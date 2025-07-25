# Flutter MCP Server Integration Guide

## 🌟 Standardmäßig konfigurierte MCP Server

In diesem Flutter-Template sind bereits folgende MCP Server in `.vscode/mcp.json` vorkonfiguriert:

### 📁 Workspace-spezifische MCP Konfiguration

Die MCP Server werden über die Datei `.vscode/mcp.json` konfiguriert. Diese projektspezifische Konfiguration überschreibt globale VS Code Einstellungen und stellt sicher, dass nur die für Flutter-Entwicklung relevanten Tools verfügbar sind.

**Aktivierung:** Die Server werden automatisch beim Start von GitHub Copilot geladen.

### 🔧 Vorkonfigurierte Standard-Server

#### 1. Filesystem Server

```json
"filesystem": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-filesystem", "${workspaceFolder}"],
  "type": "stdio"
}
```

**Zweck:** Ermöglicht Copilot den Zugriff auf Dateisystem-Operationen im Workspace

- Dateien lesen und schreiben
- Verzeichnisstrukturen navigieren
- Datei-Metadaten abfragen

#### 2. Memory Server

```json
"memory": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-memory"],
  "type": "stdio"
}
```

**Zweck:** Persistenter Speicher für Kontext zwischen Chat-Sitzungen

- Projekt-spezifische Informationen merken
- Benutzer-Präferenzen speichern
- Langzeit-Kontext für bessere Empfehlungen

#### 3. Ref (Research) Server

```json
"Ref": {
  "command": "npx",
  "args": ["ref-tools-mcp@latest"],
  "env": {
    "REF_API_KEY": "ref-beed9e1711b0f9e0c9c3"
  },
  "type": "stdio"
}
```

**Zweck:** Dokumentations-Recherche und Web-Suche

- Flutter/Dart Dokumentation durchsuchen
- Stack Overflow Integration
- GitHub Repository-Suche
- Aktuelle Best Practices finden

#### 4. Semgrep Security Server

```json
"semgrep": {
  "command": "uvx",
  "args": ["semgrep-mcp"],
  "env": {
    "SEMGREP_APP_TOKEN": "c6f6c8dfc492f89783804bb59ddc329d5f9fd59e3355a3bc68fbdd9b4f02ab28"
  },
  "type": "stdio"
}
```

**Zweck:** Code-Sicherheitsanalyse und Qualitätsprüfung

- Automatische Vulnerability-Scans
- Code-Quality-Checks
- Flutter/Dart spezifische Regeln
- Security Best Practices

#### 5. Exa AI Search Server

```json
"exa": {
  "command": "npx",
  "args": ["-y", "mcp-remote", "https://mcp.exa.ai/mcp?exaApiKey=..."],
  "type": "stdio"
}
```

**Zweck:** KI-gestützte Web-Recherche

- Semantische Suche im Web
- Aktuelle Flutter-News und Updates
- Community-Diskussionen finden
- Trend-Analyse

#### 6. Playwright Testing Server

```json
"playwright": {
  "type": "stdio",
  "command": "npx",
  "args": ["@playwright/mcp@latest"],
  "gallery": true
}
```

**Zweck:** End-to-End Testing Automatisierung

- Flutter Web Testing
- Browser-Automatisierung
- Screenshot-Tests
- Performance-Monitoring

### 🚀 Server-Management

**Automatischer Start:** Alle Server werden beim Öffnen des Workspaces automatisch gestartet.

**Manueller Neustart:**

```powershell
# VS Code Command Palette (Ctrl+Shift+P)
> Developer: Reload Window
```

**Server deaktivieren:** Kommentieren Sie den entsprechenden Block in `.vscode/mcp.json` aus:

```json
// "exa": { ... }  // Server temporär deaktiviert
```

**Debug-Modus:** Aktivieren Sie Debug-Logs in VS Code Developer Console (F12):

```javascript
// Alle MCP-Aktivitäten loggen
localStorage.setItem('vscode.copilot.mcp.debug', 'true');
```

