import 'package:flutter/foundation.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/decision_matrix.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/decision_result.dart';
import 'package:mychoice_app/features/criteria_selection/domain/entities/criterion.dart';
import 'package:mychoice_app/features/decision_engine/domain/usecases/calculate_saw_usecase.dart';
import 'package:mychoice_app/core/errors/app_exception.dart';

/// State enum for calculation progress
enum CalculationState { idle, loading, loaded, error }

/// Provider managing SAW calculation state
class ResultProvider extends ChangeNotifier {
  final CalculateSAWUseCase _calculateSAWUseCase;

  // State
  DecisionResult? _result;
  CalculationState _state = CalculationState.idle;
  String? _error;
  String? _errorDetails;

  // Matrix & criteria stored for What-If / Comparison downstream screens
  DecisionMatrix? _matrix;
  Map<String, Criterion>? _criteriaMap;

  // Getters
  DecisionResult? get result => _result;
  CalculationState get state => _state;
  String? get error => _error;
  String? get errorDetails => _errorDetails;
  DecisionMatrix? get matrix => _matrix;
  Map<String, Criterion>? get criteriaMap => _criteriaMap;

  bool get isLoading => _state == CalculationState.loading;
  bool get isLoaded => _state == CalculationState.loaded;
  bool get hasError => _state == CalculationState.error;

  ResultProvider({required CalculateSAWUseCase calculateSAWUseCase})
    : _calculateSAWUseCase = calculateSAWUseCase;

  /// Calculate SAW results for the given decision parameters
  Future<void> calculate({
    required DecisionMatrix matrix,
    required Map<String, double> weights,
    required Map<String, Criterion> criteriaMap,
  }) async {
    _state = CalculationState.loading;
    _error = null;
    _errorDetails = null;
    _result = null;
    notifyListeners();

    try {
      // Check if matrix is complete
      if (!matrix.isComplete()) {
        throw ValidationError(message: 'Missing values in decision matrix');
      }

      // Validate weights sum to 100%
      final weightSum = weights.values.fold<double>(0, (sum, w) => sum + w);
      if ((weightSum - 100).abs() > 0.001) {
        throw ValidationError(message: 'Weights must sum to exactly 100%');
      }

      // Call use case
      _result = await _calculateSAWUseCase.call(
        matrix: matrix,
        weights: weights,
        criteriaMap: criteriaMap,
      );

      // Store matrix and criteria for downstream screens (What-If, Comparison)
      _matrix = matrix;
      _criteriaMap = criteriaMap;

      _state = CalculationState.loaded;
    } on ValidationError catch (e) {
      _error = e.message;
      _errorDetails = e.code;
      _state = CalculationState.error;
    } on CalculationError catch (e) {
      _error = e.message;
      _errorDetails = e.code;
      _state = CalculationState.error;
    } catch (e) {
      _error = 'An unexpected error occurred during calculation';
      _errorDetails = e.toString();
      _state = CalculationState.error;
    }

    notifyListeners();
  }

  /// Reset provider to initial state
  void reset() {
    _state = CalculationState.idle;
    _error = null;
    _errorDetails = null;
    _result = null;
    _matrix = null;
    _criteriaMap = null;
    notifyListeners();
  }
}
