import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mychoice_app/features/decision_history/domain/entities/decision_history.dart';
import 'package:mychoice_app/features/decision_history/domain/repositories/decision_history_repository.dart';
import 'package:mychoice_app/features/decision_history/presentation/providers/decision_history_provider.dart';
import 'package:mychoice_app/screens/user/history/history_detail_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('saving a review changes the button to Edit Review', (
    WidgetTester tester,
  ) async {
    final repository = _ReviewRepository();
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => DecisionHistoryProvider(repository: repository),
        child: MaterialApp(home: HistoryDetailScreen(decision: _decision())),
      ),
    );

    expect(find.text('No rating yet'), findsOneWidget);
    expect(find.text('Save Review & Rating'), findsOneWidget);
    expect(find.text('Simpan Ulasan & Rating'), findsNothing);

    await tester.tap(find.byIcon(Icons.star_rounded).last);
    await tester.enterText(
      find.byType(TextField).last,
      'This review was helpful.',
    );
    await tester.ensureVisible(find.text('Save Review & Rating'));
    await tester.tap(find.text('Save Review & Rating'));
    await tester.pumpAndSettle();

    expect(repository.savedRating, 5);
    expect(repository.savedReview, 'This review was helpful.');
    expect(find.text('Edit Review'), findsOneWidget);
    expect(find.text('Save Review & Rating'), findsNothing);
  });

  testWidgets('an existing review opens with the Edit Review button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => DecisionHistoryProvider(repository: _ReviewRepository()),
        child: MaterialApp(
          home: HistoryDetailScreen(
            decision: _decision(rating: 4, review: 'Already saved.'),
          ),
        ),
      ),
    );

    expect(find.text('Edit Review'), findsOneWidget);
    expect(find.text('Rating: 4 stars'), findsOneWidget);
    expect(find.text('Already saved.'), findsOneWidget);
  });
}

HistoryDecision _decision({int rating = 0, String review = ''}) {
  return HistoryDecision(
    id: 'history-1',
    category: 'Technology',
    title: 'Laptop choice',
    score: 0.9,
    dateGroup: 'Today',
    date: 'November 15, 2026',
    recordedAt: DateTime(2026, 11, 15),
    rating: rating,
    review: review,
  );
}

class _ReviewRepository implements DecisionHistoryRepository {
  int? savedRating;
  String? savedReview;

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
  Future<List<DecisionHistory>> getDecisionHistories() async => [];

  @override
  Future<DecisionHistory?> getDecisionHistoryById(String id) async => null;

  @override
  Future<void> updateReviewAndRating({
    required String decisionHistoryId,
    required int rating,
    String? review,
  }) async {
    savedRating = rating;
    savedReview = review;
  }

  @override
  Future<void> deleteDecisionHistory(String id) async {}
}
