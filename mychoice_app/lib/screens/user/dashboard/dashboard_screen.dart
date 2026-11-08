import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/bottom_navigation.dart';
import '../history/history_sample_data.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  void _createNewDecision() {
    Navigator.of(context).pushNamed('/create-decision');
  }

  void _continueDecision(String title) {
    Navigator.of(context).pushNamed('/continue-decision', arguments: title);
  }

  void _onNavigation(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        _createNewDecision();
        break;
      case 2:
        Navigator.of(context).pushNamed('/insight');
        break;
      case 3:
        Navigator.of(context).pushNamed('/history');
        break;
      case 4:
        Navigator.of(context).pushNamed('/profile');
        break;
    }
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$feature feature coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    final userName = context.watch<AuthProvider>().user?.name.trim();

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            bottom: 0, // Space for bottom nav bar
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
                decoration: const BoxDecoration(
                  gradient: AppColors.backgroundGradient,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Greeting
                    Row(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white,
                          backgroundImage: const NetworkImage(
                            'avatar_default.jpeg',
                          ),
                          onBackgroundImageError: (exception, stackTrace) {},
                          child: const Icon(
                            Icons.person,
                            color: AppColors.primary88,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello!',
                                style: AppTypography.body.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                              Text(
                                userName == null || userName.isEmpty
                                    ? 'User'
                                    : userName,
                                style: AppTypography.sectionTitle.copyWith(
                                  color: AppColors.textWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Notification Icon
                        IconButton(
                          onPressed: () => _showComingSoon('Notifications'),
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Tagline
                    Text(
                      'Ready to make a better choice?',
                      style: AppTypography.body.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.screenHorizontal),

              // Create New Decision Button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    onPressed: _createNewDecision,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                    ),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: Text(
                      'Create New Decision',
                      style: AppTypography.buttonLarge,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Continue Your Decision Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Continue Your Decision',
                      style: AppTypography.sectionTitle,
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/continue-decision'),
                      child: Text(
                        'View All',
                        style: AppTypography.buttonMedium.copyWith(
                          color: AppColors.primary88,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Ongoing Decisions Horizontal List
              SizedBox(
                height: 160,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontal,
                  ),
                  scrollDirection: Axis.horizontal,
                  children: [
                    _OngoingDecisionCard(
                      category: 'Technology',
                      title: 'Laptop',
                      subtitle: '(3 choices, 5 criteria)',
                      progress: 0.7,
                      color: AppColors.categoryTechnology,
                      icon: Icons.laptop_mac,
                      onTap: () => _continueDecision('Laptop'),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    _OngoingDecisionCard(
                      category: 'Education',
                      title: 'Course',
                      subtitle: '(3 choices, 5 criteria)',
                      progress: 0.4,
                      color: AppColors.categoryEducation,
                      icon: Icons.school,
                      onTap: () => _continueDecision('Course'),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    _OngoingDecisionCard(
                      category: 'Technology',
                      title: 'Smartphone',
                      subtitle: '(3 choices, 5 criteria)',
                      progress: 0.85,
                      color: AppColors.categoryTechnology,
                      icon: Icons.smartphone,
                      onTap: () => _continueDecision('Smartphone'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Decision Summary Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                ),
                child: Text(
                  'Decision Summary',
                  style: AppTypography.sectionTitle,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Summary Stats
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        count: '12',
                        label: 'Decision',
                        color: AppColors.primary88,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _SummaryCard(
                        count: '8',
                        label: 'What-If',
                        color: AppColors.categoryEducation,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _SummaryCard(
                        count: '6',
                        label: 'Review',
                        color: AppColors.categoryFashion,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Recent Decision Section
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Decision', style: AppTypography.sectionTitle),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/history'),
                      child: Text(
                        'View All',
                        style: AppTypography.buttonMedium.copyWith(
                          color: AppColors.primary88,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Recent Decisions List (dynamically from shared decision history)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                ),
                child: Column(
                  children: historySampleDecisions.take(3).map((decision) {
                    final Color cardColor;
                    final IconData cardIcon;
                    switch (decision.category.toLowerCase()) {
                      case 'education':
                        cardColor = AppColors.categoryEducation;
                        cardIcon = Icons.school;
                        break;
                      case 'fashion':
                        cardColor = AppColors.categoryFashion;
                        cardIcon = Icons.checkroom;
                        break;
                      default:
                        cardColor = AppColors.categoryTechnology;
                        cardIcon = Icons.laptop_mac;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _RecentDecisionCard(
                        category: decision.category,
                        title: decision.title,
                        subtitle:
                            'Score: ${(decision.score * 100).toInt()}% · ${decision.dateGroup}',
                        status: decision.status,
                        icon: cardIcon,
                        color: cardColor,
                        onTap: () =>
                            Navigator.of(context).pushNamed('/history'),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigation(
        selectedIndex: 0,
        onSelected: _onNavigation,
      ),
    );
  }
}

// ==================== DASHBOARD WIDGETS ====================

/// Ongoing Decision Card Widget
class _OngoingDecisionCard extends StatelessWidget {
  final String category;
  final String title;
  final String subtitle;
  final double progress;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  const _OngoingDecisionCard({
    required this.category,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.color,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const Spacer(),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: AppTypography.sectionInnerTitle.copyWith(
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                category,
                style: AppTypography.small.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: AppTypography.sectionInnerTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: AppTypography.small.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        minHeight: 6,
                        backgroundColor: AppColors.grey200,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Icon(Icons.arrow_forward, size: 18, color: color),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Summary Card Widget
class _SummaryCard extends StatelessWidget {
  final String count;
  final String label;
  final Color color;

  const _SummaryCard({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(
              child: Text(
                count,
                style: AppTypography.sectionTitle.copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: AppTypography.sectionInnerTitle),
        ],
      ),
    );
  }
}

/// Recent Decision Card Widget
class _RecentDecisionCard extends StatelessWidget {
  final String category;
  final String title;
  final String subtitle;
  final String status;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _RecentDecisionCard({
    required this.category,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ), // BIGGER ICON: 32 (was 24)
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$category - $title',
                      style: AppTypography.sectionInnerTitle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTypography.small.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success20,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: AppTypography.smallSemibold.copyWith(
                    color: AppColors.success80,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
