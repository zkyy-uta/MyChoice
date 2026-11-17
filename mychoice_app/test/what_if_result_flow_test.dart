import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mychoice_app/features/alternative_management/domain/entities/alternative.dart';
import 'package:mychoice_app/features/criteria_selection/domain/entities/criterion.dart';
import 'package:mychoice_app/features/decision_engine/data/repositories/decision_engine_repository_impl.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/decision_matrix.dart';
import 'package:mychoice_app/features/priority_setting/domain/usecases/auto_balance_usecase.dart';
import 'package:mychoice_app/features/what_if_simulation/domain/usecases/recalculate_simulation_usecase.dart';
import 'package:mychoice_app/features/what_if_simulation/presentation/providers/simulation_provider.dart';
import 'package:mychoice_app/screens/user/decision/what_if_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets(
    'Try Another Scenario processes changed weights and opens decision results',
    (WidgetTester tester) async {
      final repository = DecisionEngineRepositoryImpl();
      final price = Criterion(
        id: 'price',
        name: 'Price',
        type: CriterionType.cost,
        source: 'suggested',
      );
      final quality = Criterion(
        id: 'quality',
        name: 'Quality',
        type: CriterionType.benefit,
        source: 'suggested',
      );
      final alternatives = [
        const Alternative(id: 'a', name: 'Option A', source: 'custom'),
        const Alternative(id: 'b', name: 'Option B', source: 'custom'),
      ];
      final criteria = [price, quality];
      final criteriaMap = {
        for (final criterion in criteria) criterion.id: criterion,
      };
      final matrix = DecisionMatrix(
        alternatives: alternatives,
        criteria: criteria,
        values: {
          'a': {'price': 10, 'quality': 5},
          'b': {'price': 20, 'quality': 10},
        },
      );
      final originalWeights = {'price': 50.0, 'quality': 50.0};
      final originalResult = await repository.calculate(
        matrix: matrix,
        weights: originalWeights,
        criteriaMap: criteriaMap,
      );
      final simulationProvider =
          SimulationProvider(
            recalculateUseCase: RecalculateSimulationUseCase(
              repository: repository,
            ),
            autoBalanceUseCase: AutoBalanceUseCase(),
          )..initialize(
            originalResult: originalResult,
            matrix: matrix,
            criteriaMap: criteriaMap,
            originalWeights: originalWeights,
            category: 'Education',
            subcategory: 'Course',
          );
      simulationProvider.adjustWeight('price', 0);
      simulationProvider.adjustWeight('quality', 100);
      await simulationProvider.recalculate();

      await tester.pumpWidget(
        ChangeNotifierProvider<SimulationProvider>.value(
          value: simulationProvider,
          child: const MaterialApp(home: WhatIfScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Run Simulation'));
      await tester.tap(find.text('Run Simulation'));
      await tester.pumpAndSettle();
      expect(find.text('Try Another Scenario'), findsOneWidget);

      await tester.tap(find.text('Try Another Scenario'));
      await tester.pump();
      expect(find.text('Processing Decisions'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(find.text('Decision Results'), findsOneWidget);
      expect(find.text('Education'), findsOneWidget);
      expect(find.text('Course'), findsOneWidget);
      expect(find.text('🥇 Option B'), findsOneWidget);

      simulationProvider.dispose();
    },
  );
}
