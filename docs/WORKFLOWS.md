# Flutter-spezifische Workflows für GitHub Copilot

## 🚀 Flutter-Entwicklung Workflows mit GitHub Copilot Chatmodes

### 🎯 Verfügbare GitHub Copilot Chatmodes für Flutter

Dieses Template nutzt GitHub Copilot's native Chatmodes und erweiterte Community Chatmodes:

**Native GitHub Copilot Chatmodes:**
- `@workspace` - Flutter App-weite Kontext-Fragen und Projektanalyse
- `@terminal` - Flutter CLI-Kommandos und Build-Prozesse
- `@vscode` - Flutter Extension spezifische Hilfe

**Community Chatmodes (aus awesome-copilot):**
- **PRD Chatmode** - Erstelle Product Requirements Documents für Flutter Features
- **Feature Request Chatmode** - Strukturiere Feature-Anforderungen (bereits implementiert)
- **Specification Chatmode** - Detaillierte technische Spezifikationen
- **Implementation Plan Chatmode** - Schritt-für-Schritt Implementierungspläne
- **Accessibility Chatmode** - WCAG-konforme Flutter UI-Entwicklung

### Flutter Widget-Entwicklung Workflow

**Schritt 1: Widget-Analyse**
```bash
@workspace Analysiere die UI-Anforderungen für [Widget-Name]
```

Der Agent analysiert:
- Bestehende Design-Patterns im Projekt
- Material Design 3 Guidelines
- Theme-Integration
- Accessibility-Anforderungen (mit Accessibility Chatmode)

**Schritt 2: Widget-Struktur planen**
```dart
// Agent erstellt Struktur-Vorschlag mit GitHub Copilot
class MyCustomWidget extends StatelessWidget {
  const MyCustomWidget({
    super.key,
    required this.data,
    this.onPressed,
    this.variant = WidgetVariant.primary,
  });
  
  // Properties und Build-Methode
}
```

**Schritt 3: Implementation mit Tests**
- Widget-Code mit const constructors
- Responsive Design für verschiedene Screen-Größen
- Widget Tests für verschiedene States
- Integration Tests für User-Interaktionen
- Accessibility-Tests (WCAG 2.1 Compliance)

**GitHub Copilot Integration:**
- `@workspace` für Widget-Pattern Analyse
- `@terminal` für Flutter Test-Kommandos
- **Accessibility Chatmode** für barrierefreie UI-Komponenten

### Flutter App-Architektur Workflow

**Schritt 1: Architektur-Pattern wählen**
```bash
@workspace Empfehle Architektur-Pattern für eine [App-Typ] mit [Features]
```

**Clean Architecture für Flutter:**
```
lib/
├── core/              # Shared utilities
├── features/          # Feature modules
│   ├── auth/
│   │   ├── domain/    # Business logic
│   │   ├── data/      # Data sources
│   │   └── presentation/ # UI layer
└── shared/            # Shared components
```

**Schritt 2: State Management Setup**
- Provider für einfache Apps
- Bloc für complex state management
- Riverpod für advanced dependency injection
- GetX für lightweight solutions

**Schritt 3: Dependency Injection**
```dart
// Service Locator Pattern
void configureDependencies() {
  GetIt.instance.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      localDataSource: GetIt.instance(),
      remoteDataSource: GetIt.instance(),
    ),
  );
}
```

### Flutter Backend-Integration Workflow

**API-Integration mit HTTP**
```dart
class ApiService {
  static const String baseUrl = 'https://api.example.com';
  
  Future<List<User>> getUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => User.fromJson(json)).toList();
    } else {
      throw ApiException('Failed to load users');
    }
  }
}
```

**MCP Server für Backend:**
- Firebase MCP für Firestore und Auth
- Supabase MCP für PostgreSQL Backend
- GraphQL MCP für Graph APIs
- OpenAPI MCP für REST APIs
2. **Stakeholder-Mapping**: Identifikation von Zielgruppen und Personas
3. **Anforderungssammlung**: Strukturierte Erfassung funktionaler und nicht-funktionaler Anforderungen
4. **User Story Generation**: Automatische Erstellung testbarer User Stories mit eindeutigen IDs
5. **GitHub Integration**: Optional Erstellung von GitHub Issues basierend auf User Stories

