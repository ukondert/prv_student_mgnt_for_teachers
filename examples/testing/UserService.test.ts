// Umfassende Testing-Pattern für Agent-optimierte Entwicklung

import { describe, it, expect, beforeEach, afterEach, jest } from '@jest/globals';
import { MCPClient } from '@modelcontextprotocol/client';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { UserService } from '../api/UserService';
import { UserCard } from '../components/UserCard';

/**
 * Unit Test Pattern für Services mit MCP Integration
 */
describe('UserService', () => {
  let userService: UserService;
  let mockMCPClient: jest.Mocked<MCPClient>;

  beforeEach(() => {
    // MCP Client Mock
    mockMCPClient = {
      call: jest.fn(),
      connect: jest.fn(),
      disconnect: jest.fn()
    } as any;

    userService = new UserService(mockMCPClient);
  });

  describe('getUsers', () => {
    it('should return paginated users from database', async () => {
      // Arrange
      const mockUsers = [
        { id: '1', email: 'test@example.com', name: 'Test User', role: 'user', created_at: new Date() },
        { id: '2', email: 'admin@example.com', name: 'Admin User', role: 'admin', created_at: new Date() }
      ];
      const mockCount = [{ total: '2' }];

      mockMCPClient.call
        .mockResolvedValueOnce(mockUsers) // Users query
        .mockResolvedValueOnce(mockCount); // Count query

      // Act
      const result = await userService.getUsers({ page: 1, limit: 10 });

      // Assert
      expect(result.data).toHaveLength(2);
      expect(result.pagination.total).toBe(2);
      expect(mockMCPClient.call).toHaveBeenCalledTimes(2);
      expect(mockMCPClient.call).toHaveBeenCalledWith('postgres', 'query', expect.objectContaining({
        sql: expect.stringContaining('SELECT u.*, p.bio, p.avatar_url'),
        params: [10, 0]
      }));
    });

    it('should handle database errors gracefully', async () => {
      // Arrange
      mockMCPClient.call.mockRejectedValue(new Error('Database connection failed'));

      // Act & Assert
      await expect(userService.getUsers()).rejects.toThrow('Could not retrieve users');
    });

    it('should use cache when available', async () => {
      // Cache würde hier gemockt werden
      // Implementation abhängig von Cache-Provider
    });
  });

  describe('createUser', () => {
    it('should create new user successfully', async () => {
      // Arrange
      const newUserData = {
        email: 'new@example.com',
        name: 'New User',
        role: 'user'
      };

      const mockCreatedUser = {
        id: '3',
        ...newUserData,
        created_at: new Date(),
        updated_at: new Date()
      };

      mockMCPClient.call
        .mockResolvedValueOnce([]) // Email check
        .mockResolvedValueOnce([mockCreatedUser]); // Insert

      // Act
      const result = await userService.createUser(newUserData);

      // Assert
      expect(result.id).toBe('3');
      expect(result.email).toBe(newUserData.email);
      expect(mockMCPClient.call).toHaveBeenCalledWith('postgres', 'query', expect.objectContaining({
        sql: expect.stringContaining('INSERT INTO users'),
        params: [newUserData.email, newUserData.name, newUserData.role]
      }));
    });

    it('should reject duplicate email addresses', async () => {
      // Arrange
      const duplicateUserData = {
        email: 'existing@example.com',
        name: 'Duplicate User'
      };

      mockMCPClient.call.mockResolvedValueOnce([{ id: '1', email: 'existing@example.com' }]);

      // Act & Assert
      await expect(userService.createUser(duplicateUserData)).rejects.toThrow('Email already exists');
    });
  });
});

/**
 * Integration Test Pattern für API Endpoints
 */
