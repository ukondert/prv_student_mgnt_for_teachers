// Flutter API Client - Moderne HTTP Client Implementation
// Zeigt Best Practices für API Integration mit Error Handling

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

/// HTTP Response Model
@immutable
class HttpResponse {
  const HttpResponse({
    required this.statusCode,
    required this.body,
    required this.headers,
  });

  final int statusCode;
  final String body;
  final Map<String, String> headers;

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
  bool get isClientError => statusCode >= 400 && statusCode < 500;
  bool get isServerError => statusCode >= 500;
}

/// API Client Configuration
@immutable
class ApiConfig {
  const ApiConfig({
    required this.baseUrl,
    this.timeout = const Duration(seconds: 30),
    this.retryAttempts = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.defaultHeaders = const {},
  });

  final String baseUrl;
  final Duration timeout;
  final int retryAttempts;
  final Duration retryDelay;
  final Map<String, String> defaultHeaders;
}

/// Sealed class für API Results - Type-safe Error Handling
sealed class ApiResult<T> {
  const ApiResult();
}

final class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data, {this.statusCode = 200});
  final T data;
  final int statusCode;
}

final class ApiFailure<T> extends ApiResult<T> {
  const ApiFailure(this.error, {this.statusCode});
  final String error;
  final int? statusCode;
}

/// Request/Response Interceptors
abstract interface class ApiInterceptor {
  Future<Map<String, String>> onRequest(String url, Map<String, String> headers);
  Future<HttpResponse> onResponse(HttpResponse response);
  Future<String> onError(String error, int? statusCode);
}

/// Authentication Interceptor
class AuthInterceptor implements ApiInterceptor {
  AuthInterceptor({required this.tokenProvider});

  final Future<String?> Function() tokenProvider;

  @override
  Future<Map<String, String>> onRequest(String url, Map<String, String> headers) async {
    final token = await tokenProvider();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  @override
  Future<HttpResponse> onResponse(HttpResponse response) async {
    return response;
  }

  @override
  Future<String> onError(String error, int? statusCode) async {
    if (statusCode == 401) {
      return 'Authentication failed. Please login again.';
    }
    return error;
  }
}

/// Logging Interceptor
class LoggingInterceptor implements ApiInterceptor {
  @override
  Future<Map<String, String>> onRequest(String url, Map<String, String> headers) async {
    if (kDebugMode) {
      debugPrint('🌐 API Request: $url');
      debugPrint('📋 Headers: $headers');
    }
    return headers;
  }

  @override
  Future<HttpResponse> onResponse(HttpResponse response) async {
    if (kDebugMode) {
      debugPrint('✅ API Response: ${response.statusCode}');
      if (response.body.length < 1000) {
        debugPrint('📄 Body: ${response.body}');
      }
    }
    return response;
  }

  @override
  Future<String> onError(String error, int? statusCode) async {
    if (kDebugMode) {
      debugPrint('❌ API Error ($statusCode): $error');
    }
    return error;
  }
}

/// Einfacher HTTP Client für interne Nutzung
class SimpleHttpClient {
  SimpleHttpClient() : _client = HttpClient();

  final HttpClient _client;

  Future<HttpResponse> get(String url, {Map<String, String>? headers}) async {
    final request = await _client.getUrl(Uri.parse(url));
    _addHeaders(request, headers);
    final response = await request.close();
    return _processResponse(response);
  }

  Future<HttpResponse> post(String url, {Map<String, String>? headers, String? body}) async {
    final request = await _client.postUrl(Uri.parse(url));
    _addHeaders(request, headers);
    if (body != null) {
      request.write(body);
    }
    final response = await request.close();
    return _processResponse(response);
  }

  Future<HttpResponse> put(String url, {Map<String, String>? headers, String? body}) async {
    final request = await _client.putUrl(Uri.parse(url));
    _addHeaders(request, headers);
    if (body != null) {
      request.write(body);
    }
    final response = await request.close();
    return _processResponse(response);
  }

  Future<HttpResponse> delete(String url, {Map<String, String>? headers}) async {
    final request = await _client.deleteUrl(Uri.parse(url));
    _addHeaders(request, headers);
    final response = await request.close();
    return _processResponse(response);
  }

  void _addHeaders(HttpClientRequest request, Map<String, String>? headers) {
    headers?.forEach((key, value) {
      request.headers.set(key, value);
    });
  }

  Future<HttpResponse> _processResponse(HttpClientResponse response) async {
    final body = await response.transform(utf8.decoder).join();
    final headers = <String, String>{};
    response.headers.forEach((key, values) {
      headers[key] = values.join(', ');
    });

    return HttpResponse(
      statusCode: response.statusCode,
      body: body,
      headers: headers,
    );
  }

