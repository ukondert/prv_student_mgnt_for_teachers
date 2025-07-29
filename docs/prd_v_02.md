# PRD: Lehrer-Cockpit

**Version:** 1.0
**Datum:** 29. Juli 2025
**Status:** In Entwicklung

## 1. Übersicht und Hintergrund

Dieses Dokument beschreibt die Anforderungen für das "Lehrer-Cockpit", eine plattformübergreifende Anwendung für Lehrer an Höheren Technischen Lehranstalten (HTL). Die App soll die tägliche Verwaltung von Schülerleistungen vereinfachen, die Objektivität der Benotung erhöhen und die administrative Last reduzieren. Die Entwicklung erfolgt mit Flutter, um eine breite Geräteunterstützung (Smartphone, Tablet, Desktop) zu gewährleisten. Kernmerkmale sind ein Local-First-Datenansatz, Offline-Fähigkeit und eine primäre Synchronisation via Bluetooth.

## 2. Ziele und Erfolgskriterien

### Projektziele
- **Effizienzsteigerung:** Reduzierung der Zeit für die Erfassung und Verwaltung von Noten um mindestens 30 % im Vergleich zu manuellen Methoden (z. B. Excel).
- **Objektivität und Transparenz:** Schaffung einer nachvollziehbaren und fairen Notengrundlage durch strukturierte Beurteilungssysteme.
- **Datenhoheit und Sicherheit:** Sicherstellung, dass sensible Schülerdaten primär auf den Geräten der Lehrkräfte verbleiben.
- **Benutzerfreundlichkeit:** Eine intuitive Benutzeroberfläche, die für die schnelle Erfassung im Unterrichtsgeschehen optimiert ist.

### Erfolgskriterien (KPIs)
- **Aktive Nutzung:** Mindestens 80 % der Nutzer erfassen wöchentlich Leistungen mit der App.
- **Feature-Adoption:** Mindestens 70 % der Nutzer haben mindestens ein benutzerdefiniertes Leistungsbeurteilungskonzept erstellt.
- **Synchronisations-Erfolg:** Die Bluetooth-Synchronisation wird von mindestens 90 % der Multi-Device-Nutzer erfolgreich eingesetzt.
- **Benutzerzufriedenheit:** Eine durchschnittliche Bewertung von 4.5 Sternen oder höher in den App Stores.

## 3. Annahmen und Abhängigkeiten

### Annahmen
- Die Zielgruppe (HTL-Lehrer) ist technisch affin und offen für den Einsatz digitaler Werkzeuge.
- Lehrer besitzen die notwendige Hardware (Smartphone, Tablet oder Laptop).
- Die Bluetooth-Funktionalität der Zielgeräte ist für eine zuverlässige Synchronisation ausreichend.

### Abhängigkeiten
- Das Projekt ist auf das Flutter-Framework und dessen plattformspezifische Kompatibilität angewiesen.
- Die Funktionalität ist von den Bluetooth-APIs der jeweiligen Betriebssysteme (iOS, Android, macOS, Windows) abhängig.

## 4. User Stories und Anforderungen

### 4.1. Kern-Infrastruktur

