# Projekt-Validierungsskript für Context Engineering Template
# Prüft alle Aspekte des Templates auf Vollständigkeit und Korrektheit

param(
    [switch]$Fix = $false,
    [switch]$Verbose = $false,
    [string]$OutputFormat = "console", # console, json, markdown
    [string]$OutputFile = ""
)

# Globale Variablen
$script:ValidationResults = @()
$script:TotalChecks = 0
$script:PassedChecks = 0
$script:FailedChecks = 0
$script:WarningChecks = 0

# Validierungsresultat-Klasse
class ValidationResult {
    [string]$Category
    [string]$Check
    [string]$Status  # Pass, Fail, Warning
    [string]$Message
    [string]$File
    [hashtable]$Details
    
    ValidationResult([string]$category, [string]$check, [string]$status, [string]$message, [string]$file = "", [hashtable]$details = @{}) {
        $this.Category = $category
        $this.Check = $check
        $this.Status = $status
        $this.Message = $message
        $this.File = $file
        $this.Details = $details
    }
}

# Logging-Funktionen
function Write-CheckResult {
    param(
        [string]$Category,
        [string]$Check,
        [string]$Status,
        [string]$Message,
        [string]$File = "",
        [hashtable]$Details = @{}
    )
    
    $result = [ValidationResult]::new($Category, $Check, $Status, $Message, $File, $Details)
    $script:ValidationResults += $result
    $script:TotalChecks++
    
    switch ($Status) {
        "Pass" { 
            $script:PassedChecks++
            if ($Verbose) {
                Write-Host "  ✓ $Check" -ForegroundColor Green
            }
        }
        "Fail" { 
            $script:FailedChecks++
            Write-Host "  ✗ $Check`: $Message" -ForegroundColor Red
        }
        "Warning" { 
            $script:WarningChecks++
            Write-Host "  ⚠ $Check`: $Message" -ForegroundColor Yellow
        }
    }
}

# Datei-Existenz prüfen
function Test-RequiredFiles {
    Write-Host "`n📁 Prüfe erforderliche Dateien..." -ForegroundColor Cyan
    
    $requiredFiles = @(
        @{ Path = "README.md"; Description = "Haupt-Dokumentation" },
        @{ Path = ".copilot\agent-settings.json"; Description = "Agent-Konfiguration" },
        @{ Path = ".copilot\mcp-config.json"; Description = "MCP-Konfiguration" },
        @{ Path = "docs\AGENT_RULES.md"; Description = "Agent-Regeln" },
        @{ Path = "docs\PATTERNS.md"; Description = "Code-Pattern" },
        @{ Path = "docs\MCP_SERVERS.md"; Description = "MCP-Server-Dokumentation" },
        @{ Path = "templates\feature-request.md"; Description = "Feature-Request-Template" },
        @{ Path = "templates\bug-report.md"; Description = "Bug-Report-Template" },
        @{ Path = "examples\components\UserCard.tsx"; Description = "React-Komponenten-Beispiel" },
        @{ Path = "examples\api\UserService.ts"; Description = "API-Service-Beispiel" },
        @{ Path = "examples\database\BaseRepository.ts"; Description = "Database-Pattern-Beispiel" },
        @{ Path = "examples\testing\UserService.test.ts"; Description = "Test-Pattern-Beispiel" },
        @{ Path = "scripts\setup-mcp.ps1"; Description = "MCP-Setup-Skript" }
    )
    
    foreach ($file in $requiredFiles) {
        if (Test-Path $file.Path) {
            Write-CheckResult "Structure" "File Exists: $($file.Path)" "Pass" $file.Description $file.Path
        } else {
            Write-CheckResult "Structure" "File Missing: $($file.Path)" "Fail" "Erforderliche Datei fehlt: $($file.Description)" $file.Path
            
            if ($Fix) {
                # Hier könnte automatische Reparatur implementiert werden
            }
        }
    }
}

