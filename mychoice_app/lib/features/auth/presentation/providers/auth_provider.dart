import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/session.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthState { initial, loading, authenticated, error, unauthenticated }

class AuthProvider extends ChangeNotifier {
  AuthProvider({required AuthRepository repository})
    : _repository = repository {
    _initialized = initialize();
  }

  final AuthRepository _repository;
  late final Future<void> _initialized;

  User? _user;
  Session? _session;
  AuthState _state = AuthState.initial;
  String? _error;
  bool _registrationNeedsConfirmation = false;
  bool _googleSignInPending = false;
  bool _passwordResetCodeVerified = false;

  User? get user => _user;
  Session? get session => _session;
  AuthState get state => _state;
  String? get error => _error;
  bool get isAuthenticated =>
      _state == AuthState.authenticated && _user != null;
  bool get registrationNeedsConfirmation => _registrationNeedsConfirmation;
  bool get isGoogleSignInPending => _googleSignInPending;
  bool get isPasswordResetCodeVerified => _passwordResetCodeVerified;
  Future<void> get initialized => _initialized;

  Future<void> initialize() async {
    _state = AuthState.loading;
    notifyListeners();
    try {
      final result = await _repository.getCurrentUser();
      if (result == null) {
        _setUnauthenticated();
      } else {
        _setAuthenticated(result.user, result.session);
      }
    } catch (error) {
      _setError(error);
      _user = null;
      _session = null;
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _state = AuthState.loading;
    _error = null;
    _googleSignInPending = false;
    _registrationNeedsConfirmation = false;
    notifyListeners();

    try {
      final result = await _repository.login(email, password);
      _setAuthenticated(result.user, result.session);
    } catch (error) {
      _setError(error);
      _user = null;
      _session = null;
    }

    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    _state = AuthState.loading;
    _error = null;
    _googleSignInPending = true;
    notifyListeners();

    try {
      final didLaunch = await _repository.signInWithGoogle();
      if (!didLaunch && _googleSignInPending) {
        throw AuthenticationError(
          message:
              'Tidak dapat membuka halaman login Google. Silakan coba lagi.',
        );
      }
      if (_googleSignInPending) {
        _state = AuthState.unauthenticated;
      }
    } catch (error) {
      _googleSignInPending = false;
      _setError(error);
    }

    notifyListeners();
  }

  Future<void> completeGoogleSignIn() async {
    if (!_googleSignInPending) return;

    try {
      final result = await _repository.getCurrentUser();
      if (result == null) {
        throw AuthenticationError(
          message: 'Login Google tidak berhasil. Silakan coba lagi.',
        );
      }
      _googleSignInPending = false;
      _setAuthenticated(result.user, result.session);
    } catch (error) {
      _googleSignInPending = false;
      _setError(error);
    }

    notifyListeners();
  }

  void failGoogleSignIn(Object error) {
    if (!_googleSignInPending) return;
    _googleSignInPending = false;
    _setError(error);
    notifyListeners();
  }

  Future<void> register(RegistrationData data) async {
    _state = AuthState.loading;
    _error = null;
    _googleSignInPending = false;
    _registrationNeedsConfirmation = false;
    notifyListeners();

    try {
      final result = await _repository.register(data);
      if (result.session == null) {
        _user = null;
        _session = null;
        _state = AuthState.unauthenticated;
        _registrationNeedsConfirmation = true;
      } else {
        _setAuthenticated(result.user, result.session);
      }
    } catch (error) {
      _setError(error);
      _user = null;
      _session = null;
    }

    notifyListeners();
  }

  Future<void> requestPasswordReset(String email) async {
    _state = AuthState.loading;
    _error = null;
    _passwordResetCodeVerified = false;
    notifyListeners();
    try {
      await _repository.requestPasswordReset(email);
      _state = _user == null
          ? AuthState.unauthenticated
          : AuthState.authenticated;
    } catch (error) {
      _setError(error);
    }
    notifyListeners();
  }

  Future<void> verifyPasswordResetCode(String email, String code) async {
    _state = AuthState.loading;
    _error = null;
    _passwordResetCodeVerified = false;
    notifyListeners();
    try {
      await _repository.verifyPasswordResetCode(email, code);
      _state = AuthState.unauthenticated;
      _passwordResetCodeVerified = true;
    } catch (error) {
      _setError(error);
    }
    notifyListeners();
  }

  Future<void> updatePassword(String password) async {
    _state = AuthState.loading;
    _error = null;
    notifyListeners();
    try {
      await _repository.updatePassword(password);
      _passwordResetCodeVerified = false;
      _setUnauthenticated();
    } catch (error) {
      _setError(error);
    }
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    _state = AuthState.loading;
    _error = null;
    notifyListeners();

    try {
      await _repository.deleteAccount();
      _setUnauthenticated();
    } catch (error) {
      _setError(error);
    }

    notifyListeners();
  }

  Future<void> logout() async {
    _state = AuthState.loading;
    _error = null;
    _googleSignInPending = false;
    notifyListeners();

    try {
      await _repository.logout();
      _setUnauthenticated();
    } catch (error) {
      _setError(error);
    }

    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void setAuthenticated(User user, Session? session) {
    _setAuthenticated(user, session);
    notifyListeners();
  }

  void setUnauthenticated() {
    _setUnauthenticated();
    notifyListeners();
  }

  void _setAuthenticated(User user, Session? session) {
    _user = user;
    _session = session;
    _state = AuthState.authenticated;
    _error = null;
  }

  void _setUnauthenticated() {
    _user = null;
    _session = null;
    _state = AuthState.unauthenticated;
    _error = null;
  }

  void _setError(Object error) {
    final errorText = error.toString().toLowerCase();
    _state = AuthState.error;
    _error = switch (error) {
      AppException exception => exception.message,
      AuthException exception => exception.message,
      _
          when errorText.contains('unsupported provider') &&
              errorText.contains('not enabled') =>
        'Login Google belum diaktifkan di Supabase. Aktifkan provider Google '
            'di Authentication → Sign In / Providers.',
      _
          when errorText.contains('failed host lookup') ||
              errorText.contains('socketexception') ||
              errorText.contains('no address associated with hostname') =>
        'Tidak dapat terhubung ke server. Periksa koneksi internet atau DNS '
            'di HP, lalu coba lagi.',
      _ => 'Terjadi kesalahan autentikasi. Silakan coba lagi. ($error)',
    };
  }
}