| ID | User Story | Akzeptanzkriterien | Priorität |
| :--- | :--- | :--- | :--- |
| **GH-001** | Als Lehrer möchte ich, dass meine Daten primär lokal auf meinem Gerät gespeichert werden (Local-First), | - Alle Daten (Schüler, Noten, etc.) werden in einer lokalen Datenbank auf dem Gerät gespeichert.<br>- Die App ist vollständig offline funktionsfähig.<br>- Es findet keine automatische Datenübertragung an einen Cloud-Server statt. | Hoch |
| **GH-002** | Als Lehrer möchte ich meine Daten sicher und direkt zwischen meinen Geräten (z.B. Tablet und Laptop) via Bluetooth synchronisieren, | - Die App bietet eine manuelle Funktion "Geräte synchronisieren".<br>- Die App erkennt andere Geräte mit derselben App im lokalen Netzwerk (via Bluetooth).<br>- Ein Konfliktlösungsmechanismus (z.B. Last-Write-Wins) stellt die Datenkonsistenz sicher.<br>- Die Synchronisation überträgt alle neuen oder geänderten Daten seit dem letzten Sync. | Hoch |
| **GH-003** | Als Lehrer möchte ich optional meine Daten in einer Cloud sichern und synchronisieren können, | - Die Cloud-Synchronisation ist standardmäßig deaktiviert.<br>- Der Nutzer muss die Cloud-Synchronisation explizit aktivieren und sich authentifizieren.<br>- Diese Funktion wird als kostenpflichtiges Add-on angeboten. | Mittel |

### 4.2. Stammdatenverwaltung (Desktop-optimiert)

| ID | User Story | Akzeptanzkriterien | Priorität |
| :--- | :--- | :--- | :--- |
| **GH-004** | Als Lehrer möchte ich Klassen anlegen und verwalten, | - Ich kann eine Klasse mit einem eindeutigen Namen (z.B. "4AHITS") und einem Schuljahr anlegen.<br>- Ich kann bestehende Klassen bearbeiten und archivieren. | Hoch |
| **GH-005** | Als Lehrer möchte ich Schüler zu meinen Klassen hinzufügen und deren Stammdaten pflegen, | - Pro Schüler können Vorname, Nachname, Schulemail und ein optionales Foto erfasst werden.<br>- Zusätzlich können Kontaktdaten der Eltern (Name, E-Mail, Telefon) und allgemeine Anmerkungen gespeichert werden.<br>- Schüler können einer oder mehreren Klassen zugewiesen werden. | Hoch |
| **GH-006** | Als Lehrer möchte ich Fächer anlegen, die ich unterrichte, | - Ich kann Fächer mit einem Namen (z.B. "Softwareentwicklung") anlegen.<br>- Ich kann Fächer Klassen zuordnen. | Hoch |

### 4.3. Leistungsbeurteilungskonzepte (Desktop-optimiert)

| ID | User Story | Akzeptanzkriterien | Priorität |
| :--- | :--- | :--- | :--- |
| **GH-007** | Als Lehrer möchte ich Vorlagen für Beurteilungskonzepte erstellen, | - Ich kann eine Vorlage mit einem Namen (z.B. "Standard Theorie-Fach") erstellen.<br>- In der Vorlage kann ich Leistungskategorien (z.B. "Mitarbeit", "Tests", "Projekte") definieren.<br>- Jeder Kategorie kann ich eine prozentuale Gewichtung für die Gesamtnote zuweisen (Summe muss 100 % ergeben). | Hoch |
| **GH-008** | Als Lehrer möchte ich einer Klasse in einem Fach ein Beurteilungskonzept zuweisen, | - Ich kann einer Kombination aus Klasse und Fach (z.B. "4AHITS - Softwareentwicklung") eine Vorlage zuweisen.<br>- Die zugewiesene Vorlage kann für diese spezifische Klasse noch angepasst werden. | Hoch |

### 4.4. Schnellerfassung im Unterricht (Mobil-optimiert)

| ID | User Story | Akzeptanzkriterien | Priorität |
| :--- | :--- | :--- | :--- |
| **GH-009** | Als Lehrer möchte ich eine Ansicht haben, die mir alle Schüler der aktuellen Stunde anzeigt, | - Nach Auswahl von Klasse und Fach sehe ich eine Liste aller Schüler.<br>- Die Ansicht ist für schnelle Interaktionen auf Tablets und Smartphones optimiert. | Hoch |
| **GH-010** | Als Lehrer möchte ich mit einem Klick die mündliche Mitarbeit eines Schülers protokollieren, | - Neben jedem Schüler gibt es einen Button (z.B. "+1").<br>- Ein Klick auf den Button erzeugt einen positiven Eintrag für "Mündliche Mitarbeit" für den heutigen Tag. | Hoch |
| **GH-011** | Als Lehrer möchte ich eine mündliche Wiederholung (Test) schnell benoten, | - Eine Aktion (z.B. langer Druck auf einen Schüler) öffnet ein Menü.<br>- Im Menü kann ich "Wiederholung" auswählen.<br>- Es erscheint ein Dialog zur Eingabe einer Note von 1 bis 5. | Hoch |

