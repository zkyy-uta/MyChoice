import 'package:flutter/material.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/decision_result.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/calculation_breakdown.dart';
import 'package:mychoice_app/features/alternative_management/domain/entities/alternative.dart';
import 'package:mychoice_app/core/theme/app_colors.dart';
import 'package:mychoice_app/core/theme/app_typography.dart';
import 'package:mychoice_app/core/theme/app_spacing.dart';

/// Screen showing full breakdown of a single alternative's calculation
class ResultDetailScreen extends StatelessWidget {
  final Alternative alternative;
  final DecisionResult result;
  final CalculationBreakdown breakdown;

  const ResultDetailScreen({
    super.key,
    required this.alternative,
    required this.result,
    required this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(alternative.name),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alternative name and score
            Card(
              elevation: 0,
              color: AppColors.primary20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Composite Score',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '${breakdown.compositeScore.toStringAsFixed(2)}%',
                      style: AppTypography.screenTitle.copyWith(
                        color: AppColors.primary88,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppSpacing.cardRadius,
                      ),
                      child: LinearProgressIndicator(
                        value: breakdown.compositeScore / 100,
                        minHeight: 8,
                        backgroundColor: AppColors.primary20,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary88,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // SAW Methodology explanation
            _buildExplanationSection(),

            const SizedBox(height: AppSpacing.lg),

            // Detailed breakdown
            Text('Calculation Details', style: AppTypography.sectionTitle),
            const SizedBox(height: AppSpacing.md),

            // Calculation steps
            _buildCalculationSteps(),

            const SizedBox(height: AppSpacing.lg),

            // SAW Formula explanation
            Card(
              elevation: 0,
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                side: const BorderSide(color: AppColors.border, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SAW Formula', style: AppTypography.sectionInnerTitle),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Simple Additive Weighting (SAW) calculates a composite score by:',
                      style: AppTypography.body,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildFormulaStep(
                      '1. Normalize',
                      'Each criterion value is normalized to 0-1 range:\n• Benefit: value / MAX value\n• Cost: MIN value / value',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildFormulaStep(
                      '2. Weight',
                      'Each normalized value is multiplied by its weight:\nweighted = normalized × weight %',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildFormulaStep(
                      '3. Sum',
                      'All weighted values are summed:\ncomposite = Σ(weighted values) × 100',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Ranking information
            Card(
              elevation: 0,
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                side: const BorderSide(color: AppColors.border, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ranking Information',
                      style: AppTypography.sectionInnerTitle,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildRankingInfo(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationSection() {
    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How SAW Works', style: AppTypography.sectionInnerTitle),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Simple Additive Weighting (SAW) is a multi-criteria decision-making method that:\n\n'
              '1. Normalizes all criterion values to a comparable scale\n'
              '2. Applies your chosen weights to prioritize certain criteria\n'
              '3. Sums the weighted values to produce a final score\n\n'
              'This produces a single, transparent score that you can interpret easily.',
              style: AppTypography.body,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculationSteps() {
    return Column(
      children: breakdown.criteria.entries.map((entry) {
        final critId = entry.key;
        final score = entry.value;
        final critName = 'Criterion $critId'; // TODO: Get from context

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Card(
            elevation: 0,
            color: AppColors.cardBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(critName, style: AppTypography.sectionInnerTitle),
                  const SizedBox(height: AppSpacing.md),
                  _buildStepValue('Normalized', score.normalized),
                  const SizedBox(height: AppSpacing.sm),
                  _buildStepValue('Weight', score.weight * 100),
                  const SizedBox(height: AppSpacing.sm),
                  _buildStepValue('Contribution', score.weighted * 100),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.primary20,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.cardRadius,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Formula:', style: AppTypography.body),
                        Text(
                          '${score.normalized.toStringAsFixed(3)} × ${(score.weight * 100).toStringAsFixed(1)}% = ${(score.weighted * 100).toStringAsFixed(2)}%',
                          style: AppTypography.body.copyWith(
                            color: AppColors.primary88,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStepValue(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.body),
        Text(
          value.toStringAsFixed(4),
          style: AppTypography.body.copyWith(
            color: AppColors.primary88,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildFormulaStep(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.body.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary88,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          description,
          style: AppTypography.small.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildRankingInfo() {
    // Find this alternative's rank
    int? rank;
    for (final ranked in result.ranking) {
      if (ranked.alternative.id == alternative.id) {
        rank = ranked.rank;
        break;
      }
    }

    if (rank == null) {
      return const Text('Rank information not available');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Rank'),
            Text(
              '$rank of ${result.ranking.length}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (rank == 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Status'),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary88,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                ),
                child: const Text(
                  '🏆 Best Match',
                  style: TextStyle(color: AppColors.textWhite, fontSize: 12),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
