import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mychoice_app/features/alternative_management/domain/entities/alternative.dart';
import 'package:mychoice_app/features/alternative_management/presentation/providers/alternative_provider.dart';
import 'package:mychoice_app/screens/user/decision/alternative_management_screen.dart';
import 'package:mychoice_app/features/alternative_management/data/repositories/alternative_repository_impl.dart';
import 'package:mychoice_app/features/alternative_management/domain/usecases/add_alternative_usecase.dart';
import 'package:mychoice_app/features/alternative_management/data/datasources/alternative_datasource.dart';
import 'package:mychoice_app/features/auth/presentation/providers/user_provider.dart';
import 'package:mychoice_app/core/theme/app_theme.dart';

void main() {
  group('AlternativeManagementScreen Widget Tests', () {
    late AlternativeProvider alternativeProvider;
    late UserProvider userProvider;

    setUp(() {
      // Create mock repository
      final repository = AlternativeRepositoryImpl(
        dataSource: MockAlternativeDataSource(),
      );
      final useCase = AddAlternativeUseCase(repository: repository);

      alternativeProvider = AlternativeProvider(
        repository: repository,
        addAlternativeUseCase: useCase,
      );
      userProvider = UserProvider();
    });

    testWidgets('should display mode toggle (Catalog and Custom)', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<AlternativeProvider>.value(
                value: alternativeProvider,
              ),
              ChangeNotifierProvider<UserProvider>.value(value: userProvider),
            ],
            child: const AlternativeManagementScreen(),
          ),
        ),
      );

      // Assert
      expect(find.text('Catalog'), findsOneWidget);
      expect(find.text('Custom'), findsOneWidget);
    });

    testWidgets('should start in Catalog mode', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<AlternativeProvider>.value(
                value: alternativeProvider,
              ),
              ChangeNotifierProvider<UserProvider>.value(value: userProvider),
            ],
            child: const AlternativeManagementScreen(),
          ),
        ),
      );

      // Assert
      expect(alternativeProvider.catalogMode, true);
    });

    testWidgets('should toggle between Catalog and Custom mode', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<AlternativeProvider>.value(
                value: alternativeProvider,
              ),
              ChangeNotifierProvider<UserProvider>.value(value: userProvider),
            ],
            child: const AlternativeManagementScreen(),
          ),
        ),
      );

      expect(alternativeProvider.catalogMode, true);

      // Act - tap Custom button
      final customButton = find.text('Custom');
      await tester.tap(customButton);
      await tester.pumpAndSettle();

      // Assert
      expect(alternativeProvider.catalogMode, false);

      // Act - tap Catalog button
      final catalogButton = find.text('Catalog');
      await tester.tap(catalogButton);
      await tester.pumpAndSettle();

      // Assert
      expect(alternativeProvider.catalogMode, true);
    });

    testWidgets('should display count badge', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<AlternativeProvider>.value(
                value: alternativeProvider,
              ),
              ChangeNotifierProvider<UserProvider>.value(value: userProvider),
            ],
            child: const AlternativeManagementScreen(),
          ),
        ),
      );

      // Assert
      expect(find.text('Options Compared: 0'), findsOneWidget);
    });

    testWidgets('should update count when alternative added', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<AlternativeProvider>.value(
                value: alternativeProvider,
              ),
              ChangeNotifierProvider<UserProvider>.value(value: userProvider),
            ],
            child: const AlternativeManagementScreen(),
          ),
        ),
      );

      // Act - add alternative via provider
      final alt = Alternative(
        id: 'alt1',
        name: 'Test Alternative',
        source: 'custom',
      );
      alternativeProvider.addAlternativeWithoutQuotaCheck(alt);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Options Compared: 1'), findsOneWidget);
    });

    testWidgets(
      'should display Next button disabled when no alternatives selected',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider<AlternativeProvider>.value(
                  value: alternativeProvider,
                ),
                ChangeNotifierProvider<UserProvider>.value(value: userProvider),
              ],
              child: const AlternativeManagementScreen(),
            ),
          ),
        );

        // Assert
        final nextButton = find.byType(ElevatedButton);
        expect(nextButton, findsWidgets);
        // Check if first ElevatedButton is disabled
        final buttonWidget = tester.widget<ElevatedButton>(nextButton.first);
        expect(buttonWidget.onPressed, isNull);
      },
    );

    testWidgets('should enable Next button when alternatives selected', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<AlternativeProvider>.value(
                value: alternativeProvider,
              ),
              ChangeNotifierProvider<UserProvider>.value(value: userProvider),
            ],
            child: const AlternativeManagementScreen(),
          ),
        ),
      );

      // Act - add at least 2 alternatives
      alternativeProvider.addAlternativeWithoutQuotaCheck(
        Alternative(id: 'alt1', name: 'Alt 1', source: 'custom'),
      );
      alternativeProvider.addAlternativeWithoutQuotaCheck(
        Alternative(id: 'alt2', name: 'Alt 2', source: 'custom'),
      );
      await tester.pumpAndSettle();

      // Assert
      final nextButton = find.byType(ElevatedButton);
      final buttonWidget = tester.widget<ElevatedButton>(nextButton.first);
      expect(buttonWidget.onPressed, isNotNull);
    });

    testWidgets('should allow deleting alternatives', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<AlternativeProvider>.value(
                value: alternativeProvider,
              ),
              ChangeNotifierProvider<UserProvider>.value(value: userProvider),
            ],
            child: const AlternativeManagementScreen(),
          ),
        ),
      );

      // Act - add alternatives
      alternativeProvider.addAlternativeWithoutQuotaCheck(
        Alternative(id: 'alt1', name: 'Alt 1', source: 'custom'),
      );
      alternativeProvider.addAlternativeWithoutQuotaCheck(
        Alternative(id: 'alt2', name: 'Alt 2', source: 'custom'),
      );
      await tester.pumpAndSettle();

      expect(alternativeProvider.alternativeCount, 2);

      // Act - delete an alternative
      alternativeProvider.removeAlternative('alt1');
      await tester.pumpAndSettle();

      // Assert
      expect(alternativeProvider.alternativeCount, 1);
      expect(find.text('Options Compared: 1'), findsOneWidget);
    });

    testWidgets('should have Back button', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<AlternativeProvider>.value(
                value: alternativeProvider,
              ),
              ChangeNotifierProvider<UserProvider>.value(value: userProvider),
            ],
            child: const AlternativeManagementScreen(),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets(
      'should display Selected Options section when alternatives added',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider<AlternativeProvider>.value(
                  value: alternativeProvider,
                ),
                ChangeNotifierProvider<UserProvider>.value(value: userProvider),
              ],
              child: const AlternativeManagementScreen(),
            ),
          ),
        );

        // Act - add alternative
        alternativeProvider.addAlternativeWithoutQuotaCheck(
          Alternative(id: 'alt1', name: 'Test Alternative', source: 'custom'),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Selected Options'), findsOneWidget);
      },
    );
  });
}
