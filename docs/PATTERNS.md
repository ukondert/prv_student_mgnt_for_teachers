# Flutter Code Patterns & Best Practices

## 🏗️ Flutter Architektur-Patterns

### Clean Architecture für Flutter
```dart
// Domain Layer - Business Logic
abstract class User {
  String get id;
  String get email;
  String get name;
  String? get avatarUrl;
  DateTime get createdAt;
}

abstract class UserRepository {
  Future<User?> findById(String id);
  Future<User> create(CreateUserRequest request);
  Future<User> update(String id, UpdateUserRequest request);
  Future<void> delete(String id);
  Stream<List<User>> watchUsers();
}

// Application Layer - Use Cases
class CreateUserUseCase {
  const CreateUserUseCase(this._repository);
  
  final UserRepository _repository;

  Future<User> call(CreateUserRequest request) async {
    // Validation
    if (request.email.isEmpty) {
      throw ValidationException('Email is required');
    }
    
    // Business rules
    final existingUser = await _repository.findByEmail(request.email);
    if (existingUser != null) {
      throw BusinessException('User already exists');
    }
    
    // Create user
    return _repository.create(request);
  }
}

// Infrastructure Layer - Data Sources
class FirebaseUserRepository implements UserRepository {
  const FirebaseUserRepository(this._firestore);
  
  final FirebaseFirestore _firestore;

  @override
  Future<User?> findById(String id) async {
    final doc = await _firestore.collection('users').doc(id).get();
    if (!doc.exists) return null;
    
    return UserModel.fromFirestore(doc);
  }

  @override
  Stream<List<User>> watchUsers() {
    return _firestore
        .collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromFirestore(doc))
            .toList());
  }
}
```

### Repository Pattern mit MCP Integration
```typescript
export class MCPUserRepository implements UserRepository {
  constructor(private readonly mcpClient: MCPClient) {}

  async findById(id: string): Promise<User | null> {
    const result = await this.mcpClient.call('database', 'query', {
      sql: 'SELECT * FROM users WHERE id = ?',
      params: [id]
    });
    
    return result.length > 0 ? this.mapToUser(result[0]) : null;
  }

  private mapToUser(row: any): User {
    return {
      id: row.id,
      email: row.email,
      name: row.name,
      createdAt: new Date(row.created_at)
    };
  }
}
```

## 🔧 Service Patterns

### Error Handling Pattern
```typescript
export class ServiceError extends Error {
  constructor(
    message: string,
    public readonly code: string,
    public readonly cause?: Error
  ) {
    super(message);
    this.name = 'ServiceError';
  }
}

export class UserService {
  async createUser(userData: CreateUserDto): Promise<User> {
    try {
      await this.validateUserData(userData);
      return await this.userRepository.create(userData);
    } catch (error) {
      if (error instanceof ValidationError) {
        throw new ServiceError(
          'Invalid user data',
          'VALIDATION_FAILED',
          error
        );
      }
      
      this.logger.error('Unexpected error creating user', error);
      throw new ServiceError(
        'Failed to create user',
        'CREATION_FAILED',
        error as Error
      );
    }
  }
}
```

### Validation Pattern
```typescript
import { z } from 'zod';

export const CreateUserSchema = z.object({
  email: z.string().email('Invalid email format'),
  name: z.string().min(2, 'Name must be at least 2 characters'),
  age: z.number().min(18, 'Must be at least 18 years old')
});

export type CreateUserDto = z.infer<typeof CreateUserSchema>;

export class UserService {
  private async validateUserData(userData: unknown): Promise<CreateUserDto> {
    const result = CreateUserSchema.safeParse(userData);
    
    if (!result.success) {
      throw new ValidationError('Invalid user data', result.error.issues);
    }
    
    return result.data;
  }
}
```

## 🎨 Frontend Patterns

