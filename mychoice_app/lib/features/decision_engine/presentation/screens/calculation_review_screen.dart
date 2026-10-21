import 'package:flutter/material.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/decision_matrix.dart';
import 'package:mychoice_app/features/criteria_selection/domain/entities/criterion.dart';
import 'package:mychoice_app/core/theme/app_colors.dart';
import 'package:mychoice_app/core/theme/app_typography.dart';
import 'package:mychoice_app/core/theme/app_spacing.dart';

/// Screen for reviewing decision parameters before calculation
class CalculationReviewScreen extends StatelessWidget {
  final DecisionMatrix matrix;
  final Map<String, double> weights;
  final Map<String, Criterion> criteriaMap;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const CalculationReviewScreen({
    super.key,
    required this.matrix,
    required this.weights,
    required this.criteriaMap,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Before Calculating'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary card
            Card(
              elevation: 0,
              color: AppColors.primary20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                side: const BorderSide(color: AppColors.primary88, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.primary88,
                      size: 24,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Ready to Calculate',
                      style: AppTypography.sectionTitle.copyWith(
                        color: AppColors.primary88,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'We\'re about to calculate your decision using the parameters below.',
                      style: AppTypography.body,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Alternatives section
            _buildSection(
              title: 'Alternatives to Compare',
              count: matrix.alternatives.length,
              children: [
                ...matrix.alternatives.map((alt) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: AppColors.secondary80,
                          size: 18,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            alt.name,
                            style: AppTypography.body,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Criteria section
            _buildSection(
              title: 'Criteria with Weights',
              count: matrix.criteria.length,
              children: [
                ...matrix.criteria.map((crit) {
                  final weight = weights[crit.id] ?? 0.0;
                  final typeLabel = crit.type.displayName;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(crit.name, style: AppTypography.body),
                                  const SizedBox(height: 2),
                                  Text(
                                    typeLabel,
                                    style: AppTypography.small.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary20,
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.cardRadius,
                                ),
                              ),
                              child: Text(
                                '${weight.toStringAsFixed(1)}%',
                                style: AppTypography.body.copyWith(
                                  color: AppColors.primary88,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        // Weight visualization
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.cardRadius,
                          ),
                          child: LinearProgressIndicator(
                            value: weight / 100,
                            minHeight: 4,
                            backgroundColor: AppColors.primary20,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary88,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Weight validation
            _buildWeightValidation(),

            const SizedBox(height: AppSpacing.lg),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    child: const Text('Go Back'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    child: const Text('Confirm Calculation'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required int count,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.sectionTitle),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '$count item${count != 1 ? 's' : ''}',
          style: AppTypography.small.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.md),
        Card(
          elevation: 0,
          color: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeightValidation() {
    final weightSum = weights.values.fold<double>(0, (sum, w) => sum + w);
    final isValid = (weightSum - 100).abs() <= 0.001;

    return Card(
      elevation: 0,
      color: isValid ? AppColors.primary20 : AppColors.error20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        side: BorderSide(
          color: isValid ? AppColors.primary88 : AppColors.error80,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(
              isValid ? Icons.check_circle : Icons.warning,
              color: isValid ? AppColors.primary88 : AppColors.error80,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isValid ? 'Weights Valid' : 'Weights Invalid',
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isValid ? AppColors.primary88 : AppColors.error80,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Total: ${weightSum.toStringAsFixed(1)}% (must be 100%)',
                    style: AppTypography.small,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
