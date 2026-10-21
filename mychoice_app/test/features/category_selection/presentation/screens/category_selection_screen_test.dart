import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mychoice_app/features/category_selection/presentation/providers/category_provider.dart';
import 'package:mychoice_app/features/category_selection/presentation/screens/category_selection_screen.dart';
import 'package:mychoice_app/features/category_selection/data/repositories/category_repository_impl.dart';
import 'package:mychoice_app/features/category_selection/data/datasources/category_datasource.dart';
import 'package:mychoice_app/core/theme/app_theme.dart';

void main() {
  group('CategorySelectionScreen Widget Tests', () {
    late CategoryProvider categoryProvider;

    setUp(() {
      final repository = CategoryRepositoryImpl(
        dataSource: MockCategoryDataSource(),
      );
      categoryProvider = CategoryProvider(repository: repository);
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

      // Assert
      expect(find.byType(Card), findsWidgets);
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

      // Find and tap Technology category
      final technologyCard = find.ancestor(
        of: find.text('Technology'),
        matching: find.byType(Card),
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

      // Act - tap Technology category
      final technologyCard = find.ancestor(
        of: find.text('Technology'),
        matching: find.byType(Card),
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

      // Act - tap Technology category
      final technologyCard = find.ancestor(
        of: find.text('Technology'),
        matching: find.byType(Card),
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

      // Act - select Technology
      final technologyCard = find.ancestor(
        of: find.text('Technology'),
        matching: find.byType(Card),
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
        matching: find.byType(Card),
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

      // Act - tap Technology but don't select subcategory
      final technologyCard = find.ancestor(
        of: find.text('Technology'),
        matching: find.byType(Card),
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

        // Act - select Technology
        final technologyCard = find.ancestor(
          of: find.text('Technology'),
          matching: find.byType(Card),
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

      // Assert
      expect(find.text('Technology'), findsOneWidget);
      expect(find.text('Education'), findsOneWidget);
      expect(find.text('Fashion'), findsOneWidget);
    });
  });
}
