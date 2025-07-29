# Use-Case-getriebener Implementierungs-Workflow

Dieser Workflow beschreibt den Prozess der technischen Umsetzung (Implementierung und Test), nachdem die Anwendungsfälle (Use Cases) bereits vollständig analysiert und spezifiziert wurden. Der Use Case dient hierbei als direkter Bauplan für die Entwicklung.

## Kernprinzip

Jeder Use Case repräsentiert eine in sich geschlossene, wertschöpfende Funktionalität aus Nutzersicht. Der Implementierungs-Workflow zerlegt diesen Use Case in konkrete Entwicklungs- und Testaufgaben für Frontend und Backend.

---

## Phasen des Implementierungs-Workflows

### Phase 1: Vorbereitung der Implementierung (Use-Case-Auswahl)

*   **Aktivität:**
    *   Das Entwicklungsteam wählt einen oder mehrere priorisierte Use Cases für die Umsetzung in einem Entwicklungszyklus (z. B. einem Sprint) aus.
*   **Input-Artefakte für das Team:**
    *   **Detaillierte Use-Case-Beschreibung:** Der textuelle Ablauf (Flow of Events), inklusive Hauptszenario ("Happy Path"), alternativen Abläufen und Fehlerfällen.
    *   **Realisierungsdiagramme (z. B. UML-Sequenzdiagramme):** Diese Diagramme zeigen, wie die Systemkomponenten (UI, Controller, Services, Datenbank) zusammenspielen müssen, um den Use Case zu erfüllen. Sie definieren die notwendigen Methodenaufrufe und Schnittstellen.
*   **Ziel:**
    *   Ein klares, gemeinsames Verständnis im Team schaffen, welche technische Logik und welche Schnittstellen für den ausgewählten Use Case benötigt werden.

### Phase 2: Parallele Implementierung (Frontend & Backend)

Die Umsetzung erfolgt in der Regel parallel, geleitet durch die in den Diagrammen definierten Schnittstellen und Verantwortlichkeiten.

*   **Backend-Implementierung:**
    *   **Aufgabe:** Die serverseitige Logik für den Use Case erstellen.
    *   **Aktivitäten:**
        1.  **API-Endpunkte erstellen:** Anlegen der Schnittstellen (z. B. REST-Endpunkte), die vom Frontend aufgerufen werden.
        2.  **Geschäftslogik implementieren:** Programmieren der Services und Controller, die die im Use Case beschriebenen Verarbeitungsschritte ausführen.
        3.  **Datenzugriff realisieren:** Anbinden der Datenbank und Implementieren der Lese- und Schreibvorgänge.
    *   **Fokus:** Die im Sequenzdiagramm gezeigten serverseitigen Interaktionen in Code umsetzen.

*   **Frontend-Implementierung:**
    *   **Aufgabe:** Die Benutzeroberfläche für den Use Case erstellen.
    *   **Aktivitäten:**
        1.  **UI-Komponenten entwickeln:** Erstellen der Masken, Formulare und Bedienelemente, die der Nutzer für die Interaktion benötigt.
        2.  **UI-Logik implementieren:** Programmieren der clientseitigen Validierungen und der Interaktionsabläufe gemäß dem Use Case.
        3.  **API-Anbindung:** Verknüpfen der UI-Elemente mit den vom Backend bereitgestellten API-Endpunkten, um Daten zu senden und zu empfangen.
    *   **Fokus:** Den im Use Case beschriebenen Dialog zwischen Nutzer und System im Frontend abbilden.

### Phase 3: Testen auf Basis des Use Cases

Die Tests werden direkt aus dem Use Case abgeleitet, was eine lückenlose Überprüfung der Anforderungen gewährleistet.

*   **Aktivität:**
    *   Erstellung und Durchführung von Testfällen, die den gesamten "Flow of Events" des Use Cases abdecken.
*   **Test-Artefakte:**
    *   **Unit-Tests:** Jede neu implementierte Backend- und Frontend-Komponente wird isoliert getestet.
    *   **Integrationstests:** Es wird überprüft, ob das Zusammenspiel von Frontend und Backend für den spezifischen Use Case wie im Design vorgesehen funktioniert. Der Test folgt dem Pfad des Sequenzdiagramms.
    *   **Akzeptanztests / End-to-End-Tests:** Der gesamte Use Case wird aus der Perspektive des Endnutzers durchgespielt.
        *   Der Hauptablauf ("Happy Path") wird zum primären Testfall.
        *   Jeder alternative Ablauf und jeder Fehlerfall aus der Use-Case-Beschreibung wird zu einem eigenen, spezifischen Testfall.
*   **Ziel:**
    *   Sicherstellen, dass die Implementierung die im Use Case definierte Anforderung vollständig und korrekt erfüllt.

## Vorteile dieses Implementierungs-Workflows

*   **Klarheit und Fokus:** Das Team arbeitet an einer klar umrissenen, fachlichen Funktionalität, was Missverständnisse reduziert.
*   **Hohe Qualitätssicherung:** Da die Tests direkt aus den Anforderungen abgeleitet werden, wird sichergestellt, dass genau das getestet wird, was der Nutzer erwartet.
*   **Durchgängige Nachverfolgbarkeit (Traceability):** Jede Codezeile und jeder Testfall kann direkt auf einen Use Case zurückgeführt werden. Dies erleichtert die Wartung und das Fehlermanagement enorm.