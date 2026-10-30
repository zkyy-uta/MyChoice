import 'package:mychoice_app/features/alternative_management/domain/entities/alternative.dart';
import 'package:mychoice_app/features/criteria_selection/domain/entities/criterion.dart';

/// Represents the decision matrix: alternatives × criteria with raw values
class DecisionMatrix {
  final List<Alternative> alternatives;
  final List<Criterion> criteria;
  final Map<String, Map<String, double>> values;

  DecisionMatrix({
    required this.alternatives,
    required this.criteria,
    required this.values,
  });

  /// Get value for alternative-criterion pair
  double? getValue(String altId, String critId) => values[altId]?[critId];

  /// Set value for alternative-criterion pair
  void setValue(String altId, String critId, double value) {
    values[altId] ??= {};
    values[altId]![critId] = value;
  }

  /// Check if all cells in the matrix are filled
  bool isComplete() {
    for (final alt in alternatives) {
      for (final crit in criteria) {
        if (getValue(alt.id, crit.id) == null) {
          return false;
        }
      }
    }
    return true;
  }

  /// Get all missing values as list of (altId, critId) pairs
  List<(String altId, String critId)> getMissingValues() {
    final missing = <(String altId, String critId)>[];
    for (final alt in alternatives) {
      for (final crit in criteria) {
        if (getValue(alt.id, crit.id) == null) {
          missing.add((alt.id, crit.id));
        }
      }
    }
    return missing;
  }

  /// Create a copy with updated values
  DecisionMatrix copyWith({
    List<Alternative>? alternatives,
    List<Criterion>? criteria,
    Map<String, Map<String, double>>? values,
  }) {
    return DecisionMatrix(
      alternatives: alternatives ?? this.alternatives,
      criteria: criteria ?? this.criteria,
      values: values ?? Map.from(this.values),
    );
  }
}
