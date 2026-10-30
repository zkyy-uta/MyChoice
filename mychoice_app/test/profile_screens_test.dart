import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mychoice_app/core/entities/user_plan.dart';
import 'package:mychoice_app/features/auth/domain/entities/user.dart';
import 'package:mychoice_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mychoice_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:mychoice_app/screens/admin/profile/admin_profile_screen.dart';
import 'package:mychoice_app/screens/user/profile/personal_information_screen.dart';
import 'package:mychoice_app/screens/user/profile/premium_plan_screen.dart';
import 'package:mychoice_app/screens/user/profile/profile_screen.dart';
import 'package:mychoice_app/screens/user/profile/security_screen.dart';
import 'package:mychoice_app/screens/user/profile/language_screen.dart';
import 'package:mychoice_app/screens/user/profile/my_decision_data_screen.dart';
import 'package:mychoice_app/screens/user/profile/notification_settings_screen.dart';
import 'package:mychoice_app/screens/user/history/history_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('user profile opens personal information, security and plan', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(500, 900));
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(repository: _ProfileAuthRepository()),
        child: MaterialApp(
          home: const ProfileScreen(),
          routes: {
            '/profile/personal-information': (_) =>
                const PersonalInformationScreen(),
            '/profile/security': (_) => const SecurityScreen(),
            '/profile/premium-plan': (_) => const PremiumPlanScreen(),
            '/profile/notifications': (_) => const NotificationSettingsScreen(),
            '/profile/language': (_) => const LanguageScreen(),
            '/profile/my-decision-data': (_) => const MyDecisionDataScreen(),
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Kim Ryul'), findsOneWidget);
    await tester.tap(find.text('Personal Information'));
    await tester.pumpAndSettle();
    expect(find.text('First Name'), findsOneWidget);
    expect(find.text('Date of Birth'), findsNothing);
    expect(find.text('Save Changes'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Security'));
    await tester.pumpAndSettle();
    expect(find.text('Account Security'), findsOneWidget);
    expect(find.text('Two-Factor Authentication'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Premium Plan'));
    await tester.pumpAndSettle();
    expect(find.text('Your Current Plan'), findsOneWidget);
    expect(find.text('UPGRADE TO PREMIUM'), findsOneWidget);
    await tester.ensureVisible(
      find.textContaining('Up to 10 choices per decision'),
    );
    expect(find.text('1 decision per day'), findsNWidgets(2));
    expect(find.text('Up to 3 choices per decision'), findsOneWidget);
    expect(
      find.textContaining('Up to 10 choices per decision'),
      findsOneWidget,
    );
    expect(find.textContaining('alternatives'), findsNothing);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Notification'));
    await tester.tap(find.text('Notification'));
    await tester.pumpAndSettle();
    expect(find.text('Notification Preferences'), findsOneWidget);
    expect(find.text('Decision reminders'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Language'));
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    expect(find.text('Select your language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Bahasa Indonesia'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('My Decision Data'));
    await tester.tap(find.text('My Decision Data'));
    await tester.pumpAndSettle();
    expect(find.text('Decisions created'), findsOneWidget);
    expect(find.text('Technology'), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('admin profile includes personal information', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(500, 900));
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) =>
            AuthProvider(repository: _ProfileAuthRepository(isAdmin: true)),
        child: MaterialApp(
          home: const AdminProfileScreen(),
          routes: {
            '/admin/profile/personal-information': (_) =>
                const PersonalInformationScreen(isAdmin: true),
            '/admin': (_) => const Scaffold(body: Text('Admin dashboard')),
            '/admin/users': (_) =>
                const Scaffold(body: Text('User management')),
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Admin User'), findsOneWidget);
    await tester.tap(find.text('Personal Information'));
    await tester.pumpAndSettle();
    expect(find.text('admin@mychoice.com'), findsOneWidget);
    expect(find.text('Save Changes'), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('user can confirm account deletion from profile', (
    WidgetTester tester,
  ) async {
    final repository = _ProfileAuthRepository();
    await tester.binding.setSurfaceSize(const Size(500, 900));
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(repository: repository),
        child: MaterialApp(
          home: const ProfileScreen(),
          routes: {'/login': (_) => const Scaffold(body: Text('Login screen'))},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Delete Account'));
    await tester.tap(find.text('Delete Account'));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Akun dan data keputusan yang terkait akan dihapus '
        'permanen. Tindakan ini tidak dapat dibatalkan.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
    expect(repository.didDeleteAccount, isFalse);

    await tester.ensureVisible(find.text('Delete Account'));
    await tester.tap(find.text('Delete Account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus akun'));
    await tester.pumpAndSettle();

    expect(repository.didDeleteAccount, isTrue);
    expect(find.text('Login screen'), findsOneWidget);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('profile navigation works from history screen', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(500, 900));
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(repository: _ProfileAuthRepository()),
        child: MaterialApp(
          home: const HistoryScreen(),
          routes: {
            '/profile': (_) => const ProfileScreen(),
            '/dashboard': (_) => const Scaffold(body: Text('Home screen')),
            '/create-decision': (_) =>
                const Scaffold(body: Text('Decision screen')),
            '/history': (_) => const HistoryScreen(),
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('My Profile'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsNothing);

    await tester.binding.setSurfaceSize(null);
  });
}

class _ProfileAuthRepository implements AuthRepository {
  _ProfileAuthRepository({this.isAdmin = false});

  final bool isAdmin;
  bool didDeleteAccount = false;

  @override
  Future<AuthResult?> getCurrentUser() async => AuthResult(
    user: User(
      id: 'test-user',
      email: isAdmin ? 'admin@mychoice.com' : 'kimryul4sho@gmail.com',
      name: isAdmin ? 'Admin User' : 'Kim Ryul',
      role: isAdmin ? UserRole.admin : UserRole.basic,
      plan: UserPlan.forTier(isAdmin ? UserPlanTier.admin : UserPlanTier.basic),
      createdAt: DateTime(2026),
    ),
  );

  @override
  Future<AuthResult> login(String email, String password) =>
      throw UnimplementedError();

  @override
  Future<bool> signInWithGoogle() async => false;

  @override
  Future<void> logout() async {}

  @override
  Future<AuthResult> register(RegistrationData data) =>
      throw UnimplementedError();

  @override
  Future<void> requestPasswordReset(String email) async {}

  @override
  Future<void> verifyPasswordResetCode(String email, String code) async {}

  @override
  Future<void> updatePassword(String password) async {}

  @override
  Future<void> deleteAccount() async {
    didDeleteAccount = true;
  }
}
