import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mychoice_app/features/category_selection/presentation/providers/category_provider.dart';
import 'package:mychoice_app/screens/user/decision/category_selection_screen.dart';
import 'package:mychoice_app/features/category_selection/domain/entities/category.dart';
import 'package:mychoice_app/features/category_selection/domain/repositories/category_repository.dart';
import 'package:mychoice_app/core/theme/app_theme.dart';

void main() {
  group('CategorySelectionScreen Widget Tests', () {
    late CategoryProvider categoryProvider;

    setUp(() {
      categoryProvider = CategoryProvider(
        repository: _TestCategoryRepository(),
      );
    });

    testWidgets('should display category cards', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: ChangeNotifierProvider<CategoryProvider>.value(
            value: categoryProvider,
            child: const CategorySelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Technology'), findsOneWidget);
      expect(find.text('Education'), findsOneWidget);
      expect(find.text('Fashion'), findsOneWidget);
    });

    testWidgets('should display subcategories when category is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: ChangeNotifierProvider<CategoryProvider>.value(
            value: categoryProvider,
            child: const CategorySelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap Technology category
      final technologyCard = find.ancestor(
        of: find.text('Technology'),
        matching: find.byType(InkWell),
      );
      expect(technologyCard, findsOneWidget);
      await tester.tap(technologyCard.first);
      await tester.pumpAndSettle();

      // Assert - subcategories should appear
      expect(find.text('Laptop'), findsOneWidget);
      expect(find.text('Phone'), findsOneWidget);
    });

    testWidgets('should allow selecting a subcategory', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: ChangeNotifierProvider<CategoryProvider>.value(
            value: categoryProvider,
            child: const CategorySelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act - tap Technology category
      final technologyCard = find.ancestor(
        of: find.text('Technology'),
        matching: find.byType(InkWell),
      );
      await tester.tap(technologyCard.first);
      await tester.pumpAndSettle();

      // Act - tap Laptop subcategory chip
      final laptopChip = find.ancestor(
        of: find.text('Laptop'),
        matching: find.byType(FilterChip),
      );
      expect(laptopChip, findsOneWidget);
      await tester.tap(laptopChip.first);
      await tester.pumpAndSettle();

      // Assert
      expect(categoryProvider.selectedSubcategory, isNotNull);
      expect(categoryProvider.selectedSubcategory!.name, 'Laptop');
    });

    testWidgets('should highlight selected category', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: ChangeNotifierProvider<CategoryProvider>.value(
            value: categoryProvider,
            child: const CategorySelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act - tap Technology category
      final technologyCard = find.ancestor(
        of: find.text('Technology'),
        matching: find.byType(InkWell),
      );
      await tester.tap(technologyCard.first);
      await tester.pumpAndSettle();

      // Assert
      expect(categoryProvider.selectedCategory, isNotNull);
      expect(categoryProvider.selectedCategory!.name, 'Technology');
    });

    testWidgets('should reset subcategory when category changes', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: ChangeNotifierProvider<CategoryProvider>.value(
            value: categoryProvider,
            child: const CategorySelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act - select Technology
      final technologyCard = find.ancestor(
        of: find.text('Technology'),
        matching: find.byType(InkWell),
      );
      await tester.tap(technologyCard.first);
      await tester.pumpAndSettle();

      // Act - select Laptop
      final laptopChip = find.ancestor(
        of: find.text('Laptop'),
        matching: find.byType(FilterChip),
      );
      await tester.tap(laptopChip.first);
      await tester.pumpAndSettle();

      expect(categoryProvider.selectedSubcategory!.name, 'Laptop');

      // Act - select Education category (should reset subcategory)
      final educationCard = find.ancestor(
        of: find.text('Education'),
        matching: find.byType(InkWell),
      );
      await tester.tap(educationCard.first);
      await tester.pumpAndSettle();

      // Assert
      expect(categoryProvider.selectedSubcategory, isNull);
      expect(categoryProvider.selectedCategory!.name, 'Education');
    });

    testWidgets('should disable Next button when category not selected', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: ChangeNotifierProvider<CategoryProvider>.value(
            value: categoryProvider,
            child: const CategorySelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - Next button should be disabled
      final nextButton = find.ancestor(
        of: find.text('Next'),
        matching: find.byType(ElevatedButton),
      );
      expect(nextButton, findsOneWidget);

      // Check if button is disabled
      final buttonWidget = tester.widget<ElevatedButton>(nextButton);
      expect(buttonWidget.onPressed, isNull);
    });

    testWidgets('should disable Next button when subcategory not selected', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: ChangeNotifierProvider<CategoryProvider>.value(
            value: categoryProvider,
            child: const CategorySelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act - tap Technology but don't select subcategory
      final technologyCard = find.ancestor(
        of: find.text('Technology'),
        matching: find.byType(InkWell),
      );
      await tester.tap(technologyCard.first);
      await tester.pumpAndSettle();

      // Assert - Next button should still be disabled
      final nextButton = find.ancestor(
        of: find.text('Next'),
        matching: find.byType(ElevatedButton),
      );
      final buttonWidget = tester.widget<ElevatedButton>(nextButton);
      expect(buttonWidget.onPressed, isNull);
    });

    testWidgets(
      'should enable Next button when both category and subcategory selected',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: ChangeNotifierProvider<CategoryProvider>.value(
              value: categoryProvider,
              child: const CategorySelectionScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Act - select Technology
        final technologyCard = find.ancestor(
          of: find.text('Technology'),
          matching: find.byType(InkWell),
        );
        await tester.tap(technologyCard.first);
        await tester.pumpAndSettle();

        // Act - select Laptop
        final laptopChip = find.ancestor(
          of: find.text('Laptop'),
          matching: find.byType(FilterChip),
        );
        await tester.tap(laptopChip.first);
        await tester.pumpAndSettle();

        // Assert - Next button should be enabled
        final nextButton = find.ancestor(
          of: find.text('Next'),
          matching: find.byType(ElevatedButton),
        );
        final buttonWidget = tester.widget<ElevatedButton>(nextButton);
        expect(buttonWidget.onPressed, isNotNull);
      },
    );

    testWidgets('should have Back button that pops navigation', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: ChangeNotifierProvider<CategoryProvider>.value(
            value: categoryProvider,
            child: const CategorySelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should display all three main categories', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: ChangeNotifierProvider<CategoryProvider>.value(
            value: categoryProvider,
            child: const CategorySelectionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Technology'), findsOneWidget);
      expect(find.text('Education'), findsOneWidget);
      expect(find.text('Fashion'), findsOneWidget);
    });
  });
}

