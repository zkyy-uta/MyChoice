import 'package:flutter_test/flutter_test.dart';
import 'package:mychoice_app/features/decision_engine/data/datasources/saw_calculator.dart';
import 'package:mychoice_app/features/alternative_management/domain/entities/alternative.dart';
import 'package:mychoice_app/features/criteria_selection/domain/entities/criterion.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/decision_matrix.dart';

void main() {
  group('SAW Calculator Tests', () {
    // **Property 1: SAW Calculation Determinism**
    // Same inputs must produce identical outputs every time
    test('Property 1: SAW Calculation Determinism', () {
      // Setup: Create a fixed matrix
      final alts = [
        Alternative(id: 'a1', name: 'Option A', source: 'custom'),
        Alternative(id: 'a2', name: 'Option B', source: 'custom'),
        Alternative(id: 'a3', name: 'Option C', source: 'custom'),
      ];

      final criteria = [
        Criterion(
          id: 'c1',
          name: 'Price',
          type: CriterionType.cost,
          source: 'suggested',
        ),
        Criterion(
          id: 'c2',
          name: 'Quality',
          type: CriterionType.benefit,
          source: 'suggested',
        ),
        Criterion(
          id: 'c3',
          name: 'Speed',
          type: CriterionType.benefit,
          source: 'suggested',
        ),
      ];

      final values = {
        'a1': {'c1': 100.0, 'c2': 85.0, 'c3': 80.0},
        'a2': {'c1': 120.0, 'c2': 90.0, 'c3': 75.0},
        'a3': {'c1': 80.0, 'c2': 75.0, 'c3': 95.0},
      };

      final matrix = DecisionMatrix(
        alternatives: alts,
        criteria: criteria,
        values: values,
      );

      final criteriaMap = {for (var c in criteria) c.id: c};
      final weights = {'c1': 40.0, 'c2': 35.0, 'c3': 25.0};

      // Calculate twice and verify identical results
      final result1 = SAWCalculator.calculate(
        matrix: matrix,
        criteriaMap: criteriaMap,
        weights: weights,
      );

      final result2 = SAWCalculator.calculate(
        matrix: matrix,
        criteriaMap: criteriaMap,
        weights: weights,
      );

      // Verify ranking order is identical
      expect(result1.ranking.length, result2.ranking.length);
      for (int i = 0; i < result1.ranking.length; i++) {
        expect(
          result1.ranking[i].alternative.id,
          result2.ranking[i].alternative.id,
        );
        expect(
          (result1.ranking[i].compositeScore -
                  result2.ranking[i].compositeScore)
              .abs(),
          lessThan(0.01), // Allow 0.01% tolerance
          reason: 'Scores must be identical within tolerance',
        );
      }
    });

    // **Property 2: Normalization Bounds and Direction**
    // Verify normalized values are always in [0, 1] and maintain proper direction
    test('Property 2: Normalization Bounds and Direction', () {
      // Test Benefit criterion: higher raw value → higher normalized value
      final benefitAlts = [
        Alternative(id: 'b1', name: 'Low', source: 'custom'),
        Alternative(id: 'b2', name: 'Medium', source: 'custom'),
        Alternative(id: 'b3', name: 'High', source: 'custom'),
      ];

      final benefitCriteria = [
        Criterion(
          id: 'benefit',
          name: 'RAM',
          type: CriterionType.benefit,
          source: 'suggested',
        ),
      ];

      final benefitValues = {
        'b1': {'benefit': 8.0},
        'b2': {'benefit': 16.0},
        'b3': {'benefit': 32.0},
      };

      final benefitMatrix = DecisionMatrix(
        alternatives: benefitAlts,
        criteria: benefitCriteria,
        values: benefitValues,
      );

      final criteriaMap = {'benefit': benefitCriteria[0]};
      final weights = {'benefit': 100.0};

      final result = SAWCalculator.calculate(
        matrix: benefitMatrix,
        criteriaMap: criteriaMap,
        weights: weights,
      );

      // Verify normalized values are in [0, 1]
      for (final ranking in result.ranking) {
        final breakdown = result.breakdown[ranking.alternative.id]!;
        for (final score in breakdown.criteria.values) {
          expect(score.normalized, greaterThanOrEqualTo(0.0));
          expect(score.normalized, lessThanOrEqualTo(1.0));
        }
      }

      // Verify benefit direction: higher raw value → higher composite score
      expect(
        result.ranking[0].alternative.id,
        'b3',
      ); // Highest RAM ranked first
      expect(
        result.ranking[1].alternative.id,
        'b2',
      ); // Medium RAM ranked second
      expect(result.ranking[2].alternative.id, 'b1'); // Low RAM ranked last
    });

    // **Property 3: Weighted Score Accumulation**
    // Verify final composite scores are always in [0, 100]
    test('Property 3: Weighted Score Accumulation', () {
      final alts = [
        Alternative(id: 'a1', name: 'Option 1', source: 'custom'),
        Alternative(id: 'a2', name: 'Option 2', source: 'custom'),
      ];

      final criteria = [
        Criterion(
          id: 'c1',
          name: 'Factor 1',
          type: CriterionType.benefit,
          source: 'suggested',
        ),
        Criterion(
          id: 'c2',
          name: 'Factor 2',
          type: CriterionType.cost,
          source: 'suggested',
        ),
      ];

      final values = {
        'a1': {'c1': 100.0, 'c2': 50.0},
        'a2': {'c1': 200.0, 'c2': 30.0},
      };

      final matrix = DecisionMatrix(
        alternatives: alts,
        criteria: criteria,
        values: values,
      );

      final criteriaMap = {for (var c in criteria) c.id: c};
      final weights = {'c1': 60.0, 'c2': 40.0};

      final result = SAWCalculator.calculate(
        matrix: matrix,
        criteriaMap: criteriaMap,
        weights: weights,
      );

      // Verify all composite scores are in [0, 100]
      for (final ranking in result.ranking) {
        expect(ranking.compositeScore, greaterThanOrEqualTo(0.0));
        expect(ranking.compositeScore, lessThanOrEqualTo(100.0));
      }
    });

    // **Property 18: Normalized Values Consistency**
    // Same value normalized repeatedly must produce identical result (no drift)
    test('Property 18: Normalized Values Consistency Across Recalculation', () {
      final alts = [Alternative(id: 'a', name: 'Option', source: 'custom')];

      final criteria = [
        Criterion(
          id: 'c',
          name: 'Criterion',
          type: CriterionType.benefit,
          source: 'suggested',
        ),
      ];

      final values = {
        'a': {'c': 42.5},
      };

      final matrix = DecisionMatrix(
        alternatives: alts,
        criteria: criteria,
        values: values,
      );

      final criteriaMap = {'c': criteria[0]};
      final weights = {'c': 100.0};

      // Calculate 100 times and verify identical results each time
      final results = <double>[];
      for (int i = 0; i < 100; i++) {
        final result = SAWCalculator.calculate(
          matrix: matrix,
          criteriaMap: criteriaMap,
          weights: weights,
        );
        results.add(result.ranking[0].compositeScore);
      }

      // All results must be identical
      final firstResult = results[0];
      for (final result in results) {
        expect(result, firstResult);
      }
    });

    // **Property 19: Benefit vs. Cost Criterion Ordering Preservation**
    // Ordered values must maintain their order after normalization
    test('Property 19: Benefit vs. Cost Criterion Ordering Preservation', () {
      // Test benefit criteria: v1 < v2 < v3 → norm[v1] < norm[v2] < norm[v3]
      final benefitAlts = [
        Alternative(id: 'a1', name: 'Low', source: 'custom'),
        Alternative(id: 'a2', name: 'Mid', source: 'custom'),
        Alternative(id: 'a3', name: 'High', source: 'custom'),
      ];

      final benefitCriteria = [
        Criterion(
          id: 'benefit',
          name: 'Battery',
          type: CriterionType.benefit,
          source: 'suggested',
        ),
      ];

      final benefitValues = {
        'a1': {'benefit': 100.0},
        'a2': {'benefit': 150.0},
        'a3': {'benefit': 200.0},
      };

      final benefitMatrix = DecisionMatrix(
        alternatives: benefitAlts,
        criteria: benefitCriteria,
        values: benefitValues,
      );

      final criteriaMap = {'benefit': benefitCriteria[0]};
      final weights = {'benefit': 100.0};

      final result = SAWCalculator.calculate(
        matrix: benefitMatrix,
        criteriaMap: criteriaMap,
        weights: weights,
      );

      // For benefit: higher value should rank higher
      expect(result.ranking[0].alternative.id, 'a3');
      expect(result.ranking[1].alternative.id, 'a2');
      expect(result.ranking[2].alternative.id, 'a1');

      // Test cost criteria: v1 < v2 < v3 → norm[v1] > norm[v2] > norm[v3]
      final costAlts = [
        Alternative(id: 'c1', name: 'Cheap', source: 'custom'),
        Alternative(id: 'c2', name: 'Mid', source: 'custom'),
        Alternative(id: 'c3', name: 'Expensive', source: 'custom'),
      ];

      final costCriteria = [
        Criterion(
          id: 'cost',
          name: 'Price',
          type: CriterionType.cost,
          source: 'suggested',
        ),
      ];

      final costValues = {
        'c1': {'cost': 100.0},
        'c2': {'cost': 150.0},
        'c3': {'cost': 200.0},
      };

      final costMatrix = DecisionMatrix(
        alternatives: costAlts,
        criteria: costCriteria,
        values: costValues,
      );

      final costCriteriaMap = {'cost': costCriteria[0]};
      final costWeights = {'cost': 100.0};

      final costResult = SAWCalculator.calculate(
        matrix: costMatrix,
        criteriaMap: costCriteriaMap,
        weights: costWeights,
      );

      // For cost: lower value should rank higher
      expect(costResult.ranking[0].alternative.id, 'c1');
      expect(costResult.ranking[1].alternative.id, 'c2');
      expect(costResult.ranking[2].alternative.id, 'c3');
    });

    // **Edge Case: All values same (no differentiation)**
    test('Edge Case: All values identical', () {
      final alts = [
        Alternative(id: 'a1', name: 'Option A', source: 'custom'),
        Alternative(id: 'a2', name: 'Option B', source: 'custom'),
        Alternative(id: 'a3', name: 'Option C', source: 'custom'),
      ];

      final criteria = [
        Criterion(
          id: 'c1',
          name: 'Criterion 1',
          type: CriterionType.benefit,
          source: 'suggested',
        ),
      ];

      final values = {
        'a1': {'c1': 50.0},
        'a2': {'c1': 50.0},
        'a3': {'c1': 50.0},
      };

      final matrix = DecisionMatrix(
        alternatives: alts,
        criteria: criteria,
        values: values,
      );

      final criteriaMap = {'c1': criteria[0]};
      final weights = {'c1': 100.0};

      final result = SAWCalculator.calculate(
        matrix: matrix,
        criteriaMap: criteriaMap,
        weights: weights,
      );

      // All should have identical scores
      expect(
        result.ranking[0].compositeScore,
        result.ranking[1].compositeScore,
      );
      expect(
        result.ranking[1].compositeScore,
        result.ranking[2].compositeScore,
      );
    });

    // **Edge Case: Zero values**
    test('Edge Case: Zero values in matrix', () {
      final alts = [
        Alternative(id: 'a1', name: 'Zero', source: 'custom'),
        Alternative(id: 'a2', name: 'NonZero', source: 'custom'),
      ];

      final criteria = [
        Criterion(
          id: 'c1',
          name: 'Factor',
          type: CriterionType.cost,
          source: 'suggested',
        ),
      ];

      final values = {
        'a1': {'c1': 0.0},
        'a2': {'c1': 100.0},
      };

      final matrix = DecisionMatrix(
        alternatives: alts,
        criteria: criteria,
        values: values,
      );

      final criteriaMap = {'c1': criteria[0]};
      final weights = {'c1': 100.0};

      // Should not throw and should produce valid results
      final result = SAWCalculator.calculate(
        matrix: matrix,
        criteriaMap: criteriaMap,
        weights: weights,
      );

      expect(result.ranking.length, 2);
      expect(result.ranking[0].compositeScore.isFinite, true);
    });

    // **Performance: Large matrix (10 alts × 8 criteria)**
    test('Performance: Large decision matrix', () {
      final alts = List.generate(
        10,
        (i) => Alternative(id: 'a$i', name: 'Option $i', source: 'custom'),
      );

      final criteria = List.generate(
        8,
        (i) => Criterion(
          id: 'c$i',
          name: 'Criterion $i',
          type: i.isEven ? CriterionType.benefit : CriterionType.cost,
          source: 'suggested',
        ),
      );

      final values = <String, Map<String, double>>{};
      for (final alt in alts) {
        values[alt.id] = {};
        for (final crit in criteria) {
          values[alt.id]![crit.id] =
              (alt.id.hashCode + crit.id.hashCode) % 100 + 1.0;
        }
      }

      final matrix = DecisionMatrix(
        alternatives: alts,
        criteria: criteria,
        values: values,
      );

      final criteriaMap = {for (var c in criteria) c.id: c};
      final weights = {for (var c in criteria) c.id: 100.0 / criteria.length};

      final stopwatch = Stopwatch()..start();
      final result = SAWCalculator.calculate(
        matrix: matrix,
        criteriaMap: criteriaMap,
        weights: weights,
      );
      stopwatch.stop();

      expect(result.ranking.length, 10);
      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(1000),
        reason: 'Calculation should be fast',
      );
    });
  });
}
