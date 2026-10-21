import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/errors/app_exception.dart';

/// Authentication state enum
enum AuthState { initial, loading, authenticated, error, unauthenticated }

/// Authentication provider using ChangeNotifier for state management
class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  // State properties
  User? _user;
  Session? _session;
  AuthState _state = AuthState.initial;
  String? _error;

  // Getters
  User? get user => _user;
  Session? get session => _session;
  AuthState get state => _state;
  String? get error => _error;
  bool get isAuthenticated =>
      _state == AuthState.authenticated && _user != null;

  AuthProvider({required AuthRepository repository}) : _repository = repository;

  /// Login with email and password
  Future<void> login(String email, String password) async {
    _state = AuthState.loading;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.login(email, password);
      _user = result.user;
      _session = result.session;
      _state = AuthState.authenticated;
      _error = null;
    } on AppException catch (e) {
      _state = AuthState.error;
      _error = e.message;
      _user = null;
      _session = null;
    } catch (e) {
      _state = AuthState.error;
      _error = 'An unexpected error occurred: $e';
      _user = null;
      _session = null;
    }

    notifyListeners();
  }

  /// Register new user with provided data
  Future<void> register(RegistrationData data) async {
    _state = AuthState.loading;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.register(data);
      _user = result.user;
      _session = result.session;
      _state = AuthState.authenticated;
      _error = null;
    } on AppException catch (e) {
      _state = AuthState.error;
      _error = e.message;
      _user = null;
      _session = null;
    } catch (e) {
      _state = AuthState.error;
      _error = 'An unexpected error occurred: $e';
      _user = null;
      _session = null;
    }

    notifyListeners();
  }

  /// Logout current user
  Future<void> logout() async {
    _state = AuthState.loading;
    _error = null;
    notifyListeners();

    try {
      await _repository.logout();
      _user = null;
      _session = null;
      _state = AuthState.unauthenticated;
      _error = null;
    } on AppException catch (e) {
      _state = AuthState.error;
      _error = e.message;
    } catch (e) {
      _state = AuthState.error;
      _error = 'Logout failed: $e';
    }

    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Set authentication state directly (useful for initialization)
  void setAuthenticated(User user, Session session) {
    _user = user;
    _session = session;
    _state = AuthState.authenticated;
    _error = null;
    notifyListeners();
  }

  /// Set unauthenticated state
  void setUnauthenticated() {
    _user = null;
    _session = null;
    _state = AuthState.unauthenticated;
    _error = null;
    notifyListeners();
  }
}
