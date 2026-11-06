import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/bottom_navigation.dart';
import '../../../core/widgets/mobile_background.dart';
import '../history/history_sample_data.dart';

class InsightScreen extends StatelessWidget {
  const InsightScreen({super.key});

  void _onNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/dashboard');
      case 1:
        Navigator.of(context).pushNamed('/create-decision');
      case 2:
        break;
      case 3:
        Navigator.of(context).pushNamed('/history');
      case 4:
        Navigator.of(context).pushNamed('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final decisions = historySampleDecisions;
    final decisionCount = decisions.length;
    final averageScore = decisionCount == 0
        ? 0.0
        : decisions.fold<double>(0, (total, item) => total + item.score) /
              decisionCount;

    final categoryCounts = <String, int>{};
    final priorityTotals = <String, double>{};
    for (final decision in decisions) {
      categoryCounts.update(
        decision.category,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
      for (final entry in decision.priorities.entries) {
        priorityTotals.update(
          entry.key,
          (total) => total + entry.value,
          ifAbsent: () => entry.value.toDouble(),
        );
      }
    }

    final averagePriorities =
        priorityTotals.entries
            .map(
              (entry) => _PriorityValue(
                name: entry.key,
                percent: decisionCount == 0 ? 0 : entry.value / decisionCount,
              ),
            )
            .toList()
          ..sort((a, b) => b.percent.compareTo(a.percent));
    final topPriorities = averagePriorities.take(3).toList();
    final otherPercent = averagePriorities
        .skip(3)
        .fold<double>(0, (total, item) => total + item.percent);
    final rankedCategories = categoryCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topCategory = rankedCategories.isEmpty ? null : rankedCategories[0];
    final commonPriorityNames = topPriorities
        .take(2)
        .map((item) => item.name)
        .toList();

    return MobileBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Your Decision Insights',
            style: AppTypography.appBarTitle,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.textPurple,
          elevation: 0,
        ),
        body: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
            children: [
              Text(
                'Based on your available decision history:',
                style: AppTypography.smallSemibold.copyWith(
                  color: AppColors.textPurple,
                ),
              ),
              const SizedBox(height: 14),
              _TotalDecisionsCard(count: decisionCount),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _StatisticCard(
                      icon: Icons.category_outlined,
                      label: 'Top Category',
                      value: topCategory?.key ?? '—',
                      detail: topCategory == null
                          ? 'No data'
                          : '${topCategory.value} of $decisionCount decisions',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatisticCard(
                      icon: Icons.insights_rounded,
                      label: 'Average Score',
                      value: decisionCount == 0
                          ? '—'
                          : '${(averageScore * 100).toStringAsFixed(0)}%',
                      detail: 'Across all decisions',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _SectionCard(
                title: 'Your Common Priorities',
                subtitle: 'Average weight across available decisions',
                child: Column(
                  children: [
                    for (final priority in topPriorities)
                      _PriorityRow(
                        name: priority.name,
                        percent: priority.percent,
                        maximum: topPriorities.firstOrNull?.percent ?? 1,
                      ),
                    if (averagePriorities.length > 3)
                      _PriorityRow(
                        name: 'Other',
                        percent: otherPercent,
                        maximum: topPriorities.firstOrNull?.percent ?? 1,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _WhatIfCard(decisionCount: decisionCount),
              const SizedBox(height: 14),
              _DecisionPatternCard(commonPriorities: commonPriorityNames),
              const SizedBox(height: 14),
              _SectionCard(
                title: 'Decision Categories',
                subtitle: 'Share of recorded decisions by category',
                child: _CategoryDistributionChart(
                  categories: rankedCategories,
                  total: decisionCount,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigation(
          selectedIndex: 2,
          onSelected: (index) => _onNavigation(context, index),
        ),
      ),
    );
  }
}

class _PriorityValue {
  const _PriorityValue({required this.name, required this.percent});

  final String name;
  final double percent;
}

class _CategoryDistributionChart extends StatelessWidget {
  const _CategoryDistributionChart({
    required this.categories,
    required this.total,
  });

  static const _colors = [
    AppColors.primary88,
    Color(0xFF39A89B),
    Color(0xFFF2A65A),
    Color(0xFF7C8FE8),
    Color(0xFFE77991),
    Color(0xFF8C6CCB),
  ];

  final List<MapEntry<String, int>> categories;
  final int total;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty || total == 0) {
      return Text(
        'No decision history available yet.',
        style: AppTypography.small.copyWith(color: AppColors.textSecondary),
      );
    }

    final summary = categories
        .map(
          (category) =>
              '${category.key}: ${category.value} '
              '(${(category.value / total * 100).round()}%)',
        )
        .join(', ');

    return Semantics(
      label: 'Decision category distribution. $summary',
      child: Row(
        children: [
          ExcludeSemantics(
            child: SizedBox(
              width: 112,
              height: 112,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size.square(112),
                    painter: _CategoryDonutPainter(
                      categories: categories,
                      total: total,
                      colors: _colors,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$total',
                        style: AppTypography.smallSemibold.copyWith(
                          color: AppColors.textPurple,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        'decisions',
                        style: AppTypography.small.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var index = 0; index < categories.length; index++)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: index == categories.length - 1 ? 0 : 9,
                    ),
                    child: _CategoryLegendItem(
                      name: categories[index].key,
                      count: categories[index].value,
                      total: total,
                      color: _colors[index % _colors.length],
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

class _CategoryLegendItem extends StatelessWidget {
  const _CategoryLegendItem({
    required this.name,
    required this.count,
    required this.total,
    required this.color,
  });

  final String name;
  final int count;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Expanded(
        child: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.small.copyWith(
            color: AppColors.textPurple,
            fontSize: 10,
          ),
        ),
      ),
      const SizedBox(width: 4),
      Text(
        '$count · ${(count / total * 100).round()}%',
        style: AppTypography.extraSmallSemibold.copyWith(
          color: AppColors.textPurple,
        ),
      ),
    ],
  );
}

class _CategoryDonutPainter extends CustomPainter {
  const _CategoryDonutPainter({
    required this.categories,
    required this.total,
    required this.colors,
  });

  final List<MapEntry<String, int>> categories;
  final int total;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.shortestSide * 0.15;
    final chartRect = Offset.zero & size;
    final rect = chartRect.deflate(strokeWidth / 2);
    var startAngle = -math.pi / 2;

    for (var index = 0; index < categories.length; index++) {
      final sweepAngle = categories[index].value / total * math.pi * 2;
      final paint = Paint()
        ..color = colors[index % colors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _CategoryDonutPainter oldDelegate) =>
      oldDelegate.categories != categories ||
      oldDelegate.total != total ||
      oldDelegate.colors != colors;
}

class _TotalDecisionsCard extends StatelessWidget {
  const _TotalDecisionsCard({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.82),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: Colors.white, width: 1.2),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadow.withValues(alpha: 0.16),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        Text(
          '$count',
          style: AppTypography.sectionTitle.copyWith(
            color: AppColors.textPurple,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          'Total Decisions',
          style: AppTypography.small.copyWith(color: AppColors.textPurple),
        ),
      ],
    ),
  );
}

class _StatisticCard extends StatelessWidget {
  const _StatisticCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.detail,
  });

  final IconData icon;
  final String label;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 100),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.76),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.white, width: 1.1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.primary88),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.extraSmallSemibold.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.oneLinerSemibold.copyWith(
            color: AppColors.textPurple,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          detail,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.small.copyWith(
            color: AppColors.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    ),
  );
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child, this.subtitle});

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.78),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.white, width: 1.1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.smallSemibold.copyWith(
            color: AppColors.textPurple,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: AppTypography.small.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
        const SizedBox(height: 10),
        child,
      ],
    ),
  );
}

