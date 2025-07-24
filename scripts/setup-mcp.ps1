# MCP Server Setup Script
# Dieses Skript richtet die wichtigsten MCP Server für das Context Engineering Template ein

param(
    [string]$ServerType = "all",
    [switch]$Force = $false,
    [switch]$Verbose = $false
)

# Logging-Funktionen
function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Write-Verbose {
    param([string]$Message)
    if ($Verbose) {
        Write-Host "[VERBOSE] $Message" -ForegroundColor Cyan
    }
}

# Node.js Version prüfen
function Test-NodeVersion {
    try {
        $nodeVersion = node --version
        $versionNumber = [Version]($nodeVersion -replace 'v', '')
        
        if ($versionNumber -lt [Version]"18.0.0") {
            Write-Error "Node.js Version 18+ ist erforderlich. Aktuelle Version: $nodeVersion"
            return $false
        }
        
        Write-Info "Node.js Version: $nodeVersion ✓"
        return $true
    }
    catch {
        Write-Error "Node.js ist nicht installiert oder nicht im PATH"
        return $false
    }
}

# Git prüfen
function Test-Git {
    try {
        $gitVersion = git --version
        Write-Info "Git Version: $gitVersion ✓"
        return $true
    }
    catch {
        Write-Error "Git ist nicht installiert oder nicht im PATH"
        return $false
    }
}

# MCP Server installieren
function Install-MCPServer {
    param(
        [string]$Name,
        [string]$Repository,
        [string]$InstallPath,
        [hashtable]$Config = @{}
    )
    
    Write-Info "Installiere MCP Server: $Name"
    
    # Prüfen ob bereits installiert
    if (Test-Path $InstallPath) {
        if (-not $Force) {
            Write-Warning "$Name ist bereits installiert. Verwende -Force zum Überschreiben."
            return $true
        }
        else {
            Write-Info "Entferne existierende Installation..."
            Remove-Item -Path $InstallPath -Recurse -Force
        }
    }
    
    try {
        # Repository klonen
        Write-Verbose "Klone Repository: $Repository"
        git clone $Repository $InstallPath
        
        # In Verzeichnis wechseln
        Push-Location $InstallPath
        
        # Abhängigkeiten installieren
        Write-Verbose "Installiere Abhängigkeiten..."
        npm install
        
        # Build falls erforderlich
        if (Test-Path "package.json") {
            $packageJson = Get-Content "package.json" | ConvertFrom-Json
            if ($packageJson.scripts.build) {
                Write-Verbose "Führe Build aus..."
                npm run build
            }
        }
        
        # Konfigurationsdatei erstellen
        if ($Config.Count -gt 0) {
            $configPath = Join-Path $InstallPath "config.json"
            $Config | ConvertTo-Json -Depth 10 | Out-File -FilePath $configPath -Encoding UTF8
            Write-Verbose "Konfiguration erstellt: $configPath"
        }
        
        Pop-Location
        Write-Info "$Name erfolgreich installiert ✓"
        return $true
    }
    catch {
        Write-Error "Fehler beim Installieren von $Name`: $($_.Exception.Message)"
        if (Get-Location | Where-Object { $_.Path -eq $InstallPath }) {
            Pop-Location
        }
        return $false
    }
}

# Filesystem MCP Server
function Install-FilesystemServer {
    $config = @{
        "allowed_directories" = @(
            "."
            "$env:USERPROFILE\Documents"
            "$env:USERPROFILE\Desktop"
        )
        "allow_create" = $true
        "allow_delete" = $false
        "allow_modify" = $true
    }
    
    Install-MCPServer -Name "Filesystem Server" `
                     -Repository "https://github.com/modelcontextprotocol/servers" `
                     -InstallPath ".\mcp-servers\filesystem" `
                     -Config $config
}

# SQLite MCP Server
function Install-SQLiteServer {
    $config = @{
        "databases" = @{
            "main" = @{
                "path" = ".\data\main.db"
                "readonly" = $false
            }
            "test" = @{
                "path" = ".\data\test.db"
                "readonly" = $true
            }
        }
    }
    
    # Data-Verzeichnis erstellen
    $dataPath = ".\data"
    if (-not (Test-Path $dataPath)) {
        New-Item -ItemType Directory -Path $dataPath -Force | Out-Null
    }
    
    Install-MCPServer -Name "SQLite Server" `
                     -Repository "https://github.com/modelcontextprotocol/servers" `
                     -InstallPath ".\mcp-servers\sqlite" `
                     -Config $config
}

