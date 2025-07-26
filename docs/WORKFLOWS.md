# 1. Flutter-spezifische Workflows für GitHub Copilot

## 1.1. Inhaltsverzeichnis

- [1. Flutter-spezifische Workflows für GitHub Copilot](#1-flutter-spezifische-workflows-für-github-copilot)
  - [1.1. Inhaltsverzeichnis](#11-inhaltsverzeichnis)
  - [1.2. 🚀 Flutter-Entwicklung Workflows mit GitHub Copilot Chatmodes](#12--flutter-entwicklung-workflows-mit-github-copilot-chatmodes)
    - [1.2.1. 🎯 Verfügbare GitHub Copilot Chatmodes für Flutter](#121--verfügbare-github-copilot-chatmodes-für-flutter)
    - [1.2.2. 🚀 Von der Idee zur Implementierung: Der geführte Chatmode-Workflow](#122--von-der-idee-zur-implementierung-der-geführte-chatmode-workflow)
    - [1.2.3. Flutter Widget-Entwicklung Workflow](#123-flutter-widget-entwicklung-workflow)
    - [1.2.4. Flutter App-Architektur Workflow](#124-flutter-app-architektur-workflow)
    - [1.2.5. Flutter Backend-Integration Workflow](#125-flutter-backend-integration-workflow)
  - [1.3. Agent-optimierte Entwicklungsworkflows](#13-agent-optimierte-entwicklungsworkflows)
    - [1.3.1. 🚀 Quick Start Workflow](#131--quick-start-workflow)
    - [1.3.2. 🔄 Iterative Entwicklung](#132--iterative-entwicklung)
    - [1.3.3. 🐛 Bug-Fixing Workflow](#133--bug-fixing-workflow)
    - [1.3.4. 🔧 Refactoring Workflow](#134--refactoring-workflow)
  - [1.4. MCP-Server-optimierte Workflows](#14-mcp-server-optimierte-workflows)
    - [1.4.1. 📁 Filesystem Operations](#141--filesystem-operations)
    - [1.4.2. 🗄️ Database Operations](#142-️-database-operations)
    - [1.4.3. 🐙 GitHub Integration](#143--github-integration)
    - [1.4.4. 🔍 Web Research](#144--web-research)
    - [1.4.5. 🧠 Memory Management](#145--memory-management)
  - [1.5. Spezielle Workflows](#15-spezielle-workflows)
    - [1.5.1. 🎯 Performance Optimization](#151--performance-optimization)
    - [1.5.2. 🔐 Security Review](#152--security-review)
    - [1.5.3. 📚 Documentation Workflow](#153--documentation-workflow)
  - [1.6. Automatisierung und CI/CD](#16-automatisierung-und-cicd)
    - [1.6.1. 🔄 Continuous Integration](#161--continuous-integration)
    - [1.6.2. 🚀 Automated Deployment](#162--automated-deployment)
  - [1.7. Best Practices für Agent-Workflows](#17-best-practices-für-agent-workflows)
    - [1.7.1. 💡 Kontext-Management](#171--kontext-management)
    - [1.7.2. 🎯 Effizienz-Tipps](#172--effizienz-tipps)
    - [1.7.3. 🔍 Debugging-Strategien](#173--debugging-strategien)
    - [1.7.4. 📈 Kontinuierliche Verbesserung](#174--kontinuierliche-verbesserung)


## 1.2. 🚀 Flutter-Entwicklung Workflows mit GitHub Copilot Chatmodes

### 1.2.1. 🎯 Verfügbare GitHub Copilot Chatmodes für Flutter

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

### 1.2.2. 🚀 Von der Idee zur Implementierung: Der geführte Chatmode-Workflow

Die bereitgestellten Chatmodes sind so konzipiert, dass sie einen strukturierten und nachvollziehbaren Prozess von der ersten Idee bis zum ausführbaren Code ermöglichen. Dieser Workflow stellt sicher, dass jede Phase auf der vorherigen aufbaut, was die Klarheit erhöht und Mehrdeutigkeiten für Entwickler und KI-Agenten reduziert.

**Workflow-Übersicht:**
`(Idee)` -> `Product Requirements Document (PRD)` -> `Feature Request` -> `Technische Spezifikation` -> `Implementierungsplan` -> `Code`

---

#### **Schritt 0: Eine Idee finden (Optional)**

Falls noch keine konkrete Idee für eine App oder ein Feature existiert, kann dieser Chatmode als kreativer Impulsgeber dienen.

- **Ziel**: Eine einfache, umsetzbare App-Idee generieren, die als Grundlage für die weiteren Schritte dient.
- **Chatmode**: `simple-app-idea-generator`.
- **Beispiel-Prompt**:
  ```
  simple-app-idea-generator: Generiere eine Idee für eine mobile App, die Studenten beim Lernen hilft.
  ```
- **Ergebnis**: Eine kurze, prägnante Beschreibung einer App-Idee. Diese kann direkt als Input für den nächsten Schritt verwendet werden.

#### **Schritt 1: Das Produkt definieren (Das "Warum")**

Am Anfang steht die Vision für das gesamte Produkt. Dieser Schritt dient dazu, den übergeordneten Rahmen, die Ziele und die Zielgruppe zu definieren.

- **Ziel**: Eine umfassende Produktvision erstellen, die den Business Value, die Zielgruppe, die Erfolgsmetriken und die wichtigsten Feature-Bereiche umreißt.
- **Chatmode**: `PRD Chatmode`.
- **Beispiel-Prompt**:
  ```
  PRD Chatmode: Erstelle ein Product Requirements Document für eine neue Lern-App für Studenten.
  ```
- **Ergebnis**: Eine `docs/prd/prd-learning-app.md` Datei. Dieses Dokument ist die "Single Source of Truth" für die Produktstrategie und dient als Grundlage für alle weiteren Detaillierungen.

---

#### **Schritt 2: Ein Feature konkretisieren (Das "Was")**

Nachdem das Gesamtprodukt definiert ist, wird ein einzelnes Feature aus dem PRD ausgewählt und detailliert ausgearbeitet.

- **Ziel**: Ein High-Level-Feature aus dem PRD in eine klare, verständliche und vollständige Anforderung mit User Stories und Akzeptanzkriterien umwandeln.
- **Chatmode**: `Feature Request Chatmode`.
- **Beispiel-Prompt**:
  ```
  Feature Request Chatmode: Erstelle einen detaillierten Feature Request für das 'User-Profil-System', das im PRD unter 'docs/prd/prd-learning-app.md' erwähnt wird. Die Benutzer sollen Namen, Profilbild und Biografie bearbeiten können.
  ```
- **Ergebnis**: Eine `docs/features/feature-request-user-profile.md` Datei. Dieses Dokument beschreibt ein spezifisches Feature im Detail.

---

#### **Schritt 3: Die technische Lösung entwerfen (Das "Wie")**

Sobald die Anforderungen für das Feature klar sind, wird die technische Umsetzung geplant.

- **Ziel**: Die funktionalen Anforderungen aus dem Feature Request in eine technische Blaupause übersetzen. Definiert Architekturentscheidungen, Datenmodelle, APIs und technische Constraints.
- **Chatmode**: `Specification Chatmode`.
- **Beispiel-Prompt**:
  ```
  Specification Chatmode: Erstelle eine technische Spezifikation basierend auf dem Feature Request unter 'docs/features/feature-request-user-profile.md'. Berücksichtige die Clean Architecture des Projekts und nutze den SQLite MCP Server für die lokale Speicherung.
  ```
- **Ergebnis**: Eine `spec/spec-design-user-profile.md` Datei. Diese stellt sicher, dass die technische Umsetzung die Anforderungen erfüllt und sich nahtlos in die bestehende Architektur einfügt.

---

#### **Schritt 4: Die Arbeit aufteilen (Die "Schritte")**

Mit der technischen Spezifikation als Leitfaden wird die Implementierung in konkrete, ausführbare Aufgaben zerlegt.

- **Ziel**: Die technische Spezifikation in eine Liste von atomaren, sequenziellen Aufgaben herunterbrechen, die von einem Entwickler oder einer KI direkt ausgeführt werden können.
- **Chatmode**: `Implementation Plan Chatmode`.
- **Beispiel-Prompt**:
  ```
  Implementation Plan Chatmode: Erstelle einen Implementierungsplan basierend auf der Spezifikation unter 'spec/spec-design-user-profile.md'. Liste alle zu erstellenden oder zu ändernden Dateien, die notwendigen Klassen und die zu schreibenden Tests auf.
  ```
- **Ergebnis**: Eine `plan/plan-feature-user-profile-1.md` Datei. Dieser Plan ist die direkte Anleitung für die Codierungsphase.

---

#### **Schritt 5: Die Implementierung durchführen (Der "Code")**

Mit dem detaillierten Plan kann nun die eigentliche Codierung beginnen. Hier kommen die nativen Copilot-Fähigkeiten zum Einsatz.

- **Ziel**: Den Implementierungsplan in funktionierenden, getesteten und dokumentierten Code umsetzen.
- **Tools**: `@workspace`, `@terminal`, Inline-Copilot.
- **Beispiel-Prompts**:
  ```
  @workspace Implementiere die 'UserProfileRepository'-Klasse gemäß dem Plan in 'plan/plan-feature-user-profile-1.md'.

  @workspace Erstelle die notwendigen Widget-Tests für das 'UserProfileScreen'.

  @terminal führe 'flutter test' aus, um alle neuen Tests zu validieren.
  ```
- **Ergebnis**: Ein vollständig implementiertes, getestetes und integriertes Feature, das den ursprünglichen Anforderungen entspricht.
// ...existing

Die bereitgestellten Chatmodes sind so konzipiert, dass sie einen strukturierten und nachvollziehbaren Prozess von der ersten Idee bis zum ausführbaren Code ermöglichen. Dieser Workflow stellt sicher, dass jede Phase auf der vorherigen aufbaut, was die Klarheit erhöht und Mehrdeutigkeiten für Entwickler und KI-Agenten reduziert.

**Workflow-Übersicht:**
`Idee` -> `Feature Request` -> `Technische Spezifikation` -> `Implementierungsplan` -> `Code`

#### **Schritt 1: Die Anforderung definieren (Das "Was")**

Am Anfang steht eine Idee oder ein Bedürfnis. Der erste Schritt ist, dies in eine strukturierte Anforderung zu überführen.

- **Ziel**: Eine vage Idee in eine klare, verständliche und vollständige Anforderung umwandeln. Klärt den Business Value, die Zielgruppe und die User Stories.
- **Chatmode**: `Feature Request Chatmode` (für einzelne Features) oder `PRD Chatmode` (für größere Projekte/Epics).
- **Beispiel-Prompt**:
  ```
  Feature Request Chatmode: Erstelle einen Feature Request für ein neues User-Profil-System. Die Benutzer sollen ihren Namen, ihr Profilbild und eine kurze Biografie bearbeiten können.
  ```
- **Ergebnis**: Eine `docs/features/feature-request-user-profile.md` Datei. Dieses Dokument ist die "Single Source of Truth" für die Anforderungen des Features.

---

#### **Schritt 2: Die technische Lösung entwerfen (Das "Wie")**

Sobald die Anforderungen klar sind, wird die technische Umsetzung geplant.

- **Ziel**: Die funktionalen Anforderungen in eine technische Blaupause übersetzen. Definiert Architekturentscheidungen, Datenmodelle, APIs und technische Constraints.
- **Chatmode**: `Specification Chatmode`.
- **Beispiel-Prompt**:
  ```
  Specification Chatmode: Erstelle eine technische Spezifikation basierend auf dem Feature Request unter 'docs/features/feature-request-user-profile.md'. Berücksichtige die Clean Architecture des Projekts und nutze den SQLite MCP Server für die lokale Speicherung.
  ```
- **Ergebnis**: Eine `spec/spec-design-user-profile.md` Datei. Diese stellt sicher, dass die technische Umsetzung die Anforderungen erfüllt und sich nahtlos in die bestehende Architektur einfügt.

---

#### **Schritt 3: Die Arbeit aufteilen (Die "Schritte")**

Mit der technischen Spezifikation als Leitfaden wird die Implementierung in konkrete, ausführbare Aufgaben zerlegt.

- **Ziel**: Die technische Spezifikation in eine Liste von atomaren, sequenziellen Aufgaben herunterbrechen, die von einem Entwickler oder einer KI direkt ausgeführt werden können.
- **Chatmode**: `Implementation Plan Chatmode`.
- **Beispiel-Prompt**:
  ```
  Implementation Plan Chatmode: Erstelle einen Implementierungsplan basierend auf der Spezifikation unter 'spec/spec-design-user-profile.md'. Liste alle zu erstellenden oder zu ändernden Dateien, die notwendigen Klassen und die zu schreibenden Tests auf.
  ```
- **Ergebnis**: Eine `plan/plan-feature-user-profile-1.md` Datei. Dieser Plan ist die direkte Anleitung für die Codierungsphase und minimiert das Risiko von Fehlinterpretationen.

---

#### **Schritt 4: Die Implementierung durchführen (Der "Code")**

Mit dem detaillierten Plan kann nun die eigentliche Codierung beginnen. Hier kommen die nativen Copilot-Fähigkeiten zum Einsatz.

- **Ziel**: Den Implementierungsplan in funktionierenden, getesteten und dokumentierten Code umsetzen.
- **Tools**: `@workspace`, `@terminal`, Inline-Copilot.
- **Beispiel-Prompts**:
  ```
  @workspace Implementiere die 'UserProfileRepository'-Klasse gemäß dem Plan in 'plan/plan-feature-user-profile-1.md'.

  @workspace Erstelle die notwendigen Widget-Tests für das 'UserProfileScreen'.

  @terminal führe 'flutter test' aus, um alle neuen Tests zu validieren.
  ```
- **Ergebnis**: Ein vollständig implementiertes, getestetes und integriertes Feature, das den ursprünglichen Anforderungen entspricht.

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

### 1.2.3. Flutter Widget-Entwicklung Workflow

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

### 1.2.4. Flutter App-Architektur Workflow

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

### 1.2.5. Flutter Backend-Integration Workflow

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

## 1.3. Agent-optimierte Entwicklungsworkflows

### 1.3.1. 🚀 Quick Start Workflow
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

### 1.3.2. 🔄 Iterative Entwicklung

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

### 1.3.3. 🐛 Bug-Fixing Workflow

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

### 1.3.4. 🔧 Refactoring Workflow

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

## 1.4. MCP-Server-optimierte Workflows

### 1.4.1. 📁 Filesystem Operations
```
@workspace Nutze MCP Filesystem Server um:
- Projektdateien zu analysieren
- Code-Templates zu generieren
- Konfigurationsdateien zu verwalten
- Dokumentation zu aktualisieren
```

### 1.4.2. 🗄️ Database Operations
```
@workspace Nutze MCP SQLite Server um:
- Schema-Migrationen zu erstellen
- Test-Daten zu generieren
- Query-Performance zu analysieren
- Backup-Strategien zu implementieren
```

### 1.4.3. 🐙 GitHub Integration
```
@workspace Nutze MCP GitHub Server um:
- Issues und Pull Requests zu verwalten
- Code Reviews zu automatisieren
- Release Notes zu generieren
- Contributor-Statistiken zu erstellen
```

### 1.4.4. 🔍 Web Research
```
@workspace Nutze MCP Brave Search um:
- Best Practices zu recherchieren
- Dokumentation zu finden
- Dependency-Updates zu prüfen
- Security-Advisories zu überwachen
```

### 1.4.5. 🧠 Memory Management
```
@workspace Nutze MCP Memory Server um:
- Projekt-Kontext zu speichern
- Code-Entscheidungen zu dokumentieren
- Pattern-Bibliothek zu erweitern
- Lessons Learned zu sammeln
```

## 1.5. Spezielle Workflows

### 1.5.1. 🎯 Performance Optimization

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

### 1.5.2. 🔐 Security Review

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

### 1.5.3. 📚 Documentation Workflow

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

## 1.6. Automatisierung und CI/CD

### 1.6.1. 🔄 Continuous Integration

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

### 1.6.2. 🚀 Automated Deployment

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

## 1.7. Best Practices für Agent-Workflows

### 1.7.1. 💡 Kontext-Management
- Nutze `@workspace` für projektweite Kontexterfassung
- Referenziere spezifische Dateien für fokussierte Analyse
- Kombiniere MCP Server für erweiterte Capabilities
- Dokumentiere Entscheidungen im Memory Server

### 1.7.2. 🎯 Effizienz-Tipps
- Verwende Templates für wiederkehrende Aufgaben
- Nutze Patterns aus docs/PATTERNS.md als Basis
- Kombiniere mehrere MCP Server für komplexe Workflows
- Automatisiere Routine-Validierungen

### 1.7.3. 🔍 Debugging-Strategien
- Nutze verbose Ausgaben bei Problemen
- Prüfe MCP Server Logs für Integration-Issues
- Verwende validate-project.ps1 für systematische Fehlersuche
- Dokumentiere Lösungen für zukünftige Referenz

### 1.7.4. 📈 Kontinuierliche Verbesserung
- Sammle Feedback zu Workflow-Effizienz
- Erweitere Patterns basierend auf Erfahrungen
- Optimiere MCP Server Konfigurationen
- Aktualisiere Agent-Regeln basierend auf Lessons Learned
