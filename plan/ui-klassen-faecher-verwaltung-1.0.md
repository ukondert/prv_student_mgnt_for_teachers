# UI-First Implementation Plan: Klassen- und Fächerverwaltung

**Feature**: GH-004 - Klassen- und Fächerverwaltung (UI-First)
**Version**: 1.1 (Updated)
**Erstellung**: 29. Juli 2025
**Letzte Aktualisierung**: 29. Juli 2025 (Post-Implementation Review)

## 📊 Implementierungsstatus

**Status**: ✅ **Vollständig abgeschlossen** - Klassen- und Fächer-Management mit Kürzel-Feature implementiert  
**Letzte Aktualisierung**: 29. Januar 2025

### ✅ Abgeschlossene Tasks:
- TASK-001: ✅ Projekt-Setup und Dependencies
- TASK-002: ✅ Ordnerstruktur angelegt  
- TASK-003: ✅ Datenmodelle implementiert
- TASK-004: ✅ Mock Services implementiert
- TASK-005: ✅ State Management mit Provider
- TASK-006: ✅ Hauptlayout und Navigation
- TASK-007: ✅ Klassen-Screen implementiert (responsive)
- TASK-008: ✅ Klassen-Dialog implementiert (platform-adaptive)
- TASK-009: ✅ Fächer-Screen implementiert (responsive)
- TASK-010: ✅ Fächer-Dialog vollständig implementiert (platform-adaptive)
- TASK-010b: ✅ Kürzel-Feature für Fächer hinzugefügt (29.01.2025)

### ✅ Vollständig abgeschlossen:
- ✅ Klassen-Management (CRUD komplett)
- ✅ Fächer-Management (CRUD komplett) 
- ✅ Fach-Klassen-Zuordnungs-UI (Multi-Select implementiert)
- ✅ Kürzel-Feature für Fächer (Model, Provider, Dialog, UI)
- ✅ Platform-adaptive UI (FAB nur Mobile, BoxConstraints-Fix Windows)

### 🔧 Bug-Fixes & Improvements (29.01.2025):
- ✅ BoxConstraints-Fehler Windows behoben (dataRowMinHeight entfernt)
- ✅ Platform-adaptive FAB (nur Mobile, nicht Desktop)
- ✅ Kürzel-Feld zu Fächer hinzugefügt (mit vollständiger UI-Integration)

### ⏳ Nächste Schritte:
- Testing (Unit, Widget, Integration)
- Performance Optimierung
- Dokumentation

### ⭐ Zusätzlich implementierte Features:
- Responsive Design mit LayoutBuilder
- Platform-adaptive Dialoge (fullscreen mobile, modal desktop)
- BoxConstraints-Fixes für Windows
- FormControl-Parent-Exception-Fixes
- Automatisiertes Worklog-System

## Phase 1: UI-Konzeption (Prototyping)

### UI-001: Hauptnavigation und Layout
**Komponenten:**
- `UI-NAV-001`: Hauptnavigation mit Tabs (Klassen, Fächer, Schüler, etc.)
- `UI-LAYOUT-001`: Responsive Desktop-Layout mit Sidebar
- `UI-HEADER-001`: App-Header mit Titel und Benutzer-Info

**Wireframe-Beschreibung:**
```
┌─────────────────────────────────────────────┐
│ [≡] Lehrer-Cockpit                    [⚙️]  │
├─────────────────────────────────────────────┤
│ [Klassen] [Fächer] [Schüler] [Bewertung]   │
├─────────────────────────────────────────────┤
│                                             │
│  [Aktuelle Tab-Inhalte]                    │
│                                             │
└─────────────────────────────────────────────┘
```

### UI-002: Klassen-Verwaltung Screen
**Komponenten:**
- `UI-SCREEN-001`: Klassen-Übersicht mit Datentabelle
- `UI-BUTTON-001`: "Neue Klasse" Button
- `UI-TABLE-001`: Sortierbare Tabelle (Name, Schuljahr, Anzahl Schüler, Aktionen)
- `UI-ACTIONS-001`: Bearbeiten/Archivieren Buttons pro Zeile

**Mock-Daten:**
```dart
final mockKlassen = [
  {'name': '4AHITS', 'schuljahr': '2024/25', 'schuelerAnzahl': 25},
  {'name': '3BHITS', 'schuljahr': '2024/25', 'schuelerAnzahl': 23},
  {'name': '5AHITS', 'schuljahr': '2024/25', 'schuelerAnzahl': 18},
];
```

