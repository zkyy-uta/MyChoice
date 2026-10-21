import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mychoice_app/screens/admin/users/user_management_screen.dart';

void main() {
  testWidgets('admin can search and filter accounts by status', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(500, 900));
    await tester.pumpWidget(const MaterialApp(home: UserManagementScreen()));

    expect(find.byIcon(Icons.arrow_back), findsNothing);
    expect(find.text('Enami Asa'), findsOneWidget);
    expect(find.text('Bima Sakti'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'najwa');
    await tester.pump();
    expect(find.text('Najwa'), findsOneWidget);
    expect(find.text('Enami Asa'), findsNothing);

    await tester.tap(find.byTooltip('Filter by status'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CheckboxListTile, 'Active'));
    await tester.tap(find.text('Apply filter'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pump();
    expect(find.text('Najwa'), findsOneWidget);
    expect(find.text('Enami Asa'), findsNothing);

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('admin must confirm before deactivating a user', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(500, 900));
    await tester.pumpWidget(const MaterialApp(home: UserManagementScreen()));

    await tester.tap(find.byTooltip('Show account details').first);
    await tester.pumpAndSettle();
    final accountDetails = find.byType(Dialog);
    expect(
      find.descendant(of: accountDetails, matching: find.text('Enami Asa')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: accountDetails,
        matching: find.text('asa.enami@gmail.com'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: accountDetails, matching: find.text('Premium')),
      findsOneWidget,
    );
    expect(find.byType(TextFormField), findsNothing);
    expect(find.text('Deactivate account?'), findsNothing);

    await tester.tap(find.text('Deactivate Account'));
    await tester.pumpAndSettle();
    expect(find.text('Deactivate account?'), findsOneWidget);
    expect(
      find.text(
        'Enami Asa will no longer be able to sign in to MyChoice. '
        'Their existing data will be kept.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Deactivate'));
    await tester.pumpAndSettle();
    expect(find.text('User Management'), findsOneWidget);
    expect(find.text('Inactive'), findsNWidgets(2));
    expect(find.text('Account deactivated successfully'), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });
}
