# Flutter Context Engineering Template für GitHub Copilot Agent Mode 🚀

Ein umfassendes Template für Context Engineering mit GitHub Copilot Agent Mode speziell optimiert für Flutter-Entwicklung in VS Code mit Integration verfügbarer MCP-Server für maximale Produktivität.

## 🎯 Was ist Context Engineering für Flutter?

Context Engineering ist der nächste Evolutionsschritt nach Prompt Engineering, speziell für Flutter-Entwicklung. Anstatt nur clevere Prompts zu schreiben, erstellen wir ein komplettes System aus:

- **Flutter-spezifische Projektregeln** und Dart-Konventionen
- **Widget-Patterns** und State Management Beispiele
- **Flutter-Dokumentation** und Best Practices  
- **MCP-Server Integration** für Backend-Services und APIs
- **Flutter-optimierte Agent-Workflows**

### Warum GitHub Copilot Agent Mode für Flutter?

- 🎯 **Native VS Code Integration** - Direkt in der Flutter-IDE arbeiten
- 🔧 **Flutter-spezifische Agent-Fähigkeiten** - Widget-Entwicklung, State Management
- 🛠️ **MCP Server Support** - Backend-Integration und API-Verbindungen
- � **Mobile-First Context** - Versteht Flutter App-Architektur
- 🔄 **Hot Reload Integration** - Schnelle Entwicklungszyklen

## 📁 Flutter Template Struktur

```yaml
flutter_context_engineering/
├── .github/                     # GitHub Copilot Instructions (VS Code Standard)
│   ├── copilot-instructions.md  # Haupt-Instructions (automatisch aktiv)
│   ├── README.md               # Anleitung zur Instructions-Struktur
│   └── instructions/           # Spezialisierte Instructions Files
│       ├── widget-development.instructions.md
│       ├── testing.instructions.md
│       ├── performance-deployment.instructions.md
│       └── security.instructions.md
├── docs/                       # Flutter-Projektdokumentation
│   ├── AGENT_RULES.md          # Referenz zu Instructions (migriert)
│   ├── PATTERNS.md             # Flutter Widget-Patterns & State Management
│   ├── MCP_SERVERS.md          # Backend & API MCP Server
│   └── WORKFLOWS.md            # Flutter-Entwicklung Workflows
├── examples/                   # Flutter Code-Beispiele
│   ├── widgets/                # Widget-Patterns (Stateless/Stateful)
│   ├── screens/                # Screen/Page-Patterns
│   ├── services/               # Service-Layer (HTTP, Database)
│   ├── models/                 # Data Models & Serialization
│   ├── state_management/       # Provider, Bloc, Riverpod Beispiele
│   └── testing/                # Unit & Widget Tests
├── templates/                  # Flutter-spezifische Templates
│   ├── feature-request.md      # Flutter Feature Requests
│   ├── bug-report.md           # Flutter Bug Reports
│   ├── widget-template.dart    # Widget Template
│   └── screen-template.dart    # Screen Template
├── scripts/                    # Flutter Automatisierung
│   ├── setup-mcp.ps1          # MCP Server Setup für Flutter
│   ├── flutter-doctor.ps1     # Flutter Environment Check
│   └── validate-project.ps1   # Flutter Projekt-Validierung
└── README.md                   # Diese Datei
```

## 🚦 Flutter Quick Start

### 1. Template einrichten

```bash
# Repository klonen oder als Template verwenden
git clone https://github.com/ukondert/template_context_engineering_flutter.git
cd template_context_engineering_flutter

# Flutter Environment prüfen
.\scripts\flutter-doctor.ps1

# MCP Server Setup (Windows PowerShell)
.\scripts\setup-mcp.ps1
```

### 2. Projekt anpassen

```bash
# Projektname in pubspec.yaml anpassen
# name: my_flutter_app
# description: A new Flutter project with Context Engineering

# Optional: Android Package Name anpassen
# android/app/build.gradle: applicationId "com.example.my_flutter_app"

# Optional: iOS Bundle Identifier anpassen  
# ios/Runner.xcodeproj/project.pbxproj: PRODUCT_BUNDLE_IDENTIFIER

# Flutter Dependencies installieren
flutter pub get

# Projekt validieren
flutter analyze
```

### 3. VS Code mit Flutter Extensions öffnen

```bash
code .
```

