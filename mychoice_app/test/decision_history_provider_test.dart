import 'package:flutter_test/flutter_test.dart';

import 'package:mychoice_app/features/decision_history/data/models/decision_history_model.dart';
import 'package:mychoice_app/features/decision_history/domain/entities/decision_history.dart';
import 'package:mychoice_app/features/decision_history/domain/repositories/decision_history_repository.dart';
import 'package:mychoice_app/features/decision_history/presentation/providers/decision_history_provider.dart';

class MockDecisionHistoryRepository implements DecisionHistoryRepository {
  final List<DecisionHistory> _histories = [];
  DecisionHistory? _detail;
  bool shouldFail = false;
  String? failureMessage;

  @override
  Future<DecisionHistory> createDecisionHistory({
    required String category,
    String? subcategory,
    required String title,
    required double score,
    String? finalOption,
    DateTime? decisionDate,
    Map<String, dynamic>? priorities,
  }) async {
    if (shouldFail) throw Exception(failureMessage ?? 'create failed');
    final now = DateTime.now();
    final entry = DecisionHistory(
      id: 'hist_${_histories.length + 1}',
      userId: 'user_1',
      category: category,
      subcategory: subcategory,
      title: title,
      score: score,
      finalOption: finalOption,
      decisionDate: decisionDate ?? now,
      priorities: priorities ?? const {},
      createdAt: now,
      updatedAt: now,
    );
    _histories.insert(0, entry);
    return entry;
  }

  @override
  Future<List<DecisionHistory>> getDecisionHistories() async {
    if (shouldFail) throw Exception(failureMessage ?? 'load failed');
    return List.unmodifiable(_histories);
  }

  @override
  Future<DecisionHistory?> getDecisionHistoryById(String id) async {
    if (shouldFail) throw Exception(failureMessage ?? 'detail failed');
    return _histories.firstWhere((h) => h.id == id, orElse: () => _detail!);
  }

  @override
  Future<void> updateReviewAndRating({
    required String decisionHistoryId,
    required int rating,
    String? review,
  }) async {
    if (shouldFail) throw Exception(failureMessage ?? 'update failed');
    if (rating < 1 || rating > 5) throw Exception('invalid rating');
    final index = _histories.indexWhere((h) => h.id == decisionHistoryId);
    if (index == -1) throw Exception('not found');
    _histories[index] = _histories[index].copyWith(rating: rating, review: review);
  }

  @override
  Future<void> deleteDecisionHistory(String id) async {
    if (shouldFail) throw Exception(failureMessage ?? 'delete failed');
    _histories.removeWhere((h) => h.id == id);
  }
}

DecisionHistory _sampleHistory({int rating = 0, String? review}) {
  return DecisionHistory(
    id: 'hist_1',
    userId: 'user_1',
    category: 'Technology',
    subcategory: 'Laptop',
    title: 'Lenovo IdeaPad Slim 5',
    score: 0.89,
    finalOption: 'Lenovo IdeaPad Slim 5',
    decisionDate: DateTime(2026, 10, 3),
    priorities: {'Price': 30, 'Performance': 35},
    createdAt: DateTime(2026, 10, 10, 8, 0),
    updatedAt: DateTime(2026, 10, 10, 8, 0),
    rating: rating,
    review: review,
  );
}

void main() {
  group('DecisionHistoryProvider', () {
    late MockDecisionHistoryRepository mockRepository;
    late DecisionHistoryProvider provider;

    setUp(() {
      mockRepository = MockDecisionHistoryRepository();
      provider = DecisionHistoryProvider(repository: mockRepository);
    });

    test('loadHistories populates histories list', () async {
      mockRepository._histories.add(_sampleHistory());

      await provider.loadHistories();

      expect(provider.histories.length, 1);
      expect(provider.histories.first.title, 'Lenovo IdeaPad Slim 5');
      expect(provider.isLoading, false);
      expect(provider.error, null);
    });

    test('loadHistories sets error on failure', () async {
      mockRepository.shouldFail = true;
      mockRepository.failureMessage = 'DB down';

      await provider.loadHistories();

      expect(provider.histories, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.error, isNotNull);
      expect(provider.error!.contains('DB down'), true);
    });

    test('addHistory inserts new history at top and returns it', () async {
      final created = await provider.addHistory(
        category: 'Fashion',
        title: 'Nike Air Max',
        score: 0.9,
        priorities: {'Price': 40, 'Style': 60},
      );

      expect(created, isNotNull);
      expect(created!.title, 'Nike Air Max');
      expect(provider.histories.length, 1);
      expect(provider.histories.first.title, 'Nike Air Max');
    });

    test('addHistory returns null on failure', () async {
      mockRepository.shouldFail = true;

      final created = await provider.addHistory(
        category: 'Tech',
        title: 'X',
        score: 0.5,
      );

      expect(created, null);
      expect(provider.error, isNotNull);
    });

    test('saveReviewAndRating updates local history', () async {
      await provider.addHistory(
        category: 'Technology',
        title: 'Lenovo IdeaPad Slim 5',
        score: 0.89,
      );

      final success = await provider.saveReviewAndRating(
        decisionHistoryId: 'hist_1',
        rating: 4,
        review: 'Great choice',
      );

      expect(success, true);
      expect(provider.histories.first.rating, 4);
      expect(provider.histories.first.review, 'Great choice');
    });

    test('saveReviewAndRating returns false on failure', () async {
      mockRepository.shouldFail = true;

      final success = await provider.saveReviewAndRating(
        decisionHistoryId: 'hist_1',
        rating: 4,
      );

      expect(success, false);
      expect(provider.error, isNotNull);
    });

    test('deleteHistory removes from list', () async {
      mockRepository._histories.add(_sampleHistory());

      final success = await provider.deleteHistory('hist_1');

      expect(success, true);
      expect(provider.histories, isEmpty);
    });

    test('clearError clears error state', () async {
      mockRepository.shouldFail = true;
      await provider.loadHistories();
      expect(provider.error, isNotNull);

      provider.clearError();
      expect(provider.error, null);
    });
  });

  group('DecisionHistoryModel integration', () {
    test('round-trip model -> entity -> model', () {
      final original = DecisionHistoryModel(
        id: 'rt_1',
        userId: 'u',
        category: 'Education',
        title: 'Course',
        score: 0.82,
        decisionDate: DateTime(2026, 9, 15),
        createdAt: DateTime(2026, 10, 1),
        updatedAt: DateTime(2026, 10, 1),
        rating: 5,
        review: 'Excellent',
      );

      final json = original.toJson();
      final fromJson = DecisionHistoryModel.fromJson(json);
      expect(fromJson.rating, original.rating);
      expect(fromJson.review, original.review);
    });
  });
}
