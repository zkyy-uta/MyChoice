import 'package:flutter/foundation.dart';
import '../../domain/entities/criterion.dart';
import '../../domain/repositories/criteria_repository.dart';
import '../../../../core/errors/app_exception.dart';

/// Manages criteria selection state and operations
class CriteriaProvider extends ChangeNotifier {
  final CriteriaRepository repository;

  List<Criterion> _selectedCriteria = [];
  List<Criterion> _suggestedCriteria = [];
  AIState _aiSuggestionsState = AIState.none;
  String? _currentPlanTier;

  CriteriaProvider({required this.repository});

  // Getters
  List<Criterion> get selectedCriteria => List.unmodifiable(_selectedCriteria);
  List<Criterion> get suggestedCriteria =>
      List.unmodifiable(_suggestedCriteria);
  AIState get aiSuggestionsState => _aiSuggestionsState;
  int get selectedCriteriaCount => _selectedCriteria.length;

  /// Initialize provider with subcategory and plan tier
  Future<void> initialize(String subcategoryId, String planTier) async {
    _currentPlanTier = planTier;
    await _loadSuggestedCriteria(subcategoryId);
  }

  /// Load suggested criteria for a subcategory
  Future<void> _loadSuggestedCriteria(String subcategoryId) async {
    try {
      _suggestedCriteria = await repository.getSuggestedCriteria(subcategoryId);
      notifyListeners();
    } catch (e) {
      _suggestedCriteria = [];
      notifyListeners();
    }
  }

  /// Select a criterion
  void selectCriterion(Criterion criterion) {
    if (!_selectedCriteria.any((c) => c.id == criterion.id)) {
      // Check plan limits
      if (_currentPlanTier != null) {
        final isValid = _checkPlanLimit(_selectedCriteria.length + 1);
        if (!isValid) {
          final maxCount = getMaxCriteriaCount();
          throw PlanLimitExceededException(
            message:
                'Criteria limit exceeded for your plan. Upgrade to Premium for more criteria.',
            limit: maxCount,
            attempted: _selectedCriteria.length + 1,
            feature: 'criteria',
          );
        }
      }

      _selectedCriteria.add(criterion);
      notifyListeners();
    }
  }

  /// Deselect a criterion
  void deselectCriterion(String criterionId) {
    _selectedCriteria.removeWhere((c) => c.id == criterionId);
    notifyListeners();
  }

  /// Add a custom criterion
  void addCustomCriterion(String name, CriterionType type) {
    // Check plan limits
    if (_currentPlanTier != null) {
      final isValid = _checkPlanLimit(_selectedCriteria.length + 1);
      if (!isValid) {
        final maxCount = getMaxCriteriaCount();
        throw PlanLimitExceededException(
          message:
              'Criteria limit exceeded for your plan. Upgrade to Premium for more criteria.',
          limit: maxCount,
          attempted: _selectedCriteria.length + 1,
          feature: 'criteria',
        );
      }
    }

    final customCriterion = Criterion(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      type: type,
      source: 'custom',
    );

    _selectedCriteria.add(customCriterion);
    notifyListeners();
  }

  /// Check if criteria count is within plan limits
  bool _checkPlanLimit(int count) {
    if (_currentPlanTier == null) return true;

    if (_currentPlanTier!.toLowerCase() == 'basic') {
      return count <= 3;
    } else if (_currentPlanTier!.toLowerCase() == 'premium') {
      return count <= 8;
    }
    return true;
  }

  /// Get max criteria count for current plan
  int getMaxCriteriaCount() {
    if (_currentPlanTier == null) return 3;

    if (_currentPlanTier!.toLowerCase() == 'premium') {
      return 8;
    }
    return 3; // Default to basic
  }

  /// Can add more criteria
  bool canAddMoreCriteria() {
    return _selectedCriteria.length < getMaxCriteriaCount();
  }

  /// Fetch AI suggestions (placeholder)
  Future<void> fetchAISuggestions() async {
    _aiSuggestionsState = AIState.loading;
    notifyListeners();

    try {
      // Simulate AI call delay
      await Future.delayed(const Duration(seconds: 1));

      // Return mock suggestions
      // In real implementation, this would call an AI service
      _aiSuggestionsState = AIState.loaded;
      notifyListeners();
    } catch (e) {
      _aiSuggestionsState = AIState.error;
      notifyListeners();
    }
  }

  /// Reset state
  void reset() {
    _selectedCriteria = [];
    _suggestedCriteria = [];
    _aiSuggestionsState = AIState.none;
    _currentPlanTier = null;
    notifyListeners();
  }
}

enum AIState { none, loading, loaded, error }
