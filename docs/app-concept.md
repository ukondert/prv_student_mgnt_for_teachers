# App Konzept: Lehrer-Cockpit

## 📱 App Konzept Übersicht

### Grundidee
**App Name:** Lehrer-Cockpit (Arbeitstitel)
**Kategorie:** Produktivität / Bildung
**Zielgruppe:** Lehrer an Höheren Technischen Lehranstalten (HTL)

**Elevator Pitch:** 
Das Lehrer-Cockpit ist eine für HTL-Lehrer optimierte Flutter-App zur mühelosen Verwaltung von Schülerleistungen. Sie ermöglicht die schnelle Erfassung von mündlicher Mitarbeit und die strukturierte Beurteilung von Projekten direkt im Unterricht. Mit einem Local-First-Ansatz, Bluetooth-Synchronisation und optionaler Cloud-Anbindung behalten Lehrer die volle Datenkontrolle und können Noten transparent und objektiv ermitteln.

## 🎯 Problem & Lösung

### Problem Statement
- **Was ist das Problem?** HTL-Lehrer müssen eine Vielzahl unterschiedlicher Leistungsarten (mündliche Mitarbeit, Wiederholungen, Projekte, Laborübungen, Tests) verwalten. Die Erfassung während des Unterrichts ist oft umständlich, zeitaufwändig und führt zu einer unstrukturierten Zettelwirtschaft. Die anschließende Zusammenführung zu einer fairen, objektiven Gesamtnote ist komplex.
- **Wer hat dieses Problem?** Primär Lehrer an HTLs und ähnlichen technischen/berufsbildenden Schulen.
- **Wie schwerwiegend ist es?** Hoch. Es kostet wertvolle Zeit, führt zu potenziell subjektiven Bewertungen und erhöht den administrativen Aufwand erheblich.
- **Marktgröße:** Tausende Lehrer im deutschsprachigen Raum (Österreich, Deutschland).

### Lösungsansatz
- **Kernlösung:** Eine Multi-Plattform-App (Smartphone, Tablet, Desktop), die eine blitzschnelle Erfassung von Leistungen im Unterricht (Tagesansicht pro Klasse) und eine durchdachte Verwaltung von Schülern, Klassen und Beurteilungsschemata am Desktop ermöglicht.
- **Differenzierung:** Der Fokus auf HTL-spezifische Anforderungen (Projekte, Laborübungen), der "Local-First"-Ansatz mit standardmäßiger Bluetooth-Synchronisation und die Flexibilität durch anpassbare Leistungsbeurteilungskonzepte.
- **Wertversprechen:** Spare täglich Zeit, erhöhe die Objektivität deiner Notengebung und habe alle Leistungsdaten sicher und jederzeit griffbereit – auch ohne Internet.

## 👥 Zielgruppe & User Personas

### Primäre Zielgruppe
- **Demografisch:** Lehrer an HTLs, Alter 30-60, technisch affin.
- **Verhalten:** Nutzen bereits digitale Werkzeuge zur Unterrichtsvorbereitung, sind aber mit bestehenden Notenverwaltungslösungen unzufrieden. Besorgt um den Datenschutz von Schülerdaten.
- **Pain Points:** Zeitmangel, unübersichtliche Notenaufzeichnungen, Druck zur objektiven Benotung, schlechtes WLAN in Werkstätten/Laboren.

### User Personas (1 Haupttyp)
1. **DI Peter "Peda" Maier** - 45, Lehrer für Softwareentwicklung & Netzwerktechnik
   - **Motivation:** Seinen Schülern praxisnahes Wissen vermitteln und dabei fair und transparent bewerten.
   - **Ziele:** Weniger Zeit mit Verwaltung verbringen, eine klare Grundlage für Elterngespräche haben, mündliche Mitarbeit einfach erfassen, ohne den Unterrichtsfluss zu stören.
   - **Frustration:** Verliert oft den Überblick über die mündliche Mitarbeit, Notenlisten in Excel sind umständlich auf dem Tablet, will Schülerdaten nicht in einer US-Cloud speichern.

## 🚀 Core Features & User Stories

### MVP Features (Phase 1)
1. **Klassen- & Schülerverwaltung**
   - **User Story:** Als Lehrer möchte ich meine Klassen und Schüler einfach anlegen und verwalten, um eine zentrale Datenbasis zu haben.
   - **Priorität:** Hoch
   - **Wert für User:** Grundvoraussetzung für alle weiteren Funktionen.

2. **Schnellerfassung im Unterricht**
   - **User Story:** Als Lehrer möchte ich während des Unterrichts mit wenigen Klicks mündliche Mitarbeit, Wiederholungen oder kurze Anmerkungen für einzelne Schüler protokollieren, um den Unterrichtsfluss minimal zu stören.
   - **Priorität:** Hoch
   - **Wert für User:** Das "Killer-Feature", das den größten täglichen Schmerz löst.

3. **Strukturierte Leistungsbeurteilung**
   - **User Story:** Als Lehrer möchte ich komplexe Leistungen wie Projekte oder Laborübungen anhand von vordefinierten Kriterien strukturiert beurteilen können, um eine objektive Bewertung zu gewährleisten.
   - **Priorität:** Hoch
   - **Wert für User:** Sichert die Qualität und Fairness der Benotung.

4. **Leistungsbeurteilungskonzepte**
   - **User Story:** Als Lehrer möchte ich pro Fach festlegen können, wie sich die Gesamtnote aus einzelnen Leistungskategorien (z.B. 50% schriftlich, 30% praktisch, 20% mündlich) zusammensetzt, um die Notenfindung zu automatisieren.
   - **Priorität:** Hoch
   - **Wert für User:** Schafft Transparenz und automatisiert die Notenberechnung.

