import '../entities/admin_catalog_data.dart';

abstract class AdminCatalogRepository {
  Future<AdminSubcategoryCatalog> loadSubcategory({
    required String category,
    required String subcategory,
  });

  Future<AdminCatalogCriterion> addCriterion({
    required String category,
    required String subcategory,
    required String name,
    required String type,
    required String unit,
  });

  Future<String> saveOption({
    required String category,
    required String subcategory,
    String? id,
    required String name,
    required Map<String, String> values,
    required Set<String> unavailable,
    required List<AdminCatalogCriterion> criteria,
  });

  Future<void> deleteOption({required String id});
}
