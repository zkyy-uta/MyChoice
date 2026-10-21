import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_datasource.dart';

/// Implementation of CategoryRepository using MockCategoryDataSource
class CategoryRepositoryImpl implements CategoryRepository {
  final MockCategoryDataSource _dataSource;

  CategoryRepositoryImpl({required MockCategoryDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<List<Category>> getCategories() {
    return _dataSource.getCategories();
  }

  @override
  Future<List<Subcategory>> getSubcategories(String categoryId) {
    return _dataSource.getSubcategories(categoryId);
  }

  @override
  Future<Category?> getCategoryById(String categoryId) {
    return _dataSource.getCategoryById(categoryId);
  }
}
