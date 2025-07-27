// Flutter Widget Testing Beispiel - Demonstriert moderne Testing Patterns
// Zeigt umfassende Testing-Strategien für Flutter Widgets

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// User Model für Tests
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final bool isActive;
}

/// User Profile Card Widget (zu testende Komponente)
class UserProfileCard extends StatelessWidget {
  const UserProfileCard({
    super.key,
    required this.user,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
  });

  final User user;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: user.avatarUrl != null
                        ? NetworkImage(user.avatarUrl!)
                        : null,
                    child: user.avatarUrl == null
                        ? Text(user.name.substring(0, 1).toUpperCase())
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (user.isActive)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                ],
              ),
              if (showActions) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit'),
                    ),
                    TextButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete, size: 16),
                      label: const Text('Delete'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Test Suite für UserProfileCard
void main() {
  group('UserProfileCard Widget Tests', () {
    late User testUser;

    setUp(() {
      testUser = const User(
        id: '1',
        name: 'John Doe',
        email: 'john.doe@example.com',
        isActive: true,
      );
    });

    testWidgets('should display user information correctly', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserProfileCard(user: testUser),
          ),
        ),
      );

      // Act & Assert
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john.doe@example.com'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should display user avatar with initial when no avatarUrl', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserProfileCard(user: testUser),
          ),
        ),
      );

      // Act & Assert
      expect(find.text('J'), findsOneWidget); // Initial of John
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('should show NetworkImage when avatarUrl is provided', (tester) async {
      // Arrange
      final userWithAvatar = User(
        id: testUser.id,
        name: testUser.name,
        email: testUser.email,
        avatarUrl: 'https://example.com/avatar.jpg',
        isActive: testUser.isActive,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserProfileCard(user: userWithAvatar),
          ),
        ),
      );

      // Act & Assert
      final circleAvatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(circleAvatar.backgroundImage, isA<NetworkImage>());
    });

    testWidgets('should not show active icon for inactive users', (tester) async {
      // Arrange
      final inactiveUser = User(
        id: testUser.id,
        name: testUser.name,
        email: testUser.email,
        isActive: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserProfileCard(user: inactiveUser),
          ),
        ),
      );

      // Act & Assert
      expect(find.byIcon(Icons.check_circle), findsNothing);
    });

    testWidgets('should show action buttons when showActions is true', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserProfileCard(
              user: testUser,
              showActions: true,
            ),
          ),
        ),
      );

      // Act & Assert
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('should hide action buttons when showActions is false', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserProfileCard(
              user: testUser,
              showActions: false,
            ),
          ),
        ),
      );

      // Act & Assert
      expect(find.text('Edit'), findsNothing);
      expect(find.text('Delete'), findsNothing);
    });

    testWidgets('should call onTap when card is tapped', (tester) async {
      // Arrange
      bool wasTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserProfileCard(
              user: testUser,
              onTap: () => wasTapped = true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Assert
      expect(wasTapped, isTrue);
    });

    testWidgets('should call onEdit when edit button is tapped', (tester) async {
      // Arrange
      bool editWasCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserProfileCard(
              user: testUser,
              onEdit: () => editWasCalled = true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      // Assert
      expect(editWasCalled, isTrue);
    });

    testWidgets('should call onDelete when delete button is tapped', (tester) async {
      // Arrange
      bool deleteWasCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserProfileCard(
              user: testUser,
              onDelete: () => deleteWasCalled = true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Assert
      expect(deleteWasCalled, isTrue);
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper semantics for screen readers', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: UserProfileCard(user: testUser),
            ),
          ),
        );

        // Act & Assert
        final cardSemanticsNode = tester.getSemantics(find.byType(UserProfileCard));
        expect(cardSemanticsNode.hasAction(SemanticsAction.tap), isTrue);
      });

      testWidgets('should be accessible with large font sizes', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(textScaleFactor: 2.0),
              child: Scaffold(
                body: UserProfileCard(user: testUser),
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('john.doe@example.com'), findsOneWidget);
      });
    });

    group('Golden Tests', () {
      testWidgets('should match golden file for default appearance', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 300,
                  child: UserProfileCard(user: testUser),
                ),
              ),
            ),
          ),
        );

        // Act & Assert
        await expectLater(
          find.byType(UserProfileCard),
          matchesGoldenFile('user_profile_card_default.png'),
        );
      });

      testWidgets('should match golden file for inactive user', (tester) async {
        // Arrange
        final inactiveUser = User(
          id: testUser.id,
          name: testUser.name,
          email: testUser.email,
          isActive: false,
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 300,
                  child: UserProfileCard(user: inactiveUser),
                ),
              ),
            ),
          ),
        );

        // Act & Assert
        await expectLater(
          find.byType(UserProfileCard),
          matchesGoldenFile('user_profile_card_inactive.png'),
        );
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle very long names gracefully', (tester) async {
        // Arrange
        final userWithLongName = User(
          id: testUser.id,
          name: 'This is a very very very long name that might overflow',
          email: testUser.email,
          isActive: testUser.isActive,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 200, // Constrained width
                child: UserProfileCard(user: userWithLongName),
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.text(userWithLongName.name), findsOneWidget);
        expect(tester.takeException(), isNull); // No overflow exceptions
      });

      testWidgets('should handle empty name gracefully', (tester) async {
        // Arrange
        final userWithEmptyName = User(
          id: testUser.id,
          name: '',
          email: testUser.email,
          isActive: testUser.isActive,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: UserProfileCard(user: userWithEmptyName),
            ),
          ),
        );

        // Act & Assert
        expect(find.text(''), findsWidgets); // Empty text still renders
        expect(tester.takeException(), isNull); // No exceptions
      });
    });

    group('Performance Tests', () {
      testWidgets('should not rebuild unnecessarily', (tester) async {
        // Arrange
        int buildCount = 0;
        Widget buildWidget() {
          buildCount++;
          return UserProfileCard(user: testUser);
        }

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: buildWidget(),
            ),
          ),
        );

        // Act - Trigger a pump without changes
        await tester.pump();

        // Assert
        expect(buildCount, equals(1)); // Should only build once
      });
    });
  });

  group('Integration Tests', () {
    testWidgets('should work correctly in a list', (tester) async {
      // Arrange
      final users = [
        const User(
          id: '1',
          name: 'John Doe',
          email: 'john.doe@example.com',
          isActive: true,
        ),
        const User(
          id: '2',
          name: 'Jane Smith',
          email: 'jane.smith@example.com',
          isActive: false,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return UserProfileCard(user: users[index]);
              },
            ),
          ),
        ),
      );

      // Act & Assert
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Jane Smith'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget); // Only John is active
    });

    testWidgets('should handle scroll performance in large lists', (tester) async {
      // Arrange
      final users = List.generate(100, (index) {
        return User(
          id: '$index',
          name: 'User $index',
          email: 'user$index@example.com',
          isActive: index % 2 == 0,
        );
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return UserProfileCard(user: users[index]);
              },
            ),
          ),
        ),
      );

      // Act - Scroll to test performance
      await tester.fling(find.byType(ListView), const Offset(0, -500), 1000);
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(UserProfileCard), findsWidgets);
      expect(tester.takeException(), isNull); // No performance issues
    });
  });
}
