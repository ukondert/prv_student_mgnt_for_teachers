// API Service Pattern mit MCP Integration

import { MCPClient } from '@modelcontextprotocol/client';
import { User, CreateUserDto, UpdateUserDto } from '../../types/User';
import { PaginationOptions, PaginatedResult } from '../../types/Pagination';
import { ServiceError } from '../../utils/errors';
import { logger } from '../../utils/logger';
import { cache } from '../../utils/cache';

export class UserService {
  constructor(
    private readonly mcpClient: MCPClient,
    private readonly cacheService = cache
  ) {}

  /**
   * Alle Benutzer abrufen mit Pagination
   */
  async getUsers(options: PaginationOptions = { page: 1, limit: 20 }): Promise<PaginatedResult<User>> {
    try {
      const cacheKey = `users:${JSON.stringify(options)}`;
      
      // Cache prüfen
      const cached = await this.cacheService.get<PaginatedResult<User>>(cacheKey);
      if (cached) {
        logger.debug('Users returned from cache', { options });
        return cached;
      }

      // Daten über MCP Database Server abrufen
      const offset = (options.page - 1) * options.limit;
      
      const [usersResult, countResult] = await Promise.all([
        this.mcpClient.call('postgres', 'query', {
          sql: `
            SELECT u.*, p.bio, p.avatar_url
            FROM users u
            LEFT JOIN profiles p ON u.id = p.user_id
            WHERE u.active = true
            ORDER BY u.created_at DESC
            LIMIT $1 OFFSET $2
          `,
          params: [options.limit, offset]
        }),
        this.mcpClient.call('postgres', 'query', {
          sql: 'SELECT COUNT(*) as total FROM users WHERE active = true'
        })
      ]);

      const users = usersResult.map(this.mapRowToUser);
      const total = parseInt(countResult[0].total);
      const totalPages = Math.ceil(total / options.limit);

      const result: PaginatedResult<User> = {
        data: users,
        pagination: {
          page: options.page,
          limit: options.limit,
          total,
          totalPages,
          hasNext: options.page < totalPages,
          hasPrev: options.page > 1
        }
      };

      // Ergebnis cachen
      await this.cacheService.set(cacheKey, result, 300); // 5 Minuten

      logger.info('Users retrieved successfully', { 
        count: users.length, 
        total, 
        page: options.page 
      });

      return result;
    } catch (error) {
      logger.error('Failed to retrieve users', error);
      throw new ServiceError('Could not retrieve users', 'USERS_FETCH_FAILED', error);
    }
  }

  /**
   * Einzelnen Benutzer abrufen
   */
  async getUserById(id: string): Promise<User | null> {
    try {
      const cacheKey = `user:${id}`;
      
      // Cache prüfen
      const cached = await this.cacheService.get<User>(cacheKey);
      if (cached) return cached;

      const result = await this.mcpClient.call('postgres', 'query', {
        sql: `
          SELECT u.*, p.bio, p.avatar_url
          FROM users u
          LEFT JOIN profiles p ON u.id = p.user_id
          WHERE u.id = $1 AND u.active = true
        `,
        params: [id]
      });

      if (result.length === 0) {
        return null;
      }

      const user = this.mapRowToUser(result[0]);
      
      // User cachen
      await this.cacheService.set(cacheKey, user, 600); // 10 Minuten

      return user;
    } catch (error) {
      logger.error('Failed to retrieve user', { userId: id, error });
      throw new ServiceError('Could not retrieve user', 'USER_FETCH_FAILED', error);
    }
  }

  /**
   * Neuen Benutzer erstellen
   */
  async createUser(userData: CreateUserDto): Promise<User> {
    try {
      // Validierung
      await this.validateUserData(userData);
      
      // Prüfen ob E-Mail bereits existiert
      const existingUser = await this.getUserByEmail(userData.email);
      if (existingUser) {
        throw new ServiceError('Email already exists', 'EMAIL_ALREADY_EXISTS');
      }

      // Benutzer erstellen
      const result = await this.mcpClient.call('postgres', 'query', {
        sql: `
          INSERT INTO users (email, name, role, created_at, updated_at)
          VALUES ($1, $2, $3, NOW(), NOW())
          RETURNING *
        `,
        params: [userData.email, userData.name, userData.role || 'user']
      });

      const newUser = this.mapRowToUser(result[0]);

      // Cache invalidieren
      await this.cacheService.invalidate('users:*');
      
      // Event über MCP Event Bus senden (falls verfügbar)
      try {
        await this.mcpClient.call('events', 'emit', {
          event: 'user.created',
          data: newUser
        });
      } catch (eventError) {
        // Event-Fehler nicht propagieren
        logger.warn('Failed to emit user.created event', eventError);
      }

      logger.info('User created successfully', { userId: newUser.id, email: newUser.email });

      return newUser;
    } catch (error) {
      logger.error('Failed to create user', { userData, error });
      
      if (error instanceof ServiceError) {
        throw error;
      }
      
      throw new ServiceError('Could not create user', 'USER_CREATION_FAILED', error);
    }
  }