**Vorteile:**

- Vollständige Produktdokumentation
- Testbare User Stories mit Akzeptanzkriterien
- Technische Machbarkeitsanalyse
- Integration mit GitHub Issues
- Metriken und Erfolgskriterien

### GitHub Copilot Chat Workflows für Flutter

**Native GitHub Copilot Chat:**

- `@workspace` - Flutter App-weite Kontext-Fragen und Projektanalyse
- `@terminal` - Flutter CLI-Kommandos und Build-Prozesse  
- `@vscode` - Flutter Extension spezifische Hilfe

**Bereitgestellte Community Chatmodes:**

- **PRD Chatmode** - Product Requirements Documents für Flutter Features
- **Specification Chatmode** - Detaillierte technische Spezifikationen
- **Implementation Plan Chatmode** - Schritt-für-Schritt Implementierungspläne
- **Accessibility Chatmode** - WCAG-konforme Flutter UI-Entwicklung
- **Simple App Idea Generator** - Brainstorming für Flutter App-Ideen

### Flutter Feature-Entwicklung Workflow

**Schritt 1: Idee entwickeln (mit Community Chatmode)**

```
Simple App Idea Generator: Brainstorme neue Flutter App-Idee
```

**Schritt 2: Anforderungen dokumentieren (mit Community Chatmode)**

```
PRD Chatmode: Erstelle Product Requirements Document
```

**Schritt 3: Technische Spezifikation (mit Community Chatmode)**

```
Specification Chatmode: Erstelle detaillierte technische Spezifikation
```

**Schritt 4: Implementierungsplan (mit Community Chatmode)**

```
Implementation Plan Chatmode: Generiere Schritt-für-Schritt Plan
```

**Schritt 5: Flutter-spezifische Implementierung (mit nativen Copilot Chat)**

```
@workspace Analysiere aktuelle Flutter-Projektstruktur
@workspace Implementiere Widget basierend auf Spezifikation
@terminal flutter test - Führe Tests aus
@vscode Konfiguriere Flutter Extension Settings
```

#### Quality Assurance Pipeline

**Automatisierte QA mit GitHub Copilot:**

```bash
# Requirements Validation
@workspace Validiere Vollständigkeit der Anforderungen
@workspace Überprüfe User Stories auf Testbarkeit

# Implementation Review  
@workspace Prüfe Code gegen AGENT_RULES.md
@workspace Validiere Pattern-Konsistenz mit docs/PATTERNS.md
@workspace Teste MCP Server Integration

# Documentation Review
@workspace Aktualisiere README basierend auf neuen Features
@workspace Generiere API-Dokumentation
@workspace Erstelle Usage-Examples für neue Features
```

#### Best Practices für Chatmode-Integration

**Kontext-Management:**

- Nutze GitHub Copilot Community Chatmodes für spezielle Anforderungen
- Verwende native `@workspace` für technische Implementierung
- Referenziere spezifische Template-Dateien für konsistente Ausgaben

**Effizienz-Tipps:**

- Starte mit dem spezifischsten Chatmode für deine Aufgabe
- Nutze die automatische GitHub Issues-Erstellung verfügbarer Chatmodes
- Integriere MCP Server-Empfehlungen in die Implementierungsplanung
- Dokumentiere Entscheidungen direkt in den generierten Dokumenten

**Qualitätssicherung:**

- Validiere alle Chatmode-Ausgaben gegen bestehende Projektstandards
- Nutze die eingebauten Checklisten der Templates
- Stelle sicher, dass User Stories testbar und messbar sind
- Verknüpfe Feature Requests mit konkreten Implementierungsbeispielen

## Agent-optimierte Entwicklungsworkflows

### 🚀 Quick Start Workflow
1. **Projekt initialisieren**
   ```
   @workspace Führe Setup-Skript aus: .\scripts\setup-mcp.ps1
   ```

2. **Validierung durchführen**
   ```
   @workspace Validiere Projekt: .\scripts\validate-project.ps1 -Verbose
   ```

