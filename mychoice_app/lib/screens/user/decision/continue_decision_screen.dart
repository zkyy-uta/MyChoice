import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/mobile_background.dart';

class InProgressDecision {
  final String id;
  final String title;
  final String category;
  final String subcategory;
  final double progress;
  final String stepName;
  final List<String> options;
  final Map<String, double> priorities;
  final DateTime lastModified;
  final IconData icon;
  final Color color;

  const InProgressDecision({
    required this.id,
    required this.title,
    required this.category,
    required this.subcategory,
    required this.progress,
    required this.stepName,
    required this.options,
    required this.priorities,
    required this.lastModified,
    required this.icon,
    required this.color,
  });
}

/// Screen for continuing a previously started decision.
class ContinueDecisionScreen extends StatefulWidget {
  const ContinueDecisionScreen({super.key});

  @override
  State<ContinueDecisionScreen> createState() => _ContinueDecisionScreenState();
}

class _ContinueDecisionScreenState extends State<ContinueDecisionScreen> {
  late List<InProgressDecision> _draftDecisions;
  late String _activeId;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _draftDecisions = [
      InProgressDecision(
        id: 'laptop_draft',
        title: 'Laptop Comparison',
        category: 'Technology',
        subcategory: 'Laptop',
        progress: 0.70,
        stepName: 'Step 3: Priority Setting',
        options: const [
          'Lenovo IdeaPad Slim 5',
          'ASUS VivoBook 15',
          'HP Pavilion 15',
        ],
        priorities: const {
          'Price': 30,
          'Performance': 35,
          'Battery': 20,
          'Storage': 15,
        },
        lastModified: DateTime.now().subtract(const Duration(hours: 3)),
        icon: Icons.laptop_mac,
        color: AppColors.categoryTechnology,
      ),
      InProgressDecision(
        id: 'course_draft',
        title: 'Online Course Selection',
        category: 'Education',
        subcategory: 'Course',
        progress: 0.40,
        stepName: 'Step 2: Choices Selected',
        options: const [
          'Coursera Machine Learning Specialization (DeepLearning.AI)',
          'edX CS50: Introduction to Computer Science (Harvard)',
          'Udemy The Complete 2026 Web Development Bootcamp (Angela Yu)',
        ],
        priorities: const {
          'Price': 30,
          'Performance': 35,
          'Battery': 20,
          'Storage': 15,
        },
        lastModified: DateTime.now().subtract(const Duration(days: 1)),
        icon: Icons.school,
        color: AppColors.categoryEducation,
      ),
      InProgressDecision(
        id: 'smartphone_draft',
        title: 'Flagship Smartphone',
        category: 'Technology',
        subcategory: 'Smartphone',
        progress: 0.85,
        stepName: 'Step 3: Ready to Calculate',
        options: const [
          'Apple iPhone 15 Pro Max',
          'Samsung Galaxy S24 Ultra',
          'Google Pixel 8 Pro',
        ],
        priorities: const {
          'Price': 25,
          'Performance': 40,
          'Battery': 20,
          'Storage': 15,
        },
        lastModified: DateTime.now().subtract(const Duration(days: 2)),
        icon: Icons.smartphone,
        color: AppColors.categoryTechnology,
      ),
      InProgressDecision(
        id: 'bag_draft',
        title: 'Travel Backpack',
        category: 'Fashion',
        subcategory: 'Bags',
        progress: 0.50,
        stepName: 'Step 2: Choices Selected',
        options: const [
          'Tumi Alpha 3 Continental Carry-On',
          'Samsonite Winfield 3 DLX Hardside Spinner',
          'Eiger Rhinos 60L Adventure Backpack',
        ],
        priorities: const {
          'Price': 30,
          'Performance': 35,
          'Battery': 20,
          'Storage': 15,
        },
        lastModified: DateTime.now().subtract(const Duration(days: 3)),
        icon: Icons.shopping_bag,
        color: AppColors.categoryFashion,
      ),
    ];
    _activeId = _draftDecisions.first.id;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg is String && arg.isNotEmpty) {
        final query = arg.toLowerCase();
        final match = _draftDecisions.firstWhere(
          (d) =>
              d.title.toLowerCase().contains(query) ||
              d.subcategory.toLowerCase().contains(query) ||
              d.category.toLowerCase().contains(query),
          orElse: () => _draftDecisions.first,
        );
        _activeId = match.id;
      }
    }
  }

  void _resumeDecision(InProgressDecision decision) {
    Navigator.of(context).pushNamed('/create-decision');
  }

  void _deleteDraft(String id) {
    setState(() {
      _draftDecisions.removeWhere((d) => d.id == id);
      if (_draftDecisions.isNotEmpty) {
        _activeId = _draftDecisions.first.id;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Draft decision removed.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeDecision = _draftDecisions.firstWhere(
      (d) => d.id == _activeId,
      orElse: () => _draftDecisions.isNotEmpty
          ? _draftDecisions.first
          : InProgressDecision(
              id: 'none',
              title: 'No Active Draft',
              category: 'Technology',
              subcategory: 'Laptop',
              progress: 0.0,
              stepName: 'Not Started',
              options: const [],
              priorities: const {},
              lastModified: DateTime.now(),
              icon: Icons.edit_note,
              color: AppColors.primary88,
            ),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: MobileBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
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
                          color: AppColors.textPurple,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Continue Decision',
                        textAlign: TextAlign.center,
                        style: AppTypography.sectionInnerTitle.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 19,
                          color: AppColors.textPurple,
                        ),
                      ),
                    ),
                    const SizedBox(width: 42),
                  ],
                ),
              ),

              Expanded(
                child: _draftDecisions.isEmpty
                    ? _buildEmptyState()
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Resume Where You Left Off',
                              style: AppTypography.sectionInnerTitle.copyWith(
                                color: AppColors.textPurple,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Select an unfinished decision below to continue configuring and analyzing.',
                              style: AppTypography.small.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Active Draft Hero Card
                            _buildActiveDraftCard(activeDecision),

                            const SizedBox(height: 28),

                            // Other Draft Decisions Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Other In-Progress Decisions',
                                  style: AppTypography.sectionInnerTitle.copyWith(
                                    color: AppColors.textPurple,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${_draftDecisions.length} drafts',
                                  style: AppTypography.small.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            ..._draftDecisions
                                .where((d) => d.id != activeDecision.id)
                                .map((draft) => _buildDraftItem(draft)),

                            const SizedBox(height: 24),

                            // New Decision Alternative Button
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => Navigator.of(context)
                                    .pushNamed('/create-decision'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary88,
                                  side: const BorderSide(
                                    color: AppColors.primary88,
                                    width: 1.5,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                icon: const Icon(Icons.add),
                                label: const Text('Start A New Decision'),
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

  Widget _buildActiveDraftCard(InProgressDecision decision) {
    final percent = (decision.progress * 100).toInt();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary88.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: decision.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(decision.icon, color: decision.color, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${decision.category} · ${decision.subcategory}',
                      style: AppTypography.small.copyWith(
                        color: decision.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      decision.title,
                      style: AppTypography.sectionInnerTitle.copyWith(
                        color: AppColors.textPurple,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Discard Draft',
                onPressed: () => _deleteDraft(decision.id),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                decision.stepName,
                style: AppTypography.small.copyWith(
                  color: AppColors.textPurple,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$percent% Completed',
                style: AppTypography.small.copyWith(
                  color: decision.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: decision.progress,
              minHeight: 8,
              backgroundColor: AppColors.grey200,
              valueColor: AlwaysStoppedAnimation<Color>(decision.color),
            ),
          ),
          const SizedBox(height: 16),

          // Selected Choices summary
          Text(
            'Selected Options (${decision.options.length}):',
            style: AppTypography.small.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: decision.options.map((opt) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey300),
                ),
                child: Text(
                  opt,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Configured Priorities summary
          if (decision.priorities.isNotEmpty) ...[
            Text(
              'Configured Criteria Weights:',
              style: AppTypography.small.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: decision.priorities.entries.map((entry) {
                return Text(
                  '${entry.key}: ${entry.value.toInt()}%',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.primary88,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],

          // Resume Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => _resumeDecision(decision),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
              label: const Text(
                'Resume Decision',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraftItem(InProgressDecision draft) {
    final percent = (draft.progress * 100).toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: draft.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(draft.icon, color: draft.color, size: 22),
        ),
        title: Text(
          draft.title,
          style: AppTypography.body.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPurple,
          ),
        ),
        subtitle: Text(
          '${draft.subcategory} · $percent% · ${draft.options.length} options',
          style: AppTypography.small.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: OutlinedButton(
          onPressed: () {
            setState(() {
              _activeId = draft.id;
            });
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary88,
            side: const BorderSide(color: AppColors.primary88),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          ),
          child: const Text('Select'),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 64,
              color: AppColors.primary88,
            ),
            const SizedBox(height: 16),
            Text(
              'No In-Progress Decisions',
              style: AppTypography.screenTitle.copyWith(
                color: AppColors.textPurple,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You have no unfinished decision drafts. You can create a new decision anytime.',
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed('/create-decision'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Create New Decision'),
            ),
          ],
        ),
      ),
    );
  }
}
