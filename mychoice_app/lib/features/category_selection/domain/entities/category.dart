/// Subcategory entity
class Subcategory {
  final String id;
  final String name;
  final String description;

  const Subcategory({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  String toString() => 'Subcategory(id: $id, name: $name)';
}

/// Category entity
class Category {
  final String id;
  final String name;
  final String description;
  final String icon;
  final List<Subcategory> subcategories;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.subcategories,
  });

  @override
  String toString() =>
      'Category(id: $id, name: $name, subcategories: ${subcategories.length})';
}
