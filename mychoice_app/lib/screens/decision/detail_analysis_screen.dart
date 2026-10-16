import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class DetailAnalysisScreen extends StatelessWidget {
  const DetailAnalysisScreen({
    super.key,
    this.onComparison,
    this.onTabSelected,
  });

  final VoidCallback? onComparison;
  final ValueChanged<int>? onTabSelected;

  static const purple = AppColors.primary88;
  static const darkPurple = AppColors.textPurple;

  static const List<_ScoreContribution> contributions = [
    _ScoreContribution(
      name: 'Performance',
      value: 0.3325,
    ),
    _ScoreContribution(
      name: 'Price',
      value: 0.2700,
    ),
    _ScoreContribution(
      name: 'Battery',
      value: 0.1600,
    ),
    _ScoreContribution(
      name: 'Storage',
      value: 0.1275,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.surfaceLight,
      body: Stack(
        children: [
          const _BackgroundGlow(),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      27,
                      22,
                      27,
                      20,
                    ),
                    child: _buildContent(),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 39,
                  ),
                  child: _buildComparisonButton(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 19,
        vertical: 9,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 42,
            child: IconButton(
              tooltip: 'Back',
              onPressed: () => Navigator.maybePop(context),
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: darkPurple,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Detailed Analysis',
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
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '🤖',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'AI Decision Analysis',
              style: AppTypography.sectionInnerTitle.copyWith(
                color: darkPurple,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        Text(
          'Why is Lenovo IdeaPad Slim 5 ranked #1?',
          style: AppTypography.small.copyWith(
            color: darkPurple,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          'Lenovo achieved the highest overall score because it performed '
          'strongly on the criteria you prioritized, especially Performance '
          'and Price.',
          style: AppTypography.small.copyWith(
            color: darkPurple,
            fontSize: 10,
            height: 1.35,
            fontWeight: FontWeight.w400,
          ),
        ),

        const SizedBox(height: 22),

        Text(
          'Score Contribution',
          style: AppTypography.sectionInnerTitle.copyWith(
            color: darkPurple,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 15),

        ...contributions.map(
          (item) => _buildContributionRow(item),
        ),

        const SizedBox(height: 22),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '💡',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            const SizedBox(width: 3),
            Text(
              'Key Insight',
              style: AppTypography.small.copyWith(
                color: darkPurple,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Text(
          'Performance has the largest impact because you gave it the '
          'highest weight: 35%.',
          style: AppTypography.small.copyWith(
            color: darkPurple,
            fontSize: 10,
            height: 1.35,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildContributionRow(
    _ScoreContribution item,
  ) {
    const maxValue = 0.3325;

    final barWidth = 110.0 * (item.value / maxValue);

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 5,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Text(
              item.name,
              style: AppTypography.small.copyWith(
                color: darkPurple,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 8,
                width: barWidth,
                decoration: BoxDecoration(
                  color: darkPurple,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          SizedBox(
            width: 42,
            child: Text(
              item.value.toStringAsFixed(4),
              textAlign: TextAlign.right,
              style: AppTypography.small.copyWith(
                color: darkPurple,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonButton(BuildContext context) {
    return SizedBox(
      width: 139,
      height: 39,
      child: Material(
        color: darkPurple,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onComparison ??
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Comparison screen is not connected yet.',
                    ),
                  ),
                );
              },
          borderRadius: BorderRadius.circular(22),
          child: Center(
            child: Text(
              'View Comparison',
              style: AppTypography.buttonMedium.copyWith(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreContribution {
  const _ScoreContribution({
    required this.name,
    required this.value,
  });

  final String name;
  final double value;
}

class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFEFF2F4),
                  Color(0xFFF1F3F5),
                  Color(0xFFE9EDF0),
                ],
              ),
            ),
          ),

          Positioned(
            top: -90,
            left: 55,
            child: _glow(
              size: 240,
              color: const Color(0xFFAAADE0),
            ),
          ),

          Positioned(
            bottom: -90,
            left: -55,
            child: _glow(
              size: 250,
              color: const Color(0xFF9B8AD2),
            ),
          ),

          Positioned(
            bottom: -70,
            right: -75,
            child: _glow(
              size: 220,
              color: const Color(0xFFAEBBE9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glow({
    required double size,
    required Color color,
  }) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: 45,
        sigmaY: 45,
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(
            alpha: 0.55,
          ),
        ),
      ),
    );
  }
}