import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/decision/create_decision_screen.dart';
import 'screens/history/history_screen.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/data/datasources/mock_auth_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/dashboard/presentation/screens/guest_home_screen.dart';
import 'features/category_selection/presentation/screens/public_catalog_screen.dart';
import 'features/category_selection/presentation/screens/catalog_item_detail_screen.dart';
import 'features/category_selection/presentation/providers/category_provider.dart';
import 'features/category_selection/data/datasources/category_datasource.dart';
import 'features/category_selection/data/repositories/category_repository_impl.dart';
import 'features/decision_engine/presentation/screens/result_screen.dart';
import 'features/decision_engine/presentation/providers/result_provider.dart';
import 'features/decision_engine/domain/usecases/calculate_saw_usecase.dart';
import 'features/decision_engine/data/repositories/decision_engine_repository_impl.dart';
import 'features/what_if_simulation/domain/usecases/recalculate_simulation_usecase.dart';
import 'features/what_if_simulation/presentation/providers/simulation_provider.dart';
import 'features/what_if_simulation/presentation/screens/what_if_screen.dart';
import 'features/comparison/presentation/providers/comparison_provider.dart';
import 'features/comparison/presentation/screens/comparison_screen.dart';
import 'features/priority_setting/domain/usecases/auto_balance_usecase.dart';

/// MyChoice App
/// Main application widget with routing and theme configuration
class MyChoiceApp extends StatelessWidget {
  const MyChoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth Provider
        Provider<MockAuthDataSource>(create: (_) => MockAuthDataSource()),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            repository: AuthRepositoryImpl(
              mockDataSource: context.read<MockAuthDataSource>(),
            ),
          ),
        ),
        // Category Provider
        Provider<MockCategoryDataSource>(
          create: (_) => MockCategoryDataSource(),
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (context) => CategoryProvider(
            repository: CategoryRepositoryImpl(
              dataSource: context.read<MockCategoryDataSource>(),
            ),
          ),
        ),
        // Decision Engine Provider
        Provider<DecisionEngineRepositoryImpl>(
          create: (_) => DecisionEngineRepositoryImpl(),
        ),
        ChangeNotifierProvider<ResultProvider>(
          create: (context) => ResultProvider(
            calculateSAWUseCase: CalculateSAWUseCase(
              repository: context.read<DecisionEngineRepositoryImpl>(),
            ),
          ),
        ),
        // Phase 7: What-If Simulation Provider
        ChangeNotifierProvider<SimulationProvider>(
          create: (context) => SimulationProvider(
            recalculateUseCase: RecalculateSimulationUseCase(
              repository: context.read<DecisionEngineRepositoryImpl>(),
            ),
            autoBalanceUseCase: AutoBalanceUseCase(),
          ),
        ),
        // Phase 7: Comparison Provider
        ChangeNotifierProvider<ComparisonProvider>(
          create: (_) => ComparisonProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'MyChoice',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,

        // Routes
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/guest-home': (context) => const GuestHomeScreen(),
          '/create-decision': (context) => const CreateDecisionScreen(),
          '/result': (context) => const ResultScreen(),
          '/history': (context) => const HistoryScreen(),
          '/public-catalog': (context) => const PublicCatalogScreen(),
          '/catalog-item-detail': (context) {
            final categoryId =
                ModalRoute.of(context)?.settings.arguments as String?;
            return CatalogItemDetailScreen(
              categoryId: categoryId ?? 'technology',
            );
          },
          // Phase 7 routes
          '/what-if': (context) => const WhatIfScreen(),
          '/comparison': (context) => const ComparisonScreen(),
        },
      ),
    );
  }
}
