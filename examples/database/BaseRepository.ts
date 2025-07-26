// Erweiterte Datenbank-Pattern mit MCP Integration

import { MCPClient } from '@modelcontextprotocol/client';
import { Pool } from 'pg';
import { logger } from '../../utils/logger';
import { ServiceError } from '../../utils/errors';

/**
 * Repository Pattern mit MCP Database Server Integration
 */
export abstract class BaseRepository<T, TCreate, TUpdate> {
  constructor(
    protected readonly mcpClient: MCPClient,
    protected readonly tableName: string
  ) {}

  /**
   * Alle Datensätze abrufen
   */
  async findAll(conditions: Record<string, any> = {}): Promise<T[]> {
    try {
      const { whereClause, params } = this.buildWhereClause(conditions);
      
      const result = await this.mcpClient.call('postgres', 'query', {
        sql: `SELECT * FROM ${this.tableName} ${whereClause}`,
        params
      });

      return result.map(this.mapRowToEntity);
    } catch (error) {
      logger.error(`Failed to find all ${this.tableName}`, error);
      throw new ServiceError(`Could not retrieve ${this.tableName}`, 'FETCH_FAILED', error);
    }
  }

  /**
   * Einzelnen Datensatz finden
   */
  async findById(id: string): Promise<T | null> {
    try {
      const result = await this.mcpClient.call('postgres', 'query', {
        sql: `SELECT * FROM ${this.tableName} WHERE id = $1`,
        params: [id]
      });

      return result.length > 0 ? this.mapRowToEntity(result[0]) : null;
    } catch (error) {
      logger.error(`Failed to find ${this.tableName} by id`, { id, error });
      throw new ServiceError(`Could not retrieve ${this.tableName}`, 'FETCH_FAILED', error);
    }
  }

  /**
   * Neuen Datensatz erstellen
   */
  async create(data: TCreate): Promise<T> {
    try {
      const { columns, placeholders, values } = this.buildInsertClause(data);
      
      const result = await this.mcpClient.call('postgres', 'query', {
        sql: `
          INSERT INTO ${this.tableName} (${columns}, created_at, updated_at)
          VALUES (${placeholders}, NOW(), NOW())
          RETURNING *
        `,
        params: values
      });

      return this.mapRowToEntity(result[0]);
    } catch (error) {
      logger.error(`Failed to create ${this.tableName}`, { data, error });
      throw new ServiceError(`Could not create ${this.tableName}`, 'CREATE_FAILED', error);
    }
  }

  /**
   * Datensatz aktualisieren
   */
  async update(id: string, data: TUpdate): Promise<T | null> {
    try {
      const { setClause, params } = this.buildUpdateClause(data);
      
      const result = await this.mcpClient.call('postgres', 'query', {
        sql: `
          UPDATE ${this.tableName} 
          SET ${setClause}, updated_at = NOW()
          WHERE id = $${params.length + 1}
          RETURNING *
        `,
        params: [...params, id]
      });

      return result.length > 0 ? this.mapRowToEntity(result[0]) : null;
    } catch (error) {
      logger.error(`Failed to update ${this.tableName}`, { id, data, error });
      throw new ServiceError(`Could not update ${this.tableName}`, 'UPDATE_FAILED', error);
    }
  }

  /**
   * Datensatz löschen
   */
  async delete(id: string): Promise<boolean> {
    try {
      const result = await this.mcpClient.call('postgres', 'query', {
        sql: `DELETE FROM ${this.tableName} WHERE id = $1`,
        params: [id]
      });

      return result.rowCount > 0;
    } catch (error) {
      logger.error(`Failed to delete ${this.tableName}`, { id, error });
      throw new ServiceError(`Could not delete ${this.tableName}`, 'DELETE_FAILED', error);
    }
  }

  /**
   * Soft Delete (falls active-Spalte vorhanden)
   */
  async softDelete(id: string): Promise<boolean> {
    try {
      const result = await this.mcpClient.call('postgres', 'query', {
        sql: `UPDATE ${this.tableName} SET active = false, updated_at = NOW() WHERE id = $1`,
        params: [id]
      });

      return result.rowCount > 0;
    } catch (error) {
      logger.error(`Failed to soft delete ${this.tableName}`, { id, error });
      throw new ServiceError(`Could not delete ${this.tableName}`, 'DELETE_FAILED', error);
    }
  }

