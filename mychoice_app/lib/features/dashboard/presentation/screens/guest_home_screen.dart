import 'package:flutter/material.dart';
import 'package:mychoice_app/core/theme/app_colors.dart';
import 'package:mychoice_app/core/theme/app_spacing.dart';
import 'package:mychoice_app/core/theme/app_typography.dart';
import 'package:mychoice_app/core/widgets/animated_gradient_background.dart';

/// Guest Home Screen — public dashboard accessible without login.
/// Shows explore categories, popular choices, and a CTA to create a decision.
class GuestHomeScreen extends StatelessWidget {
  const GuestHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header / Brand ───────────────────────────────────────
                Row(
                  children: [
                    Image.asset(
                      'assets/images/logo_mychoice.png',
                      width: 36,
                      height: 36,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.auto_awesome,
                          color: AppColors.primary88,
                          size: 32,
                        );
                      },
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const Text(
                      'MyChoice',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: 0,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.person_outline,
                      color: AppColors.textTertiary,
                      size: AppSpacing.iconMd,
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // Tagline
                Text(
                  'Make Your Next Decision\nwith Confidence.',
                  style: AppTypography.sectionTitle.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Compare your options based on what matters most to you.',
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // ── Explore Categories ───────────────────────────────────
                Text(
                  'Explore Categories',
                  style: AppTypography.sectionTitle.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                _buildCategoryGrid(),

                const SizedBox(height: AppSpacing.xxl),

                // ── Popular Choices ──────────────────────────────────────
                Text(
                  'Popular Choices',
                  style: AppTypography.sectionTitle.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                _buildPopularChoiceRow(
                  context,
                  iconAsset: 'assets/icons/laptop.png',
                  label: 'Laptop',
                  color: AppColors.categoryTechnology,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildPopularChoiceRow(
                  context,
                  iconAsset: 'assets/icons/education.png',
                  label: 'Course',
                  color: AppColors.categoryEducation,
                ),

                const SizedBox(height: AppSpacing.xxl),

                // ── CTA Card ─────────────────────────────────────────────
                _buildCTACard(context),

                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _GuestBottomNav(
        selectedIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).pushNamed('/guest-explore');
          } else if (index == 2) {
            Navigator.of(context).pushNamed('/login');
          }
        },
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {
        'title': 'Technology',
        'icon': 'assets/icons/laptop.png',
        'color': AppColors.categoryTechnology,
      },
      {
        'title': 'Education',
        'icon': 'assets/icons/education.png',
        'color': AppColors.categoryEducation,
      },
      {
        'title': 'Fashion',
        'icon': 'assets/icons/fashion.png',
        'color': AppColors.categoryFashion,
      },
    ];

    return Row(
      children: categories.map((cat) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _CategoryPill(
              title: cat['title'] as String,
              iconAsset: cat['icon'] as String,
              color: cat['color'] as Color,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPopularChoiceRow(
    BuildContext context, {
    required String iconAsset,
    required String label,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLarge),
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
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              iconAsset,
              width: 20,
              height: 20,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.category, color: color, size: 20);
              },
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: AppTypography.sectionInnerTitle.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            'Explore →',
            style: AppTypography.smallSemibold.copyWith(
              color: color,
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildCTACard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.primary88,
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ready to Make a Better Choice?',
            style: AppTypography.sectionTitle.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Start your decision journey with MyChoice.',
            style: AppTypography.body.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/guest-create-decision');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                ),
              ),
              child: Text(
                'Create a Decision',
                style: AppTypography.buttonLarge.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Category Pill — rounded card with icon and title
class _CategoryPill extends StatelessWidget {
  final String title;
  final String iconAsset;
  final Color color;

  const _CategoryPill({
    required this.title,
    required this.iconAsset,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(
              iconAsset,
              width: 32,
              height: 32,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.category,
                  color: color,
                  size: 32,
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: AppTypography.smallSemibold.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Guest Bottom Navigation — Home, Explore, Sign In
class _GuestBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _GuestBottomNav({
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              _GuestNavItem(
                icon: Icons.home,
                label: 'Home',
                isSelected: selectedIndex == 0,
                onTap: () => onTap(0),
              ),
              _GuestNavItem(
                icon: Icons.explore,
                label: 'Explore',
                isSelected: selectedIndex == 1,
                onTap: () => onTap(1),
              ),
              _GuestNavItem(
                icon: Icons.login,
                label: 'Sign In',
                isSelected: selectedIndex == 2,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuestNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GuestNavItem({
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primary88.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? AppColors.primary88 : AppColors.textTertiary,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.extraSmallSemibold.copyWith(
              color: isSelected ? AppColors.primary88 : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
