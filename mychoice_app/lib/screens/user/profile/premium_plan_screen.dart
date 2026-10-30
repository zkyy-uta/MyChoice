import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class PremiumPlanScreen extends StatelessWidget {
  const PremiumPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('Premium Plan', style: AppTypography.sectionInnerTitle),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        children: [
          Text('Your Current Plan', style: AppTypography.sectionInnerTitle),
          const SizedBox(height: AppSpacing.md),
          _PlanCard(
            title: 'FREE PLAN',
            description: '1 decision per day',
            actionLabel: 'Current plan',
            onPressed: null,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Your Benefits', style: AppTypography.sectionInnerTitle),
          const SizedBox(height: AppSpacing.sm),
          const _Benefit(text: '1 decision per day'),
          const _Benefit(text: 'Up to 3 choices per decision'),
          const _Benefit(text: 'Basic decision analysis'),
          const _Benefit(text: 'What-if simulation'),
          const _Benefit(text: 'Decision review'),
          const SizedBox(height: AppSpacing.xl),
          _PlanCard(
            title: 'UPGRADE TO PREMIUM',
            description:
                'Unlimited decisions\nUp to 10 choices per decision\n'
                'Personal decision pattern\nAdvanced insights',
            actionLabel: 'Upgrade Now',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Premium subscriptions are coming soon'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onPressed,
  });

  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLarge),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              style: AppTypography.sectionInnerTitle.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: AppTypography.small.copyWith(height: 1.7),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: ElevatedButton(
              onPressed: onPressed,
              child: Text(actionLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColors.primaryDark,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(text, style: AppTypography.small),
        ],
      ),
    );
  }
}
