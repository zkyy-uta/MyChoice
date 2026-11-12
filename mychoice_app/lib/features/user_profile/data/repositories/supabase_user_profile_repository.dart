import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../models/user_profile_model.dart';

/// Implementasi repository profil pengguna menggunakan Supabase.
class SupabaseUserProfileRepository implements UserProfileRepository {
  SupabaseUserProfileRepository(this._client);

  final SupabaseClient _client;

  String get _currentUserId {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('User belum login.');
    }
    return user.id;
  }

  @override
  Future<UserProfile> getUserProfile() async {
    final userId = _currentUserId;

    try {
      // Coba via fungsi RPC terlebih dahulu
      try {
        final response = await _client.rpc('get_user_profile');
        final data = response as List<dynamic>;
        if (data.isNotEmpty) {
          return UserProfileModel.fromJson(data.first as Map<String, dynamic>).toEntity();
        }
      } on Object {
        // Jika RPC gagal, fallback ke query langsung
      }

      // Fallback: query langsung ke tabel pengguna
      final response = await _client
          .from('pengguna')
          .select('*')
          .eq('id_pengguna', userId)
          .maybeSingle();

      if (response == null) {
        throw Exception('Profil pengguna tidak ditemukan.');
      }

      return UserProfileModel.fromJson(Map<String, dynamic>.from(response as Map)).toEntity();
    } on Exception {
      rethrow;
    } on Object catch (e) {
      throw Exception('Gagal memuat profil pengguna: $e');
    }
  }

  @override
  Future<UserProfile> updateProfile({required String name}) async {
    final userId = _currentUserId;

    try {
      final response = await _client
          .from('pengguna')
          .update({'nama': name})
          .eq('id_pengguna', userId)
          .select()
          .single();

      return UserProfileModel.fromJson(Map<String, dynamic>.from(response as Map)).toEntity();
    } on Exception {
      rethrow;
    } on Object catch (e) {
      throw Exception('Gagal memperbarui profil: $e');
    }
  }

  @override
  Future<bool> isAdmin() async {
    try {
      final response = await _client.rpc('is_admin_user');
      return response as bool? ?? false;
    } on Object {
      return false;
    }
  }

  @override
  Future<bool> isPremium() async {
    try {
      final response = await _client.rpc('is_premium_user');
      return response as bool? ?? false;
    } on Object {
      return false;
    }
  }

  @override
  Future<UserProfile> updateRoleAndPlan({
    required String targetUserId,
    String? role,
    String? plan,
  }) async {
    try {
      final payload = <String, dynamic>{};
      if (role != null) payload['role'] = role;
      if (plan != null) payload['plan'] = plan;

      if (payload.isEmpty) {
        throw Exception('Tidak ada field yang diperbarui.');
      }

      final response = await _client
          .from('pengguna')
          .update(payload)
          .eq('id_pengguna', targetUserId)
          .select()
          .single();

      return UserProfileModel.fromJson(Map<String, dynamic>.from(response as Map)).toEntity();
    } on Exception {
      rethrow;
    } on Object catch (e) {
      throw Exception('Gagal memperbarui role dan plan: $e');
    }
  }
}
