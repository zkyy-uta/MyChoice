/// Entitas domain untuk profil dan manajemen akun pengguna.
class UserProfile {
  const UserProfile({
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
  final String role; // 'user' atau 'admin'
  final String plan; // 'basic' atau 'premium'
  final DateTime createdAt;

  /// Apakah pengguna adalah admin.
  bool get isAdmin => role == 'admin';

  /// Apakah pengguna memiliki plan premium.
  bool get isPremium => plan == 'premium';

  /// Buat salinan dengan penggantian field opsional.
  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? plan,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      plan: plan ?? this.plan,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'UserProfile(id: $id, name: $name, email: $email, role: $role, plan: $plan)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
