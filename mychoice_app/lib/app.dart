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
import 'screens/admin/dashboard/admin_dashboard_screen.dart';
import 'screens/admin/profile/admin_profile_screen.dart';
import 'screens/admin/catalogue/catalogue_screen.dart';
import 'screens/admin/users/user_management_screen.dart';
import 'screens/profile/personal_information_screen.dart';
import 'screens/profile/language_screen.dart';
import 'screens/profile/my_decision_data_screen.dart';
import 'screens/profile/notification_settings_screen.dart';
import 'screens/profile/premium_plan_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/security_screen.dart';

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
        '/dashboard': (context) => const DashboardScreen(),
        '/create-decision': (context) => const CreateDecisionScreen(),
        '/history': (context) => const HistoryScreen(),
      },
    );
  }
}
