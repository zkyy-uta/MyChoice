import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/mobile_background.dart';
import 'package:mychoice_app/features/decision_history/presentation/providers/decision_history_provider.dart';

class HistoryDecision {
  const HistoryDecision({
    required this.id,
    required this.category,
    required this.title,
    required this.score,
    required this.dateGroup,
    required this.date,
    required this.recordedAt,
    this.priorities = const {
      'Price': 30,
      'Performance': 35,
      'Battery': 20,
      'Storage': 15,
    },
    this.status = 'Decision Made',
    this.review = '',
    this.rating = 0,
  });

  final String id;
  final String category;
  final String title;
  final double score;
  final String dateGroup;
  final String date;
  final DateTime recordedAt;
  final Map<String, int> priorities;
  final String status;
  final String review;
  final int rating;

  IconData get icon => switch (category) {
    'Technology' => Icons.laptop_mac_rounded,
    'Education' || 'Internship' => Icons.school_rounded,
    'Fashion' => Icons.checkroom_rounded,
    _ => Icons.category_rounded,
  };
}

class HistoryDetailScreen extends StatefulWidget {
  const HistoryDetailScreen({
    required this.decision,
    this.decisionHistoryId,
    super.key,
  });

  final HistoryDecision decision;
  final String? decisionHistoryId;

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  late TextEditingController _reviewController;
  int _selectedRating = 0;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _reviewController = TextEditingController(text: widget.decision.review);
    _selectedRating = widget.decision.rating;
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _saveReviewAndRating() async {
    final historyId = widget.decisionHistoryId ?? widget.decision.id;
    if (historyId.isEmpty) return;

    setState(() => _isSaving = true);
    try {
      final provider = context.read<DecisionHistoryProvider>();
      final success = await provider.saveReviewAndRating(
        decisionHistoryId: historyId,
        rating: _selectedRating,
        review: _reviewController.text.trim().isEmpty
            ? null
            : _reviewController.text.trim(),
      );

      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ulasan dan bintang rating tersimpan.'),
            backgroundColor: AppColors.success80,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.error ?? 'Gagal menyimpan ulasan.'),
            backgroundColor: AppColors.error80,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan ulasan: $e'),
          backgroundColor: AppColors.error80,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MobileBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Decision Detail', style: AppTypography.appBarTitle),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenHorizontal,
                    AppSpacing.lg,
                    AppSpacing.screenHorizontal,
                    120,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(widget.decision.icon, color: AppColors.primaryDark),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            widget.decision.category,
                            style: AppTypography.oneLinerSemibold.copyWith(
                              color: AppColors.textPurple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(widget.decision.title, style: AppTypography.small),
                      const SizedBox(height: AppSpacing.md),
                      _DetailSection(
                        title: 'Decision Date',
                        child: Text(widget.decision.date, style: AppTypography.small),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _DetailSection(
                        title: 'Final Score',
                        child: Text(
                          'Score: ${widget.decision.score.toStringAsFixed(2)}',
                          style: AppTypography.small,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _DetailSection(
                        title: 'Your Priorities',
                        child: Column(
                          children: widget.decision.priorities.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      entry.key,
                                      style: AppTypography.small,
                                    ),
                                  ),
                                  Text(
                                    '${entry.value}%',
                                    style: AppTypography.small,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _DetailSection(
                        title: 'Decision Status',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              size: 15,
                              color: AppColors.primary88,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(widget.decision.status, style: AppTypography.small),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const Divider(color: AppColors.grey400),
                      const SizedBox(height: AppSpacing.md),
                      _DetailSection(
                        title: 'Your Review',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: List.generate(
                                5,
                                (index) => IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(
                                    Icons.star_rounded,
                                    size: 20,
                                    color: index < _selectedRating
                                        ? AppColors.warning80
                                        : AppColors.grey300,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _selectedRating = index + 1;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              _selectedRating == 0
                                  ? 'Belum memberi rating'
                                  : 'Rating: $_selectedRating bintang',
                              style: AppTypography.small.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            TextField(
                              controller: _reviewController,
                              maxLines: 3,
                              style: AppTypography.small.copyWith(
                                color: AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Write your review here...',
                                hintStyle: AppTypography.small.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                                  borderSide: const BorderSide(color: AppColors.border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                                  borderSide: const BorderSide(color: AppColors.primary88, width: 1.4),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                  vertical: AppSpacing.md,
                                ),
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: FilledButton.icon(
                                onPressed: _isSaving ? null : _saveReviewAndRating,
                                icon: _isSaving
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.save_rounded,
                                        size: 18,
                                      ),
                                label: Text(
                                  _isSaving
                                      ? 'Menyimpan...'
                                      : 'Simpan Ulasan & Rating',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.oneLinerSemibold.copyWith(
            color: AppColors.textPurple,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        child,
      ],
    );
  }
}
