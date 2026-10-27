import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signup_app/main.dart';

void main() {
  testWidgets('validates all fields before demo signup', (tester) async {
    await tester.pumpWidget(const OrbitGuildApp());
    await tester.ensureVisible(find.text('Join the guild'));
    await tester.tap(find.text('Join the guild'));
    await tester.pump();
    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Myles Miller');
    await tester.enterText(fields.at(1), 'wrong-email');
    await tester.enterText(fields.at(2), '123');
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Join the guild'));
    await tester.tap(find.text('Join the guild'));
    await tester.pump();
    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(find.text('Use at least 6 characters'), findsOneWidget);

    await tester.enterText(fields.at(1), 'myles@example.com');
    await tester.enterText(fields.at(2), 'long-demo-password');
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Join the guild'));
    await tester.tap(find.text('Join the guild'));
    await tester.pump();
    expect(
      find.text('Demo signup complete — your form passed validation!'),
      findsOneWidget,
    );
  });

  testWidgets('local tip can load, fail, and retry', (tester) async {
    await tester.pumpWidget(const OrbitGuildApp());
    await tester.ensureVisible(find.text('Get a signup tip'));
    await tester.tap(find.text('Get a signup tip'));
    await tester.pump();
    expect(find.text('Choosing a preset tip...'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 700));
    expect(find.textContaining('Use a long, unique password'), findsOneWidget);
    expect(
      find.text('Preset demo tip, not live AI. No form data is used.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Test error'));
    await tester.pump(const Duration(milliseconds: 700));
    expect(
      find.text('The demo tip could not load. Your form is unaffected.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Retry tip'));
    await tester.pump(const Duration(milliseconds: 700));
    expect(find.textContaining('Avoid names and birthdays'), findsOneWidget);
  });
}
