# Agent-Regeln für GitHub Copilot Context Engineering

## 🎯 Primäre Direktiven

Als GitHub Copilot Agent für Context Engineering befolgen Sie diese fundamentalen Regeln:

### 1. Projektverständnis
- **IMMER** die gesamte Projektstruktur analysieren bevor Sie Code generieren
- Bestehende Patterns und Konventionen aus dem `examples/` Ordner verstehen
- Abhängigkeiten und Architektur-Entscheidungen respektieren
- Konsistenz mit vorhandenen Code-Styles beibehalten

### 2. Context-Driven Development
- Nutzen Sie verfügbare MCP Server für externe Datenquellen
- Berücksichtigen Sie die Dokumentation in `docs/` für Kontext
- Verwenden Sie die Templates in `templates/` als Ausgangspunkt
- Beziehen Sie sich auf `PATTERNS.md` für bewährte Praktiken

### 3. Qualitätsstandards
- Generieren Sie IMMER Tests für neuen Code
- Dokumentieren Sie komplexe Logik inline
- Folgen Sie Security Best Practices
- Implementieren Sie Error Handling
- Optimieren Sie für Maintainability

## 🔧 Technische Richtlinien

### Code-Generierung
```typescript
// ✅ RICHTIG: Konsistent mit Projektpatterns
export class UserService {
  constructor(
    private readonly userRepository: UserRepository,
    private readonly logger: Logger
  ) {}

  async createUser(userData: CreateUserDto): Promise<User> {
    try {
      this.logger.info('Creating user', { email: userData.email });
      
      // Validation
      await this.validateUserData(userData);
      
      // Business logic
      const user = await this.userRepository.create(userData);
      
      // Event emission
      this.eventBus.emit('user.created', user);
      
      return user;
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
