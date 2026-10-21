import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Total weight indicator widget showing cumulative weight
class TotalWeightIndicator extends StatelessWidget {
  final double totalWeight;
  final double targetWeight;

  const TotalWeightIndicator({
    required this.totalWeight,
    this.targetWeight = 100.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isValid = (totalWeight - targetWeight).abs() < 0.001;
    final backgroundColor = isValid ? AppColors.success20 : AppColors.error20;
    final borderColor = isValid ? AppColors.success80 : AppColors.error80;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Weight', style: AppTypography.oneLiner),
              const SizedBox(height: AppSpacing.xs),
              Text(
                isValid ? 'Valid (100%)' : 'Invalid',
                style: AppTypography.small.copyWith(
                  color: isValid ? AppColors.success80 : AppColors.error80,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: isValid ? AppColors.success80 : AppColors.error80,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Text(
              '${totalWeight.toStringAsFixed(1)}%',
              style: AppTypography.buttonMedium.copyWith(
                color: AppColors.textWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