### 4. GitHub Copilot Instructions aktivieren

Die neuen GitHub Copilot Instructions werden automatisch erkannt:

- **Automatische Aktivierung**: `.github/copilot-instructions.md` wird von VS Code automatisch geladen
- **Spezielle Instructions**: Files in `.github/instructions/` werden basierend auf `applyTo`-Patterns angewendet
- **Setting aktivieren** (optional): `"github.copilot.chat.codeGeneration.useInstructionFiles": true`
- **Detaillierte Anleitung**: Siehe `.github/README.md` für vollständige Dokumentation

### 5. Mit Flutter-Entwicklung beginnen

1. Nutzen Sie die vorhandenen `templates/` für neue Widgets und Screens
2. Verwenden Sie `@workspace` um Flutter-Features zu analysieren
3. Lassen Sie den Agent Flutter-Implementierungspläne erstellen
4. Nutzen Sie Hot Reload für schnelle Iteration (`flutter run`)
5. Instructions werden automatisch basierend auf Datei-Kontext angewendet
6. Referenzieren Sie die Beispiele in `examples/` für bewährte Patterns

## 🎯 GitHub Copilot Instructions Struktur

### Neue VS Code-konforme Organisation

Dieses Template verwendet die **offizielle GitHub Copilot Instructions Struktur** basierend auf der [VS Code Dokumentation](https://code.visualstudio.com/docs/copilot/copilot-customization):

#### Automatische Instructions

- **`.github/copilot-instructions.md`** - Haupt-Instructions für alle Flutter-Projekte
- **Automatische Erkennung** durch VS Code ohne zusätzliche Konfiguration
- **Cross-Platform Support** für VS Code, Visual Studio und GitHub.com

#### Spezialisierte Instructions (applyTo-Patterns)

- **`widget-development.instructions.md`** → Gilt für `lib/**/*.dart` (UI-Entwicklung)
- **`testing.instructions.md`** → Gilt für `test/**/*.dart` (Test-Entwicklung)
- **`security.instructions.md`** → Gilt für `lib/**/*.dart` (Security-Guidelines)
- **`performance-deployment.instructions.md`** → Gilt für alle Dateien (Performance & CI/CD)

#### Vorteile für Context Engineering

- **🎯 Intelligente Anwendung**: Instructions werden nur für relevante Dateien geladen
- **📝 Modulare Organisation**: Trennung nach Fachbereichen für bessere Wartbarkeit
- **🔄 Referenzierung**: Instructions können sich gegenseitig referenzieren
- **👥 Team-Kollaboration**: Versioniert, dokumentiert und einfach erweiterbar

## 🔧 MCP Server Integration für Flutter

Dieses Template integriert die besten MCP Server für Flutter-Entwicklung:

### 🗃️ Backend & Datenbanken

- **Firebase MCP** - Firestore, Authentication, Cloud Functions
- **Supabase MCP** - PostgreSQL Backend as a Service
- **SQLite MCP** - Lokale Datenbank für Flutter Apps
- **MongoDB MCP** - NoSQL Database für komplexe Datenstrukturen

### 🌐 API & Web Services

- **HTTP Request MCP** - REST API-Integration
- **GraphQL MCP** - GraphQL API-Verbindungen
- **WebSocket MCP** - Real-time Kommunikation
- **OpenAPI MCP** - Automatische API-Client Generation

### 📱 Mobile-spezifische Services

- **Push Notifications MCP** - FCM & Apple Push Integration
- **Analytics MCP** - Firebase Analytics, Crashlytics
- **Payment MCP** - Stripe, PayPal Integration
- **Maps MCP** - Google Maps, Apple Maps Integration

### 🤖 AI & ML für Mobile

- **OpenAI MCP** - ChatGPT Integration in Flutter Apps
- **TensorFlow Lite MCP** - On-device ML Models
- **Google ML Kit MCP** - Text Recognition, Face Detection
- **Hugging Face MCP** - ML Model Integration

### 📝 Entwicklungstools

- **Flutter Doctor MCP** - Environment Validation
- **Pub Dev MCP** - Dependency Management
- **App Store Connect MCP** - iOS App Store Integration
- **Play Console MCP** - Google Play Store Integration

Vollständige Liste in [`docs/MCP_SERVERS.md`](docs/MCP_SERVERS.md)

## 🎯 Flutter-optimierte Agent-Workflows

### GitHub Copilot Chat-Modi für Flutter

- **`@workspace`** - Flutter App-weite Fragen und Architektur-Analyse
- **`@terminal`** - Flutter CLI-Kommandos und Build-Prozesse  
- **`@vscode`** - Flutter Extension spezifische Hilfe und Konfiguration

### Intelligente Instructions-Anwendung

Die Instructions werden **automatisch** basierend auf Ihrem Arbeitskontext angewendet:

#### Beim Arbeiten in `lib/` Dateien

- ✅ **widget-development.instructions.md** → Widget-Patterns, State Management
- ✅ **security.instructions.md** → Sichere Entwicklungspraktiken
- ✅ **copilot-instructions.md** → Grundlegende Flutter-Prinzipien

#### Beim Arbeiten in `test/` Dateien

- ✅ **testing.instructions.md** → Test-Strategien und Widget Tests
- ✅ **copilot-instructions.md** → Grundlegende Flutter-Prinzipien

#### Bei CI/CD und Performance-Fragen

- ✅ **performance-deployment.instructions.md** → Build-Optimierung, Analytics

### Flutter Widget-Entwicklung Workflow

1. **Widget-Analyse**: `@workspace` analysiert UI-Anforderungen
2. **Design System**: Agent berücksichtigt Material Design / Cupertino
3. **State Management**: Wahl zwischen StatelessWidget, StatefulWidget, Provider, Bloc
4. **Widget Testing**: Automatische Widget-Tests und Golden Tests
5. **Performance**: Optimization für 60fps und Memory Management

### Flutter App-Architektur Workflow

1. **Architektur-Pattern**: Clean Architecture, MVVM oder MVC für Flutter
2. **Dependency Injection**: get_it, injectable Setup
3. **Routing**: GoRouter, Auto Route Konfiguration
4. **State Management**: Provider, Bloc, Riverpod Implementation
5. **Data Layer**: Repository Pattern, API Integration, Local Storage

### Flutter Deployment Workflow

1. **Build Configuration**: Android/iOS spezifische Builds
2. **Code Signing**: Certificates und Provisioning Profiles
3. **Store Preparation**: App Store Connect, Google Play Console
4. **CI/CD**: GitHub Actions für Flutter Apps
5. **Monitoring**: Crashlytics, Analytics Integration

## 🔒 Flutter Best Practices

### Context Engineering Prinzipien für Flutter

- **Flutter-spezifisch sein**: Klare Widget-Hierarchien und State Management
- **Material/Cupertino Design**: Plattform-native UI-Patterns verwenden
- **Performance optimieren**: Widget-Rebuilds minimieren, Lazy Loading
- **Testing integrieren**: Unit Tests, Widget Tests, Integration Tests
- **Platform Features nutzen**: Native iOS/Android Funktionalität über Plugins
- **Instructions-Struktur nutzen**: Modulare Organization für bessere Wartbarkeit

### Flutter Agent-Interaktion Tipps

- **Kontext-bewusst arbeiten**: Instructions werden automatisch für relevante Dateien angewendet
- **Spezifische Referenzen**: "Befolge die Widget Development Instructions"
- **Flutter-Kontext geben**: Flutter Version und Ziel-Plattformen erwähnen
- **Beispiele nutzen**: Referenzieren Sie Flutter-Beispiele im `examples/` Ordner
- **Modulare Instructions**: Nutzen Sie spezialisierte Instructions für verschiedene Aufgaben
- **applyTo-Patterns**: Verstehen Sie, welche Instructions für welche Dateien gelten

## 📚 Flutter-spezifische Ressourcen

### Offizielle Dokumentation

- [Flutter Documentation](https://flutter.dev/docs) - Offizielle Flutter Docs
- [Dart Language Guide](https://dart.dev/guides) - Dart Programmierung
- [Material Design 3](https://m3.material.io/) - Design System für Flutter
- [Flutter Widget Catalog](https://flutter.dev/docs/development/ui/widgets) - Alle verfügbaren Widgets

### State Management

- [Provider Documentation](https://pub.dev/packages/provider) - Einfaches State Management
- [Bloc Library](https://bloclibrary.dev/) - Business Logic Component Pattern
- [Riverpod](https://riverpod.dev/) - Advanced Provider für Dependency Injection
- [GetX](https://pub.dev/packages/get) - Lightweight State Management

### Flutter Packages

- [pub.dev](https://pub.dev/) - Official Dart Package Repository
- [HTTP Package](https://pub.dev/packages/http) - HTTP Client für API-Calls
- [SharedPreferences](https://pub.dev/packages/shared_preferences) - Lokale Datenspeicherung
- [SQLite](https://pub.dev/packages/sqflite) - Lokale Datenbank

### Testing in Flutter

- [Flutter Testing](https://flutter.dev/docs/testing) - Offizielle Testing-Dokumentation
- [Widget Testing](https://flutter.dev/docs/cookbook/testing/widget) - UI-Component Tests
- [Integration Testing](https://flutter.dev/docs/testing/integration-tests) - End-to-End Tests
- [Mockito](https://pub.dev/packages/mockito) - Mocking für Unit Tests

### Performance & Optimization

- [Flutter Performance](https://flutter.dev/docs/perf) - Performance Best Practices
- [Build Modes](https://flutter.dev/docs/testing/build-modes) - Debug vs Release Builds
- [Memory Management](https://flutter.dev/docs/development/tools/devtools/memory) - Speicher-Optimierung
- [App Size Optimization](https://flutter.dev/docs/perf/app-size) - App-Größe reduzieren

### Deployment

- [Android Deployment](https://flutter.dev/docs/deployment/android) - Google Play Store
- [iOS Deployment](https://flutter.dev/docs/deployment/ios) - Apple App Store
- [Web Deployment](https://flutter.dev/docs/deployment/web) - Web-Apps mit Flutter
- [CI/CD with GitHub Actions](https://flutter.dev/docs/deployment/cd) - Kontinuierliche Bereitstellung

## 🚀 Was ist neu in dieser Version?

### ✨ GitHub Copilot Instructions Optimierung (v2.0)

- **🎯 VS Code Standard-Konformität**: Migration zu `.github/copilot-instructions.md`
- **📁 Modulare Instructions-Struktur**: Aufgeteilte Instructions nach Fachbereichen
- **🔧 Intelligente Anwendung**: `applyTo`-Patterns für spezifische Dateitypen
- **⚡ Bessere Performance**: Selektives Laden relevanter Instructions
- **👥 Team-Kollaboration**: Versionierte und dokumentierte Instructions

### 🔄 Migration von Legacy-Struktur

Die ursprüngliche `.copilot/custom-instructions.md` wurde optimiert zu:

- **Automatische Erkennung** durch VS Code
- **Spezialisierte Instructions** für Widgets, Testing, Security, Performance
- **Front Matter Support** für Metadata und Scope-Kontrolle
- **Cross-Platform Unterstützung** für VS Code, Visual Studio, GitHub.com

Vollständige Details zur neuen Struktur finden Sie in [`.github/README.md`](.github/README.md).

## 🤝 Contributing

1. Fork das Repository
2. Erstellen Sie einen Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Committen Sie Ihre Änderungen (`git commit -m 'Add some AmazingFeature'`)
4. Pushen Sie den Branch (`git push origin feature/AmazingFeature`)
5. Öffnen Sie einen Pull Request

## 📄 Lizenz

Dieses Projekt steht unter der MIT Lizenz - siehe [LICENSE](LICENSE) Datei für Details.

## 🙏 Inspiration & Credits

Basiert auf den Konzepten von [coleam00/context-engineering-intro](https://github.com/coleam00/context-engineering-intro), speziell angepasst für Flutter-Entwicklung mit GitHub Copilot Agent Mode und moderner MCP-Integration.

### Flutter Community Ressourcen

- [Flutter Community](https://flutter.dev/community) - Offizielle Flutter Community
- [Flutter Awesome](https://github.com/Solido/awesome-flutter) - Kuratierte Liste von Flutter Ressourcen
- [Flutter Samples](https://github.com/flutter/samples) - Offizielle Flutter Beispiele
- [Flutter Cookbook](https://flutter.dev/docs/cookbook) - Praktische Flutter Rezepte

### Inspiration für Mobile UI/UX

- [Material Design](https://material.io/design) - Google Design System
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/) - Apple Design Guidelines
- [Flutter Gallery](https://gallery.flutter.dev/) - Flutter Design Showcase
- [Dribbble Flutter](https://dribbble.com/tags/flutter) - Flutter UI Inspirationen