# Verzeichnisstruktur prüfen
function Test-DirectoryStructure {
    Write-Host "`n📂 Prüfe Verzeichnisstruktur..." -ForegroundColor Cyan
    
    $requiredDirectories = @(
        ".copilot",
        "docs",
        "examples",
        "examples\components",
        "examples\api",
        "examples\database", 
        "examples\testing",
        "templates",
        "scripts"
    )
    
    foreach ($dir in $requiredDirectories) {
        if (Test-Path $dir -PathType Container) {
            Write-CheckResult "Structure" "Directory Exists: $dir" "Pass" "Verzeichnis vorhanden" $dir
        } else {
            Write-CheckResult "Structure" "Directory Missing: $dir" "Fail" "Erforderliches Verzeichnis fehlt" $dir
            
            if ($Fix) {
                New-Item -ItemType Directory -Path $dir -Force | Out-Null
                Write-Host "    → Verzeichnis erstellt: $dir" -ForegroundColor Blue
            }
        }
    }
}

# JSON-Konfigurationsdateien validieren
function Test-JsonConfigurations {
    Write-Host "`n🔧 Prüfe JSON-Konfigurationen..." -ForegroundColor Cyan
    
    $jsonFiles = @(
        @{ Path = ".copilot\agent-settings.json"; RequiredKeys = @("agent_behavior", "context_awareness", "code_generation") },
        @{ Path = ".copilot\mcp-config.json"; RequiredKeys = @("servers", "troubleshooting") }
    )
    
    foreach ($jsonFile in $jsonFiles) {
        if (Test-Path $jsonFile.Path) {
            try {
                $content = Get-Content $jsonFile.Path -Raw | ConvertFrom-Json
                Write-CheckResult "Configuration" "JSON Valid: $($jsonFile.Path)" "Pass" "JSON ist gültig" $jsonFile.Path
                
                # Erforderliche Schlüssel prüfen
                foreach ($key in $jsonFile.RequiredKeys) {
                    if ($content.PSObject.Properties.Name -contains $key) {
                        Write-CheckResult "Configuration" "Required Key: $key" "Pass" "Schlüssel vorhanden" $jsonFile.Path
                    } else {
                        Write-CheckResult "Configuration" "Missing Key: $key" "Fail" "Erforderlicher Schlüssel fehlt" $jsonFile.Path
                    }
                }
            }
            catch {
                Write-CheckResult "Configuration" "JSON Invalid: $($jsonFile.Path)" "Fail" "JSON ist ungültig: $($_.Exception.Message)" $jsonFile.Path
            }
        }
    }
}

# Markdown-Dateien auf Vollständigkeit prüfen
function Test-MarkdownContent {
    Write-Host "`n📝 Prüfe Markdown-Inhalte..." -ForegroundColor Cyan
    
    $markdownFiles = @(
        @{ 
            Path = "README.md"
            RequiredSections = @("# Context Engineering Template", "## Quick Start", "## MCP Integration", "## Agent Workflows")
        },
        @{
            Path = "docs\AGENT_RULES.md"
            RequiredSections = @("# Agent Rules", "## Project Understanding", "## Code Generation Rules")
        },
        @{
            Path = "docs\PATTERNS.md" 
            RequiredSections = @("# Code Patterns", "## Backend Patterns", "## Frontend Patterns")
        },
        @{
            Path = "docs\MCP_SERVERS.md"
            RequiredSections = @("# MCP Server Integration", "## Setup Instructions", "## Popular Servers")
        }
    )
    
    foreach ($mdFile in $markdownFiles) {
        if (Test-Path $mdFile.Path) {
            $content = Get-Content $mdFile.Path -Raw
            
            # Prüfe erforderliche Sections
            foreach ($section in $mdFile.RequiredSections) {
                if ($content -match [regex]::Escape($section)) {
                    Write-CheckResult "Documentation" "Section Found: $section" "Pass" "Sektion vorhanden" $mdFile.Path
                } else {
                    Write-CheckResult "Documentation" "Section Missing: $section" "Warning" "Empfohlene Sektion fehlt" $mdFile.Path
                }
            }
            
            # Prüfe Mindestlänge
            if ($content.Length -gt 500) {
                Write-CheckResult "Documentation" "Content Length: $($mdFile.Path)" "Pass" "Ausreichend Inhalt ($($content.Length) Zeichen)" $mdFile.Path
            } else {
                Write-CheckResult "Documentation" "Content Too Short: $($mdFile.Path)" "Warning" "Inhalt könnte ausführlicher sein ($($content.Length) Zeichen)" $mdFile.Path
            }
        }
    }
}

