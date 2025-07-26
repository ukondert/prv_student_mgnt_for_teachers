# Flutter Doctor Script - Environment Validation
# Prüft die Flutter-Entwicklungsumgebung auf Vollständigkeit

param(
    [switch]$Verbose,
    [switch]$Fix,
    [string]$FlutterChannel = "stable"
)

Write-Host "🚀 Flutter Environment Validation" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green

# Flutter Installation prüfen
Write-Host "`n📱 Flutter Installation prüfen..." -ForegroundColor Yellow

try {
    $flutterVersion = flutter --version
    Write-Host "✅ Flutter ist installiert" -ForegroundColor Green
    
    if ($Verbose) {
        Write-Host $flutterVersion -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Flutter ist nicht installiert oder nicht im PATH" -ForegroundColor Red
    Write-Host "Installieren Sie Flutter von: https://flutter.dev/docs/get-started/install" -ForegroundColor Yellow
    
    if ($Fix) {
        Write-Host "Automatische Installation wird nicht unterstützt. Bitte manuell installieren." -ForegroundColor Yellow
    }
    exit 1
}

# Flutter Doctor ausführen
Write-Host "`n🔍 Flutter Doctor ausführen..." -ForegroundColor Yellow
flutter doctor -v

# Dart Installation prüfen
Write-Host "`n📦 Dart Installation prüfen..." -ForegroundColor Yellow

try {
    $dartVersion = dart --version
    Write-Host "✅ Dart ist verfügbar" -ForegroundColor Green
    
    if ($Verbose) {
        Write-Host $dartVersion -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Dart ist nicht verfügbar" -ForegroundColor Red
}

# Android Studio / Android SDK prüfen
Write-Host "`n🤖 Android Development prüfen..." -ForegroundColor Yellow

$androidSdkPath = $env:ANDROID_HOME
if ($androidSdkPath -and (Test-Path $androidSdkPath)) {
    Write-Host "✅ Android SDK gefunden: $androidSdkPath" -ForegroundColor Green
    
    # Android SDK Tools prüfen
    $adbPath = Join-Path $androidSdkPath "platform-tools\adb.exe"
    if (Test-Path $adbPath) {
        Write-Host "✅ Android Debug Bridge (ADB) verfügbar" -ForegroundColor Green
    } else {
        Write-Host "⚠️ ADB nicht gefunden" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ Android SDK nicht gefunden (ANDROID_HOME nicht gesetzt)" -ForegroundColor Red
    Write-Host "Setzen Sie ANDROID_HOME Environment Variable" -ForegroundColor Yellow
}

# Xcode prüfen (nur auf macOS relevant, aber Info geben)
Write-Host "`n🍎 iOS Development (Xcode)..." -ForegroundColor Yellow
Write-Host "ℹ️ Xcode ist nur auf macOS verfügbar für iOS-Entwicklung" -ForegroundColor Cyan

# VS Code und Extensions prüfen
Write-Host "`n💻 VS Code und Flutter Extensions prüfen..." -ForegroundColor Yellow

try {
    $vsCodeVersion = code --version
    Write-Host "✅ VS Code ist installiert" -ForegroundColor Green
    
    # Flutter Extension prüfen
    $extensions = code --list-extensions
    
    if ($extensions -contains "Dart-Code.dart-code") {
        Write-Host "✅ Dart Extension installiert" -ForegroundColor Green
    } else {
        Write-Host "❌ Dart Extension nicht installiert" -ForegroundColor Red
        if ($Fix) {
            Write-Host "Installing Dart Extension..." -ForegroundColor Yellow
            code --install-extension Dart-Code.dart-code
        }
    }
    
    if ($extensions -contains "Dart-Code.flutter") {
        Write-Host "✅ Flutter Extension installiert" -ForegroundColor Green
    } else {
        Write-Host "❌ Flutter Extension nicht installiert" -ForegroundColor Red
        if ($Fix) {
            Write-Host "Installing Flutter Extension..." -ForegroundColor Yellow
            code --install-extension Dart-Code.flutter
        }
    }
    
} catch {
    Write-Host "❌ VS Code ist nicht installiert oder nicht im PATH" -ForegroundColor Red
}

# Git prüfen
Write-Host "`n📋 Git Installation prüfen..." -ForegroundColor Yellow

try {
    $gitVersion = git --version
    Write-Host "✅ Git ist installiert" -ForegroundColor Green
    
    if ($Verbose) {
        Write-Host $gitVersion -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Git ist nicht installiert" -ForegroundColor Red
    Write-Host "Installieren Sie Git von: https://git-scm.com/" -ForegroundColor Yellow
}

# Flutter Channel prüfen
Write-Host "`n🔄 Flutter Channel prüfen..." -ForegroundColor Yellow

$currentChannel = flutter channel | Where-Object { $_ -match "^\*" } | ForEach-Object { $_.Replace("* ", "") }
Write-Host "Aktueller Channel: $currentChannel" -ForegroundColor Cyan

if ($currentChannel -ne $FlutterChannel) {
    Write-Host "⚠️ Flutter läuft auf '$currentChannel', empfohlen ist '$FlutterChannel'" -ForegroundColor Yellow
    
    if ($Fix) {
        Write-Host "Wechsle zu $FlutterChannel Channel..." -ForegroundColor Yellow
        flutter channel $FlutterChannel
        flutter upgrade
    }
}

# Pub Global Packages prüfen
Write-Host "`n📦 Wichtige Flutter Packages prüfen..." -ForegroundColor Yellow

$globalPackages = flutter pub global list

# Empfohlene Global Packages
$recommendedPackages = @(
    "flutter_gen",
    "dart_code_metrics",
    "import_sorter"
)

foreach ($package in $recommendedPackages) {
    if ($globalPackages -match $package) {
        Write-Host "✅ $package ist global installiert" -ForegroundColor Green
    } else {
        Write-Host "⚠️ $package ist nicht global installiert" -ForegroundColor Yellow
        
        if ($Fix) {
            Write-Host "Installiere $package..." -ForegroundColor Yellow
            flutter pub global activate $package
        }
    }
}

# Connected Devices prüfen
Write-Host "`n📱 Verbundene Geräte prüfen..." -ForegroundColor Yellow

$devices = flutter devices
Write-Host $devices -ForegroundColor Gray

if ($devices -match "No devices detected") {
    Write-Host "⚠️ Keine Geräte oder Emulatoren erkannt" -ForegroundColor Yellow
    Write-Host "Starten Sie einen Android Emulator oder verbinden Sie ein Gerät" -ForegroundColor Yellow
} else {
    Write-Host "✅ Geräte/Emulatoren verfügbar" -ForegroundColor Green
}

# Performance Checks
Write-Host "`n⚡ Performance Checks..." -ForegroundColor Yellow

# Verfügbarer Speicher
$memory = Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
$totalMemoryGB = [math]::Round($memory.Sum / 1GB, 2)

Write-Host "RAM: $totalMemoryGB GB" -ForegroundColor Cyan

if ($totalMemoryGB -lt 8) {
    Write-Host "⚠️ Weniger als 8 GB RAM - Flutter Entwicklung könnte langsam sein" -ForegroundColor Yellow
} else {
    Write-Host "✅ Ausreichend RAM für Flutter Entwicklung" -ForegroundColor Green
}

# Zusammenfassung
Write-Host "`n📊 Zusammenfassung" -ForegroundColor Green
Write-Host "=================" -ForegroundColor Green

Write-Host "Flutter Environment Check abgeschlossen!" -ForegroundColor Green

if ($Fix) {
    Write-Host "`nWenn --Fix verwendet wurde, führen Sie das Script erneut aus um Änderungen zu überprüfen." -ForegroundColor Yellow
}

Write-Host "`n🚀 Nächste Schritte:" -ForegroundColor Cyan
Write-Host "1. Beheben Sie alle roten (❌) Issues" -ForegroundColor White
Write-Host "2. Installieren Sie fehlende Extensions in VS Code" -ForegroundColor White
Write-Host "3. Starten Sie einen Android Emulator oder verbinden Sie ein Gerät" -ForegroundColor White
Write-Host "4. Erstellen Sie ein neues Flutter Projekt: flutter create my_app" -ForegroundColor White

Write-Host "`n📚 Hilfreiche Links:" -ForegroundColor Cyan
Write-Host "- Flutter Docs: https://flutter.dev/docs" -ForegroundColor Blue
Write-Host "- Dart Docs: https://dart.dev/guides" -ForegroundColor Blue
Write-Host "- VS Code Flutter: https://flutter.dev/docs/development/tools/vs-code" -ForegroundColor Blue
