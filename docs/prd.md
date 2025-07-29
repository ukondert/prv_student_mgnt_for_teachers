## PRD: Lehrer-Cockpit

## 1. Product overview

### 1.1 Document title and version

1. PRD: Lehrer-Cockpit
2. Version: 1.0

### 1.2 Product summary

1. Das "Lehrer-Cockpit" ist eine für Lehrer an Höheren Technischen Lehranstalten (HTL) konzipierte Flutter-Anwendung. Ihr Hauptzweck ist die Vereinfachung und Digitalisierung der Schülerleistungsverwaltung. Die App ermöglicht es Lehrkräften, verschiedenste Leistungsarten – von der schnellen Protokollierung mündlicher Mitarbeit im Unterricht bis hin zur strukturierten Beurteilung komplexer technischer Projekte – effizient zu erfassen und zu verwalten.

2. Ein zentrales Merkmal ist der "Local-First"-Ansatz, bei dem alle Daten primär auf den Geräten des Nutzers gespeichert werden, um volle Offline-Fähigkeit und maximalen Datenschutz zu gewährleisten. Die Synchronisation zwischen Geräten (z.B. Tablet und Laptop) erfolgt standardmäßig über eine direkte Bluetooth-Verbindung. Eine optionale, Ende-zu-Ende-verschlüsselte Cloud-Synchronisation kann als Premium-Funktion hinzugefügt werden.

## 2. Goals

### 2.1 Business goals

1.  **Markteinführung:** Erfolgreiche Einführung einer kaufbaren Basisversion der App in den gängigen App Stores (Apple App Store, Google Play Store, Microsoft Store) innerhalb der nächsten 9 Monate.
2.  **Monetarisierung:** Etablierung eines optionalen Abonnement-Modells für Premium-Funktionen wie die Cloud-Synchronisation, um wiederkehrende Einnahmen zu generieren.
3.  **Kundenbindung:** Erreichen einer hohen Benutzerzufriedenheit (durchschnittlich >4.5 Sterne), um eine starke Basis für Mundpropaganda im Bildungssektor zu schaffen.

### 2.2 User goals

1.  **Zeitersparnis:** Den administrativen Aufwand für die Notenverwaltung im Vergleich zu analogen oder Excel-basierten Methoden signifikant reduzieren.
2.  **Objektivität & Transparenz:** Eine klare, nachvollziehbare und faire Grundlage für die Notengebung durch anpassbare Beurteilungskonzepte und Rubriken schaffen.
3.  **Flexibilität & Kontrolle:** Jederzeit und überall – auch offline – auf alle relevanten Leistungsdaten zugreifen und die volle Kontrolle über die eigenen Daten behalten.
4.  **Fokussierung:** Den Unterrichtsfluss so wenig wie möglich stören, indem Leistungen schnell und intuitiv erfasst werden können.

### 2.3 Non-goals

1.  **Schulverwaltungssystem:** Die App ist kein Ersatz für offizielle Schulverwaltungssysteme (wie Sokrates, Untis etc.). Sie dient der persönlichen Arbeitserleichterung des Lehrers. Ein Daten-Import/-Export ist für V1 nicht geplant.
2.  **Kommunikationsplattform:** Die App wird keine Chat- oder Kommunikationsfunktionen zwischen Lehrern, Schülern oder Eltern enthalten.
3.  **Stunden- und Vertretungsplanung:** Diese Funktionen sind explizit nicht Teil des Funktionsumfangs.
4.  **Anwesenheitsverwaltung:** Eine detaillierte Anwesenheitskontrolle ist für die erste Version nicht vorgesehen.

## 3. User personas

### 3.1 Key user types

1.  **HTL-Lehrer/in:** Die primäre und einzige Nutzergruppe. Sie unterrichtet sowohl theoretische als auch praktische Fächer und benötigt ein Werkzeug, das dieser Vielfalt gerecht wird.

### 3.2 Basic persona details

