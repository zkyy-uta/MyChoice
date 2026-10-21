import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/decision_matrix.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/decision_result.dart';
import 'package:mychoice_app/features/criteria_selection/domain/entities/criterion.dart';
import 'package:mychoice_app/features/priority_setting/domain/usecases/auto_balance_usecase.dart';
import 'package:mychoice_app/features/what_if_simulation/domain/usecases/recalculate_simulation_usecase.dart';

/// Provider managing What-If simulation state.
/// Keeps an immutable snapshot of the original result/weights and lets the
/// user adjust weights independently, triggering debounced recalculations.
class SimulationProvider extends ChangeNotifier {
  final RecalculateSimulationUseCase _recalculateUseCase;
  final AutoBalanceUseCase _autoBalanceUseCase;

  // ── Original (read-only) state ────────────────────────────────────────────
  DecisionResult? _originalResult;
  Map<String, double> _originalWeights = {};
  DecisionMatrix? _originalMatrix;
  Map<String, Criterion> _criteriaMap = {};

  // ── Simulation state ───────────────────────────────────────────────────────
  Map<String, double> _simulatedWeights = {};
  DecisionResult? _simulatedResult;
  bool _isCalculating = false;

  /// altId → rank delta (positive = improved, negative = worsened)
  Map<String, int> _rankChanges = {};

  // ── Debounce timer ─────────────────────────────────────────────────────────
  Timer? _debounceTimer;

  SimulationProvider({
    required RecalculateSimulationUseCase recalculateUseCase,
    required AutoBalanceUseCase autoBalanceUseCase,
  })  : _recalculateUseCase = recalculateUseCase,
        _autoBalanceUseCase = autoBalanceUseCase;

  // ── Getters ────────────────────────────────────────────────────────────────
  DecisionResult? get originalResult => _originalResult;
  Map<String, double> get originalWeights => Map.unmodifiable(_originalWeights);
  Map<String, double> get simulatedWeights =>
      Map.unmodifiable(_simulatedWeights);
  DecisionResult? get simulatedResult => _simulatedResult;
  bool get isCalculating => _isCalculating;
  Map<String, int> get rankChanges => Map.unmodifiable(_rankChanges);

  double get totalSimulatedWeight =>
      _simulatedWeights.values.fold(0.0, (sum, w) => sum + w);

  // ── Initialisation ─────────────────────────────────────────────────────────

  /// Set up the provider with the original decision data.
  /// Call this before navigating to the What-If screen.
  void initialize({
    required DecisionResult originalResult,
    required DecisionMatrix matrix,
    required Map<String, Criterion> criteriaMap,
    required Map<String, double> originalWeights,
  }) {
    _originalResult = originalResult;
    _originalMatrix = matrix;
    _criteriaMap = criteriaMap;
    // Deep-copy so mutations never touch the originals
    _originalWeights = Map<String, double>.from(originalWeights);
    _simulatedWeights = Map<String, double>.from(originalWeights);
    _simulatedResult = null;
    _rankChanges = {};
    _isCalculating = false;
    _debounceTimer?.cancel();
    notifyListeners();
  }

  // ── Weight adjustment ──────────────────────────────────────────────────────

  /// Update a single criterion weight and schedule a debounced recalculation.
  void adjustWeight(String critId, double newValue) {
    _simulatedWeights[critId] = newValue;
    notifyListeners();
    _scheduleRecalculation();
  }

  /// Auto-balance all simulated weights so they sum to 100%.
  void autoBalance() {
    _simulatedWeights = _autoBalanceUseCase(_simulatedWeights);
    notifyListeners();
    _scheduleRecalculation();
  }

  /// Restore simulated weights to the original values.
  void resetToOriginal() {
    _simulatedWeights = Map<String, double>.from(_originalWeights);
    _simulatedResult = null;
    _rankChanges = {};
    _debounceTimer?.cancel();
    notifyListeners();
  }

  /// Sum of all simulated weights (convenience alias kept for consumers).
  double getWeightSum() => totalSimulatedWeight;

  // ── Recalculation ──────────────────────────────────────────────────────────

  void _scheduleRecalculation() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), recalculate);
  }

  /// Trigger recalculation immediately (bypasses debounce).
  Future<void> recalculate() async {
    if (_originalMatrix == null || _originalResult == null) return;

    _isCalculating = true;
    notifyListeners();

    try {
      final result = await _recalculateUseCase(
        matrix: _originalMatrix!,
        simulatedWeights: Map<String, double>.from(_simulatedWeights),
        criteriaMap: _criteriaMap,
      );

      _simulatedResult = result;
      _rankChanges = _computeRankChanges(result);
    } catch (_) {
      // Silently ignore simulation errors – original result is still shown
    } finally {
      _isCalculating = false;
      notifyListeners();
    }
  }

  /// Compare original vs simulated ranking positions.
  /// Positive delta means the alternative improved (moved up).
  Map<String, int> _computeRankChanges(DecisionResult simulated) {
    final changes = <String, int>{};
    final originalRanks = {
      for (final r in _originalResult!.ranking) r.alternative.id: r.rank,
    };
    for (final r in simulated.ranking) {
      final altId = r.alternative.id;
      final origRank = originalRanks[altId];
      if (origRank != null) {
        // Smaller rank number = better position, so improvement = orig - new
        changes[altId] = origRank - r.rank;
      }
    }
    return changes;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

