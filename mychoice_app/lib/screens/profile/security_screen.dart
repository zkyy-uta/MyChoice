import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _twoFactorEnabled = false;

  Future<void> _showChangePasswordDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Password', style: AppTypography.sectionInnerTitle),
        content: TextField(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'New password',
            prefixIcon: Icon(Icons.lock_outline),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('Security', style: AppTypography.sectionInnerTitle),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        children: [
          Text('Account Security', style: AppTypography.sectionInnerTitle),
          const SizedBox(height: AppSpacing.md),
          _SecurityTile(
            icon: Icons.key_outlined,
            title: 'Change Password',
            trailing: const Icon(Icons.chevron_right),
            onTap: _showChangePasswordDialog,
          ),
          const SizedBox(height: AppSpacing.sm),
          const _SecurityTile(
            icon: Icons.mark_email_read_outlined,
            title: 'Email Verification',
            subtitle: 'Your email is verified.',
            trailing: Icon(Icons.check, color: AppColors.success80),
          ),
          const SizedBox(height: AppSpacing.sm),
          _SecurityTile(
            icon: Icons.verified_user_outlined,
            title: 'Two-Factor Authentication',
            trailing: Switch(
              value: _twoFactorEnabled,
              onChanged: (value) => setState(() => _twoFactorEnabled = value),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _SecurityTile(
            icon: Icons.devices_outlined,
            title: 'Active Sessions',
            subtitle: 'Manage devices logged into your account.',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You are signed in on this device')),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityTile extends StatelessWidget {
  const _SecurityTile({
    required this.icon,
    required this.title,
    required this.trailing,
    this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.primaryDark),
        title: Text(title, style: AppTypography.smallSemibold),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle!,
                style: AppTypography.extraSmallSemibold.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
        trailing: trailing,
      ),
    );
  }
}
