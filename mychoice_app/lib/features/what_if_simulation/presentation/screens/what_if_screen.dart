import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mychoice_app/features/what_if_simulation/presentation/providers/simulation_provider.dart';
import 'package:mychoice_app/core/theme/app_colors.dart';
import 'package:mychoice_app/core/theme/app_spacing.dart';
import 'package:mychoice_app/core/theme/app_typography.dart';

/// What-If Simulation screen – lets the user adjust criterion weights and see
/// how the ranking changes without permanently altering the decision.
class WhatIfScreen extends StatefulWidget {
  const WhatIfScreen({super.key});

  @override
  State<WhatIfScreen> createState() => _WhatIfScreenState();
}

class _WhatIfScreenState extends State<WhatIfScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('What-If Simulation'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<SimulationProvider>(
        builder: (context, provider, _) {
          if (provider.originalResult == null) {
            return const Center(child: Text('No decision data available.'));
          }

          final original = provider.originalResult!;
          final simulated = provider.simulatedResult;
          final weights = provider.simulatedWeights;
          final totalWeight = provider.totalSimulatedWeight;
          final weightOk = (totalWeight - 100.0).abs() < 0.5;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ────────────────────────────────────────────────
                Text(
                  'What-If Simulation',
                  style: AppTypography.sectionTitle,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Adjust priorities to see how results would change',
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── Original result summary ───────────────────────────────
                _OriginalResultCard(provider: provider),
                const SizedBox(height: AppSpacing.lg),

                // ── Weight sliders ────────────────────────────────────────
                Text('Adjust Weights', style: AppTypography.sectionInnerTitle),
                const SizedBox(height: AppSpacing.md),
                ...weights.entries.map((entry) {
                  final critId = entry.key;
                  final value = entry.value;

                  // Use the criterion ID as the display name until
                  // a criterion-name mapping is available.
                  final displayName = critId;

                  return _WeightSliderRow(
                    critId: critId,
                    displayName: displayName,
                    value: value,
                    onChanged: (v) => provider.adjustWeight(critId, v),
                  );
                }),
                const SizedBox(height: AppSpacing.md),

                // ── Total weight indicator ────────────────────────────────
                _TotalWeightIndicator(
                  total: totalWeight,
                  isValid: weightOk,
                ),
                const SizedBox(height: AppSpacing.md),

                // ── Auto-balance button ───────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: provider.autoBalance,
                    icon: const Icon(Icons.balance),
                    label: const Text('Auto-Balance to 100%'),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── Calculating indicator ────────────────────────────────
                if (provider.isCalculating)
                  const Center(child: CircularProgressIndicator()),

                // ── Simulated results ─────────────────────────────────────
                if (simulated != null && !provider.isCalculating) ...[
                  Text(
                    'Simulated Ranking',
                    style: AppTypography.sectionInnerTitle,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...simulated.ranking.map((ranked) {
                    final altId = ranked.alternative.id;
                    final delta = provider.rankChanges[altId] ?? 0;
                    final origRanked = original.ranking.firstWhere(
                      (r) => r.alternative.id == altId,
                      orElse: () => ranked,
                    );
                    final scoreDelta =
                        ranked.compositeScore - origRanked.compositeScore;

                    return _SimulatedRankCard(
                      ranked: ranked,
                      rankDelta: delta,
                      scoreDelta: scoreDelta,
                    );
                  }),
                  const SizedBox(height: AppSpacing.md),

                  // ── Rank change summary ───────────────────────────────
                  _RankChangeSummary(
                    simulated: simulated,
                    original: original,
                    rankChanges: provider.rankChanges,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // ── Action buttons ────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: provider.resetToOriginal,
                        child: const Text('Reset to Original'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: weightOk
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Simulation saved as new decision',
                                    ),
                                  ),
                                );
                                // TODO: integrate with decision history
                              }
                            : null,
                        child: const Text('Save as New Decision'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _OriginalResultCard extends StatelessWidget {
  final SimulationProvider provider;
  const _OriginalResultCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final top = provider.originalResult?.topAlternative;
    if (top == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary20,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.primary88),
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events, color: AppColors.primary88),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Original Top Result',
                  style: AppTypography.small.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  top.alternative.name,
                  style: AppTypography.sectionInnerTitle,
                ),
              ],
            ),
          ),
          Text(
            '${top.compositeScore.toStringAsFixed(1)}%',
            style: AppTypography.sectionInnerTitle.copyWith(
              color: AppColors.primary88,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightSliderRow extends StatelessWidget {
  final String critId;
  final String displayName;
  final double value;
  final ValueChanged<double> onChanged;

  const _WeightSliderRow({
    required this.critId,
    required this.displayName,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  displayName,
                  style: AppTypography.body,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${value.toStringAsFixed(1)}%',
                style: AppTypography.body.copyWith(
                  color: AppColors.primary88,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Slider(
            value: value.clamp(0.0, 100.0),
            min: 0.0,
            max: 100.0,
            divisions: 100,
            activeColor: AppColors.primary88,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _TotalWeightIndicator extends StatelessWidget {
  final double total;
  final bool isValid;

  const _TotalWeightIndicator({
    required this.total,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    final color = isValid ? Colors.green.shade700 : Colors.red.shade700;
    final bg = isValid ? Colors.green.shade50 : Colors.red.shade50;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle_outline : Icons.warning_amber_rounded,
            color: color,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Total weight: ${total.toStringAsFixed(1)}%'
            '${isValid ? ' ✓' : ' (must equal 100%)'}',
            style: AppTypography.body.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _SimulatedRankCard extends StatelessWidget {
  final dynamic ranked; // RankedAlternative
  final int rankDelta;
  final double scoreDelta;

  const _SimulatedRankCard({
    required this.ranked,
    required this.rankDelta,
    required this.scoreDelta,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeBg;
    Color badgeFg;
    String badgeText;

    if (rankDelta > 0) {
      badgeBg = Colors.green.shade100;
      badgeFg = Colors.green.shade800;
      badgeText = '↑ +$rankDelta';
    } else if (rankDelta < 0) {
      badgeBg = Colors.red.shade100;
      badgeFg = Colors.red.shade800;
      badgeText = '↓ $rankDelta';
    } else {
      badgeBg = Colors.grey.shade100;
      badgeFg = Colors.grey.shade700;
      badgeText = '—';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary20,
          child: Text(
            '${ranked.rank}',
            style: AppTypography.buttonMedium.copyWith(
              color: AppColors.primary88,
            ),
          ),
        ),
        title: Text(ranked.alternative.name, style: AppTypography.body),
        subtitle: Text(
          '${ranked.compositeScore.toStringAsFixed(1)}%'
          ' (${scoreDelta >= 0 ? '+' : ''}${scoreDelta.toStringAsFixed(1)}%)',
          style: AppTypography.small.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: badgeBg,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          ),
          child: Text(
            badgeText,
            style: AppTypography.small.copyWith(
              color: badgeFg,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _RankChangeSummary extends StatelessWidget {
  final dynamic simulated;
  final dynamic original;
  final Map<String, int> rankChanges;

  const _RankChangeSummary({
    required this.simulated,
    required this.original,
    required this.rankChanges,
  });

  @override
  Widget build(BuildContext context) {
    // Build list of notable rank changes
    final notable = rankChanges.entries
        .where((e) => e.value != 0)
        .toList()
      ..sort((a, b) => b.value.abs().compareTo(a.value.abs()));

    if (notable.isEmpty) {
      return Text(
        '⚡ No rank changes with current weights.',
        style: AppTypography.body.copyWith(color: AppColors.textSecondary),
      );
    }

    // Resolve alternative names
    final nameById = <String, String>{};
    for (final r in (original.ranking as List)) {
      nameById[r.alternative.id] = r.alternative.name;
    }
    final origRankById = <String, int>{};
    for (final r in (original.ranking as List)) {
      origRankById[r.alternative.id] = r.rank;
    }
    final simRankById = <String, int>{};
    for (final r in (simulated.ranking as List)) {
      simRankById[r.alternative.id] = r.rank;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: notable.map((e) {
        final name = nameById[e.key] ?? e.key;
        final origRank = origRankById[e.key] ?? '?';
        final simRank = simRankById[e.key] ?? '?';
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Text(
            '⚡ $name moved from #$origRank → #$simRank',
            style: AppTypography.body.copyWith(
              color:
                  e.value > 0 ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
        );
      }).toList(),
    );
  }
}

