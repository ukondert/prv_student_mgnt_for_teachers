# Flutter Examples Collection

Diese Sammlung demonstriert moderne Flutter/Dart Best Practices und zeigt, wie man mit einer einzigen Codebasis Apps für verschiedene Plattformen und Bildschirmgrößen entwickelt.

## 📁 Verzeichnisstruktur

### `/responsive/`
**Adaptive UI für verschiedene Bildschirmgrößen**

- **`responsive_utils.dart`** - Utility-Klassen für responsive Design
  - `ScreenBreakpoints` - Definierte Breakpoints für mobile, tablet, desktop
  - `ResponsiveValue<T>` - Type-safe responsive Werte
  - `ResponsiveBuilder` - Builder für responsive Widgets
  - `ResponsiveContainer` - Container mit adaptiver Maximalbreite
  - `AdaptiveNavigation` - Navigation die sich an die Bildschirmgröße anpasst

### `/screens/`
**Vollständige Screen-Implementierungen**

- **`responsive_user_list_screen.dart`** - Demo für responsive Layouts
  - **Mobile**: Single-Column ListView
  - **Tablet**: Two-Column Grid  
  - **Desktop**: Master-Detail Layout mit Sidebar
  - Adaptive Navigation und FloatingActionButton

### `/widgets/`
**Wiederverwendbare UI-Komponenten**

- **`adaptive_widgets.dart`** - Platform-spezifische Widgets
  - `AdaptiveButton` - Material/Cupertino Button je nach Plattform
  - `AdaptiveProgressIndicator` - Platform-spezifische Loading Indicators
  - `AdaptiveAlertDialog` - Native Dialog-Styles
  - `AdaptiveScaffold` - Platform-adaptive App-Struktur
  - `ResponsiveFormScreen` - Form die sich an Bildschirmgröße anpasst

- **`user_profile_card.dart`** - Erweiterte User Card mit verschiedenen Layouts
  - Compact Layout für mobile Listen
  - Expanded Layout für Tablet-Grids
  - Detailed Layout für Desktop

### `/services/`
**Backend-Integration und Business Logic**

- **`modern_user_service.dart`** - Moderne HTTP Service Implementation
  - Dependency Injection statt Singleton Pattern
  - Sealed Classes für Type-Safe Error Handling
  - Interface Segregation für bessere Testbarkeit
  - Proper Exception Handling und Retry Logic

### `/state_management/`
**State Management Patterns**

- **`user_state_demo.dart`** - Verschiedene State Management Ansätze
  - `ChangeNotifier` Pattern für komplexe State Logic
  - `ValueNotifier` für einfache reactive Updates  
  - Immutable State Models mit `copyWith`
  - Proper Error Handling und Loading States

### `/testing/`
**Testing Best Practices**

- **`modern_widget_test.dart`** - Umfassende Widget Tests
  - Unit Tests für Widget Behavior
  - Integration Tests für Widget Composition
  - Accessibility Tests
  - Golden Tests für visueller Regression
  - Performance Tests
  - Edge Case Testing

## 🎯 Key Features Demonstriert

### 1. **Responsive Design**
```dart
// Verschiedene Werte für verschiedene Bildschirmgrößen
final spacing = context.responsiveValue(
  mobile: 16,
  tablet: 24, 
  desktop: 32,
);

// Adaptive Layouts
ResponsiveLayout(
  mobile: MobileLayout(),
  tablet: TabletLayout(), 
  desktop: DesktopLayout(),
)
```

### 2. **Platform-Adaptive UI**
```dart
// Automatisch Material Design auf Android, Cupertino auf iOS
AdaptiveButton(
  onPressed: () {},
  child: Text('Button'),
)

// Platform-spezifische Navigation
AdaptiveNavigation(
  destinations: destinations,
  selectedIndex: selectedIndex,
  onDestinationSelected: onDestinationSelected,
)
```

### 3. **Type-Safe State Management**
```dart
// Sealed Classes für Error Handling
sealed class ApiResult<T> {}
class ApiSuccess<T> extends ApiResult<T> { ... }
class ApiError<T> extends ApiResult<T> { ... }

// Pattern Matching mit switch expressions
final result = await userService.getUsers();
switch (result) {
  case ApiSuccess(:final data):
    // Handle success
  case ApiError(:final message):
    // Handle error
}
```

### 4. **Modern Testing Patterns**
```dart
group('Widget Tests', () {
  testWidgets('should display user information', (tester) async {
    // Arrange, Act, Assert Pattern
    await tester.pumpWidget(testWidget);
    expect(find.text('John Doe'), findsOneWidget);
  });
  
  // Golden Tests für visueller Konsistenz
  testWidgets('should match golden file', (tester) async {
    await expectLater(
      find.byType(UserCard),
      matchesGoldenFile('user_card.png'),
    );
  });
});
```

## 🏗️ Architektur-Patterns

### Clean Architecture
- **Presentation Layer**: Widgets und Screens
- **Domain Layer**: Business Logic und Use Cases  
- **Data Layer**: Services und Repositories

### Dependency Injection
- Constructor Injection statt Singleton Pattern
- Interface Segregation für bessere Testbarkeit
- Mockable Dependencies für Unit Tests

### Immutable Data Models
```dart
@immutable
class User {
  const User({required this.id, required this.name});
  
  final String id;
  final String name;
  
  User copyWith({String? id, String? name}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
```

## 📱 Multi-Platform Support

### Responsive Breakpoints
- **Mobile**: < 600px (Portrait phones)
- **Tablet**: 600-1024px (Tablets, landscape phones)
- **Desktop**: 1024-1440px (Laptops, small screens)
- **Wide Desktop**: > 1440px (Large monitors)

### Platform-Adaptive Features
- **iOS**: Cupertino Design Language
- **Android**: Material Design 3
- **Web**: Mouse interaction, keyboard navigation
- **Desktop**: Native window controls, menu bars

### Accessibility
- Screen reader support mit proper Semantics
- High contrast theme support
- Large font size scaling
- Keyboard navigation

## 🧪 Testing Strategy

### Widget Tests
- User interaction testing
- State change verification
- Error condition handling

### Integration Tests  
- Multi-widget interaction
- Navigation flow testing
- State persistence

### Golden Tests
- Visual regression testing
- Cross-platform UI consistency
- Theme variation testing

## 🚀 Best Practices Implementiert

### Performance
- `const` constructors für bessere Performance
- `RepaintBoundary` für komplexe Widgets
- `ListView.builder` für große Listen
- Image caching und optimization

### Code Quality
- Dart 3 Features (Sealed Classes, Pattern Matching)
- Proper error handling mit typed exceptions
- Immutable data structures
- Clean separation of concerns

### Developer Experience
- Hot reload optimized code structure
- Clear naming conventions
- Comprehensive documentation
- Type-safe APIs

---

Diese Beispiele zeigen, wie moderne Flutter-Apps entwickelt werden, die gleichzeitig wartbar, performant und benutzerfreundlich auf allen Plattformen sind.
