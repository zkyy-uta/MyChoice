// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mychoice_app/app.dart';
import 'package:mychoice_app/core/entities/user_plan.dart';
import 'package:mychoice_app/core/routes/role_guard.dart';
import 'package:mychoice_app/features/auth/domain/entities/user.dart'
    as app_user;
import 'package:mychoice_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mychoice_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:mychoice_app/screens/auth/forgot_password_screen.dart';
import 'package:mychoice_app/screens/auth/login_screen.dart';
import 'package:mychoice_app/screens/auth/reset_password_code_screen.dart';
import 'package:mychoice_app/screens/auth/reset_password_screen.dart';
import 'package:mychoice_app/screens/user/decision/create_decision_screen.dart';
import 'package:mychoice_app/screens/user/profile/premium_plan_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await Supabase.initialize(
      url: 'http://localhost:54321',
      publishableKey: 'test-publishable-key',
    );
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyChoiceApp());

    // Verify that splash screen is shown initially
    expect(find.text('MyChoice'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('login screen offers Google sign-in', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(repository: _UnauthenticatedRepository()),
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Or'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
  });

  testWidgets('user login opens user dashboard', (WidgetTester tester) async {
    await _verifyLoginDestination(tester, isAdmin: false);
  });

  testWidgets('admin login opens admin dashboard', (WidgetTester tester) async {
    await _verifyLoginDestination(tester, isAdmin: true);
  });

  testWidgets('password recovery asks for an email code in the app', (
    WidgetTester tester,
  ) async {
    final repository = _UnauthenticatedRepository();
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(repository: repository),
        child: MaterialApp(
          home: const ForgotPasswordScreen(),
          routes: {
            '/verify-reset-code': (_) =>
                const ResetPasswordCodeScreen(email: 'user@example.com'),
            '/reset-password': (_) => const ResetPasswordScreen(),
          },
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Kembali ke login'), findsNothing);
    await tester.enterText(
      find.byKey(const Key('reset-email')),
      'user@example.com',
    );
    await tester.tap(find.text('Kirim kode reset'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Masukkan Kode Reset'), findsOneWidget);
    expect(find.byKey(const Key('reset-code')), findsOneWidget);
    expect(find.text('Kembali ke login'), findsNothing);

    await tester.enterText(find.byKey(const Key('reset-code')), '1234 5678');
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('reset-code')))
          .controller
          ?.text,
      '12345678',
    );
    await tester.tap(find.text('Verifikasi kode'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(repository.didVerifyPasswordResetCode, isTrue);
    expect(find.text('Buat Password Baru'), findsOneWidget);

    final saveButton = tester.widget<ElevatedButton>(
      find.byKey(const Key('save-new-password')),
    );
    expect(saveButton.onPressed, isNull);

    await tester.enterText(
      find.byKey(const Key('new-password')),
      'StrongPass123',
    );
    await tester.enterText(
      find.byKey(const Key('confirm-new-password')),
      'DifferentPass123',
    );
    await tester.pump();
    expect(
      tester
          .widget<ElevatedButton>(find.byKey(const Key('save-new-password')))
          .onPressed,
      isNull,
    );

    await tester.enterText(
      find.byKey(const Key('confirm-new-password')),
      'StrongPass123',
    );
    await tester.pump();
    expect(
      tester
          .widget<ElevatedButton>(find.byKey(const Key('save-new-password')))
          .onPressed,
      isNotNull,
    );
  });

  test('shows connection guidance for failed Supabase DNS lookup', () async {
    final repository = _UnauthenticatedRepository()
      ..loginError = Exception('SocketException: Failed host lookup');
    final auth = AuthProvider(repository: repository);
    await auth.initialized;

    await auth.login('user@example.com', 'Password123');

    expect(auth.error, contains('Periksa koneksi internet atau DNS di HP'));
    auth.dispose();
  });

  testWidgets('unauthenticated users cannot open admin routes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(repository: _UnauthenticatedRepository()),
        child: MaterialApp(
          routes: {'/login': (_) => const Scaffold(body: Text('Login screen'))},
          home: RoleGuard(
            adminOnly: true,
            builder: (_) => const Text('Private admin page'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Private admin page'), findsNothing);
    expect(find.text('Login screen'), findsOneWidget);
    expect(
      find.text('Silakan login untuk mengakses halaman ini.'),
      findsNothing,
    );
  });

  testWidgets('Basic decision blocks a fourth option and shows upgrade popup', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    await tester.pumpWidget(
      MaterialApp(
        home: const CreateDecisionScreen(),
        routes: {'/profile/premium-plan': (_) => const PremiumPlanScreen()},
      ),
    );

    const options = [
      'ASUS Vivobook 14',
      'Lenovo IdeaPad Slim 5',
      'Acer Aspire 5',
      'HP Pavilion 15',
    ];
    for (final option in options) {
      final optionFinder = find.text(option);
      await tester.ensureVisible(optionFinder);
      await tester.tap(optionFinder);
      await tester.pump();
    }
    final addOptionsButton = find.byKey(const Key('add-selected-options'));
    await tester.ensureVisible(addOptionsButton);
    await tester.tap(addOptionsButton);
    await tester.pumpAndSettle();

    expect(find.text('Options Compared (3)'), findsOneWidget);
    expect(find.text('Batas pilihan tercapai'), findsOneWidget);
    expect(
      find.text(
        'Tidak bisa menambahkan lebih dari 3 barang. Maksimal 3 pilihan '
        'barang. Kalau ingin membandingkan lebih banyak, kamu perlu membeli '
        'paket Premium.',
      ),
      findsOneWidget,
    );
    expect(find.text('3 pilihan'), findsOneWidget);
    expect(find.text('Hingga 10'), findsOneWidget);
    expect(find.text('Upgrade Premium'), findsOneWidget);

    await tester.tap(find.text('Upgrade Premium'));
    await tester.pumpAndSettle();
    expect(find.text('Premium Plan'), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('decision creation reviews, processes, and opens results', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    await tester.pumpWidget(const MaterialApp(home: CreateDecisionScreen()));

    final makeDecisionButton = find.text('Make a Decision');
    await tester.ensureVisible(makeDecisionButton);
    await tester.tap(makeDecisionButton);
    await tester.pumpAndSettle();

    expect(find.text('Almost done! 🎉'), findsOneWidget);
    await tester.tap(find.text('Start Calculation'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 3500));
    await tester.pump();

    expect(find.text('Decision Results'), findsOneWidget);
    await tester.tap(find.text('Decision Results').last);
    await tester.pumpAndSettle();

    expect(find.text('Decision Results'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Decision'), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });
}

Future<void> _verifyLoginDestination(
  WidgetTester tester, {
  required bool isAdmin,
}) async {
  final role = isAdmin ? app_user.UserRole.admin : app_user.UserRole.basic;
  final repository = _UnauthenticatedRepository(
    loginResult: AuthResult(
      user: app_user.User(
        id: 'test-user',
        email: 'user@example.com',
        name: isAdmin ? 'Admin' : 'User',
        role: role,
        plan: UserPlan.forTier(
          isAdmin ? UserPlanTier.admin : UserPlanTier.basic,
        ),
        createdAt: DateTime(2026),
      ),
    ),
  );
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(repository: repository),
      child: MaterialApp(
        home: const LoginScreen(),
        routes: {
          '/dashboard': (_) => const Scaffold(body: Text('User Dashboard')),
          '/admin': (_) => const Scaffold(body: Text('Admin Dashboard')),
        },
      ),
    ),
  );
  await tester.pumpAndSettle();

  await tester.enterText(
    find.byKey(const Key('login-email')),
    'user@example.com',
  );
  await tester.enterText(find.byKey(const Key('login-password')), 'Password1');
  await tester.tap(find.text('Log In'));
  await tester.pumpAndSettle();

  expect(
    find.text(isAdmin ? 'Admin Dashboard' : 'User Dashboard'),
    findsOneWidget,
  );
}

class _UnauthenticatedRepository implements AuthRepository {
  _UnauthenticatedRepository({this.loginResult});

  final AuthResult? loginResult;
  bool didVerifyPasswordResetCode = false;
  Object? loginError;

  @override
  Future<AuthResult?> getCurrentUser() async => null;

  @override
  Future<AuthResult> login(String email, String password) async {
    if (loginError != null) throw loginError!;
    if (loginResult != null) return loginResult!;
    throw UnimplementedError();
  }

  @override
  Future<bool> signInWithGoogle() async => false;

  @override
  Future<void> logout() async {}

  @override
  Future<AuthResult> register(RegistrationData data) {
    throw UnimplementedError();
  }

  @override
  Future<void> requestPasswordReset(String email) async {}

  @override
  Future<void> verifyPasswordResetCode(String email, String code) async {
    didVerifyPasswordResetCode = true;
  }

  @override
  Future<void> updatePassword(String password) async {}

  @override
  Future<void> deleteAccount() async {}
}
