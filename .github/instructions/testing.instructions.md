---
description: "Flutter testing patterns and guidelines"
applyTo: "test/**/*.dart"
---

# Flutter Testing Instructions

## 🧪 Testing Patterns

### Widget Test Template

```dart
// Widget Test Template
testWidgets('WidgetName should display correctly', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: WidgetName(data: testData),
    ),
  );

  expect(find.byType(WidgetName), findsOneWidget);
  // Weitere Assertions...
});
```

### Testing Strategy

- **Unit Tests** für Business Logic
- **Widget Tests** für UI Components
- **Integration Tests** für User Flows
- **Golden Tests** für Visual Regression

### Test Structure

```dart
// Arrange
final testData = TestDataFactory.createUser();
final mockService = MockUserService();

// Act
await tester.pumpWidget(TestApp(
  child: UserCard(user: testData),
));

// Assert
expect(find.text(testData.name), findsOneWidget);
```

### Mocking Best Practices

```dart
// Use mockito or mocktail
class MockUserService extends Mock implements UserService {}

// Mock async operations
when(() => mockService.getUser(any()))
    .thenAnswer((_) async => testUser);
```

### Test Utilities

- Verwenden Sie `TestWidgetsFlutterBinding.ensureInitialized()`
- Nutzen Sie `pumpAndSettle()` für Animationen
- Implementieren Sie `TestApp` wrapper für konsistente Umgebung
- Verwenden Sie `find.byKey()` für spezifische Widget-Tests

### Golden Tests

```dart
testWidgets('UserCard golden test', (tester) async {
  await tester.pumpWidget(TestApp(
    child: UserCard(user: testUser),
  ));
  
  await expectLater(
    find.byType(UserCard),
    matchesGoldenFile('user_card.png'),
  );
});
```
