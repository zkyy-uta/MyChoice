import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

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
    const icons = [
      Icons.home_rounded,
      Icons.add_rounded,
      Icons.bar_chart_rounded,
      Icons.history_rounded,
      Icons.people_alt_rounded,
    ];
    const labels = ['Home', 'Decision', 'Insight', 'History', 'Profile'];

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.paddingOf(context).bottom + 5,
        top: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: Colors.white, width: 1.2),
      ),
      child: Row(
        children: List.generate(icons.length, (index) {
          final selected = index == selectedIndex;
          return Expanded(
            child: InkWell(
              onTap: () => onSelected(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 41,
                    height: 38,
                    decoration: selected
                        ? BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryDark,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryDark.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 7,
                              ),
                            ],
                          )
                        : null,
                    child: Icon(
                      icons[index],
                      size: index == 1 ? 27 : 23,
                      color: selected ? Colors.white : AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    labels[index],
                    style: AppTypography.extraSmallSemibold.copyWith(
                      color: AppColors.textPurple,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
