import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class MyDecisionDataScreen extends StatelessWidget {
  const MyDecisionDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('My Decision Data', style: AppTypography.sectionInnerTitle),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        children: [
          Text('Your Activity', style: AppTypography.sectionInnerTitle),
          const SizedBox(height: AppSpacing.md),
          const _DataSummaryCard(
            icon: Icons.checklist_outlined,
            title: 'Decisions created',
            value: '12',
          ),
          const _DataSummaryCard(
            icon: Icons.category_outlined,
            title: 'Most used category',
            value: 'Technology',
          ),
          const _DataSummaryCard(
            icon: Icons.schedule_outlined,
            title: 'Last decision',
            value: 'Laptop',
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Your decisions are stored in your account so you can review them later.',
            style: AppTypography.small.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _DataSummaryCard extends StatelessWidget {
  const _DataSummaryCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        leading: Icon(icon, color: AppColors.primaryDark),
        title: Text(title, style: AppTypography.small),
        trailing: Text(value, style: AppTypography.smallSemibold),
      ),
    );
  }
}