  /**
   * Bulk-Operationen
   */
  async bulkCreate(items: TCreate[]): Promise<T[]> {
    try {
      // Transaction verwenden
      await this.mcpClient.call('postgres', 'begin');
      
      const created: T[] = [];
      
      for (const item of items) {
        const result = await this.create(item);
        created.push(result);
      }

      await this.mcpClient.call('postgres', 'commit');
      
      return created;
    } catch (error) {
      await this.mcpClient.call('postgres', 'rollback');
      logger.error(`Failed to bulk create ${this.tableName}`, { count: items.length, error });
      throw new ServiceError(`Could not bulk create ${this.tableName}`, 'BULK_CREATE_FAILED', error);
    }
  }

  // Abstract Methods - müssen in abgeleiteten Klassen implementiert werden
  protected abstract mapRowToEntity(row: any): T;

  // Private Hilfsmethoden
  private buildWhereClause(conditions: Record<string, any>): { whereClause: string; params: any[] } {
    if (Object.keys(conditions).length === 0) {
      return { whereClause: '', params: [] };
    }

    const clauses: string[] = [];
    const params: any[] = [];
    let paramIndex = 1;

    for (const [key, value] of Object.entries(conditions)) {
      if (value !== undefined && value !== null) {
        clauses.push(`${key} = $${paramIndex++}`);
        params.push(value);
      }
    }

    return {
      whereClause: clauses.length > 0 ? `WHERE ${clauses.join(' AND ')}` : '',
      params
    };
  }

  private buildInsertClause(data: any): { columns: string; placeholders: string; values: any[] } {
    const entries = Object.entries(data).filter(([_, value]) => value !== undefined);
    const columns = entries.map(([key]) => key).join(', ');
    const placeholders = entries.map((_, index) => `$${index + 1}`).join(', ');
    const values = entries.map(([_, value]) => value);

    return { columns, placeholders, values };
  }

  private buildUpdateClause(data: any): { setClause: string; params: any[] } {
    const entries = Object.entries(data).filter(([_, value]) => value !== undefined);
    const setClauses = entries.map(([key], index) => `${key} = $${index + 1}`);
    const params = entries.map(([_, value]) => value);

    return { setClause: setClauses.join(', '), params };
  }
}

/**
 * Migration und Schema Management
 */
export class DatabaseMigrationService {
  constructor(private readonly mcpClient: MCPClient) {}

  /**
   * Migration ausführen
   */
  async runMigration(migrationSql: string, version: string): Promise<void> {
    try {
      // Prüfen ob Migration bereits ausgeführt wurde
      const existingMigration = await this.mcpClient.call('postgres', 'query', {
        sql: 'SELECT * FROM migrations WHERE version = $1',
        params: [version]
      });

      if (existingMigration.length > 0) {
        logger.info('Migration already applied', { version });
        return;
      }

      // Migration in Transaction ausführen
      await this.mcpClient.call('postgres', 'begin');

      // Migration SQL ausführen
      await this.mcpClient.call('postgres', 'query', { sql: migrationSql });

      // Migration in Tabelle eintragen
      await this.mcpClient.call('postgres', 'query', {
        sql: 'INSERT INTO migrations (version, applied_at) VALUES ($1, NOW())',
        params: [version]
      });

      await this.mcpClient.call('postgres', 'commit');

      logger.info('Migration applied successfully', { version });
    } catch (error) {
      await this.mcpClient.call('postgres', 'rollback');
      logger.error('Migration failed', { version, error });
      throw new ServiceError('Migration failed', 'MIGRATION_FAILED', error);
    }
  }

  /**
   * Migrations-Tabelle erstellen
   */
  async createMigrationsTable(): Promise<void> {
    const sql = `
      CREATE TABLE IF NOT EXISTS migrations (
        id SERIAL PRIMARY KEY,
        version VARCHAR(255) UNIQUE NOT NULL,
        applied_at TIMESTAMP DEFAULT NOW()
      )
    `;

    await this.mcpClient.call('postgres', 'query', { sql });
  }

