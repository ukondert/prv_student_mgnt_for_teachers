---
description: "Flutter Widget development patterns and best practices"
applyTo: "lib/**/*.dart"
---

# Flutter Widget Instructions

## 🎨 Widget Pattern

### Standard Widget Template

```dart
// Standard Widget Template
class WidgetName extends StatelessWidget {
  const WidgetName({
    super.key,
    required this.data,
    this.onTap,
  });

  final DataType data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Widget(
      // Implementation
    );
  }
}
```

### State Management

- Bevorzugen Sie StatelessWidget wo möglich
- Nutzen Sie Provider/Riverpod für komplexe State-Logik
- Implementieren Sie immutable Data Models
- Verwenden Sie ValueNotifier für einfache reactive Updates

### Performance

- Verwenden Sie `const` konstruktoren wo möglich
- Implementieren Sie `RepaintBoundary` für komplexe Widgets
- Nutzen Sie `ListView.builder` für große Listen
- Vermeiden Sie unnötige Rebuilds durch proper Widget-Design

### Navigation

```dart
// Named Routes bevorzugen
context.pushNamed('/screen-name', extra: data);

// Oder mit go_router
GoRouter.of(context).push('/screen-name', extra: data);
```

### Error Handling

```dart
// Async Operations
try {
  final result = await service.fetchData();
  // Handle success
} on ServiceException catch (e) {
  // Handle service-specific errors
} catch (e) {
  // Handle general errors
  logger.error('Unexpected error: $e');
}
```

### Responsive Design

```dart
// Responsive Breakpoints
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth > 600) {
        return DesktopLayout();
      } else {
        return MobileLayout();
      }
    },
  );
}
```

### Material Design 3

- Nutzen Sie Material 3 Design System
- Implementieren Sie Dynamic Color (Material You)
- Befolgen Sie Accessibility Guidelines
- Verwenden Sie semantische Widgets

### Animation

```dart
// Einfache Animationen
AnimationController controller;
Animation<double> animation;

// Hero Animations für Navigation
Hero(
  tag: 'unique-tag',
  child: widget,
)
```
