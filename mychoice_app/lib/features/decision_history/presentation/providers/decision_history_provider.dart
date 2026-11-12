import 'package:flutter/foundation.dart';

import '../../domain/entities/decision_history.dart';
import '../../domain/repositories/decision_history_repository.dart';

/// Provider untuk mengelola state riwayat keputusan dan ulasan/bintang rating.
class DecisionHistoryProvider extends ChangeNotifier {
  DecisionHistoryProvider({required DecisionHistoryRepository repository})
      : _repository = repository;

  final DecisionHistoryRepository _repository;

  List<DecisionHistory> _histories = [];
  bool _isLoading = false;
  String? _error;

  List<DecisionHistory> get histories => _histories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  /// Muat daftar riwayat keputusan dari backend.
  Future<void> loadHistories() async {
    _setLoading(true);
    _setError(null);
    try {
      _histories = await _repository.getDecisionHistories();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Simpan riwayat keputusan baru dan tambahkan ke daftar lokal.
  Future<DecisionHistory?> addHistory({
    required String category,
    String? subcategory,
    required String title,
    required double score,
    String? finalOption,
    DateTime? decisionDate,
    Map<String, dynamic>? priorities,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final created = await _repository.createDecisionHistory(
        category: category,
        subcategory: subcategory,
        title: title,
        score: score,
        finalOption: finalOption,
        decisionDate: decisionDate,
        priorities: priorities,
      );
      _histories.insert(0, created);
      notifyListeners();
      return created;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Muat satu detail riwayat keputusan berdasarkan ID.
  Future<DecisionHistory?> loadDetail(String id) async {
    _setLoading(true);
    _setError(null);
    try {
      return await _repository.getDecisionHistoryById(id);
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Simpan ulasan dan bintang rating (1-5) untuk riwayat keputusan.
  Future<bool> saveReviewAndRating({
    required String decisionHistoryId,
    required int rating,
    String? review,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      await _repository.updateReviewAndRating(
        decisionHistoryId: decisionHistoryId,
        rating: rating,
        review: review,
      );

      // Perbarui entitas lokal jika ada di daftar
      final index = _histories.indexWhere((h) => h.id == decisionHistoryId);
      if (index != -1) {
        _histories[index] = _histories[index].copyWith(
          rating: rating,
          review: review,
        );
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Hapus riwayat keputusan.
  Future<bool> deleteHistory(String id) async {
    _setLoading(true);
    _setError(null);
    try {
      await _repository.deleteDecisionHistory(id);
      _histories.removeWhere((h) => h.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
