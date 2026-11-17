import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mychoice_app/core/errors/app_exception.dart';
import 'package:mychoice_app/features/decision_history/domain/entities/decision_history.dart';
import 'package:mychoice_app/features/decision_history/domain/repositories/decision_history_repository.dart';
import 'package:mychoice_app/features/decision_history/presentation/providers/decision_history_provider.dart';
import 'package:mychoice_app/screens/user/decision/create_decision_screen.dart';
import 'package:mychoice_app/screens/user/decision/result_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('shows the Premium prompt when a Basic daily limit is reached', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) =>
            DecisionHistoryProvider(repository: _DailyLimitRepository()),
        child: MaterialApp(
          home: const ResultScreen(),
          routes: {
            '/profile/premium-plan': (_) =>
                const Scaffold(body: Text('Premium plan')),
          },
        ),
      ),
    );
    await tester.pump();

    final saveButton = find.text('Save Decision');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Daily Basic decision limit reached'), findsOneWidget);
    expect(
      find.textContaining('one successfully saved decision'),
      findsOneWidget,
    );

    await tester.tap(find.text('View Premium'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Premium plan'), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('lets a Basic user return to the dashboard from the prompt', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) =>
            DecisionHistoryProvider(repository: _DailyLimitRepository()),
        child: MaterialApp(
          home: const ResultScreen(),
          routes: {
            '/dashboard': (_) => const Scaffold(body: Text('Dashboard')),
          },
        ),
      ),
    );
    await tester.pump();

    final saveButton = find.text('Save Decision');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('Back to Dashboard'));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsOneWidget);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets(
    'shows the limit prompt before a Basic user calculates a decision',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) =>
              DecisionHistoryProvider(repository: _DailyLimitRepository()),
          child: MaterialApp(
            home: const CreateDecisionScreen(
              initialCategory: 'Technology',
              initialSubcategory: 'Laptop',
              initialOptions: ['Option 1', 'Option 2'],
            ),
            routes: {
              '/profile/premium-plan': (_) =>
                  const Scaffold(body: Text('Premium plan')),
              '/dashboard': (_) => const Scaffold(body: Text('Dashboard')),
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final button = find.text('Make a Decision');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text('Daily Basic decision limit reached'), findsOneWidget);
      expect(find.text('Almost done! 🎉'), findsNothing);
      await tester.binding.setSurfaceSize(null);
    },
  );
}

class _DailyLimitRepository implements DecisionHistoryRepository {
  @override
  Future<bool> canCreateDecisionToday() async => false;

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
    throw PlanLimitExceededException(
      message: 'Daily decision limit reached.',
      feature: 'daily_decisions',
      limit: 1,
      attempted: 2,
      code: 'BASIC_DAILY_DECISION_LIMIT',
    );
  }

  @override
  Future<void> deleteDecisionHistory(String id) async {}

  @override
  Future<DecisionHistory?> getDecisionHistoryById(String id) async => null;

  @override
  Future<List<DecisionHistory>> getDecisionHistories() async => [];

  @override
  Future<void> updateReviewAndRating({
    required String decisionHistoryId,
    required int rating,
    String? review,
  }) async {}
}
