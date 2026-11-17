import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/entities/user_plan.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/mobile_background.dart';
import '../../../core/widgets/page_app_bar.dart';
import '../../../features/auth/presentation/providers/auth_provider.dart';

class PremiumPlanScreen extends StatelessWidget {
  const PremiumPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userPlan = context.watch<AuthProvider>().user?.plan;
    final isPremium =
        userPlan?.tier == UserPlanTier.premium ||
        userPlan?.tier == UserPlanTier.admin;
    return MobileBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const PageAppBar(title: 'Premium Plan'),
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
          children: [
            Text('Your Current Plan', style: AppTypography.sectionInnerTitle),
            const SizedBox(height: AppSpacing.md),
            _PlanCard(
              title: isPremium ? 'PREMIUM PLAN' : 'BASIC PLAN',
              description: isPremium
                  ? 'Unlimited decisions'
                  : '1 saved decision per day',
              actionLabel: 'Current plan',
              onPressed: null,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Your Benefits', style: AppTypography.sectionInnerTitle),
            const SizedBox(height: AppSpacing.sm),
            if (isPremium) ...const [
              _Benefit(text: 'Unlimited saved decisions'),
              _Benefit(text: 'Up to 10 choices per decision'),
              _Benefit(text: 'Premium-only decision insights'),
            ] else ...const [
              _Benefit(text: '1 saved decision per day (WIB)'),
              _Benefit(text: 'Up to 3 choices per decision'),
              _Benefit(text: 'Decision history and review'),
            ],
            const SizedBox(height: AppSpacing.xl),
            if (!isPremium)
              _PlanCard(
                title: 'UPGRADE TO PREMIUM',
                description:
                    'Unlimited decisions\nUp to 10 choices per decision\n'
                    'Premium-only insights',
                actionLabel: 'Upgrade Now',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Premium payments are not available yet. '
                        'Please contact an administrator.',
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
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
