import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/data/datasources/mock_auth_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/category_selection/data/datasources/category_datasource.dart';
import 'features/category_selection/data/repositories/category_repository_impl.dart';
import 'features/category_selection/presentation/providers/category_provider.dart';
import 'features/comparison/presentation/providers/comparison_provider.dart';
import 'features/comparison/presentation/screens/comparison_screen.dart';
import 'features/decision_engine/data/repositories/decision_engine_repository_impl.dart';
import 'features/decision_engine/domain/usecases/calculate_saw_usecase.dart';
import 'features/decision_engine/presentation/providers/result_provider.dart';
import 'features/priority_setting/domain/usecases/auto_balance_usecase.dart';
import 'features/what_if_simulation/domain/usecases/recalculate_simulation_usecase.dart';
import 'features/what_if_simulation/presentation/providers/simulation_provider.dart';
import 'features/what_if_simulation/presentation/screens/what_if_screen.dart';
import 'screens/admin/catalogue/catalogue_screen.dart';
import 'screens/admin/dashboard/admin_dashboard_screen.dart';
import 'screens/admin/profile/admin_profile_screen.dart';
import 'screens/admin/users/user_management_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/decision/create_decision_screen.dart';
import 'screens/history/history_screen.dart';
import 'screens/mf04_public_home_catalog_screen.dart';
import 'screens/comparison/mf08_manual_choice_structuring_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/profile/language_screen.dart';
import 'screens/profile/my_decision_data_screen.dart';
import 'screens/profile/notification_settings_screen.dart';
import 'screens/profile/personal_information_screen.dart';
import 'screens/profile/premium_plan_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/security_screen.dart';
import 'screens/splash/splash_screen.dart';

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
          '/public-catalog': (context) => const Mf04PublicHomeCatalogScreen(),
          '/create-decision': (context) => const CreateDecisionScreen(),
          '/history': (context) => const HistoryScreen(),
          '/comparison': (context) => const ComparisonScreen(),
          '/mf08-comparison': (context) {
            final arguments = ModalRoute.of(context)?.settings.arguments;
            if (arguments is! Mf08ComparisonArguments) {
              throw FlutterError(
                'The /mf08-comparison route requires '
                'Mf08ComparisonArguments.',
              );
            }
            return Mf08ComparisonScreen(
              choices: arguments.choices,
              category: arguments.category,
              subcategory: arguments.subcategory,
            );
          },
          '/what-if': (context) => const WhatIfScreen(),
          '/admin': (context) => const AdminDashboardScreen(),
          '/admin/users': (context) => const UserManagementScreen(),
          '/admin/catalogue': (context) => const CatalogueScreen(),
          '/admin/profile': (context) => const AdminProfileScreen(),
          '/admin/profile/personal-information': (context) =>
              const PersonalInformationScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/profile/personal-information': (context) =>
              const PersonalInformationScreen(),
          '/profile/security': (context) => const SecurityScreen(),
          '/profile/premium-plan': (context) => const PremiumPlanScreen(),
          '/profile/notifications': (context) =>
              const NotificationSettingsScreen(),
          '/profile/language': (context) => const LanguageScreen(),
          '/profile/my-decision-data': (context) =>
              const MyDecisionDataScreen(),
        },
      ),
    );
  }
}