class _TestCategoryRepository implements CategoryRepository {
  static const _categories = [
    Category(
      id: 'technology',
      name: 'Technology',
      description: 'Electronics and computing devices',
      icon: 'technology',
      subcategories: [
        Subcategory(
          id: 'laptop',
          name: 'Laptop',
          description: 'Portable computers',
        ),
        Subcategory(id: 'phone', name: 'Phone', description: 'Mobile phones'),
      ],
    ),
    Category(
      id: 'education',
      name: 'Education',
      description: 'Learning and courses',
      icon: 'education',
      subcategories: [
        Subcategory(
          id: 'course',
          name: 'Course',
          description: 'Online courses',
        ),
      ],
    ),
    Category(
      id: 'fashion',
      name: 'Fashion',
      description: 'Clothing and accessories',
      icon: 'fashion',
      subcategories: [
        Subcategory(id: 'shoes', name: 'Shoes', description: 'Footwear'),
      ],
    ),
  ];

  @override
  Future<List<Category>> getCategories() async => _categories;

  @override
  Future<List<Subcategory>> getSubcategories(String categoryId) async {
    return _categories
        .firstWhere((category) => category.id == categoryId)
        .subcategories;
  }

  @override
  Future<Category?> getCategoryById(String categoryId) async {
    for (final category in _categories) {
      if (category.id == categoryId) return category;
    }
    return null;
  }
}
