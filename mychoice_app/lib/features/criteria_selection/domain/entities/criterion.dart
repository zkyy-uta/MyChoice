/// Criterion entity representing an evaluation criterion
class Criterion {
  final String id;
  final String name;
  final CriterionType type; // Benefit or Cost
  final String source; // 'suggested' or 'custom'

  Criterion({
    required this.id,
    required this.name,
    required this.type,
    required this.source,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Criterion &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          type == other.type &&
          source == other.source;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ type.hashCode ^ source.hashCode;

  Criterion copyWith({
    String? id,
    String? name,
    CriterionType? type,
    String? source,
  }) => Criterion(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    source: source ?? this.source,
  );
}

enum CriterionType { benefit, cost }

extension CriterionTypeString on CriterionType {
  String get displayName => this == CriterionType.benefit ? 'Benefit' : 'Cost';

  String get shortName => this == CriterionType.benefit ? 'B' : 'C';
}
