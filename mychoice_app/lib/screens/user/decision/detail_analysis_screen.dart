import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/mobile_background.dart';
import '../comparison/mf08_manual_choice_structuring_screen.dart';
import 'result_screen.dart';

class DetailAnalysisScreen extends StatelessWidget {
  const DetailAnalysisScreen({
    super.key,
    this.category = 'Technology',
    this.subcategory = 'Laptop',
    this.choices = const [],
    this.onComparison,
    this.onTabSelected,
  });

  final String category;
  final String subcategory;
  final List<RankedChoice> choices;
  final VoidCallback? onComparison;
  final ValueChanged<int>? onTabSelected;

  static const purple = AppColors.primary88;
  static const darkPurple = AppColors.textPurple;

  static const List<_ScoreContribution> _contributions = [
    _ScoreContribution(name: 'Performance', value: 0.3325),
    _ScoreContribution(name: 'Price', value: 0.2700),
    _ScoreContribution(name: 'Battery', value: 0.1600),
    _ScoreContribution(name: 'Storage', value: 0.1275),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MobileBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(27, 22, 27, 20),
                  child: _buildContent(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 39),
                child: _buildComparisonButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 9),
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
            const Text('🤖', style: TextStyle(fontSize: 14)),
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

        ..._contributions.map((item) => _buildContributionRow(item)),

        const SizedBox(height: 22),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('💡', style: TextStyle(fontSize: 10)),
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

  Widget _buildContributionRow(_ScoreContribution item) {
    // Lebar setiap bar disesuaikan dengan desain Figma.
    // Nilai skor tetap menggunakan data aslinya.
    final double barWidth =
        {
          'Performance': 110.0,
          'Price': 87.0,
          'Battery': 38.0,
          'Storage': 23.0,
        }[item.name] ??
        0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
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
      width: 148,
      height: 42,
      child: Material(
        color: darkPurple,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onComparison ??
              () {
                final compChoices = choices.isNotEmpty
                    ? choices
                        .map(
                          (c) => ComparisonChoice(
                            name: c.name,
                            finalScore: c.score,
                          ),
                        )
                        .toList()
                    : const [
                        ComparisonChoice(
                          name: 'Lenovo IdeaPad Slim 5',
                          finalScore: 0.86,
                        ),
                        ComparisonChoice(
                          name: 'ASUS Vivobook 14',
                          finalScore: 0.79,
                        ),
                        ComparisonChoice(
                          name: 'Acer Aspire 5',
                          finalScore: 0.74,
                        ),
                      ];

                Navigator.of(context).pushNamed(
                  '/mf08-comparison',
                  arguments: Mf08ComparisonArguments(
                    category: category,
                    subcategory: subcategory,
                    choices: compChoices,
                  ),
                );
              },
          borderRadius: BorderRadius.circular(22),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.compare_arrows_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  'View Comparison',
                  style: AppTypography.buttonMedium.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreContribution {
  const _ScoreContribution({required this.name, required this.value});

  final String name;
  final double value;
}