describe('User API Integration', () => {
  let app: any; // Express app oder Test-Server
  let request: any; // Supertest oder ähnliches

  beforeEach(async () => {
    // Test-Database Setup
    await setupTestDatabase();
    
    // Test-Server starten
    app = await createTestApp();
    request = supertest(app);
  });

  afterEach(async () => {
    // Test-Database cleanup
    await cleanupTestDatabase();
  });

  describe('GET /api/users', () => {
    it('should return list of users', async () => {
      // Arrange - Test-Daten einfügen
      await insertTestUsers([
        { email: 'test1@example.com', name: 'Test User 1' },
        { email: 'test2@example.com', name: 'Test User 2' }
      ]);

      // Act
      const response = await request
        .get('/api/users')
        .expect(200);

      // Assert
      expect(response.body.data).toHaveLength(2);
      expect(response.body.pagination.total).toBe(2);
    });

    it('should support pagination parameters', async () => {
      // Arrange
      await insertTestUsers(Array.from({ length: 25 }, (_, i) => ({
        email: `test${i}@example.com`,
        name: `Test User ${i}`
      })));

      // Act
      const response = await request
        .get('/api/users?page=2&limit=10')
        .expect(200);

      // Assert
      expect(response.body.data).toHaveLength(10);
      expect(response.body.pagination.page).toBe(2);
      expect(response.body.pagination.total).toBe(25);
    });
  });

  describe('POST /api/users', () => {
    it('should create new user', async () => {
      // Arrange
      const newUser = {
        email: 'new@example.com',
        name: 'New User',
        role: 'user'
      };

      // Act
      const response = await request
        .post('/api/users')
        .send(newUser)
        .expect(201);

      // Assert
      expect(response.body.email).toBe(newUser.email);
      expect(response.body.id).toBeDefined();
      
      // Verify in database
      const dbUser = await getUserFromDatabase(response.body.id);
      expect(dbUser).toBeTruthy();
    });

    it('should validate required fields', async () => {
      // Act
      const response = await request
        .post('/api/users')
        .send({ email: 'incomplete@example.com' }) // Missing name
        .expect(400);

      // Assert
      expect(response.body.error).toContain('Missing required fields');
    });
  });
});

/**
 * Component Test Pattern für React Components
 */
describe('UserCard Component', () => {
  const mockUser = {
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
    role: 'user',
    bio: 'Test user bio',
    avatar: 'https://example.com/avatar.jpg',
    createdAt: new Date('2024-01-01'),
    updatedAt: new Date('2024-01-01')
  };

  it('should render user information correctly', () => {
    // Act
    render(<UserCard user={mockUser} />);

    // Assert
    expect(screen.getByText('Test User')).toBeInTheDocument();
    expect(screen.getByText('test@example.com')).toBeInTheDocument();
    expect(screen.getByText('Test user bio')).toBeInTheDocument();
    expect(screen.getByRole('img')).toHaveAttribute('src', mockUser.avatar);
  });

  it('should handle missing optional fields gracefully', () => {
    // Arrange
    const userWithoutOptionalFields = {
      ...mockUser,
      bio: undefined,
      avatar: undefined
    };

    // Act
    render(<UserCard user={userWithoutOptionalFields} />);

    // Assert
    expect(screen.getByText('Test User')).toBeInTheDocument();
    expect(screen.queryByText('Test user bio')).not.toBeInTheDocument();
    expect(screen.getByTestId('default-avatar')).toBeInTheDocument();
  });

  it('should call onEdit when edit button is clicked', () => {
    // Arrange
    const mockOnEdit = jest.fn();
    render(<UserCard user={mockUser} onEdit={mockOnEdit} />);

    // Act
    fireEvent.click(screen.getByTestId('edit-button'));

    // Assert
    expect(mockOnEdit).toHaveBeenCalledWith(mockUser.id);
  });

  it('should show loading state during operations', async () => {
    // Arrange
    const mockOnEdit = jest.fn().mockImplementation(() => new Promise(resolve => setTimeout(resolve, 1000)));
    render(<UserCard user={mockUser} onEdit={mockOnEdit} />);

    // Act
    fireEvent.click(screen.getByTestId('edit-button'));

    // Assert
    expect(screen.getByText('Loading...')).toBeInTheDocument();
    
    // Wait for operation to complete
    await waitFor(() => {
      expect(screen.queryByText('Loading...')).not.toBeInTheDocument();
    });
  });
});

/**
 * E2E Test Pattern mit Playwright/Cypress
 */