---

## 🎯 Erweiterte MCP Server (Optional)

Die folgenden Server können bei Bedarf zur `.vscode/mcp.json` hinzugefügt werden. **Kopieren Sie die gewünschten Konfigurationen in den `"servers"` Block Ihrer `.vscode/mcp.json` Datei.**

**Beispiel-Integration:**

```json
{
  "servers": {
    // ... bestehende Standard-Server ...
    
    // Neuen Server hier hinzufügen:
    "firebase": {
      "command": "npx",
      "args": ["-y", "@firebase/mcp-server"],
      "env": {
        "FIREBASE_PROJECT_ID": "your-project-id"
      },
      "type": "stdio"
    }
  }
}
```

### 🗃️ Backend & Datenbank Server

#### Firebase MCP Server

```json
"firebase": {
  "command": "npx",
  "args": ["-y", "@firebase/mcp-server"],
  "env": {
    "FIREBASE_PROJECT_ID": "your-project-id",
    "FIREBASE_PRIVATE_KEY": "your-service-account-key"
  }
}
```

**Flutter Integration:**

- Firestore Database-Operationen
- Firebase Authentication
- Cloud Functions Integration
- Firebase Storage für File-Uploads
- Push Notifications (FCM)

**Dart Code Beispiel:**

```dart
// Firestore Collection abfragen
final users = await FirebaseFirestore.instance
  .collection('users')
  .where('isActive', isEqualTo: true)
  .get();
```

#### Supabase MCP Server

```json
"supabase": {
  "command": "npx", 
  "args": ["-y", "supabase-mcp-server"],
  "env": {
    "SUPABASE_URL": "https://your-project.supabase.co",
    "SUPABASE_SERVICE_ROLE_KEY": "your-service-role-key"
  }
}
```

**Flutter Integration:**

- PostgreSQL-Backend mit REST API
- Real-time Subscriptions
- Authentication mit Row Level Security
- File Storage

**Dart Code Beispiel:**

```dart
// Supabase Client
final response = await Supabase.instance.client
  .from('users')
  .select()
  .eq('status', 'active');
```

#### SQLite MCP Server (Lokal)

```json
"sqlite": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-sqlite", "./data/app.db"]
}
```

**Flutter Integration:**

- Lokale Datenbank mit sqflite
- Offline-First Apps
- Daten-Synchronisation

**Dart Code Beispiel:**

```dart
// SQLite Database Helper
class DatabaseHelper {
  static Future<Database> _database() async {
    return openDatabase(
      'app_database.db',
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY,
            name TEXT,
            email TEXT
          )
        ''');
      },
    );
  }
}
```

#### Redis MCP Server

