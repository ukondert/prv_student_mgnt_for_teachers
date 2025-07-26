#Requires -Version 5.1

<#
.SYNOPSIS
    MCP Server Management Script für VS Code
    
.DESCRIPTION
    Startet, stoppt und verwaltet MCP Server für die VS Code GitHub Copilot Integration.
    
.PARAMETER Action
    Die auszuführende Aktion: start, stop, restart, status, logs
    
.PARAMETER ServerName
    Name des MCP Servers: git, fetch, filesystem, sqlite, openai, all
    
.PARAMETER Debug
    Aktiviert Debug-Ausgabe für MCP Server
    
.EXAMPLE
    .\mcp-manager.ps1 -Action start -ServerName git
    Startet nur den Git MCP Server
    
.EXAMPLE
    .\mcp-manager.ps1 -Action start -ServerName all -EnableDebug
    Startet alle MCP Server mit Debug-Ausgabe
    
.EXAMPLE
    .\mcp-manager.ps1 -Action status
    Zeigt Status aller laufenden MCP Server
#>

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("start", "stop", "restart", "status", "logs", "install")]
    [string]$Action,
    
    [ValidateSet("git", "fetch", "filesystem", "sqlite", "openai", "replicate", "notion", "all")]
    [string]$ServerName = "all",
    
    [switch]$EnableDebug
)

# Farbige Ausgabe-Funktionen
function Write-Success { param([string]$Message) Write-Host $Message -ForegroundColor Green }
function Write-Warning { param([string]$Message) Write-Host $Message -ForegroundColor Yellow }
function Write-Error { param([string]$Message) Write-Host $Message -ForegroundColor Red }
function Write-Info { param([string]$Message) Write-Host $Message -ForegroundColor Cyan }

# MCP Server Konfigurationen
$MCPServers = @{
    "git" = @{
        "package" = "@modelcontextprotocol/server-git"
        "args" = @()
        "description" = "Git Repository Operations"
    }
    "fetch" = @{
        "package" = "@modelcontextprotocol/server-fetch"
        "args" = @()
        "description" = "HTTP Request Operations"
    }
    "filesystem" = @{
        "package" = "@modelcontextprotocol/server-filesystem"
        "args" = @("./")
        "description" = "File System Operations"
    }
    "sqlite" = @{
        "package" = "@modelcontextprotocol/server-sqlite"
        "args" = @("./data/app.db")
        "description" = "SQLite Database Operations"
    }
    "openai" = @{
        "package" = "mcp-server-openai"
        "args" = @()
        "description" = "OpenAI API Integration"
        "requiresEnv" = @("OPENAI_API_KEY")
    }
    "replicate" = @{
        "package" = "mcp-server-replicate"
        "args" = @()
        "description" = "Replicate AI Models"
        "requiresEnv" = @("REPLICATE_API_TOKEN")
    }
    "notion" = @{
        "package" = "mcp-server-notion"
        "args" = @()
        "description" = "Notion API Integration"
        "requiresEnv" = @("NOTION_API_KEY")
    }
}

function Test-Prerequisites {
    # Node.js prüfen
    try {
        $nodeVersion = node --version 2>$null
        Write-Info "Node.js Version: $nodeVersion"
    } catch {
        Write-Error "Node.js ist nicht installiert oder nicht im PATH"
        return $false
    }
    
    # NPX prüfen
    try {
        npx --version | Out-Null
        Write-Info "NPX ist verfügbar"
    } catch {
        Write-Error "NPX ist nicht verfügbar"
        return $false
    }
    
    return $true
}

function Test-EnvironmentVariables {
    param([hashtable]$ServerConfig)
    
    if ($ServerConfig.ContainsKey("requiresEnv")) {
        foreach ($envVar in $ServerConfig.requiresEnv) {
            if (-not (Get-ChildItem Env: | Where-Object Name -eq $envVar)) {
                Write-Warning "Umgebungsvariable $envVar ist nicht gesetzt"
                return $false
            }
        }
    }
    return $true
}

function Install-MCPServer {
    param([string]$ServerName)
    
    if ($ServerName -eq "all") {
        foreach ($name in $MCPServers.Keys) {
            Install-MCPServer $name
        }
        return
    }
    
    if (-not $MCPServers.ContainsKey($ServerName)) {
        Write-Error "Unbekannter MCP Server: $ServerName"
        return
    }
    
    $config = $MCPServers[$ServerName]
    Write-Info "Installiere $($config.package)..."
    
    try {
        $installArgs = @("-g", $config.package)
        Start-Process "npm" -ArgumentList ("install", $installArgs) -Wait -NoNewWindow
        Write-Success "✅ $($config.package) erfolgreich installiert"
    } catch {
        Write-Error "❌ Fehler beim Installieren von $($config.package): $_"
    }
}