# Code-Beispiele validieren
function Test-CodeExamples {
    Write-Host "`n💻 Prüfe Code-Beispiele..." -ForegroundColor Cyan
    
    $codeFiles = @(
        @{ Path = "examples\components\UserCard.tsx"; Language = "TypeScript"; MinLines = 50 },
        @{ Path = "examples\api\UserService.ts"; Language = "TypeScript"; MinLines = 100 },
        @{ Path = "examples\database\BaseRepository.ts"; Language = "TypeScript"; MinLines = 100 },
        @{ Path = "examples\testing\UserService.test.ts"; Language = "TypeScript"; MinLines = 100 }
    )
    
    foreach ($codeFile in $codeFiles) {
        if (Test-Path $codeFile.Path) {
            $content = Get-Content $codeFile.Path
            $lineCount = $content.Count
            
            # Zeilenanzahl prüfen
            if ($lineCount -ge $codeFile.MinLines) {
                Write-CheckResult "CodeExamples" "Sufficient Content: $($codeFile.Path)" "Pass" "$lineCount Zeilen" $codeFile.Path
            } else {
                Write-CheckResult "CodeExamples" "Insufficient Content: $($codeFile.Path)" "Warning" "Nur $lineCount Zeilen (empfohlen: $($codeFile.MinLines)+)" $codeFile.Path
            }
            
            # TypeScript-spezifische Prüfungen
            if ($codeFile.Language -eq "TypeScript") {
                $hasImports = $content | Where-Object { $_ -match "^import\s" }
                if ($hasImports) {
                    Write-CheckResult "CodeExamples" "Has Imports: $($codeFile.Path)" "Pass" "Import-Statements vorhanden" $codeFile.Path
                } else {
                    Write-CheckResult "CodeExamples" "No Imports: $($codeFile.Path)" "Warning" "Keine Import-Statements gefunden" $codeFile.Path
                }
                
                $hasExports = $content | Where-Object { $_ -match "^export\s" }
                if ($hasExports) {
                    Write-CheckResult "CodeExamples" "Has Exports: $($codeFile.Path)" "Pass" "Export-Statements vorhanden" $codeFile.Path
                } else {
                    Write-CheckResult "CodeExamples" "No Exports: $($codeFile.Path)" "Warning" "Keine Export-Statements gefunden" $codeFile.Path
                }
            }
        }
    }
}

# Template-Integrität prüfen
function Test-TemplateIntegrity {
    Write-Host "`n🔍 Prüfe Template-Integrität..." -ForegroundColor Cyan
    
    # Prüfe Template-Dateien
    $templates = @("feature-request.md", "bug-report.md")
    
    foreach ($template in $templates) {
        $path = "templates\$template"
        if (Test-Path $path) {
            $content = Get-Content $path -Raw
            
            # Prüfe auf Agent-Instruktionen
            if ($content -match "<!--\s*AGENT_INSTRUCTIONS") {
                Write-CheckResult "Templates" "Agent Instructions: $template" "Pass" "Agent-Instruktionen vorhanden" $path
            } else {
                Write-CheckResult "Templates" "No Agent Instructions: $template" "Warning" "Keine Agent-Instruktionen gefunden" $path
            }
            
            # Prüfe auf erforderliche Felder
            $requiredFields = @("## Description", "## Context", "## Acceptance Criteria")
            foreach ($field in $requiredFields) {
                if ($content -match [regex]::Escape($field)) {
                    Write-CheckResult "Templates" "Required Field: $field in $template" "Pass" "Feld vorhanden" $path
                } else {
                    Write-CheckResult "Templates" "Missing Field: $field in $template" "Warning" "Empfohlenes Feld fehlt" $path
                }
            }
        }
    }
}

