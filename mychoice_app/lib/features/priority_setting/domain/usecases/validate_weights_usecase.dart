/// Result of weight validation
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  ValidationResult({required this.isValid, this.errorMessage});

  factory ValidationResult.success() =>
      ValidationResult(isValid: true, errorMessage: null);

  factory ValidationResult.error(String message) =>
      ValidationResult(isValid: false, errorMessage: message);
}

/// Use case for validating that weights sum to 100%
class ValidateWeightsUseCase {
  static const double _tolerance = 0.001; // ±0.001 tolerance

  /// Validate that weights sum to 100% (±tolerance)
  /// Returns ValidationResult with isValid and optional error message
  ValidationResult call(Map<String, double> weights) {
    if (weights.isEmpty) {
      return ValidationResult.error('No weights provided');
    }

    final sum = weights.values.fold(0.0, (prev, elem) => prev + elem);
    final targetSum = 100.0;

    // Check if sum is within tolerance of 100%
    if ((sum - targetSum).abs() <= _tolerance) {
      return ValidationResult.success();
    }

    return ValidationResult.error(
      'Weights must sum to 100% (currently ${sum.toStringAsFixed(1)}%)',
    );
  }

  /// Check if weights are valid without returning error message
  bool isValid(Map<String, double> weights) {
    if (weights.isEmpty) return false;

    final sum = weights.values.fold(0.0, (prev, elem) => prev + elem);
    return (sum - 100.0).abs() <= _tolerance;
  }

  /// Get the current sum of weights
  double getWeightSum(Map<String, double> weights) {
    return weights.values.fold(0.0, (prev, elem) => prev + elem);
  }
}