  /**
   * Alle angewandten Migrationen abrufen
   */
  async getAppliedMigrations(): Promise<string[]> {
    const result = await this.mcpClient.call('postgres', 'query', {
      sql: 'SELECT version FROM migrations ORDER BY applied_at ASC'
    });

    return result.map(row => row.version);
  }
}

/**
 * Connection Pool Management
 */
export class DatabaseConnectionManager {
  private pool: Pool | null = null;

  constructor(
    private readonly connectionConfig: {
      host: string;
      port: number;
      database: string;
      user: string;
      password: string;
      max?: number;
      idleTimeoutMillis?: number;
    }
  ) {}

  /**
   * Connection Pool initialisieren
   */
  async initialize(): Promise<void> {
    try {
      this.pool = new Pool({
        ...this.connectionConfig,
        max: this.connectionConfig.max || 20,
        idleTimeoutMillis: this.connectionConfig.idleTimeoutMillis || 30000
      });

      // Connection testen
      const client = await this.pool.connect();
      await client.query('SELECT NOW()');
      client.release();

      logger.info('Database connection pool initialized');
    } catch (error) {
      logger.error('Failed to initialize database connection pool', error);
      throw new ServiceError('Database connection failed', 'CONNECTION_FAILED', error);
    }
  }

  /**
   * Pool schließen
   */
  async close(): Promise<void> {
    if (this.pool) {
      await this.pool.end();
      this.pool = null;
      logger.info('Database connection pool closed');
    }
  }

  /**
   * Pool-Status abrufen
   */
  getPoolStatus(): {
    totalCount: number;
    idleCount: number;
    waitingCount: number;
  } {
    if (!this.pool) {
      return { totalCount: 0, idleCount: 0, waitingCount: 0 };
    }

    return {
      totalCount: this.pool.totalCount,
      idleCount: this.pool.idleCount,
      waitingCount: this.pool.waitingCount
    };
  }
}

/**
 * Query Builder für komplexe Abfragen
 */
export class QueryBuilder {
  private selectFields: string[] = ['*'];
  private fromTable = '';
  private joinClauses: string[] = [];
  private whereClauses: string[] = [];
  private orderByClauses: string[] = [];
  private limitValue?: number;
  private offsetValue?: number;
  private params: any[] = [];
  private paramIndex = 1;

  select(fields: string[]): QueryBuilder {
    this.selectFields = fields;
    return this;
  }

  from(table: string): QueryBuilder {
    this.fromTable = table;
    return this;
  }

  join(table: string, condition: string): QueryBuilder {
    this.joinClauses.push(`INNER JOIN ${table} ON ${condition}`);
    return this;
  }

  leftJoin(table: string, condition: string): QueryBuilder {
    this.joinClauses.push(`LEFT JOIN ${table} ON ${condition}`);
    return this;
  }

  where(condition: string, value?: any): QueryBuilder {
    if (value !== undefined) {
      const placeholder = `$${this.paramIndex++}`;
      this.whereClauses.push(condition.replace('?', placeholder));
      this.params.push(value);
    } else {
      this.whereClauses.push(condition);
    }
    return this;
  }

  orderBy(field: string, direction: 'ASC' | 'DESC' = 'ASC'): QueryBuilder {
    this.orderByClauses.push(`${field} ${direction}`);
    return this;
  }

  limit(count: number): QueryBuilder {
    this.limitValue = count;
    return this;
  }

  offset(count: number): QueryBuilder {
    this.offsetValue = count;
    return this;
  }

  build(): { sql: string; params: any[] } {
    let sql = `SELECT ${this.selectFields.join(', ')} FROM ${this.fromTable}`;

    if (this.joinClauses.length > 0) {
      sql += ` ${this.joinClauses.join(' ')}`;
    }

    if (this.whereClauses.length > 0) {
      sql += ` WHERE ${this.whereClauses.join(' AND ')}`;
    }

    if (this.orderByClauses.length > 0) {
      sql += ` ORDER BY ${this.orderByClauses.join(', ')}`;
    }

    if (this.limitValue) {
      sql += ` LIMIT ${this.limitValue}`;
    }

    if (this.offsetValue) {
      sql += ` OFFSET ${this.offsetValue}`;
    }

    return { sql, params: this.params };
  }
}

// Utility Functions
export const createQueryBuilder = () => new QueryBuilder();