1.  **DI Peter "Peda" Maier**: Ein 45-jähriger, technikaffiner Lehrer für Softwareentwicklung und Netzwerktechnik an einer HTL. Er ist frustriert von der Zettelwirtschaft und unübersichtlichen Excel-Tabellen. Er sucht eine schnelle, datenschutzkonforme Lösung, die ihm hilft, seine vielfältigen Beurteilungen (Mitarbeit, Tests, Programmierprojekte) fair und effizient zu verwalten, ohne dafür auf eine Cloud angewiesen zu sein.

### 3.3 Role-based access

1.  **Lehrer**: Es gibt nur eine Benutzerrolle. Der Lehrer hat vollen Lese- und Schreibzugriff auf alle von ihm erstellten Daten (Klassen, Schüler, Leistungen). Es gibt keine geteilten Daten zwischen verschiedenen Lehrern.

## 4. Functional Requirements

1.  **ID**: FR-1
    *   **Feature**: Lokale Datenspeicherung (Local-First)
    *   **Priority**: Hoch
    *   **Description**: Alle Anwendungsdaten müssen standardmäßig auf dem Gerät des Benutzers in einer lokalen Datenbank gespeichert werden. Die App muss vollständig offline funktionsfähig sein.
2.  **ID**: FR-2
    *   **Feature**: Bluetooth-Synchronisation
    *   **Priority**: Hoch
    *   **Description**: Die App muss eine manuelle Synchronisation von Daten zwischen zwei Geräten desselben Benutzers über eine direkte Bluetooth-Verbindung ermöglichen. Ein Mechanismus zur Konfliktlösung (z.B. Last-Write-Wins) ist erforderlich.
3.  **ID**: FR-3
    *   **Feature**: Stammdatenverwaltung
    *   **Priority**: Hoch
    *   **Description**: Benutzer müssen Klassen, Fächer und Schüler anlegen und verwalten können. Schülerdaten umfassen Vor-/Nachname, E-Mail, optionales Foto sowie Kontaktdaten der Eltern und allgemeine Anmerkungen.
4.  **ID**: FR-4
    *   **Feature**: Verwaltung von Beurteilungskonzepten
    *   **Priority**: Hoch
    *   **Description**: Benutzer müssen Vorlagen für Beurteilungskonzepte erstellen können. Eine Vorlage definiert Leistungskategorien (z.B. Mitarbeit, Tests) und deren prozentuale Gewichtung an der Gesamtnote. Diese Konzepte können Fächern für unterschiedliche Klassen zugewiesen werden. (z.B. POS - 4. Klasse)
5.  **ID**: FR-5
    *   **Feature**: Schnellerfassung von Leistungen
    *   **Priority**: Hoch
    *   **Description**: In einer für Mobilgeräte optimierten Ansicht muss die mündliche Mitarbeit per einfachem Klick ("+1") und eine mündliche Wiederholung über ein Menü mit Notenauswahl (1-5) erfassbar sein.
6.  **ID**: FR-6
    *   **Feature**: Strukturierte Leistungsbeurteilung mit Rubriken
    *   **Priority**: Hoch
    *   **Description**: Benutzer müssen Vorlagen für Beurteilungsrubriken (z.B. für Projekte) mit gewichteten Kriterien erstellen können. Eine Leistung kann dann anhand dieser Rubrik mit Noten und Kommentaren pro Kriterium bewertet werden.
7.  **ID**: FR-7
    *   **Feature**: Notenberechnung
    *   **Priority**: Hoch
    *   **Description**: Die App muss basierend auf den erfassten Leistungen und dem zugewiesenen Beurteilungskonzept eine gewichtete Durchschnittsnote für jeden Schüler berechnen und einen Notenvorschlag anzeigen.

## 5. Non-Functional Requirements

### 5.1 User Experience Requirements

1.  **ID**: UX-1
    *   **Requirement**: Reaktionsfähigkeit
    *   **Description**: Alle UI-Interaktionen, insbesondere die Schnellerfassung, müssen ohne spürbare Verzögerung (<200ms) erfolgen. Die App muss sich flüssig anfühlen.
