import 'package:mychoice_app/features/alternative_management/domain/entities/alternative.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/calculation_breakdown.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/saw_configuration.dart';

/// Single ranked alternative with its score
class RankedAlternative {
  final int rank;
  final Alternative alternative;
  final double compositeScore; // 0-100

  const RankedAlternative({
    required this.rank,
    required this.alternative,
    required this.compositeScore,
  });

  /// Create a copy with updated fields
  RankedAlternative copyWith({
    int? rank,
    Alternative? alternative,
    double? compositeScore,
  }) {
    return RankedAlternative(
      rank: rank ?? this.rank,
      alternative: alternative ?? this.alternative,
      compositeScore: compositeScore ?? this.compositeScore,
    );
  }

  @override
  String toString() =>
      'RankedAlternative(rank: $rank, name: ${alternative.name}, score: ${compositeScore.toStringAsFixed(2)}%)';
}

/// Complete SAW calculation result
class DecisionResult {
  final List<RankedAlternative> ranking;
  final Map<String, CalculationBreakdown> breakdown;
  final String algorithmVersion;
  final DateTime calculatedAt;
  final SAWConfiguration config;

  const DecisionResult({
    required this.ranking,
    required this.breakdown,
    required this.algorithmVersion,
    required this.calculatedAt,
    required this.config,
  });

  /// Get the top-ranked alternative
  RankedAlternative? get topAlternative =>
      ranking.isNotEmpty ? ranking.first : null;

  /// Get breakdown for a specific alternative
  CalculationBreakdown? getBreakdownForAlternative(String altId) =>
      breakdown[altId];

  /// Create a copy with updated fields
  DecisionResult copyWith({
    List<RankedAlternative>? ranking,
    Map<String, CalculationBreakdown>? breakdown,
    String? algorithmVersion,
    DateTime? calculatedAt,
    SAWConfiguration? config,
  }) {
    return DecisionResult(
      ranking: ranking ?? this.ranking,
      breakdown: breakdown ?? this.breakdown,
      algorithmVersion: algorithmVersion ?? this.algorithmVersion,
      calculatedAt: calculatedAt ?? this.calculatedAt,
      config: config ?? this.config,
    );
  }

  @override
  String toString() =>
      'DecisionResult(ranking: ${ranking.length} alternatives, topScore: ${topAlternative?.compositeScore.toStringAsFixed(2)}%)';
}