# MCP-Setup prüfen
function Test-MCPSetup {
    Write-Host "`n🔌 Prüfe MCP-Setup..." -ForegroundColor Cyan
    
    # Prüfe Setup-Skript
    $setupScript = "scripts\setup-mcp.ps1"
    if (Test-Path $setupScript) {
        $content = Get-Content $setupScript -Raw
        
        # Prüfe auf wichtige Funktionen
        $requiredFunctions = @("Install-MCPServer", "Test-NodeVersion", "Update-VSCodeConfig")
        foreach ($func in $requiredFunctions) {
            if ($content -match "function\s+$func") {
                Write-CheckResult "MCPSetup" "Function: $func" "Pass" "Funktion vorhanden" $setupScript
            } else {
                Write-CheckResult "MCPSetup" "Missing Function: $func" "Fail" "Erforderliche Funktion fehlt" $setupScript
            }
        }
        
        # Prüfe auf Fehlerbehandlung
        if ($content -match "try\s*\{" -and $content -match "catch\s*\{") {
            Write-CheckResult "MCPSetup" "Error Handling" "Pass" "Fehlerbehandlung implementiert" $setupScript
        } else {
            Write-CheckResult "MCPSetup" "No Error Handling" "Warning" "Fehlerbehandlung könnte verbessert werden" $setupScript
        }
    }
    
    # Prüfe MCP-Konfiguration
    $mcpConfig = ".copilot\mcp-config.json"
    if (Test-Path $mcpConfig) {
        try {
            $config = Get-Content $mcpConfig | ConvertFrom-Json
            
            if ($config.servers -and $config.servers.PSObject.Properties.Count -gt 0) {
                Write-CheckResult "MCPSetup" "Server Configurations" "Pass" "$($config.servers.PSObject.Properties.Count) Server konfiguriert" $mcpConfig
            } else {
                Write-CheckResult "MCPSetup" "No Servers" "Warning" "Keine MCP-Server konfiguriert" $mcpConfig
            }
        }
        catch {
            Write-CheckResult "MCPSetup" "Config Error" "Fail" "Fehler beim Lesen der MCP-Konfiguration" $mcpConfig
        }
    }
}

# Git-Repository prüfen
function Test-GitRepository {
    Write-Host "`n📦 Prüfe Git-Repository..." -ForegroundColor Cyan
    
    if (Test-Path ".git") {
        Write-CheckResult "Repository" "Git Initialized" "Pass" "Git-Repository initialisiert" ".git"
        
        # .gitignore prüfen
        if (Test-Path ".gitignore") {
            $gitignore = Get-Content ".gitignore" -Raw
            
            $importantIgnores = @("node_modules", "*.log", ".env", "dist/", "build/")
            foreach ($ignore in $importantIgnores) {
                if ($gitignore -match [regex]::Escape($ignore)) {
                    Write-CheckResult "Repository" "Gitignore: $ignore" "Pass" "Eintrag vorhanden" ".gitignore"
                } else {
                    Write-CheckResult "Repository" "Missing Gitignore: $ignore" "Warning" "Empfohlener Eintrag fehlt" ".gitignore"
                }
            }
        } else {
            Write-CheckResult "Repository" "No Gitignore" "Warning" ".gitignore-Datei fehlt" ""
            
            if ($Fix) {
                $defaultGitignore = @"
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Build outputs
dist/
build/
*.tsbuildinfo

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# MCP Data
data/
mcp-servers/
"@
                $defaultGitignore | Out-File -FilePath ".gitignore" -Encoding UTF8
                Write-Host "    → .gitignore erstellt" -ForegroundColor Blue
            }
        }
    } else {
        Write-CheckResult "Repository" "No Git" "Warning" "Kein Git-Repository initialisiert" ""
        
        if ($Fix) {
            git init
            Write-Host "    → Git-Repository initialisiert" -ForegroundColor Blue
        }
    }
}

