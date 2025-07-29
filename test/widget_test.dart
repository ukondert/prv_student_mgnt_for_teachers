import 'package:flutter_test/flutter_test.dart';

import 'package:student_management_for_teachers/app.dart';

void main() {
  testWidgets('App launches without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LehrerCockpitApp());

    // Verify that the app title is displayed
    expect(find.text('Lehrer-Cockpit'), findsOneWidget);
  });
}
