/// Priority entity representing weight assignment to a criterion
class Priority {
  final String criterionId;
  final double weight; // 0-100

  Priority({required this.criterionId, required this.weight});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Priority &&
          runtimeType == other.runtimeType &&
          criterionId == other.criterionId &&
          weight == other.weight;

  @override
  int get hashCode => criterionId.hashCode ^ weight.hashCode;

  Priority copyWith({String? criterionId, double? weight}) => Priority(
    criterionId: criterionId ?? this.criterionId,
    weight: weight ?? this.weight,
  );
}
