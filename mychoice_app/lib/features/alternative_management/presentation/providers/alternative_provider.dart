import 'package:flutter/foundation.dart';
import '../../domain/entities/alternative.dart';
import '../../domain/repositories/alternative_repository.dart';
import '../../domain/usecases/add_alternative_usecase.dart';
import '../../../../core/entities/user_plan.dart';
import '../../../../core/errors/app_exception.dart';

/// Alternative provider for state management
class AlternativeProvider extends ChangeNotifier {
  final AlternativeRepository _repository;
  final AddAlternativeUseCase _addAlternativeUseCase;

  // State properties
  List<Alternative> _selectedAlternatives = [];
  List<Alternative> _catalogAlternatives = [];
  bool _catalogMode = true;
  String? _error;
  bool _isLoading = false;

  // Getters
  List<Alternative> get selectedAlternatives => _selectedAlternatives;
  List<Alternative> get catalogAlternatives => _catalogAlternatives;
  bool get catalogMode => _catalogMode;
  String? get error => _error;
  bool get isLoading => _isLoading;
  int get alternativeCount => _selectedAlternatives.length;

  AlternativeProvider({
    required AlternativeRepository repository,
    required AddAlternativeUseCase addAlternativeUseCase,
  }) : _repository = repository,
       _addAlternativeUseCase = addAlternativeUseCase;

  /// Load catalog alternatives for a subcategory
  Future<void> loadCatalogAlternatives(String subcategoryId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _catalogAlternatives = await _repository.getCatalogAlternatives(
        subcategoryId,
      );
      _isLoading = false;
      _error = null;
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to load alternatives: $e';
    }

    notifyListeners();
  }

  /// Add alternative with quota enforcement
  Future<void> addAlternative(Alternative alternative, UserPlan plan) async {
    try {
      // Check quota using use case
      await _addAlternativeUseCase.call(
        alternative,
        _selectedAlternatives.length,
        plan,
      );

      // Check if already added
      if (!_selectedAlternatives.any((alt) => alt.id == alternative.id)) {
        _selectedAlternatives.add(alternative);
        _error = null;
      }
    } on PlanLimitExceededException catch (e) {
      _error = e.message;
      rethrow;
    } catch (e) {
      _error = 'Error adding alternative: $e';
    }

    notifyListeners();
  }

  /// Remove alternative
  void removeAlternative(String alternativeId) {
    _selectedAlternatives.removeWhere((alt) => alt.id == alternativeId);
    _error = null;
    notifyListeners();
  }

  /// Toggle between catalog and custom mode
  void toggleMode() {
    _catalogMode = !_catalogMode;
    _error = null;
    notifyListeners();
  }

  /// Check if alternative is selected
  bool isAlternativeSelected(String alternativeId) {
    return _selectedAlternatives.any((alt) => alt.id == alternativeId);
  }

  /// Clear selections
  void clearSelections() {
    _selectedAlternatives.clear();
    _catalogAlternatives.clear();
    _error = null;
    _catalogMode = true;
    notifyListeners();
  }

  /// Check if selection meets minimum requirements
  bool get isSelectionValid {
    return _selectedAlternatives.length >= 2;
  }

  /// Helper method for testing - add alternative without quota check
  void addAlternativeWithoutQuotaCheck(Alternative alternative) {
    if (!_selectedAlternatives.any((alt) => alt.id == alternative.id)) {
      _selectedAlternatives.add(alternative);
      _error = null;
      notifyListeners();
    }
  }
}
