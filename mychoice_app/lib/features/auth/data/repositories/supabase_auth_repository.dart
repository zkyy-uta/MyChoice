import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../../core/entities/user_plan.dart';
import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/session.dart' as app_session;
import '../../domain/entities/user.dart' as app_user;
import '../../domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client);

  final supabase.SupabaseClient _client;

  @override
  Future<AuthResult?> getCurrentUser() async {
    final session = await _client.auth.getSession();
    if (session == null) return null;

    final authUser = _client.auth.currentUser;
    if (authUser == null) {
      throw AuthenticationError(message: 'Invalid login session.');
    }

    return AuthResult(
      user: await _loadUser(authUser),
      session: _mapSession(session),
    );
  }

  @override
  Future<AuthResult> login(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
    final authUser = response.user;
    final session = response.session;
    if (authUser == null || session == null) {
      throw AuthenticationError(
        message: 'Login failed. Please check your credentials.',
      );
    }

    try {
      return AuthResult(
        user: await _loadUser(authUser),
        session: _mapSession(session),
      );
    } on Object {
      await _client.auth.signOut();
      rethrow;
    }
  }

  @override
  Future<bool> signInWithGoogle() {
    return _client.auth.signInWithOAuth(
      supabase.OAuthProvider.google,
      redirectTo: kIsWeb ? Uri.base.origin : 'mychoice://login-callback',
    );
  }

  @override
  Future<AuthResult> register(RegistrationData data) async {
    final response = await _client.auth.signUp(
      email: data.email.trim(),
      password: data.password,
      data: {'full_name': data.name.trim()},
    );
    final authUser = response.user;
    if (authUser == null) {
      throw AuthenticationError(
        message: 'Account could not be created. Please try again.',
      );
    }

    final session = response.session;
    return AuthResult(
      user: session == null
          ? _mapUnconfirmedUser(authUser)
          : await _loadUser(authUser),
      session: session == null ? null : _mapSession(session),
    );
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    // Sends a recovery OTP / code to user email using Supabase password recovery
    await _client.auth.resetPasswordForEmail(email.trim());
  }

  @override
  Future<void> verifyPasswordResetCode(String email, String code) async {
    await _client.auth.verifyOTP(
      email: email.trim(),
      token: code.trim(),
      type: supabase.OtpType.recovery,
    );
  }

  @override
  Future<void> updatePassword(String password) async {
    await _client.auth.updateUser(supabase.UserAttributes(password: password));
    await _client.auth.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    await _client.functions.invoke('delete-account');
    await _client.auth.signOut();
  }

  @override
  Future<void> logout() => _client.auth.signOut();

  Future<app_user.User> _loadUser(supabase.User authUser) async {
    final profile = await _client
        .from('users')
        .select('nama, role, plan, status_akun, tanggal_dibuat')
        .eq('id_pengguna', authUser.id)
        .maybeSingle();
    if (profile == null) {
      throw AuthenticationError(
        message: 'Your account profile is missing. Please contact support.',
      );
    }
    if (profile['status_akun'] != 'aktif') {
      await _client.auth.signOut();
      throw AuthenticationError(
        message: 'This account has been deactivated. Contact an administrator.',
      );
    }

    final isAdmin = profile['role'] == 'admin';
    final isPremium = profile['plan'] == 'premium';
    final planTier = isAdmin
        ? UserPlanTier.admin
        : isPremium
        ? UserPlanTier.premium
        : UserPlanTier.basic;
    final userRole = isAdmin
        ? app_user.UserRole.admin
        : isPremium
        ? app_user.UserRole.premium
        : app_user.UserRole.basic;

    return app_user.User(
      id: authUser.id,
      email: authUser.email ?? '',
      name: (profile['nama'] as String?) ?? '',
      role: userRole,
      plan: UserPlan.forTier(planTier),
      createdAt:
          DateTime.tryParse(profile['tanggal_dibuat'] as String? ?? '') ??
          DateTime.tryParse(authUser.createdAt) ??
          DateTime.now(),
    );
  }

  app_user.User _mapUnconfirmedUser(supabase.User authUser) {
    final metadata = authUser.userMetadata ?? const <String, dynamic>{};

    return app_user.User(
      id: authUser.id,
      email: authUser.email ?? '',
      name: (metadata['full_name'] as String?) ?? '',
      role: app_user.UserRole.basic,
      plan: UserPlan.forTier(UserPlanTier.basic),
      createdAt: DateTime.parse(authUser.createdAt),
    );
  }

  app_session.Session _mapSession(supabase.Session session) {
    final now = DateTime.now();
    final expiresAt = session.expiresAt == null
        ? now.add(Duration(seconds: session.expiresIn ?? 3600))
        : DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000);

    return app_session.Session(
      token: session.accessToken,
      refreshToken: session.refreshToken,
      expiresAt: expiresAt,
      createdAt: now,
    );
  }
}
