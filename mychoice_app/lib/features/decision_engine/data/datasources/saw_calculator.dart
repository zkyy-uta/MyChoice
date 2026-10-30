import 'package:mychoice_app/features/alternative_management/domain/entities/alternative.dart';
import 'package:mychoice_app/features/criteria_selection/domain/entities/criterion.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/decision_matrix.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/decision_result.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/saw_configuration.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/calculation_breakdown.dart';

/// Extension on double for rounding to decimal places
extension DoubleRounding on double {
  /// Round to specified decimal places
  double clampToDecimal(int places) {
    final factor = pow(10.0, places).toInt();
    return (this * factor).round() / factor;
  }
}

/// SAW (Simple Additive Weighting) Calculator
/// Implements deterministic decision calculation with guaranteed reproducibility
class SAWCalculator {
  SAWCalculator._();

  /// Calculate SAW results from decision matrix
  /// Returns identical results for identical inputs (deterministic)
  static DecisionResult calculate({
    required DecisionMatrix matrix,
    required Map<String, Criterion> criteriaMap,
    required Map<String, double> weights, // critId -> 0-100
  }) {
    if (matrix.alternatives.isEmpty) {
      throw ArgumentError('No alternatives provided');
    }
    if (matrix.criteria.isEmpty) {
      throw ArgumentError('No criteria provided');
    }

    // Step 1: Normalize values
    final normalized = _normalize(matrix, criteriaMap);

    // Step 2: Apply weights
    final weighted = _applyWeights(normalized, weights);

    // Step 3: Calculate composite scores
    final scores = _sumScores(weighted);

    // Step 4: Rank alternatives
    final ranking = _rankAlternatives(scores, matrix.alternatives);

    // Step 5: Build breakdown
    final breakdown = _buildBreakdown(
      normalized,
      weighted,
      scores,
      criteriaMap,
      weights,
    );

    return DecisionResult(
      ranking: ranking,
      breakdown: breakdown,
      algorithmVersion: '1.0',
      calculatedAt: DateTime.now(),
      config: SAWConfiguration.defaultConfig(),
    );
  }

  /// Step 1: Normalize matrix values
  /// Benefit criteria: normalized = raw / MAX
  /// Cost criteria: normalized = MIN / raw
  /// All normalized values constrained to [0, 1]
  static Map<String, Map<String, double>> _normalize(
    DecisionMatrix matrix,
    Map<String, Criterion> criteriaMap,
  ) {
    final normalized = <String, Map<String, double>>{};

    for (final criterion in matrix.criteria) {
      // Get all values for this criterion
      final values = <double>[];
      for (final alt in matrix.alternatives) {
        final value = matrix.getValue(alt.id, criterion.id);
        if (value != null) {
          values.add(value);
        }
      }

      if (values.isEmpty) continue;

      final max = values.reduce((a, b) => a > b ? a : b);
      final min = values.reduce((a, b) => a < b ? a : b);

      for (final alt in matrix.alternatives) {
        if (!normalized.containsKey(alt.id)) {
          normalized[alt.id] = {};
        }

        final rawValue = matrix.getValue(alt.id, criterion.id);
        if (rawValue == null) continue;

        double normValue;

        // Check if benefit or cost criterion
        final criterionType = criteriaMap[criterion.id]?.type;
        if (criterionType == CriterionType.benefit) {
          // Benefit: higher is better, normalize to raw/MAX
          normValue = max > 0 ? rawValue / max : 0.0;
        } else {
          // Cost: lower is better, normalize to MIN/raw
          normValue = rawValue > 0 ? min / rawValue : 1.0;
        }

        // Clamp to [0, 1] and round to 3 decimal places for determinism
        normValue = normValue.clamp(0.0, 1.0).clampToDecimal(3);
        normalized[alt.id]![criterion.id] = normValue;
      }
    }

    return normalized;
  }

  /// Step 2: Apply weights to normalized values
  /// weighted = normalized * (weight / 100)
  /// Round to 4 decimal places
  static Map<String, Map<String, double>> _applyWeights(
    Map<String, Map<String, double>> normalized,
    Map<String, double> weights,
  ) {
    final weighted = <String, Map<String, double>>{};

    for (final altId in normalized.keys) {
      weighted[altId] = {};

      for (final critId in normalized[altId]!.keys) {
        final normValue = normalized[altId]![critId]!;
        final weight = weights[critId] ?? 0.0;
        final weightFraction = weight / 100.0;
        final weightedValue = (normValue * weightFraction).clampToDecimal(4);

        weighted[altId]![critId] = weightedValue;
      }
    }

    return weighted;
  }

  /// Step 3: Sum weighted scores per alternative
  /// Scale to 0-100 range for display
  static Map<String, double> _sumScores(
    Map<String, Map<String, double>> weighted,
  ) {
    final scores = <String, double>{};

    for (final altId in weighted.keys) {
      final sum = weighted[altId]!.values.fold(0.0, (a, b) => a + b);
      // Scale to 0-100 and round to 2 decimal places
      final scaled = (sum * 100).clampToDecimal(2);
      scores[altId] = scaled;
    }

    return scores;
  }

  /// Step 4: Rank alternatives by composite score (highest first)
  static List<RankedAlternative> _rankAlternatives(
    Map<String, double> scores,
    List<Alternative> alternatives,
  ) {
    // Create list of alternatives with scores
    final withScores = <(Alternative, double)>[];
    for (final alt in alternatives) {
      final score = scores[alt.id] ?? 0.0;
      withScores.add((alt, score));
    }

    // Sort by score descending
    withScores.sort((a, b) => b.$2.compareTo(a.$2));

    // Create ranked list
    final ranking = <RankedAlternative>[];
    for (int i = 0; i < withScores.length; i++) {
      ranking.add(
        RankedAlternative(
          rank: i + 1,
          alternative: withScores[i].$1,
          compositeScore: withScores[i].$2,
        ),
      );
    }

    return ranking;
  }

  /// Step 5: Build detailed breakdown for each alternative
  static Map<String, CalculationBreakdown> _buildBreakdown(
    Map<String, Map<String, double>> normalized,
    Map<String, Map<String, double>> weighted,
    Map<String, double> scores,
    Map<String, Criterion> criteriaMap,
    Map<String, double> weights,
  ) {
    final breakdown = <String, CalculationBreakdown>{};

    for (final altId in normalized.keys) {
      final criteria = <String, NormalizedScore>{};

      for (final critId in normalized[altId]!.keys) {
        final norm = normalized[altId]![critId]!;
        final weight = (weights[critId] ?? 0.0) / 100.0;
        final w = weighted[altId]![critId]!;

        criteria[critId] = NormalizedScore(
          normalized: norm,
          weight: weight,
          weighted: w,
        );
      }

      breakdown[altId] = CalculationBreakdown(
        alternativeId: altId,
        criteria: criteria,
        compositeScore: scores[altId] ?? 0.0,
      );
    }

    return breakdown;
  }
}

/// Power function helper
double pow(double base, int exponent) {
  double result = 1.0;
  for (int i = 0; i < exponent; i++) {
    result *= base;
  }
  return result;
}