3. **Feature entwickeln**
   ```
   @workspace Erstelle Feature basierend auf templates/feature-request.md
   ```

### 🔄 Iterative Entwicklung

#### Context-driven Feature Development
1. **Kontext sammeln**
   - `@workspace Analysiere aktuelle Projektstruktur`
   - `@workspace Zeige verfügbare MCP Server und deren Capabilities`
   - `@workspace Prüfe bestehende Patterns in docs/PATTERNS.md`

2. **Feature planen**
   - Nutze `templates/feature-request.md` für strukturierte Planung
   - `@workspace Erstelle Implementierungsplan basierend auf AGENT_RULES.md`
   - `@workspace Schlage Code-Pattern vor basierend auf examples/`

3. **Implementierung**
   - `@workspace Implementiere Service-Layer mit MCP Integration`
   - `@workspace Erstelle Tests basierend auf examples/testing/`
   - `@workspace Aktualisiere Dokumentation`

4. **Validierung**
   - `@workspace Führe validate-project.ps1 aus`
   - `@workspace Prüfe Code gegen AGENT_RULES.md`
   - `@workspace Teste MCP Server Integration`

### 🐛 Bug-Fixing Workflow

1. **Problem analysieren**
   ```
   @workspace Analysiere Bug-Report: templates/bug-report.md
   @workspace Identifiziere betroffene Komponenten
   @workspace Prüfe relevante Tests in examples/testing/
   ```

2. **Root Cause Analysis**
   ```
   @workspace Suche ähnliche Patterns in Code-Beispielen
   @workspace Prüfe MCP Server Logs (falls relevant)
   @workspace Analysiere Dependencies und Konfiguration
   ```

3. **Fix implementieren**
   ```
   @workspace Erstelle Fix basierend auf Best Practices
   @workspace Schreibe Tests für Regression Prevention
   @workspace Aktualisiere relevante Dokumentation
   ```

### 🔧 Refactoring Workflow

1. **Code Analyse**
   ```
   @workspace Identifiziere Refactoring-Kandidaten
   @workspace Prüfe aktuelle Patterns gegen docs/PATTERNS.md
   @workspace Analysiere Performance-Implikationen
   ```

2. **Refactoring planen**
   ```
   @workspace Erstelle Refactoring-Plan mit Backward Compatibility
   @workspace Identifiziere erforderliche Test-Updates
   @workspace Plane schrittweise Migration
   ```

3. **Durchführung**
   ```
   @workspace Implementiere Refactoring schrittweise
   @workspace Aktualisiere Tests parallel
   @workspace Validiere jede Iteration
   ```

## MCP-Server-optimierte Workflows

### 📁 Filesystem Operations
```
@workspace Nutze MCP Filesystem Server um:
- Projektdateien zu analysieren
- Code-Templates zu generieren
- Konfigurationsdateien zu verwalten
- Dokumentation zu aktualisieren
```

### 🗄️ Database Operations
```
@workspace Nutze MCP SQLite Server um:
- Schema-Migrationen zu erstellen
- Test-Daten zu generieren
- Query-Performance zu analysieren
- Backup-Strategien zu implementieren
```

### 🐙 GitHub Integration
```
@workspace Nutze MCP GitHub Server um:
- Issues und Pull Requests zu verwalten
- Code Reviews zu automatisieren
- Release Notes zu generieren
- Contributor-Statistiken zu erstellen
```

### 🔍 Web Research
```
@workspace Nutze MCP Brave Search um:
- Best Practices zu recherchieren
- Dokumentation zu finden
- Dependency-Updates zu prüfen
- Security-Advisories zu überwachen
```

### 🧠 Memory Management
```
@workspace Nutze MCP Memory Server um:
- Projekt-Kontext zu speichern
- Code-Entscheidungen zu dokumentieren
- Pattern-Bibliothek zu erweitern
- Lessons Learned zu sammeln
```

## Spezielle Workflows

### 🎯 Performance Optimization

