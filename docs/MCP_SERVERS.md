# MCP Server Integration Guide

## 🌟 Verfügbare MCP Server

### 🗃️ Datenbank & Speicher Server

#### PostgreSQL MCP Server
```json
{
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-postgres"],
  "env": {
    "POSTGRES_URL": "postgresql://user:password@localhost:5432/dbname"
  }
}
```

**Capabilities:**
- Schema-Exploration
- SQL-Queries ausführen
- Datenbank-Operationen (CRUD)
- Transaction-Management

**Verwendung:**
```typescript
// Über MCP Client
const users = await mcp.call('postgres', 'query', {
  sql: 'SELECT * FROM users WHERE active = true',
  params: []
});
```

#### SQLite MCP Server
```json
{
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-sqlite", "./data/app.db"]
}
```

**Ideal für:**
- Lokale Entwicklung
- Prototyping
- Embedded Applications

#### Redis MCP Server
```json
{
  "command": "npx",
  "args": ["-y", "mcp-server-redis"],
  "env": {
    "REDIS_URL": "redis://localhost:6379"
  }
}
```

**Features:**
- Key-Value Operationen
- Caching
- Session Management
- Pub/Sub Messaging

### 🌐 Web & API Server

#### HTTP Request MCP Server (Fetch)
```json
{
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-fetch"]
}
```

**Capabilities:**
- HTTP GET/POST/PUT/DELETE Requests
- Header-Management
- Response-Parsing
- Error-Handling

**Beispiel:**
```typescript
const apiData = await mcp.call('fetch', 'request', {
  url: 'https://api.github.com/users/octocat',
  method: 'GET',
  headers: {
    'Authorization': 'token ghp_xxxxxxxxxxxx'
  }
});
```

#### Puppeteer MCP Server
```json
{
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-puppeteer"]
}
```

**Features:**
- Web Scraping
- Screenshot-Erstellung
- PDF-Generierung
- Browser-Automatisierung

### 📊 Entwicklung & DevOps

#### Git MCP Server
```json
{
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-git"]
}
```

**Operationen:**
- Repository-Status
- Commit-Erstellung
- Branch-Management
- History-Abfragen

#### Docker MCP Server
```json
{
  "command": "npx",
  "args": ["-y", "mcp-server-docker"]
}
```

**Container-Management:**
- Container starten/stoppen
- Image-Verwaltung
- Log-Abfragen
- Volume-Management

#### Kubernetes MCP Server
```json
{
  "command": "npx",
  "args": ["-y", "mcp-server-kubernetes"]
}
```

**K8s-Operationen:**
- Pod-Management
- Service-Konfiguration
- Deployment-Updates
- Cluster-Monitoring

### 🤖 AI & Machine Learning

#### OpenAI MCP Server
```json
{
  "command": "npx",
  "args": ["-y", "mcp-server-openai"],
  "env": {
    "OPENAI_API_KEY": "sk-xxxxxxxxxxxxxx"
  }
}
```

**AI-Integration:**
- ChatGPT API Zugriff
- Text-Generierung
- Code-Completion
- Embeddings

#### Replicate MCP Server
```json
{
  "command": "npx",
  "args": ["-y", "mcp-server-replicate"],
  "env": {
    "REPLICATE_API_TOKEN": "r8_xxxxxxxxxxxxxx"
  }
}
```

**ML-Models:**
- Image-Generierung
- Text-zu-Sprache
- Code-Generierung
- Custom Models

### 📝 Produktivität & Integration

#### Notion MCP Server
```json
{
  "command": "npx",
  "args": ["-y", "mcp-server-notion"],
  "env": {
    "NOTION_API_KEY": "secret_xxxxxxxxxxxxxx"
  }
}
```

**Notion-Integration:**
- Database-Queries
- Page-Erstellung
- Content-Updates
- Team-Kollaboration

#### Gmail MCP Server
```json
{
  "command": "npx",
  "args": ["-y", "mcp-server-gmail"],
  "env": {
    "GMAIL_CREDENTIALS": "./path/to/credentials.json"
  }
}
```

**E-Mail-Funktionen:**
- E-Mail senden
- Inbox durchsuchen
- Automatische Antworten
- Kalender-Integration

#### Google Calendar MCP Server
```json
{
  "command": "npx",
  "args": ["-y", "mcp-server-google-calendar"],
  "env": {
    "GOOGLE_CALENDAR_CREDENTIALS": "./path/to/credentials.json"
  }
}
```

## ⚙️ Setup & Konfiguration

### 1. MCP Server Installation

#### Automatische Installation (Empfohlen)
```powershell
# Führen Sie das Setup-Script aus
.\scripts\setup-mcp.ps1
```

#### Manuelle Installation
```bash
# Basis-Server installieren
npm install -g @modelcontextprotocol/server-git
npm install -g @modelcontextprotocol/server-fetch
npm install -g @modelcontextprotocol/server-filesystem

# Erweiterte Server (nach Bedarf)
npm install -g mcp-server-postgres
npm install -g mcp-server-redis
```

### 2. VS Code Konfiguration

#### .vscode/settings.json erweitern
```json
{
  "github.copilot.advanced": {
    "mcp": {
      "enabled": true,
      "configPath": ".copilot/mcp-config.json"
    }
  }
}
```

### 3. Umgebungsvariablen konfigurieren

