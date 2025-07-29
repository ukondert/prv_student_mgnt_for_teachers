# UI-First Implementation Plan: Klassen- und Fächerverwaltung

**Feature**: GH-004 - Klassen- und Fächerverwaltung (UI-First)
**Version**: 1.0
**Erstellung**: 29. Juli 2025

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

### TASK-001: Projekt-Setup und Dependencies
**Datei**: `FILE-pubspec.yaml`
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
  # UI Components
  data_table_2: ^2.5.9
  # Local Storage (für später)
  hive: ^2.2.3
  hive_flutter: ^1.1.0
```

### TASK-002: Ordnerstruktur anlegen
**Struktur**: `FILE-lib/`
```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
├── features/
│   └── stammdaten/
│       ├── models/
│       │   ├── klasse.dart
│       │   └── fach.dart
│       ├── services/
│       │   ├── klassen_service.dart
│       │   └── faecher_service.dart
│       ├── providers/
│       │   ├── klassen_provider.dart
│       │   └── faecher_provider.dart
│       └── screens/
│           ├── klassen_screen.dart
│           ├── faecher_screen.dart
│           └── widgets/
│               ├── klasse_form_dialog.dart
│               └── fach_form_dialog.dart
├── shared/
│   └── widgets/
│       ├── app_layout.dart
│       └── responsive_data_table.dart
└── routing/
    └── app_router.dart
```

### TASK-003: Datenmodelle implementieren
**Datei**: `FILE-lib/features/stammdaten/models/klasse.dart`
```dart
class Klasse {
  final String id;
  final String name;
  final String schuljahr;
  final DateTime erstelltAm;
  final bool istArchiviert;

  const Klasse({
    required this.id,
    required this.name,
    required this.schuljahr,
    required this.erstelltAm,
    this.istArchiviert = false,
  });

  factory Klasse.fromJson(Map<String, dynamic> json) => Klasse(
    id: json['id'],
    name: json['name'],
    schuljahr: json['schuljahr'],
    erstelltAm: DateTime.parse(json['erstelltAm']),
    istArchiviert: json['istArchiviert'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'schuljahr': schuljahr,
    'erstelltAm': erstelltAm.toIso8601String(),
    'istArchiviert': istArchiviert,
  };

  Klasse copyWith({
    String? id,
    String? name,
    String? schuljahr,
    DateTime? erstelltAm,
    bool? istArchiviert,
  }) => Klasse(
    id: id ?? this.id,
    name: name ?? this.name,
    schuljahr: schuljahr ?? this.schuljahr,
    erstelltAm: erstelltAm ?? this.erstelltAm,
    istArchiviert: istArchiviert ?? this.istArchiviert,
  );
}
```

### TASK-004: Mock Services implementieren
**Datei**: `FILE-lib/features/stammdaten/services/klassen_service.dart`

### TASK-005: State Management mit Provider
**Datei**: `FILE-lib/features/stammdaten/providers/klassen_provider.dart`

### TASK-006: Hauptlayout und Navigation
**Datei**: `FILE-lib/shared/widgets/app_layout.dart`

### TASK-007: Klassen-Screen implementieren
**Datei**: `FILE-lib/features/stammdaten/screens/klassen_screen.dart`

### TASK-008: Klassen-Dialog implementieren
**Datei**: `FILE-lib/features/stammdaten/screens/widgets/klasse_form_dialog.dart`

### TASK-009: Fächer-Screen implementieren
**Datei**: `FILE-lib/features/stammdaten/screens/faecher_screen.dart`

### TASK-010: Fächer-Dialog implementieren
**Datei**: `FILE-lib/features/stammdaten/screens/widgets/fach_form_dialog.dart`

## Phase 4: Integration (Testing & Validation)

### INT-001: Unit Tests für Models
**Datei**: `FILE-test/features/stammdaten/models/klasse_test.dart`

### INT-002: Widget Tests für Screens
**Datei**: `FILE-test/features/stammdaten/screens/klassen_screen_test.dart`

### INT-003: Integration Tests für User Flows
**Datei**: `FILE-integration_test/klassen_verwaltung_test.dart`

### TEST-001: Manuelle UI Tests
- [ ] Klasse anlegen funktioniert
- [ ] Klasse bearbeiten funktioniert
- [ ] Klasse archivieren funktioniert
- [ ] Fach anlegen funktioniert
- [ ] Fach bearbeiten funktioniert
- [ ] Fach-Klassen-Zuordnung funktioniert
- [ ] Responsive Design funktioniert auf verschiedenen Bildschirmgrößen

### TEST-002: Validierung gegen Acceptance Criteria
- [ ] ✅ Ich kann eine Klasse mit einem Namen und Schuljahr anlegen
- [ ] ✅ Ich kann bestehende Klassen bearbeiten und archivieren
- [ ] ✅ Ich kann Fächer mit einem Namen anlegen
- [ ] ✅ Ich kann Fächer Klassen zuordnen

## Implementierungs-Reihenfolge

### Sprint 1 (1 Woche)
1. **Tag 1-2**: TASK-001, TASK-002, TASK-003 (Setup & Models)
2. **Tag 3-4**: TASK-004, TASK-005 (Services & State Management)
3. **Tag 5**: TASK-006 (Layout & Navigation)

### Sprint 2 (1 Woche)
1. **Tag 1-2**: TASK-007, TASK-008 (Klassen-UI)
2. **Tag 3-4**: TASK-009, TASK-010 (Fächer-UI)
3. **Tag 5**: INT-001, INT-002, INT-003 (Testing)

## Validierung

Nach Abschluss der Implementierung muss das Feature alle Acceptance Criteria aus Issue GH-004 erfüllen und als Grundlage für GH-005 (Schülerverwaltung) dienen können.

---
**Status**: Ready for Implementation
**Geschätzter Aufwand**: 2 Wochen
**Nächster Schritt**: Beginne mit TASK-001 (Projekt-Setup)
