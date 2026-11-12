import '../../domain/entities/user_profile.dart';

/// Model data profil pengguna (dikirim/diterima dari Supabase).
class UserProfileModel {
  const UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.plan,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String email;
  final String role;
  final String plan;
  final DateTime createdAt;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id_pengguna'] as String,
      name: json['nama'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      plan: json['plan'] as String? ?? 'basic',
      createdAt: DateTime.tryParse(json['tanggal_dibuat'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toUpdateJson({required String name}) {
    return {
      'nama': name,
    };
  }

  Map<String, dynamic> toRolePlanJson({
    String? role,
    String? plan,
  }) {
    return {
      if (role != null) 'role': role,
      if (plan != null) 'plan': plan,
    };
  }

  UserProfile toEntity() {
    return UserProfile(
      id: id,
      name: name,
      email: email,
      role: role,
      plan: plan,
      createdAt: createdAt,
    );
  }

  @override
  String toString() =>
      'UserProfileModel(id: $id, name: $name, email: $email, role: $role, plan: $plan)';
}