### React Component Pattern
```tsx
interface UserCardProps {
  user: User;
  onEdit?: (user: User) => void;
  onDelete?: (userId: string) => void;
  className?: string;
}

export const UserCard: React.FC<UserCardProps> = ({
  user,
  onEdit,
  onDelete,
  className
}) => {
  const handleEdit = useCallback(() => {
    onEdit?.(user);
  }, [user, onEdit]);

  const handleDelete = useCallback(() => {
    onDelete?.(user.id);
  }, [user.id, onDelete]);

  return (
    <div className={cn('user-card', className)}>
      <div className="user-card__header">
        <h3>{user.name}</h3>
        <span className="user-card__email">{user.email}</span>
      </div>
      
      <div className="user-card__actions">
        {onEdit && (
          <Button variant="outline" onClick={handleEdit}>
            Edit
          </Button>
        )}
        {onDelete && (
          <Button variant="destructive" onClick={handleDelete}>
            Delete
          </Button>
        )}
      </div>
    </div>
  );
};
```

### Custom Hook Pattern
```tsx
export function useUsers() {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchUsers = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);
      const response = await userService.getUsers();
      setUsers(response);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error');
    } finally {
      setLoading(false);
    }
  }, []);

  const createUser = useCallback(async (userData: CreateUserDto) => {
    const newUser = await userService.createUser(userData);
    setUsers(prev => [...prev, newUser]);
    return newUser;
  }, []);

  useEffect(() => {
    fetchUsers();
  }, [fetchUsers]);

  return {
    users,
    loading,
    error,
    refetch: fetchUsers,
    createUser
  };
}
```

## 🧪 Testing Patterns

### Unit Test Pattern
```typescript
describe('UserService', () => {
  let userService: UserService;
  let mockRepository: jest.Mocked<UserRepository>;
  let mockEventBus: jest.Mocked<EventBus>;
  let mockLogger: jest.Mocked<Logger>;

  beforeEach(() => {
    mockRepository = createMockRepository();
    mockEventBus = createMockEventBus();
    mockLogger = createMockLogger();
    
    userService = new UserService(
      mockRepository,
      mockEventBus,
      mockLogger
    );
  });

  describe('createUser', () => {
    it('should create user successfully', async () => {
      // Arrange
      const userData = {
        email: 'test@example.com',
        name: 'Test User'
      };
      const expectedUser = {
        id: '123',
        ...userData,
        createdAt: new Date()
      };

      mockRepository.create.mockResolvedValue(expectedUser);

      // Act
      const result = await userService.createUser(userData);

      // Assert
      expect(result).toEqual(expectedUser);
      expect(mockRepository.create).toHaveBeenCalledWith(userData);
      expect(mockEventBus.emit).toHaveBeenCalledWith('user.created', expectedUser);
    });

    it('should throw ServiceError on validation failure', async () => {
      // Arrange
      const invalidUserData = { email: 'invalid-email' };

      // Act & Assert
      await expect(userService.createUser(invalidUserData))
        .rejects
        .toThrow(ServiceError);
    });
  });
});
```

### Integration Test Pattern
```typescript
describe('User API Integration', () => {
  let app: Application;
  let testDatabase: TestDatabase;

  beforeAll(async () => {
    testDatabase = await createTestDatabase();
    app = createTestApp({ database: testDatabase });
  });

  afterAll(async () => {
    await testDatabase.close();
  });

  beforeEach(async () => {
    await testDatabase.reset();
  });

  it('should create and retrieve user', async () => {
    // Create user
    const userData = {
      email: 'test@example.com',
      name: 'Test User'
    };

    const createResponse = await request(app)
      .post('/api/users')
      .send(userData)
      .expect(201);

    const createdUser = createResponse.body;
    expect(createdUser).toMatchObject(userData);

    // Retrieve user
    const getResponse = await request(app)
      .get(`/api/users/${createdUser.id}`)
      .expect(200);

    expect(getResponse.body).toEqual(createdUser);
  });
});
```

## 🔄 State Management Patterns

### Redux Pattern (RTK)
```typescript
// User Slice
export const userSlice = createSlice({
  name: 'users',
  initialState: {
    entities: {} as Record<string, User>,
    ids: [] as string[],
    loading: false,
    error: null as string | null
  },
  reducers: {
    setLoading: (state, action) => {
      state.loading = action.payload;
    },
    setError: (state, action) => {
      state.error = action.payload;
    }
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchUsers.fulfilled, (state, action) => {
        state.entities = keyBy(action.payload, 'id');
        state.ids = action.payload.map(user => user.id);
        state.loading = false;
      })
      .addCase(createUser.fulfilled, (state, action) => {
        const user = action.payload;
        state.entities[user.id] = user;
        state.ids.push(user.id);
      });
  }
});

// Async Thunks
export const fetchUsers = createAsyncThunk(
  'users/fetchUsers',
  async (_, { rejectWithValue }) => {
    try {
      return await userService.getUsers();
    } catch (error) {
      return rejectWithValue(error.message);
    }
  }
);
```

