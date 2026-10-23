import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mychoice_app/features/what_if_simulation/presentation/providers/simulation_provider.dart';
import 'package:mychoice_app/core/theme/app_colors.dart';
import 'package:mychoice_app/core/theme/app_spacing.dart';
import 'package:mychoice_app/core/theme/app_typography.dart';
import 'package:mychoice_app/core/widgets/animated_gradient_background.dart';

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
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Consumer<SimulationProvider>(
            builder: (context, provider, _) {
              if (provider.originalResult == null) {
                return const Center(
                  child: Text('No decision data available.'),
                );
              }

              final original = provider.originalResult!;
              final weights = provider.simulatedWeights;
              final totalWeight = provider.totalSimulatedWeight;
              final weightOk = (totalWeight - 100.0).abs() < 0.5;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ─────────────────────────────────────────────
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppColors.textPurple,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'What-If Simulation',
                            style: AppTypography.sectionTitle.copyWith(
                              color: AppColors.textPurple,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'What if your priorities changed?',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // ── Original Priorities ────────────────────────────────
                    _buildOriginalPriorities(provider),
                    const SizedBox(height: AppSpacing.xxl),

                    // ── Simulation Priorities ──────────────────────────────
                    _buildSectionTitle('Simulation Priorities'),
                    const SizedBox(height: AppSpacing.md),
                    ...weights.entries.map((entry) {
                      final critId = entry.key;
                      final value = entry.value;

                      final displayName = _getDisplayName(critId);

                      return _WeightSliderRow(
                        critId: critId,
                        displayName: displayName,
                        value: value,
                        onChanged: (v) => provider.adjustWeight(critId, v),
                      );
                    }),
                    const SizedBox(height: AppSpacing.md),

                    // ── Total weight indicator ─────────────────────────────
                    _TotalWeightIndicator(
                      total: totalWeight,
                      isValid: weightOk,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // ── Run Simulation button ──────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: weightOk
                            ? () {
                                provider.recalculate();
                                _showSimulationResultModal(
                                  context,
                                  provider,
                                  original,
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: weightOk
                              ? AppColors.primaryDark
                              : AppColors.primary40,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.buttonRadius,
                            ),
                          ),
                        ),
                        child: Text(
                          'Run Simulation',
                          style: AppTypography.buttonLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: _MainBottomNav(
        selectedIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.of(context).pushNamed('/dashboard');
              break;
            case 1:
              Navigator.of(context).pushNamed('/create-decision');
              break;
            case 3:
              Navigator.of(context).pushNamed('/history');
              break;
            case 4:
              Navigator.of(context).pushNamed('/profile');
              break;
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.sectionTitle.copyWith(color: AppColors.textPurple),
    );
  }

  Widget _buildOriginalPriorities(SimulationProvider provider) {
    final originalWeights = provider.originalWeights;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.primary20,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.info_outline,
                color: AppColors.primary88,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Original Priorities',
              style: AppTypography.sectionInnerTitle.copyWith(
                color: AppColors.textPurple,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ...originalWeights.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getDisplayName(entry.key),
                  style: AppTypography.body.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${entry.value.toInt()}%',
                  style: AppTypography.body.copyWith(
                    color: AppColors.primary88,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  String _getDisplayName(String critId) {
    switch (critId.toLowerCase()) {
      case 'price':
      case 'harga':
        return 'Harga';
      case 'performance':
      case 'performa':
        return 'Performa';
      case 'battery':
      case 'battery life':
      case 'baterai':
        return 'Baterai';
      case 'storage':
      case 'penyimpanan':
        return 'Penyimpanan';
      case 'weight':
      case 'berat':
        return 'Berat';
      default:
        return critId;
    }
  }

  void _showSimulationResultModal(
    BuildContext context,
    SimulationProvider provider,
    dynamic original,
  ) {
    final simulated = provider.simulatedResult;
    if (simulated == null) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _SimulationResultModal(
        original: original,
        simulated: simulated,
        rankChanges: provider.rankChanges,
        onTryAgain: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

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
                  style: AppTypography.body.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${value.toStringAsFixed(1)}',
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
            inactiveColor: AppColors.border,
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isValid ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle_outline : Icons.warning_amber_rounded,
            color: isValid ? Colors.green.shade700 : Colors.red.shade700,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Total: ${total.toStringAsFixed(1)}'
            '${isValid ? '' : ' (must equal 100%)'}',
            style: AppTypography.body.copyWith(
              color: isValid ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Simulation Result Modal — shows original vs new ranking
class _SimulationResultModal extends StatelessWidget {
  final dynamic original;
  final dynamic simulated;
  final Map<String, int> rankChanges;
  final VoidCallback onTryAgain;

  const _SimulationResultModal({
    required this.original,
    required this.simulated,
    required this.rankChanges,
    required this.onTryAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.dialogRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.dialogPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Simulation Result',
                  style: AppTypography.sectionTitle.copyWith(
                    color: AppColors.textPurple,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.textPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Original Ranking
            _RankingSection(
              title: 'Original Ranking',
              ranking: original.ranking,
            ),
            const SizedBox(height: AppSpacing.lg),

            // New Ranking
            _RankingSection(
              title: 'New Ranking',
              ranking: simulated.ranking,
            ),
            const SizedBox(height: AppSpacing.md),

            // Note
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary20,
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.primary88,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Changing your priorities changed the ranking.',
                          style: AppTypography.small.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Note: This simulation does not change your original decision.',
                          style: AppTypography.small.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Try Another Scenario button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onTryAgain,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                  ),
                ),
                child: Text(
                  'Try Another Scenario',
                  style: AppTypography.buttonLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RankingSection extends StatelessWidget {
  final String title;
  final List<dynamic> ranking;

  const _RankingSection({
    required this.title,
    required this.ranking,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.sectionInnerTitle.copyWith(
            color: AppColors.textPurple,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...ranking.asMap().entries.map((entry) {
          final index = entry.key;
          final ranked = entry.value;
          return _RankItem(
            rank: index + 1,
            name: ranked.alternative.name,
            score: ranked.compositeScore,
            isFirst: index == 0,
          );
        }),
      ],
    );
  }
}

class _RankItem extends StatelessWidget {
  final int rank;
  final String name;
  final double score;
  final bool isFirst;

  const _RankItem({
    required this.rank,
    required this.name,
    required this.score,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          // Rank badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isFirst
                  ? AppColors.primary88
                  : AppColors.primary20,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: AppTypography.smallSemibold.copyWith(
                  color: isFirst ? Colors.white : AppColors.primary88,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Name and score
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${score.toStringAsFixed(2)}',
                  style: AppTypography.small.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Main Bottom Navigation — Home, Decision, Insight, History, Profile
class _MainBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _MainBottomNav({
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
              _NavItem(
                icon: Icons.home,
                label: 'Home',
                isSelected: selectedIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.add_circle_outline,
                label: 'Decision',
                isSelected: selectedIndex == 1,
                onTap: () => onTap(1),
                isAction: true,
              ),
              _NavItem(
                icon: Icons.bar_chart,
                label: 'Insight',
                isSelected: selectedIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                icon: Icons.history,
                label: 'History',
                isSelected: selectedIndex == 3,
                onTap: () => onTap(3),
              ),
              _NavItem(
                icon: Icons.person_outline,
                label: 'Profile',
                isSelected: selectedIndex == 4,
                onTap: () => onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isAction;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    this.isAction = false,
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
              color: isAction
                  ? AppColors.primaryDark
                  : (isSelected
                      ? AppColors.primary88.withValues(alpha: 0.15)
                      : Colors.transparent),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isAction
                  ? Colors.white
                  : (isSelected ? AppColors.primary88 : AppColors.textTertiary),
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.extraSmallSemibold.copyWith(
              color: isAction
                  ? AppColors.primaryDark
                  : (isSelected ? AppColors.primary88 : AppColors.textTertiary),
            ),
          ),
        ],
      ),
    );
  }
}
