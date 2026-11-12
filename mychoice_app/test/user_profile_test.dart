import 'package:flutter_test/flutter_test.dart';

import 'package:mychoice_app/features/user_profile/data/models/user_profile_model.dart';
import 'package:mychoice_app/features/user_profile/domain/entities/user_profile.dart';
import 'package:mychoice_app/features/user_profile/domain/repositories/user_profile_repository.dart';
import 'package:mychoice_app/features/user_profile/presentation/providers/user_profile_provider.dart';

class MockUserProfileRepository implements UserProfileRepository {
  UserProfile? _profile;
  bool shouldFail = false;
  String? failureMessage;

  @override
  Future<UserProfile> getUserProfile() async {
    if (shouldFail) throw Exception(failureMessage ?? 'load profile failed');
    return _profile ??
        UserProfile(
          id: 'user_1',
          name: 'Budi Santoso',
          email: 'budi@example.com',
          role: 'user',
          plan: 'basic',
          createdAt: DateTime(2026, 10, 1),
        );
  }

  @override
  Future<UserProfile> updateProfile({required String name}) async {
    if (shouldFail) throw Exception(failureMessage ?? 'update profile failed');
    _profile = UserProfile(
      id: _profile?.id ?? 'user_1',
      name: name,
      email: _profile?.email ?? 'budi@example.com',
      role: _profile?.role ?? 'user',
      plan: _profile?.plan ?? 'basic',
      createdAt: _profile?.createdAt ?? DateTime.now(),
    );
    return _profile!;
  }

  @override
  Future<bool> isAdmin() async {
    if (shouldFail) throw Exception(failureMessage ?? 'isAdmin failed');
    return _profile?.role == 'admin';
  }

  @override
  Future<bool> isPremium() async {
    if (shouldFail) throw Exception(failureMessage ?? 'isPremium failed');
    return _profile?.plan == 'premium';
  }

  @override
  Future<UserProfile> updateRoleAndPlan({
    required String targetUserId,
    String? role,
    String? plan,
  }) async {
    if (shouldFail) throw Exception(failureMessage ?? 'update role/plan failed');
    _profile = UserProfile(
      id: targetUserId,
      name: _profile?.name ?? 'User',
      email: _profile?.email ?? 'user@example.com',
      role: role ?? _profile?.role ?? 'user',
      plan: plan ?? _profile?.plan ?? 'basic',
      createdAt: _profile?.createdAt ?? DateTime.now(),
    );
    return _profile!;
  }
}

void main() {
  group('UserProfileModel', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'id_pengguna': 'user_1',
        'nama': 'Budi Santoso',
        'email': 'budi@example.com',
        'role': 'user',
        'plan': 'basic',
        'tanggal_dibuat': '2026-10-01T00:00:00Z',
      };

      final model = UserProfileModel.fromJson(json);

      expect(model.id, 'user_1');
      expect(model.name, 'Budi Santoso');
      expect(model.email, 'budi@example.com');
      expect(model.role, 'user');
      expect(model.plan, 'basic');
    });

    test('fromJson defaults missing fields', () {
      final model = UserProfileModel.fromJson({'id_pengguna': 'user_1'});

      expect(model.name, '');
      expect(model.email, '');
      expect(model.role, 'user');
      expect(model.plan, 'basic');
    });

    test('toEntity preserves all fields', () {
      final model = UserProfileModel(
        id: 'user_1',
        name: 'Budi',
        email: 'budi@example.com',
        role: 'admin',
        plan: 'premium',
        createdAt: DateTime(2026, 10, 1),
      );
      final entity = model.toEntity();

      expect(entity.id, model.id);
      expect(entity.name, model.name);
      expect(entity.role, model.role);
      expect(entity.plan, model.plan);
      expect(entity.isAdmin, true);
      expect(entity.isPremium, true);
    });

    test('isAdmin returns true for admin role', () {
      final entity = UserProfile(
        id: 'x', name: 'A', email: 'a@b.com', role: 'admin', plan: 'basic',
        createdAt: DateTime.now(),
      );
      expect(entity.isAdmin, true);
    });

    test('isAdmin returns false for user role', () {
      final entity = UserProfile(
        id: 'x', name: 'A', email: 'a@b.com', role: 'user', plan: 'basic',
        createdAt: DateTime.now(),
      );
      expect(entity.isAdmin, false);
    });

    test('isPremium returns true for premium plan', () {
      final entity = UserProfile(
        id: 'x', name: 'A', email: 'a@b.com', role: 'user', plan: 'premium',
        createdAt: DateTime.now(),
      );
      expect(entity.isPremium, true);
    });

    test('isPremium returns false for basic plan', () {
      final entity = UserProfile(
        id: 'x', name: 'A', email: 'a@b.com', role: 'user', plan: 'basic',
        createdAt: DateTime.now(),
      );
      expect(entity.isPremium, false);
    });
  });

  group('UserProfileProvider', () {
    late MockUserProfileRepository mockRepository;
    late UserProfileProvider provider;

    setUp(() {
      mockRepository = MockUserProfileRepository();
      provider = UserProfileProvider(repository: mockRepository);
    });

    test('loadProfile populates profile', () async {
      await provider.loadProfile();

      expect(provider.profile, isNotNull);
      expect(provider.profile!.name, 'Budi Santoso');
      expect(provider.isLoading, false);
      expect(provider.error, null);
      expect(provider.isAdmin, false);
      expect(provider.isPremium, false);
    });

    test('loadProfile sets error on failure', () async {
      mockRepository.shouldFail = true;
      mockRepository.failureMessage = 'DB down';

      await provider.loadProfile();

      expect(provider.profile, null);
      expect(provider.isLoading, false);
      expect(provider.error, isNotNull);
      expect(provider.error!.contains('DB down'), true);
    });

    test('updateName updates profile locally', () async {
      await provider.loadProfile();
      final success = await provider.updateName('Budi Updated');

      expect(success, true);
      expect(provider.profile!.name, 'Budi Updated');
    });

    test('updateName returns false on failure', () async {
      mockRepository.shouldFail = true;

      final success = await provider.updateName('Budi Updated');

      expect(success, false);
      expect(provider.error, isNotNull);
    });

    test('isAdmin and isPremium reflect profile', () async {
      mockRepository._profile = UserProfile(
        id: 'user_1', name: 'Admin', email: 'admin@example.com',
        role: 'admin', plan: 'premium', createdAt: DateTime(2026, 10, 1),
      );
      await provider.loadProfile();

      expect(provider.isAdmin, true);
      expect(provider.isPremium, true);
    });

    test('updateRoleAndPlan updates profile', () async {
      await provider.loadProfile();
      final success = await provider.updateRoleAndPlan(
        targetUserId: 'user_1',
        role: 'admin',
        plan: 'premium',
      );

      expect(success, true);
      expect(provider.profile!.role, 'admin');
      expect(provider.profile!.plan, 'premium');
    });

    test('clearError clears error state', () async {
      mockRepository.shouldFail = true;
      await provider.loadProfile();
      expect(provider.error, isNotNull);

      provider.clearError();
      expect(provider.error, null);
    });
  });
}
