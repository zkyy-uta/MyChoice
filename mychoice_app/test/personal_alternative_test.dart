import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mychoice_app/features/alternative_management/domain/entities/alternative.dart';
import 'package:mychoice_app/features/alternative_management/domain/repositories/personal_alternative_repository.dart';
import 'package:mychoice_app/features/criteria_selection/domain/repositories/personal_criteria_repository.dart';
import 'package:mychoice_app/features/decision_history/presentation/providers/decision_history_provider.dart';
import 'package:mychoice_app/screens/user/decision/create_decision_screen.dart';
import 'package:provider/provider.dart';
import 'test_support/fake_decision_history_repository.dart';

void main() {
  testWidgets('saves manual option details under the selected subcategory', (
    tester,
  ) async {
    final repository = _MemoryPersonalAlternativeRepository();
    await tester.binding.setSurfaceSize(const Size(900, 1400));
    await tester.pumpWidget(
      Provider<PersonalAlternativeRepository>.value(
        value: repository,
        child: const MaterialApp(
          home: CreateDecisionScreen(
            initialCategory: 'Technology',
            initialSubcategory: 'Laptop',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final nameField = find.byKey(const Key('personal-option-name'));
    await tester.ensureVisible(nameField);
    await tester.enterText(nameField, 'My Custom Laptop');
    await tester.pump();
    final addButton = find.byKey(const Key('add-personal-option'));
    await tester.ensureVisible(addButton);
    expect(tester.widget<OutlinedButton>(addButton).onPressed, isNotNull);
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('manual-attribute-RAM')), findsOneWidget);
    expect(find.byKey(const Key('manual-attribute-Storage')), findsOneWidget);
    expect(find.byKey(const Key('manual-attribute-Processor')), findsOneWidget);

    const values = {
      'Price': '1200',
      'RAM': '16',
      'Storage': '512',
      'Processor': 'Core Ultra 7',
      'Battery': '10',
      'Weight': '1.4',
    };
    for (final entry in values.entries) {
      final field = find.byKey(Key('manual-attribute-${entry.key}'));
      await tester.ensureVisible(field);
      await tester.enterText(field, entry.value);
    }
    final saveButton = find.byKey(const Key('save-personal-option'));
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(repository.savedCategory, 'Technology');
    expect(repository.savedSubcategory, 'Laptop');
    expect(repository.savedName, 'My Custom Laptop');
    expect(repository.savedAttributes['RAM'], 16.0);
    expect(repository.savedAttributes['Storage'], 512.0);
    expect(repository.savedAttributes['Processor'], 'Core Ultra 7');
    expect(find.text('My Custom Laptop'), findsOneWidget);
    expect(
      find.textContaining('Only you can see these options'),
      findsOneWidget,
    );

    await tester.pumpWidget(
      Provider<PersonalAlternativeRepository>.value(
        value: repository,
        child: const MaterialApp(
          home: CreateDecisionScreen(
            initialCategory: 'Technology',
            initialSubcategory: 'Laptop',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('My Custom Laptop'), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('allows editing and deleting a saved personal option', (
    tester,
  ) async {
    final repository = _MemoryPersonalAlternativeRepository();
    await repository.addMyOption(
      category: 'Technology',
      subcategory: 'Laptop',
      name: 'My Custom Laptop',
      attributes: const {
        'Price': 1200.0,
        'RAM': 16.0,
        'Storage': 512.0,
        'Processor': 'Core Ultra 7',
        'Battery': 10.0,
        'Weight': 1.4,
      },
    );
    await tester.binding.setSurfaceSize(const Size(900, 1400));
    await tester.pumpWidget(
      Provider<PersonalAlternativeRepository>.value(
        value: repository,
        child: const MaterialApp(
          home: CreateDecisionScreen(
            initialCategory: 'Technology',
            initialSubcategory: 'Laptop',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final editButton = find.byKey(
      const Key('edit-personal-option-personal-option-id'),
    );
    await tester.ensureVisible(editButton);
    await tester.tap(editButton);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('manual-option-name')),
      'Updated Laptop',
    );
    await tester.enterText(find.byKey(const Key('manual-attribute-RAM')), '32');
    await tester.tap(find.byKey(const Key('save-personal-option')));
    await tester.pumpAndSettle();

    expect(repository.savedName, 'Updated Laptop');
    expect(repository.savedAttributes['RAM'], 32.0);
    expect(find.text('Updated Laptop'), findsOneWidget);

    final deleteButton = find.byKey(
      const Key('delete-personal-option-personal-option-id'),
    );
    await tester.ensureVisible(deleteButton);
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(
        const Key('confirm-delete-personal-option-personal-option-id'),
      ),
    );
    await tester.pumpAndSettle();

    expect(repository.savedName, isNull);
    expect(find.text('Updated Laptop'), findsNothing);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('requires selected options before making a decision', (
    tester,
  ) async {
    final repository = _MemoryPersonalAlternativeRepository();
    await tester.binding.setSurfaceSize(const Size(900, 1400));
    await tester.pumpWidget(
      Provider<PersonalAlternativeRepository>.value(
        value: repository,
        child: const MaterialApp(
          home: CreateDecisionScreen(
            initialCategory: 'Technology',
            initialSubcategory: 'Laptop',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final button = find.text('Make a Decision');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(
      find.text('Add at least two options before making a decision.'),
      findsOneWidget,
    );
    expect(find.text('Almost done! 🎉'), findsNothing);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('accepts a priority total that rounds to 100 percent', (
    tester,
  ) async {
    final repository = _MemoryPersonalAlternativeRepository();
    await tester.binding.setSurfaceSize(const Size(900, 1400));
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => DecisionHistoryProvider(
          repository: FakeDecisionHistoryRepository(),
        ),
        child: Provider<PersonalAlternativeRepository>.value(
          value: repository,
          child: const MaterialApp(
            home: CreateDecisionScreen(
              initialCategory: 'Technology',
              initialSubcategory: 'Laptop',
              initialOptions: ['Option 1', 'Option 2'],
              initialPriorities: {
                'Price': 24.999999999,
                'RAM': 20,
                'Storage': 20,
                'Processor': 20,
                'Battery': 10,
                'Weight': 5,
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final button = find.text('Make a Decision');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('100%'), findsWidgets);
    expect(find.text('Almost done! 🎉'), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('shows the precise total when priorities are still invalid', (
    tester,
  ) async {
    final repository = _MemoryPersonalAlternativeRepository();
    await tester.binding.setSurfaceSize(const Size(900, 1400));
    await tester.pumpWidget(
      Provider<PersonalAlternativeRepository>.value(
        value: repository,
        child: const MaterialApp(
          home: CreateDecisionScreen(
            initialCategory: 'Technology',
            initialSubcategory: 'Laptop',
            initialPriorities: {
              'Price': 24.98,
              'RAM': 20,
              'Storage': 20,
              'Processor': 20,
              'Battery': 10,
              'Weight': 5,
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('99.98%'), findsOneWidget);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('restores custom criteria and prevents selecting more than six', (
    tester,
  ) async {
    final alternatives = _MemoryPersonalAlternativeRepository();
    final criteriaRepository = _MemoryPersonalCriteriaRepository();
    Widget decisionScreen() => MultiProvider(
      providers: [
        Provider<PersonalAlternativeRepository>.value(value: alternatives),
        Provider<PersonalCriteriaRepository>.value(value: criteriaRepository),
      ],
      child: const MaterialApp(
        home: CreateDecisionScreen(
          initialCategory: 'Technology',
          initialSubcategory: 'Laptop',
        ),
      ),
    );

    await tester.binding.setSurfaceSize(const Size(900, 1400));
    await tester.pumpWidget(decisionScreen());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Add Criteria'));
    await tester.tap(find.text('Add Criteria'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('add-criteria-name')),
      'Comfort',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
    await tester.pumpAndSettle();

    final criterion = find.ancestor(
      of: find.text('Comfort'),
      matching: find.byType(CheckboxListTile),
    );
    await tester.ensureVisible(criterion);
    await tester.tap(criterion);
    await tester.pumpAndSettle();

    expect(
      criteriaRepository.getCriteria('Technology', 'Laptop'),
      contains('Comfort'),
    );
    expect(find.text('Maximum criteria reached'), findsOneWidget);
    expect(find.textContaining('up to 6 criteria'), findsOneWidget);
    expect(tester.widget<CheckboxListTile>(criterion).value, isFalse);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.pumpWidget(decisionScreen());
    await tester.pumpAndSettle();

    final restoredCriterion = find.ancestor(
      of: find.text('Comfort'),
      matching: find.byType(CheckboxListTile),
    );
    expect(restoredCriterion, findsOneWidget);
    expect(tester.widget<CheckboxListTile>(restoredCriterion).value, isFalse);

    final smartphone = find.text('Smartphone').first;
    await tester.ensureVisible(smartphone);
    await tester.tap(smartphone);
    await tester.pumpAndSettle();
    expect(find.text('Comfort'), findsNothing);

    final laptop = find.text('Laptop').first;
    await tester.ensureVisible(laptop);
    await tester.tap(laptop);
    await tester.pumpAndSettle();
    expect(find.text('Comfort'), findsWidgets);
    await tester.binding.setSurfaceSize(null);
  });
}

class _MemoryPersonalCriteriaRepository implements PersonalCriteriaRepository {
  final Map<String, List<String>> _criteriaByScope = {};

  String _scopeKey(String category, String subcategory) =>
      '$category\u001f$subcategory';

  List<String> getCriteria(String category, String subcategory) =>
      List<String>.of(
        _criteriaByScope[_scopeKey(category, subcategory)] ?? const [],
      );

  @override
  Future<String> addMyCriterion({
    required String category,
    required String subcategory,
    required String name,
  }) async {
    final normalizedName = name.trim();
    final criteria = _criteriaByScope.putIfAbsent(
      _scopeKey(category, subcategory),
      () => [],
    );
    if (criteria.any(
      (criterion) => criterion.toLowerCase() == normalizedName.toLowerCase(),
    )) {
      throw StateError('This criterion is already saved for this subcategory.');
    }
    criteria.add(normalizedName);
    return normalizedName;
  }

  @override
  Future<List<String>> getMyCriteria({
    required String category,
    required String subcategory,
  }) async => getCriteria(category, subcategory);
}

class _MemoryPersonalAlternativeRepository
    implements PersonalAlternativeRepository {
  String? savedCategory;
  String? savedSubcategory;
  String? savedName;
  Map<String, dynamic> savedAttributes = {};

  @override
  Future<List<Alternative>> getMyOptions({
    required String category,
    required String subcategory,
  }) async {
    if (category != savedCategory ||
        subcategory != savedSubcategory ||
        savedName == null) {
      return [];
    }
    return [
      Alternative(
        id: 'personal-option-id',
        name: savedName!,
        source: 'custom',
        specs: savedAttributes,
      ),
    ];
  }

  @override
  Future<Alternative> addMyOption({
    required String category,
    required String subcategory,
    required String name,
    required Map<String, dynamic> attributes,
  }) async {
    savedCategory = category;
    savedSubcategory = subcategory;
    savedName = name;
    savedAttributes = attributes;
    return Alternative(
      id: 'personal-option-id',
      name: name,
      source: 'custom',
      specs: attributes,
    );
  }

  @override
  Future<Alternative> updateMyOption({
    required String id,
    required String name,
    required Map<String, dynamic> attributes,
  }) async {
    savedName = name;
    savedAttributes = attributes;
    return Alternative(id: id, name: name, source: 'custom', specs: attributes);
  }

  @override
  Future<void> deleteMyOption({required String id}) async {
    savedName = null;
    savedAttributes = {};
  }
}
