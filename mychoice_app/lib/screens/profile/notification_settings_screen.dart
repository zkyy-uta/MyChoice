import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _decisionReminders = true;
  bool _weeklySummary = false;
  bool _productUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('Notification', style: AppTypography.sectionInnerTitle),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        children: [
          Text(
            'Notification Preferences',
            style: AppTypography.sectionInnerTitle,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Choose which notifications you would like to receive.',
            style: AppTypography.small.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          _NotificationToggle(
            title: 'Decision reminders',
            subtitle: 'Get reminders about decisions you are working on.',
            value: _decisionReminders,
            onChanged: (value) => setState(() => _decisionReminders = value),
          ),
          _NotificationToggle(
            title: 'Weekly summary',
            subtitle: 'Receive a summary of your decision activity.',
            value: _weeklySummary,
            onChanged: (value) => setState(() => _weeklySummary = value),
          ),
          _NotificationToggle(
            title: 'Product updates',
            subtitle: 'Hear about new features and improvements.',
            value: _productUpdates,
            onChanged: (value) => setState(() => _productUpdates = value),
          ),
        ],
      ),
    );
  }
}

class _NotificationToggle extends StatelessWidget {
  const _NotificationToggle({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Text(title, style: AppTypography.smallSemibold),
        subtitle: Text(
          subtitle,
          style: AppTypography.extraSmallSemibold.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        activeTrackColor: AppColors.primary88,
      ),
    );
  }
}
