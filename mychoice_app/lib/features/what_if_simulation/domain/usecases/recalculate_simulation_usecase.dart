import 'package:mychoice_app/features/decision_engine/domain/entities/decision_matrix.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/decision_result.dart';
import 'package:mychoice_app/features/decision_engine/domain/repositories/decision_engine_repository.dart';
import 'package:mychoice_app/features/criteria_selection/domain/entities/criterion.dart';

/// Use case that re-runs the SAW calculation with a new (simulated) weight set.
/// Never mutates the original [DecisionResult]; always returns a fresh result.
class RecalculateSimulationUseCase {
  final DecisionEngineRepository _repository;

  RecalculateSimulationUseCase({required DecisionEngineRepository repository})
      : _repository = repository;

  /// [simulatedWeights] – map of criterion ID → weight value in 0-100 range.
  Future<DecisionResult> call({
    required DecisionMatrix matrix,
    required Map<String, double> simulatedWeights,
    required Map<String, Criterion> criteriaMap,
  }) async {
    return _repository.calculate(
      matrix: matrix,
      weights: simulatedWeights,
      criteriaMap: criteriaMap,
    );
  }
}

