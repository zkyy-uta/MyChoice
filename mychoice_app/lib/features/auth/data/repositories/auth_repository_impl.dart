import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/mock_auth_datasource.dart';

/// Authentication repository implementation using mock datasource
class AuthRepositoryImpl implements AuthRepository {
  final MockAuthDataSource _mockDataSource;

  AuthRepositoryImpl({required MockAuthDataSource mockDataSource})
    : _mockDataSource = mockDataSource;

  @override
  Future<AuthResult> login(String email, String password) {
    return _mockDataSource.login(email, password);
  }

  @override
  Future<AuthResult> register(RegistrationData data) {
    return _mockDataSource.register(data);
  }

  @override
  Future<void> logout() {
    return _mockDataSource.logout();
  }

  @override
  Future<Session> refreshToken(String refreshToken) {
    return _mockDataSource.refreshToken(refreshToken);
  }

  @override
  Future<Session?> getStoredSession() {
    return _mockDataSource.getStoredSession();
  }
}
