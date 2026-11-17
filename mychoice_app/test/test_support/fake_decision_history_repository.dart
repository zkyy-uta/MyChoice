import 'package:mychoice_app/features/decision_history/domain/entities/decision_history.dart';
import 'package:mychoice_app/features/decision_history/domain/repositories/decision_history_repository.dart';

class FakeDecisionHistoryRepository implements DecisionHistoryRepository {
  @override
  Future<bool> canCreateDecisionToday() async => true;

  @override
  Future<DecisionHistory> createDecisionHistory({
    required String category,
    String? subcategory,
    required String title,
    required double score,
    String? finalOption,
    DateTime? decisionDate,
    Map<String, dynamic>? priorities,
  }) => throw UnimplementedError();

  @override
  Future<void> deleteDecisionHistory(String id) async {}

  @override
  Future<DecisionHistory?> getDecisionHistoryById(String id) async => null;

  @override
  Future<List<DecisionHistory>> getDecisionHistories() async {
    final now = DateTime.now();
    return [
      for (var index = 0; index < 6; index++)
        DecisionHistory(
          id: 'history-$index',
          userId: 'test-user',
          category: index < 3
              ? 'Technology'
              : index < 5
              ? 'Education'
              : 'Fashion',
          subcategory: 'Laptop',
          title: 'Decision $index',
          score: 0.8 + index * 0.01,
          decisionDate: now,
          priorities: const {'Performance': 60.0, 'Price': 40.0},
          createdAt: now,
          updatedAt: now,
        ),
    ];
  }

  @override
  Future<void> updateReviewAndRating({
    required String decisionHistoryId,
    required int rating,
    String? review,
  }) async {}
}
