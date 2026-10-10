import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/bottom_navigation.dart';
import 'history_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _categoryFilter = 'All';
  String _dateFilter = 'This Week';
  String _statusFilter = 'All';
  DateTimeRange? _customDateRange;

  final List<HistoryDecision> _decisions = [
    HistoryDecision(
      category: 'Technology',
      title: 'Lenovo IdeaPad Slim 5',
      score: 0.89,
      dateGroup: 'Today',
      date: 'October 3, 2026',
      recordedAt: DateTime(2026, 10, 3),
    ),
    HistoryDecision(
      category: 'Internship',
      title: 'Company A',
      score: 0.86,
      dateGroup: 'Today',
      date: 'October 3, 2026',
      recordedAt: DateTime(2026, 10, 3),
      priorities: {'Learning': 40, 'Culture': 30, 'Location': 20, 'Salary': 10},
      status: 'In Progress',
    ),
    HistoryDecision(
      category: 'Technology',
      title: 'Samsung Galaxy A56',
      score: 0.84,
      dateGroup: 'Yesterday',
      date: 'October 2, 2026',
      recordedAt: DateTime(2026, 10, 2),
      status: 'Reviewed',
    ),
    HistoryDecision(
      category: 'Fashion',
      title: 'Nike Air Max 95 Big Bubble Gore-Tex',
      score: 0.89,
      dateGroup: 'Yesterday',
      date: 'October 2, 2026',
      recordedAt: DateTime(2026, 10, 2),
    ),
    HistoryDecision(
      category: 'Technology',
      title: 'Lenovo IdeaPad Slim 5',
      score: 0.88,
      dateGroup: 'Yesterday',
      date: 'October 2, 2026',
      recordedAt: DateTime(2026, 10, 2),
    ),
    HistoryDecision(
      category: 'Education',
      title: 'UX Design Program',
      score: 0.82,
      dateGroup: 'Earlier',
      date: 'September 15, 2026',
      recordedAt: DateTime(2026, 9, 15),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<HistoryDecision> get _filteredDecisions {
    return _decisions.where((decision) {
      final matchesCategory =
          _categoryFilter == 'All' ||
          decision.category == _categoryFilter ||
          (_categoryFilter == 'Education' && decision.category == 'Internship');
      final matchesDate = switch (_dateFilter) {
        'This Week' =>
          decision.dateGroup == 'Today' || decision.dateGroup == 'Yesterday',
        'This Month' =>
          decision.recordedAt.year == DateTime.now().year &&
              decision.recordedAt.month == DateTime.now().month,
        'Custom' =>
          _customDateRange == null ||
              (!decision.recordedAt.isBefore(_customDateRange!.start) &&
                  !decision.recordedAt.isAfter(_customDateRange!.end)),
        _ => true,
      };
      final matchesStatus =
          _statusFilter == 'All' || decision.status == _statusFilter;
      final searchText = '${decision.category} ${decision.title}'.toLowerCase();
      return matchesCategory &&
          matchesDate &&
          matchesStatus &&
          searchText.contains(_query.toLowerCase());
    }).toList();
  }

  Future<void> _showFilters() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          top: false,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.82,
            ),
            decoration: const BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 26,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 42,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          'Filters',
                          style: AppTypography.oneLinerSemibold.copyWith(
                            color: AppColors.textPurple,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            tooltip: 'Close filters',
                            visualDensity: VisualDensity.compact,
                            onPressed: () => Navigator.pop(sheetContext),
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 20,
                              color: AppColors.textPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _FilterSection(
                    title: 'Category',
                    options: const [
                      'All',
                      'Technology',
                      'Education',
                      'Fashion',
                    ],
                    selected: _categoryFilter,
                    onSelected: (value) {
                      setState(() => _categoryFilter = value);
                      setSheetState(() {});
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _FilterSection(
                    title: 'Date',
                    options: const ['This Week', 'This Month', 'Custom'],
                    selected: _dateFilter,
                    onSelected: (value) async {
                      setState(() => _dateFilter = value);
                      setSheetState(() {});
                      if (value != 'Custom') return;
                      final range = await showDateRangePicker(
                        context: sheetContext,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                        initialDateRange:
                            _customDateRange ??
                            DateTimeRange(
                              start: DateTime(2026, 10, 1),
                              end: DateTime(2026, 10, 11),
                            ),
                      );
                      if (range != null && mounted) {
                        setState(() => _customDateRange = range);
                        setSheetState(() {});
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _FilterSection(
                    title: 'Status',
                    options: const [
                      'All',
                      'Decision Made',
                      'In Progress',
                      'Reviewed',
                    ],
                    selected: _statusFilter,
                    onSelected: (value) {
                      setState(() => _statusFilter = value);
                      setSheetState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onNavigation(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed('/dashboard');
      case 1:
        Navigator.of(context).pushNamed('/create-decision');
      case 2:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Insight feature coming soon')),
        );
      case 3:
        break;
      case 4:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile feature coming soon')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredDecisions;
    final groups = <String, List<HistoryDecision>>{};
    for (final decision in filtered) {
      groups.putIfAbsent(decision.dateGroup, () => []).add(decision);
    }

    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _HistoryHeader(onBack: () => Navigator.of(context).maybePop()),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.md,
                  AppSpacing.screenHorizontal,
                  112,
                ),
                children: [
                  Text(
                    'Your Decisions',
                    style: AppTypography.oneLinerSemibold.copyWith(
                      color: AppColors.textPurple,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 42,
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) =>
                                setState(() => _query = value),
                            style: AppTypography.small.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search Decisions...',
                              hintStyle: AppTypography.small.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                size: 18,
                                color: AppColors.textPurple,
                              ),
                              contentPadding: EdgeInsets.zero,
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.primary88,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.primary88,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Material(
                        color: Colors.white.withValues(alpha: 0.85),
                        elevation: 2,
                        borderRadius: BorderRadius.circular(8),
                        child: IconButton(
                          tooltip: 'Filter category',
                          onPressed: _showFilters,
                          icon: const Icon(
                            Icons.tune_rounded,
                            color: AppColors.textPurple,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_categoryFilter != 'All' ||
                      _dateFilter != 'This Week' ||
                      _statusFilter != 'All') ...[
                    const SizedBox(height: AppSpacing.sm),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: AppSpacing.xs,
                        children: [
                          if (_categoryFilter != 'All')
                            _ActiveFilterChip(
                              label: _categoryFilter,
                              onDeleted: () =>
                                  setState(() => _categoryFilter = 'All'),
                            ),
                          if (_dateFilter != 'This Week')
                            _ActiveFilterChip(
                              label: _dateFilter,
                              onDeleted: () => setState(() {
                                _dateFilter = 'This Week';
                                _customDateRange = null;
                              }),
                            ),
                          if (_statusFilter != 'All')
                            _ActiveFilterChip(
                              label: _statusFilter,
                              onDeleted: () =>
                                  setState(() => _statusFilter = 'All'),
                            ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  if (filtered.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Center(
                        child: Text(
                          'No decisions found',
                          style: AppTypography.body,
                        ),
                      ),
                    )
                  else
                    ...groups.entries.map((group) {
                      return _HistoryGroup(
                        title: group.key,
                        decisions: group.value,
                        onTap: _openDetail,
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 3,
        onSelected: _onNavigation,
      ),
    );
  }

  void _openDetail(HistoryDecision decision) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => HistoryDetailScreen(decision: decision),
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

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
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: options.map((option) {
            final active = option == selected;
            return ChoiceChip(
              label: Text(option),
              labelStyle: AppTypography.small.copyWith(
                color: active ? Colors.white : AppColors.textPurple,
              ),
              selected: active,
              onSelected: (_) => onSelected(option),
              selectedColor: AppColors.primaryDark,
              backgroundColor: AppColors.primary20,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              showCheckmark: false,
              side: BorderSide.none,
              shape: const StadiumBorder(),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ActiveFilterChip extends StatelessWidget {
  const _ActiveFilterChip({required this.label, required this.onDeleted});

  final String label;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text(label, style: AppTypography.small),
      onDeleted: onDeleted,
      deleteIconColor: AppColors.textPurple,
      backgroundColor: AppColors.primary20,
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      child: Row(
        children: [
          SizedBox(
            width: 42,
            child: IconButton(
              tooltip: 'Back',
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.textPurple,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Decision History',
              textAlign: TextAlign.center,
              style: AppTypography.sectionInnerTitle.copyWith(
                color: AppColors.textPurple,
              ),
            ),
          ),
          const SizedBox(width: 42),
        ],
      ),
    );
  }
}

class _HistoryGroup extends StatelessWidget {
  const _HistoryGroup({
    required this.title,
    required this.decisions,
    required this.onTap,
  });

  final String title;
  final List<HistoryDecision> decisions;
  final ValueChanged<HistoryDecision> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Text(
            title,
            style: AppTypography.oneLinerSemibold.copyWith(
              color: AppColors.textPurple,
            ),
          ),
        ),
        ...decisions.map(
          (decision) =>
              _HistoryRow(decision: decision, onTap: () => onTap(decision)),
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.decision, required this.onTap});

  final HistoryDecision decision;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        decision.icon,
                        size: 13,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        decision.category,
                        style: AppTypography.smallSemibold.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 17),
                    child: Text(
                      decision.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.small.copyWith(
                        color: AppColors.textPurple,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 17),
                    child: Text(
                      'Score: ${decision.score.toStringAsFixed(2)}',
                      style: AppTypography.small.copyWith(
                        color: AppColors.textPurple,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 17, top: 2),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_rounded,
                          size: 12,
                          color: AppColors.textPurple,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          decision.status,
                          style: AppTypography.small.copyWith(
                            color: AppColors.textPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.primaryDark,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