2.  **ID**: UX-2
    *   **Requirement**: Kontextoptimierte Ansichten
    *   **Description**: Die App muss erkennen, auf welchem Gerätetyp sie läuft, und eine passende UI bereitstellen (z.B. Listenansicht auf dem Smartphone, mehrspaltige Layouts auf dem Desktop).

### 5.2 UI Requirements

1.  **ID**: UI-1
    *   **Requirement**: Responsives Design
    *   **Description**: Das Layout muss sich an alle Ziel-Bildschirmgrößen anpassen, von kleinen Smartphones bis zu großen Desktop-Monitoren.
2.  **ID**: UI-2
    *   **Requirement**: Plattformkonformität
    *   **Description**: Die App soll die Design-Prinzipien von Material Design (Android/Windows) und Cupertino (iOS/macOS) respektieren, um sich nativ anzufühlen.

### 5.3 Advanced Features

1.  **ID**: AF-1
    *   **Feature**: Optionale Cloud-Synchronisation
    *   **Description**: Als Opt-in-Funktion (Abonnement) kann der Benutzer eine Ende-zu-Ende-verschlüsselte Cloud-Synchronisation aktivieren, um Daten über das Internet zu sichern und abzugleichen.

## 6. Narrative

DI Peter Maier beginnt seine Unterrichtsstunde in "Softwareentwicklung" mit der 4AHITS. Er öffnet das Lehrer-Cockpit auf seinem Tablet. Als ein Schüler eine brillante Frage stellt, tippt Peter neben dessen Namen auf den "+1"-Button, um die Mitarbeit zu protokollieren. Später, bei einer mündlichen Wiederholung, öffnet er per langem Druck das Menü und vergibt eine "2". In der Pause synchronisiert er sein Tablet via Bluetooth mit seinem Laptop im Kabinett. Am Nachmittag nutzt er die Desktop-App, um die eingereichten Softwareprojekte anhand seiner vordefinierten Rubrik ("Planung", "Umsetzung", "Doku") fair zu bewerten. Vor der Notenkonferenz wirft er einen Blick auf die automatisch berechneten Gesamtnoten und fühlt sich bestens vorbereitet.

## 7. Success metrics

### 7.1 User-centric metrics

1.  **Engagement:** Anzahl der pro Woche erfassten Leistungen pro aktivem Nutzer.
2.  **Retention:** Prozentsatz der Nutzer, die die App nach dem ersten Monat und nach dem ersten Semester weiterhin aktiv nutzen.
3.  **Feature Adoption:** Prozentsatz der Nutzer, die mindestens ein benutzerdefiniertes Beurteilungskonzept und eine Rubrik erstellt haben.

### 7.2 Business metrics

1.  **Verkäufe:** Anzahl der verkauften Lizenzen der Basis-App.
2.  **Conversion Rate:** Prozentsatz der Nutzer, die das optionale Cloud-Abonnement abschließen.
3.  **App Store Rating:** Durchschnittliche Bewertung in den jeweiligen App Stores.

### 7.3 Technical metrics

1.  **Stabilität:** Crash-freie Sitzungsrate von >99.5%.
2.  **Performance:** App-Startzeit unter 3 Sekunden auf Referenzgeräten.
3.  **Synchronisation:** Erfolgsrate der Bluetooth-Synchronisation >95%.

## 8. Technical considerations

### 8.1 Integration points

1.  **Bluetooth:** Nutzung der nativen Bluetooth-APIs von iOS, Android, macOS und Windows zur Geräteerkennung und Datenübertragung.
2.  **App Stores:** Anbindung an die In-App-Kauf-APIs von Apple und Google für das Cloud-Abonnement.

### 8.2 Data storage & privacy

