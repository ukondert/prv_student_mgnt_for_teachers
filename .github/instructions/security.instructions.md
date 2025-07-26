---
description: "Flutter security best practices and guidelines"
applyTo: "lib/**/*.dart"
---

# Flutter Security Instructions

## 🔐 Security Best Practices

### Data Protection

```dart
// Secure Storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

// Store sensitive data
await storage.write(key: 'api_token', value: token);

// Read sensitive data
final token = await storage.read(key: 'api_token');
```

### Network Security

```dart
// Certificate Pinning
class SecurityService {
  static final dio = Dio();
  
  static void configureCertificatePinning() {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (cert, host, port) {
        return _verifyCertificate(cert, host);
      };
      return client;
    };
  }
}
```

### Input Validation

```dart
// Validate user input
class InputValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email ist erforderlich';
    }
    
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Ungültige Email-Adresse';
    }
    
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.length < 8) {
      return 'Passwort muss mindestens 8 Zeichen haben';
    }
    return null;
  }
}
```

### Authentication & Authorization

```dart
// Biometric Authentication
import 'package:local_auth/local_auth.dart';

class BiometricService {
  static final LocalAuthentication _localAuth = LocalAuthentication();
  
  static Future<bool> authenticateWithBiometrics() async {
    try {
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      if (!isAvailable) return false;
      
      return await _localAuth.authenticate(
        localizedReason: 'Bitte authentifizieren Sie sich',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}
```

### Secure Configuration

```dart
// Environment Variables (never hardcode secrets)
class ApiConfig {
  static const String baseUrl = String.fromEnvironment('API_BASE_URL');
  static const String apiKey = String.fromEnvironment('API_KEY');
  
  // Validate configuration at startup
  static void validateConfig() {
    assert(baseUrl.isNotEmpty, 'API_BASE_URL must be provided');
    assert(apiKey.isNotEmpty, 'API_KEY must be provided');
  }
}
```

### Error Handling Security

```dart
// Secure error messages (no sensitive info leakage)
class SecureErrorHandler {
  static String sanitizeErrorMessage(String error) {
    // Remove sensitive information from error messages
    if (error.contains('password') || error.contains('token')) {
      return 'Authentifizierungsfehler aufgetreten';
    }
    
    if (error.contains('database') || error.contains('sql')) {
      return 'Datenbankfehler aufgetreten';
    }
    
    return 'Ein unerwarteter Fehler ist aufgetreten';
  }
}
```

### Security Checklist

- [ ] Keine Secrets im Source Code
- [ ] Input Validation für alle Benutzereingaben
- [ ] HTTPS für alle Netzwerkverbindungen
- [ ] Certificate Pinning implementiert
- [ ] Secure Storage für sensitive Daten
- [ ] Biometrische Authentifizierung wo möglich
- [ ] Error Messages enthalten keine sensitiven Informationen
- [ ] Code Obfuscation für Release Builds
