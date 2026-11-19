import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/models/admin_user.dart';
import '../../domain/repositories/admin_user_repository.dart';

class SupabaseAdminUserRepository implements AdminUserRepository {
  SupabaseAdminUserRepository(this._client);

  final SupabaseClient _client;

  AdminUser _mapRow(Map<String, dynamic> row) => AdminUser(
    id: row['id_pengguna'] as String,
    name: row['nama'] as String? ?? '',
    email: row['email'] as String? ?? '',
    role: row['role'] as String? ?? 'user',
    plan: row['plan'] as String? ?? 'basic',
    status: row['status_akun'] == 'aktif'
        ? AdminUserStatus.active
        : AdminUserStatus.inactive,
    createdAt: DateTime.tryParse(row['tanggal_dibuat'] as String? ?? ''),
  );

  @override
  Future<List<AdminUser>> getUsers() async {
    try {
      // RPC security definer: policy SELECT "pengguna_read_own" membatasi user
      // biasa pada barisnya sendiri, sehingga daftar akun harus diambil lewat
      // fungsi khusus admin.
      final rows = await _client.rpc('admin_list_users');
      if (rows is! List) {
        throw const FormatException('The user directory response is invalid.');
      }
      return rows
          .map((row) => _mapRow(Map<String, dynamic>.from(row as Map)))
          // Akun admin tidak ditampilkan pada dashboard maupun User Management;
          // daftar hanya berisi akun pengguna dengan plan basic/premium.
          .where((user) => user.role != 'admin')
          .toList();
    } on PostgrestException catch (error) {
      throw Exception('Failed to load user accounts: ${error.message}');
    }
  }

  @override
  Future<AdminUser> updateAccess({
    required String userId,
    required String role,
    required String plan,
  }) async {
    try {
      final result = await _client.rpc(
        'admin_update_user_access',
        params: {'p_target_user_id': userId, 'p_role': role, 'p_plan': plan},
      );
      if (result is! Map) {
        throw const FormatException('The access update response is invalid.');
      }
      return _mapRow(Map<String, dynamic>.from(result));
    } on PostgrestException catch (error) {
      throw Exception('Failed to update user access: ${error.message}');
    }
  }

  @override
  Future<void> setActive({required String userId, required bool active}) async {
    try {
      await _client.functions.invoke(
        'manage-user-status',
        body: {'targetUserId': userId, 'active': active},
      );
    } on FunctionException catch (error) {
      throw Exception('Failed to update account status: ${error.reasonPhrase}');
    } on PostgrestException catch (error) {
      throw Exception('Failed to update account status: ${error.message}');
    }
  }
}
