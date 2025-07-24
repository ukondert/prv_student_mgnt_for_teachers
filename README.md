# Context Engineering Template für GitHub Copilot Agent Mode 🤖

Ein umfassendes Template für Context Engineering mit GitHub Copilot Agent Mode in VS Code und Integration verfügbarer MCP-Server für maximale Produktivität.

## 🚀 Was ist Context Engineering?

Context Engineering ist der nächste Evolutionsschritt nach Prompt Engineering. Anstatt nur clevere Prompts zu schreiben, erstellen wir ein komplettes System aus:

- **Projektregeln** und Konventionen
- **Beispielcode** und Patterns
- **Dokumentation** und Spezifikationen  
- **MCP-Server Integration** für erweiterte Fähigkeiten
- **Agent-optimierte Workflows**

### Warum GitHub Copilot Agent Mode?

- 🎯 **Native VS Code Integration** - Direkt in der IDE arbeiten
- 🔧 **Erweiterte Agent-Fähigkeiten** - Chat, Workspace, Terminal Integration
- 🛠️ **MCP Server Support** - Zugriff auf externe Tools und Datenquellen
- 📝 **Context-Aware** - Versteht Ihren gesamten Workspace
- 🔄 **Iterative Entwicklung** - Kontinuierliche Verbesserung möglich

## 📁 Template Struktur

```
template_context_engineering/
├── .copilot/                    # Copilot Agent Konfiguration
│   ├── agent-settings.json     # Agent-spezifische Einstellungen
│   └── mcp-config.json         # MCP Server Konfiguration
├── docs/                       # Projektdokumentation
│   ├── AGENT_RULES.md          # Globale Agent-Regeln
│   ├── PATTERNS.md             # Code-Patterns und Best Practices
│   ├── MCP_SERVERS.md          # Verfügbare MCP Server
│   └── WORKFLOWS.md            # Standard-Workflows
├── examples/                   # Code-Beispiele und Patterns
│   ├── components/             # UI/Component Patterns
│   ├── api/                    # API Integration Patterns
│   ├── database/               # Datenbank Patterns
│   └── testing/                # Test Patterns
├── templates/                  # Projekt-Templates
│   ├── feature-request.md      # Template für Feature Requests
│   ├── bug-report.md           # Template für Bug Reports
│   └── implementation-plan.md  # Template für Implementierungspläne
├── scripts/                    # Automatisierungsscripts
│   ├── setup-mcp.ps1          # MCP Server Setup
│   └── validate-project.ps1   # Projekt-Validierung
└── README.md                   # Diese Datei
```

## 🚦 Quick Start

### 1. Template einrichten
```bash
# Repository klonen oder als Template verwenden
git clone https://github.com/ukondert/template_context_engineering.git
cd template_context_engineering

# MCP Server Setup (Windows PowerShell)
.\scripts\setup-mcp.ps1
```

### 2. VS Code öffnen
```bash
code .
```

### 3. GitHub Copilot Agent aktivieren
- Öffnen Sie die Command Palette (`Ctrl+Shift+P`)
- Wählen Sie "GitHub Copilot: Open Chat"
- Nutzen Sie die Agent-Modi:
  - `@workspace` - Workspace-weite Fragen
  - `@terminal` - Terminal-Kommandos
  - `@vscode` - VS Code spezifische Hilfe

### 4. Erstes Feature entwickeln
1. Kopieren Sie `templates/feature-request.md` und passen es an
2. Verwenden Sie `@workspace` um das Feature zu analysieren
3. Lassen Sie den Agent einen Implementierungsplan erstellen
4. Iterieren Sie mit dem Agent bis zur fertigen Lösung

## 🔧 MCP Server Integration

Dieses Template integriert die besten verfügbaren MCP Server:

### 🗃️ Datenbanken & Speicher
- **PostgreSQL MCP** - Datenbankoperationen
- **SQLite MCP** - Lokale Datenbank
- **Redis MCP** - Caching und Session-Management

### 🌐 Web & APIs
- **HTTP Request MCP** - API-Calls und Web-Requests
- **OpenAPI MCP** - Automatische API-Integration
- **Webhook MCP** - Webhook-Verarbeitung

### 📊 Entwicklung & Tools
- **Git MCP** - Git-Operationen
- **Docker MCP** - Container-Management
- **Kubernetes MCP** - K8s-Cluster Management

### 🤖 AI & ML
- **OpenAI MCP** - ChatGPT Integration
- **Replicate MCP** - ML-Model Zugriff
- **Hugging Face MCP** - Model Hub Integration

### 📝 Produktivität
- **Notion MCP** - Notion-Integration
- **Gmail MCP** - E-Mail-Automatisierung
- **Calendar MCP** - Kalender-Management

Vollständige Liste in [`docs/MCP_SERVERS.md`](docs/MCP_SERVERS.md)

## 🎯 Agent-optimierte Workflows

### Feature-Entwicklung Workflow
1. **Analyse**: `@workspace` analysiert Anforderungen
2. **Planung**: Agent erstellt detaillierten Implementierungsplan
3. **Entwicklung**: Schrittweise Umsetzung mit Code-Reviews
4. **Testing**: Automatische Test-Erstellung und Validierung
5. **Documentation**: Automatische Dokumentation-Updates

### Bug-Fix Workflow
1. **Reproduktion**: Agent analysiert Bug-Report
2. **Root-Cause**: Systematische Ursachen-Analyse
3. **Solution**: Entwicklung der Lösung
4. **Validation**: Test der Lösung
5. **Prevention**: Maßnahmen gegen Wiederholung

## 🔒 Best Practices

### Context Engineering Prinzipien
- **Explizit sein**: Klare Anforderungen und Erwartungen
- **Beispiele geben**: Konkrete Code-Patterns zeigen
- **Validierung einbauen**: Automatische Qualitätsprüfungen
- **Iterativ arbeiten**: Kontinuierliche Verbesserung
- **MCP nutzen**: Externe Tools und Services integrieren

### Agent-Interaktion Tipps
- Nutzen Sie spezifische Agent-Modi (`@workspace`, `@terminal`)
- Geben Sie Kontext über Projektstruktur und Ziele
- Verwenden Sie die Beispiele im `examples/` Ordner
- Referenzieren Sie relevante Dokumentation
- Bitten Sie um schrittweise Erklärungen bei komplexen Themen

## 📚 Weiterführende Ressourcen

- [GitHub Copilot Documentation](https://docs.github.com/en/copilot)
- [Model Context Protocol](https://modelcontextprotocol.io/)
- [MCP Servers Registry](https://github.com/modelcontextprotocol/servers)
- [VS Code Extension API](https://code.visualstudio.com/api)

## 🤝 Contributing

1. Fork das Repository
2. Erstellen Sie einen Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Committen Sie Ihre Änderungen (`git commit -m 'Add some AmazingFeature'`)
4. Pushen Sie den Branch (`git push origin feature/AmazingFeature`)
5. Öffnen Sie einen Pull Request

## 📄 Lizenz

Dieses Projekt steht unter der MIT Lizenz - siehe [LICENSE](LICENSE) Datei für Details.

## 🙏 Inspiration

Basiert auf den Konzepten von [coleam00/context-engineering-intro](https://github.com/coleam00/context-engineering-intro), angepasst für GitHub Copilot Agent Mode und moderne MCP-Integration.
