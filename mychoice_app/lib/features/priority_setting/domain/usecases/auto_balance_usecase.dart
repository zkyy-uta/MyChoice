/// Use case for auto-balancing weights to sum to 100%
class AutoBalanceUseCase {
  /// Proportionally rescale weights to sum to 100%
  /// Preserves proportions: if weight[A] = 2x * weight[B] before,
  /// it will be 2x * weight[B] after
  ///
  /// Returns new weights map with sum = 100%
  Map<String, double> call(Map<String, double> weights) {
    if (weights.isEmpty) return {};

    // Filter out zero and negative weights for calculation
    final validWeights = Map<String, double>.from(weights)
      ..removeWhere((_, value) => value <= 0);

    if (validWeights.isEmpty) {
      // All weights were zero or negative, distribute equally
      final count = weights.length;
      final equalWeight = 100.0 / count;
      return Map.fromIterable(weights.keys, value: (_) => equalWeight);
    }

    // Calculate sum of valid weights
    final currentSum = validWeights.values.fold(
      0.0,
      (prev, elem) => prev + elem,
    );

    // If sum is already 100, return as-is
    if ((currentSum - 100.0).abs() < 0.001) {
      return Map<String, double>.from(weights);
    }

    // Calculate scaling factor
    final scaleFactor = 100.0 / currentSum;

    // Apply scaling to all weights
    final result = <String, double>{};
    weights.forEach((key, value) {
      result[key] = (value * scaleFactor);
    });

    return result;
  }

  /// Check if weights need balancing (sum != 100%)
  bool needsBalancing(Map<String, double> weights) {
    if (weights.isEmpty) return false;

    final sum = weights.values.fold(0.0, (prev, elem) => prev + elem);
    return (sum - 100.0).abs() > 0.001;
  }

  /// Get the percentage of total for a weight
  double getPercentage(double weight, Map<String, double> allWeights) {
    final sum = allWeights.values.fold(0.0, (prev, elem) => prev + elem);
    if (sum == 0) return 0;
    return (weight / sum) * 100.0;
  }
}
