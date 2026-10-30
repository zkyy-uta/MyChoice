import '../entities/user.dart';
import '../entities/session.dart';

/// Registration data model
class RegistrationData {
  final String email;
  final String password;
  final String name;

  const RegistrationData({
    required this.email,
    required this.password,
    required this.name,
  });
}

/// Authentication result containing user and session
class AuthResult {
  final User user;
  final Session? session;

  const AuthResult({required this.user, this.session});
}

/// Authentication repository interface
abstract class AuthRepository {
  Future<AuthResult?> getCurrentUser();

  /// Login with email and password
  Future<AuthResult> login(String email, String password);

  /// Start Google OAuth sign-in
  Future<bool> signInWithGoogle();

  /// Register new user with provided data
  Future<AuthResult> register(RegistrationData data);

  Future<void> requestPasswordReset(String email);

  Future<void> verifyPasswordResetCode(String email, String code);

  Future<void> updatePassword(String password);

  /// Permanently delete the currently authenticated account.
  Future<void> deleteAccount();

  /// Logout current user
  Future<void> logout();
}
