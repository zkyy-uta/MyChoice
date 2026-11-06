import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mychoice_app/features/alternative_management/domain/entities/alternative.dart';
import 'package:mychoice_app/features/comparison/presentation/providers/comparison_provider.dart';
import 'package:mychoice_app/features/criteria_selection/domain/entities/criterion.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/calculation_breakdown.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/decision_matrix.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/decision_result.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/saw_configuration.dart';
import 'package:mychoice_app/screens/user/comparison/comparison_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('comparison values for all alternatives fit on a phone screen', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));

    final alternatives = [
      const Alternative(id: 'a', name: 'Option A', source: 'custom'),
      const Alternative(id: 'b', name: 'Option B', source: 'custom'),
      const Alternative(id: 'c', name: 'Option C', source: 'custom'),
    ];
    final criterion = Criterion(
      id: 'price',
      name: 'Price',
      type: CriterionType.cost,
      source: 'custom',
    );
    final matrix = DecisionMatrix(
      alternatives: alternatives,
      criteria: [criterion],
      values: {
        'a': {'price': 0.9},
        'b': {'price': 0.8},
        'c': {'price': 0.7},
      },
    );
    final result = DecisionResult(
      ranking: [
        for (var index = 0; index < alternatives.length; index++)
          RankedAlternative(
            rank: index + 1,
            alternative: alternatives[index],
            compositeScore: 90 - index * 10,
          ),
      ],
      breakdown: {
        for (var index = 0; index < alternatives.length; index++)
          alternatives[index].id: CalculationBreakdown(
            alternativeId: alternatives[index].id,
            criteria: {
              'price': NormalizedScore(
                normalized: 0.9 - index * 0.1,
                weight: 1,
                weighted: 0.9 - index * 0.1,
              ),
            },
            compositeScore: 90 - index * 10,
          ),
      },
      algorithmVersion: '1.0',
      calculatedAt: DateTime(2025),
      config: SAWConfiguration(
        version: '1.0',
        toleranceThreshold: 0.001,
        timestamp: DateTime(2025),
      ),
    );
    final provider = ComparisonProvider()
      ..buildComparisonView(result, matrix, {'price': criterion});

    await tester.pumpWidget(
      ChangeNotifierProvider<ComparisonProvider>.value(
        value: provider,
        child: const MaterialApp(home: ComparisonScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Price'), findsOneWidget);
    for (final value in ['0.900', '0.800', '0.700']) {
      final cell = find.text(value);
      expect(cell, findsOneWidget);
      expect(tester.getCenter(cell).dx, lessThan(360));
    }

    await tester.binding.setSurfaceSize(null);
  });
}
