---
description: "Guidelines for building Flutter/Dart applications"
applyTo: "**/*.dart"
---

# Flutter/Dart Development

## General Instructions

• First, prompt the user if they want to integrate static analysis tools 
(flutter_lints, dart_code_metrics, very_good_analysis) into their project setup. If yes, provide guidance on tool
selection and configuration.
• If the user declines static analysis tools or wants to proceed without them,
continue with implementing the Best practices, bug patterns and code smell
prevention guidelines outlined below.
• Address code smells proactively during development rather than accumulating
technical debt.
• Focus on readability, maintainability, and performance when refactoring
identified issues.
• Use IDE / Code editor reported warnings and suggestions to catch common patterns
early in development.
• Follow Flutter's widget composition patterns and lifecycle best practices.

## Best practices

### Naming Conventions

• Follow Dart's official style guide:
  ◦ `UpperCamelCase` for class, enum, typedef, and extension names.
  ◦ `lowerCamelCase` for variable, function, parameter, and method names.
  ◦ `SCREAMING_SNAKE_CASE` for constants.
  ◦ `snake_case` for libraries, packages, directories, and source files.
• Use nouns for classes (`UserService`, `ProfileWidget`) and verbs for methods (`getUserById`, `validateInput`).
• Prefix private members with underscore (`_privateMethod`, `_internalState`).
• Use descriptive names for widgets (`UserProfileCard` instead of `Card`).

### Widget Development

• **StatelessWidget vs StatefulWidget**: Prefer `StatelessWidget` when possible. Only use `StatefulWidget` when you need to manage mutable state.
• **Const Constructors**: Always use `const` constructors for immutable widgets to improve performance.
• **Key Usage**: Use keys for widgets in lists or when widget identity matters (`ValueKey`, `ObjectKey`, `GlobalKey`).
• **Widget Composition**: Break complex widgets into smaller, reusable components.
• **Build Method**: Keep build methods pure - no side effects, network calls, or state mutations.

```dart
// Good: Const constructor with key parameter
class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.user,
    this.onTap,
  });

  final User user;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(user.name),
        onTap: onTap,
      ),
    );
  }
}
```

### State Management

• **Provider/Riverpod**: Use for complex state management across multiple widgets.
• **ValueNotifier/ValueListenableBuilder**: Use for simple reactive updates.
• **setState**: Only for local widget state that doesn't affect other widgets.
• **Immutable Data**: Always use immutable data models with copyWith methods.

```dart
// Good: Immutable data model
@immutable
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;

  User copyWith({
    String? id,
    String? name,
    String? email,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}
```

### Async Programming

• **Future vs Stream**: Use `Future<T>` for single async values, `Stream<T>` for continuous data flow.
• **FutureBuilder/StreamBuilder**: Use for handling async data in widgets.
• **async/await**: Prefer over `.then()` chains for better readability.
• **Error Handling**: Always handle errors in async operations.

```dart
// Good: Proper async error handling
Future<User?> fetchUser(String id) async {
  try {
    final response = await http.get(Uri.parse('/api/users/$id'));
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }
    return null;
  } catch (e) {
    debugPrint('Error fetching user: $e');
    return null;
  }
}
```

### Performance Best Practices

• **RepaintBoundary**: Use for expensive widgets that rarely change.
• **ListView.builder**: Use for large or infinite lists instead of ListView with children.
• **Image Caching**: Use `cached_network_image` for network images.
• **Widget Rebuilds**: Minimize unnecessary rebuilds by proper widget design.

```dart
// Good: Optimized list with RepaintBoundary
class UserList extends StatelessWidget {
  const UserList({super.key, required this.users});

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          child: UserCard(
            key: ValueKey(users[index].id),
            user: users[index],
          ),
        );
      },
    );
  }
}
```

### Bug Patterns

| Rule | Description | Solution |
|------|-------------|----------|
| prefer_const_constructors | Use const constructors when possible | Add `const` keyword to widget constructors |
| avoid_print | Don't use print() in production | Use `debugPrint()` or logging packages |
| close_sinks | Close StreamControllers and other sinks | Implement proper disposal in StatefulWidget |
| avoid_empty_else | Remove empty else blocks | Clean up unnecessary conditional branches |
| prefer_final_fields | Use final for fields that are never reassigned | Add `final` keyword to immutable fields |
| avoid_unnecessary_containers | Don't wrap widgets in unnecessary Container | Use more specific widgets like Padding, SizedBox |
| prefer_typing_uninitialized_variables | Specify types for uninitialized variables | Add explicit type annotations |
| avoid_relative_lib_imports | Use package: imports instead of relative | Use `package:my_app/...` imports |

### Code Smells

| Rule | Description | Solution |
|------|-------------|----------|
| Long build methods | Build methods with too many lines | Extract widgets into separate classes |
| Deep widget nesting | Too many nested widgets | Break into smaller widget components |
| Stateful widgets for static content | Using StatefulWidget unnecessarily | Convert to StatelessWidget |
| Missing error handling | Async operations without error handling | Add try-catch blocks and proper error states |
| Magic numbers/strings | Hardcoded values throughout code | Extract to constants or configuration |
| Duplicate widget code | Similar widgets repeated | Create reusable components |
| Missing keys in lists | Dynamic lists without keys | Add appropriate keys (ValueKey, ObjectKey) |
| Unused imports | Importing packages not used | Remove unused import statements |

### Testing Best Practices

• **Widget Tests**: Test widget behavior and UI logic.
• **Unit Tests**: Test business logic and data models.
• **Integration Tests**: Test complete user flows.
• **Golden Tests**: Test widget appearance consistency.

```dart
// Good: Widget test example
void main() {
  testWidgets('UserCard displays user information', (tester) async {
    const user = User(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: UserCard(user: user),
      ),
    );

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('john@example.com'), findsOneWidget);
  });
}
```

### Security Considerations

• **Input Validation**: Always validate user input before processing.
• **Secure Storage**: Use `flutter_secure_storage` for sensitive data.
• **Network Security**: Implement certificate pinning for production apps.
• **Permission Handling**: Request permissions appropriately and handle denials.

## Build and Verification

• After adding or modifying code, verify the project continues to build successfully.
• Run `flutter analyze` to check for code issues and style violations.
• Run `flutter test` to ensure all tests pass.
• Use `flutter doctor` to check for any development environment issues.
• For production builds, run `flutter build apk --release` (Android) or `flutter build ios --release` (iOS).
• Ensure all dependencies are properly declared in `pubspec.yaml`.

## Additional Resources

• [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
• [Flutter Widget Catalog](https://docs.flutter.dev/development/ui/widgets)
• [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)
• [Flutter Testing](https://docs.flutter.dev/testing)
