class AdminCatalogCriterion {
  const AdminCatalogCriterion({
    required this.id,
    required this.name,
    required this.type,
    required this.unit,
    required this.attributeKey,
  });

  final int id;
  final String name;
  final String type;
  final String unit;
  final String? attributeKey;
}

class AdminCatalogOption {
  const AdminCatalogOption({
    required this.id,
    required this.name,
    required this.attributes,
    this.price,
  });

  final String id;
  final String name;
  final Map<String, dynamic> attributes;
  final double? price;
}

class AdminSubcategoryCatalog {
  const AdminSubcategoryCatalog({
    required this.criteria,
    required this.options,
  });

  final List<AdminCatalogCriterion> criteria;
  final List<AdminCatalogOption> options;
}
