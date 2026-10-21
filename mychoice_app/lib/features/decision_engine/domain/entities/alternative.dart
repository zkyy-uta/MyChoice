/// Alternative entity
class Alternative {
  final String id;
  final String name;
  final String source; // 'catalog' or 'custom'
  final String? catalogId;
  final String? brand;
  final String? specs; // JSON string of specs

  const Alternative({
    required this.id,
    required this.name,
    required this.source,
    this.catalogId,
    this.brand,
    this.specs,
  });

  Alternative copyWith({
    String? id,
    String? name,
    String? source,
    String? catalogId,
    String? brand,
    String? specs,
  }) {
    return Alternative(
      id: id ?? this.id,
      name: name ?? this.name,
      source: source ?? this.source,
      catalogId: catalogId ?? this.catalogId,
      brand: brand ?? this.brand,
      specs: specs ?? this.specs,
    );
  }

  @override
  String toString() => 'Alternative(id: $id, name: $name, source: $source)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Alternative && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
