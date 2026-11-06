import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mychoice_app/screens/admin/catalogue/manage_subcategory_screen.dart';

void main() {
  testWidgets('cancelling an option sheet keeps the management screen usable', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(500, 900));
    await tester.pumpWidget(
      const MaterialApp(home: ManageSubcategoryScreen(subcategory: 'Laptop')),
    );

    await tester.ensureVisible(find.text('+ Add Option'));
    await tester.tap(find.text('+ Add Option'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Test option');
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Test option'), findsNothing);
    expect(find.text('+ Add Option'), findsOneWidget);

    await tester.ensureVisible(find.text('+ Add Criteria'));
    await tester.tap(find.text('+ Add Criteria'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Test criteria');
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Test criteria'), findsNothing);

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('back button returns from category management', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          const ManageSubcategoryScreen(subcategory: 'Laptop'),
                    ),
                  );
                },
                child: const Text('Open management'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open management'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.text('Open management'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
