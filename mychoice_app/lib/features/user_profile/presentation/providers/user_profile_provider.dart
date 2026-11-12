import 'package:flutter/foundation.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';

/// Provider untuk mengelola profil dan manajemen akun pengguna.
class UserProfileProvider extends ChangeNotifier {
  UserProfileProvider({required UserProfileRepository repository})
      : _repository = repository;

  final UserProfileRepository _repository;

  UserProfile? _profile;
  bool _isLoading = false;
  String? _error;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAdmin => _profile?.isAdmin ?? false;
  bool get isPremium => _profile?.isPremium ?? false;
  bool get hasProfile => _profile != null;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  /// Muat profil pengguna dari backend.
  Future<void> loadProfile() async {
    _setLoading(true);
    _setError(null);
    try {
      _profile = await _repository.getUserProfile();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Perbarui nama profil pengguna.
  Future<bool> updateName(String name) async {
    _setLoading(true);
    _setError(null);
    try {
      _profile = await _repository.updateProfile(name: name);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Perbarui role dan plan pengguna (hanya admin).
  Future<bool> updateRoleAndPlan({
    required String targetUserId,
    String? role,
    String? plan,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      final updated = await _repository.updateRoleAndPlan(
        targetUserId: targetUserId,
        role: role,
        plan: plan,
      );
      // Jika mengupdate profil sendiri, refresh profil lokal
      if (updated.id == _profile?.id) {
        _profile = updated;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
