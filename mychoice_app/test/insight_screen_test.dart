import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mychoice_app/screens/user/insight/insight_screen.dart';

void main() {
  testWidgets('insight shows decision history statistics and patterns', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(const MaterialApp(home: InsightScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Your Decision Insights'), findsOneWidget);
    expect(find.byType(BackButton), findsNothing);
    expect(find.text('6'), findsWidgets);
    expect(find.text('Technology'), findsWidgets);
    expect(find.text('Average Score'), findsOneWidget);
    expect(find.text('Your Common Priorities'), findsOneWidget);
    expect(find.text('Performance'), findsOneWidget);
    expect(find.text('What-If Usage'), findsOneWidget);
    expect(find.text('Not tracked yet'), findsOneWidget);
    expect(find.text('Decision Pattern'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.scrollUntilVisible(
      find.text('Decision Categories'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Decision Categories'), findsOneWidget);
    expect(find.text('3 · 50%'), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
    expect(tester.takeException(), isNull);

    await tester.binding.setSurfaceSize(null);
  });
}
