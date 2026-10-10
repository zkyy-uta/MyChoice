import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class HistoryDecision {
  const HistoryDecision({
    required this.category,
    required this.title,
    required this.score,
    required this.dateGroup,
    required this.date,
    required this.recordedAt,
    this.priorities = const {
      'Price': 30,
      'Performance': 35,
      'Battery': 20,
      'Storage': 15,
    },
    this.status = 'Decision Made',
    this.review = 'Performance sesuai dengan kebutuhan.',
    this.rating = 5,
  });

  final String category;
  final String title;
  final double score;
  final String dateGroup;
  final String date;
  final DateTime recordedAt;
  final Map<String, int> priorities;
  final String status;
  final String review;
  final int rating;

  IconData get icon => switch (category) {
    'Technology' => Icons.laptop_mac_rounded,
    'Education' || 'Internship' => Icons.school_rounded,
    'Fashion' => Icons.checkroom_rounded,
    _ => Icons.category_rounded,
  };
}

class HistoryDetailScreen extends StatelessWidget {
  const HistoryDetailScreen({required this.decision, super.key});

  final HistoryDecision decision;

  void _onNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed('/dashboard');
      case 1:
        Navigator.of(context).pushNamed('/create-decision');
      case 2:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Insight feature coming soon')),
        );
      case 3:
        Navigator.of(context).maybePop();
      case 4:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile feature coming soon')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _HistoryHeader(title: 'Decision Detail'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.lg,
                  AppSpacing.screenHorizontal,
                  120,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(decision.icon, color: AppColors.primaryDark),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          decision.category,
                          style: AppTypography.oneLinerSemibold.copyWith(
                            color: AppColors.textPurple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(decision.title, style: AppTypography.small),
                    const SizedBox(height: AppSpacing.md),
                    _DetailSection(
                      title: 'Decision Date',
                      child: Text(decision.date, style: AppTypography.small),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _DetailSection(
                      title: 'Final Score',
                      child: Text(
                        'Score: ${decision.score.toStringAsFixed(2)}',
                        style: AppTypography.small,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _DetailSection(
                      title: 'Your Priorities',
                      child: Column(
                        children: decision.priorities.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    entry.key,
                                    style: AppTypography.small,
                                  ),
                                ),
                                Text(
                                  '${entry.value}%',
                                  style: AppTypography.small,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _DetailSection(
                      title: 'Decision Status',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 15,
                            color: AppColors.primary88,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(decision.status, style: AppTypography.small),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Divider(color: AppColors.grey400),
                    const SizedBox(height: AppSpacing.md),
                    _DetailSection(
                      title: 'Your Review',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (index) => Icon(
                                Icons.star_rounded,
                                size: 18,
                                color: index < decision.rating
                                    ? AppColors.warning80
                                    : AppColors.grey300,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            decision.review,
                            style: AppTypography.small.copyWith(
                              color: AppColors.textPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: DecisionBottomNavigation(
      //   selectedIndex: 3,
      //   onSelected: (index) => _onNavigation(context, index),
      // ),
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      child: Row(
        children: [
          SizedBox(
            width: 42,
            child: IconButton(
              tooltip: 'Back',
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.textPurple,
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.sectionInnerTitle.copyWith(
                color: AppColors.textPurple,
              ),
            ),
          ),
          const SizedBox(width: 42),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.oneLinerSemibold.copyWith(
            color: AppColors.textPurple,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        child,
      ],
    );
  }
}
