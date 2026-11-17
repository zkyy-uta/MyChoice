import '../../../../core/models/admin_user.dart';

abstract class AdminUserRepository {
  Future<List<AdminUser>> getUsers();

  Future<AdminUser> updateAccess({
    required String userId,
    required String role,
    required String plan,
  });

  Future<void> setActive({required String userId, required bool active});
}
