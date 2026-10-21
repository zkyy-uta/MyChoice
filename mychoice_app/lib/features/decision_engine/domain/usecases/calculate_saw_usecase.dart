import 'package:mychoice_app/features/decision_engine/domain/entities/decision_matrix.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/decision_result.dart';
import 'package:mychoice_app/features/decision_engine/domain/repositories/decision_engine_repository.dart';
import 'package:mychoice_app/features/criteria_selection/domain/entities/criterion.dart';

/// Use case for orchestrating SAW calculation
class CalculateSAWUseCase {
  final DecisionEngineRepository _repository;

  CalculateSAWUseCase({required DecisionEngineRepository repository})
    : _repository = repository;

  /// Calculate SAW result for the given decision parameters
  ///
  /// Parameters:
  /// - matrix: Decision matrix with alternatives, criteria, and raw values
  /// - weights: Map of criterion ID to weight percentage (0-100)
  /// - criteriaMap: Map of criterion ID to Criterion entity
  ///
  /// Returns: DecisionResult with ranking and detailed breakdown
  ///
  /// Throws: AppException if calculation fails
  Future<DecisionResult> call({
    required DecisionMatrix matrix,
    required Map<String, double> weights,
    required Map<String, Criterion> criteriaMap,
  }) async {
    return _repository.calculate(
      matrix: matrix,
      weights: weights,
      criteriaMap: criteriaMap,
    );
  }
}
