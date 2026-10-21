// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mychoice_app/app.dart';
import 'package:mychoice_app/screens/decision/create_decision_screen.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyChoiceApp());

    // Verify that splash screen is shown initially
    expect(find.text('MyChoice'), findsOneWidget);
  });

  testWidgets('decision creation reviews, processes, and opens results', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    await tester.pumpWidget(const MaterialApp(home: CreateDecisionScreen()));

    final makeDecisionButton = find.text('Make a Decision');
    await tester.ensureVisible(makeDecisionButton);
    await tester.tap(makeDecisionButton);
    await tester.pumpAndSettle();

    expect(find.text('Almost done! 🎉'), findsOneWidget);
    await tester.tap(find.text('Start Calculation'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 3500));
    await tester.pump();

    expect(find.text('Decision Results'), findsOneWidget);
    await tester.tap(find.text('Decision Results').last);
    await tester.pumpAndSettle();

    expect(find.text('Decision Results'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Decision'), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });
}
