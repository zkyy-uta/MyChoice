import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/decision/create_decision_screen.dart';
import 'screens/history/history_screen.dart';
import 'screens/admin/dashboard/admin_dashboard_screen.dart';
import 'screens/admin/profile/admin_profile_screen.dart';
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
    return MaterialApp(
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
        '/profile': (context) => const ProfileScreen(),
        '/profile/personal-information': (context) =>
            const PersonalInformationScreen(),
        '/profile/premium-plan': (context) => const PremiumPlanScreen(),
        '/profile/security': (context) => const SecurityScreen(),
        '/profile/notifications': (context) =>
            const NotificationSettingsScreen(),
        '/profile/language': (context) => const LanguageScreen(),
        '/profile/my-decision-data': (context) => const MyDecisionDataScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
        '/admin/users': (context) => const UserManagementScreen(),
        '/admin/profile': (context) => const AdminProfileScreen(),
        '/admin/profile/personal-information': (context) =>
            const PersonalInformationScreen(isAdmin: true),
      },
    );
  }
}
