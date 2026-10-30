import '../entities/user.dart';
import '../entities/session.dart';

/// Registration data model
class RegistrationData {
  final String email;
  final String password;
  final String name;
  final DateTime dateOfBirth;

  const RegistrationData({
    required this.email,
    required this.password,
    required this.name,
    required this.dateOfBirth,
  });
}

/// Authentication result containing user and session
class AuthResult {
  final User user;
  final Session session;

  const AuthResult({required this.user, required this.session});
}

/// Authentication repository interface
abstract class AuthRepository {
  /// Login with email and password
  Future<AuthResult> login(String email, String password);

  /// Register new user with provided data
  Future<AuthResult> register(RegistrationData data);

  /// Logout current user
  Future<void> logout();

  /// Refresh authentication token
  Future<Session> refreshToken(String refreshToken);

  /// Get stored session (from local storage or memory)
  Future<Session?> getStoredSession();
}
