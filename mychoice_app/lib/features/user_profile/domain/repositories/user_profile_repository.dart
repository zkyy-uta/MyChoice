import '../entities/user_profile.dart';

/// Antarmuka repository untuk manajemen profil dan akun pengguna.
abstract class UserProfileRepository {
  /// Ambil profil lengkap pengguna yang sedang login.
  Future<UserProfile> getUserProfile();

  /// Perbarui nama pengguna sendiri.
  Future<UserProfile> updateProfile({required String name});

  /// Cek apakah pengguna adalah admin.
  Future<bool> isAdmin();

  /// Cek apakah pengguna memiliki plan premium.
  Future<bool> isPremium();

  /// Perbarui role dan plan pengguna (hanya admin).
  Future<UserProfile> updateRoleAndPlan({
    required String targetUserId,
    String? role,
    String? plan,
  });
}
