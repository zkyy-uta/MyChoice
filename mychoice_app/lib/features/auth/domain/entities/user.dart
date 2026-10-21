import 'package:mychoice_app/core/entities/user_plan.dart';

enum UserRole { guest, basic, premium, admin }

/// User entity representing an authenticated user
class User {
  final String id;
  final String email;
  final String name;
  final DateTime? dateOfBirth;
  final UserRole role;
  final UserPlan plan;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.dateOfBirth,
    required this.role,
    required this.plan,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create a copy with optional field replacements
  User copyWith({
    String? id,
    String? email,
    String? name,
    DateTime? dateOfBirth,
    UserRole? role,
    UserPlan? plan,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      role: role ?? this.role,
      plan: plan ?? this.plan,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'User(id: $id, email: $email, name: $name, role: $role)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id && other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}
