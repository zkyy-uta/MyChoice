import 'package:mychoice_app/core/models/admin_user.dart';
import 'package:mychoice_app/features/admin_analytics/domain/entities/admin_review.dart';
import 'package:mychoice_app/features/admin_analytics/domain/repositories/admin_analytics_repository.dart';
import 'package:mychoice_app/features/admin_user_management/domain/repositories/admin_user_repository.dart';

class FakeAdminUserRepository implements AdminUserRepository {
  FakeAdminUserRepository({List<AdminUser>? users})
    : _users = List.of(users ?? sampleAdminUsers);

  final List<AdminUser> _users;

  AdminUser? userById(String id) {
    for (final user in _users) {
      if (user.id == id) return user;
    }
    return null;
  }

  @override
  Future<List<AdminUser>> getUsers() async => List.unmodifiable(_users);

  @override
  Future<AdminUser> updateAccess({
    required String userId,
    required String role,
    required String plan,
  }) async {
    final index = _users.indexWhere((user) => user.id == userId);
    if (index < 0) throw StateError('User not found');
    final updated = _users[index].copyWith(role: role, plan: plan);
    _users[index] = updated;
    return updated;
  }

  @override
  Future<void> setActive({required String userId, required bool active}) async {
    final index = _users.indexWhere((user) => user.id == userId);
    if (index < 0) throw StateError('User not found');
    _users[index] = _users[index].copyWith(
      status: active ? AdminUserStatus.active : AdminUserStatus.inactive,
    );
  }
}

class FakeAdminAnalyticsRepository implements AdminAnalyticsRepository {
  @override
  Future<List<AdminReview>> getReviews() async => sampleAdminReviews;
}

final sampleAdminUsers = [
  AdminUser(
    id: 'user-enami',
    name: 'Enami Asa',
    email: 'asa.enami@gmail.com',
    role: 'user',
    plan: 'premium',
    status: AdminUserStatus.active,
    createdAt: DateTime(2026, 1, 5),
  ),
  AdminUser(
    id: 'user-bima',
    name: 'Bima Sakti',
    email: 'bima.sakti@gmail.com',
    role: 'user',
    plan: 'basic',
    status: AdminUserStatus.inactive,
    createdAt: DateTime(2026, 2, 5),
  ),
  AdminUser(
    id: 'user-najwa',
    name: 'Najwa Putri',
    email: 'najwa.putri@gmail.com',
    role: 'user',
    plan: 'basic',
    status: AdminUserStatus.active,
    createdAt: DateTime(2026, 3, 5),
  ),
  AdminUser(
    id: 'user-siti',
    name: 'Siti Aulia',
    email: 'siti.aulia@gmail.com',
    role: 'user',
    plan: 'premium',
    status: AdminUserStatus.active,
    createdAt: DateTime(2026, 4, 5),
  ),
  AdminUser(
    id: 'user-raka',
    name: 'Raka Pratama',
    email: 'raka.pratama@gmail.com',
    role: 'user',
    plan: 'basic',
    status: AdminUserStatus.active,
    createdAt: DateTime(2026, 5, 5),
  ),
];

final sampleAdminReviews = [
  AdminReview(
    id: 'review-siti',
    userId: 'user-siti',
    decisionTitle: 'Laptop selection',
    createdAt: DateTime.now(),
    rating: 5,
    review: 'The history page is useful.',
  ),
  AdminReview(
    id: 'review-enami',
    userId: 'user-enami',
    decisionTitle: 'Phone selection',
    createdAt: DateTime.now(),
    rating: 5,
    review: 'A helpful experience.',
  ),
  AdminReview(
    id: 'review-bima',
    userId: 'user-bima',
    decisionTitle: 'Study choice',
    createdAt: DateTime.now(),
    rating: 5,
    review: 'Clear and easy to use.',
  ),
  AdminReview(
    id: 'review-najwa',
    userId: 'user-najwa',
    decisionTitle: 'Laptop choice',
    createdAt: DateTime.now(),
    rating: 3,
    review: 'Helpful overall.',
  ),
  AdminReview(
    id: 'review-raka',
    userId: 'user-raka',
    decisionTitle: 'Camera choice',
    createdAt: DateTime.now(),
    rating: 4,
    review: 'Nice comparison.',
  ),
];