  /**
   * Benutzer aktualisieren
   */
  async updateUser(id: string, updates: UpdateUserDto): Promise<User> {
    try {
      // Benutzer muss existieren
      const existingUser = await this.getUserById(id);
      if (!existingUser) {
        throw new ServiceError('User not found', 'USER_NOT_FOUND');
      }

      // E-Mail Eindeutigkeit prüfen (falls E-Mail geändert wird)
      if (updates.email && updates.email !== existingUser.email) {
        const emailTaken = await this.getUserByEmail(updates.email);
        if (emailTaken) {
          throw new ServiceError('Email already exists', 'EMAIL_ALREADY_EXISTS');
        }
      }

      // Update-Query erstellen
      const setClauses: string[] = [];
      const params: any[] = [];
      let paramIndex = 1;

      if (updates.email) {
        setClauses.push(`email = $${paramIndex++}`);
        params.push(updates.email);
      }
      if (updates.name) {
        setClauses.push(`name = $${paramIndex++}`);
        params.push(updates.name);
      }
      if (updates.role) {
        setClauses.push(`role = $${paramIndex++}`);
        params.push(updates.role);
      }

      setClauses.push(`updated_at = NOW()`);
      params.push(id);

      const result = await this.mcpClient.call('postgres', 'query', {
        sql: `
          UPDATE users 
          SET ${setClauses.join(', ')}
          WHERE id = $${paramIndex} AND active = true
          RETURNING *
        `,
        params
      });

      if (result.length === 0) {
        throw new ServiceError('User not found', 'USER_NOT_FOUND');
      }

      const updatedUser = this.mapRowToUser(result[0]);

      // Cache invalidieren
      await this.cacheService.invalidate(`user:${id}`);
      await this.cacheService.invalidate('users:*');

      logger.info('User updated successfully', { userId: id, updates });

      return updatedUser;
    } catch (error) {
      logger.error('Failed to update user', { userId: id, updates, error });
      
      if (error instanceof ServiceError) {
        throw error;
      }
      
      throw new ServiceError('Could not update user', 'USER_UPDATE_FAILED', error);
    }
  }

  /**
   * Benutzer deaktivieren (Soft Delete)
   */
  async deleteUser(id: string): Promise<void> {
    try {
      const user = await this.getUserById(id);
      if (!user) {
        throw new ServiceError('User not found', 'USER_NOT_FOUND');
      }

      await this.mcpClient.call('postgres', 'query', {
        sql: 'UPDATE users SET active = false, updated_at = NOW() WHERE id = $1',
        params: [id]
      });

      // Cache invalidieren
      await this.cacheService.invalidate(`user:${id}`);
      await this.cacheService.invalidate('users:*');

      logger.info('User deleted successfully', { userId: id });
    } catch (error) {
      logger.error('Failed to delete user', { userId: id, error });
      
      if (error instanceof ServiceError) {
        throw error;
      }
      
      throw new ServiceError('Could not delete user', 'USER_DELETE_FAILED', error);
    }
  }

  /**
   * Benutzer-Suche
   */
  async searchUsers(query: string, options: PaginationOptions = { page: 1, limit: 20 }): Promise<PaginatedResult<User>> {
    try {
      const searchTerm = `%${query.toLowerCase()}%`;
      const offset = (options.page - 1) * options.limit;

      const [usersResult, countResult] = await Promise.all([
        this.mcpClient.call('postgres', 'query', {
          sql: `
            SELECT u.*, p.bio, p.avatar_url
            FROM users u
            LEFT JOIN profiles p ON u.id = p.user_id
            WHERE u.active = true 
            AND (LOWER(u.name) LIKE $1 OR LOWER(u.email) LIKE $1)
            ORDER BY u.name ASC
            LIMIT $2 OFFSET $3
          `,
          params: [searchTerm, options.limit, offset]
        }),
        this.mcpClient.call('postgres', 'query', {
          sql: `
            SELECT COUNT(*) as total 
            FROM users 
            WHERE active = true 
            AND (LOWER(name) LIKE $1 OR LOWER(email) LIKE $1)
          `,
          params: [searchTerm]
        })
      ]);

      const users = usersResult.map(this.mapRowToUser);
      const total = parseInt(countResult[0].total);
      const totalPages = Math.ceil(total / options.limit);

      return {
        data: users,
        pagination: {
          page: options.page,
          limit: options.limit,
          total,
          totalPages,
          hasNext: options.page < totalPages,
          hasPrev: options.page > 1
        }
      };
    } catch (error) {
      logger.error('Failed to search users', { query, error });
      throw new ServiceError('Could not search users', 'USER_SEARCH_FAILED', error);
    }
  }

  // Private Hilfsmethoden

  private async getUserByEmail(email: string): Promise<User | null> {
    const result = await this.mcpClient.call('postgres', 'query', {
      sql: 'SELECT * FROM users WHERE email = $1 AND active = true',
      params: [email]
    });

    return result.length > 0 ? this.mapRowToUser(result[0]) : null;
  }

  private async validateUserData(userData: CreateUserDto): Promise<void> {
    // Hier könnte Zod Validation oder ähnliches verwendet werden
    if (!userData.email || !userData.name) {
      throw new ServiceError('Missing required fields', 'VALIDATION_FAILED');
    }

    if (!this.isValidEmail(userData.email)) {
      throw new ServiceError('Invalid email format', 'VALIDATION_FAILED');
    }
  }

  private isValidEmail(email: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  private mapRowToUser(row: any): User {
    return {
      id: row.id,
      email: row.email,
      name: row.name,
      role: row.role,
      bio: row.bio,
      avatar: row.avatar_url,
      createdAt: new Date(row.created_at),
      updatedAt: new Date(row.updated_at)
    };
  }
}

// Factory Function für DI
export const createUserService = (mcpClient: MCPClient) => {
  return new UserService(mcpClient);
};