1.  **Lokale Datenbank:** Verwendung einer robusten, plattformübergreifenden Datenbanklösung (z.B. SQLite via Drift/Moor oder Hive).
2.  **Datenschutz:** Die App muss DSGVO-konform sein. Es werden keine Daten ohne explizite Zustimmung des Nutzers (Opt-in für Cloud) an externe Server gesendet. Wie vom Nutzer spezifiziert, werden die lokalen Daten nicht zusätzlich verschlüsselt.

### 8.3 Scalability & performance

1.  **Skalierbarkeit:** Maximal Zuordnung von 40 Schüler pro Klasse, skallierbarkeit nicht notwendig
2.  **Performance:** Die Flutter-App muss unter Beachtung von Performance-Best-Practices (z.B. Vermeidung unnötiger Rebuilds) entwickelt werden.

### 8.4 Potential challenges

1.  **Bluetooth-Zuverlässigkeit:** Die Stabilität und Geschwindigkeit der Bluetooth-Verbindung kann je nach Hardware, Betriebssystem und Umgebungsbedingungen stark variieren.
2.  **Synchronisationslogik:** Die Entwicklung einer robusten, konfliktfreien Synchronisationslogik (CRDTs oder ähnliche Ansätze) ist komplex.
3.  **Plattformspezifische Unterschiede:** Die Implementierung der Bluetooth-Funktionalität und die Sicherstellung eines konsistenten Verhaltens auf allen Zielplattformen ist eine Herausforderung.

## 9. Milestones & sequencing

### 9.1 Project estimate

1.  **Mittel (M):** 4-6 Monate

### 9.2 Team size & composition

1.  **1-2 Entwickler:** 1-2 Flutter-Entwickler mit Erfahrung in der plattformübergreifenden Entwicklung.

### 9.3 Suggested phases

1.  **Phase 1: Fundament & Stammdaten (1-2 Monate)**
    *   Einrichtung des Flutter-Projekts, Implementierung der lokalen Datenbank, Erstellung der UI für die Verwaltung von Klassen, Fächern und Schülern (Desktop-optimiert).
2.  **Phase 2: Leistungserfassung (1-2 Monate)**
    *   Implementierung der mobil-optimierten Schnellerfassungs-UI. Entwicklung der Funktionalität für die strukturierte Beurteilung mittels Rubriken. Erstellung der Logik für Beurteilungskonzepte.
3.  **Phase 3: Kernlogik & Synchronisation (1-2 Monate)**
    *   Implementierung der Notenberechnungslogik. Entwicklung und Test der Bluetooth-Synchronisation.
4.  **Phase 4: Finalisierung & Release (1 Monat)**
    *   Testing auf allen Zielplattformen, Bug-Fixing, Vorbereitung und Einreichung bei den App Stores.

## 10. User stories

### 10.1. Infrastruktur & Datenhaltung

1.  **ID**: GH-001
2.  **Related Features**: FR-1
3.  **Description**: Als Lehrer möchte ich, dass meine Daten primär lokal auf meinem Gerät gespeichert werden, damit ich die volle Kontrolle habe und die App auch offline funktioniert.
4.  **Acceptance criteria**:
    1.  Alle Daten werden in einer lokalen Datenbank auf dem Gerät gespeichert.
    2.  Die App ist ohne Internetverbindung vollständig nutzbar.
    3.  Es findet keine automatische Datenübertragung an einen Cloud-Server statt.

2.  **ID**: GH-002
3.  **Related Features**: FR-2
4.  **Description**: Als Lehrer möchte ich meine Daten sicher und direkt zwischen meinen Geräten via Bluetooth synchronisieren, um auf allen Geräten den gleichen Datenstand zu haben.
5.  **Acceptance criteria**:
    1.  Die App bietet eine manuelle Funktion "Geräte synchronisieren".
    2.  Die App erkennt andere Geräte mit derselben App im lokalen Netzwerk via Bluetooth.
    3.  Ein Konfliktlösungsmechanismus stellt die Datenkonsistenz sicher.

