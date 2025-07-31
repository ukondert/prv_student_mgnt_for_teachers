import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../features/stammdaten/services/klassen_service.dart';
import '../../features/stammdaten/services/faecher_service.dart';
import '../../features/stammdaten/services/impl/mock_klassen_service.dart';
import '../../features/stammdaten/services/impl/mock_faecher_service.dart';

/// Service Locator für Dependency Injection
/// 
/// Diese Klasse verwaltet die Service-Instanzen und bietet eine zentrale
/// Stelle für die Konfiguration der verschiedenen Implementierungen.
/// 
/// Unterstützte Service-Typen:
/// - MockUp (aktuell): In-Memory-Services für Entwicklung/Testing
/// - SQLite (geplant): Lokale Datenbank-Services
/// - HTTP (geplant): REST-API-Services
class ServiceLocator {
  static ServiceLocator? _instance;
  static ServiceLocator get instance => _instance ??= ServiceLocator._();
  ServiceLocator._();

  // Service instances
  KlassenService? _klassenService;
  FaecherService? _faecherService;

  /// Current service mode
  ServiceMode _mode = ServiceMode.mock;
  ServiceMode get mode => _mode;

  /// Initialize services with the specified mode
  void initialize({ServiceMode mode = ServiceMode.mock}) {
    _mode = mode;
    _initializeServices();
  }

  void _initializeServices() {
    switch (_mode) {
      case ServiceMode.mock:
        _klassenService = MockKlassenService();
        _faecherService = MockFaecherService();
        break;
      case ServiceMode.sqlite:
        // TODO: Implement SQLite services
        throw UnimplementedError('SQLite services not yet implemented');
      case ServiceMode.http:
        // TODO: Implement HTTP services  
        throw UnimplementedError('HTTP services not yet implemented');
    }
  }

  /// Get KlassenService instance
  KlassenService get klassenService {
    if (_klassenService == null) {
      throw StateError('ServiceLocator not initialized. Call initialize() first.');
    }
    return _klassenService!;
  }

  /// Get FaecherService instance
  FaecherService get faecherService {
    if (_faecherService == null) {
      throw StateError('ServiceLocator not initialized. Call initialize() first.');
    }
    return _faecherService!;
  }

  /// Reset all services (useful for testing)
  void reset() {
    _klassenService = null;
    _faecherService = null;
    
    // Clear mock data
    if (_mode == ServiceMode.mock) {
      MockKlassenService.clearAllData();
      MockFaecherService.clearAllData();
    }
  }

  /// Switch to a different service mode
  void switchMode(ServiceMode newMode) {
    if (_mode != newMode) {
      reset();
      initialize(mode: newMode);
    }
  }
}

/// Available service implementation modes
enum ServiceMode {
  /// In-Memory mock services for development and testing
  mock,
  
  /// Local SQLite database services
  sqlite,
  
  /// Remote HTTP API services
  http,
}

/// Provider wrapper for ServiceLocator
/// 
/// This provides easy access to services throughout the widget tree
/// using Provider pattern.
class ServiceProvider extends StatelessWidget {
  final Widget child;
  final ServiceMode mode;

  const ServiceProvider({
    super.key,
    required this.child,
    this.mode = ServiceMode.mock,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize ServiceLocator
    ServiceLocator.instance.initialize(mode: mode);

    return MultiProvider(
      providers: [
        Provider<KlassenService>.value(
          value: ServiceLocator.instance.klassenService,
        ),
        Provider<FaecherService>.value(
          value: ServiceLocator.instance.faecherService,
        ),
      ],
      child: child,
    );
  }
}

/// Extension to easily access services from BuildContext
extension ServiceContext on BuildContext {
  KlassenService get klassenService => read<KlassenService>();
  FaecherService get faecherService => read<FaecherService>();
}

/// Development utility for service management
class ServiceUtils {
  /// Get debug information about current services
  static Map<String, dynamic> getDebugInfo() {
    final locator = ServiceLocator.instance;
    
    return {
      'mode': locator.mode.name,
      'klassenService': locator._klassenService.runtimeType.toString(),
      'faecherService': locator._faecherService.runtimeType.toString(),
      'mockData': {
        'klassen': ServiceLocator.instance.mode == ServiceMode.mock 
            ? MockKlassenService.getCurrentDatabase().length
            : 'N/A',
        'faecher': ServiceLocator.instance.mode == ServiceMode.mock
            ? MockFaecherService.getCurrentDatabase().length
            : 'N/A',
      },
    };
  }

  /// Reset all mock data (useful for testing)
  static void resetMockData() {
    if (ServiceLocator.instance.mode == ServiceMode.mock) {
      MockKlassenService.clearAllData();
      MockFaecherService.clearAllData();
    }
  }

  /// Preload mock data for demonstration
  static Future<void> preloadMockData() async {
    if (ServiceLocator.instance.mode == ServiceMode.mock) {
      // Trigger initialization of mock data
      await ServiceLocator.instance.klassenService.getAlleKlassen();
      await ServiceLocator.instance.faecherService.getAlleFaecher();
    }
  }
}
