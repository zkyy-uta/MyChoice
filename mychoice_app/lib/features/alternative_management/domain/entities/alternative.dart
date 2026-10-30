/// Alternative entity
class Alternative {
  final String id;
  final String name;
  final String source; // 'catalog' or 'custom'
  final String? catalogId;
  final Map<String, dynamic>? specs;

  const Alternative({
    required this.id,
    required this.name,
    required this.source,
    this.catalogId,
    this.specs,
  });

  Alternative copyWith({
    String? id,
    String? name,
    String? source,
    String? catalogId,
    Map<String, dynamic>? specs,
  }) {
    return Alternative(
      id: id ?? this.id,
      name: name ?? this.name,
      source: source ?? this.source,
      catalogId: catalogId ?? this.catalogId,
      specs: specs ?? this.specs,
    );
  }

  @override
  String toString() => 'Alternative(id: $id, name: $name, source: $source)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Alternative &&
        other.id == id &&
        other.name == name &&
        other.source == source;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ source.hashCode;
}