3.  **ID**: GH-003
4.  **Related Features**: AF-1
5.  **Description**: Als Lehrer möchte ich optional meine Daten in einer Cloud sichern und synchronisieren können, falls ich ein Backup oder einen Abgleich über das Internet wünsche.
6.  **Acceptance criteria**:
    1.  Die Cloud-Synchronisation ist standardmäßig deaktiviert und muss explizit aktiviert werden.
    2.  Diese Funktion wird als kostenpflichtiges Add-on angeboten.

### 10.2. Stammdaten & Konzepte

1.  **ID**: GH-004
2.  **Related Features**: FR-3
3.  **Description**: Als Lehrer möchte ich Klassen und Fächer anlegen und verwalten, um meine Unterrichtsstruktur in der App abzubilden.
4.  **Acceptance criteria**:
    1.  Ich kann eine Klasse mit einem Namen und Schuljahr anlegen.
    2.  Ich kann Fächer mit einem Namen anlegen und sie Klassen zuordnen.

2.  **ID**: GH-005
3.  **Related Features**: FR-3
4.  **Description**: Als Lehrer möchte ich Schüler zu meinen Klassen hinzufügen und deren Stammdaten pflegen.
5.  **Acceptance criteria**:
    1.  Pro Schüler können Vorname, Nachname, Schulemail und ein optionales Foto erfasst werden.
    2.  Kontaktdaten der Eltern und allgemeine Anmerkungen können gespeichert werden.

3.  **ID**: GH-006
4.  **Related Features**: FR-4
5.  **Description**: Als Lehrer möchte ich Vorlagen für Beurteilungskonzepte erstellen und zuweisen, um die Notenfindung zu standardisieren.
6.  **Acceptance criteria**:
    1.  Ich kann eine Vorlage mit Leistungskategorien und deren prozentualer Gewichtung erstellen.
    2.  Ich kann einer Klasse in einem Fach eine Konzept-Vorlage zuweisen.

### 10.3. Leistungserfassung & Auswertung

1.  **ID**: GH-007
2.  **Related Features**: FR-5
3.  **Description**: Als Lehrer möchte ich im Unterricht mit einem Klick die mündliche Mitarbeit eines Schülers protokollieren.
4.  **Acceptance criteria**:
    1.  In der Unterrichtsansicht wird bei einem kurzen Klick auf den Schüler (Nameskürzel oder Bild), für die mündliche Mitarbeit ein Zähler inkrementiert (+1 Funktionalität)
    2. Ein Klick erzeugt einen positiven Eintrag für "Mündliche Mitarbeit" für den heutigen Tag.

5.  **ID**: GH-008
6.  **Related Features**: FR-5
7.  **Description**: Als Lehrer möchte ich eine mündliche Wiederholung schnell benoten können.
8.  **Acceptance criteria**:
    1.  Eine Aktion (z.B. langer Druck) in der Unterrichtsansicht auf den Schüler (Kürzel/Bild) öffnet ein Menü zur Auswahl von "Wiederholung".
    2.  Ein Dialog zur Eingabe einer Note von 1 bis 5 erscheint.

9.  **ID**: GH-009
4.  **Related Features**: FR-6
5.  **Description**: Als Lehrer möchte ich komplexe Leistungen wie Projekte anhand einer detaillierten Rubrik bewerten.
6.  **Acceptance criteria**:
    1.  Ich kann Rubrik-Vorlagen mit gewichteten Kriterien erstellen.
    2.  Ich kann eine Leistung anhand einer Rubrik bewerten, indem ich pro Kriterium eine Note und einen Kommentar vergebe.
    3.  Die App berechnet die Gesamtnote für die Leistung automatisch.

7.  **ID**: GH-010
5.  **Related Features**: FR-7
6.  **Description**: Als Lehrer möchte ich, dass die App mir eine vorläufige Gesamtnote für einen Schüler berechnet.
7.  **Acceptance criteria**:
    1.  Die App zeigt eine Übersicht aller Leistungen eines Schülers in einem Fach.
    2.  Basierend auf dem Beurteilungskonzept wird eine gewichtete Gesamtnote berechnet und angezeigt.
