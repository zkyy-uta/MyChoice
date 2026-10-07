import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';

/// Dashboard Screen
/// Main screen after login showing:
/// - User greeting
/// - Create New Decision button
/// - Continue Your Decision (ongoing decisions)
/// - Decision Summary stats
/// - Recent Decisions list
/// - Bottom Navigation Bar
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // TODO: Navigate to different screens based on index
    switch (index) {
      case 0:
        // Home - already here
        break;
      case 1:
        // Decision/Create
        _createNewDecision();
        break;
      case 2:
        // Insight/Analytics
        _showComingSoon('Insight');
        break;
      case 3:
        // History
        _showComingSoon('History');
        break;
      case 4:
        // Profile
        _showComingSoon('Profile');
        break;
    }
  }

  void _createNewDecision() {
    // TODO: Navigate to category selection
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create Decision feature coming soon')),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$feature feature coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            bottom: 100, // Space for bottom nav bar
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
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              Text(
                                'Kim Ryul',
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
                        color: Colors.white.withOpacity(0.8),
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
                child: Text(
                  'Continue Your Decision',
                  style: AppTypography.sectionTitle,
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
                  children: const [
                    _OngoingDecisionCard(
                      category: 'Technology',
                      title: 'Laptop',
                      subtitle: '(3 Choice dan 5 Criteria)',
                      progress: 0.7,
                      color: AppColors.categoryTechnology,
                      icon: Icons.laptop_mac,
                    ),
                    SizedBox(width: AppSpacing.md),
                    _OngoingDecisionCard(
                      category: 'Education',
                      title: 'Course',
                      subtitle: '(3 Choice dan 5 Criteria)',
                      progress: 0.4,
                      color: AppColors.categoryEducation,
                      icon: Icons.school,
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
                      onPressed: () => _showComingSoon('View All'),
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

              // Recent Decisions List
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                ),
                child: Column(
                  children: [
                    _RecentDecisionCard(
                      category: 'Technology',
                      title: 'Laptop',
                      subtitle: 'Lenovo',
                      status: 'Done',
                      icon: Icons.laptop_mac,
                      color: AppColors.categoryTechnology,
                    ),
                    SizedBox(height: AppSpacing.md),
                    _RecentDecisionCard(
                      category: 'Education',
                      title: 'Course',
                      subtitle: 'Data Analyst',
                      status: 'Done',
                      icon: Icons.school,
                      color: AppColors.categoryEducation,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavBarItem(
                  icon: Icons.home,
                  label: 'Home',
                  isSelected: _selectedIndex == 0,
                  onTap: () => _onNavBarTap(0),
                ),
                _NavBarItem(
                  icon: Icons.add_circle_outline,
                  label: 'Decision',
                  isSelected: _selectedIndex == 1,
                  onTap: () => _onNavBarTap(1),
                ),
                _NavBarItem(
                  icon: Icons.bar_chart,
                  label: 'Insight',
                  isSelected: _selectedIndex == 2,
                  onTap: () => _onNavBarTap(2),
                ),
                _NavBarItem(
                  icon: Icons.history,
                  label: 'History',
                  isSelected: _selectedIndex == 3,
                  onTap: () => _onNavBarTap(3),
                ),
                _NavBarItem(
                  icon: Icons.person_outline,
                  label: 'Profile',
                  isSelected: _selectedIndex == 4,
                  onTap: () => _onNavBarTap(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== DASHBOARD WIDGETS ====================

/// Nav Bar Item Widget
class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary88 : AppColors.textTertiary,
              size: AppSpacing.iconMd,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.extraSmallSemibold.copyWith(
                color: isSelected
                    ? AppColors.primary88
                    : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ongoing Decision Card Widget
class _OngoingDecisionCard extends StatelessWidget {
  final String category;
  final String title;
  final String subtitle;
  final double progress;
  final Color color;
  final IconData icon;

  const _OngoingDecisionCard({
    required this.category,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ), // BIGGER ICON: 32 (was 20)
              ),
              const Spacer(),
              Text(
                '${(progress * 100).toInt()}%',
                style: AppTypography.sectionInnerTitle.copyWith(color: color),
              ),
            ],
          ),
          const Spacer(),
          Text(
            category,
            style: AppTypography.small.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(title, style: AppTypography.sectionInnerTitle),
          Text(
            subtitle,
            style: AppTypography.small.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: AppColors.grey200,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  children: [
                    Text(
                      'Continue',
                      style: AppTypography.smallSemibold.copyWith(color: color),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 14, color: color),
                  ],
                ),
              ),
            ],
          ),
        ],
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
        color: color.withOpacity(0.1),
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

  const _RecentDecisionCard({
    required this.category,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
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
              color: color.withOpacity(0.1),
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
    );
  }
}
