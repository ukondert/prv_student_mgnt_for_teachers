# Bug Report Template

## 🐛 Bug Beschreibung

### Kurze Zusammenfassung
<!-- Eine klare, prägnante Beschreibung des Bugs -->

### Aktuelles Verhalten
<!-- Was passiert derzeit? -->

### Erwartetes Verhalten
<!-- Was sollte stattdessen passieren? -->

## 🔍 Reproduktion

### Schritte zur Reproduktion
1. Gehe zu '...'
2. Klicke auf '...'
3. Scrolle nach unten zu '...'
4. Der Fehler tritt auf

### Reproduzierbarkeit
- [ ] Immer reproduzierbar
- [ ] Manchmal reproduzierbar (ca. __% der Zeit)
- [ ] Schwer reproduzierbar
- [ ] Nur einmal aufgetreten

### Minimales Reproduktions-Beispiel
<!-- Code-Snippet oder Link zu Repository/Branch -->

```javascript
// Fügen Sie hier den minimalen Code ein,
// der das Problem reproduziert
```

## 💻 Umgebung

### Browser/Client
- **Browser**: Chrome/Firefox/Safari/Edge
- **Version**: 
- **OS**: Windows/macOS/Linux
- **Device**: Desktop/Mobile/Tablet

### Server/Backend
- **Environment**: Development/Staging/Production
- **Version**: 
- **Database**: PostgreSQL/MySQL/MongoDB
- **Node.js Version**: 

### Dependencies
<!-- Relevante Package-Versionen -->

```json
{
  "react": "18.x.x",
  "next": "14.x.x",
  "other-package": "x.x.x"
}
```

## 📊 Impact Assessment

### Severity
- [ ] **Critical**: Application unusable, data loss
- [ ] **High**: Major feature broken, significant user impact
- [ ] **Medium**: Feature partially working, workaround available
- [ ] **Low**: Minor issue, cosmetic problem

### Affected Users
- [ ] All users
- [ ] Specific user group: ___________
- [ ] Only in specific environment
- [ ] Estimated percentage: ___%

### Business Impact
<!-- Auswirkungen auf Business-Ziele -->

## 🔬 Technical Analysis

### Error Messages
```
Paste any error messages, stack traces, or console logs here
```

### Network Requests
<!-- Relevante API-Calls, Status Codes, etc. -->

### Database Queries
<!-- Problematische Queries, Performance-Issues -->

### Console Logs
```
Browser console output or server logs
```

## 📝 Additional Context

### Screenshots/Videos
<!-- Attach or link to visual evidence -->

### Related Issues
<!-- Links to similar or related bugs -->

### Workaround
<!-- Temporary solution if available -->

### Recent Changes
<!-- What was changed recently that might have caused this? -->

## 🧪 Proposed Investigation

### Debugging Steps
1. Check logs for error patterns
2. Analyze database queries
3. Review recent code changes
4. Test in different environments

### Potential Root Causes
- [ ] Frontend Logic Error
- [ ] Backend API Issue
- [ ] Database Problem
- [ ] Third-Party Service
- [ ] Infrastructure/Deployment
- [ ] User Data/Configuration

### MCP Tools for Investigation
- [ ] **Database MCP**: Query debugging
- [ ] **Git MCP**: Analyze recent changes
- [ ] **Terminal MCP**: Log analysis
- [ ] **Fetch MCP**: API testing

## ✅ Definition of Done

### Bug Fix Criteria
- [ ] Root cause identified and documented
- [ ] Fix implemented and tested
- [ ] No regression in existing functionality
- [ ] Edge cases covered
- [ ] Performance impact assessed

### Testing Requirements
- [ ] Unit tests cover the bug scenario
- [ ] Integration tests verify the fix
- [ ] Manual testing in affected environments
- [ ] Regression testing completed

### Documentation Updates
- [ ] Code comments added for complex fixes
- [ ] README/docs updated if needed
- [ ] Changelog entry created
- [ ] Post-mortem document (for critical bugs)

---

## 🤖 Agent Instructions

**Für GitHub Copilot Agent:**

1. **Verstehen & Reproduzieren**:
   - Analysiere den Bug-Report vollständig
   - Reproduziere das Problem lokal
   - Verstehe die betroffenen Code-Bereiche

2. **Root-Cause-Analyse**:
   - Nutze MCP Server für Debugging
   - Analysiere Logs und Error-Messages
   - Prüfe Recent Changes via Git MCP
   - Identifiziere die zugrunde liegende Ursache

3. **Lösungsentwicklung**:
   - Entwickle minimale, sichere Lösung
   - Berücksichtige Edge Cases
   - Folge bestehende Code-Patterns
   - Implementiere umfassendes Error Handling

4. **Testing & Validation**:
   - Schreibe Tests für den Bug-Fall
   - Führe Regression-Tests durch
   - Validiere in verschiedenen Umgebungen
   - Überprüfe Performance-Impact

5. **Prevention & Documentation**:
   - Implementiere Monitoring/Alerting
   - Dokumentiere die Lösung
   - Identifiziere Prevention-Maßnahmen
   - Erstelle Post-Mortem (falls nötig)

### Kontext nutzen:
- `docs/AGENT_RULES.md` für Coding-Standards
- `docs/PATTERNS.md` für Debugging-Patterns
- `examples/testing/` für Test-Strategien
- `docs/MCP_SERVERS.md` für Debugging-Tools
