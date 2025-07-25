# MCP Server Management - Verwendungsbeispiele

## 🚀 Quick Start

```powershell
# Basis MCP Server installieren und starten
.\scripts\mcp-manager.ps1 -Action install -ServerName all
.\scripts\mcp-manager.ps1 -Action start -ServerName all

# Status aller Server anzeigen
.\scripts\mcp-manager.ps1 -Action status
```

## 📋 Verfügbare Commands

### Installation
```powershell
# Alle MCP Server installieren
.\scripts\mcp-manager.ps1 -Action install

# Nur Git Server installieren  
.\scripts\mcp-manager.ps1 -Action install -ServerName git
```

### Server Management
```powershell
# Einzelne Server starten
.\scripts\mcp-manager.ps1 -Action start -ServerName git
.\scripts\mcp-manager.ps1 -Action start -ServerName fetch
.\scripts\mcp-manager.ps1 -Action start -ServerName filesystem

# Alle Server starten
.\scripts\mcp-manager.ps1 -Action start -ServerName all

# Mit Debug-Ausgabe starten
.\scripts\mcp-manager.ps1 -Action start -ServerName git -Debug
```

### Server Status
```powershell
# Status aller Server anzeigen
.\scripts\mcp-manager.ps1 -Action status

# Log-Informationen anzeigen
.\scripts\mcp-manager.ps1 -Action logs
```

### Server stoppen
```powershell
# Einzelnen Server stoppen
.\scripts\mcp-manager.ps1 -Action stop -ServerName git

# Alle Server stoppen
.\scripts\mcp-manager.ps1 -Action stop -ServerName all

# Server neu starten
.\scripts\mcp-manager.ps1 -Action restart -ServerName git
```

## 🔧 VS Code Integration

### 1. MCP Server in VS Code aktivieren

Nach dem Start der Server müssen diese in VS Code konfiguriert werden:

```json
// .vscode/settings.json oder settings.json
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
    }
  }
}
```

### 2. VS Code Developer Console für MCP

```javascript
// VS Code Developer Console (Ctrl+Shift+I)
// MCP Server Status in VS Code prüfen
await vscode.commands.executeCommand('github.copilot.chat.mcp.refresh');

// MCP Logs anzeigen
console.log('MCP Status:', await vscode.commands.executeCommand('github.copilot.chat.mcp.getStatus'));
```

## 🌐 Environment Variables

Für erweiterte MCP Server (OpenAI, Notion, etc.) benötigen Sie API-Keys:

```powershell
# PowerShell - Umgebungsvariablen setzen
$env:OPENAI_API_KEY = "sk-xxxxxxxxxxxxxx"
$env:REPLICATE_API_TOKEN = "r8_xxxxxxxxxxxxxx" 
$env:NOTION_API_KEY = "secret_xxxxxxxxxxxxxx"

# Oder in .env Datei
# Erstellen Sie eine .env Datei im Projektroot:
OPENAI_API_KEY=sk-xxxxxxxxxxxxxx
REPLICATE_API_TOKEN=r8_xxxxxxxxxxxxxx
NOTION_API_KEY=secret_xxxxxxxxxxxxxx
```

## 🐛 Troubleshooting

### Häufige Probleme

#### "Server läuft bereits"
```powershell
# Alle Node.js Prozesse anzeigen
Get-Process node

# MCP Server Prozesse stoppen
.\scripts\mcp-manager.ps1 -Action stop -ServerName all

# Neu starten  
.\scripts\mcp-manager.ps1 -Action restart -ServerName all
```

#### "npx Befehl nicht gefunden"
```powershell
# Node.js/NPM Installation prüfen
node --version
npm --version

# NPX Cache leeren
npm cache clean --force
```

#### "Umgebungsvariable fehlt"
```powershell
# Aktuelle Umgebungsvariablen anzeigen
Get-ChildItem Env: | Where-Object Name -like "*API*"

# Variable setzen
$env:OPENAI_API_KEY = "your-api-key-here"
```

### Debug-Modus

```powershell
# Server mit maximaler Debug-Ausgabe starten
.\scripts\mcp-manager.ps1 -Action start -ServerName git -Debug

# Manuelle Debug-Ausgabe
npx @modelcontextprotocol/server-git --debug --verbose
```

## 📊 Monitoring

### Performance Monitoring
```powershell
# Server-Performance überwachen
while ($true) {
    Clear-Host
    .\scripts\mcp-manager.ps1 -Action status
    Start-Sleep 5
}
```

### Logs überwachen
```powershell
# PowerShell Logs in Echtzeit (Windows Event Log)
Get-WinEvent -FilterHashtable @{LogName='Application'; ProviderName='Node.js'} -MaxEvents 10
```

## 🔗 Integration mit anderen Tools

### GitHub Copilot Chat
```
# In VS Code Copilot Chat verwenden:
@workspace Zeige mir alle Git Commits der letzten Woche
@workspace Erstelle eine neue Datei mit den Projektinfos
@workspace Führe eine HTTP-Anfrage an die GitHub API durch
```

### Terminal Integration
```powershell
# Alias für häufige Commands erstellen
Set-Alias -Name mcp -Value ".\scripts\mcp-manager.ps1"

# Verwendung:
mcp -Action status
mcp -Action start -ServerName git
mcp -Action restart -ServerName all
```
