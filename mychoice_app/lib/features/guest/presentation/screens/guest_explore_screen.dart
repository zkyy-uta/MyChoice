import 'package:flutter/material.dart';
import 'package:mychoice_app/core/theme/app_colors.dart';
import 'package:mychoice_app/core/theme/app_spacing.dart';
import 'package:mychoice_app/core/theme/app_typography.dart';
import 'package:mychoice_app/core/widgets/animated_gradient_background.dart';

/// Guest Explore Screen — browse categories and recommended options
/// without needing to log in.
class GuestExploreScreen extends StatelessWidget {
  const GuestExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // ── App Bar ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.textPrimary,
                        size: AppSpacing.iconSm,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Explore',
                        style: AppTypography.screenTitle.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                ),
                child: Text(
                  'Discover options for your next decision.',
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // ── Search Field ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                ),
                child: Container(
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
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search categories or items...',
                      hintStyle: AppTypography.inputHint.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textPurple,
                        size: AppSpacing.iconSm,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── Browse Categories ──────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Browse Categories header
                      Text(
                        'Browse Categories',
                        style: AppTypography.sectionTitle.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      ..._buildCategoryTiles(context),

                      const SizedBox(height: AppSpacing.xxl),

                      // Popular Subcategories
                      Text(
                        'Popular Subcategories',
                        style: AppTypography.sectionTitle.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      _buildSubcategoryChips(),

                      const SizedBox(height: AppSpacing.xxl),

                      // Recommended Options
                      Text(
                        'Recommended Options',
                        style: AppTypography.sectionTitle.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      _buildRecommendedOptions(context),

                      const SizedBox(height: AppSpacing.huge),
                    ],
                  ),
                ),
              ),

              // ── CTA Card ───────────────────────────────────────────────
              _buildCTACard(context),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _GuestBottomNav(
        selectedIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushNamed('/guest-home');
          } else if (index == 2) {
            Navigator.of(context).pushNamed('/login');
          }
        },
      ),
    );
  }

  List<Widget> _buildCategoryTiles(BuildContext context) {
    final categories = [
      {
        'title': 'Technology',
        'subtitle': 'Laptops, smartphones, tablets, and more',
        'icon': 'assets/icons/laptop.png',
        'color': AppColors.categoryTechnology,
      },
      {
        'title': 'Education',
        'subtitle': 'Courses, certifications, and internships',
        'icon': 'assets/icons/education.png',
        'color': AppColors.categoryEducation,
      },
      {
        'title': 'Fashion',
        'subtitle': 'Shoes, bags, clothing, and watches',
        'icon': 'assets/icons/fashion.png',
        'color': AppColors.categoryFashion,
      },
    ];

    return categories.map((cat) {
      return Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
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
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                '/guest-category-detail',
                arguments: cat['title'],
              );
            },
            borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLarge),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: (cat['color'] as Color).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      cat['icon'] as String,
                      width: 32,
                      height: 32,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.category,
                          color: (cat['color'] as Color?),
                          size: 32,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cat['title'] as String,
                          style: AppTypography.sectionInnerTitle.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          cat['subtitle'] as String,
                          style: AppTypography.small.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Arrow
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.textTertiary,
                    size: AppSpacing.iconXs,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildSubcategoryChips() {
    final subcategories = [
      {'label': 'Laptop', 'icon': 'assets/icons/laptop.png'},
      {'label': 'Shoes', 'icon': 'assets/icons/fashion.png'},
      {'label': 'Courses', 'icon': 'assets/icons/education.png'},
    ];

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: subcategories.map((sub) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLarge),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                sub['icon'] as String,
                width: 20,
                height: 20,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.category, size: 20);
                },
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                sub['label'] as String,
                style: AppTypography.smallSemibold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecommendedOptions(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        final isEven = index % 2 == 0;
        final data = isEven
            ? {
                'title': 'ASUS Vivobook',
                'subtitle': 'Laptop',
                'icon': 'assets/icons/laptop.png',
                'color': AppColors.categoryTechnology,
              }
            : {
                'title': 'Galaxy S25 Ultra',
                'subtitle': 'Smartphone',
                'icon': 'assets/icons/smartphone.png',
                'color': AppColors.categoryTechnology,
              };

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLarge),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: (data['color'] as Color).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  data['icon'] as String,
                  width: 32,
                  height: 32,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.device_unknown,
                      color: (data['color'] as Color?),
                      size: 32,
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                data['title'] as String,
                style: AppTypography.sectionInnerTitle.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                data['subtitle'] as String,
                style: AppTypography.small.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCTACard(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Ready to compare your options?',
            style: AppTypography.sectionTitle.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Create a decision and find what matters most to you.',
            style: AppTypography.body.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/create-decision');
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
              color: isSelected
                  ? AppColors.primary88.withValues(alpha: 0.15)
                  : Colors.transparent,
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
