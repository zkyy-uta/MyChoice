import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/admin_bottom_navigation.dart';

class ManageSubcategoryScreen extends StatefulWidget {
  const ManageSubcategoryScreen({
    super.key,
    required this.subcategory,
  });

  final String subcategory;

  @override
  State<ManageSubcategoryScreen> createState() =>
      _ManageSubcategoryScreenState();
}

class _ManageSubcategoryScreenState
    extends State<ManageSubcategoryScreen> {
  static const Color _purple = AppColors.textPurple;
  static const Color _dark = Color(0xFF511B4D);
  static const Color _green = Color(0xFF239B4B);
  static const Color _orange = Color(0xFFFF812D);
  static const Color _palePurple = Color(0xFFE9EAFB);
  static const Color _yellow = Color(0xFFF5E7BF);

  final List<_Criterion> _criteria = [
    _Criterion(
      name: 'Price',
      type: 'Cost',
      unit: 'Rp',
      icon: Icons.payments_outlined,
    ),
    _Criterion(
      name: 'RAM',
      type: 'Benefit',
      unit: 'GB',
      icon: Icons.memory_rounded,
    ),
    _Criterion(
      name: 'Storage',
      type: 'Benefit',
      unit: 'GB',
      icon: Icons.storage_rounded,
    ),
    _Criterion(
      name: 'Weight',
      type: 'Cost',
      unit: 'kg',
      icon: Icons.scale_outlined,
    ),
  ];

  final List<_OptionItem> _options = [
    _OptionItem(
      name: 'ASUS Vivobook 14',
      values: {
        'Price': '8500000',
        'RAM': '16',
        'Storage': '512',
        'Weight': '1.4',
      },
    ),
    _OptionItem(
      name: 'Lenovo IdeaPad Slim 5',
      values: {
        'Price': '9500000',
        'RAM': '16',
        'Storage': '512',
        'Weight': '1.6',
      },
    ),
    _OptionItem(
      name: 'Acer Aspire 5',
      values: {
        'Price': '7000000',
        'RAM': '8',
        'Storage': '512',
        'Weight': '',
      },
    ),
  ];

  final List<_Suggestion> _suggestedCriteria = [
    _Suggestion(
      name: 'Battery Life',
      users: 18,
      unit: 'hours',
    ),
    _Suggestion(
      name: 'Screen Size',
      users: 5,
      unit: 'inches',
    ),
    _Suggestion(
      name: 'Warranty',
      users: 10,
      unit: 'years',
    ),
  ];

  final Map<String, GlobalKey> _suggestionKeys = {};

  _Suggestion? _activeSuggestion;
  TextEditingController? _popoverUnitController;

  String _popoverSelectedType = 'Benefit';
  double _popoverArrowX = 72;
  bool _showIncompleteOnly = false;

  int get _incompleteCount =>
      _options.where(_isIncomplete).length;

  int get _displayedOptionCount =>
      24 + _options.length - 3;

  bool _isIncomplete(_OptionItem option) {
    return _criteria.any((criterion) {
      if (option.unavailable.contains(criterion.name)) {
        return false;
      }

      return (option.values[criterion.name] ?? '')
          .trim()
          .isEmpty;
    });
  }

  List<_OptionItem> get _visibleOptions {
    if (_showIncompleteOnly) {
      return _options.where(_isIncomplete).toList();
    }

    return _options;
  }

  @override
  void dispose() {
    _popoverUnitController?.dispose();
    _popoverUnitController = null;
    super.dispose();
  }

  void _disposePopoverControllerAfterFrame() {
    final controller = _popoverUnitController;
    _popoverUnitController = null;

    if (controller != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.dispose();
      });
    }
  }

  void _closeSuggestionPopover() {
    if (_activeSuggestion == null) return;

    setState(() {
      _activeSuggestion = null;
    });

    _disposePopoverControllerAfterFrame();
  }

  // ============================================================
  // SCREEN
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatistics(),
                    const SizedBox(height: 22),
                    _buildCriteriaSection(),
                    const SizedBox(height: 24),
                    _buildSuggestionsSection(),
                    const SizedBox(height: 24),
                    _buildOptionsSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNavigation(
        selectedIndex: 2,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 12),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: _purple,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.subcategory,
                  style: AppTypography.sectionTitle.copyWith(
                    color: AppColors.primaryDark,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Manage criteria and options in '
                  '${widget.subcategory}',
                  style: AppTypography.extraSmallSemibold.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATISTICS
  // ============================================================

  Widget _buildStatistics() {
    return Row(
      children: [
        _statCard(
          '${_criteria.length}',
          'Criteria',
          incomplete: false,
        ),
        const SizedBox(width: 8),
        _statCard(
          '$_displayedOptionCount',
          'Options',
          incomplete: false,
        ),
        const SizedBox(width: 8),
        _statCard(
          '$_incompleteCount',
          'Incomplete',
          incomplete: true,
        ),
      ],
    );
  }

  Widget _statCard(
    String value,
    String label, {
    required bool incomplete,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          gradient: incomplete
              ? null
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFA18DE1),
                    Color(0xFF634A9E),
                  ],
                ),
          color: incomplete ? _yellow : null,
          borderRadius: BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: incomplete ? _dark : Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                color: incomplete ? _dark : Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CRITERIA
  // ============================================================

  Widget _buildCriteriaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Criteria'),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _criteria.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 14,
            childAspectRatio: 1.04,
          ),
          itemBuilder: (context, index) {
            return _criterionCard(_criteria[index]);
          },
        ),
        const SizedBox(height: 14),
        _primaryButton(
          label: '+ Add Criteria',
          onPressed: _showAddCriterionDialog,
        ),
      ],
    );
  }

  Widget _criterionCard(_Criterion criterion) {
    final isBenefit = criterion.type == 'Benefit';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E8F5),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white,
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.13),
            blurRadius: 7,
            offset: const Offset(1, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  criterion.icon,
                  color: _dark,
                  size: 29,
                ),
              ),
              const Spacer(),
              Icon(
                isBenefit
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                color: isBenefit ? _green : _orange,
                size: 30,
              ),
            ],
          ),
          const Spacer(),
          Text(
            criterion.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.sectionInnerTitle.copyWith(
              color: _dark,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${criterion.type} · ${criterion.unit}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.smallSemibold.copyWith(
              color: AppColors.textTertiary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SUGGESTED BY USER
  // ============================================================

  Widget _buildSuggestionsSection() {
    final popupWidth = math.min(
      MediaQuery.of(context).size.width - 40,
      360.0,
    ).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.playlist_add_rounded,
              color: _dark,
              size: 23,
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                'Suggested by User',
                style: AppTypography.sectionInnerTitle.copyWith(
                  color: _dark,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: _dark,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${_suggestedCriteria.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          'Many users added these on their own. '
          'Add the ones that fit.',
          style: AppTypography.extraSmallSemibold.copyWith(
            color: AppColors.textTertiary,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 128,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _suggestedCriteria.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final suggestion = _suggestedCriteria[index];

              final key = _suggestionKeys.putIfAbsent(
                suggestion.name,
                () => GlobalKey(),
              );

              return _suggestionCard(
                suggestion,
                key: key,
              );
            },
          ),
        ),
        if (_activeSuggestion != null &&
            _popoverUnitController != null) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: popupWidth,
              child: Material(
                color: Colors.transparent,
                child: _suggestionPopoverCard(
                  suggestion: _activeSuggestion!,
                  unitController: _popoverUnitController!,
                  selectedType: _popoverSelectedType,
                  arrowX: _popoverArrowX,
                  arrowOnTop: true,
                  popupWidth: popupWidth,
                  onTypeChanged: (value) {
                    setState(() {
                      _popoverSelectedType = value;
                    });
                  },
                  onCancel: _closeSuggestionPopover,
                  onAdd: () => _addSuggestedCriterion(
                    _activeSuggestion!,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _suggestionCard(
    _Suggestion suggestion, {
    Key? key,
  }) {
    final isSelected =
        _activeSuggestion?.name == suggestion.name;

    return SizedBox(
      key: key,
      width: 132,
      height: 128,
      child: CustomPaint(
        foregroundPainter: isSelected
            ? null
            : const _DashedRoundedBorderPainter(
                color: Color(0xFF8F7AE4),
              ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F7FC),
            borderRadius: BorderRadius.circular(21),
            border: isSelected
                ? Border.all(
                    color: _dark,
                    width: 1.2,
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDAD3FF),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: _dark,
                      size: 21,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      final closesActive =
                          _activeSuggestion?.name ==
                              suggestion.name;

                      setState(() {
                        _suggestedCriteria.removeWhere(
                          (item) =>
                              item.name == suggestion.name,
                        );

                        if (closesActive) {
                          _activeSuggestion = null;
                        }
                      });

                      if (closesActive) {
                        _disposePopoverControllerAfterFrame();
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(3),
                      child: Icon(
                        Icons.close_rounded,
                        color: _dark,
                        size: 19,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                suggestion.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.smallSemibold.copyWith(
                  color: _dark,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.people_outline_rounded,
                    size: 12,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '${suggestion.users} Users',
                    style: AppTypography.extraSmallSemibold.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 28,
                child: FilledButton(
                  onPressed: () {
                    _openSuggestionPopover(suggestion);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: _dark,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    '+ ADD',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // OPEN SUGGESTION POPOVER
  // ============================================================

  void _openSuggestionPopover(_Suggestion suggestion) {
    if (_activeSuggestion?.name == suggestion.name) {
      _closeSuggestionPopover();
      return;
    }

    final previousController = _popoverUnitController;
    final controller = TextEditingController(
      text: suggestion.unit,
    );

    final key = _suggestionKeys[suggestion.name];
    final renderObject =
        key?.currentContext?.findRenderObject();

    final screenWidth = MediaQuery.of(context).size.width;
    final popupWidth = math.min(
      screenWidth - 40,
      360.0,
    ).toDouble();

    final popupLeft = (screenWidth - popupWidth) / 2;
    var arrowX = popupWidth / 2;

    if (renderObject is RenderBox && renderObject.hasSize) {
      final targetPosition =
          renderObject.localToGlobal(Offset.zero);
      final targetSize = renderObject.size;

      arrowX = (
        targetPosition.dx +
        targetSize.width / 2 -
        popupLeft
      ).clamp(
        34.0,
        popupWidth - 34,
      ).toDouble();
    }

    setState(() {
      _activeSuggestion = suggestion;
      _popoverUnitController = controller;
      _popoverSelectedType = 'Benefit';
      _popoverArrowX = arrowX;
    });

    if (previousController != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        previousController.dispose();
      });
    }
  }

  void _addSuggestedCriterion(_Suggestion suggestion) {
    final unit = _popoverUnitController?.text.trim() ?? '';

    if (unit.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a unit.'),
        ),
      );
      return;
    }

    final duplicate = _criteria.any(
      (criterion) =>
          criterion.name.toLowerCase() ==
          suggestion.name.toLowerCase(),
    );

    if (duplicate) {
      _closeSuggestionPopover();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This criterion already exists.'),
        ),
      );

      return;
    }

    final newCriterion = _Criterion(
      name: suggestion.name,
      type: _popoverSelectedType,
      unit: unit,
      icon: _iconForCriterion(suggestion.name),
    );

    setState(() {
      _criteria.add(newCriterion);

      _suggestedCriteria.removeWhere(
        (item) => item.name == suggestion.name,
      );

      _activeSuggestion = null;
    });

    _disposePopoverControllerAfterFrame();
  }

  // ============================================================
  // SUGGESTION POPOVER CARD
  // ============================================================

  Widget _suggestionPopoverCard({
    required _Suggestion suggestion,
    required TextEditingController unitController,
    required String selectedType,
    required double arrowX,
    required bool arrowOnTop,
    required double popupWidth,
    required ValueChanged<String> onTypeChanged,
    required VoidCallback onCancel,
    required VoidCallback onAdd,
  }) {
    final card = Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 19, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFAFD),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: _dark,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add “${suggestion.name}”?',
            style: AppTypography.sectionInnerTitle.copyWith(
              color: _dark,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 19),
          Row(
            children: [
              Text(
                'Type',
                style: AppTypography.smallSemibold.copyWith(
                  color: _dark,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 9),
              _suggestedBadge(),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: _palePurple,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _typeButton(
                    label: 'Benefit',
                    icon: Icons.arrow_upward_rounded,
                    color: _green,
                    selected: selectedType == 'Benefit',
                    onTap: () => onTypeChanged('Benefit'),
                  ),
                ),
                Expanded(
                  child: _typeButton(
                    label: 'Cost',
                    icon: Icons.arrow_downward_rounded,
                    color: _orange,
                    selected: selectedType == 'Cost',
                    onTap: () => onTypeChanged('Cost'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 19),
          Row(
            children: [
              Text(
                'Unit',
                style: AppTypography.smallSemibold.copyWith(
                  color: _dark,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 9),
              _suggestedBadge(),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: unitController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'e.g. hours, GB, years',
              filled: true,
              fillColor: const Color(0xFFF0EFF8),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: _dark,
                  width: 1.1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: _dark,
                  width: 1.6,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: _yellow,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  color: Color(0xFF9B5700),
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Criteria cannot be edited after saving. '
                    '$_displayedOptionCount options will need '
                    'a value for it.',
                    style: const TextStyle(
                      color: Color(0xFF80500C),
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 19),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _dark,
                      side: const BorderSide(
                        color: _dark,
                        width: 1.2,
                      ),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: FilledButton(
                    onPressed: onAdd,
                    style: FilledButton.styleFrom(
                      backgroundColor: _dark,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'ADD',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    const double arrowWidth = 64;
    const double arrowHeight = 46;
    const double arrowOverlap = 8;

    final safeArrowX = arrowX.clamp(
      arrowWidth / 2 + 5,
      popupWidth - arrowWidth / 2 - 5,
    ).toDouble();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: arrowOnTop
                ? arrowHeight - arrowOverlap
                : 0,
            bottom: arrowOnTop
                ? 0
                : arrowHeight - arrowOverlap,
          ),
          child: card,
        ),
        Positioned(
          left: safeArrowX - (arrowWidth - 4) / 2,
          top: arrowOnTop
              ? arrowHeight - arrowOverlap - 1
              : null,
          bottom: arrowOnTop
              ? null
              : arrowHeight - arrowOverlap - 1,
          child: Container(
            width: arrowWidth - 4,
            height: 3,
            color: const Color(0xFFFCFAFD),
          ),
        ),
        Positioned(
          left: safeArrowX - arrowWidth / 2,
          top: arrowOnTop ? -7.3 : null,
          bottom: arrowOnTop ? null : -10,
          child: CustomPaint(
            size: const Size(arrowWidth, arrowHeight),
            painter: _PopoverArrowPainter(
              color: _dark,
              arrowOnTop: arrowOnTop,
            ),
          ),
        ),
      ],
    );
  }

  Widget _suggestedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE0D6FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'suggested',
        style: TextStyle(
          color: Color(0xFF7155A8),
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _typeButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 43,
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 22,
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: label == 'Benefit' ? _dark : _orange,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForCriterion(String name) {
    switch (name.toLowerCase()) {
      case 'battery life':
        return Icons.battery_charging_full_rounded;
      case 'screen size':
        return Icons.monitor_outlined;
      case 'warranty':
        return Icons.verified_outlined;
      default:
        return Icons.tune_rounded;
    }
  }

  // ============================================================
  // OPTIONS
  // ============================================================

  Widget _buildOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Options'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _filterChip(
              label: 'All · $_displayedOptionCount',
              selected: !_showIncompleteOnly,
              onTap: () {
                setState(() => _showIncompleteOnly = false);
              },
            ),
            _filterChip(
              label: 'Incomplete · $_incompleteCount',
              selected: _showIncompleteOnly,
              onTap: () {
                setState(() => _showIncompleteOnly = true);
              },
              selectedBackground: _yellow,
              selectedTextColor: const Color(0xFF8A6916),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white,
              width: 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 7,
                offset: const Offset(1, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              for (final option in _visibleOptions)
                _optionRow(option),
              if (_visibleOptions.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    'No options match this filter.',
                  ),
                ),
              const Divider(height: 22),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'This prototype currently shows sample options.',
                      ),
                    ),
                  );
                },
                child: Text(
                  'See all $_displayedOptionCount options  ⌄',
                  style: AppTypography.extraSmallSemibold.copyWith(
                    color: _dark,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _primaryButton(
          label: '+ Add Option',
          onPressed: _showAddOptionDialog,
        ),
      ],
    );
  }

  Widget _optionRow(_OptionItem option) {
    final incomplete = _isIncomplete(option);

    IconData icon = Icons.laptop_mac_rounded;

    if (widget.subcategory.toLowerCase() == 'smartphone') {
      icon = Icons.smartphone_rounded;
    } else if (widget.subcategory.toLowerCase() == 'tablet') {
      icon = Icons.tablet_mac_rounded;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E3F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: _purple,
              size: 21,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.smallSemibold.copyWith(
                    color: _dark,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  incomplete
                      ? 'Incomplete values'
                      : 'All values complete',
                  style: AppTypography.extraSmallSemibold.copyWith(
                    fontSize: 9,
                    color: incomplete ? _orange : _green,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit option',
            onPressed: () => _showAddOptionDialog(
              existing: option,
            ),
            icon: const Icon(
              Icons.edit_outlined,
              color: _dark,
              size: 19,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    Color? selectedBackground,
    Color? selectedTextColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? (selectedBackground ?? _dark)
              : const Color(0xFFF0EAF8),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: AppTypography.extraSmallSemibold.copyWith(
            color: selected
                ? (selectedTextColor ?? Colors.white)
                : _dark,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ADD CRITERIA DIALOG
  // ============================================================

  Future<void> _showAddCriterionDialog() async {
    final nameController = TextEditingController();
    final unitController = TextEditingController();

    String selectedType = 'Benefit';

    final result = await showDialog<_Criterion>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Criteria'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Criteria Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Benefit',
                          child: Text('Benefit'),
                        ),
                        DropdownMenuItem(
                          value: 'Cost',
                          child: Text('Cost'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedType = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: unitController,
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _dark,
                  ),
                  onPressed: () {
                    final name = nameController.text.trim();
                    final unit = unitController.text.trim();

                    if (name.isEmpty || unit.isEmpty) return;

                    Navigator.pop(
                      dialogContext,
                      _Criterion(
                        name: name,
                        type: selectedType,
                        unit: unit,
                        icon: _iconForCriterion(name),
                      ),
                    );
                  },
                  child: const Text('Save Criteria'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    unitController.dispose();

    if (result == null || !mounted) return;

    final duplicate = _criteria.any(
      (item) =>
          item.name.toLowerCase() == result.name.toLowerCase(),
    );

    if (duplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This criterion already exists.'),
        ),
      );
      return;
    }

    setState(() {
      _criteria.add(result);
    });
  }

  // ============================================================
  // ADD / EDIT OPTION DIALOG
  // ============================================================

  Future<void> _showAddOptionDialog({
    _OptionItem? existing,
  }) async {
    final nameController = TextEditingController(
      text: existing?.name ?? '',
    );

    final controllers = <String, TextEditingController>{
      for (final criterion in _criteria)
        criterion.name: TextEditingController(
          text: existing?.values[criterion.name] ?? '',
        ),
    };

    final unavailable = <String>{
      ...?existing?.unavailable,
    };

    final result = await showDialog<_OptionItem>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                existing == null ? 'Add Option' : 'Edit Option',
              ),
              content: SizedBox(
                width: 420,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Option Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      for (final criterion in _criteria) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${criterion.name} (${criterion.unit})',
                            style: AppTypography.smallSemibold.copyWith(
                              color: _dark,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          controller: controllers[criterion.name],
                          enabled: !unavailable.contains(
                            criterion.name,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter ${criterion.name}',
                            border: const OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: const Text(
                            'Not Available',
                            style: TextStyle(fontSize: 11),
                          ),
                          value: unavailable.contains(
                            criterion.name,
                          ),
                          onChanged: (checked) {
                            setDialogState(() {
                              if (checked == true) {
                                unavailable.add(criterion.name);
                                controllers[criterion.name]!.clear();
                              } else {
                                unavailable.remove(criterion.name);
                              }
                            });
                          },
                          controlAffinity:
                              ListTileControlAffinity.leading,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                if (existing != null)
                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                        dialogContext,
                        _OptionItem.delete(existing.name),
                      );
                    },
                    child: const Text(
                      'Delete Option',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _dark,
                  ),
                  onPressed: () {
                    final name = nameController.text.trim();

                    if (name.isEmpty) return;

                    Navigator.pop(
                      dialogContext,
                      _OptionItem(
                        name: name,
                        values: {
                          for (final criterion in _criteria)
                            criterion.name:
                                controllers[criterion.name]!
                                    .text
                                    .trim(),
                        },
                        unavailable: Set<String>.from(unavailable),
                      ),
                    );
                  },
                  child: Text(
                    existing == null
                        ? 'Save Option'
                        : 'Update Option',
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();

    for (final controller in controllers.values) {
      controller.dispose();
    }

    if (result == null || !mounted) return;

    setState(() {
      if (result.isDeleted) {
        _options.removeWhere(
          (option) => option.name == result.name,
        );
      } else {
        final index = existing == null
            ? -1
            : _options.indexOf(existing);

        if (index >= 0) {
          _options[index] = result;
        } else {
          _options.add(result);
        }
      }
    });
  }

  // ============================================================
  // SHARED WIDGETS
  // ============================================================

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.sectionInnerTitle.copyWith(
        color: _purple,
        fontSize: 17,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _primaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 43,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: _dark,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// DATA MODELS
// ============================================================

class _Criterion {
  const _Criterion({
    required this.name,
    required this.type,
    required this.unit,
    required this.icon,
  });

  final String name;
  final String type;
  final String unit;
  final IconData icon;
}

class _Suggestion {
  const _Suggestion({
    required this.name,
    required this.users,
    required this.unit,
  });

  final String name;
  final int users;
  final String unit;
}

class _OptionItem {
  _OptionItem({
    required this.name,
    required this.values,
    Set<String>? unavailable,
    this.isDeleted = false,
  }) : unavailable = unavailable ?? {};

  factory _OptionItem.delete(String name) {
    return _OptionItem(
      name: name,
      values: const {},
      isDeleted: true,
    );
  }

  final String name;
  final Map<String, String> values;
  final Set<String> unavailable;
  final bool isDeleted;
}

// ============================================================
// DASHED BORDER FOR SUGGESTION CARDS
// ============================================================

class _DashedRoundedBorderPainter extends CustomPainter {
  const _DashedRoundedBorderPainter({
    required this.color,
  });

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          rect.deflate(1),
          const Radius.circular(21),
        ),
      );

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;

      while (distance < metric.length) {
        final end = math.min(
          distance + 7,
          metric.length,
        ).toDouble();

        canvas.drawPath(
          metric.extractPath(distance, end),
          paint,
        );

        distance += 12;
      }
    }
  }

  @override
  bool shouldRepaint(
    covariant _DashedRoundedBorderPainter oldDelegate,
  ) {
    return oldDelegate.color != color;
  }
}

// ============================================================
// NATURAL CURVED POPOVER POINTER
// ============================================================

class _PopoverArrowPainter extends CustomPainter {
  const _PopoverArrowPainter({
    required this.color,
    required this.arrowOnTop,
  });

  final Color color;
  final bool arrowOnTop;

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..color = const Color(0xFFFCFAFD)
      ..style = PaintingStyle.fill;

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final width = size.width;
    final height = size.height;

    final curve = Path()
      ..moveTo(0, height)
      ..cubicTo(
        width * 0.20,
        height,
        width * 0.39,
        height * 0.10,
        width * 0.50,
        height * 0.04,
      )
      ..cubicTo(
        width * 0.61,
        height * 0.10,
        width * 0.80,
        height,
        width,
        height,
      );

    final filledShape = Path.from(curve)..close();

    canvas.save();

    if (!arrowOnTop) {
      canvas.translate(0, height);
      canvas.scale(1, -1);
    }

    canvas.drawPath(filledShape, fill);
    canvas.drawPath(curve, stroke);

    canvas.restore();
  }

  @override
  bool shouldRepaint(
    covariant _PopoverArrowPainter oldDelegate,
  ) {
    return oldDelegate.color != color ||
        oldDelegate.arrowOnTop != arrowOnTop;
  }
}
