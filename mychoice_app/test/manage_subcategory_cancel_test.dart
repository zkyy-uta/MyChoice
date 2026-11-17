import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mychoice_app/features/admin_catalog/domain/entities/admin_catalog_data.dart';
import 'package:mychoice_app/features/admin_catalog/domain/repositories/admin_catalog_repository.dart';
import 'package:mychoice_app/screens/admin/catalogue/manage_subcategory_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('cancelling an option sheet keeps the management screen usable', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(500, 900));
    await tester.pumpWidget(_managementApp());
    await tester.pumpAndSettle();

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
      Provider<AdminCatalogRepository>.value(
        value: _FakeAdminCatalogRepository(),
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const ManageSubcategoryScreen(
                          subcategory: 'Laptop',
                        ),
                      ),
                    );
                  },
                  child: const Text('Open management'),
                ),
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

Widget _managementApp() => Provider<AdminCatalogRepository>.value(
  value: _FakeAdminCatalogRepository(),
  child: const MaterialApp(
    home: ManageSubcategoryScreen(subcategory: 'Laptop'),
  ),
);

class _FakeAdminCatalogRepository implements AdminCatalogRepository {
  @override
  Future<AdminCatalogCriterion> addCriterion({
    required String category,
    required String subcategory,
    required String name,
    required String type,
    required String unit,
  }) async => throw UnimplementedError();

  @override
  Future<void> deleteOption({required String id}) async {}

  @override
  Future<AdminSubcategoryCatalog> loadSubcategory({
    required String category,
    required String subcategory,
  }) async => const AdminSubcategoryCatalog(criteria: [], options: []);

  @override
  Future<String> saveOption({
    required String category,
    required String subcategory,
    String? id,
    required String name,
    required Map<String, String> values,
    required Set<String> unavailable,
    required List<AdminCatalogCriterion> criteria,
  }) async => 'option-id';
}