  void close() {
    _client.close();
  }
}

/// Hauptklasse für API Communication
class ApiClient {
  ApiClient({
    required this.config,
    SimpleHttpClient? httpClient,
    List<ApiInterceptor> interceptors = const [],
  }) : _httpClient = httpClient ?? SimpleHttpClient(),
       _interceptors = interceptors;

  final ApiConfig config;
  final SimpleHttpClient _httpClient;
  final List<ApiInterceptor> _interceptors;

  /// GET Request
  Future<ApiResult<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
    T Function(List<dynamic>)? fromJsonList,
  }) async {
    return _makeRequest<T>(
      () async {
        final url = _buildUrl(endpoint, queryParams);
        final headers = await _buildHeaders();
        return _httpClient.get(url, headers: headers);
      },
      fromJson: fromJson,
      fromJsonList: fromJsonList,
    );
  }

  /// POST Request
  Future<ApiResult<T>> post<T>(
    String endpoint, {
    Object? body,
    Map<String, String>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
    T Function(List<dynamic>)? fromJsonList,
  }) async {
    return _makeRequest<T>(
      () async {
        final url = _buildUrl(endpoint, queryParams);
        final headers = await _buildHeaders();
        return _httpClient.post(
          url,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
      },
      fromJson: fromJson,
      fromJsonList: fromJsonList,
    );
  }

  /// PUT Request
  Future<ApiResult<T>> put<T>(
    String endpoint, {
    Object? body,
    Map<String, String>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    return _makeRequest<T>(
      () async {
        final url = _buildUrl(endpoint, queryParams);
        final headers = await _buildHeaders();
        return _httpClient.put(
          url,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
      },
      fromJson: fromJson,
    );
  }

  /// DELETE Request
  Future<ApiResult<bool>> delete(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    final result = await _makeRequest<String>(
      () async {
        final url = _buildUrl(endpoint, queryParams);
        final headers = await _buildHeaders();
        return _httpClient.delete(url, headers: headers);
      },
    );

    return switch (result) {
      ApiSuccess() => const ApiSuccess(true),
      ApiFailure(:final error, :final statusCode) => ApiFailure(error, statusCode: statusCode),
    };
  }

  /// Private: Führt HTTP Request mit Retry Logic aus
  Future<ApiResult<T>> _makeRequest<T>(
    Future<HttpResponse> Function() request, {
    T Function(Map<String, dynamic>)? fromJson,
    T Function(List<dynamic>)? fromJsonList,
    int attempt = 0,
  }) async {
    try {
      final response = await request().timeout(config.timeout);
      final processedResponse = await _processInterceptors(response);

      if (processedResponse.isSuccess) {
        if (fromJson != null || fromJsonList != null) {
          final data = _parseResponse<T>(processedResponse.body, fromJson, fromJsonList);
          return ApiSuccess(data, statusCode: processedResponse.statusCode);
        } else {
          // Für void/bool operations - wir wissen dass T bool ist
          return ApiSuccess(true as T, statusCode: processedResponse.statusCode);
        }
      } else {
        final errorMessage = await _processErrorInterceptors(
          'HTTP ${processedResponse.statusCode}',
          processedResponse.statusCode,
        );
        return ApiFailure(errorMessage, statusCode: processedResponse.statusCode);
      }
    } on SocketException {
      if (attempt < config.retryAttempts) {
        await Future.delayed(config.retryDelay * (attempt + 1));
        return _makeRequest(request, fromJson: fromJson, fromJsonList: fromJsonList, attempt: attempt + 1);
      }
      return const ApiFailure('Network connection failed');
    } on TimeoutException {
      if (attempt < config.retryAttempts) {
        await Future.delayed(config.retryDelay * (attempt + 1));
        return _makeRequest(request, fromJson: fromJson, fromJsonList: fromJsonList, attempt: attempt + 1);
      }
      return const ApiFailure('Request timeout');
    } catch (e) {
      final errorMessage = await _processErrorInterceptors(e.toString(), null);
      return ApiFailure(errorMessage);
    }
  }

  /// Private: URL Builder
  String _buildUrl(String endpoint, Map<String, String>? queryParams) {
    var url = '${config.baseUrl}/$endpoint'.replaceAll('//', '/');
    if (config.baseUrl.startsWith('http')) {
      url = config.baseUrl + (endpoint.startsWith('/') ? endpoint : '/$endpoint');
    }

    if (queryParams != null && queryParams.isNotEmpty) {
      final uri = Uri.parse(url);
      url = uri.replace(queryParameters: {...uri.queryParameters, ...queryParams}).toString();
    }

    return url;
  }

  /// Private: Headers Builder mit Interceptors
  Future<Map<String, String>> _buildHeaders() async {
    var headers = Map<String, String>.from(config.defaultHeaders);
    headers['Content-Type'] = 'application/json';
    headers['Accept'] = 'application/json';

    for (final interceptor in _interceptors) {
      headers = await interceptor.onRequest('', headers);
    }

    return headers;
  }

  /// Private: Response Interceptors
  Future<HttpResponse> _processInterceptors(HttpResponse response) async {
    var processedResponse = response;
    for (final interceptor in _interceptors) {
      processedResponse = await interceptor.onResponse(processedResponse);
    }
    return processedResponse;
  }

  /// Private: Error Interceptors
  Future<String> _processErrorInterceptors(String error, int? statusCode) async {
    var processedError = error;
    for (final interceptor in _interceptors) {
      processedError = await interceptor.onError(processedError, statusCode);
    }
    return processedError;
  }

  /// Private: JSON Response Parser
  T _parseResponse<T>(
    String body,
    T Function(Map<String, dynamic>)? fromJson,
    T Function(List<dynamic>)? fromJsonList,
  ) {
    if (body.isEmpty) {
      throw const FormatException('Empty response body');
    }

    final dynamic json = jsonDecode(body);

    if (fromJsonList != null && json is List) {
      return fromJsonList(json);
    } else if (fromJson != null && json is Map<String, dynamic>) {
      return fromJson(json);
    } else if (json is T) {
      return json;
    } else {
      throw FormatException('Cannot parse response to type $T');
    }
  }

  /// Cleanup
  void dispose() {
    _httpClient.close();
  }
}

/// Factory für verschiedene API Clients
class ApiClientFactory {
  static ApiClient createDefault({
    required String baseUrl,
    Future<String?> Function()? tokenProvider,
    bool enableLogging = true,
  }) {
    final interceptors = <ApiInterceptor>[];

    if (tokenProvider != null) {
      interceptors.add(AuthInterceptor(tokenProvider: tokenProvider));
    }

    if (enableLogging) {
      interceptors.add(LoggingInterceptor());
    }

    return ApiClient(
      config: ApiConfig(baseUrl: baseUrl),
      interceptors: interceptors,
    );
  }
}

/// Beispiel User Model für API Verwendung
@immutable
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });

  final String id;
  final String name;
  final String email;
  final String? avatar;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
    );
  }
}