```json
"redis": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-redis"],
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
"fetch": {
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
"puppeteer": {
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

#### Docker MCP Server

```json
"docker": {
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
"kubernetes": {
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
"openai": {
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
"replicate": {
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
"notion": {
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
"gmail": {
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
"google-calendar": {
  "command": "npx",
  "args": ["-y", "mcp-server-google-calendar"],
  "env": {
    "GOOGLE_CALENDAR_CREDENTIALS": "./path/to/credentials.json"
  }
}
```

### 📊 Entwicklung & DevOps

#### Docker MCP Server

```json
"docker": {
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
"kubernetes": {
  "command": "npx",
  "args": ["-y", "mcp-server-kubernetes"]
}
```

**K8s-Operationen:**

- Pod-Management
- Service-Konfiguration
- Deployment-Updates
- Cluster-Monitoring

### 🚀 App Store Deployment

#### App Store Connect MCP Server

```json
"app-store-connect": {
  "command": "npx",
  "args": ["-y", "app-store-connect-mcp"],
  "env": {
    "ASC_API_KEY_ID": "your-api-key-id",
    "ASC_API_ISSUER_ID": "your-issuer-id",
    "ASC_API_PRIVATE_KEY": "./credentials/AuthKey_XXXXXXXXXX.p8"
  }
}
```

**iOS Deployment Automatisierung:**

- App Store Connect API Integration
- Build Upload und Verwaltung
- TestFlight Beta Distribution
- App Review Status Tracking
- Metadata und Screenshots Management
- In-App Purchase Configuration

**Flutter Integration Beispiel:**

```dart
// fastlane/Fastfile für iOS Deployment
lane :upload_to_testflight do
  build_app(
    scheme: "Runner",
    export_method: "app-store"
  )
  
  upload_to_testflight(
    api_key_path: "./credentials/AuthKey_XXXXXXXXXX.p8",
    skip_waiting_for_build_processing: false,
    distribute_external: true,
    groups: ["Beta Testers"]
  )
end
```

#### Google Play Console MCP Server

```json
"play-console": {
  "command": "npx",
  "args": ["-y", "google-play-console-mcp"],
  "env": {
    "GOOGLE_PLAY_CREDENTIALS": "./credentials/play-console-service-account.json",
    "GOOGLE_PLAY_PACKAGE_NAME": "com.example.your_app"
  }
}
```

**Android Deployment Automatisierung:**

- Google Play Console API Integration
- APK/AAB Upload und Publishing
- Internal/Closed/Open Testing Tracks
- Release Notes Management
- Store Listing Updates
- In-App Billing Configuration

**Flutter Integration Beispiel:**

```dart
// fastlane/Fastfile für Android Deployment
lane :upload_to_play_store do
  gradle(
    task: "bundle",
    build_type: "Release"
  )
  
  upload_to_play_store(
    track: "internal",
    json_key: "./credentials/play-console-service-account.json",
    aab: "./build/app/outputs/bundle/release/app-release.aab",
    skip_upload_apk: true,
    skip_upload_metadata: false,
    skip_upload_images: false,
    skip_upload_screenshots: false
  )
end
```

## ⚙️ Setup & Konfiguration

### 1. VS Code MCP Server Konfiguration

#### Vollständige settings.json Beispiel

```json
{
  "github.copilot.chat.mcp.enabled": true,
  "github.copilot.chat.mcp.servers": {
    "git": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-git"]
    },
    "fetch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "./"]
    },
    "sqlite": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sqlite", "./data/app.db"]
    }
  }
}
```

### 2. Automatisches Setup Script

```powershell
# Führen Sie das Setup-Script aus
.\scripts\setup-mcp.ps1
```

### 3. Manuelle Installation

```bash
# Basis-Server installieren
npm install -g @modelcontextprotocol/server-git
npm install -g @modelcontextprotocol/server-fetch
npm install -g @modelcontextprotocol/server-filesystem

# Erweiterte Server (nach Bedarf)
npm install -g mcp-server-postgres
npm install -g mcp-server-redis
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

## 🎮 MCP Server Management via CLI

### Einzelne MCP Server starten/stoppen

#### PowerShell Commands für Windows

```powershell
# MCP Server manuell starten
npx @modelcontextprotocol/server-git
npx @modelcontextprotocol/server-fetch
npx @modelcontextprotocol/server-filesystem ./

# Mit Debug-Ausgabe
npx @modelcontextprotocol/server-git --debug
npx @modelcontextprotocol/server-sqlite ./data/app.db --verbose

# Server-Prozesse anzeigen
Get-Process | Where-Object {$_.ProcessName -like "*mcp*"}

# MCP Server stoppen (nach Prozess-Name)
Stop-Process -Name "node" -Force
# oder spezifischer
Get-Process | Where-Object {$_.CommandLine -like "*mcp-server*"} | Stop-Process
```

#### VS Code Copilot Chat MCP Server Kontrolle

```powershell
# VS Code MCP Status prüfen
code --list-extensions | findstr copilot

# VS Code mit MCP Debug-Modus starten
code --verbose --log debug

# VS Code Einstellungen für MCP anzeigen
code --open-settings-json
```

#### Bash/Linux Commands

```bash
# MCP Server starten
npx @modelcontextprotocol/server-git &
npx @modelcontextprotocol/server-fetch &

# Server-Prozesse anzeigen
ps aux | grep mcp

# Server stoppen
pkill -f "mcp-server"
killall node  # Vorsicht: stoppt alle Node.js Prozesse!

# Spezifischen MCP Server stoppen
ps aux | grep "mcp-server-git" | awk '{print $2}' | xargs kill
```

### VS Code Integration Management

#### MCP Server in VS Code aktivieren/deaktivieren

```json
// settings.json - Server temporär deaktivieren
{
  "github.copilot.chat.mcp.enabled": false,  // Alle MCP Server deaktivieren
  "github.copilot.chat.mcp.servers": {
    "git": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-git"],
      "disabled": true  // Einzelnen Server deaktivieren
    }
  }
}
```

#### VS Code Developer Console für MCP Debugging

```javascript
// VS Code Developer Console (Ctrl+Shift+I)
// MCP Server Status abfragen
await vscode.commands.executeCommand('copilot.mcp.status');

// MCP Server neu starten
await vscode.commands.executeCommand('copilot.mcp.restart');

// MCP Logs anzeigen
await vscode.commands.executeCommand('copilot.mcp.showLogs');
```

### PowerShell Helper Scripts

#### MCP Server Manager Script

```powershell
# mcp-manager.ps1
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("start", "stop", "restart", "status", "logs")]
    [string]$Action,
    
    [string]$ServerName = "all"
)

function Start-MCPServer {
    param([string]$Server)
    
    switch ($Server) {
        "git" { 
            Start-Process "npx" -ArgumentList "@modelcontextprotocol/server-git" -NoNewWindow
            Write-Host "Git MCP Server gestartet" -ForegroundColor Green
        }
        "fetch" { 
            Start-Process "npx" -ArgumentList "@modelcontextprotocol/server-fetch" -NoNewWindow
            Write-Host "Fetch MCP Server gestartet" -ForegroundColor Green
        }
        "filesystem" { 
            Start-Process "npx" -ArgumentList "@modelcontextprotocol/server-filesystem", "./" -NoNewWindow
            Write-Host "Filesystem MCP Server gestartet" -ForegroundColor Green
        }
        "all" {
            Start-MCPServer "git"
            Start-MCPServer "fetch" 
            Start-MCPServer "filesystem"
        }
    }
}

function Stop-MCPServer {
    Get-Process | Where-Object {$_.ProcessName -eq "node" -and $_.CommandLine -like "*mcp-server*"} | Stop-Process -Force
    Write-Host "MCP Server gestoppt" -ForegroundColor Yellow
}

function Get-MCPServerStatus {
    $processes = Get-Process | Where-Object {$_.CommandLine -like "*mcp-server*"}
    if ($processes) {
        $processes | Format-Table ProcessName, Id, CommandLine -AutoSize
    } else {
        Write-Host "Keine MCP Server laufen derzeit" -ForegroundColor Red
    }
}

switch ($Action) {
    "start" { Start-MCPServer $ServerName }
    "stop" { Stop-MCPServer }
    "restart" { 
        Stop-MCPServer
        Start-Sleep 2
        Start-MCPServer $ServerName
    }
    "status" { Get-MCPServerStatus }
    "logs" { 
        Write-Host "Starten Sie MCP Server mit --debug für Logs:"
        Write-Host "npx @modelcontextprotocol/server-git --debug"
    }
}
```

#### Verwendung des Scripts

```powershell
# Alle Server starten
.\mcp-manager.ps1 -Action start

# Nur Git Server starten
.\mcp-manager.ps1 -Action start -ServerName git

# Alle Server stoppen
.\mcp-manager.ps1 -Action stop

# Status anzeigen
.\mcp-manager.ps1 -Action status

# Server neu starten
.\mcp-manager.ps1 -Action restart
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
