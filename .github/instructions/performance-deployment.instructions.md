---
description: "Flutter performance optimization and deployment guidelines"
applyTo: "**"
---

# Flutter Performance & Deployment Instructions

## ⚡ Performance Monitoring

### Logging

```dart
// Structured Logging
logger.info('User action completed', extra: {
  'userId': user.id,
  'action': 'profile_update',
  'timestamp': DateTime.now().toIso8601String(),
});
```

### Performance Monitoring

- Nutzen Sie Flutter Performance Tools
- Implementieren Sie Firebase Performance Monitoring
- Überwachen Sie Memory Usage
- Tracken Sie App Start Time

## 🚀 Deployment & CI/CD

### Build Configuration

- Konfigurieren Sie verschiedene Flavors (dev, staging, prod)
- Implementieren Sie Code Obfuscation für Release
- Nutzen Sie FastLane für Deployment Automation
- Konfigurieren Sie ProGuard/R8 für Android

### Build Optimization

```dart
// Release build optimizations
flutter build apk --release --obfuscate --split-debug-info=build/debug-info/

// iOS release
flutter build ios --release --obfuscate --split-debug-info=build/debug-info/
```

### Environment Configuration

```dart
// Environment-specific configuration
class Environment {
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://api.example.com',
  );
  
  static const bool isDevelopment = bool.fromEnvironment('DEBUG');
}
```

### CI/CD Pipeline

- Implementieren Sie automatisierte Tests
- Nutzen Sie GitHub Actions für Flutter builds
- Konfigurieren Sie Fastlane für App Store/Play Store deployment
- Implementieren Sie Code-Quality-Checks (lint, format, analyze)

### Monitoring & Analytics

- Firebase Analytics für User Behavior
- Crashlytics für Error Tracking
- Performance Monitoring für App-Performance
- Custom Events für Business Metrics
