// Flutter Service Layer Pattern
// Saubere HTTP API Integration mit modernen Dart Features

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

/// User model - immutable data class
@immutable
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final bool isActive;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'isActive': isActive,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}

/// API Response wrapper für typsichere Responses
sealed class ApiResult<T> {
  const ApiResult();
}

class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data);
  final T data;
}

class ApiError<T> extends ApiResult<T> {
  const ApiError(this.message, [this.statusCode]);
  final String message;
  final int? statusCode;
}

/// Custom Exceptions
class UserServiceException implements Exception {
  const UserServiceException(this.message, [this.statusCode]);
  final String message;
  final int? statusCode;

  @override
  String toString() => 'UserServiceException: $message';
}

/// HTTP Client Interface für bessere Testbarkeit
abstract interface class HttpClient {
  Future<HttpResponse> get(String url, {Map<String, String>? headers});
  Future<HttpResponse> post(String url, {Map<String, String>? headers, String? body});
  Future<HttpResponse> put(String url, {Map<String, String>? headers, String? body});
  Future<HttpResponse> delete(String url, {Map<String, String>? headers});
  void close();
}

/// HTTP Response Model
class HttpResponse {
  const HttpResponse({
    required this.statusCode,
    required this.body,
    this.headers = const {},
  });

  final int statusCode;
  final String body;
  final Map<String, String> headers;
}

/// Service-Klasse für Benutzer-API-Operationen
/// 
/// Demonstriert moderne Flutter/Dart Best Practices:
/// - Dependency Injection
/// - Sealed Classes für Type-Safe Error Handling
/// - Interface Segregation (HttpClient interface)
/// - Immutable Data Models
/// - Proper Exception Handling
/// - Clean Architecture Pattern
/// 
/// Verwendung:
/// ```dart
/// final userService = UserService(
///   httpClient: MyHttpClient(),
///   baseUrl: 'https://api.example.com',
/// );
/// 
/// final result = await userService.getUsers();
/// switch (result) {
///   case ApiSuccess(:final data):
///     // Handle success
///     print('Users: $data');
///   case ApiError(:final message):
///     // Handle error
///     print('Error: $message');
/// }
/// ```
class UserService {
  const UserService({
    required HttpClient httpClient,
    String baseUrl = 'https://api.example.com',
  }) : _httpClient = httpClient,
       _baseUrl = baseUrl;

  final HttpClient _httpClient;
  final String _baseUrl;

  static const Duration _timeout = Duration(seconds: 30);

  /// Holt alle Benutzer von der API
  Future<ApiResult<List<User>>> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (search?.isNotEmpty == true) 'search': search!,
      };

      final url = _buildUrl('/users', queryParams);
      final response = await _httpClient.get(url, headers: _defaultHeaders);

      return switch (response.statusCode) {
        200 => _parseUserList(response.body),
        404 => const ApiError('Users not found', 404),
        >= 500 => ApiError('Server error', response.statusCode),
        _ => ApiError('Unknown error', response.statusCode),
      };
    } on SocketException {
      return const ApiError('Network connection failed');
    } catch (e) {
      debugPrint('Error in getUsers: $e');
      return ApiError('Unexpected error: $e');
    }
  }

  /// Holt einen Benutzer anhand der ID
  Future<ApiResult<User>> getUserById(String id) async {
    if (id.trim().isEmpty) {
      return const ApiError('User ID cannot be empty');
    }

    try {
      final response = await _httpClient.get(
        '$_baseUrl/users/$id',
        headers: _defaultHeaders,
      );

      return switch (response.statusCode) {
        200 => _parseUser(response.body),
        404 => const ApiError('User not found', 404),
        >= 500 => ApiError('Server error', response.statusCode),
        _ => ApiError('Unknown error', response.statusCode),
      };
    } on SocketException {
      return const ApiError('Network connection failed');
    } catch (e) {
      debugPrint('Error in getUserById: $e');
      return ApiError('Unexpected error: $e');
    }
  }

  /// Erstellt einen neuen Benutzer
  Future<ApiResult<User>> createUser(User user) async {
    final validationError = _validateUser(user);
    if (validationError != null) {
      return ApiError(validationError);
    }

    try {
      final response = await _httpClient.post(
        '$_baseUrl/users',
        headers: _defaultHeaders,
        body: jsonEncode(user.toJson()),
      );

      return switch (response.statusCode) {
        201 => _parseUser(response.body),
        409 => const ApiError('User already exists', 409),
        >= 500 => ApiError('Server error', response.statusCode),
        _ => ApiError('Failed to create user', response.statusCode),
      };
    } on SocketException {
      return const ApiError('Network connection failed');
    } catch (e) {
      debugPrint('Error in createUser: $e');
      return ApiError('Unexpected error: $e');
    }
  }

  /// Aktualisiert einen bestehenden Benutzer
  Future<ApiResult<User>> updateUser(String id, User user) async {
    if (id.trim().isEmpty) {
      return const ApiError('User ID cannot be empty');
    }

    final validationError = _validateUser(user);
    if (validationError != null) {
      return ApiError(validationError);
    }

    try {
      final response = await _httpClient.put(
        '$_baseUrl/users/$id',
        headers: _defaultHeaders,
        body: jsonEncode(user.toJson()),
      );

      return switch (response.statusCode) {
        200 => _parseUser(response.body),
        404 => const ApiError('User not found', 404),
        >= 500 => ApiError('Server error', response.statusCode),
        _ => ApiError('Failed to update user', response.statusCode),
      };
    } on SocketException {
      return const ApiError('Network connection failed');
    } catch (e) {
      debugPrint('Error in updateUser: $e');
      return ApiError('Unexpected error: $e');
    }
  }

  /// Löscht einen Benutzer
  Future<ApiResult<bool>> deleteUser(String id) async {
    if (id.trim().isEmpty) {
      return const ApiError('User ID cannot be empty');
    }

    try {
      final response = await _httpClient.delete(
        '$_baseUrl/users/$id',
        headers: _defaultHeaders,
      );

      return switch (response.statusCode) {
        204 => const ApiSuccess(true),
        404 => const ApiError('User not found', 404),
        >= 500 => ApiError('Server error', response.statusCode),
        _ => ApiError('Failed to delete user', response.statusCode),
      };
    } on SocketException {
      return const ApiError('Network connection failed');
    } catch (e) {
      debugPrint('Error in deleteUser: $e');
      return ApiError('Unexpected error: $e');
    }
  }

  // Private Helper Methods

  String _buildUrl(String path, Map<String, String> queryParams) {
    final uri = Uri.parse('$_baseUrl$path');
    return uri.replace(queryParameters: queryParams).toString();
  }

  ApiResult<List<User>> _parseUserList(String body) {
    try {
      final List<dynamic> jsonList = jsonDecode(body);
      final users = jsonList
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();
      return ApiSuccess(users);
    } catch (e) {
      return const ApiError('Failed to parse user list');
    }
  }

  ApiResult<User> _parseUser(String body) {
    try {
      final Map<String, dynamic> json = jsonDecode(body);
      final user = User.fromJson(json);
      return ApiSuccess(user);
    } catch (e) {
      return const ApiError('Failed to parse user data');
    }
  }

  String? _validateUser(User user) {
    if (user.name.trim().isEmpty) {
      return 'Name cannot be empty';
    }
    if (user.email.trim().isEmpty) {
      return 'Email cannot be empty';
    }
    if (!_isValidEmail(user.email)) {
      return 'Invalid email format';
    }
    return null;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Map<String, String> get _defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Ressourcen freigeben
  void dispose() {
    _httpClient.close();
  }
}
