import 'package:flutter/foundation.dart';

import '../../../../core/models/admin_user.dart';
import '../../domain/repositories/admin_user_repository.dart';

class AdminUserProvider extends ChangeNotifier {
  AdminUserProvider(this._repository);

  final AdminUserRepository _repository;

  List<AdminUser> _users = [];
  bool _isLoading = false;
  String? _error;

  List<AdminUser> get users => List.unmodifiable(_users);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _users = await _repository.getUsers();
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateAccess({
    required String userId,
    required String role,
    required String plan,
  }) async {
    try {
      final updated = await _repository.updateAccess(
        userId: userId,
        role: role,
        plan: plan,
      );
      _replace(updated);
      _error = null;
      notifyListeners();
      return true;
    } catch (error) {
      _error = error.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> setActive({required String userId, required bool active}) async {
    try {
      await _repository.setActive(userId: userId, active: active);
      final index = _users.indexWhere((user) => user.id == userId);
      if (index >= 0) {
        _users[index] = _users[index].copyWith(
          status: active ? AdminUserStatus.active : AdminUserStatus.inactive,
        );
      }
      _error = null;
      notifyListeners();
      return true;
    } catch (error) {
      _error = error.toString();
      notifyListeners();
      return false;
    }
  }

  void _replace(AdminUser updated) {
    final index = _users.indexWhere((user) => user.id == updated.id);
    if (index >= 0) _users[index] = updated;
  }
}
