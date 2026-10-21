enum AdminUserStatus { active, inactive }

class AdminUser {
  const AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.plan,
    required this.status,
  });

  final String id;
  final String name;
  final String email;
  final String plan;
  final AdminUserStatus status;

  AdminUser copyWith({
    String? name,
    String? email,
    String? plan,
    AdminUserStatus? status,
  }) {
    return AdminUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      plan: plan ?? this.plan,
      status: status ?? this.status,
    );
  }
}

const demoAdminUsers = [
  AdminUser(
    id: 'USR-001',
    name: 'Enami Asa',
    email: 'asa.enami@gmail.com',
    plan: 'Premium',
    status: AdminUserStatus.active,
  ),
  AdminUser(
    id: 'USR-002',
    name: 'Bima Sakti',
    email: 'bima.sakti@gmail.com',
    plan: 'Premium',
    status: AdminUserStatus.active,
  ),
  AdminUser(
    id: 'USR-003',
    name: 'Najwa',
    email: 'najwa@gmail.com',
    plan: 'Basic',
    status: AdminUserStatus.inactive,
  ),
  AdminUser(
    id: 'USR-004',
    name: 'Noor Irma',
    email: 'irma.noor@gmail.com',
    plan: 'Premium',
    status: AdminUserStatus.active,
  ),
  AdminUser(
    id: 'USR-005',
    name: 'Siwa Anzar',
    email: 'siwa.anzar@gmail.com',
    plan: 'Basic',
    status: AdminUserStatus.active,
  ),
  AdminUser(
    id: 'USR-006',
    name: 'Victor',
    email: 'victor@gmail.com',
    plan: 'Basic',
    status: AdminUserStatus.active,
  ),
];
