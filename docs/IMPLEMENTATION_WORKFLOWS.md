# Implementierungs Workflows

## **1. UI-zentrierter Ansatz („UI-First“)**

### ✅ **Geeignet für:**

* Projekte, bei denen **Usability im Vordergrund steht**
* **Startups mit MVPs**
* **Prototyping** und schnelle Iteration mit Kunden

### 🛠️ **Typische Technologien/Methoden:**

* Flutter, Figma, SwiftUI, React Native
* Rapid Prototyping Tools

### 📌 **Beispiel:**

> **Entwicklung einer Fitness-App** (z. B. Schrittzähler oder Kalorienzähler) für den Endkundenmarkt.
> Zuerst wird per Figma ein ansprechender UI-Prototyp erstellt, danach werden die benötigten Datenmodelle und Logiken aus dem UI abgeleitet.

---

## **2. Domain-zentrierter Ansatz („Domain-Driven Design“)**

### ✅ **Geeignet für:**

* Komplexe Geschäftsanwendungen mit vielen Regeln und Zuständen
* Systeme mit langlebiger, sich entwickelnder Domänenlogik
* Enterprise-Systeme (z. B. ERP, Buchhaltung, Logistik)

### 🛠️ **Typische Technologien/Methoden:**

* Java mit Spring Boot
* .NET Core, Clean Architecture
* Domain-Driven Design (DDD), Event Sourcing

### 📌 **Beispiel:**

> **Honorarnoten-App mit komplexen Steuer- und Abrechnungsregeln**.
> Der Fokus liegt auf korrekter Abbildung der Geschäftslogik, z. B. Regeln für Mehrwertsteuer, Zuschläge, Templates. Die UI ist nur Mittel zur Eingabe und Anzeige.

---

## **3. Use-Case-zentrierter Ansatz**

### ✅ **Geeignet für:**

* Systeme mit **klar definierten Benutzeraktionen**
* **Workflow-basierte Anwendungen**
* Anwendungen mit guter Modularisierbarkeit

### 🛠️ **Typische Technologien/Methoden:**

* Clean Architecture, Onion Architecture
* Java, Kotlin, C#, Flutter mit Feature-basiertem Aufbau

### 📌 **Beispiel:**

> **Workflow-System für Urlaubsanträge in einem Unternehmen.**
> Jeder Anwendungsfall (z. B. Antrag stellen, genehmigen, ablehnen) wird als separater Use Case modelliert. Der Code ist entlang dieser Anwendungsfälle organisiert.

---

## **4. Technologie- bzw. Architektur-zentrierter Ansatz**

### ✅ **Geeignet für:**

* Systeme mit hohen Anforderungen an Skalierbarkeit, Performance oder Infrastruktur
* Technologisch motivierte Projekte oder Proof of Concepts
* Cloud-native Microservices-Architekturen

### 🛠️ **Typische Technologien/Methoden:**

* Kubernetes, Kafka, Spring Cloud, Serverless, Firebase
* CQRS, Event Sourcing, Reactive Programming

### 📌 **Beispiel:**

> **Echtzeit-Streaming-Plattform für Sensordaten** in einer IoT-Umgebung.
> Die Wahl fällt zuerst auf Kafka und ein Event-Streaming-Framework, danach wird die Feature-Umsetzung an diese Architektur angepasst.

---

## **5. Test-First-Ansatz (TDD/BDD)**

### ✅ **Geeignet für:**

* Projekte mit hoher Qualitätsanforderung oder Sicherheitskritik
* Anwendungen, die refaktorierbar und stabil sein sollen
* Pair Programming / Extreme Programming (XP)

### 🛠️ **Typische Technologien/Methoden:**

* JUnit, Mockito, TestNG, Cucumber, Jest
* TDD, BDD, Specification by Example

### 📌 **Beispiel:**

> **Banking-Anwendung für Zahlungsabwicklung mit kritischen Berechnungen.**
> Jede Methode zur Überweisung, Validierung oder Sicherheitsüberprüfung wird zuerst durch Testspezifikationen beschrieben. Erst danach folgt die Implementierung.

---

## Zusammenfassung: Vergleich mit passenden Einsatzbereichen

| **Ansatz**                | **Wann besonders sinnvoll?**   | **Beispielprojekt**                                           |
| ------------------------- | ------------------------------ | ------------------------------------------------------------- |
| **UI-zentriert**          | MVP, Fokus auf Usability       | Fitness-App, ToDo-Listen-App, Dating-App                      |
| **Domain-zentriert**      | Komplexe Geschäftslogik        | Honorarnoten-App, Buchhaltung, Logistiksysteme                |
| **Use-Case-zentriert**    | Workflow-getriebene Systeme    | Urlaubsantrags-App, Buchungssysteme, Genehmigungsprozesse     |
| **Technologie-zentriert** | Technisch getriebene Systeme   | Event-Streaming, Cloud-native IoT-Plattform                   |
| **Test-First**            | Hohe Codequalität erforderlich | Bank-App, medizinische Software, sicherheitskritische Systeme |

