# Flutter Context Engineering - Copilot Instructions

## 🎯 Primäre Direktiven

Als GitHub Copilot Agent für Flutter-Entwicklung befolgen Sie diese fundamentalen Regeln:

### Flutter-Projektverständnis

- **IMMER** die Flutter-Projektstruktur (`lib/`, `pubspec.yaml`, `android/`, `ios/`) analysieren
- Bestehende Widget-Patterns aus `examples/widgets/` verstehen und anwenden
- Flutter/Dart Versionen und Zielplattformen berücksichtigen
- Konsistenz mit vorhandenem State Management beibehalten

### Context-Driven Development

- Nutzen Sie Flutter-spezifische MCP Server für Backend-Integration
- Verwenden Sie Widget-Templates aus `templates/` als Ausgangspunkt
- Beziehen Sie sich auf `docs/PATTERNS.md` für bewährte Praktiken
- Berücksichtigen Sie die Projektdokumentation in `docs/`

### Qualitätsstandards

- Generieren Sie IMMER Widget Tests für neue Widgets
- Implementieren Sie Error Handling für async/await Operationen
- Optimieren Sie für Performance (const constructors, RepaintBoundary)
- Folgen Sie Flutter Security Best Practices

## 🏗️ Architektur-Richtlinien

### Projektstruktur

```text
lib/
├── core/           # Core utilities, constants
├── data/           # Data layer (repositories, models)
├── domain/         # Business logic (entities, use cases)
├── presentation/   # UI layer (screens, widgets)
├── shared/         # Shared widgets and utilities
└── main.dart       # App entry point
```

### Clean Architecture

- Trennen Sie Data, Domain und Presentation Layer
- Implementieren Sie Repository Pattern
- Verwenden Sie Use Cases für komplexe Business Logic

## 🔐 Security & Best Practices

### Security Checklist

- [ ] Keine API Keys im Code
- [ ] Input Validation implementiert
- [ ] Sichere HTTP-Verbindungen (Certificate Pinning)
- [ ] Biometrie/Secure Storage für sensitive Daten
- [ ] Proper Error Messages (keine sensitive Infos)

### Code Quality

- Befolgen Sie Dart/Flutter Linting Rules
- Implementieren Sie umfassende Tests (Unit, Widget, Integration)
- Dokumentieren Sie komplexe Logik inline
- Verwenden Sie meaningful Variable/Method Namen

---

**Verwendung**: Diese Instructions sind automatisch aktiv für GitHub Copilot in diesem Projekt.
