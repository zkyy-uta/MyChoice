import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../comparison/mf08_manual_choice_structuring_screen.dart';
import 'detail_analysis_screen.dart';
import 'package:mychoice_app/features/what_if_simulation/presentation/providers/simulation_provider.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/decision_result.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/decision_matrix.dart';
import 'package:mychoice_app/features/alternative_management/domain/entities/alternative.dart';
import 'package:mychoice_app/features/criteria_selection/domain/entities/criterion.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/calculation_breakdown.dart';
import 'package:mychoice_app/features/decision_engine/domain/entities/saw_configuration.dart';

/// A single score returned by the SAW decision engine.
/// The UI only displays values; scoring must happen in the backend.
class RankedChoice {
  const RankedChoice({required this.name, required this.score});

  final String name;
  final double score;
}

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    this.category = 'Technology',
    this.subcategory = 'Laptop',
    this.choices = const [
      RankedChoice(name: 'Lenovo IdeaPad Slim 5', score: 0.86),
      RankedChoice(name: 'ASUS Vivobook 14', score: 0.79),
      RankedChoice(name: 'Acer Aspire 5', score: 0.74),
    ],
    this.onComparison,
    this.onAnalysis,
    this.onWhatIf,
    this.onSave,
    this.onTabSelected,
  });

  final String category;
  final String subcategory;
  final List<RankedChoice> choices;
  final VoidCallback? onComparison;
  final VoidCallback? onAnalysis;
  final VoidCallback? onWhatIf;
  final Future<void> Function()? onSave;

  /// 0: Home, 1: Decision, 2: Insight, 3: History, 4: Profile.
  final ValueChanged<int>? onTabSelected;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  static const purple = AppColors.primary88;
  static const darkPurple = AppColors.textPurple;
  bool saving = false;
  bool saved = false;

  void _unavailable(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature screen is not connected yet.')),
    );
  }

  Future<void> _save() async {
    if (saving || saved) return;
    if (widget.onSave == null) {
      _unavailable('Save Decision');
      return;
    }

    setState(() => saving = true);
    try {
      await widget.onSave!();
      if (!mounted) return;
      setState(() => saved = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Decision saved successfully.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save decision. Please retry.')),
      );
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [...widget.choices]
      ..sort((a, b) => b.score.compareTo(a.score));
    final top = sorted.isEmpty ? null : sorted.first;

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 9),
              child: Row(
                children: [
                  SizedBox(
                    width: 42,
                    child: IconButton(
                      tooltip: 'Back',
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 19,
                        color: darkPurple,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Decision Results',
                      textAlign: TextAlign.center,
                      style: AppTypography.sectionInnerTitle.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 19,
                        color: darkPurple,
                      ),
                    ),
                  ),
                  const SizedBox(width: 42),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 115),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎯 Your Decision Results',
                      style: AppTypography.small.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Based on the criteria and priorities you selected',
                      style: AppTypography.extraSmallSemibold.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                        color: AppColors.grey600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: AppColors.grey300, thickness: 0.8),
                    const SizedBox(height: 8),
                    Text(
                      'Category',
                      style: AppTypography.sectionInnerTitle.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: darkPurple,
                      ),
                    ),
                    const SizedBox(height: 11),
                    Row(
                      children: [
                        const Icon(
                          Icons.laptop_mac_rounded,
                          size: 22,
                          color: purple,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            widget.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.small.copyWith(
                              color: darkPurple,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 15,
                            color: purple,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            widget.subcategory,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.small.copyWith(
                              color: darkPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    if (top != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.78),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white, width: 1.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x26777078),
                              blurRadius: 5,
                              offset: Offset(3, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              '🥇 ${top.name}',
                              textAlign: TextAlign.center,
                              style: AppTypography.oneLinerSemibold.copyWith(
                                color: darkPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Final Score',
                              style: AppTypography.small.copyWith(
                                color: purple,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              top.score.toStringAsFixed(2),
                              style: AppTypography.sectionTitle.copyWith(
                                color: darkPurple,
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '⭐ Top Recommendation',
                              style: AppTypography.small.copyWith(
                                color: purple,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Top Picks Ranking',
                        style: AppTypography.sectionInnerTitle.copyWith(
                          color: darkPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...sorted.asMap().entries.map((entry) {
                        final index = entry.key;
                        final choice = entry.value;
                        const medals = ['🥇', '🥈', '🥉'];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              Text(
                                index < medals.length
                                    ? medals[index]
                                    : '${index + 1}.',
                                style: AppTypography.small.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  choice.name,
                                  style: AppTypography.small.copyWith(
                                    fontSize: 13,
                                    color: darkPurple,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                choice.score.toStringAsFixed(2),
                                style: AppTypography.small.copyWith(
                                  fontSize: 13,
                                  color: darkPurple,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ] else ...[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'No ranking results available.',
                            style: AppTypography.body,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    const Divider(color: AppColors.grey400),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: _glassButton(
                        icon: Icons.compare_arrows_rounded,
                        label: 'View Comparison',
                        subtitle: 'Compare the data and scores for each option',
                        onPressed:
                            widget.onComparison ??
                            () => Navigator.of(context).pushNamed(
                              '/mf08-comparison',
                              arguments: Mf08ComparisonArguments(
                                category: widget.category,
                                subcategory: widget.subcategory,
                                choices: widget.choices
                                    .map(
                                      (choice) => ComparisonChoice(
                                        name: choice.name,
                                        finalScore: choice.score,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                        wide: true,
                      ),
                    ),
                    const SizedBox(height: 17),
                    Row(
                      children: [
                        Expanded(
                          child: _glassButton(
                            icon: Icons.lightbulb_outline_rounded,
                            label: 'Analysis Details',
                            subtitle: 'Why these results?',
                            onPressed:
                                widget.onAnalysis ??
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DetailAnalysisScreen(),
                                    ),
                                  );
                                },
                          ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: _glassButton(
                            icon: Icons.autorenew_rounded,
                            label: 'What-If',
                            subtitle: 'Try another scenario',
                            onPressed: () {
                              // Inisialisasi SimulationProvider dengan data keputusan asli
                              final simProvider =
                                  context.read<SimulationProvider>();

                              // Buat mock Alternative dari choices
                              final alternatives =
                                  widget.choices.asMap().entries.map((entry) {
                                final index = entry.key;
                                final choice = entry.value;
                                return Alternative(
                                  id: 'alt_$index',
                                  name: choice.name,
                                  source: 'custom',
                                );
                              }).toList();

                              // Definisikan kriteria
                              final criteria = [
                                Criterion(
                                    id: 'price',
                                    name: 'Price',
                                    type: CriterionType.cost,
                                    source: 'suggested'),
                                Criterion(
                                    id: 'performance',
                                    name: 'Performance',
                                    type: CriterionType.benefit,
                                    source: 'suggested'),
                                Criterion(
                                    id: 'battery',
                                    name: 'Battery',
                                    type: CriterionType.benefit,
                                    source: 'suggested'),
                                Criterion(
                                    id: 'storage',
                                    name: 'Storage',
                                    type: CriterionType.benefit,
                                    source: 'suggested'),
                              ];

                              final criteriaMap = {
                                for (final c in criteria) c.id: c
                              };

                              // Buat matrix dengan nilai mentah
                              final values = <String, Map<String, double>>{};
                              for (final alt in alternatives) {
                                final idx = alternatives.indexOf(alt);
                                values[alt.id] = {
                                  'price': 70.0 + (idx * 5.0),
                                  'performance': 75.0 + (idx * 4.0),
                                  'battery': 65.0 + (idx * 6.0),
                                  'storage': 80.0 + (idx * 3.0),
                                };
                              }

                              final matrix = DecisionMatrix(
                                alternatives: alternatives,
                                criteria: criteria,
                                values: values,
                              );

                              // Bobot asli (dari create decision)
                              final originalWeights = <String, double>{
                                'price': 30.0,
                                'performance': 35.0,
                                'battery': 20.0,
                                'storage': 15.0,
                              };

                              // Buat breakdown per alternative
                              final breakdown = <String, CalculationBreakdown>{};
                              for (int i = 0; i < alternatives.length; i++) {
                                final alt = alternatives[i];
                                final choice = widget.choices[i];
                                final critBreakdown = <String, NormalizedScore>{};
                                for (final crit in criteria) {
                                  final rawValue = values[alt.id]![crit.id]!;
                                  final normalized = rawValue / 100.0;
                                  final weight =
                                      (originalWeights[crit.id] ?? 0) / 100.0;
                                  critBreakdown[crit.id] = NormalizedScore(
                                    normalized: normalized,
                                    weight: weight,
                                    weighted: normalized * weight,
                                  );
                                }
                                breakdown[alt.id] = CalculationBreakdown(
                                  alternativeId: alt.id,
                                  criteria: critBreakdown,
                                  compositeScore: choice.score * 100,
                                );
                              }

                              // Buat ranking
                              final ranking =
                                  widget.choices.asMap().entries.map((entry) {
                                final index = entry.key;
                                final choice = entry.value;
                                return RankedAlternative(
                                  rank: index + 1,
                                  alternative: alternatives[index],
                                  compositeScore: choice.score * 100,
                                );
                              }).toList();

                              final originalResult = DecisionResult(
                                ranking: ranking,
                                breakdown: breakdown,
                                algorithmVersion: '1.0',
                                calculatedAt: DateTime.now(),
                                config: SAWConfiguration.defaultConfig(),
                              );

                              simProvider.initialize(
                                originalResult: originalResult,
                                matrix: matrix,
                                criteriaMap: criteriaMap,
                                originalWeights: originalWeights,
                              );

                              Navigator.of(context).pushNamed('/what-if');
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 33),
                    Center(
                      child: SizedBox(
                        width: 205,
                        height: 43,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary88,
                            disabledBackgroundColor: AppColors.primary88
                                .withValues(alpha: 0.55),
                            shape: const StadiumBorder(),
                          ),
                          onPressed: (saving || saved || top == null)
                              ? null
                              : _save,
                          icon: saving
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  saved
                                      ? Icons.done_all_rounded
                                      : Icons.check_rounded,
                                  size: 18,
                                ),
                          label: Text(
                            saved ? 'Decision Saved' : 'Save Decision',
                            style: AppTypography.buttonMedium,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: _navigation(),
    );
  }

  Widget _glassButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback? onPressed,
    bool wide = false,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.78),
      elevation: 2,
      shadowColor: AppColors.shadow,
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          constraints: BoxConstraints(minHeight: wide ? 55 : 58),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 14, color: purple),
                  const SizedBox(width: 3),
                  Flexible(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: AppTypography.smallSemibold.copyWith(
                        color: darkPurple,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppTypography.small.copyWith(
                  fontSize: 10.5,
                  color: purple,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
