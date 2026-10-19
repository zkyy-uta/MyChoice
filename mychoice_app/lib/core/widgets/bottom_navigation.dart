
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

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
              _NavBarItem(
                icon: Icons.home,
                label: 'Home',
                isSelected: selectedIndex == 0,
                onTap: () => onSelected(0),
              ),
              _NavBarItem(
                icon: Icons.add_circle_outline,
                label: 'Decision',
                isSelected: selectedIndex == 1,
                onTap: () => onSelected(1),
              ),
              _NavBarItem(
                icon: Icons.bar_chart,
                label: 'Insight',
                isSelected: selectedIndex == 2,
                onTap: () => onSelected(2),
              ),
              _NavBarItem(
                icon: Icons.history,
                label: 'History',
                isSelected: selectedIndex == 3,
                onTap: () => onSelected(3),
              ),
              _NavBarItem(
                icon: Icons.person_outline,
                label: 'Profile',
                isSelected: selectedIndex == 4,
                onTap: () => onSelected(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== NAVBAR ITEM ====================

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

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

        // Animasi perubahan warna navbar
        child: TweenAnimationBuilder<Color?>(
          tween: ColorTween(
            begin: AppColors.textTertiary,
            end: isSelected
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
                  icon,
                  color: animatedColor,
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: AppTypography.extraSmallSemibold.copyWith(
                    color: animatedColor,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