1. **Baseline erstellen**
   ```
   @workspace Analysiere aktuelle Performance-Metriken
   @workspace Identifiziere Bottlenecks mit MCP Profiling
   @workspace Dokumentiere Baseline in Memory Server
   ```

2. **Optimierung durchführen**
   ```
   @workspace Implementiere Performance-Verbesserungen
   @workspace Nutze Database Server für Query-Optimierung
   @workspace Teste mit examples/testing/ Patterns
   ```

3. **Validierung**
   ```
   @workspace Vergleiche Performance vor/nach Optimierung
   @workspace Aktualisiere docs/PATTERNS.md mit neuen Erkenntnissen
   @workspace Dokumentiere Lessons Learned
   ```

### 🔐 Security Review

1. **Security Scan**
   ```
   @workspace Prüfe Code gegen Security-Patterns
   @workspace Analysiere Dependencies auf Vulnerabilities
   @workspace Nutze GitHub Server für Security Advisories
   ```

2. **Vulnerability Assessment**
   ```
   @workspace Identifiziere potentielle Schwachstellen
   @workspace Prüfe Input-Validierung und Output-Encoding
   @workspace Analysiere Authentication/Authorization
   ```

3. **Remediation**
   ```
   @workspace Implementiere Security-Fixes
   @workspace Aktualisiere Security-Patterns in docs/
   @workspace Erstelle Security-Tests
   ```

### 📚 Documentation Workflow

1. **Content Audit**
   ```
   @workspace Analysiere bestehende Dokumentation
   @workspace Identifiziere Lücken und veraltete Inhalte
   @workspace Prüfe Konsistenz zwischen Code und Docs
   ```

2. **Content Creation**
   ```
   @workspace Generiere Code-Dokumentation automatisch
   @workspace Erstelle Tutorials basierend auf examples/
   @workspace Aktualisiere API-Dokumentation
   ```

3. **Quality Assurance**
   ```
   @workspace Validiere Links und Referenzen
   @workspace Prüfe Markdown-Syntax und -Formatierung
   @workspace Teste Code-Beispiele in Dokumentation
   ```

## Automatisierung und CI/CD

### 🔄 Continuous Integration

```yaml
# .github/workflows/validation.yml
name: Template Validation

on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup PowerShell
        uses: microsoft/setup-msbuild@v1
      - name: Run Validation
        run: pwsh ./scripts/validate-project.ps1 -OutputFormat json
      - name: Upload Results
        uses: actions/upload-artifact@v3
        with:
          name: validation-results
          path: validation-results-*.json
```

### 🚀 Automated Deployment

```yaml
# .github/workflows/deploy.yml
name: Deploy Template

on:
  release:
    types: [published]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup MCP Servers
        run: pwsh ./scripts/setup-mcp.ps1 -ServerType all
      - name: Run Full Validation
        run: pwsh ./scripts/validate-project.ps1 -Fix
      - name: Package Template
        run: |
          zip -r context-engineering-template.zip . \
            -x "*.git*" "node_modules/*" "*.log"
```

## Best Practices für Agent-Workflows

### 💡 Kontext-Management
- Nutze `@workspace` für projektweite Kontexterfassung
- Referenziere spezifische Dateien für fokussierte Analyse
- Kombiniere MCP Server für erweiterte Capabilities
- Dokumentiere Entscheidungen im Memory Server

### 🎯 Effizienz-Tipps
- Verwende Templates für wiederkehrende Aufgaben
- Nutze Patterns aus docs/PATTERNS.md als Basis
- Kombiniere mehrere MCP Server für komplexe Workflows
- Automatisiere Routine-Validierungen

### 🔍 Debugging-Strategien
- Nutze verbose Ausgaben bei Problemen
- Prüfe MCP Server Logs für Integration-Issues
- Verwende validate-project.ps1 für systematische Fehlersuche
- Dokumentiere Lösungen für zukünftige Referenz

### 📈 Kontinuierliche Verbesserung
- Sammle Feedback zu Workflow-Effizienz
- Erweitere Patterns basierend auf Erfahrungen
- Optimiere MCP Server Konfigurationen
- Aktualisiere Agent-Regeln basierend auf Lessons Learned