# Ergebnisse ausgeben
function Write-ValidationSummary {
    Write-Host "`n" + "="*60 -ForegroundColor White
    Write-Host "📊 VALIDIERUNGSERGEBNISSE" -ForegroundColor White
    Write-Host "="*60 -ForegroundColor White
    
    Write-Host "Gesamt Prüfungen: $script:TotalChecks" -ForegroundColor White
    Write-Host "✓ Erfolgreich: $script:PassedChecks" -ForegroundColor Green
    Write-Host "⚠ Warnungen: $script:WarningChecks" -ForegroundColor Yellow  
    Write-Host "✗ Fehler: $script:FailedChecks" -ForegroundColor Red
    
    $successRate = if ($script:TotalChecks -gt 0) { [math]::Round(($script:PassedChecks / $script:TotalChecks) * 100, 1) } else { 0 }
    Write-Host "Erfolgsrate: $successRate%" -ForegroundColor $(if ($successRate -ge 80) { "Green" } elseif ($successRate -ge 60) { "Yellow" } else { "Red" })
    
    # Kategorien-Zusammenfassung
    $categories = $script:ValidationResults | Group-Object Category
    foreach ($category in $categories) {
        $passed = ($category.Group | Where-Object Status -eq "Pass").Count
        $failed = ($category.Group | Where-Object Status -eq "Fail").Count
        $warnings = ($category.Group | Where-Object Status -eq "Warning").Count
        
        Write-Host "`n$($category.Name): " -NoNewline -ForegroundColor Cyan
        Write-Host "$passed✓ " -NoNewline -ForegroundColor Green
        Write-Host "$warnings⚠ " -NoNewline -ForegroundColor Yellow
        Write-Host "$failed✗" -ForegroundColor Red
    }
    
    # Empfehlungen
    if ($script:FailedChecks -gt 0 -or $script:WarningChecks -gt 0) {
        Write-Host "`n🔧 EMPFEHLUNGEN:" -ForegroundColor Yellow
        
        $failedResults = $script:ValidationResults | Where-Object Status -eq "Fail"
        foreach ($result in $failedResults) {
            Write-Host "  • $($result.Message)" -ForegroundColor Red
        }
        
        if ($script:WarningChecks -gt 0) {
            Write-Host "`n⚠ VERBESSERUNGSVORSCHLÄGE:" -ForegroundColor Yellow
            $warningResults = $script:ValidationResults | Where-Object Status -eq "Warning" | Select-Object -First 5
            foreach ($result in $warningResults) {
                Write-Host "  • $($result.Message)" -ForegroundColor Yellow
            }
        }
        
        if (-not $Fix) {
            Write-Host "`n💡 Tipp: Verwende -Fix um automatische Reparaturen durchzuführen" -ForegroundColor Blue
        }
    }
}

# Ergebnisse exportieren
function Export-ValidationResults {
    param([string]$Format, [string]$FilePath)
    
    if (-not $FilePath) {
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $FilePath = "validation-results-$timestamp.$Format"
    }
    
    switch ($Format.ToLower()) {
        "json" {
            $script:ValidationResults | ConvertTo-Json -Depth 10 | Out-File -FilePath $FilePath -Encoding UTF8
        }
        "markdown" {
            $markdown = @"
# Template Validation Results

**Generated:** $(Get-Date)
**Total Checks:** $script:TotalChecks
**Success Rate:** $([math]::Round(($script:PassedChecks / $script:TotalChecks) * 100, 1))%

## Summary

| Status | Count |
|--------|-------|
| ✓ Pass | $script:PassedChecks |
| ⚠ Warning | $script:WarningChecks |
| ✗ Fail | $script:FailedChecks |

## Details

"@
            foreach ($category in ($script:ValidationResults | Group-Object Category)) {
                $markdown += "`n### $($category.Name)`n`n"
                foreach ($result in $category.Group) {
                    $icon = switch ($result.Status) {
                        "Pass" { "✓" }
                        "Warning" { "⚠" }
                        "Fail" { "✗" }
                    }
                    $markdown += "- $icon **$($result.Check)**: $($result.Message)`n"
                }
            }
            
            $markdown | Out-File -FilePath $FilePath -Encoding UTF8
        }
    }
    
    Write-Host "Ergebnisse exportiert: $FilePath" -ForegroundColor Green
}

# Hauptfunktion
function Main {
    Write-Host "🔍 Context Engineering Template Validation" -ForegroundColor Magenta
    Write-Host "===========================================" -ForegroundColor Magenta
    
    # Alle Validierungen ausführen
    Test-DirectoryStructure
    Test-RequiredFiles
    Test-JsonConfigurations
    Test-MarkdownContent
    Test-CodeExamples
    Test-TemplateIntegrity
    Test-MCPSetup
    Test-GitRepository
    
    # Zusammenfassung anzeigen
    Write-ValidationSummary
    
    # Ergebnisse exportieren
    if ($OutputFormat -ne "console") {
        Export-ValidationResults -Format $OutputFormat -FilePath $OutputFile
    }
    
    # Exit Code setzen
    if ($script:FailedChecks -gt 0) {
        exit 1
    } else {
        exit 0
    }
}

# Script ausführen
Main
