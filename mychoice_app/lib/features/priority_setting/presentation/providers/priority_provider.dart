import 'package:flutter/foundation.dart';
import '../../domain/usecases/auto_balance_usecase.dart';
import '../../domain/usecases/validate_weights_usecase.dart';

/// Manages priority/weight state for criteria
class PriorityProvider extends ChangeNotifier {
  final AutoBalanceUseCase autoBalanceUseCase;
  final ValidateWeightsUseCase validateWeightsUseCase;

  Map<String, double> _weights = {};

  PriorityProvider({
    required this.autoBalanceUseCase,
    required this.validateWeightsUseCase,
  });

  // Getters
  Map<String, double> get weights => Map.unmodifiable(_weights);
  double get totalWeight => getWeightSum();

  /// Initialize with criteria IDs
  void initialize(List<String> criteriaIds) {
    _weights = {};
    for (final id in criteriaIds) {
      _weights[id] = 0.0;
    }
    notifyListeners();
  }

  /// Set weight for a criterion
  void setWeight(String criterionId, double weight) {
    if (weight < 0 || weight > 100) {
      throw ArgumentError('Weight must be between 0 and 100');
    }

    _weights[criterionId] = weight;
    notifyListeners();
  }

  /// Get weight for a criterion
  double getWeight(String criterionId) {
    return _weights[criterionId] ?? 0.0;
  }

  /// Get the sum of all weights
  double getWeightSum() {
    return _weights.values.fold(0.0, (prev, elem) => prev + elem);
  }

  /// Auto-balance weights to sum to 100%
  void autoBalance() {
    _weights = autoBalanceUseCase(_weights);
    notifyListeners();
  }

  /// Check if weights are valid (sum = 100%)
  bool isWeightsValid() {
    return validateWeightsUseCase.isValid(_weights);
  }

  /// Get validation result
  ValidationResult validateWeights() {
    return ValidateWeightsUseCase().call(_weights);
  }

  /// Reset all weights to zero
  void reset() {
    _weights.forEach((key, _) {
      _weights[key] = 0.0;
    });
    notifyListeners();
  }

  /// Add criterion with initial weight of 0
  void addCriterion(String criterionId) {
    if (!_weights.containsKey(criterionId)) {
      _weights[criterionId] = 0.0;
      notifyListeners();
    }
  }

  /// Remove criterion
  void removeCriterion(String criterionId) {
    _weights.remove(criterionId);
    notifyListeners();
  }
}
