import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mychoice_app/screens/admin/reports/admin_reports_screen.dart';

void main() {
  testWidgets('admin can search and filter user reviews', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(500, 900));
    await tester.pumpWidget(const MaterialApp(home: AdminReportsScreen()));

    expect(find.text('Reports').first, findsOneWidget);
    expect(find.text('5 reviews'), findsOneWidget);
    expect(find.text('Najwa Putri'), findsOneWidget);
    expect(find.text('Bima Sakti'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'history');
    await tester.pump();
    expect(find.text('Siti Aulia'), findsOneWidget);
    expect(find.text('Najwa Putri'), findsNothing);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pump();
    await tester.tap(find.text('5 stars'));
    await tester.pump();
    expect(find.text('3 reviews'), findsOneWidget);
    expect(find.text('Siti Aulia'), findsOneWidget);
    expect(find.text('Raka Pratama'), findsNothing);

    await tester.binding.setSurfaceSize(null);
  });
}
