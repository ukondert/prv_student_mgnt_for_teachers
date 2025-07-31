# Copilot-Anweisungen für das "Context Engineering" Template

## 1. Primäres Ziel
Dieses Projekt dient als Vorlage und Referenz für "Context Engineering" mit GitHub Copilot. Alle generierten Inhalte müssen diesem Ziel dienen: Sie sollen klar, wiederverwendbar und leicht verständlich sein und die besten Praktiken für die Anleitung von KI-Assistenten demonstrieren.

## 2. Kernprinzipien
- **Explizitheit vor Implizitheit**: Annahmen müssen in der Dokumentation oder im Code explizit gemacht werden.
- **Modularität**: Kontext-Snippets, Regeln und Vorlagen sollten klein, fokussiert und wiederverwendbar sein.
- **Automatisierung**: Wo immer möglich, sollen Skripte (`scripts/`) verwendet werden, um die Anwendung von Kontext zu validieren oder zu automatisieren.
- **Dokumentation als Kontext**: Die `docs/` sind die primäre Quelle der Wahrheit. Verweise darauf, anstatt Inhalte zu duplizieren.

## 3. Wichtige Dateien und ihre Rollen
- `docs/AGENT_RULES.md`: Die grundlegenden Verhaltensregeln für den Agenten. Halte dich strikt daran.
- `docs/PATTERNS.md`: Eine Sammlung bewährter Lösungsansätze. Bevorzuge diese, wenn anwendbar.
- `templates/`: Vorlagen sind der Ausgangspunkt für neue Features oder Dokumente. Frage nach, welche Vorlage verwendet werden soll.
- `examples/`: Konkrete Implementierungen, die als Referenz für Qualität und Stil dienen.

## 4. Technischer Leitfaden
- **Programmier - Sprache**: ergibt sich aus dem Projekt Context, Markdown für Dokumentation (`.md`).
- **Code - Sprache** (für Klassen, Interfaces, Methoden, Variablen usw.): Englisch wenn nicht explizt vom Benutzer anders vorgegeben   
- **MCP-Server**: Nutze die in `docs/MCP_SERVERS.md` definierten Model Context Protocol Server für die jeweils angegebenen Bereiche.
- **Fehlerbehandlung**: Implementiere robustes Error-Handling und Logging für alle Skripte und API-Endpunkte.

## 5. Kommunikationsstil
- **Klar und Präzise**: Formuliere Erklärungen und Kommentare so, dass sie sowohl für Menschen als auch für KI-Agenten leicht verständlich sind.
- **Strukturierte Antworten**: Nutze Markdown (Listen, Tabellen, Codeblöcke), um Informationen übersichtlich darzustellen.
- **Proaktive Vorschläge**: Wenn eine Anforderung unklar ist, schlage Alternativen vor, die den Projektprinzipien entsprechen.
- **Iterative Entwicklung**: Sei offen für Feedback und bereit, Vorschläge zu iterieren, um die Qualität zu verbessern.