class _PriorityRow extends StatelessWidget {
  const _PriorityRow({
    required this.name,
    required this.percent,
    required this.maximum,
  });

  final String name;
  final double percent;
  final double maximum;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: AppTypography.extraSmallSemibold.copyWith(
              color: AppColors.textPurple,
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 96,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: maximum <= 0 ? 0 : (percent / maximum).clamp(0, 1),
              minHeight: 6,
              backgroundColor: AppColors.primary20,
              color: AppColors.primary88,
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 34,
          child: Text(
            '${percent.round()}%',
            textAlign: TextAlign.end,
            style: AppTypography.extraSmallSemibold.copyWith(
              color: AppColors.textPurple,
            ),
          ),
        ),
      ],
    ),
  );
}

class _WhatIfCard extends StatelessWidget {
  const _WhatIfCard({required this.decisionCount});

  final int decisionCount;

  @override
  Widget build(BuildContext context) => _SectionCard(
    title: 'What-If Usage',
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.auto_awesome_outlined,
          size: 17,
          color: AppColors.primary88,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Not tracked yet',
                style: AppTypography.smallSemibold.copyWith(
                  color: AppColors.textPurple,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Usage tracking is not available for these '
                '$decisionCount decision records.',
                style: AppTypography.small.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _DecisionPatternCard extends StatelessWidget {
  const _DecisionPatternCard({required this.commonPriorities});

  final List<String> commonPriorities;

  @override
  Widget build(BuildContext context) {
    final pattern = commonPriorities.isEmpty
        ? 'Add decisions with priorities to reveal your decision pattern.'
        : 'You most often prioritize ${commonPriorities.join(' and ')} when making decisions.';

    return _SectionCard(
      title: 'Decision Pattern',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            size: 17,
            color: AppColors.primary88,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              pattern,
              style: AppTypography.small.copyWith(
                color: AppColors.textPurple,
                fontSize: 11,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
