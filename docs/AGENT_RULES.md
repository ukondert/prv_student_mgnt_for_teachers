# Flutter Agent-Regeln für GitHub Copilot Context Engineering

> **📋 Hinweis**: Diese Datei dient als Referenz. Die aktiven Custom Instructions für GitHub Copilot finden Sie in der optimierten `.github/` Struktur.

## 🎯 Zweck dieser Dokumentation

Diese Datei dokumentiert die Regeln und Richtlinien für Flutter-Entwicklung mit GitHub Copilot Context Engineering. Der Inhalt wurde in die offizielle GitHub Copilot Instructions Struktur migriert.

## 📁 Neue optimierte Struktur

### Basierend auf VS Code Best Practices

Die Instructions wurden entsprechend der [offiziellen VS Code Dokumentation](https://code.visualstudio.com/docs/copilot/copilot-customization) umstrukturiert:

- **`.github/copilot-instructions.md`** - Haupt-Instructions (automatisch aktiv)
- **`.github/instructions/`** - Spezialisierte Instructions Files mit applyTo-Patterns

### Vorteile der neuen Struktur

- **Automatische Aktivierung** durch VS Code Standard-Konventionen
- **Modulare Organisation** nach Fachbereichen (Widgets, Testing, Security, etc.)
- **Intelligente Anwendung** durch applyTo-Glob-Patterns
- **Team-Kollaboration** durch Versionierung im Git-Repository

## � Verwandte Dateien

- **`.github/copilot-instructions.md`** - Haupt GitHub Copilot Instructions
- **`.github/instructions/`** - Spezialisierte Instructions Files
- **`.github/README.md`** - Detaillierte Anleitung zur neuen Struktur
- **`docs/PATTERNS.md`** - Flutter Design Patterns und Best Practices
- **`docs/WORKFLOWS.md`** - Entwicklungsworkflows
- **`examples/`** - Code-Beispiele und Templates

## 🔄 Migration Details

### Von `.copilot/custom-instructions.md` zu `.github/` Struktur

Der ursprüngliche monolithische Ansatz wurde in eine modulare, VS Code-konforme Struktur überführt:

1. **Haupt-Instructions**: Grundlegende Flutter-Prinzipien
2. **Widget Development**: UI-spezifische Patterns und Best Practices
3. **Testing**: Test-Strategien und -Patterns
4. **Performance & Deployment**: Optimierung und CI/CD
5. **Security**: Sicherheitsrichtlinien und Best Practices

### Context Engineering Optimierung

- **applyTo-Patterns**: Jede Instructions-Datei wird nur für relevante Dateien angewendet
- **Referenzierung**: Instructions können sich gegenseitig referenzieren
- **Scope-Kontrolle**: Automatische Anwendung basierend auf Datei-Kontext

---

**📚 Für aktuelle Nutzung**: Verwenden Sie die neue `.github/` Struktur für optimale GitHub Copilot Integration.
