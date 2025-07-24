// Flutter Service Layer Pattern
// HTTP API Integration mit Error Handling

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/api_response.dart';

/// Service-Klasse für Benutzer-API-Operationen.
/// 
/// Demonstriert Flutter Best Practices:
/// - Singleton Pattern mit factory constructor
/// - Async/await mit proper Error Handling
/// - HTTP Client mit Timeouts
/// - JSON Serialization/Deserialization
/// - Custom Exceptions für verschiedene Error-Typen
/// - Logging für Debugging
/// 
/// Verwendung:
/// ```dart
/// final userService = UserService.instance;
/// final users = await userService.getUsers();
/// ```
class UserService {
  UserService._internal();
  
  static final UserService _instance = UserService._internal();
  static UserService get instance => _instance;
  
  final http.Client _httpClient = http.Client();
  static const String _baseUrl = 'https://api.example.com/v1';
  static const Duration _timeout = Duration(seconds: 30);
  
  /// Holt alle Benutzer vom Server
  Future<List<User>> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
      };
      
      final uri = Uri.parse('$_baseUrl/users').replace(
        queryParameters: queryParams,
      );
      
      final response = await _httpClient.get(
        uri,
        headers: _getHeaders(),
      ).timeout(_timeout);
      
      if (response.statusCode == 200) {
        final ApiResponse<List<dynamic>> apiResponse = 
            ApiResponse.fromJson(jsonDecode(response.body));
            
        if (apiResponse.success && apiResponse.data != null) {
          return apiResponse.data!
              .map((json) => User.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw ApiException(apiResponse.message ?? 'Unbekannter Fehler');
        }
      } else {
        throw HttpException(
          'Server Error: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } on HttpException {
      rethrow;
    } catch (error) {
      throw NetworkException('Netzwerkfehler: $error');
    }
  }
  
  /// Holt einen einzelnen Benutzer
  Future<User> getUserById(String id) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/users/$id'),
        headers: _getHeaders(),
      ).timeout(_timeout);
      
      if (response.statusCode == 200) {
        final ApiResponse<Map<String, dynamic>> apiResponse = 
            ApiResponse.fromJson(jsonDecode(response.body));
            
        if (apiResponse.success && apiResponse.data != null) {
          return User.fromJson(apiResponse.data!);
        } else {
          throw ApiException(apiResponse.message ?? 'Benutzer nicht gefunden');
        }
      } else if (response.statusCode == 404) {
        throw UserNotFoundException('Benutzer mit ID $id nicht gefunden');
      } else {
        throw HttpException(
          'Server Error: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } on UserNotFoundException {
      rethrow;
    } on HttpException {
      rethrow;
    } catch (error) {
      throw NetworkException('Netzwerkfehler: $error');
    }
  }
  
  /// Erstellt einen neuen Benutzer
  Future<User> createUser(CreateUserRequest request) async {
    try {
      // Validation
      if (request.name.trim().isEmpty) {
        throw ValidationException('Name ist erforderlich');
      }
      if (!_isValidEmail(request.email)) {
        throw ValidationException('Ungültige E-Mail-Adresse');
      }
      
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl/users'),
        headers: _getHeaders(),
        body: jsonEncode(request.toJson()),
      ).timeout(_timeout);
      
      if (response.statusCode == 201) {
        final ApiResponse<Map<String, dynamic>> apiResponse = 
            ApiResponse.fromJson(jsonDecode(response.body));
            
        if (apiResponse.success && apiResponse.data != null) {
          return User.fromJson(apiResponse.data!);
        } else {
          throw ApiException(apiResponse.message ?? 'Fehler beim Erstellen');
        }
      } else if (response.statusCode == 409) {
        throw UserAlreadyExistsException('Benutzer existiert bereits');
      } else {
        throw HttpException(
          'Server Error: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on ValidationException {
      rethrow;
    } on UserAlreadyExistsException {
      rethrow;
    } on ApiException {
      rethrow;
    } on HttpException {
      rethrow;
    } catch (error) {
      throw NetworkException('Netzwerkfehler: $error');
    }
  }
  
  /// Aktualisiert einen Benutzer
  Future<User> updateUser(String id, UpdateUserRequest request) async {
    try {
      final response = await _httpClient.put(
        Uri.parse('$_baseUrl/users/$id'),
        headers: _getHeaders(),
        body: jsonEncode(request.toJson()),
      ).timeout(_timeout);
      
      if (response.statusCode == 200) {
        final ApiResponse<Map<String, dynamic>> apiResponse = 
            ApiResponse.fromJson(jsonDecode(response.body));
            
        if (apiResponse.success && apiResponse.data != null) {
          return User.fromJson(apiResponse.data!);
        } else {
          throw ApiException(apiResponse.message ?? 'Fehler beim Aktualisieren');
        }
      } else if (response.statusCode == 404) {
        throw UserNotFoundException('Benutzer mit ID $id nicht gefunden');
      } else {
        throw HttpException(
          'Server Error: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on UserNotFoundException {
      rethrow;
    } on ApiException {
      rethrow;
    } on HttpException {
      rethrow;
    } catch (error) {
      throw NetworkException('Netzwerkfehler: $error');
    }
  }
  
  /// Löscht einen Benutzer
  Future<void> deleteUser(String id) async {
    try {
      final response = await _httpClient.delete(
        Uri.parse('$_baseUrl/users/$id'),
        headers: _getHeaders(),
      ).timeout(_timeout);
      
      if (response.statusCode == 204) {
        // Success - no content
        return;
      } else if (response.statusCode == 404) {
        throw UserNotFoundException('Benutzer mit ID $id nicht gefunden');
      } else {
        throw HttpException(
          'Server Error: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on UserNotFoundException {
      rethrow;
    } on HttpException {
      rethrow;
    } catch (error) {
      throw NetworkException('Netzwerkfehler: $error');
    }
  }
  
  /// Standard-Headers für API-Requests
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // TODO: Add authentication headers
      // 'Authorization': 'Bearer $token',
    };
  }
  
  /// E-Mail-Validierung
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  /// Cleanup Methode
  void dispose() {
    _httpClient.close();
  }
}

/// Basis-Exception für API-Fehler
abstract class ServiceException implements Exception {
  const ServiceException(this.message);
  final String message;
  
  @override
  String toString() => 'ServiceException: $message';
}

/// API-spezifische Exception
class ApiException extends ServiceException {
  const ApiException(super.message);
  
  @override
  String toString() => 'ApiException: $message';
}

/// HTTP-spezifische Exception
class HttpException extends ServiceException {
  const HttpException(super.message, this.statusCode);
  final int statusCode;
  
  @override
  String toString() => 'HttpException ($statusCode): $message';
}

/// Netzwerk-Exception
class NetworkException extends ServiceException {
  const NetworkException(super.message);
  
  @override
  String toString() => 'NetworkException: $message';
}

/// Validierungs-Exception
class ValidationException extends ServiceException {
  const ValidationException(super.message);
  
  @override
  String toString() => 'ValidationException: $message';
}

/// Benutzer nicht gefunden Exception
class UserNotFoundException extends ServiceException {
  const UserNotFoundException(super.message);
  
  @override
  String toString() => 'UserNotFoundException: $message';
}

/// Benutzer existiert bereits Exception
class UserAlreadyExistsException extends ServiceException {
  const UserAlreadyExistsException(super.message);
  
  @override
  String toString() => 'UserAlreadyExistsException: $message';
}

/// Request-Model für das Erstellen von Benutzern
class CreateUserRequest {
  const CreateUserRequest({
    required this.name,
    required this.email,
    this.avatarUrl,
    this.role,
  });

  final String name;
  final String email;
  final String? avatarUrl;
  final String? role;

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    if (avatarUrl != null) 'avatarUrl': avatarUrl,
    if (role != null) 'role': role,
  };
}

/// Request-Model für das Aktualisieren von Benutzern
class UpdateUserRequest {
  const UpdateUserRequest({
    this.name,
    this.email,
    this.avatarUrl,
    this.role,
  });

  final String? name;
  final String? email;
  final String? avatarUrl;
  final String? role;

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (email != null) 'email': email,
    if (avatarUrl != null) 'avatarUrl': avatarUrl,
    if (role != null) 'role': role,
  };
}