5. **Local-First & Bluetooth-Sync**
   - **User Story:** Als Lehrer möchte ich meine Daten primär auf meinen Geräten speichern und sie direkt via Bluetooth zwischen meinem Tablet und Laptop synchronisieren können, um unabhängig vom Internet und datenschutzkonform zu arbeiten.
   - **Priorität:** Hoch
   - **Wert für User:** Garantiert Datenhoheit, Sicherheit und Offline-Fähigkeit.

### Advanced Features (Phase 2+)
- **Optionale Cloud-Synchronisation:** Für Nutzer, die ein zentrales Backup oder eine Synchronisation über das Internet wünschen (als Opt-in-Abo-Modell).
- **Statistische Auswertungen:** Visuelle Darstellung von Notenverteilungen, Leistungsentwicklung einzelner Schüler oder der ganzen Klasse.
- **Standard-Anmerkungen:** Vordefinierte, schnelle Kommentare ("gut mitgearbeitet", "Hausübung vergessen") zur schnellen Protokollierung.
- **Daten-Export:** Export von Notenlisten und Leistungsübersichten als PDF oder CSV.

## 🎨 User Experience Vision

### Design-Prinzipien
- **Geschwindigkeit vor Schönheit:** Die UI muss für extrem schnelle Eingaben im Unterricht optimiert sein.
- **Kontextsensitiv:** Die App zeigt auf dem Smartphone/Tablet die Unterrichtsansicht, auf dem Desktop die Verwaltungsansicht.
- **Zuverlässigkeit:** Der Local-First-Ansatz sorgt dafür, dass die App immer funktioniert.

### Key User Flows
1. **Unterrichtsstunde:** Lehrer wählt Klasse, sieht Schülerliste, tippt auf Schüler, wählt Leistungstyp (z.B. "+ Mitarbeit"), fertig.
2. **Synchronisation:** Lehrer stößt am Tablet die Synchronisation an, die App findet den Laptop via Bluetooth und gleicht die Daten ab.
3. **Notenkonferenz:** Lehrer öffnet die App am Laptop, sieht die automatisch berechneten Gesamtnoten und kann Details zu jedem Schüler einsehen.

## 💰 Business Model

### Monetization Strategy
**Primär:** One-Time-Purchase (Einmalkauf) für die Vollversion der App.
**Begründung:** Lehrer bevorzugen oft klare, einmalige Kosten statt laufender Abos für ihre Arbeitswerkzeuge.

### Revenue Streams
- **Haupteinnahmequelle:** Verkauf der App in den App Stores (iOS, Android, macOS, Windows).
- **Nebeneinnahmequelle (Phase 2):** Ein optionales Abo-Modell für die Cloud-Synchronisation und erweiterte statistische Analysen.

## 🏆 Competitive Landscape

### Direkte Konkurrenten
1. **TeacherTool (iOS/macOS):** Sehr etabliert, aber nur für Apple-Geräte und mit einer komplexen UI.
2. **Untis (mit Klassenbuch):** Weit verbreitet, aber Fokus liegt auf Stundenplanung, nicht auf detaillierter Leistungsverwaltung.
3. **Excel/Google Sheets:** Maximale Flexibilität, aber extrem umständlich in der Praxis und nicht für schnelle Erfassung geeignet.

### Unser Competitive Advantage
- **Plattformübergreifend:** Dank Flutter auf allen relevanten Geräten verfügbar.
- **HTL-Fokus:** Maßgeschneidert für die Bedürfnisse von technischen Fächern.
- **Datenschutz-by-Design:** Der Local-First- und Bluetooth-Ansatz ist ein starkes Alleinstellungsmerkmal.

## 🎯 Success Metrics & Ziele

### Key Performance Indicators (KPIs)
- **User Engagement:** Anzahl der pro Tag erfassten Leistungsbeurteilungen.
- **User Retention:** Anteil der Lehrer, die die App nach einem Semester noch aktiv nutzen.
- **Plattform-Nutzung:** Verteilung der Nutzung zwischen mobilen und Desktop-Geräten.

## ⚙️ Grundlegende Anforderungen

### Platform Anforderungen
- **Zielplattformen:** iOS, Android, macOS, Windows, Linux (Web optional).
- **Offline-Fähigkeit:** Alle Kernfunktionen müssen ohne Internetverbindung verfügbar sein.
- **Integration:** Bluetooth für die Synchronisation.

### Datenschutz & Sicherheit
- **Datenschutz:** Alle Daten werden standardmäßig nur lokal auf den Geräten des Nutzers gespeichert. Keine Übertragung an Dritte ohne explizite Zustimmung (Cloud-Sync).
- **Sicherheit:** Verschlüsselung der lokalen Datenbank.

## 📋 Risiken & Bedenken

### Umsetzungsrisiken
- **Komplexität der Synchronisation:** Die Implementierung einer robusten, konfliktfreien Synchronisation (CRDTs) ist anspruchsvoll.
- **Bluetooth-Konnektivität:** Die Zuverlässigkeit von Bluetooth kann je nach Gerät und Betriebssystem variieren.

---

**Erstellt am:** 29. Juli 2025
**Version:** 1.0
**Status:** Bereit für PRD-Entwicklung

**Nächster Schritt:** Detaillierte Ausarbeitung der Features und User Stories.
