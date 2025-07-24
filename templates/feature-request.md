# Flutter Feature Request Template

## � Feature Übersicht

**Feature Name:** [Name des Features]
**Priorität:** [Hoch/Mittel/Niedrig]
**Sprint/Version:** [Ziel-Sprint oder Version]
**Platform:** [iOS/Android/Web/Alle]

## 🎯 Ziel und Motivation

### Problem Statement
[Beschreibung des Problems oder der Verbesserungsmöglichkeit]

### Zielgruppe
[Wer wird von diesem Feature profitieren?]

### Success Metrics
[Wie messen wir den Erfolg?]

## 🎯 Akzeptanzkriterien

<!-- Definieren Sie messbare Kriterien für den Erfolg -->

- [ ] **Funktional**: Das Feature funktioniert wie beschrieben
- [ ] **Performance**: Response-Zeit unter X ms
- [ ] **Accessibility**: WCAG 2.1 AA Standards erfüllt
- [ ] **Responsiveness**: Funktioniert auf allen Geräten
- [ ] **Browser Support**: Läuft in allen supported Browsern
- [ ] **Tests**: Unit- und E2E-Tests vorhanden
- [ ] **Documentation**: API/Benutzer-Dokumentation aktualisiert

## 🏗️ Technische Anforderungen

### Betroffene Bereiche
<!-- Welche Teile der Anwendung sind betroffen? -->

- [ ] Frontend (UI/UX)
- [ ] Backend (API/Services)
- [ ] Datenbank (Schema-Änderungen)
- [ ] Infrastructure (Deployment/Config)
- [ ] Third-Party Integration
- [ ] Security/Authentication

### Abhängigkeiten
<!-- Externe Services, Libraries, andere Features -->

### Constraints
<!-- Technische Limitationen, Compliance, etc. -->

## 📝 Implementierungsnotizen

### Vorgeschlagener Ansatz
<!-- Ihr bevorzugter Lösungsansatz -->

### Alternative Ansätze
<!-- Andere mögliche Implementierungen -->

### Risiken & Herausforderungen
<!-- Potentielle Probleme und Mitigation-Strategien -->

### MCP Server Integration
<!-- Welche MCP Server könnten nützlich sein? -->

- [ ] **Database MCP**: Für Datenoperationen
- [ ] **API MCP**: Für externe API-Calls
- [ ] **Git MCP**: Für Repository-Operationen
- [ ] **AI MCP**: Für KI-gestützte Features
- [ ] **Other**: _______________

## 🧪 Test-Strategie

### Unit Tests
<!-- Was soll unit-getestet werden? -->

### Integration Tests
<!-- Welche Integrationen müssen getestet werden? -->

### E2E Tests
<!-- Kritische User Journeys -->

### Performance Tests
<!-- Load/Stress Testing Anforderungen -->

## 📊 Success Metrics

### Quantitative Metriken
<!-- Messbare KPIs -->

- Performance: ___
- Usage: ___
- Error Rate: ___
- User Satisfaction: ___

### Qualitative Metriken
<!-- Subjektive Bewertungskriterien -->

## 🚀 Rollout-Plan

### Phase 1: MVP
<!-- Minimale erste Version -->

### Phase 2: Enhancement
<!-- Erweiterte Features -->

### Phase 3: Optimization
<!-- Performance & UX Verbesserungen -->

## 🔗 Referenzen

### Design Mockups
<!-- Links zu Figma, Sketch, etc. -->

### Related Issues
<!-- Links zu ähnlichen Tickets -->

### Documentation
<!-- Externe Dokumentation, Standards, etc. -->

### Examples
<!-- Vergleichbare Implementierungen -->

---

## 🤖 Agent Instructions

**Für GitHub Copilot Agent:**

1. **Analyse**: 
   - Verstehe die Anforderungen vollständig
   - Identifiziere alle betroffenen Code-Bereiche
   - Prüfe Konsistenz mit bestehenden Patterns

2. **Planung**:
   - Erstelle detaillierten Implementierungsplan
   - Berücksichtige `examples/` und `docs/PATTERNS.md`
   - Nutze verfügbare MCP Server

3. **Implementation**:
   - Folge dem TDD-Ansatz
   - Verwende bestehende Code-Patterns
   - Implementiere umfassendes Error Handling

4. **Validation**:
   - Generiere Tests für alle neuen Features
   - Führe Code-Review durch
   - Validiere Performance-Anforderungen

5. **Documentation**:
   - Aktualisiere README und API-Docs
   - Füge Code-Kommentare hinzu
   - Erstelle Usage-Examples

### Kontext-Quellen nutzen:
- `docs/AGENT_RULES.md` für Entwicklungsrichtlinien
- `docs/PATTERNS.md` für Code-Patterns
- `docs/MCP_SERVERS.md` für verfügbare Integrationen
- `examples/` für konkrete Implementierungsbeispiele
