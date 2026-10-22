import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// MF-08 — side-by-side comparison of analyzed choices.
class Mf08ComparisonScreen extends StatelessWidget {
  const Mf08ComparisonScreen({
    super.key,
    required this.choices,
    this.category = 'Technology',
    this.subcategory = 'Laptop',
  });

  final List<ComparisonChoice> choices;
  final String category;
  final String subcategory;

  List<ComparisonChoice> get _rankedChoices {
    final ranked = List<ComparisonChoice>.of(choices)
      ..sort((a, b) => b.finalScore.compareTo(a.finalScore));
    return ranked;
  }

  List<String> get _criteria {
    final criteria = <String>{};
    for (final choice in choices) {
      criteria.addAll(choice.criteriaValues.keys);
    }
    return criteria.toList();
  }

  IconData get _categoryIcon => switch (category.toLowerCase()) {
    'education' => Icons.school_rounded,
    'fashion' => Icons.checkroom_rounded,
    _ => Icons.devices_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final ranked = _rankedChoices;
    final criteria = _criteria;

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        title: const Text('Comparison'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPurple,
        elevation: 0,
      ),
      body: choices.length < 2
          ? const _ComparisonEmptyState()
          : Container(
              decoration: const BoxDecoration(
                gradient: AppColors.softGradientBackground,
              ),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                children: [
                  Row(
                    children: [
                      Icon(
                        _categoryIcon,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        subcategory,
                        style: const TextStyle(
                          color: AppColors.textPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Comparing ${choices.length} options',
                    style: const TextStyle(
                      color: AppColors.textPurple,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 1, color: AppColors.grey400),
                  const SizedBox(height: 18),
                  _buildComparisonTable(criteria),
                  const SizedBox(height: 25),
                  _buildWeights(criteria),
                  const SizedBox(height: 22),
                  _buildFinalScores(ranked),
                  const SizedBox(height: 22),
                  FilledButton(
                    onPressed: () =>
                        _showCalculation(context, criteria, ranked),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.textPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text('View Calculation'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildComparisonTable(List<String> criteria) {
    final columnWidth = choices.length > 3 ? 86.0 : 72.0;
    final tableWidth = 106.0 + choices.length * columnWidth;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPurple.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: tableWidth,
            child: Column(
              children: [
                _tableRow(
                  firstCell: '',
                  values: choices.map((choice) => choice.name).toList(),
                  columnWidth: columnWidth,
                  isHeader: true,
                ),
                for (final criterion in criteria)
                  _tableRow(
                    firstCell: criterion,
                    values: choices
                        .map(
                          (choice) =>
                              _formatValue(_comparisonValue(choice, criterion)),
                        )
                        .toList(),
                    columnWidth: columnWidth,
                  ),
                _tableRow(
                  firstCell: 'Final Score',
                  values: choices
                      .map((choice) => choice.finalScore.toStringAsFixed(2))
                      .toList(),
                  columnWidth: columnWidth,
                  isFinal: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tableRow({
    required String firstCell,
    required List<String> values,
    required double columnWidth,
    bool isHeader = false,
    bool isFinal = false,
  }) {
    final color = isHeader || isFinal
        ? AppColors.textPurple
        : AppColors.textSecondary;
    return Container(
      constraints: const BoxConstraints(minHeight: 31),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: isFinal ? AppColors.primary20 : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: AppColors.grey200,
            width: isFinal ? 0 : 0.7,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 78,
            child: Text(
              firstCell,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: isHeader ? 12 : 12,
                fontWeight: isHeader || isFinal
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ),
          for (final value in values)
            SizedBox(
              width: columnWidth,
              child: Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isHeader ? AppColors.textSecondary : color,
                    fontSize: isHeader ? 11 : 12,
                    fontWeight: isHeader || isFinal
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeights(List<String> criteria) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final criterion in criteria)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    criterion,
                    style: const TextStyle(
                      color: AppColors.textPurple,
                      fontSize: 13,
                    ),
                  ),
                ),
                Text(
                  '${_weightFor(criterion).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: AppColors.textPurple,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildFinalScores(List<ComparisonChoice> ranked) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Final Score',
        style: TextStyle(
          color: AppColors.textPurple,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 5),
      for (var index = 0; index < ranked.length; index++)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${index == 0 ? '🏅 ' : ''}${ranked[index].name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPurple,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                ranked[index].finalScore.toStringAsFixed(2),
                style: const TextStyle(
                  color: AppColors.textPurple,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
    ],
  );

  double _weightFor(String criterion) {
    final contributions = choices
        .map((choice) => choice.criteriaContributions[criterion])
        .whereType<double>();
    var maximum = 0.0;
    for (final contribution in contributions) {
      if (contribution > maximum) maximum = contribution;
    }
    return maximum * 100;
  }

  double? _comparisonValue(ComparisonChoice choice, String criterion) {
    final contribution = choice.criteriaContributions[criterion];
    final maximumContribution = choices
        .map((item) => item.criteriaContributions[criterion] ?? 0)
        .fold<double>(0, (maximum, value) => value > maximum ? value : maximum);
    if (contribution != null && maximumContribution > 0) {
      return contribution / maximumContribution;
    }
    return choice.criteriaValues[criterion];
  }

  String _formatValue(double? value) {
    if (value == null) return '—';
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
  }

  Future<void> _showCalculation(
    BuildContext context,
    List<String> criteria,
    List<ComparisonChoice> ranked,
  ) => showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text(
        'Perhitungan skor',
        style: TextStyle(color: AppColors.textPurple),
      ),
      content: SizedBox(
        width: 360,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Skor akhir adalah jumlah kontribusi setiap kriteria.',
                style: TextStyle(color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 14),
              for (final choice in ranked) ...[
                Text(
                  choice.name,
                  style: const TextStyle(
                    color: AppColors.textPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                for (final criterion in criteria)
                  if (choice.criteriaContributions[criterion] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '$criterion · ${_weightFor(criterion).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Text(
                            choice.criteriaContributions[criterion]!
                                .toStringAsFixed(4),
                            style: const TextStyle(
                              color: AppColors.textPurple,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 12),
                  child: Text(
                    'Total ${choice.finalScore.toStringAsFixed(4)}',
                    style: const TextStyle(
                      color: AppColors.textPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Tutup'),
        ),
      ],
    ),
  );
}

class ComparisonChoice {
  const ComparisonChoice({
    required this.name,
    required this.finalScore,
    this.criteriaValues = const {},
    this.criteriaContributions = const {},
  });

  final String name;
  final double finalScore;
  final Map<String, double> criteriaValues;
  final Map<String, double> criteriaContributions;
}

class _ComparisonEmptyState extends StatelessWidget {
  const _ComparisonEmptyState();

  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.all(28),
      child: Text(
        'Perbandingan tersedia setelah hasil analisis memiliki '
        'minimal dua pilihan.',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.textSecondary),
      ),
    ),
  );
}