/// Beispiel User API Service
class UserApiService {
  UserApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// Alle User laden
  Future<ApiResult<List<User>>> getUsers() async {
    return _apiClient.get<List<User>>(
      'users',
      fromJsonList: (list) => list.map((json) => User.fromJson(json as Map<String, dynamic>)).toList(),
    );
  }

  /// User by ID laden
  Future<ApiResult<User>> getUserById(String id) async {
    return _apiClient.get<User>(
      'users/$id',
      fromJson: User.fromJson,
    );
  }

  /// Neuen User erstellen
  Future<ApiResult<User>> createUser(User user) async {
    return _apiClient.post<User>(
      'users',
      body: user.toJson(),
      fromJson: User.fromJson,
    );
  }

  /// User aktualisieren
  Future<ApiResult<User>> updateUser(String id, User user) async {
    return _apiClient.put<User>(
      'users/$id',
      body: user.toJson(),
      fromJson: User.fromJson,
    );
  }

  /// User löschen
  Future<ApiResult<bool>> deleteUser(String id) async {
    return _apiClient.delete('users/$id');
  }

  /// Cleanup
  void dispose() {
    _apiClient.dispose();
  }
}

/// Beispiel für API Client Usage
class ApiUsageExample {
  static Future<void> demonstrateUsage() async {
    // API Client erstellen
    final apiClient = ApiClientFactory.createDefault(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      tokenProvider: () async => 'your-auth-token',
      enableLogging: true,
    );

    final userService = UserApiService(apiClient: apiClient);

    try {
      // Users laden
      final usersResult = await userService.getUsers();
      switch (usersResult) {
        case ApiSuccess(:final data):
          debugPrint('Loaded ${data.length} users');
        case ApiFailure(:final error):
          debugPrint('Failed to load users: $error');
      }

      // Einzelnen User laden
      const userId = '1';
      final userResult = await userService.getUserById(userId);
      switch (userResult) {
        case ApiSuccess(:final data):
          debugPrint('Loaded user: ${data.name}');
        case ApiFailure(:final error):
          debugPrint('Failed to load user: $error');
      }

      // Neuen User erstellen
      const newUser = User(
        id: '',
        name: 'John Doe',
        email: 'john@example.com',
      );
      
      final createResult = await userService.createUser(newUser);
      switch (createResult) {
        case ApiSuccess(:final data):
          debugPrint('Created user with ID: ${data.id}');
        case ApiFailure(:final error):
          debugPrint('Failed to create user: $error');
      }

    } finally {
      // Cleanup
      userService.dispose();
    }
  }
}
