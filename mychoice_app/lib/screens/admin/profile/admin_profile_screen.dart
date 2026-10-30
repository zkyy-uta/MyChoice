import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/admin_bottom_navigation.dart';
import '../../../core/widgets/mobile_background.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Admin Profile', style: AppTypography.sectionInnerTitle),
        centerTitle: true,
      ),
      body: MobileBackground(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
          children: [
            const SizedBox(height: AppSpacing.md),
            const Center(
              child: CircleAvatar(
                radius: 42,
                backgroundColor: AppColors.primary20,
                child: Icon(
                  Icons.admin_panel_settings_outlined,
                  size: 44,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Center(
              child: Text(
                user?.name.isNotEmpty == true ? user!.name : 'Admin',
                style: AppTypography.sectionInnerTitle,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Center(child: Text(user?.email ?? '', style: AppTypography.small)),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'ACCOUNT',
              style: AppTypography.extraSmallSemibold.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              child: ListTile(
                onTap: () => Navigator.of(
                  context,
                ).pushNamed('/admin/profile/personal-information'),
                leading: const Icon(
                  Icons.person_outline,
                  color: AppColors.primaryDark,
                ),
                title: Text('Personal Information', style: AppTypography.small),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Center(
              child: TextButton.icon(
                onPressed: () async {
                  final auth = context.read<AuthProvider>();
                  await auth.logout();
                  if (!context.mounted) return;
                  if (auth.error != null) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(auth.error!)));
                    return;
                  }
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/login', (route) => false);
                },
                icon: const Icon(Icons.logout, color: AppColors.error80),
                label: Text(
                  'Log out',
                  style: AppTypography.buttonMedium.copyWith(
                    color: AppColors.error80,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNavigation(selectedIndex: 4),
    );
  }
}