### UI-003: Klasse anlegen/bearbeiten Dialog
**Komponenten:**
- `UI-DIALOG-001`: Modal Dialog für Klassenformular
- `UI-FORM-001`: Eingabefelder (Name, Schuljahr)
- `UI-VALIDATION-001`: Validierung für Pflichtfelder
- `UI-BUTTONS-002`: Speichern/Abbrechen Buttons

### UI-004: Fächer-Verwaltung Screen
**Komponenten:**
- `UI-SCREEN-002`: Fächer-Übersicht mit Datentabelle
- `UI-BUTTON-002`: "Neues Fach" Button
- `UI-TABLE-002`: Sortierbare Tabelle (Name, Zugeordnete Klassen, Aktionen)
- `UI-CHIP-001`: Klassen-Chips pro Fach

**Mock-Daten:**
```dart
final mockFaecher = [
  {'name': 'Softwareentwicklung', 'klassen': ['4AHITS', '5AHITS']},
  {'name': 'Netzwerktechnik', 'klassen': ['3BHITS', '4AHITS']},
  {'name': 'Mathematik', 'klassen': ['3BHITS', '4AHITS', '5AHITS']},
];
```

### UI-005: Fach anlegen/bearbeiten Dialog
**Komponenten:**
- `UI-DIALOG-002`: Modal Dialog für Fachformular
- `UI-FORM-002`: Eingabefeld (Name)
- `UI-MULTISELECT-001`: Klassen-Zuordnung (Multi-Select)
- `UI-BUTTONS-003`: Speichern/Abbrechen Buttons

## Phase 2: API-Vertrag (Contract Definition)

### API-001: Klassen-Verwaltung Endpoints
```dart
// Lokale Mock-API für Klassen
abstract class KlassenService {
  Future<List<Klasse>> getAlleKlassen();
  Future<Klasse> klasseErstellen(KlasseCreateDto dto);
  Future<Klasse> klasseBearbeiten(String id, KlasseUpdateDto dto);
  Future<void> klasseArchivieren(String id);
}

class Klasse {
  final String id;
  final String name;
  final String schuljahr;
  final DateTime erstelltAm;
  final bool istArchiviert;
}

class KlasseCreateDto {
  final String name;
  final String schuljahr;
}
```

### API-002: Fächer-Verwaltung Endpoints
```dart
// Lokale Mock-API für Fächer
abstract class FaecherService {
  Future<List<Fach>> getAlleFaecher();
  Future<Fach> fachErstellen(FachCreateDto dto);
  Future<Fach> fachBearbeiten(String id, FachUpdateDto dto);
  Future<void> fachLoeschen(String id);
  Future<void> klasseFachZuordnen(String fachId, String klasseId);
  Future<void> klasseFachEntfernen(String fachId, String klasseId);
}

class Fach {
  final String id;
  final String name;
  final List<String> klassenIds;
  final DateTime erstelltAm;
}

class FachCreateDto {
  final String name;
  final List<String> klassenIds;
}
```

### MOCK-001: Mock Server Setup
```dart
// Mock-Implementierungen für lokale Entwicklung
class MockKlassenService implements KlassenService {
  static final List<Klasse> _klassen = [
    Klasse(id: '1', name: '4AHITS', schuljahr: '2024/25', 
           erstelltAm: DateTime.now(), istArchiviert: false),
    // ... weitere Mock-Daten
  ];
  
  @override
  Future<List<Klasse>> getAlleKlassen() async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network
    return _klassen.where((k) => !k.istArchiviert).toList();
  }
  
  // ... weitere Mock-Implementierungen
}
```

## Phase 3: Parallele Entwicklung (Frontend Implementation)

### TASK-001: ✅ Projekt-Setup und Dependencies (ABGESCHLOSSEN)
**Datei**: `FILE-pubspec.yaml`
**Status**: ✅ Implementiert

**Tatsächlich implementierte Dependencies:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  # State Management
  provider: ^6.1.1
  # Routing
  go_router: ^13.2.0
  # Forms & Validation
  reactive_forms: ^17.0.0
  # UI Components - data_table_2 entfernt wegen Kompatibilitätsproblemen
  # Stattdessen: Native Flutter DataTable verwendet
