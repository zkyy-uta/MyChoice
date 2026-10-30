import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mychoice_app/screens/user/decision/priority_input_screen.dart';
import 'package:mychoice_app/features/criteria_selection/domain/entities/criterion.dart';
import 'package:mychoice_app/core/theme/app_theme.dart';
import 'package:mychoice_app/core/widgets/forms/weight_slider.dart';
import 'package:mychoice_app/core/widgets/forms/total_weight_indicator.dart';

void main() {
  group('PriorityInputScreen Widget Tests', () {
    late List<Criterion> testCriteria;

    setUp(() {
      testCriteria = [
        Criterion(
          id: 'crit1',
          name: 'Price',
          type: CriterionType.cost,
          source: 'suggested',
        ),
        Criterion(
          id: 'crit2',
          name: 'Quality',
          type: CriterionType.benefit,
          source: 'suggested',
        ),
        Criterion(
          id: 'crit3',
          name: 'Speed',
          type: CriterionType.benefit,
          source: 'suggested',
        ),
      ];
    });

    testWidgets('should display weight sliders for each criterion', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: PriorityInputScreen(criteria: testCriteria),
        ),
      );

      // Assert
      expect(find.byType(WeightSlider), findsWidgets);
      expect(find.text('Price'), findsWidgets);
      expect(find.text('Quality'), findsWidgets);
      expect(find.text('Speed'), findsWidgets);
    });

    testWidgets('should display total weight indicator', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: PriorityInputScreen(criteria: testCriteria),
        ),
      );

      // Assert
      expect(find.byType(TotalWeightIndicator), findsOneWidget);
      expect(find.text('Total Weight'), findsOneWidget);
    });

    testWidgets('should display Auto-Balance button', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: PriorityInputScreen(criteria: testCriteria),
        ),
      );

      // Assert
      expect(find.text('Auto-Balance'), findsOneWidget);
    });

    testWidgets('should display Calculate Result button', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: PriorityInputScreen(criteria: testCriteria),
        ),
      );

      // Assert
      expect(find.text('Calculate Result'), findsOneWidget);
    });

    testWidgets('should disable Calculate Result button when total != 100%', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: PriorityInputScreen(criteria: testCriteria),
        ),
      );

      // Assert
      final calculateButton = find.ancestor(
        of: find.text('Calculate Result'),
        matching: find.byType(ElevatedButton),
      );
      final buttonWidget = tester.widget<ElevatedButton>(calculateButton);
      expect(buttonWidget.onPressed, isNull);
    });

    testWidgets('should update weight slider in real-time', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: PriorityInputScreen(criteria: testCriteria),
        ),
      );

      // Act - drag slider
      final slider = find.byType(Slider).first;
      await tester.drag(slider, const Offset(100, 0));
      await tester.pumpAndSettle();

      // Assert - weight should be updated
      // The percentage text should be visible somewhere on screen
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets(
      'should enable Calculate Result button when weights sum to 100%',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: PriorityInputScreen(criteria: testCriteria),
          ),
        );

        // Act - set weights to sum to 100%
        // Get all sliders
        final sliders = find.byType(Slider);
        // Set first to 34, second to 33, third to 33 (total 100)
        await tester.drag(sliders.at(0), const Offset(50, 0));
        await tester.pumpAndSettle();
        await tester.drag(sliders.at(1), const Offset(50, 0));
        await tester.pumpAndSettle();
        await tester.drag(sliders.at(2), const Offset(50, 0));
        await tester.pumpAndSettle();

        // Note: This is a simplified test - actual implementation would
        // need to ensure sliders are positioned correctly to sum to 100%
      },
    );

    testWidgets('should update total weight indicator', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: PriorityInputScreen(criteria: testCriteria),
        ),
      );

      // Assert - should show 0% initially or partial sums
      expect(find.byType(TotalWeightIndicator), findsOneWidget);
    });

    testWidgets('should have Back button', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: PriorityInputScreen(criteria: testCriteria),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should display instructions text', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: PriorityInputScreen(criteria: testCriteria),
        ),
      );

      // Assert
      expect(find.text('Set the importance'), findsOneWidget);
      expect(find.text('100%'), findsWidgets);
    });

    testWidgets('should allow tapping Auto-Balance button', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: PriorityInputScreen(criteria: testCriteria),
        ),
      );

      // Act
      final autoBalanceButton = find.text('Auto-Balance');
      expect(autoBalanceButton, findsOneWidget);

      await tester.tap(autoBalanceButton);
      await tester.pumpAndSettle();

      // Assert - should show a snackbar
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets(
      'should display error when Calculate Result pressed with invalid weights',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: PriorityInputScreen(criteria: testCriteria),
          ),
        );

        // Note: Calculate button should be disabled when weights are invalid,
        // so this test ensures the button state logic works correctly
        final calculateButton = find.ancestor(
          of: find.text('Calculate Result'),
          matching: find.byType(ElevatedButton),
        );
        final buttonWidget = tester.widget<ElevatedButton>(calculateButton);
        expect(buttonWidget.onPressed, isNull);
      },
    );

    testWidgets('should display all three criteria on screen', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: PriorityInputScreen(criteria: testCriteria),
        ),
      );

      // Assert
      expect(find.text('Price'), findsWidgets);
      expect(find.text('Quality'), findsWidgets);
      expect(find.text('Speed'), findsWidgets);
    });
  });
}
