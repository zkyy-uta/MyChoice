import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/bottom_navigation.dart';
import '../../../core/widgets/mobile_background.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _deleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus akun?'),
        content: const Text(
          'Akun dan data keputusan yang terkait akan dihapus permanen. '
          'Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error80),
            child: const Text('Hapus akun'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final auth = context.read<AuthProvider>();
    await auth.deleteAccount();
    if (!context.mounted) return;

    if (auth.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(auth.error!)));
      return;
    }

    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  void _onNavigationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/dashboard');
      case 1:
        Navigator.of(context).pushNamed('/create-decision');
      case 2:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Insight feature coming soon')),
        );
      case 3:
        Navigator.of(context).pushNamed('/history');
      case 4:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('My Profile', style: AppTypography.sectionInnerTitle),
        centerTitle: true,
      ),
      body: MobileBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal,
            AppSpacing.lg,
            AppSpacing.screenHorizontal,
            AppSpacing.xl,
          ),
          children: [
            const Center(
              child: CircleAvatar(
                radius: 42,
                backgroundColor: AppColors.primary20,
                child: Icon(
                  Icons.person,
                  size: 44,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Center(
              child: Text(
                user?.name ?? '',
                style: AppTypography.sectionInnerTitle,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Center(child: Text(user?.email ?? '', style: AppTypography.small)),
            const SizedBox(height: AppSpacing.xl),
            _ProfileSection(
              title: 'ACCOUNT',
              children: [
                _ProfileOption(
                  icon: Icons.person_outline,
                  title: 'Personal Information',
                  onTap: () => Navigator.of(
                    context,
                  ).pushNamed('/profile/personal-information'),
                ),
                _ProfileOption(
                  icon: Icons.shield_outlined,
                  title: 'Security',
                  onTap: () =>
                      Navigator.of(context).pushNamed('/profile/security'),
                ),
                _ProfileOption(
                  icon: Icons.workspace_premium_outlined,
                  title: 'Premium Plan',
                  onTap: () =>
                      Navigator.of(context).pushNamed('/profile/premium-plan'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _ProfileSection(
              title: 'PREFERENCES',
              children: [
                _ProfileOption(
                  icon: Icons.notifications_outlined,
                  title: 'Notification',
                  onTap: () =>
                      Navigator.of(context).pushNamed('/profile/notifications'),
                ),
                _ProfileOption(
                  icon: Icons.translate,
                  title: 'Language',
                  onTap: () =>
                      Navigator.of(context).pushNamed('/profile/language'),
                ),
                const _UnavailableProfileOption(
                  icon: Icons.palette_outlined,
                  title: 'Appearance',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _ProfileSection(
              title: 'DATA & PRIVACY',
              children: [
                _ProfileOption(
                  icon: Icons.analytics_outlined,
                  title: 'My Decision Data',
                  onTap: () => Navigator.of(
                    context,
                  ).pushNamed('/profile/my-decision-data'),
                ),
                _ProfileOption(
                  icon: Icons.delete_outline,
                  title: 'Delete Account',
                  iconColor: AppColors.error80,
                  onTap: () => _deleteAccount(context),
                ),
              ],
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
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 4,
        onSelected: (index) => _onNavigationSelected(context, index),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.xs,
            bottom: AppSpacing.sm,
          ),
          child: Text(
            title,
            style: AppTypography.extraSmallSemibold.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor = AppColors.primaryDark,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor, size: AppSpacing.iconSm),
      title: Text(title, style: AppTypography.small),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      dense: true,
    );
  }
}

class _UnavailableProfileOption extends StatelessWidget {
  const _UnavailableProfileOption({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.primaryDark,
        size: AppSpacing.iconSm,
      ),
      title: Text(title, style: AppTypography.small),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      dense: true,
    );
  }
}
