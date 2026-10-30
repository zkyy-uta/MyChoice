import '../../domain/entities/user.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/entities/user_plan.dart';

/// Mock authentication data source for development
/// Accepts any email/password combination and returns mock user + session
class MockAuthDataSource {
  /// Mock login - accepts any credentials
  Future<AuthResult> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Create mock user (same for any email/password)
    final user = User(
      id: 'user_${email.split('@')[0]}_123',
      email: email,
      name: email.split('@')[0].replaceAll('.', ' ').toUpperCase(),
      dateOfBirth: DateTime(2000, 1, 1),
      role: UserRole.basic,
      plan: UserPlan.forTier(UserPlanTier.basic),
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    );

    // Create mock session - expires in 24 hours
    final session = Session(
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken:
          'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
      createdAt: DateTime.now(),
    );

    return AuthResult(user: user, session: session);
  }

  /// Mock register - accepts any data and returns new user + session
  Future<AuthResult> register(RegistrationData data) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));

    // Create mock user with registration data
    final user = User(
      id: 'user_${data.email.split('@')[0]}_${DateTime.now().millisecondsSinceEpoch}',
      email: data.email,
      name: data.name,
      dateOfBirth: data.dateOfBirth,
      role: UserRole.basic,
      plan: UserPlan.forTier(UserPlanTier.basic),
      createdAt: DateTime.now(),
    );

    // Create mock session
    final session = Session(
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken:
          'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
      createdAt: DateTime.now(),
    );

    return AuthResult(user: user, session: session);
  }

  /// Mock logout - no-op
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  /// Mock refresh token
  Future<Session> refreshToken(String refreshToken) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return Session(
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken:
          'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
      createdAt: DateTime.now(),
    );
  }

  /// Mock get stored session - returns null (no persistence in mock)
  Future<Session?> getStoredSession() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return null;
  }
}
