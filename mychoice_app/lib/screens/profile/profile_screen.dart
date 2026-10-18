import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/bottom_navigation.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('My Profile', style: AppTypography.sectionInnerTitle),
        centerTitle: true,
      ),
      body: ListView(
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
              child: Icon(Icons.person, size: 44, color: AppColors.primaryDark),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Text('Kim Ryul', style: AppTypography.sectionInnerTitle),
          ),
          const SizedBox(height: AppSpacing.xs),
          Center(
            child: Text('kimryul4sho@gmail.com', style: AppTypography.small),
          ),
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
              const _UnavailableProfileOption(
                icon: Icons.delete_outline,
                title: 'Delete Account',
                iconColor: AppColors.error80,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: TextButton.icon(
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed('/login'),
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
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
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

class _UnavailableProfileOption extends StatelessWidget {
  const _UnavailableProfileOption({
    required this.icon,
    required this.title,
    this.iconColor = AppColors.primaryDark,
  });

  final IconData icon;
  final String title;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor, size: AppSpacing.iconSm),
      title: Text(title, style: AppTypography.small),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      dense: true,
    );
  }
}
