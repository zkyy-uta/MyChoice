import 'package:flutter/material.dart';

import 'role_guard.dart';
import '../../screens/guest/guest_home_screen.dart';
import '../../screens/guest/guest_category_detail_screen.dart';
import '../../screens/guest/guest_create_decision_screen.dart';
import '../../screens/guest/guest_explore_screen.dart';
import '../../screens/user/comparison/comparison_screen.dart';
import '../../screens/user/decision/what_if_screen.dart';
import '../../screens/admin/catalogue/catalogue_screen.dart';
import '../../screens/admin/dashboard/admin_dashboard_screen.dart';
import '../../screens/admin/profile/admin_profile_screen.dart';
import '../../screens/admin/reports/admin_reports_screen.dart';
import '../../screens/admin/users/user_management_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/auth/reset_password_screen.dart';
import '../../screens/auth/reset_password_code_screen.dart';
import '../../screens/user/comparison/mf08_manual_choice_structuring_screen.dart';
import '../../screens/user/dashboard/dashboard_screen.dart';
import '../../screens/user/decision/create_decision_screen.dart';
import '../../screens/user/history/history_screen.dart';
import '../../screens/guest/mf04_public_home_catalog_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/user/profile/language_screen.dart';
import '../../screens/user/profile/my_decision_data_screen.dart';
import '../../screens/user/profile/notification_settings_screen.dart';
import '../../screens/user/profile/personal_information_screen.dart';
import '../../screens/user/profile/premium_plan_screen.dart';
import '../../screens/user/profile/profile_screen.dart';
import '../../screens/user/profile/security_screen.dart';
import '../../screens/splash/splash_screen.dart';

Map<String, WidgetBuilder> buildAppRoutes() {
  WidgetBuilder userRoute(WidgetBuilder builder) =>
      (context) => RoleGuard(builder: builder);
  WidgetBuilder adminRoute(WidgetBuilder builder) =>
      (context) => RoleGuard(adminOnly: true, builder: builder);

  return {
    '/': (context) => const SplashScreen(),
    '/onboarding': (context) => const OnboardingScreen(),
    '/login': (context) => const LoginScreen(),
    '/register': (context) => const RegisterScreen(),
    '/forgot-password': (context) => const ForgotPasswordScreen(),
    '/verify-reset-code': (context) {
      final email = ModalRoute.of(context)?.settings.arguments;
      if (email is! String || email.isEmpty) {
        throw FlutterError(
          'The /verify-reset-code route requires an email address.',
        );
      }
      return ResetPasswordCodeScreen(email: email);
    },
    '/reset-password': (context) => const ResetPasswordScreen(),
    '/dashboard': userRoute((context) => const DashboardScreen()),
    '/create-decision': userRoute((context) => const CreateDecisionScreen()),
    '/history': userRoute((context) => const HistoryScreen()),
    '/profile': userRoute((context) => const ProfileScreen()),
    '/profile/personal-information': userRoute(
      (context) => const PersonalInformationScreen(),
    ),
    '/profile/premium-plan': userRoute((context) => const PremiumPlanScreen()),
    '/profile/security': userRoute((context) => const SecurityScreen()),
    '/profile/notifications': userRoute(
      (context) => const NotificationSettingsScreen(),
    ),
    '/profile/language': userRoute((context) => const LanguageScreen()),
    '/profile/my-decision-data': userRoute(
      (context) => const MyDecisionDataScreen(),
    ),
    '/guest-home': (context) => const GuestHomeScreen(),
    '/guest-explore': (context) => const GuestExploreScreen(),
    '/guest-category-detail': (context) =>
        const GuestCategoryDetailScreen(categoryName: 'Technology'),
    '/guest-create-decision': (context) => const GuestCreateDecisionScreen(),
    '/public-catalog': (context) => const Mf04PublicHomeCatalogScreen(),
    '/comparison': userRoute((context) => const ComparisonScreen()),
    '/mf08-comparison': userRoute((context) {
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
    }),
    '/what-if': userRoute((context) => const WhatIfScreen()),
    '/admin': adminRoute((context) => const AdminDashboardScreen()),
    '/admin/users': adminRoute((context) => const UserManagementScreen()),
    '/admin/catalogue': adminRoute((context) => const CatalogueScreen()),
    '/admin/reports': adminRoute((context) => const AdminReportsScreen()),
    '/admin/profile': adminRoute((context) => const AdminProfileScreen()),
    '/admin/profile/personal-information': adminRoute(
      (context) => const PersonalInformationScreen(isAdmin: true),
    ),
  };
}
