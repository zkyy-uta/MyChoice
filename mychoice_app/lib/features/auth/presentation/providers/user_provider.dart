import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';

/// User provider for managing user state and profile
class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasUser => _user != null;

  /// Set user directly (from auth)
  void setUser(User user) {
    _user = user;
    _error = null;
    notifyListeners();
  }

  /// Clear user
  void clearUser() {
    _user = null;
    _error = null;
    notifyListeners();
  }

  /// Update user profile
  void updateUserProfile(User updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }

  /// Set error
  void setError(String error) {
    _error = error;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
