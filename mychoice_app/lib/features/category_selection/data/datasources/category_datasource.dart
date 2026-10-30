import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/category.dart';

/// Mock category data source that loads from assets
class MockCategoryDataSource {
  /// Load all categories from assets
  Future<List<Category>> getCategories() async {
    try {
      // Load JSON from assets
      final jsonString = await rootBundle.loadString(
        'assets/data/categories.json',
      );
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final categoriesList = jsonData['categories'] as List<dynamic>;

      // Parse JSON into Category objects
      return categoriesList.map((category) {
        final categoryData = category as Map<String, dynamic>;
        final subcategoriesList =
            categoryData['subcategories'] as List<dynamic>;

        return Category(
          id: categoryData['id'] as String,
          name: categoryData['name'] as String,
          description: categoryData['description'] as String,
          icon: categoryData['icon'] as String,
          subcategories: subcategoriesList.map((subcategory) {
            final subData = subcategory as Map<String, dynamic>;
            return Subcategory(
              id: subData['id'] as String,
              name: subData['name'] as String,
              description: subData['description'] as String,
            );
          }).toList(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  /// Get subcategories for a specific category
  Future<List<Subcategory>> getSubcategories(String categoryId) async {
    try {
      final categories = await getCategories();
      final category = categories.firstWhere(
        (cat) => cat.id == categoryId,
        orElse: () => throw Exception('Category not found: $categoryId'),
      );
      return category.subcategories;
    } catch (e) {
      throw Exception('Failed to load subcategories: $e');
    }
  }

  /// Get a specific category by ID
  Future<Category?> getCategoryById(String categoryId) async {
    try {
      final categories = await getCategories();
      return categories.firstWhereOrNull((cat) => cat.id == categoryId);
    } catch (e) {
      throw Exception('Failed to load category: $e');
    }
  }
}

extension FirstWhereOrNull<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }
}
