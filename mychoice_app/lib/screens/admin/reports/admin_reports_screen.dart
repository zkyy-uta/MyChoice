import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/admin_bottom_navigation.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  final _searchController = TextEditingController();
  int? _selectedRating;

  List<_UserReview> get _visibleReviews {
    final query = _searchController.text.trim().toLowerCase();
    return _sampleReviews.where((review) {
      final matchesQuery =
          review.name.toLowerCase().contains(query) ||
          review.comment.toLowerCase().contains(query);
      final matchesRating =
          _selectedRating == null || review.rating == _selectedRating;
      return matchesQuery && matchesRating;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reviews = _visibleReviews;
    final averageRating =
        _sampleReviews.map((review) => review.rating).reduce((a, b) => a + b) /
        _sampleReviews.length;

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceLight,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Reports',
          style: AppTypography.sectionInnerTitle.copyWith(
            color: AppColors.primaryDark,
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Text(
                'Reviews submitted by MyChoice users.',
                style: AppTypography.extraSmallSemibold.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _ReviewSummaryCard(
                      icon: Icons.rate_review_outlined,
                      label: 'Total Reviews',
                      value: '${_sampleReviews.length}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ReviewSummaryCard(
                      icon: Icons.star_rounded,
                      label: 'Average Rating',
                      value: averageRating.toStringAsFixed(1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search name or review',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.primaryDark,
                  ),
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear search',
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.close),
                        ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 8,
                children: [
                  _RatingFilterChip(
                    label: 'All',
                    selected: _selectedRating == null,
                    onSelected: () => setState(() => _selectedRating = null),
                  ),
                  for (var rating = 5; rating >= 1; rating--)
                    _RatingFilterChip(
                      label: '$rating stars',
                      selected: _selectedRating == rating,
                      onSelected: () =>
                          setState(() => _selectedRating = rating),
                    ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            sliver: SliverToBoxAdapter(
              child: Text(
                '${reviews.length} reviews',
                style: AppTypography.extraSmallSemibold.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          if (reviews.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.rate_review_outlined,
                        size: 44,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No reviews found',
                        style: AppTypography.sectionInnerTitle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Try a different search or rating filter.',
                        textAlign: TextAlign.center,
                        style: AppTypography.small,
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              sliver: SliverList.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ReviewCard(review: reviews[index]),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: const AdminBottomNavigation(selectedIndex: 3),
    );
  }
}

class _ReviewSummaryCard extends StatelessWidget {
  const _ReviewSummaryCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.extraSmallSemibold.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: AppTypography.sectionInnerTitle.copyWith(
                    color: Colors.white,
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

class _RatingFilterChip extends StatelessWidget {
  const _RatingFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.primary20,
      backgroundColor: Colors.white,
      labelStyle: AppTypography.extraSmallSemibold.copyWith(
        color: selected ? AppColors.primaryDark : AppColors.textSecondary,
      ),
      side: BorderSide(
        color: selected ? AppColors.primary60 : AppColors.borderLight,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final _UserReview review;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 19,
                backgroundColor: AppColors.primary20,
                child: Text(
                  review.name.characters.first.toUpperCase(),
                  style: AppTypography.smallSemibold.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.name, style: AppTypography.smallSemibold),
                    Text(
                      review.date,
                      style: AppTypography.extraSmallSemibold.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 18,
                    color: AppColors.warning80,
                  ),
                  const SizedBox(width: 2),
                  Text('${review.rating}', style: AppTypography.smallSemibold),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: AppTypography.small.copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _UserReview {
  const _UserReview({
    required this.name,
    required this.date,
    required this.rating,
    required this.comment,
  });

  final String name;
  final String date;
  final int rating;
  final String comment;
}

const _sampleReviews = [
  _UserReview(
    name: 'Najwa Putri',
    date: 'Today',
    rating: 5,
    comment:
        'MyChoice makes it much easier to compare options and feel confident about my decisions.',
  ),
  _UserReview(
    name: 'Bima Sakti',
    date: 'Yesterday',
    rating: 4,
    comment:
        'The comparison flow is helpful. I would love to see more product categories in the future.',
  ),
  _UserReview(
    name: 'Enami Asa',
    date: 'Oct 20, 2026',
    rating: 5,
    comment:
        'Simple to use and the results help me see the pros and cons clearly.',
  ),
  _UserReview(
    name: 'Raka Pratama',
    date: 'Oct 18, 2026',
    rating: 3,
    comment:
        'A useful app for making decisions. Some screens could explain the features a little more.',
  ),
  _UserReview(
    name: 'Siti Aulia',
    date: 'Oct 16, 2026',
    rating: 5,
    comment:
        'I like how organized my decision history is. It is easy to revisit my choices.',
  ),
];
