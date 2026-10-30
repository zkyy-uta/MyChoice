import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mychoice_app/features/decision_engine/presentation/providers/result_provider.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/decision_result.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/calculation_breakdown.dart';
import 'package:mychoice_app/features/what_if_simulation/presentation/providers/simulation_provider.dart';
import 'package:mychoice_app/features/comparison/presentation/providers/comparison_provider.dart';
import 'package:mychoice_app/core/theme/app_colors.dart';
import 'package:mychoice_app/core/theme/app_typography.dart';
import 'package:mychoice_app/core/theme/app_spacing.dart';

/// Screen displaying SAW calculation results with ranked alternatives
class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // Track which alternative detail is expanded
  String? _expandedAltId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Decision Results'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<ResultProvider>(
        builder: (context, resultProvider, _) {
          // Handle loading state
          if (resultProvider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: AppColors.primary88),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Calculating your decision...',
                    style: AppTypography.body,
                  ),
                ],
              ),
            );
          }

          // Handle error state
          if (resultProvider.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: AppColors.error80,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Calculation Failed',
                      style: AppTypography.sectionTitle,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      resultProvider.error ?? 'An unknown error occurred',
                      style: AppTypography.body,
                      textAlign: TextAlign.center,
                    ),
                    if (resultProvider.errorDetails != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Error Code: ${resultProvider.errorDetails}',
                        style: AppTypography.small.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Handle empty state
          if (resultProvider.result == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 48,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('No results available', style: AppTypography.body),
                ],
              ),
            );
          }

          final result = resultProvider.result!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text('Ranked Alternatives', style: AppTypography.sectionTitle),
                const SizedBox(height: AppSpacing.md),

                // Results list
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: result.ranking.length,
                  itemBuilder: (context, index) {
                    final ranked = result.ranking[index];
                    final isExpanded = _expandedAltId == ranked.alternative.id;
                    final isTopResult = ranked.rank == 1;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Column(
                        children: [
                          // Result card
                          _buildResultCard(
                            ranked: ranked,
                            isTop: isTopResult,
                            isExpanded: isExpanded,
                            onTap: () {
                              setState(() {
                                _expandedAltId = isExpanded
                                    ? null
                                    : ranked.alternative.id;
                              });
                            },
                          ),

                          // Expanded breakdown
                          if (isExpanded) ...[
                            const SizedBox(height: AppSpacing.sm),
                            _buildBreakdownDetails(result, ranked),
                          ],
                        ],
                      ),
                    );
                  },
                ),

                // Footer actions
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement save decision
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Decision saved!')),
                      );
                    },
                    child: const Text('Save Decision'),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    // Compare Alternatives button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          final matrix = resultProvider.matrix;
                          final criteriaMap = resultProvider.criteriaMap;
                          if (matrix == null || criteriaMap == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Calculation data not available'),
                              ),
                            );
                            return;
                          }
                          context.read<ComparisonProvider>().buildComparisonView(
                            result,
                            matrix,
                            criteriaMap,
                          );
                          Navigator.of(context).pushNamed('/comparison');
                        },
                        icon: const Icon(Icons.compare_arrows),
                        label: const Text('Compare'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    // What-If Simulation button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          final matrix = resultProvider.matrix;
                          final criteriaMap = resultProvider.criteriaMap;
                          if (matrix == null || criteriaMap == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Calculation data not available'),
                              ),
                            );
                            return;
                          }
                          // Derive equal initial weights if not available
                          final criteriaCount = criteriaMap.length;
                          final equalWeight = criteriaCount > 0
                              ? 100.0 / criteriaCount
                              : 0.0;
                          final initialWeights = {
                            for (final id in criteriaMap.keys)
                              id: equalWeight,
                          };
                          context.read<SimulationProvider>().initialize(
                            originalResult: result,
                            matrix: matrix,
                            criteriaMap: criteriaMap,
                            originalWeights: initialWeights,
                          );
                          Navigator.of(context).pushNamed('/what-if');
                        },
                        icon: const Icon(Icons.tune),
                        label: const Text('What-If'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build individual result card
  Widget _buildResultCard({
    required RankedAlternative ranked,
    required bool isTop,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isTop ? AppColors.primary20 : AppColors.cardBackground,
          border: Border.all(
            color: isTop ? AppColors.primary88 : AppColors.border,
            width: isTop ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rank and name with badge
            Row(
              children: [
                // Rank badge
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isTop ? AppColors.primary88 : AppColors.grey200,
                    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${ranked.rank}',
                    style: AppTypography.buttonLarge.copyWith(
                      color: isTop
                          ? AppColors.textWhite
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),

                // Name and best match badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ranked.alternative.name,
                        style: AppTypography.sectionInnerTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (isTop) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary88,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.cardRadius,
                            ),
                          ),
                          child: Text(
                            '🏆 Best Match',
                            style: AppTypography.extraSmallSemibold.copyWith(
                              color: AppColors.textWhite,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Score percentage
                Text(
                  '${ranked.compositeScore.toStringAsFixed(1)}%',
                  style: AppTypography.sectionTitle.copyWith(
                    color: isTop ? AppColors.primary88 : AppColors.textPrimary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              child: LinearProgressIndicator(
                value: ranked.compositeScore / 100,
                minHeight: 6,
                backgroundColor: AppColors.primary20,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isTop ? AppColors.primary88 : AppColors.secondary80,
                ),
              ),
            ),

            // Expand indicator
            if (!isExpanded)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Icon(
                    Icons.expand_more,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build breakdown details for expanded alternative
  Widget _buildBreakdownDetails(
    DecisionResult result,
    RankedAlternative ranked,
  ) {
    final breakdown = result.getBreakdownForAlternative(ranked.alternative.id);
    if (breakdown == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Calculation Breakdown', style: AppTypography.sectionInnerTitle),
          const SizedBox(height: AppSpacing.md),

          // Criterion breakdown items
          Column(children: _buildCriterionBreakdownItems(breakdown)),

          const SizedBox(height: AppSpacing.md),

          // Total score
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primary20,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Score', style: AppTypography.buttonLarge),
                Text(
                  '${ranked.compositeScore.toStringAsFixed(2)}%',
                  style: AppTypography.buttonLarge.copyWith(
                    color: AppColors.primary88,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build criterion breakdown items with dividers
  List<Widget> _buildCriterionBreakdownItems(CalculationBreakdown breakdown) {
    final items = <Widget>[];
    final entries = breakdown.criteria.entries.toList();

    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final critId = entry.key;
      final score = entry.value;

      // Find criterion name
      String critName = 'Criterion $critId';
      // TODO: Get criterion name from context or parameter

      items.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(critName, style: AppTypography.body)),
                Text(
                  '${score.weighted.toStringAsFixed(4)} →',
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              '${score.normalized.toStringAsFixed(3)} (normalized) × ${(score.weight * 100).toStringAsFixed(1)}% = ${(score.weighted * 100).toStringAsFixed(2)}%',
              style: AppTypography.small.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );

      // Add divider between items
      if (i < entries.length - 1) {
        items.add(
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Divider(color: AppColors.divider, height: 1),
          ),
        );
      }
    }

    return items;
  }
}
