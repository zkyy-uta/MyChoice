import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../models/user_profile_model.dart';

/// Implementasi repository profil pengguna menggunakan Supabase.
class SupabaseUserProfileRepository implements UserProfileRepository {
  SupabaseUserProfileRepository(this._client);

  static const _profilePhotosBucket = 'profile-photos';
  static const _maxPhotoSizeBytes = 5 * 1024 * 1024;
  static const _profileSelect =
      'id_pengguna,nama,email,role,plan,tanggal_dibuat,avatar_path';

  final SupabaseClient _client;

  String get _currentUserId {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('User belum login.');
    }
    return user.id;
  }

  Future<UserProfile> _profileFromRow(dynamic row) async {
    final model = UserProfileModel.fromJson(
      Map<String, dynamic>.from(row as Map),
    );
    final avatarPath = model.avatarPath;
    final avatarUrl = avatarPath == null
        ? null
        : await _client.storage
              .from(_profilePhotosBucket)
              .createSignedUrl(avatarPath, 3600);
    return model.toEntity().copyWith(avatarUrl: avatarUrl);
  }

  @override
  Future<UserProfile> getUserProfile() async {
    final userId = _currentUserId;

    try {
      final response = await _client
          .from('pengguna')
          .select(_profileSelect)
          .eq('id_pengguna', userId)
          .maybeSingle();

      if (response == null) {
        throw Exception('Profil pengguna tidak ditemukan.');
      }

      return _profileFromRow(response);
    } on Exception {
      rethrow;
    } on Object catch (e) {
      throw Exception('Gagal memuat profil pengguna: $e');
    }
  }

  @override
  Future<UserProfile> updateProfile({required String name}) async {
    final userId = _currentUserId;
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) {
      throw ArgumentError('Nama depan wajib diisi.');
    }

    try {
      final response = await _client
          .from('pengguna')
          .update({'nama': normalizedName})
          .eq('id_pengguna', userId)
          .select(_profileSelect)
          .single();

      return _profileFromRow(response);
    } on Exception {
      rethrow;
    } on Object catch (e) {
      throw Exception('Gagal memperbarui profil: $e');
    }
  }

  @override
  Future<UserProfile> updateProfilePhoto({
    required Uint8List imageBytes,
    required String fileName,
  }) async {
    final userId = _currentUserId;
    if (imageBytes.isEmpty) {
      throw ArgumentError('File foto kosong.');
    }
    if (imageBytes.length > _maxPhotoSizeBytes) {
      throw ArgumentError('Ukuran foto maksimal 5 MB.');
    }

    final extension = fileName.split('.').last.toLowerCase();
    const mimeTypes = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'webp': 'image/webp',
    };
    final contentType = mimeTypes[extension];
    if (contentType == null) {
      throw ArgumentError('Format foto harus JPG, PNG, atau WebP.');
    }

    final path = '$userId/avatar';

    try {
      await _client.storage
          .from(_profilePhotosBucket)
          .uploadBinary(
            path,
            imageBytes,
            fileOptions: FileOptions(contentType: contentType, upsert: true),
          );
      final response = await _client
          .from('pengguna')
          .update({'avatar_path': path})
          .eq('id_pengguna', userId)
          .select(_profileSelect)
          .single();
      return _profileFromRow(response);
    } on Exception {
      rethrow;
    } on Object catch (e) {
      throw Exception('Gagal memperbarui foto profil: $e');
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

      return _profileFromRow(response);
    } on Exception {
      rethrow;
    } on Object catch (e) {
      throw Exception('Gagal memperbarui role dan plan: $e');
    }
  }
}
