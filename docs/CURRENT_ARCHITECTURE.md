# Aktuell verwendete Dateien - Service-basierte Architektur

## ✅ CORE SERVICE INFRASTRUCTURE (BEHALTEN)
- `lib/core/services/service_locator.dart` - Service Locator für DI
- `lib/features/stammdaten/services/klassen_service.dart` - Service Interface
- `lib/features/stammdaten/services/faecher_service.dart` - Service Interface 
- `lib/features/stammdaten/services/mock_klassen_service.dart` - MockUp Implementation
- `lib/features/stammdaten/services/mock_faecher_service.dart` - MockUp Implementation

## ✅ MODELS & DTOS (BEHALTEN)
- `lib/features/stammdaten/models/klasse.dart` - Domain Models
- `lib/features/stammdaten/models/fach.dart` - Domain Models
- `lib/features/stammdaten/dtos/klasse_dtos.dart` - API DTOs
- `lib/features/stammdaten/dtos/fach_dtos.dart` - API DTOs

## ✅ REFACTORED PROVIDERS (BEHALTEN)
- `lib/features/stammdaten/providers/refactored_klassen_provider.dart` - Service-based Provider
- `lib/features/stammdaten/providers/refactored_faecher_provider.dart` - Service-based Provider

## ✅ ADAPTER PROVIDERS (BEHALTEN)
- `lib/features/stammdaten/providers/klassen_provider_adapter.dart` - Legacy UI Compatibility
- `lib/features/stammdaten/providers/faecher_provider_adapter.dart` - Legacy UI Compatibility

## ✅ SCREENS & UI (BEHALTEN/AKTUALISIEREN)
- `lib/features/stammdaten/screens/klassen_screen_corrected.dart` - Korrigierter Screen mit Adaptern
- `lib/features/stammdaten/screens/faecher_screen.dart` - Aktualisieren für Adapter
- `lib/features/stammdaten/widgets/klasse_dialog_refactored.dart` - Verwendet Adapter
- `lib/features/stammdaten/widgets/fach_dialog_refactored.dart` - Aktualisieren für Adapter

## ✅ APP CONFIGURATION (BEHALTEN)
- `lib/app.dart` - ServiceProvider + MultiProvider Setup
- `lib/routing/app_router.dart` - Routing mit korrigierten Screens

## ❌ ZU LÖSCHENDE DATEIEN (LEGACY/KORRUPT)
- `lib/features/stammdaten/providers/klassen_provider.dart` - Korrupt, durch Adapter ersetzt
- `lib/features/stammdaten/providers/faecher_provider.dart` - Legacy, durch Adapter ersetzt
- `lib/features/stammdaten/providers/klassen_provider_*.dart` - Alle Backup/Test Dateien
- `lib/features/stammdaten/screens/klassen_screen.dart` - Alte Version
- `lib/features/stammdaten/screens/faecher_screen_*.dart` - Alte/Test Versionen
- Alle anderen Backup/Test Dateien