#### .env Datei erstellen
```env
# Datenbank-Verbindungen
POSTGRES_URL=postgresql://user:password@localhost:5432/dbname
REDIS_URL=redis://localhost:6379

# API-Keys
OPENAI_API_KEY=sk-xxxxxxxxxxxxxx
REPLICATE_API_TOKEN=r8_xxxxxxxxxxxxxx

# Google Services
GOOGLE_CREDENTIALS=./credentials/google-credentials.json

# Notion
NOTION_API_KEY=secret_xxxxxxxxxxxxxx
```

## 🔧 Praktische Anwendungsbeispiele

### Datenbank-Operationen
```typescript
// Benutzer aus Datenbank abrufen
const users = await mcp.call('postgres', 'query', {
  sql: `
    SELECT u.*, p.name as profile_name 
    FROM users u 
    LEFT JOIN profiles p ON u.id = p.user_id 
    WHERE u.active = true
  `,
  params: []
});

// Cache mit Redis
await mcp.call('redis', 'set', {
  key: 'user_list',
  value: JSON.stringify(users),
  expiry: 300 // 5 Minuten
});
```

### API-Integration
```typescript
// GitHub API über Fetch MCP
const repoInfo = await mcp.call('fetch', 'request', {
  url: 'https://api.github.com/repos/owner/repo',
  method: 'GET',
  headers: {
    'Authorization': `token ${process.env.GITHUB_TOKEN}`,
    'Accept': 'application/vnd.github.v3+json'
  }
});

// Commit-Informationen über Git MCP
const commits = await mcp.call('git', 'log', {
  maxCount: 10,
  format: 'json'
});
```

### AI-Powered Code Review
```typescript
// Code-Analyse mit OpenAI MCP
const codeReview = await mcp.call('openai', 'chat', {
  model: 'gpt-4',
  messages: [
    {
      role: 'system',
      content: 'Du bist ein Senior Software Engineer. Reviewe den folgenden Code und gib Verbesserungsvorschläge.'
    },
    {
      role: 'user',
      content: `Hier ist der Code:\n\n${sourceCode}`
    }
  ]
});
```

### Dokumentation automatisieren
```typescript
// Notion-Dokumentation erstellen
await mcp.call('notion', 'createPage', {
  parent: { database_id: 'documentation_db_id' },
  properties: {
    'Name': { title: [{ text: { content: 'API Documentation' } }] },
    'Status': { select: { name: 'Draft' } }
  },
  children: [
    {
      object: 'block',
      type: 'heading_1',
      heading_1: { rich_text: [{ text: { content: 'API Endpoints' } }] }
    }
  ]
});
```

## 🚀 Best Practices

### 1. MCP Server Auswahl
- **Entwicklung**: Git, Filesystem, Terminal
- **Datenbanken**: PostgreSQL, Redis
- **APIs**: Fetch, OpenAPI
- **Produktivität**: Notion, Gmail, Calendar

### 2. Performance-Optimierung
```typescript
// Connection Pooling
const mcpPool = new MCPConnectionPool({
  maxConnections: 10,
  idleTimeout: 30000
});

// Caching für häufige Anfragen
const cachedResult = await cache.getOrSet(
  `mcp:${operation}:${hash}`,
  () => mcp.call(server, operation, params),
  300 // 5 Minuten Cache
);
```

### 3. Error Handling
```typescript
try {
  const result = await mcp.call('server', 'operation', params);
  return result;
} catch (error) {
  if (error instanceof MCPConnectionError) {
    // Retry-Logic
    return await retryWithBackoff(() => 
      mcp.call('server', 'operation', params)
    );
  }
  
  logger.error('MCP operation failed', { error, server, operation });
  throw new ServiceError('External service unavailable', error);
}
```

### 4. Security Considerations
- API-Keys in Umgebungsvariablen speichern
- Berechtigungen minimal halten
- Input-Validierung für MCP-Calls
- Rate-Limiting implementieren

### 5. Monitoring & Debugging
```typescript
// MCP-Call Logging
const mcpLogger = new MCPLogger({
  logLevel: 'debug',
  includePayload: process.env.NODE_ENV === 'development'
});

// Metrics Collection
const mcpMetrics = new MCPMetrics();
mcpMetrics.trackCall(server, operation, duration, success);
```

## 🔍 Troubleshooting

### Häufige Probleme

#### MCP Server startet nicht
```bash
# Überprüfen Sie die Installation
npm list -g | grep mcp

# Server-Logs anzeigen
npx @modelcontextprotocol/server-git --debug
```

#### Authentifizierung fehlgeschlagen
```bash
# Umgebungsvariablen prüfen
echo $OPENAI_API_KEY
echo $POSTGRES_URL

# Credentials-Dateien validieren
ls -la ./credentials/
```

#### Langsame Performance
- Nicht benötigte Server deaktivieren
- Connection Pooling verwenden
- Caching implementieren
- Request-Batching nutzen

### Debug-Modi aktivieren
```json
{
  "mcpServers": {
    "git": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-git", "--debug"],
      "env": {
        "DEBUG": "mcp:*"
      }
    }
  }
}
```

---

**Nächste Schritte:**
1. Führen Sie `scripts/setup-mcp.ps1` aus
2. Konfigurieren Sie benötigte API-Keys
3. Testen Sie die MCP-Integration mit `@workspace`
4. Erweitern Sie die Konfiguration nach Bedarf