## 🔒 Security Patterns

### Authentication Pattern
```typescript
export class JWTAuthService {
  constructor(
    private readonly secretKey: string,
    private readonly userService: UserService
  ) {}

  async authenticate(token: string): Promise<User | null> {
    try {
      const payload = jwt.verify(token, this.secretKey) as JWTPayload;
      return await this.userService.findById(payload.userId);
    } catch (error) {
      return null;
    }
  }

  generateToken(user: User): string {
    return jwt.sign(
      { userId: user.id, email: user.email },
      this.secretKey,
      { expiresIn: '24h' }
    );
  }
}

// Middleware
export const authenticateRequest = async (req: Request, res: Response, next: NextFunction) => {
  const token = extractTokenFromHeader(req.headers.authorization);
  
  if (!token) {
    return res.status(401).json({ error: 'Authentication required' });
  }

  const user = await authService.authenticate(token);
  
  if (!user) {
    return res.status(401).json({ error: 'Invalid token' });
  }

  req.user = user;
  next();
};
```

### Input Sanitization Pattern
```typescript
import DOMPurify from 'dompurify';
import { escape } from 'lodash';

export class SanitizationService {
  static sanitizeHtml(input: string): string {
    return DOMPurify.sanitize(input, {
      ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'p', 'br'],
      ALLOWED_ATTR: []
    });
  }

  static escapeHtml(input: string): string {
    return escape(input);
  }

  static sanitizeFilename(filename: string): string {
    return filename
      .replace(/[^a-zA-Z0-9._-]/g, '')
      .substring(0, 255);
  }
}
```

## 📊 Performance Patterns

### Caching Pattern
```typescript
export class CacheService {
  private cache = new Map<string, { value: any; expiry: number }>();

  set(key: string, value: any, ttlSeconds: number = 300): void {
    const expiry = Date.now() + ttlSeconds * 1000;
    this.cache.set(key, { value, expiry });
  }

  get<T>(key: string): T | null {
    const entry = this.cache.get(key);
    
    if (!entry) return null;
    
    if (Date.now() > entry.expiry) {
      this.cache.delete(key);
      return null;
    }
    
    return entry.value as T;
  }

  invalidate(pattern: string): void {
    const regex = new RegExp(pattern);
    for (const key of this.cache.keys()) {
      if (regex.test(key)) {
        this.cache.delete(key);
      }
    }
  }
}

// Usage with Service
export class UserService {
  async getUser(id: string): Promise<User | null> {
    const cacheKey = `user:${id}`;
    
    // Try cache first
    const cached = this.cache.get<User>(cacheKey);
    if (cached) return cached;
    
    // Fetch from database
    const user = await this.userRepository.findById(id);
    
    // Cache result
    if (user) {
      this.cache.set(cacheKey, user, 300); // 5 minutes
    }
    
    return user;
  }
}
```

### Pagination Pattern
```typescript
export interface PaginationOptions {
  page: number;
  limit: number;
  sortBy?: string;
  sortOrder?: 'asc' | 'desc';
}

export interface PaginatedResult<T> {
  data: T[];
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
    hasNext: boolean;
    hasPrev: boolean;
  };
}

export class UserService {
  async getUsers(options: PaginationOptions): Promise<PaginatedResult<User>> {
    const offset = (options.page - 1) * options.limit;
    
    const [users, total] = await Promise.all([
      this.userRepository.findMany({
        offset,
        limit: options.limit,
        sortBy: options.sortBy,
        sortOrder: options.sortOrder
      }),
      this.userRepository.count()
    ]);

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
  }
}
```

---

**Hinweis**: Diese Patterns sind Richtlinien. Passen Sie sie an Ihre spezifischen Anforderungen an und halten Sie sie konsistent im gesamten Projekt.