# GitHub MCP Server
function Install-GitHubServer {
    $githubToken = $env:GITHUB_TOKEN
    if (-not $githubToken) {
        Write-Warning "GITHUB_TOKEN Umgebungsvariable nicht gesetzt. GitHub Server wird ohne Token konfiguriert."
    }
    
    $config = @{
        "token" = $githubToken
        "default_repo" = ""
        "allowed_repos" = @()
    }
    
    Install-MCPServer -Name "GitHub Server" `
                     -Repository "https://github.com/modelcontextprotocol/servers" `
                     -InstallPath ".\mcp-servers\github" `
                     -Config $config
}

# Web Search MCP Server (Brave)
function Install-BraveSearchServer {
    $braveApiKey = $env:BRAVE_API_KEY
    if (-not $braveApiKey) {
        Write-Warning "BRAVE_API_KEY Umgebungsvariable nicht gesetzt. Brave Search Server wird ohne API Key konfiguriert."
    }
    
    $config = @{
        "api_key" = $braveApiKey
        "max_results" = 10
        "safe_search" = "moderate"
    }
    
    Install-MCPServer -Name "Brave Search Server" `
                     -Repository "https://github.com/modelcontextprotocol/servers" `
                     -InstallPath ".\mcp-servers\brave-search" `
                     -Config $config
}

# Memory MCP Server
function Install-MemoryServer {
    $config = @{
        "storage_path" = ".\data\memory.json"
        "max_memories" = 1000
        "auto_save" = $true
    }
    
    Install-MCPServer -Name "Memory Server" `
                     -Repository "https://github.com/modelcontextprotocol/servers" `
                     -InstallPath ".\mcp-servers\memory" `
                     -Config $config
}

# VS Code MCP Config updaten
function Update-VSCodeConfig {
    Write-Info "Aktualisiere VS Code MCP Konfiguration..."
    
    $mcpConfigPath = ".\.copilot\mcp-config.json"
    
    if (-not (Test-Path $mcpConfigPath)) {
        Write-Error "MCP Konfigurationsdatei nicht gefunden: $mcpConfigPath"
        return $false
    }
    
    try {
        $mcpConfig = Get-Content $mcpConfigPath | ConvertFrom-Json
        
        # Installed servers hinzufügen
        $installedServers = @{
            "filesystem" = @{
                "command" = "node"
                "args" = @(".\mcp-servers\filesystem\build\index.js")
                "enabled" = $true
                "config_path" = ".\mcp-servers\filesystem\config.json"
            }
            "sqlite" = @{
                "command" = "node"
                "args" = @(".\mcp-servers\sqlite\build\index.js")
                "enabled" = $true
                "config_path" = ".\mcp-servers\sqlite\config.json"
            }
            "github" = @{
                "command" = "node"
                "args" = @(".\mcp-servers\github\build\index.js")
                "enabled" = $true
                "config_path" = ".\mcp-servers\github\config.json"
            }
            "brave-search" = @{
                "command" = "node"
                "args" = @(".\mcp-servers\brave-search\build\index.js")
                "enabled" = $true
                "config_path" = ".\mcp-servers\brave-search\config.json"
            }
            "memory" = @{
                "command" = "node"
                "args" = @(".\mcp-servers\memory\build\index.js")
                "enabled" = $true
                "config_path" = ".\mcp-servers\memory\config.json"
            }
        }
        
        # Servers zur Konfiguration hinzufügen
        foreach ($serverName in $installedServers.Keys) {
            $mcpConfig.servers.$serverName = $installedServers[$serverName]
        }
        
        # Konfiguration speichern
        $mcpConfig | ConvertTo-Json -Depth 10 | Out-File -FilePath $mcpConfigPath -Encoding UTF8
        
        Write-Info "VS Code MCP Konfiguration aktualisiert ✓"
        return $true
    }
    catch {
        Write-Error "Fehler beim Aktualisieren der VS Code Konfiguration: $($_.Exception.Message)"
        return $false
    }
}

# Status aller Server prüfen
function Test-MCPServers {
    Write-Info "Prüfe Status der MCP Server..."
    
    $servers = @("filesystem", "sqlite", "github", "brave-search", "memory")
    $results = @{}
    
    foreach ($server in $servers) {
        $serverPath = ".\mcp-servers\$server"
        $configPath = "$serverPath\config.json"
        $indexPath = "$serverPath\build\index.js"
        
        $status = @{
            "installed" = (Test-Path $serverPath)
            "configured" = (Test-Path $configPath)
            "built" = (Test-Path $indexPath)
        }
        
        $results[$server] = $status
        
        $statusIcon = if ($status.installed -and $status.configured -and $status.built) { "✓" } else { "✗" }
        Write-Host "  $server`: $statusIcon" -ForegroundColor $(if ($statusIcon -eq "✓") { "Green" } else { "Red" })
    }
    
    return $results
}

