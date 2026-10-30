/// Normalized score for a criterion: contains normalized value, weight, and weighted contribution
class NormalizedScore {
  final double normalized; // 0-1
  final double weight; // 0-1 (percentage / 100)
  final double weighted; // normalized * weight

  const NormalizedScore({
    required this.normalized,
    required this.weight,
    required this.weighted,
  });

  /// Create a copy with updated fields
  NormalizedScore copyWith({
    double? normalized,
    double? weight,
    double? weighted,
  }) {
    return NormalizedScore(
      normalized: normalized ?? this.normalized,
      weight: weight ?? this.weight,
      weighted: weighted ?? this.weighted,
    );
  }

  @override
  String toString() =>
      'NormalizedScore(normalized: ${normalized.toStringAsFixed(4)}, weight: ${weight.toStringAsFixed(4)}, weighted: ${weighted.toStringAsFixed(4)})';
}

/// Calculation breakdown for a single alternative showing all criterion contributions
class CalculationBreakdown {
  final String alternativeId;
  final Map<String, NormalizedScore> criteria;
  final double compositeScore; // 0-100, for convenience

  const CalculationBreakdown({
    required this.alternativeId,
    required this.criteria,
    required this.compositeScore,
  });

  /// Get total weighted score for this alternative (should match compositeScore)
  double getTotalScore() {
    return criteria.values.fold<double>(
          0,
          (sum, score) => sum + score.weighted,
        ) *
        100;
  }

  /// Get normalized score for a specific criterion
  NormalizedScore? getScoreForCriterion(String critId) => criteria[critId];

  /// Create a copy with updated fields
  CalculationBreakdown copyWith({
    String? alternativeId,
    Map<String, NormalizedScore>? criteria,
    double? compositeScore,
  }) {
    return CalculationBreakdown(
      alternativeId: alternativeId ?? this.alternativeId,
      criteria: criteria ?? this.criteria,
      compositeScore: compositeScore ?? this.compositeScore,
    );
  }

  @override
  String toString() =>
      'CalculationBreakdown(altId: $alternativeId, criteria: ${criteria.length}, compositeScore: ${compositeScore.toStringAsFixed(2)})';
}
