import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mychoice_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mychoice_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:mychoice_app/screens/admin/dashboard/admin_dashboard_screen.dart';
import 'package:mychoice_app/screens/admin/profile/admin_profile_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('admin profile has no back arrow and can log out', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(500, 900));
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => AuthProvider(repository: _TestAuthRepository()),
          child: const AdminProfileScreen(),
        ),
        routes: {
          '/login': (_) => const Scaffold(body: Text('Login screen')),
          '/admin': (_) => const Scaffold(body: Text('Admin dashboard')),
          '/admin/users': (_) => const Scaffold(body: Text('User management')),
        },
      ),
    );

    expect(find.byIcon(Icons.arrow_back), findsNothing);
    expect(find.text('Log out'), findsOneWidget);
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    expect(find.text('Login screen'), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('admin dashboard header matches user profile proportions', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(500, 900));
    await tester.pumpWidget(const MaterialApp(home: AdminDashboardScreen()));

    expect(find.text('New User Activity'), findsOneWidget);
    expect(find.text('Admin'), findsOneWidget);
    final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar).first);
    expect(avatar.radius, 24);
    final adminName = tester.widget<Text>(find.text('Admin'));
    expect(adminName.style?.fontSize, 20);

    await tester.binding.setSurfaceSize(null);
  });
}

class _TestAuthRepository implements AuthRepository {
  @override
  Future<AuthResult?> getCurrentUser() async => null;

  @override
  Future<AuthResult> login(String email, String password) =>
      throw UnimplementedError();

  @override
  Future<bool> signInWithGoogle() async => false;

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
  Future<void> deleteAccount() async {}

  @override
  Future<void> logout() async {}
}
