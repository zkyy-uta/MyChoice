import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';

class AdminBottomNavigation extends StatelessWidget {
  const AdminBottomNavigation({required this.selectedIndex, super.key});

  final int selectedIndex;

  void _select(BuildContext context, int index) {
    if (index == 0) {
      if (selectedIndex != index) {
        Navigator.of(context).pushReplacementNamed('/admin');
      }
    } else if (index == 1) {
      if (selectedIndex != index) {
        Navigator.of(context).pushReplacementNamed('/admin/users');
      }
    } else if (index == 4) {
      if (selectedIndex != index) {
        Navigator.of(context).pushReplacementNamed('/admin/profile');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This feature is coming soon')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home, 'Home'),
      (Icons.people, 'Users'),
      (Icons.bar_chart, 'Catalogue'),
      (Icons.history, 'Reports'),
      (Icons.person_outline, 'Profile'),
    ];

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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var index = 0; index < items.length; index++)
                InkWell(
                  onTap: () => _select(context, index),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.sm,
                    ),
                    child: TweenAnimationBuilder<Color?>(
                      tween: ColorTween(
                        begin: AppColors.textTertiary,
                        end: selectedIndex == index
                            ? AppColors.primary88
                            : AppColors.textTertiary,
                      ),
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      builder: (context, animatedColor, child) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              items[index].$1,
                              color: animatedColor,
                              size: AppSpacing.iconMd,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              items[index].$2,
                              maxLines: 1,
                              style: AppTypography.extraSmallSemibold.copyWith(
                                color: animatedColor,
                              ),
                            ),
                          ],
                        );
                      },
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
