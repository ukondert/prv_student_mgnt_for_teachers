---
description: "Automatisiertes Worklog & Entwicklungsprotokoll mit MCP Memory Server"
applyTo: "**"
---

# Worklog Instructions: Automatisiertes Entwicklungsprotokoll mit MCP Memory Server

## Zweck
Diese Datei definiert, wie bei jedem Entwicklungsschritt, Fehler und Fix automatisch ein Worklog im Memory-MCP-Server erzeugt wird. Sie ist so gestaltet, dass sie von Copilot Chat in VS Code automatisch bei jedem relevanten Vorgang angewendet wird.

---

## Anwendung

- Die Instructions werden automatisch bei jedem Chat-Request angewendet, der zu Code-Änderungen, Tests, Bugfixes oder Reviews führt.
- Die Datei kann mit anderen instructions.md-Dateien kombiniert werden, um projektspezifische Regeln zu ergänzen.

---

## Struktur einer Observation

Jede Observation im Worklog enthält:
- Zeitstempel (automatisch oder manuell)
- Datei/Feature/Modul
- Aktion (Implementierung, Bugfix, Test, Review, Fehler, Lösung)
- Beschreibung (Was wurde gemacht? Warum? Optional: Code-Snippet)
- Status (optional: success/fail)

**Beispiel:**
```
[2025-07-29 10:15] [klassen_screen.dart] [Implementierung] Responsive Dialog-Logik für mobile/desktop umgesetzt.
[2025-07-29 10:22] [klasse_dialog_temp.dart] [Fehler] FormControlParentNotFoundException beim Öffnen des Dialogs.
[2025-07-29 10:25] [klasse_dialog_temp.dart] [Lösung] ReactiveForm um das gesamte Scaffold gelegt, Fehler behoben.
```

---

## Automatisiertes Logging-Pattern

- Nach jedem `apply_patch`, `run_in_terminal`, Commit oder Testlauf wird automatisch eine Observation an den Memory-MCP-Server gesendet.
- Bei Fehlern wird eine Observation mit Fehlerbeschreibung und Stacktrace gespeichert.
- Nach erfolgreichem Fix wird eine weitere Observation mit der Lösung gespeichert.
- Am Ende der Session kann der Agent alle Observations als Markdown-Worklog exportieren (z.B. unter `docs/WORKLOG_YYYY-MM-DD_hh-mm_[name].md`).

## Datei-Namenskonvention

WORKLOG-Dateien folgen der Namenskonvention: `WORKLOG_YYYY-MM-DD_hh-mm_[name].md`

**Format-Erklärung:**
- `YYYY-MM-DD`: Erstellungsdatum (ISO 8601 Format)
- `hh-mm`: Erstellungszeit (Stunden und Minuten im 24h-Format)
- `[name]`: Beschreibender Name des Features/Moduls/Fixes

**Beispiele:**
- `WORKLOG_2025-07-29_21-03_ResponsiveDialog_DataTable.md`
- `WORKLOG_2025-07-30_11-07_Kuerzel_Feature.md`
- `WORKLOG_2025-07-30_12-25_StammdatenView_Implementation.md`


## Best Practices

- **Klar und präzise**: Jede Observation sollte verständlich und nachvollziehbar sein.
- **Chronologisch**: Die Reihenfolge der Observations bildet den tatsächlichen Arbeitsverlauf ab.
- **Verlinkung**: Bei Fehlern und deren Lösungen sollte eine Referenz (z.B. Fehler-ID oder Zeitstempel) gesetzt werden.
- **Export**: Das finale Worklog dient als Dokumentation und kann für Reviews, Audits oder Wissensmanagement genutzt werden.

---

## Beispiel für eine Worklog-Session

```
[2025-07-29 09:00] [Start] Beginn der Arbeitssitzung.
[2025-07-29 09:10] [klassen_screen.dart] [Implementierung] Responsive Layout für Klassenübersicht begonnen.
[2025-07-29 09:30] [klasse_dialog_temp.dart] [Implementierung] Fullscreen-Dialog für mobile Geräte umgesetzt.
[2025-07-29 09:45] [klasse_dialog_temp.dart] [Fehler] FormControlParentNotFoundException beim Öffnen des Dialogs.
[2025-07-29 09:50] [klasse_dialog_temp.dart] [Lösung] ReactiveForm um das gesamte Scaffold gelegt, Fehler behoben.
[2025-07-29 10:00] [klassen_screen.dart] [Fehler] BoxConstraints has non-normalized height constraints in DataTable.
[2025-07-29 10:05] [klassen_screen.dart] [Lösung] Responsive Logik in DataTable entfernt, feste Werte gesetzt.
[2025-07-29 10:30] [Ende] Alle Features und Fixes erfolgreich getestet.
```

---

## Hinweise

- Die Instructions können beliebig erweitert und an projektspezifische Anforderungen angepasst werden.
- Sie können mit anderen `.instructions.md`-Dateien kombiniert und in Prompt-Files referenziert werden.
