import 'package:flutter/foundation.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/decision_result.dart';
import 'package:mychoice_app/features/criteria_selection/domain/entities/criterion.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/decision_matrix.dart';

/// Flattened view of comparison data consumed by [ComparisonScreen].
class ComparisonView {
  final List<String> alternativeNames;
  final List<String> alternativeIds;
  final List<String> criteriaNames;
  final List<String> criteriaIds;

  /// altId → critId → raw value
  final Map<String, Map<String, double>> rawValues;

  /// altId → critId → normalized value
  final Map<String, Map<String, double>> normalizedValues;

  /// altId → composite score
  final Map<String, double> scores;

  /// altId → rank
  final Map<String, int> ranks;

  ComparisonView({
    required this.alternativeNames,
    required this.alternativeIds,
    required this.criteriaNames,
    required this.criteriaIds,
    required this.rawValues,
    required this.normalizedValues,
    required this.scores,
    required this.ranks,
  });

  /// Return the alternative ID with the best raw value for [critId].
  String? getBestAltForCriterion(String critId, CriterionType type) {
    double? bestVal;
    String? bestAltId;

    for (final altId in alternativeIds) {
      final val = rawValues[altId]?[critId];
      if (val == null) continue;
      if (bestVal == null) {
        bestVal = val;
        bestAltId = altId;
      } else {
        final isBetter =
            type == CriterionType.benefit ? val > bestVal : val < bestVal;
        if (isBetter) {
          bestVal = val;
          bestAltId = altId;
        }
      }
    }
    return bestAltId;
  }
}

/// Provider that builds a [ComparisonView] from a [DecisionResult] and its
/// supporting data, ready for the comparison table UI.
class ComparisonProvider extends ChangeNotifier {
  ComparisonView? _view;
  ComparisonView? get view => _view;

  /// Build the comparison view from calculation results.
  void buildComparisonView(
    DecisionResult result,
    DecisionMatrix matrix,
    Map<String, Criterion> criteriaMap,
  ) {
    // Collect normalized values from the breakdown stored in the result
    final normalizedValues = <String, Map<String, double>>{};
    for (final ranked in result.ranking) {
      final altId = ranked.alternative.id;
      final breakdown = result.getBreakdownForAlternative(altId);
      if (breakdown != null) {
        normalizedValues[altId] = {};
        for (final entry in breakdown.criteria.entries) {
          normalizedValues[altId]![entry.key] = entry.value.normalized;
        }
      }
    }

    _view = ComparisonView(
      alternativeNames:
          result.ranking.map((r) => r.alternative.name).toList(),
      alternativeIds: result.ranking.map((r) => r.alternative.id).toList(),
      criteriaNames: matrix.criteria.map((c) => c.name).toList(),
      criteriaIds: matrix.criteria.map((c) => c.id).toList(),
      rawValues: matrix.values,
      normalizedValues: normalizedValues,
      scores: {for (final r in result.ranking) r.alternative.id: r.compositeScore},
      ranks: {for (final r in result.ranking) r.alternative.id: r.rank},
    );
    notifyListeners();
  }
}

