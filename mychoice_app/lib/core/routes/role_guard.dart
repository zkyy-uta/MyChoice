import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/domain/entities/user.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../theme/app_colors.dart';

class RoleGuard extends StatefulWidget {
  const RoleGuard({required this.builder, this.adminOnly = false, super.key});

  final WidgetBuilder builder;
  final bool adminOnly;

  @override
  State<RoleGuard> createState() => _RoleGuardState();
}

class _RoleGuardState extends State<RoleGuard> {
  late final Future<void> _authorizationCheck;
  bool _redirectingToLogin = false;

  @override
  void initState() {
    super.initState();
    _authorizationCheck = Future<void>.delayed(Duration.zero, () {
      if (mounted) return context.read<AuthProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _authorizationCheck,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Consumer<AuthProvider>(
          builder: (context, auth, _) {
            if (auth.state == AuthState.initial ||
                auth.state == AuthState.loading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!auth.isAuthenticated) {
              if (!_redirectingToLogin) {
                _redirectingToLogin = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/login', (route) => false);
                });
              }
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final isAdmin = auth.user!.role == UserRole.admin;
            if (widget.adminOnly && !isAdmin) {
              return const _AccessRequired(
                message: 'Halaman ini hanya dapat diakses oleh admin.',
                route: '/dashboard',
                action: 'Ke beranda user',
              );
            }
            if (!widget.adminOnly && isAdmin) {
              return const _AccessRequired(
                message: 'Gunakan halaman admin untuk akun ini.',
                route: '/admin',
                action: 'Ke dashboard admin',
              );
            }

            return widget.builder(context);
          },
        );
      },
    );
  }
}

class _AccessRequired extends StatelessWidget {
  const _AccessRequired({
    required this.message,
    required this.route,
    required this.action,
  });

  final String message;
  final String route;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 48,
                color: AppColors.primaryDark,
              ),
              const SizedBox(height: 16),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(route, (route) => false),
                child: Text(action),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
