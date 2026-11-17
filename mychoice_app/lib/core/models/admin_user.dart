enum AdminUserStatus { active, inactive }

class AdminUser {
  const AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.plan,
    required this.status,
    this.createdAt,
  });

  final String id;
  final String name;
  final String email;
  final String role;
  final String plan;
  final AdminUserStatus status;
  final DateTime? createdAt;

  AdminUser copyWith({
    String? name,
    String? email,
    String? role,
    String? plan,
    AdminUserStatus? status,
  }) {
    return AdminUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      plan: plan ?? this.plan,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}
