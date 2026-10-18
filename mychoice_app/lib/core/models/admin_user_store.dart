import 'package:flutter/foundation.dart';

import 'admin_user.dart';

class AdminUserStore {
  AdminUserStore._();

  static final instance = AdminUserStore._();

  final users = ValueNotifier<List<AdminUser>>(List.of(demoAdminUsers));

  void update(AdminUser updatedUser) {
    users.value = users.value
        .map((user) => user.id == updatedUser.id ? updatedUser : user)
        .toList();
  }
}
