# Cross-Platform UI Development Chat Mode

Dieser Custom Chat Mode wurde speziell für die Entwicklung von responsiven, plattformübergreifenden Benutzeroberflächen erstellt.

## 🚀 Features

### Adaptive Design Patterns
- **Desktop/Tablet (>600px)**: DataTable mit vollständigen Features
- **Mobile (<600px)**: ListView mit Cards für touch-freundliche Interaktion
- **Automatische Responsive Breakpoints**: LayoutBuilder-basierte Logik

### Platform-Specific Guidelines
- **Material Design (Android)**: Cards, FABs, Navigation Drawer
- **Cupertino (iOS)**: Navigation Bar, Tab Bar, Segmented Controls
- **Fluent Design (Windows)**: NavigationView, CommandBar
- **Web**: Responsive Grids, Progressive Enhancement

## 📁 Included Files

### 1. Chat Mode Definition
`.github/chatmodes/crossplatform-ui.chatmode.md`
- Detaillierte Anweisungen für responsive UI-Entwicklung
- Plattformspezifische Design-Guidelines
- Performance-Optimierungen
- Accessibility-Standards

### 2. Tool Sets
`.vscode/tool-sets.jsonc`
- `responsive-design`: Tools für responsive UI-Entwicklung
- `ui-analysis`: Analyse-Tools für UI-Komponenten
- `performance-check`: Performance-Analyse Tools

### 3. Instructions Files
`.github/instructions/responsive-design.instructions.md`
- Flutter-spezifische responsive Design-Regeln
- Breakpoint-Definitionen
- Performance Guidelines
- Error Prevention Patterns

### 4. Templates
`templates/responsive-screen-template.dart`
- Vollständiges Template für responsive Flutter Screens
- Mobile und Desktop Layouts
- Verwendungsanweisungen

## 🛠️ Verwendung

### 1. Chat Mode aktivieren
1. Öffnen Sie die Chat View (Ctrl+Alt+I)
2. Wählen Sie "crossplatform-ui" aus dem Chat Mode Dropdown
3. Der Mode ist jetzt aktiv mit allen spezifischen Tools und Anweisungen

### 2. Typische Prompts
```
"Konvertiere diese DataTable zu einem responsiven Layout"
"Erstelle eine mobile-freundliche Version dieser Liste"
"Optimiere diesen Screen für alle Plattformen"
"Implementiere responsive Navigation"
```

### 3. Tool Sets verwenden
```
#responsive-design - Für UI-Entwicklung
#ui-analysis - Für Komponenten-Analyse  
#performance-check - Für Performance-Checks
```

## 🎯 Best Practices

### Mobile-First Approach
- Starten Sie mit mobilen Constraints
- Erweitern Sie für größere Bildschirme
- Touch-freundliche Interaktionen

### Performance Optimization
- ListView.builder für große Listen
- Lazy Loading implementieren
- Memory Leaks vermeiden

### Accessibility
- Semantische Widgets verwenden
- Screen Reader Support
- Keyboard Navigation

## 📱 Design Rules

### Responsive Breakpoints
- **Mobile**: < 600px (ListView + Cards)
- **Tablet**: 600-1024px (Hybrid Approach)
- **Desktop**: > 1024px (DataTable + NavigationRail)

### Touch Targets
- **Minimum**: 44px Höhe für mobile Interaktionen
- **Empfohlen**: 48px für bessere Zugänglichkeit

### Typography
- **Mobile**: Mindestens 16px für Body Text
- **Desktop**: 14px Body Text akzeptabel

## 🔧 Template Usage

Das `responsive-screen-template.dart` Template bietet:

1. **Vollständiges responsive Layout**
2. **Mobile und Desktop Varianten**
3. **Performance-optimierte Listen**
4. **Material 3 Design Tokens**
5. **Accessibility Features**

### Anpassung:
1. Klassen-Namen ändern
2. Mock-Daten durch echte Daten ersetzen
3. Business Logic hinzufügen
4. Styling an App-Theme anpassen

## 🚨 Häufige Probleme vermeiden

### BoxConstraints Errors
```dart
// ✅ RICHTIG: Bounded DataTable
Expanded(
  child: SingleChildScrollView(
    child: DataTable(...),
  ),
)

// ❌ FALSCH: Unbounded DataTable
Column(
  children: [
    DataTable(...), // RenderFlex overflow!
  ],
)
```

### Performance Issues
```dart
// ✅ RICHTIG: Builder für große Listen
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)

// ❌ FALSCH: Alle Items auf einmal erstellen
ListView(
  children: items.map((item) => ItemWidget(item)).toList(),
)
```

## 🔄 Updates und Erweiterungen

Der Chat Mode wird kontinuierlich erweitert um:
- Neue Plattform-Guidelines
- Performance-Optimierungen
- Accessibility-Verbesserungen
- Framework-Updates

## 💡 Tipps

1. **Testen Sie auf verschiedenen Bildschirmgrößen**
2. **Verwenden Sie LayoutBuilder für responsive Logic**
3. **Implementieren Sie proper constraint handling**
4. **Optimieren Sie für die primären Interaktionsmuster jeder Plattform**

Der Chat Mode ist darauf ausgelegt, Ihnen bei der Erstellung von hochwertigen, responsiven UIs zu helfen, die auf allen Plattformen optimal funktionieren!