# Haupt-Installationsfunktion
function Install-AllServers {
    Write-Info "Starte Installation aller MCP Server..."
    
    $success = $true
    
    # Verzeichnis für MCP Server erstellen
    if (-not (Test-Path ".\mcp-servers")) {
        New-Item -ItemType Directory -Path ".\mcp-servers" -Force | Out-Null
    }
    
    # Server installieren
    $success = $success -and (Install-FilesystemServer)
    $success = $success -and (Install-SQLiteServer)
    $success = $success -and (Install-GitHubServer)
    $success = $success -and (Install-BraveSearchServer)
    $success = $success -and (Install-MemoryServer)
    
    if ($success) {
        # VS Code Konfiguration aktualisieren
        Update-VSCodeConfig | Out-Null
        
        Write-Info "Alle MCP Server erfolgreich installiert! ✓"
        Write-Info ""
        Write-Info "Nächste Schritte:"
        Write-Info "1. Starte VS Code neu"
        Write-Info "2. Öffne die Command Palette (Ctrl+Shift+P)"
        Write-Info "3. Führe 'GitHub Copilot: Enable MCP' aus"
        Write-Info "4. Teste die Installation mit '@workspace Zeige verfügbare MCP Server'"
    }
    else {
        Write-Error "Einige MCP Server konnten nicht installiert werden."
    }
    
    return $success
}

# Cleanup-Funktion
function Remove-MCPServers {
    Write-Info "Entferne alle MCP Server..."
    
    if (Test-Path ".\mcp-servers") {
        Remove-Item -Path ".\mcp-servers" -Recurse -Force
        Write-Info "MCP Server entfernt ✓"
    }
    
    if (Test-Path ".\data") {
        Remove-Item -Path ".\data" -Recurse -Force
        Write-Info "Data-Verzeichnis entfernt ✓"
    }
}

# Main Script Logic
function Main {
    Write-Info "Context Engineering Template - MCP Server Setup"
    Write-Info "=============================================="
    
    # Voraussetzungen prüfen
    if (-not (Test-NodeVersion) -or -not (Test-Git)) {
        Write-Error "Voraussetzungen nicht erfüllt. Installation abgebrochen."
        exit 1
    }
    
    # Parameter verarbeiten
    switch ($ServerType.ToLower()) {
        "all" {
            Install-AllServers
        }
        "filesystem" {
            Install-FilesystemServer
        }
        "sqlite" {
            Install-SQLiteServer
        }
        "github" {
            Install-GitHubServer
        }
        "brave-search" {
            Install-BraveSearchServer
        }
        "memory" {
            Install-MemoryServer
        }
        "status" {
            Test-MCPServers
        }
        "clean" {
            Remove-MCPServers
        }
        default {
            Write-Error "Unbekannter Server-Typ: $ServerType"
            Write-Info "Verfügbare Optionen: all, filesystem, sqlite, github, brave-search, memory, status, clean"
            exit 1
        }
    }
}

# Script ausführen
Main
