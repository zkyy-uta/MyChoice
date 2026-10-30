import 'package:mychoice_app/features/decision_engine/domain/entities/decision_matrix.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/decision_result.dart';
import 'package:mychoice_app/features/decision_engine/domain/repositories/decision_engine_repository.dart';
import 'package:mychoice_app/features/decision_engine/data/datasources/saw_calculator.dart';
import 'package:mychoice_app/features/criteria_selection/domain/entities/criterion.dart';
import 'package:mychoice_app/core/errors/app_exception.dart';

/// Implementation of DecisionEngineRepository using SAWCalculator
class DecisionEngineRepositoryImpl implements DecisionEngineRepository {
  @override
  Future<DecisionResult> calculate({
    required DecisionMatrix matrix,
    required Map<String, double> weights,
    required Map<String, Criterion> criteriaMap,
  }) async {
    try {
      // Direct call to SAWCalculator (pure function, no async needed but keeping Future for interface)
      final result = SAWCalculator.calculate(
        matrix: matrix,
        criteriaMap: criteriaMap,
        weights: weights,
      );
      return result;
    } on ArgumentError catch (e) {
      throw ValidationError(
        message: e.message ?? 'Invalid input for calculation',
      );
    } catch (e) {
      throw CalculationError(message: 'Calculation failed', originalError: e);
    }
  }
}