### 4.5. Strukturierte Leistungsbeurteilung

| ID | User Story | Akzeptanzkriterien | Priorität |
| :--- | :--- | :--- | :--- |
| **GH-012** | Als Lehrer möchte ich Vorlagen für Beurteilungsrubriken (z.B. für Projekte) erstellen, | - Ich kann eine Rubrik-Vorlage mit Kriterien (z.B. "Planung", "Umsetzung", "Doku") anlegen.<br>- Jedem Kriterium kann ich eine prozentuale Gewichtung zuweisen.<br>- Pro Kriterium kann ich eine Note (1-5) und eine textuelle Beurteilung erfassen. | Hoch |
| **GH-013** | Als Lehrer möchte ich eine Leistung (z.B. ein Software-Projekt) für einen Schüler anhand einer Rubrik bewerten, | - Ich kann einem Schüler eine neue "Projekt"-Leistung zuweisen.<br>- Ich wähle eine Rubrik-Vorlage aus.<br>- Ich fülle die Noten und Kommentare für jedes Kriterium aus.<br>- Die App berechnet automatisch die Gesamtnote für das Projekt basierend auf den gewichteten Kriterien. | Hoch |

### 4.6. Auswertungen und Notenfindung

| ID | User Story | Akzeptanzkriterien | Priorität |
| :--- | :--- | :--- | :--- |
| **GH-014** | Als Lehrer möchte ich eine Übersicht aller Leistungen eines Schülers in einem Fach sehen, | - Die Übersicht zeigt alle erfassten Leistungen, gruppiert nach den Kategorien aus dem Beurteilungskonzept.<br>- Pro Kategorie wird eine Durchschnittsnote angezeigt. | Hoch |
| **GH-015** | Als Lehrer möchte ich, dass die App mir eine vorläufige Gesamtnote für einen Schüler berechnet, | - Basierend auf den Durchschnittsnoten der Kategorien und deren Gewichtung wird eine Gesamtnote (z.B. 2.45) berechnet.<br>- Die App schlägt eine gerundete Endnote vor (z.B. "Gut (2)"). | Hoch |

## 5. Nicht-funktionale Anforderungen

- **Performance:** Die App muss auf allen Zielgeräten flüssig laufen. Die Startzeit der App sollte unter 3 Sekunden liegen. UI-Interaktionen müssen ohne spürbare Verzögerung erfolgen.
- **Plattform-Unterstützung:** Die App muss für iOS, Android, macOS und Windows entwickelt und getestet werden. Das UI-Design muss sich responsiv an verschiedene Bildschirmgrößen anpassen.
- **Datenschutz:** Es werden keine lokalen Daten verschlüsselt, aber die App muss die DSGVO-Grundsätze einhalten. Der Nutzer muss über die Datenspeicherung informiert werden.
- **Benutzerfreundlichkeit:** Die Navigation muss konsistent und vorhersehbar sein. Die wichtigsten Aktionen (Schnellerfassung) müssen mit maximal zwei Klicks erreichbar sein.

## 6. Zukünftige Erweiterungen (Out of Scope für V1)

- Detaillierte statistische Auswertungen mit grafischer Darstellung.
- Erstellung von Standard-Anmerkungen für die schnelle Protokollierung.
- Daten-Export als PDF oder CSV.
- Sitzplan-Ansicht für die Schnellerfassung.
- Anwesenheitskontrolle.
