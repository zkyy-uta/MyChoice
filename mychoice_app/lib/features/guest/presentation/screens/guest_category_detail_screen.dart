import 'package:flutter/material.dart';
import 'package:mychoice_app/core/theme/app_colors.dart';
import 'package:mychoice_app/core/theme/app_spacing.dart';
import 'package:mychoice_app/core/theme/app_typography.dart';
import 'package:mychoice_app/core/widgets/animated_gradient_background.dart';

/// Guest Category Detail Screen — shows subcategories for a selected category
/// (e.g. Technology → Laptops, Smartphones, Tablets, etc.)
class GuestCategoryDetailScreen extends StatelessWidget {
  final String categoryName;

  const GuestCategoryDetailScreen({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final subcategories = _getSubcategories(categoryName);

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
                        categoryName,
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
                  'Explore ${categoryName.toLowerCase()} alternatives for your needs.',
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── Subcategory List ───────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Column(
                    children: [
                      ...subcategories.map((sub) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: AppSpacing.md),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.cardRadiusLarge,
                            ),
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
                                // Navigate to item list or decision creation
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${sub['title']} selected',
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(
                                AppSpacing.cardRadiusLarge,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                child: Row(
                                  children: [
                                    // Icon
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: (sub['color'] as Color)
                                            .withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Image.asset(
                                        sub['icon'] as String,
                                        width: 32,
                                        height: 32,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(
                                            Icons.device_unknown,
                                            color: sub['color'],
                                            size: 32,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    // Content
                                    Expanded(
                                      child: Text(
                                        sub['title'] as String,
                                        style: AppTypography.sectionInnerTitle.copyWith(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w700,
                                        ),
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
                      }).toList(),

                      const SizedBox(height: AppSpacing.huge),
                    ],
                  ),
                ),
              ),
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

  List<Map<String, dynamic>> _getSubcategories(String category) {
    switch (category) {
      case 'Technology':
        return [
          {
            'title': 'Laptops',
            'icon': 'assets/icons/laptop.png',
            'color': AppColors.categoryTechnology,
          },
          {
            'title': 'Smartphones',
            'icon': 'assets/icons/smartphone.png',
            'color': AppColors.categoryTechnology,
          },
          {
            'title': 'Tablets',
            'icon': 'assets/icons/tablet.png',
            'color': AppColors.categoryTechnology,
          },
          {
            'title': 'Desktop PCs',
            'icon': 'assets/icons/pc_desktop.png',
            'color': AppColors.categoryTechnology,
          },
          {
            'title': 'Monitors',
            'icon': 'assets/icons/monitor.png',
            'color': AppColors.categoryTechnology,
          },
        ];
      case 'Education':
        return [
          {
            'title': 'Courses',
            'icon': 'assets/icons/education.png',
            'color': AppColors.categoryEducation,
          },
          {
            'title': 'Certifications',
            'icon': 'assets/icons/education.png',
            'color': AppColors.categoryEducation,
          },
          {
            'title': 'Internships',
            'icon': 'assets/icons/education.png',
            'color': AppColors.categoryEducation,
          },
        ];
      case 'Fashion':
        return [
          {
            'title': 'Shoes',
            'icon': 'assets/icons/fashion.png',
            'color': AppColors.categoryFashion,
          },
          {
            'title': 'Bags',
            'icon': 'assets/icons/fashion.png',
            'color': AppColors.categoryFashion,
          },
          {
            'title': 'Clothing',
            'icon': 'assets/icons/fashion.png',
            'color': AppColors.categoryFashion,
          },
          {
            'title': 'Watches',
            'icon': 'assets/icons/fashion.png',
            'color': AppColors.categoryFashion,
          },
        ];
      default:
        return [];
    }
  }
}

/// Guest Bottom Navigation — shared across guest screens
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
