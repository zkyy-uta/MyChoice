import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/admin_user.dart';
import '../../../features/admin_analytics/presentation/providers/admin_analytics_provider.dart';
import '../../../features/admin_user_management/presentation/providers/admin_user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/admin_bottom_navigation.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AdminUserProvider>().loadUsers();
      context.read<AdminAnalyticsProvider>().loadReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider = context.watch<AdminUserProvider>();
    final analyticsProvider = context.watch<AdminAnalyticsProvider>();
    final users = usersProvider.users;
    final reviews = analyticsProvider.reviews;
    final months = _monthlyCounts(users);

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                decoration: const BoxDecoration(
                  gradient: AppColors.backgroundGradient,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white.withValues(alpha: .9),
                          child: const Icon(
                            Icons.admin_panel_settings_outlined,
                            color: AppColors.primaryDark,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello!',
                                style: AppTypography.body.copyWith(
                                  color: Colors.white.withValues(alpha: .85),
                                ),
                              ),
                              Text(
                                'Admin',
                                style: AppTypography.sectionTitle.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No new notifications'),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            icon: Icons.people_alt_outlined,
                            label: 'Total Users',
                            value: usersProvider.isLoading
                                ? '...'
                                : '${users.length}',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SummaryCard(
                            icon: Icons.rate_review_outlined,
                            label: 'Reviews',
                            value: analyticsProvider.isLoading
                                ? '...'
                                : '${reviews.length}',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (usersProvider.error != null || analyticsProvider.error != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          usersProvider.error ?? analyticsProvider.error!,
                          style: AppTypography.extraSmallSemibold.copyWith(
                            color: AppColors.error80,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          usersProvider.loadUsers();
                          analyticsProvider.loadReviews();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'New User Activity',
                      style: AppTypography.smallSemibold,
                    ),
                    Text(
                      'New users · monthly',
                      style: AppTypography.extraSmallSemibold.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 174,
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowLight,
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: _ActivityChart(
                    labels: months.map((item) => item.$1).toList(),
                    counts: months.map((item) => item.$2).toList(),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Users', style: AppTypography.smallSemibold),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/admin/users'),
                      child: Text(
                        'View All',
                        style: AppTypography.extraSmallSemibold.copyWith(
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              sliver: SliverList.builder(
                itemCount: users.take(3).length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _RecentUserTile(user: users[index]),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNavigation(selectedIndex: 0),
    );
  }

  List<(String, int)> _monthlyCounts(List<AdminUser> users) {
    final now = DateTime.now();
    final months = List.generate(
      5,
      (index) => DateTime(now.year, now.month - 4 + index),
    );
    return months.map((month) {
      final count = users
          .where(
            (user) =>
                user.createdAt?.year == month.year &&
                user.createdAt?.month == month.month,
          )
          .length;
      return (_monthLabel(month.month), count);
    }).toList();
  }

  String _monthLabel(int month) => const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][month - 1];
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .22),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.extraSmallSemibold.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: AppTypography.sectionInnerTitle.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityChart extends StatelessWidget {
  const _ActivityChart({required this.labels, required this.counts});

  final List<String> labels;
  final List<int> counts;

  @override
  Widget build(BuildContext context) {
    final maximum = counts.fold<int>(
      1,
      (currentMaximum, count) =>
          count > currentMaximum ? count : currentMaximum,
    );

    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) => Stack(
                          fit: StackFit.expand,
                          children: [
                            CustomPaint(painter: _DottedGridPainter()),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                for (final value in counts)
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        width: 16,
                                        height:
                                            constraints.maxHeight *
                                            value /
                                            maximum,
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryDark,
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 2,
                                          ),
                                          child: Text(
                                            '$value',
                                            style: AppTypography
                                                .extraSmallSemibold
                                                .copyWith(
                                                  color: Colors.white,
                                                  fontSize: 7,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                      child: Row(
                        children: [
                          for (final month in labels)
                            Expanded(
                              child: Center(
                                child: Text(
                                  month,
                                  style: AppTypography.extraSmallSemibold
                                      .copyWith(
                                        fontSize: 8,
                                        color: AppColors.textTertiary,
                                      ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DottedGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.grey300
      ..strokeWidth = 1;
    const lineCount = 5;
    const dashLength = 3.0;
    const dashGap = 3.0;

    for (var line = 0; line < lineCount; line++) {
      final y = size.height * line / (lineCount - 1);
      for (var x = 0.0; x < size.width; x += dashLength + dashGap) {
        canvas.drawLine(
          Offset(x, y),
          Offset(math.min(x + dashLength, size.width), y),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RecentUserTile extends StatelessWidget {
  const _RecentUserTile({required this.user});

  final AdminUser user;

  @override
  Widget build(BuildContext context) {
    final isActive = user.status == AdminUserStatus.active;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary20,
            child: Text(
              user.name.isEmpty
                  ? 'U'
                  : user.name.characters.first.toUpperCase(),
              style: AppTypography.smallSemibold.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: AppTypography.smallSemibold),
                Text(
                  user.email,
                  style: AppTypography.extraSmallSemibold.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            isActive ? 'Active' : 'Inactive',
            style: AppTypography.extraSmallSemibold.copyWith(
              color: isActive ? AppColors.success80 : AppColors.error80,
            ),
          ),
        ],
      ),
    );
  }
}
