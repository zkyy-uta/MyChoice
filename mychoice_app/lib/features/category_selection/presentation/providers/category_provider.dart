import 'package:flutter/foundation.dart' hide Category;
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

/// Category provider for state management
class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _repository;

  // State properties
  List<Category> _categories = [];
  Category? _selectedCategory;
  Subcategory? _selectedSubcategory;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Category> get categories => _categories;
  Category? get selectedCategory => _selectedCategory;
  Subcategory? get selectedSubcategory => _selectedSubcategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  CategoryProvider({required CategoryRepository repository})
    : _repository = repository;

  /// Load all categories
  Future<void> loadCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await _repository.getCategories();
      _isLoading = false;
      _error = null;
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to load categories: $e';
    }

    notifyListeners();
  }

  /// Select a category
  void selectCategory(Category category) {
    _selectedCategory = category;
    _selectedSubcategory = null; // Reset subcategory when category changes
    notifyListeners();
  }

  /// Select a subcategory
  void selectSubcategory(Subcategory subcategory) {
    _selectedSubcategory = subcategory;
    notifyListeners();
  }

  /// Clear selections
  void clearSelections() {
    _selectedCategory = null;
    _selectedSubcategory = null;
    notifyListeners();
  }

  /// Check if both category and subcategory are selected
  bool get isSelectionComplete =>
      _selectedCategory != null && _selectedSubcategory != null;
}