describe('User Management E2E', () => {
  beforeEach(async () => {
    // Browser setup
    await page.goto('/users');
  });

  it('should allow user creation flow', async () => {
    // Navigate to create user page
    await page.click('[data-testid="create-user-button"]');
    
    // Fill form
    await page.fill('[data-testid="email-input"]', 'e2e@example.com');
    await page.fill('[data-testid="name-input"]', 'E2E Test User');
    await page.selectOption('[data-testid="role-select"]', 'user');
    
    // Submit form
    await page.click('[data-testid="submit-button"]');
    
    // Verify success
    await expect(page.locator('[data-testid="success-message"]')).toBeVisible();
    await expect(page.locator('text=E2E Test User')).toBeVisible();
  });

  it('should handle validation errors', async () => {
    // Navigate to create user page
    await page.click('[data-testid="create-user-button"]');
    
    // Submit empty form
    await page.click('[data-testid="submit-button"]');
    
    // Verify validation errors
    await expect(page.locator('[data-testid="email-error"]')).toBeVisible();
    await expect(page.locator('[data-testid="name-error"]')).toBeVisible();
  });
});

/**
 * Performance Test Pattern
 */
describe('Performance Tests', () => {
  it('should handle large user lists efficiently', async () => {
    // Arrange - Create many test users
    const startTime = Date.now();
    
    // Act - Load user list
    const response = await request.get('/api/users?limit=1000');
    
    const endTime = Date.now();
    const responseTime = endTime - startTime;
    
    // Assert
    expect(response.status).toBe(200);
    expect(responseTime).toBeLessThan(1000); // Should respond within 1 second
  });

  it('should handle concurrent requests', async () => {
    // Arrange
    const concurrentRequests = Array.from({ length: 10 }, () => 
      request.get('/api/users')
    );

    // Act
    const startTime = Date.now();
    const responses = await Promise.all(concurrentRequests);
    const endTime = Date.now();

    // Assert
    responses.forEach(response => {
      expect(response.status).toBe(200);
    });
    expect(endTime - startTime).toBeLessThan(2000); // All requests within 2 seconds
  });
});

/**
 * Security Test Pattern
 */
describe('Security Tests', () => {
  it('should require authentication for protected endpoints', async () => {
    // Act
    const response = await request
      .post('/api/users')
      .send({ email: 'test@example.com', name: 'Test' });

    // Assert
    expect(response.status).toBe(401);
  });

  it('should prevent SQL injection', async () => {
    // Arrange
    const maliciousInput = "'; DROP TABLE users; --";

    // Act
    const response = await request
      .get(`/api/users/search?q=${encodeURIComponent(maliciousInput)}`);

    // Assert
    expect(response.status).toBe(200); // Should not crash
    // Database should still exist
    const usersResponse = await request.get('/api/users');
    expect(usersResponse.status).toBe(200);
  });
});

// Test Utilities
async function setupTestDatabase(): Promise<void> {
  // Database setup logic
}

async function cleanupTestDatabase(): Promise<void> {
  // Database cleanup logic
}

async function insertTestUsers(users: any[]): Promise<void> {
  // Insert test data
}

async function getUserFromDatabase(id: string): Promise<any> {
  // Retrieve user from database
}

function createTestApp(): any {
  // Create test application instance
}

/**
 * Test Data Factories
 */
export const UserFactory = {
  build: (overrides: Partial<any> = {}) => ({
    id: Math.random().toString(36),
    email: `test-${Date.now()}@example.com`,
    name: `Test User ${Date.now()}`,
    role: 'user',
    createdAt: new Date(),
    updatedAt: new Date(),
    ...overrides
  }),

  buildList: (count: number, overrides: Partial<any> = {}) =>
    Array.from({ length: count }, () => UserFactory.build(overrides))
};

/**
 * Custom Test Matchers
 */
expect.extend({
  toBeValidUser(received) {
    const pass = 
      typeof received.id === 'string' &&
      typeof received.email === 'string' &&
      typeof received.name === 'string' &&
      received.email.includes('@');

    return {
      message: () => pass 
        ? `Expected ${received} not to be a valid user`
        : `Expected ${received} to be a valid user`,
      pass
    };
  }
});