function Start-MCPServer {
    param([string]$ServerName)
    
    if ($ServerName -eq "all") {
        foreach ($name in $MCPServers.Keys) {
            Start-MCPServer $name
        }
        return
    }
    
    if (-not $MCPServers.ContainsKey($ServerName)) {
        Write-Error "Unbekannter MCP Server: $ServerName"
        return
    }
    
    $config = $MCPServers[$ServerName]
    
    # Environment Variables prüfen
    if (-not (Test-EnvironmentVariables $config)) {
        Write-Warning "Server $ServerName benötigt zusätzliche Umgebungsvariablen"
    }
    
    # Prüfen ob Server bereits läuft
    $runningProcess = Get-Process | Where-Object {
        $_.ProcessName -eq "node" -and 
        $_.CommandLine -like "*$($config.package)*"
    } 2>$null
    
    if ($runningProcess) {
        Write-Warning "MCP Server '$ServerName' läuft bereits (PID: $($runningProcess.Id))"
        return
    }
    
    Write-Info "Starte MCP Server: $ServerName ($($config.description))"
    
    try {
        $mcpArgs = @("-y", $config.package) + $config.args
        if ($EnableDebug) {
            $mcpArgs += "--debug"
        }
        
        $process = Start-Process "npx" -ArgumentList $mcpArgs -PassThru -NoNewWindow
        Start-Sleep 2
        
        if ($process -and -not $process.HasExited) {
            Write-Success "✅ MCP Server '$ServerName' gestartet (PID: $($process.Id))"
        } else {
            Write-Error "❌ MCP Server '$ServerName' konnte nicht gestartet werden"
        }
    } catch {
        Write-Error "❌ Fehler beim Starten von MCP Server '$ServerName': $_"
    }
}

function Stop-MCPServer {
    param([string]$ServerName)
    
    if ($ServerName -eq "all") {
        $processes = Get-Process | Where-Object {
            $_.ProcessName -eq "node" -and 
            $_.CommandLine -like "*mcp-server*"
        } 2>$null
    } else {
        if (-not $MCPServers.ContainsKey($ServerName)) {
            Write-Error "Unbekannter MCP Server: $ServerName"
            return
        }
        
        $config = $MCPServers[$ServerName]
        $processes = Get-Process | Where-Object {
            $_.ProcessName -eq "node" -and 
            $_.CommandLine -like "*$($config.package)*"
        } 2>$null
    }
    
    if ($processes) {
        foreach ($process in $processes) {
            try {
                Stop-Process -Id $process.Id -Force
                Write-Success "✅ MCP Server gestoppt (PID: $($process.Id))"
            } catch {
                Write-Error "❌ Fehler beim Stoppen des MCP Servers (PID: $($process.Id)): $_"
            }
        }
    } else {
        if ($ServerName -eq "all") {
            Write-Warning "Keine laufenden MCP Server gefunden"
        } else {
            Write-Warning "MCP Server '$ServerName' läuft nicht"
        }
    }
}

function Get-MCPServerStatus {
    Write-Info "=== MCP Server Status ==="
    
    $allProcesses = Get-Process | Where-Object {
        $_.ProcessName -eq "node" -and 
        $_.CommandLine -like "*mcp-server*"
    } 2>$null
    
    if (-not $allProcesses) {
        Write-Warning "Keine MCP Server laufen derzeit"
        return
    }
    
    $statusTable = @()
    
    foreach ($serverName in $MCPServers.Keys) {
        $config = $MCPServers[$serverName]
        $process = Get-Process | Where-Object {
            $_.ProcessName -eq "node" -and 
            $_.CommandLine -like "*$($config.package)*"
        } 2>$null
        
        if ($process) {
            $status = "🟢 Läuft"
            $processId = $process.Id
            $cpu = "{0:N1}%" -f $process.CPU
            $memory = "{0:N0} MB" -f ($process.WorkingSet64 / 1MB)
        } else {
            $status = "🔴 Gestoppt"
            $processId = "-"
            $cpu = "-"
            $memory = "-"
        }
        
        $statusTable += [PSCustomObject]@{
            Server = $serverName
            Status = $status
            PID = $processId
            CPU = $cpu
            Memory = $memory
            Beschreibung = $config.description
        }
    }
    
    $statusTable | Format-Table -AutoSize
}

function Show-MCPLogs {
    Write-Info "=== MCP Server Logs ==="
    Write-Info "Für detaillierte Logs starten Sie Server mit Debug-Modus:"
    Write-Host ""
    
    foreach ($serverName in $MCPServers.Keys) {
        $config = $MCPServers[$serverName]
        Write-Host "# $serverName ($($config.description))"
        Write-Host "npx $($config.package) --debug" -ForegroundColor Gray
        Write-Host ""
    }
    
    Write-Info "VS Code MCP Logs finden Sie in:"
    Write-Host "  - VS Code Developer Console (Ctrl+Shift+I)"
    Write-Host "  - VS Code Output Panel -> GitHub Copilot" -ForegroundColor Gray
}

# Hauptlogik
function Main {
    Write-Info "=== MCP Server Manager ==="
    
    if (-not (Test-Prerequisites)) {
        Write-Error "Voraussetzungen nicht erfüllt. Beenden."
        exit 1
    }
    
    switch ($Action) {
        "install" { 
            Install-MCPServer $ServerName 
        }
        "start" { 
            Start-MCPServer $ServerName 
        }
        "stop" { 
            Stop-MCPServer $ServerName 
        }
        "restart" { 
            Write-Info "Neustart von MCP Server(n)..."
            Stop-MCPServer $ServerName
            Start-Sleep 3
            Start-MCPServer $ServerName
        }
        "status" { 
            Get-MCPServerStatus 
        }
        "logs" { 
            Show-MCPLogs 
        }
    }
}

# Script ausführen
Main
