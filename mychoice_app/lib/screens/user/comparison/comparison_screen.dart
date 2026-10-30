import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mychoice_app/features/comparison/presentation/providers/comparison_provider.dart';
import 'package:mychoice_app/core/theme/app_colors.dart';
import 'package:mychoice_app/core/theme/app_spacing.dart';
import 'package:mychoice_app/core/theme/app_typography.dart';

/// Comparison table screen.
/// Shows a horizontally-scrollable matrix of alternatives × criteria with
/// raw / normalised value toggle and best-performer highlighting.
class ComparisonScreen extends StatefulWidget {
  const ComparisonScreen({super.key});

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  bool _showNormalized = false;

  /// Fixed width for the left "criteria names" column
  static const double _leftColWidth = 130.0;

  /// Fixed width for each alternative column
  static const double _altColWidth = 110.0;

  /// Fixed height for every table row
  static const double _rowHeight = 52.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare Alternatives'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<ComparisonProvider>(
        builder: (context, provider, _) {
          final view = provider.view;
          if (view == null) {
            return const Center(child: Text('No comparison data available.'));
          }

          return Column(
            children: [
              // ── Toggle bar ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Text('Show:', style: AppTypography.body),
                    const SizedBox(width: AppSpacing.sm),
                    ChoiceChip(
                      label: const Text('Raw'),
                      selected: !_showNormalized,
                      onSelected: (_) =>
                          setState(() => _showNormalized = false),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    ChoiceChip(
                      label: const Text('Normalized'),
                      selected: _showNormalized,
                      onSelected: (_) =>
                          setState(() => _showNormalized = true),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // ── Table ──────────────────────────────────────────────────
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fixed left column: criteria names
                    SizedBox(
                      width: _leftColWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header cell
                          _HeaderCell(
                            width: _leftColWidth,
                            height: _rowHeight + 16,
                            child: Text(
                              'Criteria',
                              style: AppTypography.buttonMedium,
                            ),
                          ),
                          // Criterion name rows
                          ...view.criteriaIds.map((critId) {
                            final idx = view.criteriaIds.indexOf(critId);
                            final critName = view.criteriaNames[idx];
                            return _Cell(
                              width: _leftColWidth,
                              height: _rowHeight,
                              color: idx.isEven
                                  ? AppColors.surface
                                  : AppColors.cardBackground,
                              child: Text(
                                critName,
                                style: AppTypography.small,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    // Scrollable right section: alternatives
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: view.alternativeIds.map((altId) {
                            final altIdx =
                                view.alternativeIds.indexOf(altId);
                            final altName = view.alternativeNames[altIdx];
                            final rank = view.ranks[altId] ?? 0;
                            final score = view.scores[altId] ?? 0;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Alternative header
                                _AltHeaderCell(
                                  width: _altColWidth,
                                  height: _rowHeight + 16,
                                  name: altName,
                                  rank: rank,
                                  score: score,
                                ),
                                // Value rows
                                ...view.criteriaIds.map((critId) {
                                  final rowIdx =
                                      view.criteriaIds.indexOf(critId);

                                  // Determine if this is the best for this criterion
                                  // We don't have criteriaMap here; use raw/normalized
                                  // best-by-value heuristic (highest raw = best, since
                                  // benefit is dominant; cost inversion handled upstream)
                                  final isBest = _isBestRaw(
                                    view,
                                    critId,
                                    altId,
                                    _showNormalized,
                                  );

                                  final raw = view.rawValues[altId]?[critId];
                                  final norm =
                                      view.normalizedValues[altId]?[critId];
                                  final displayVal = _showNormalized
                                      ? norm
                                      : raw;
                                  final text = displayVal != null
                                      ? displayVal.toStringAsFixed(3)
                                      : '—';

                                  return GestureDetector(
                                    onTap: () => _showCellDetail(
                                      context,
                                      critName:
                                          view.criteriaNames[rowIdx],
                                      altName: altName,
                                      raw: raw,
                                      norm: norm,
                                    ),
                                    child: _Cell(
                                      width: _altColWidth,
                                      height: _rowHeight,
                                      color: isBest
                                          ? AppColors.primary20
                                          : rowIdx.isEven
                                              ? AppColors.surface
                                              : AppColors.cardBackground,
                                      child: Text(
                                        text,
                                        style: AppTypography.small.copyWith(
                                          fontWeight: isBest
                                              ? FontWeight.w700
                                              : FontWeight.normal,
                                          color: isBest
                                              ? AppColors.primary88
                                              : AppColors.textPrimary,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Heuristic: the alternative with the highest value wins (works for both
  /// raw and normalized since normalized preserves ordering within a criterion).
  
  bool _isBestRaw(
    ComparisonView view,
    String critId,
    String altId,
    bool normalized,
  ) {
    final myValues = normalized
        ? view.normalizedValues[altId]
        : view.rawValues[altId];

    final myVal = myValues?[critId];
    if (myVal == null) return false;

    for (final id in view.alternativeIds) {
      if (id == altId) continue;

      final otherValues = normalized
          ? view.normalizedValues[id]
          : view.rawValues[id];

      final other = otherValues?[critId];

      if (other != null && other > myVal) {
        return false;
      }
    }

    return true;
  }

  void _showCellDetail(
    BuildContext context, {
    required String critName,
    required String altName,
    double? raw,
    double? norm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(altName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Criterion: $critName',
              style: AppTypography.body,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Raw value: ${raw?.toStringAsFixed(4) ?? '—'}',
              style: AppTypography.body,
            ),
            Text(
              'Normalized: ${norm?.toStringAsFixed(4) ?? '—'}',
              style: AppTypography.body,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helper cell widgets
// ─────────────────────────────────────────────────────────────────────────────

class _HeaderCell extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const _HeaderCell({
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.primary20,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
          right: BorderSide(color: AppColors.border),
        ),
      ),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}

class _AltHeaderCell extends StatelessWidget {
  final double width;
  final double height;
  final String name;
  final int rank;
  final double score;

  const _AltHeaderCell({
    required this.width,
    required this.height,
    required this.name,
    required this.rank,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.primary20,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
          right: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: AppTypography.small.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: AppColors.primary88,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            ),
            child: Text(
              '#$rank • ${score.toStringAsFixed(1)}%',
              style: AppTypography.extraSmallSemibold.copyWith(
                color: AppColors.textWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Widget child;

  const _Cell({
    required this.width,
    required this.height,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color,
        border: Border(
          bottom: BorderSide(color: AppColors.divider),
          right: BorderSide(color: AppColors.border),
        ),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

