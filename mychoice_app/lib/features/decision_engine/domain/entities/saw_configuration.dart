/// Configuration for SAW algorithm execution
class SAWConfiguration {
  final String version; // Algorithm version (e.g., '1.0')
  final double toleranceThreshold; // Floating point tolerance (e.g., 0.001)
  final DateTime timestamp; // When calculation was performed

  const SAWConfiguration({
    required this.version,
    required this.toleranceThreshold,
    required this.timestamp,
  });

  /// Create default configuration
  factory SAWConfiguration.defaultConfig() {
    return SAWConfiguration(
      version: '1.0',
      toleranceThreshold: 0.001,
      timestamp: DateTime.now(),
    );
  }

  /// Create a copy with updated fields
  SAWConfiguration copyWith({
    String? version,
    double? toleranceThreshold,
    DateTime? timestamp,
  }) {
    return SAWConfiguration(
      version: version ?? this.version,
      toleranceThreshold: toleranceThreshold ?? this.toleranceThreshold,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() =>
      'SAWConfiguration(version: $version, tolerance: $toleranceThreshold, timestamp: $timestamp)';
}
