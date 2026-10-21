import '../entities/category.dart';

/// Category repository interface
abstract class CategoryRepository {
  /// Get all categories
  Future<List<Category>> getCategories();

  /// Get subcategories for a specific category
  Future<List<Subcategory>> getSubcategories(String categoryId);

  /// Get a specific category by ID
  Future<Category?> getCategoryById(String categoryId);
}
