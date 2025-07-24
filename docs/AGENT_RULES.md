# Flutter Agent-Regeln für GitHub Copilot Context Engineering

## 🎯 Primäre Direktiven für Flutter-Entwicklung

Als GitHub Copilot Agent für Flutter Context Engineering befolgen Sie diese fundamentalen Regeln:

### 1. Flutter-Projektverständnis
- **IMMER** die gesamte Flutter-Projektstruktur (`lib/`, `pubspec.yaml`, `android/`, `ios/`) analysieren
- Bestehende Widget-Patterns und Dart-Konventionen aus dem `examples/widgets/` Ordner verstehen
- Flutter Version, Dart Version und Ziel-Plattformen (iOS/Android/Web) berücksichtigen
- Konsistenz mit vorhandenen State Management-Lösungen (Provider, Bloc, Riverpod) beibehalten

### 2. Flutter Context-Driven Development
- Nutzen Sie Flutter-spezifische MCP Server (Firebase, Supabase) für Backend-Integration
- Berücksichtigen Sie die Flutter-Dokumentation in `docs/` für Widget-Patterns
- Verwenden Sie die Widget-Templates in `templates/` als Ausgangspunkt
- Beziehen Sie sich auf `PATTERNS.md` für Flutter-bewährte Praktiken

### 3. Flutter-Qualitätsstandards
- Generieren Sie IMMER Widget Tests für neue Widgets
- Dokumentieren Sie komplexe State Management-Logik inline
- Folgen Sie Flutter Security Best Practices (keine Secrets in Code)
- Implementieren Sie Error Handling für async/await Operationen
- Optimieren Sie für Performance (const constructors, repaintBoundary)

## 🔧 Flutter-spezifische Technische Richtlinien

### Widget-Generierung
```dart
// ✅ RICHTIG: Flutter Widget Pattern
class UserProfileCard extends StatelessWidget {
  const UserProfileCard({
    super.key,
    required this.user,
    this.onTap,
    this.elevation = 4.0,
  });

  final User user;
  final VoidCallback? onTap;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: elevation,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 30,
                backgroundImage: user.avatarUrl != null
                  ? NetworkImage(user.avatarUrl!)
                  : null,
                child: user.avatarUrl == null
                  ? Text(user.initials)
                  : null,
              ),
              const SizedBox(height: 12),
              
              // Name
              Text(
                user.name,
                style: theme.textTheme.titleLarge,
              ),
              
              // Email
              Text(
                user.email,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```
    } catch (error) {
      this.logger.error('Failed to create user', error);
      throw new ServiceError('User creation failed', error);
    }
  }
}

// ❌ FALSCH: Inkonsistent, keine Fehlerbehandlung
function createUser(data) {
  return db.users.create(data);
}
```

### Architektur-Prinzipien
- **Single Responsibility**: Jede Klasse/Funktion hat einen klaren Zweck
- **Dependency Injection**: Abhängigkeiten werden injiziert, nicht hart kodiert
- **Interface Segregation**: Kleine, fokussierte Interfaces
- **Open/Closed**: Erweiterbar ohne Modifikation bestehenden Codes

### MCP Server Integration
```typescript
// ✅ Nutzen Sie MCP Server für externe Operationen
const mcp = await getMCPClient();

// Datenbank-Operationen über MCP
const users = await mcp.call('database', 'query', {
  sql: 'SELECT * FROM users WHERE active = true'
});

// API-Calls über MCP
const apiResponse = await mcp.call('fetch', 'request', {
  url: 'https://api.example.com/data',
  method: 'GET'
});
```

## 📝 Kommunikationsrichtlinien

### Interaktion mit Entwicklern
1. **Verständnis prüfen**: Stellen Sie klärende Fragen bei Unklarheiten
2. **Erklärungen geben**: Erläutern Sie Ihre Designentscheidungen
3. **Alternativen bieten**: Zeigen Sie verschiedene Lösungsansätze auf
4. **Schrittweise vorgehen**: Große Aufgaben in kleinere Schritte unterteilen

### Code-Reviews
- Prüfen Sie Konsistenz mit bestehenden Patterns
- Validieren Sie Test-Coverage
- Überprüfen Sie Security-Aspekte
- Bewerten Sie Performance-Implikationen

### Fehlerbehebung
1. **Reproduktion**: Problem genau verstehen
2. **Analyse**: Root-Cause identifizieren
3. **Lösung**: Minimale, sichere Änderungen
4. **Validierung**: Umfassende Tests
5. **Prevention**: Maßnahmen gegen Wiederholung

## 🚦 Workflow-Spezifische Regeln

### Feature-Entwicklung
```markdown
1. 📋 Requirements Analysis
   - Funktionale Anforderungen verstehen
   - Non-funktionale Anforderungen klären
   - Abhängigkeiten identifizieren

2. 🏗️ Design Phase
   - Architektur-Pattern auswählen
   - Interface-Design
   - Datenmodell planen

3. 💻 Implementation
   - TDD-Ansatz verwenden
   - Schrittweise Entwicklung
   - Code-Reviews durchführen

4. ✅ Validation
   - Unit Tests
   - Integration Tests
   - Acceptance Tests

5. 📚 Documentation
   - API-Dokumentation
   - Code-Kommentare
   - README Updates
```

### Bug-Fix Prozess
1. **Verstehen**: Bug reproduzieren und dokumentieren
2. **Lokalisieren**: Root-Cause durch Debugging finden
3. **Lösen**: Minimale Änderung implementieren
4. **Testen**: Regression-Tests durchführen
5. **Dokumentieren**: Fix und Prevention dokumentieren

## 🔐 Security & Best Practices

### Security-Checkliste
- [ ] Input-Validierung implementiert
- [ ] SQL-Injection Prevention
- [ ] XSS-Schutz aktiviert
- [ ] Authentifizierung/Autorisierung geprüft
- [ ] Sensitive Daten verschlüsselt
- [ ] Error Messages enthalten keine sensitiven Infos

### Performance-Richtlinien
- Lazy Loading implementieren
- Caching-Strategien nutzen
- Database Queries optimieren
- Resource Pooling verwenden
- Memory Leaks vermeiden

### Maintainability
- SOLID Prinzipien befolgen
- Clean Code Praktiken
- Comprehensive Test Suite
- Continuous Integration
- Automated Code Quality Checks

## 🎨 UI/UX Richtlinien

### Component Design
- Atomic Design Prinzipien
- Accessibility Standards (WCAG 2.1)
- Responsive Design
- Performance-optimierte Komponenten
- Wiederverwendbare Design Tokens

### User Experience
- Progressive Enhancement
- Graceful Degradation
- Loading States
- Error States
- Empty States

## 📊 Monitoring & Observability

### Logging
```typescript
// ✅ Structured Logging
logger.info('User operation completed', {
  userId: user.id,
  operation: 'update_profile',
  duration: performance.now() - startTime,
  metadata: { fields: updatedFields }
});
```

### Metrics
- Business Metrics
- Technical Metrics
- User Experience Metrics
- Error Rates
- Performance Metrics

### Alerting
- Critical Error Alerts
- Performance Degradation
- Security Incidents
- Business Rule Violations

---

**Hinweis**: Diese Regeln sind lebende Dokumente. Aktualisieren Sie sie basierend auf Projekt-Erfahrungen und Team-Feedback.
