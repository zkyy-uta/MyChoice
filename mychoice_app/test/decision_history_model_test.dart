import 'package:flutter_test/flutter_test.dart';

import 'package:mychoice_app/features/decision_history/data/models/decision_history_model.dart';
import 'package:mychoice_app/features/decision_history/domain/entities/decision_history.dart';

void main() {
  group('DecisionHistoryModel JSON serialization', () {
    final json = {
      'id': 'hist_123',
      'user_id': 'user_abc',
      'category': 'Technology',
      'subcategory': 'Laptop',
      'title': 'Lenovo IdeaPad Slim 5',
      'score': 0.89,
      'final_option': 'Lenovo IdeaPad Slim 5',
      'decision_date': '2026-10-03T00:00:00Z',
      'priorities': {'Price': 30, 'Performance': 35, 'Battery': 20, 'Storage': 15},
      'created_at': '2026-10-10T08:00:00Z',
      'updated_at': '2026-10-10T08:00:00Z',
      'rating': 4,
      'review': 'Sangat puas.',
    };

    test('fromJson parses all fields correctly', () {
      final model = DecisionHistoryModel.fromJson(json);

      expect(model.id, 'hist_123');
      expect(model.userId, 'user_abc');
      expect(model.category, 'Technology');
      expect(model.subcategory, 'Laptop');
      expect(model.title, 'Lenovo IdeaPad Slim 5');
      expect(model.score, 0.89);
      expect(model.finalOption, 'Lenovo IdeaPad Slim 5');
      expect(model.priorities, {'Price': 30, 'Performance': 35, 'Battery': 20, 'Storage': 15});
      expect(model.rating, 4);
      expect(model.review, 'Sangat puas.');
    });

    test('fromJson defaults missing fields', () {
      final model = DecisionHistoryModel.fromJson({
        'id': 'x',
        'user_id': 'u',
        'category': 'Fashion',
        'title': 'Nike',
        'score': 0.5,
      });

      expect(model.subcategory, null);
      expect(model.finalOption, null);
      expect(model.priorities, isEmpty);
      expect(model.rating, 0);
      expect(model.review, null);
    });

    test('toEntity preserves all fields', () {
      final model = DecisionHistoryModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity, isA<DecisionHistory>());
      expect(entity.id, model.id);
      expect(entity.rating, model.rating);
      expect(entity.review, model.review);
      expect(entity.status, 'Rated');
    });

    test('status getter returns Rated when rating > 0', () {
      final entity = DecisionHistory(
        id: 'x',
        userId: 'u',
        category: 'Tech',
        title: 'T',
        score: 0.5,
        decisionDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rating: 3,
        review: 'ok',
      );
      expect(entity.status, 'Rated');
    });

    test('status getter returns Decision Made when rating is 0', () {
      final entity = DecisionHistory(
        id: 'x',
        userId: 'u',
        category: 'Tech',
        title: 'T',
        score: 0.5,
        decisionDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      expect(entity.status, 'Decision Made');
    });

    test('copyWith updates fields', () {
      final entity = DecisionHistory(
        id: 'x',
        userId: 'u',
        category: 'Tech',
        title: 'T',
        score: 0.5,
        decisionDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rating: 0,
      );
      final updated = entity.copyWith(rating: 5, review: 'Great!');

      expect(updated.rating, 5);
      expect(updated.review, 'Great!');
      expect(updated.id, 'x'); // unchanged
    });
  });
}