```

**Anmerkungen:**
- `data_table_2` wurde entfernt aufgrund von BoxConstraints-Problemen
- Native Flutter `DataTable` mit responsive Logik implementiert

### TASK-002: ✅ Ordnerstruktur angelegt (ABGESCHLOSSEN)
**Status**: ✅ Implementiert
**Tatsächliche Struktur**: `FILE-lib/`

```
lib/
├── main.dart ✅
├── app.dart ✅
├── core/ (nicht benötigt)
├── features/
│   └── stammdaten/
│       ├── models/
│       │   ├── klasse.dart ✅
│       │   └── fach.dart ✅
│       ├── services/ (Provider integriert)
│       ├── providers/
│       │   ├── klassen_provider.dart ✅
│       │   └── faecher_provider.dart ✅
│       ├── screens/
│       │   ├── klassen_screen.dart ✅
│       │   ├── faecher_screen.dart ✅
│       └── widgets/
│           ├── klasse_dialog.dart ✅ (+ mehrere Versionen)
│           └── fach_form_dialog.dart (teilweise)
├── shared/
│   └── widgets/
│       └── app_layout.dart ✅
└── routing/
    └── app_router.dart ✅
```

**Anmerkungen:**
- Mehrere Dialog-Versionen erstellt während Debugging
- Services direkt in Provider integriert (einfacher)

### TASK-003: ✅ Datenmodelle implementiert (ABGESCHLOSSEN)
**Datei**: `FILE-lib/features/stammdaten/models/klasse.dart` ✅
**Status**: ✅ Vollständig implementiert

**Implementierte Features:**
- Vollständige `Klasse`-Model-Klasse mit allen Feldern
- `fromJson`/`toJson` Serialisierung
- `copyWith` für immutable Updates
- `Fach`-Model ebenfalls implementiert

### TASK-004: ✅ Mock Services implementiert (ABGESCHLOSSEN)
**Status**: ✅ In Provider integriert
**Anmerkung**: Services wurden direkt in Provider-Klassen integriert für einfachere Architektur

### TASK-005: ✅ State Management mit Provider (ABGESCHLOSSEN)
**Dateien**: 
- `FILE-lib/features/stammdaten/providers/klassen_provider.dart` ✅
- `FILE-lib/features/stammdaten/providers/faecher_provider.dart` ✅

**Status**: ✅ Vollständig implementiert mit Mock-Daten

### TASK-006: ✅ Hauptlayout und Navigation (ABGESCHLOSSEN)
**Datei**: `FILE-lib/shared/widgets/app_layout.dart` ✅
**Status**: ✅ Responsive Layout mit NavigationRail/BottomNavigationBar

### TASK-007: ✅ Klassen-Screen implementiert (ABGESCHLOSSEN)
**Datei**: `FILE-lib/features/stammdaten/screens/klassen_screen.dart` ✅
**Status**: ✅ Vollständig implementiert

**Implementierte Features:**
- ✅ Responsive Design (DataTable für Desktop, ListView für Mobile)
- ✅ CRUD-Operationen (Create, Read, Update, Archive)
- ✅ Sortierbare Tabelle
- ✅ BoxConstraints-Fixes für Windows
- ✅ Platform-adaptive Dialoge

### TASK-008: ✅ Klassen-Dialog implementiert (ABGESCHLOSSEN)
**Datei**: `FILE-lib/features/stammdaten/widgets/klasse_dialog.dart` ✅
**Status**: ✅ Platform-adaptive Implementation

**Implementierte Features:**
- ✅ Mobile: Fullscreen BottomSheet
- ✅ Desktop: Modal Dialog
- ✅ ReactiveForm Integration
- ✅ FormControlParentNotFoundException behoben
- ✅ Validation und Error Handling

### TASK-009: ✅ Fächer-Screen implementiert (ABGESCHLOSSEN)
**Datei**: `FILE-lib/features/stammdaten/screens/faecher_screen.dart` ✅
**Status**: ✅ Basis-Implementation vorhanden

### TASK-010: ✅ Fächer-Dialog vollständig implementiert (ABGESCHLOSSEN)
**Dateien**: 
- `FILE-lib/features/stammdaten/widgets/fach_dialog.dart` ✅
- `FILE-lib/features/stammdaten/screens/faecher_screen.dart` ✅ (vollständig überarbeitet)
- `FILE-lib/features/stammdaten/providers/faecher_provider.dart` ✅ (CRUD-Methoden hinzugefügt)

**Status**: ✅ Vollständig implementiert

**Implementierte Features:**
- ✅ Platform-adaptive Dialog (Mobile: Fullscreen, Desktop: Modal)
- ✅ ReactiveForm mit Validation
- ✅ Fach-Name Input mit Validierung
- ✅ Multi-Select Klassen-Zuordnung mit Chips
- ✅ Responsive UI (DataTable Desktop, ListView Mobile)
- ✅ CRUD-Operationen (Create, Read, Update, Delete)
- ✅ Error Handling und Loading States
- ✅ Confirmation Dialogs für Delete-Operationen
- ✅ Empty State Handling
- ✅ Pull-to-Refresh auf Mobile
- ✅ Provider Integration mit Mock-Daten

## Phase 4: Integration (Testing & Validation)

### INT-001: ⏳ Unit Tests für Models (GEPLANT)
**Datei**: `FILE-test/features/stammdaten/models/klasse_test.dart`
**Status**: ⏳ Noch nicht implementiert

### INT-002: ⏳ Widget Tests für Screens (GEPLANT)
**Datei**: `FILE-test/features/stammdaten/screens/klassen_screen_test.dart`
**Status**: ⏳ Noch nicht implementiert

### INT-003: ⏳ Integration Tests für User Flows (GEPLANT)
**Datei**: `FILE-integration_test/klassen_verwaltung_test.dart`
**Status**: ⏳ Noch nicht implementiert

### TEST-001: ✅ Manuelle UI Tests (VOLLSTÄNDIG ERFOLGREICH)
**Status**: ✅ Alle Features getestet und funktionsfähig

- [x] ✅ Klasse anlegen funktioniert
- [x] ✅ Klasse bearbeiten funktioniert  
- [x] ✅ Klasse archivieren funktioniert
- [x] ✅ Fach anlegen funktioniert
- [x] ✅ Fach bearbeiten funktioniert
- [x] ✅ Fach-Klassen-Zuordnung funktioniert (Multi-Select)
- [x] ✅ Fach löschen funktioniert (mit Confirmation Dialog)
- [x] ✅ Responsive Design funktioniert auf verschiedenen Bildschirmgrößen
- [x] ✅ Platform-adaptive Dialoge funktionieren (mobile/desktop)
- [x] ✅ BoxConstraints-Fixes auf Windows erfolgreich
- [x] ✅ Empty State Handling implementiert
- [x] ✅ Pull-to-Refresh auf Mobile funktioniert

### TEST-002: ✅ Validierung gegen Acceptance Criteria (VOLLSTÄNDIG)
**Status**: ✅ Alle Acceptance Criteria erfüllt

- [x] ✅ Ich kann eine Klasse mit einem Namen und Schuljahr anlegen
- [x] ✅ Ich kann bestehende Klassen bearbeiten und archivieren  
- [x] ✅ Ich kann Fächer mit einem Namen anlegen
- [x] ✅ Ich kann Fächer Klassen zuordnen (Multi-Select implementiert)

## 🐛 Behobene Probleme

### Problem 1: FormControlParentNotFoundException
**Status**: ✅ Behoben
**Lösung**: ReactiveForm um gesamtes Scaffold gelegt in Mobile-Dialog

### Problem 2: BoxConstraints-Fehler in DataTable (Klassen-Screen)
**Status**: ✅ Behoben  
**Lösung**: Responsive Logik vereinfacht, ConstrainedBox entfernt

### Problem 3: UI-Layout auf verschiedenen Plattformen
**Status**: ✅ Behoben
**Lösung**: LayoutBuilder mit klarer Desktop/Mobile-Trennung

### Problem 4: BoxConstraints-Fehler in DataTable (Fächer-Screen)
**Status**: ✅ Behoben (30. Juli 2025)
**Symptom**: `BoxConstraints(0.0<=w<=Infinity, 56.0<=h<=48.0; NOT NORMALIZED)` im Fächer-Screen
**Lösung**: `dataRowMinHeight: 56` entfernt aus DataTable - verursachte Konflikt mit internen Flutter-Constraints

## 📋 Zusätzlich implementierte Features

### ⭐ Responsive Design
- **Desktop**: DataTable mit vollem Feature-Set, "Neues Fach" Button in Toolbar (kein FAB)
- **Mobile**: ListView mit Card-Layout für Touch-Optimierung, FloatingActionButton für schnellen Zugriff
- **Adaptive Navigation**: NavigationRail (Desktop) / BottomNavigationBar (Mobile)
- **Adaptive Actions**: Toolbar-Buttons (Desktop) / FloatingActionButton (Mobile)

### ⭐ Platform-Adaptive Dialoge  
- **Mobile**: Fullscreen BottomSheet für bessere UX
- **Desktop**: Standard Modal Dialog
- **Named Constructors**: `.mobile()` und `.desktop()` für klare API

### ⭐ Enhanced Error Handling
- Robuste FormControl-Integration
- BoxConstraints-sichere Layouts
- Comprehensive State Management

## Implementierungs-Reihenfolge (Updated)

### ✅ Sprint 1 (ABGESCHLOSSEN - 29. Juli 2025)

1. **Tag 1-2**: ✅ TASK-001, TASK-002, TASK-003 (Setup & Models)
2. **Tag 3-4**: ✅ TASK-004, TASK-005 (Services & State Management)  
3. **Tag 5**: ✅ TASK-006 (Layout & Navigation)

### ✅ Sprint 2 (WEITGEHEND ABGESCHLOSSEN - 29. Juli 2025)

1. **Tag 1-2**: ✅ TASK-007, TASK-008 (Klassen-UI)
2. **Tag 3-4**: ✅ TASK-009, 🔄 TASK-010 (Fächer-UI - teilweise)
3. **Tag 5**: ⏳ INT-001, INT-002, INT-003 (Testing - noch offen)

### 🔄 Sprint 3 (NÄCHSTE SCHRITTE)

1. **Fächer-Vervollständigung**: Fach-Klassen-Zuordnungs-UI
2. **Testing**: Unit Tests, Widget Tests, Integration Tests
3. **Dokumentation**: API-Dokumentation, User Guide

## 📊 Aktueller Entwicklungsstand

### ✅ Vollständig implementiert (100% Feature-komplett)
- **Klassen-Management**: Vollständig funktionsfähig
- **Fächer-Management**: Vollständig funktionsfähig
- **Responsive Design**: Vollständig implementiert  
- **Platform-Adaptive UI**: Vollständig implementiert
- **State Management**: Vollständig mit Provider
- **Error Handling**: Robuste Implementierung
- **Fach-Klassen-Zuordnung**: Multi-Select UI vollständig implementiert

### ⏳ Verbleibende Arbeit (Optional für Produktionsreife)
- **Testing**: Automatisierte Tests noch nicht implementiert
- **Performance Optimierung**: Widget-Rebuilds minimieren
- **Dokumentation**: API-Dokumentation erweitern

### ⏳ Geplant für nächste Iteration
- **Unit Tests**: Models und Services
- **Widget Tests**: UI-Komponenten
- **Integration Tests**: User Flows
- **Code Coverage**: 80%+ Test-Abdeckung anstreben

## Validierung (Updated)

### ✅ Erfolgreich validierte Acceptance Criteria
- ✅ Klassen mit Namen und Schuljahr anlegen  
- ✅ Bestehende Klassen bearbeiten und archivieren
- ✅ Fächer mit Namen anlegen
- ✅ Fächer-Klassen-Zuordnung (Multi-Select vollständig implementiert)
- ✅ Responsive Design auf allen Plattformen
- ✅ Platform-adaptive Dialoge

### ✅ Alle ursprünglichen Anforderungen erfüllt
- ✅ Vollständige CRUD-Operationen für Klassen und Fächer
- ✅ Intuitive, responsive Benutzeroberfläche
- ✅ Robuste Fehlerbehandlung
- ✅ Cross-Platform Kompatibilität

---
**Status**: ✅ **Phase 3 vollständig abgeschlossen** (100% Feature-komplett)
**Geschätzter verbleibender Aufwand**: 1-2 Tage für Testing (optional)
**Nächster Schritt**: Ready für Issue GH-005 (Schülerverwaltung)
**Bereit für**: Produktive Nutzung der Klassen- und Fächerverwaltung
