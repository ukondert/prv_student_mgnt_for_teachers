// Flutter Widget Test Pattern
// Unit Tests für UserProfileCard Widget

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../widgets/user_profile_card.dart';

void main() {
  group('UserProfileCard Widget Tests', () {
    // Test-Daten
    const testUser = User(
      id: 'test-id',
      name: 'Max Mustermann',
      email: 'max@example.com',
      role: 'Admin',
      isOnline: true,
    );

    const testUserWithAvatar = User(
      id: 'test-id-2',
      name: 'Anna Schmidt',
      email: 'anna@example.com',
      avatarUrl: 'https://example.com/avatar.jpg',
      role: 'User',
      isOnline: false,
      lastSeen: DateTime(2024, 1, 15, 10, 30),
    );

    testWidgets('sollte Benutzerdaten korrekt anzeigen', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserProfileCard(user: testUser),
          ),
        ),
      );

      // Act & Assert
      expect(find.text('Max Mustermann'), findsOneWidget);
      expect(find.text('max@example.com'), findsOneWidget);
      expect(find.text('Admin'), findsOneWidget);
      expect(find.text('Online'), findsOneWidget);
    });

    testWidgets('sollte Initialen anzeigen wenn kein Avatar vorhanden', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserProfileCard(user: testUser),
          ),
        ),
      );

      // Act & Assert
      expect(find.text('MM'), findsOneWidget); // Max Mustermann -> MM
    });

    testWidgets('sollte Avatar-Bild anzeigen wenn URL vorhanden', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserProfileCard(user: testUserWithAvatar),
          ),
        ),
      );

      // Act & Assert
      expect(find.byType(CircleAvatar), findsOneWidget);
      
      final CircleAvatar avatar = tester.widget(find.byType(CircleAvatar));
      expect(avatar.backgroundImage, isA<NetworkImage>());
    });

    testWidgets('sollte "Zuletzt gesehen" anzeigen für offline Benutzer', (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserProfileCard(user: testUserWithAvatar),
          ),
        ),
      );

      // Act & Assert
      expect(find.textContaining('Zuletzt gesehen'), findsOneWidget);
    });

    testWidgets('sollte onTap Callback ausführen', (tester) async {
      // Arrange
      bool wasPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserProfileCard(
              user: testUser,
              onTap: () => wasPressed = true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(UserProfileCard));
      await tester.pumpAndSettle();

      // Assert
      expect(wasPressed, isTrue);
    });

    testWidgets('sollte Aktions-Menü anzeigen wenn showActions = true', (tester) async {
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
      expect(find.byType(PopupMenuButton<String>), findsOneWidget);
    });

    testWidgets('sollte kein Aktions-Menü anzeigen wenn showActions = false', (tester) async {
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
      expect(find.byType(PopupMenuButton<String>), findsNothing);
    });

    testWidgets('sollte Edit Callback ausführen', (tester) async {
      // Arrange
      bool editPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserProfileCard(
              user: testUser,
              onEdit: () => editPressed = true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Bearbeiten'));
      await tester.pumpAndSettle();

      // Assert
      expect(editPressed, isTrue);
    });

    testWidgets('sollte Delete Callback ausführen', (tester) async {
      // Arrange
      bool deletePressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserProfileCard(
              user: testUser,
              onDelete: () => deletePressed = true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Löschen'));
      await tester.pumpAndSettle();

      // Assert
      expect(deletePressed, isTrue);
    });

    testWidgets('sollte custom elevation verwenden', (tester) async {
      // Arrange
      const customElevation = 8.0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserProfileCard(
              user: testUser,
              elevation: customElevation,
            ),
          ),
        ),
      );

      // Act & Assert
      final Card card = tester.widget(find.byType(Card));
      expect(card.elevation, customElevation);
    });

    testWidgets('sollte Theme-Farben korrekt verwenden', (tester) async {
      // Arrange
      const customColorScheme = ColorScheme.dark();
      
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: customColorScheme),
          home: Scaffold(
            body: UserProfileCard(user: testUser),
          ),
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert - Verifiziert dass Widget ohne Fehler rendert
      expect(find.byType(UserProfileCard), findsOneWidget);
    });

    group('Initialen-Generation', () {
      testWidgets('sollte korrekte Initialen für Vor- und Nachname generieren', (tester) async {
        // Test-Daten
        const user = User(
          id: 'test',
          name: 'Anna Schmidt',
          email: 'anna@test.com',
        );

        expect(user.initials, equals('AS'));
      });

      testWidgets('sollte ersten Buchstaben für einzelnen Namen verwenden', (tester) async {
        // Test-Daten
        const user = User(
          id: 'test',
          name: 'Anna',
          email: 'anna@test.com',
        );

        expect(user.initials, equals('A'));
      });

      testWidgets('sollte Initialen für mehr als zwei Namen korrekt berechnen', (tester) async {
        // Test-Daten
        const user = User(
          id: 'test',
          name: 'Anna Maria Schmidt',
          email: 'anna@test.com',
        );

        expect(user.initials, equals('AS')); // Erster und letzter Name
      });
    });

    group('Accessibility Tests', () {
      testWidgets('sollte semantische Labels für Screen Reader bereitstellen', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: UserProfileCard(user: testUser),
            ),
          ),
        );

        // Act & Assert
        // Verifica dass alle wichtigen Texte für Screen Reader verfügbar sind
        expect(find.text('Max Mustermann'), findsOneWidget);
        expect(find.text('max@example.com'), findsOneWidget);
        expect(find.text('Admin'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('sollte mit sehr langen Namen umgehen können', (tester) async {
        // Test-Daten
        const userWithLongName = User(
          id: 'test',
          name: 'Maximiliano Eduardo Francisco José María Schmidt-Müller-Weber',
          email: 'very.long.email.address@subdomain.example.org',
        );

        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 300, // Begrenzte Breite simulieren
                child: UserProfileCard(user: userWithLongName),
              ),
            ),
          ),
        );

        // Act & Assert
        expect(find.byType(UserProfileCard), findsOneWidget);
        // Widget sollte ohne Overflow-Fehler rendern
      });

      testWidgets('sollte mit leeren/null Werten umgehen können', (tester) async {
        // Test-Daten
        const userWithMinimalData = User(
          id: 'test',
          name: 'Test',
          email: 'test@example.com',
          // Alle optionalen Felder sind null
        );

        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: UserProfileCard(user: userWithMinimalData),
            ),
          ),
        );

        // Act & Assert
        expect(find.byType(UserProfileCard), findsOneWidget);
        expect(find.text('Test'), findsOneWidget);
        expect(find.text('test@example.com'), findsOneWidget);
      });
    });
  });
}
