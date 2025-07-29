# App-Konzept: "Lehrer-Assistent" für HTLs

- **Datum:** 29. Juli 2025
- **Version:** 0.1

---

## 1. 💡 Kernidee & Vision

Eine mobile und Desktop-Anwendung, die speziell für Lehrer an Höheren Technischen Lehranstalten (HTLs) in Österreich entwickelt wurde, um die Verwaltung von Schülern und deren vielfältigen Leistungen drastisch zu vereinfachen. Die App soll den administrativen Aufwand minimieren und es Lehrern ermöglichen, sich auf das Unterrichten zu konzentrieren.

**Motto:** "Weniger verwalten, mehr unterrichten."

---

## 2. 🎯 Zielgruppe

- **Primär:** Lehrer an Höheren Technischen Lehranstalten (HTLs).
- **Sekundär:** Lehrer an anderen berufsbildenden höheren Schulen (z.B. HAK, HUM) mit komplexen Leistungsbeurteilungen.

---

## 3. 😫 Problem & Lösung

### Das Problem
Lehrer an HTLs müssen eine breite Palette von Leistungsarten verwalten, die über einfache Tests und Hausaufgaben hinausgehen:
- Mündliche Mitarbeit (oft spontan im Unterricht)
- Schriftliche Tests und Schularbeiten
- Praktische Werkstätten- und Laborübungen
- Komplexe, mehrwöchige Software- und Hardware-Projekte
- Wiederholungsprüfungen

Die Verwaltung erfolgt oft in uneinheitlichen Systemen (Excel, Notizbücher), was die objektive Notenfindung am Ende des Semesters kompliziert, zeitaufwändig und fehleranfällig macht.

### Die Lösung
Eine "All-in-One"-App, die:
1.  **Schnelle Erfassung:** Ermöglicht die blitzschnelle Protokollierung von Leistungen (besonders mündliche Mitarbeit) direkt im Unterricht.
2.  **Strukturierte Beurteilung:** Bietet Vorlagen und Schemata zur Bewertung von komplexen Projekten und praktischen Übungen.
3.  **Transparente Notenfindung:** Nutzt vom Lehrer definierbare Leistungsbeurteilungskonzepte (Gewichtungen), um automatisch einen nachvollziehbaren Notenvorschlag zu errechnen.
4.  **Zentrale Organisation:** Bündelt alle schülerbezogenen Informationen (Noten, Anmerkungen, Projekte) an einem Ort.

---

## 4. ✨ Kernfunktionen (MVP - Minimum Viable Product)

### A. Verwaltung (Desktop/Tablet optimiert)
- **Klassen- & Schüler-Management:** Anlegen und Verwalten von Klassen und Schülern.
- **Fächer-Management:** Anlegen von Fächern, die ein Lehrer unterrichtet.
- **Leistungsbeurteilungskonzepte:**
    - Erstellen von Konzepten pro Fach/Klasse (z.B. 50% Schularbeiten, 30% Projekte, 20% Mündlich).
    - Definieren von Kategorien (Schularbeit, Test, Projekt, Mitarbeit, etc.).

### B. Leistungserfassung (Mobile/Tablet optimiert)
- **Schnellerfassungs-Dashboard:** Ansicht pro Klasse für den schnellen Zugriff.
- **Mitarbeit protokollieren:** Einfache +/- Eingabe oder kurze Notiz für mündliche Leistungen.
- **Standard-Anmerkungen:** Vordefinierte, schnelle Kommentare ("gut mitgearbeitet", "Hausübung vergessen").
- **Detaillierte Leistungseingabe:** Eingabe von Noten für Tests, Projekte etc. mit Datum und Notiz.
- **Strukturierte Beurteilungsbögen:** Für Projekte und Laborübungen.

### C. Auswertung & Berichte (Desktop/Tablet optimiert)
- **Notenübersicht:** Detaillierte Leistungsübersicht pro Schüler.
- **Notenvorschlag:** Automatische Berechnung der Gesamtnote basierend auf dem hinterlegten Konzept.
- **Statistiken (Nice-to-have im MVP):**
    - Notenspiegel der Klasse.
    - Leistungsentwicklung eines Schülers.

---

## 5. 🔧 Technische Anforderungen & Architektur

- **Plattform:** Multiplattform-App mit **Flutter**.
    - **Mobile:** iOS, Android (Fokus auf schneller Erfassung).
    - **Desktop:** Windows, macOS, Linux (Fokus auf Verwaltung und Auswertung).
    - **Web:** Als mögliche zukünftige Erweiterung.
- **Datenhaltung:** **Local-First Ansatz**.
    - Jedes Gerät hält eine vollständige, lokale Kopie der Daten (z.B. in einer lokalen SQLite-Datenbank).
    - Die App ist vollständig offline-fähig.
- **Synchronisierung:**
    - **Primär & Voraussetzung:** Direkte Synchronisierung zwischen den Geräten eines Benutzers über **Bluetooth**. Dies ist ein Kernfeature für den datenschutzkonformen Abgleich ohne Cloud.
    - **Optional:** Eine Ende-zu-Ende-verschlüsselte Cloud-Synchronisierung als Opt-in für Benutzer, die den Komfort wünschen.

---

## 6. 💎 Einzigartigkeit & Vorteile

- **HTL-Fokus:** Maßgeschneidert für die komplexen Anforderungen des technischen Schulwesens.
- **Datenschutz durch Design:** Local-First und Bluetooth-Sync als Standard. Keine erzwungene Cloud-Nutzung.
- **Effizienz im Unterricht:** Die schnelle Erfassung stört den Unterrichtsfluss minimal.
- **Objektivität & Transparenz:** Nachvollziehbare Notengebung durch klare Konzepte.
- **Plattformunabhängigkeit:** Nahtloses Arbeiten auf allen Geräten des Lehrers.
