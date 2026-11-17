import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mychoice_app/core/models/admin_user.dart';
import 'package:mychoice_app/features/admin_user_management/presentation/providers/admin_user_provider.dart';
import 'package:mychoice_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mychoice_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:mychoice_app/screens/admin/users/user_management_screen.dart';
import 'test_support/fake_admin_repositories.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('admin can search and filter accounts by status', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(500, 900));
    await _pumpUserManagement(tester);

    expect(find.byIcon(Icons.arrow_back), findsNothing);
    expect(find.text('Enami Asa'), findsOneWidget);
    expect(find.text('Bima Sakti'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'najwa');
    await tester.pump();
    expect(find.text('Najwa Putri'), findsOneWidget);
    expect(find.text('Enami Asa'), findsNothing);

    await tester.tap(find.byTooltip('Filter by status'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(CheckboxListTile, 'Inactive'));
    await tester.tap(find.text('Apply filter'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pump();
    expect(find.text('Najwa Putri'), findsOneWidget);
    expect(find.text('Enami Asa'), findsOneWidget);
    expect(find.text('Bima Sakti'), findsNothing);

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('admin must confirm before deactivating a user', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(500, 900));
    final repository = await _pumpUserManagement(tester);

    await tester.tap(find.byTooltip('Show account details').first);
    await tester.pumpAndSettle();
    final accountDetails = find.byType(Dialog);
    expect(
      find.descendant(of: accountDetails, matching: find.text('Enami Asa')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: accountDetails,
        matching: find.text('asa.enami@gmail.com'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: accountDetails, matching: find.text('Premium')),
      findsOneWidget,
    );
    expect(find.byType(TextFormField), findsNothing);
    expect(find.text('Deactivate account?'), findsNothing);

    await tester.tap(find.text('Deactivate Account'));
    await tester.pumpAndSettle();
    expect(find.text('Deactivate account?'), findsOneWidget);
    expect(
      find.text(
        'Enami Asa will no longer be able to sign in to MyChoice. '
        'Their existing data will be kept.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Deactivate'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('User Management'), findsOneWidget);
    expect(repository.userById('user-enami')?.status, AdminUserStatus.inactive);

    await tester.binding.setSurfaceSize(null);
  });
}

Future<FakeAdminUserRepository> _pumpUserManagement(WidgetTester tester) async {
  final repository = FakeAdminUserRepository();
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminUserProvider(repository)),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(repository: _TestAuthRepository()),
        ),
      ],
      child: const MaterialApp(home: UserManagementScreen()),
    ),
  );
  await tester.pumpAndSettle();
  return repository;
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
