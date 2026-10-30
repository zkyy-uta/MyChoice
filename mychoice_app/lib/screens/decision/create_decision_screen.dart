import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mychoice_app/core/theme/app_colors.dart';
import 'package:mychoice_app/core/theme/app_typography.dart';
import 'package:mychoice_app/core/theme/app_spacing.dart';
import 'result_screen.dart';

/// Create New Decision Screen (MF-2 & MF-3)
/// For authenticated users only — full access to create and save decisions.
class CreateDecisionScreen extends StatefulWidget {
  const CreateDecisionScreen({super.key, this.isPremium = false});

  final bool isPremium;

  @override
  State<CreateDecisionScreen> createState() => _CreateDecisionScreenState();
}

class _CreateDecisionScreenState extends State<CreateDecisionScreen> {
  // Selected values
  String? _selectedCategory;
  String? _selectedSubcategory;
  final List<String> _selectedOptions = [];
  final Set<String> _tappedOptions = {}; // Options user tapped to select (before adding)
  final TextEditingController _newCriteriaController = TextEditingController();
  final Map<String, bool> _selectedCriteria = {
    'Price': true,
    'Performance': true,
    'Battery': true,
    'Weight': false,
    'Storage': true,
  };
  final Map<String, double> _priorities = {
    'Price': 30,
    'Performance': 35,
    'Battery': 20,
    'Storage': 15,
  };

  // Available options (mock data)
  final List<String> _availableOptions = [
    'ASUS Vivobook 14',
    'Lenovo IdeaPad Slim 5',
    'Acer Aspire 5',
    'HP Pavilion 15',
    'Dell Inspiron 15',
  ];

  // Categories with icon assets
  final Map<String, String> _categoryIcons = {
    'Technology': 'assets/icons/laptop.png',
    'Education': 'assets/icons/education.png',
    'Fashion': 'assets/icons/fashion.png',
  };

  // Subcategories by category
  final Map<String, List<String>> _subcategories = {
    'Technology': ['Laptop', 'Smartphone', 'Tablet', 'Monitor', 'PC'],
    'Education': ['Course', 'Certification', 'Bootcamp', 'University'],
    'Fashion': ['Dress', 'Shoes', 'Accessories', 'Bags'],
  };

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _selectedSubcategory = null; // Reset subcategory
    });
  }

  void _selectSubcategory(String subcategory) {
    setState(() {
      _selectedSubcategory = subcategory;
    });
  }

  void _addOption(String option) {
    if (_selectedOptions.contains(option)) return;
    final maxOptions = widget.isPremium ? 10 : 3;
    if (_selectedOptions.length >= maxOptions) {
      _showOptionLimitDialog(maxOptions);
      return;
    }
    setState(() {
      _selectedOptions.add(option);
    });
  }

  Future<void> _showOptionLimitDialog(int maxOptions) => showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary20,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Batas pilihan tercapai',
              style: TextStyle(
                color: AppColors.textPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.isPremium
                ? 'Paket Premium dapat membandingkan maksimal '
                      '$maxOptions pilihan.'
                : 'Paket Basic hanya dapat membandingkan maksimal 3 pilihan. '
                      'Untuk menambahkan pilihan ke-4, diperlukan paket '
                      'Premium. Hapus salah satu pilihan atau upgrade ke '
                      'Premium.',
            style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
          if (!widget.isPremium) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BASIC',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '3 pilihan',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.primaryGradient,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary20,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary60),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PREMIUM',
                          style: TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Hingga 10',
                          style: TextStyle(
                            color: AppColors.textPurple,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(widget.isPremium ? 'Tutup' : 'Nanti saja'),
        ),
        if (!widget.isPremium)
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryGradient,
              foregroundColor: AppColors.textWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pushNamed('/profile/premium-plan');
            },
            child: const Text('Upgrade Premium'),
          ),
      ],
    ),
  );

  void _removeOption(String option) {
    setState(() {
      _selectedOptions.remove(option);
    });
  }

  void _toggleCriteria(String criteria) {
    setState(() {
      _selectedCriteria[criteria] = !_selectedCriteria[criteria]!;
    });
  }

  void _updatePriority(String criteria, double value) {
    setState(() {
      _priorities[criteria] = value;
    });
  }

  double get _totalPriority {
    return _priorities.values.fold(0, (sum, value) => sum + value);
  }

  Future<void> _makeDecision() async {
    // User already authenticated — no gate needed for logged-in users

    if (_totalPriority != 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Total priority must equal 100%!'),
          backgroundColor: AppColors.error80,
        ),
      );
      return;
    }

    final shouldCalculate = await showDialog<bool>(
      context: context,
      builder: (_) => _DecisionReviewDialog(
        category: _selectedCategory,
        subcategory: _selectedSubcategory,
        options: List.unmodifiable(_selectedOptions),
        criteria: Map.unmodifiable(_selectedCriteria),
        priorities: Map.unmodifiable(_priorities),
        totalPriority: _totalPriority,
      ),
    );
    if (shouldCalculate != true || !mounted) return;

    final calculationComplete = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _ProcessingDecisionDialog(),
    );
    if (calculationComplete != true || !mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ResultScreen(
          category: _selectedCategory ?? 'Technology',
          subcategory: _selectedSubcategory ?? 'Laptop',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _newCriteriaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPurple,
          ),
        ),
        title: Text(
          'Create New Decision',
          style: AppTypography.sectionTitle.copyWith(
            color: AppColors.textPurple,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subtitle
            Text(
              'Make a Decision: Select the options you want to compare and set your priorities based on your needs.',
              style: AppTypography.small.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),

            // 1. Choose Category
            _buildSectionTitle('Choose Category'),
            const SizedBox(height: AppSpacing.md),
            _buildCategoryCards(),
            const SizedBox(height: AppSpacing.xxl),

            // 2. Choose Subcategory
            if (_selectedCategory != null) ...[
              _buildSectionTitle('Choose Subcategory'),
              const SizedBox(height: AppSpacing.md),
              _buildSubcategoryChips(),
              const SizedBox(height: AppSpacing.xxl),
            ],

            // 3. Options Compared
            _buildSectionTitle('Options Compared'),
            const SizedBox(height: AppSpacing.md),
            _buildOptionsSection(),
            const SizedBox(height: AppSpacing.xxl),

            // 4. Criteria
            _buildSectionTitle('Criteria'),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Suggested criteria for comparing your options:',
              style: AppTypography.small.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildCriteriaCheckboxes(),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                onPressed: _showAddCriteriaDialog,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add,
                      size: 20,
                      color: AppColors.textPurple,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Add Criteria',
                      style: AppTypography.buttonMedium.copyWith(
                        color: AppColors.textPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // 5. Set Priorities
            _buildSectionTitle('Set Priorities'),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Determine how important each criterion is. The total weight must add up to 100%',
              style: AppTypography.small.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildPrioritySliders(),
            const SizedBox(height: AppSpacing.md),
            _buildTotalPriority(),
            const SizedBox(height: AppSpacing.xxl),

            // 6. Make a Decision Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _makeDecision,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                  ),
                ),
                child: Text(
                  'Make a Decision',
                  style: AppTypography.buttonLarge,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
      bottomNavigationBar: _MainBottomNav(
        selectedIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.of(context).pushNamed('/dashboard');
              break;
            case 2:
              Navigator.of(context).pushNamed('/insight');
              break;
            case 3:
              Navigator.of(context).pushNamed('/history');
              break;
            case 4:
              Navigator.of(context).pushNamed('/profile');
              break;
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.sectionTitle.copyWith(color: AppColors.textPurple),
    );
  }

  Widget _buildCategoryCards() {
    return Row(
      children: _categoryIcons.entries.map((entry) {
        final isSelected = _selectedCategory == entry.key;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _CategoryCard(
              label: entry.key,
              iconAsset: entry.value,
              isSelected: isSelected,
              onTap: () => _selectCategory(entry.key),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubcategoryChips() {
    final subcategories = _subcategories[_selectedCategory] ?? [];
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: subcategories.map((sub) {
        final isSelected = _selectedSubcategory == sub;
        return _SubcategoryChip(
          label: sub,
          isSelected: isSelected,
          onTap: () => _selectSubcategory(sub),
        );
      }).toList(),
    );
  }

  void _toggleTapOption(String option) {
    setState(() {
      if (_tappedOptions.contains(option)) {
        _tappedOptions.remove(option);
      } else {
        _tappedOptions.add(option);
      }
    });
  }

  void _addTappedOptions() {
    setState(() {
      for (final option in _tappedOptions) {
        if (!_selectedOptions.contains(option)) {
          _selectedOptions.add(option);
        }
      }
      _tappedOptions.clear();
    });
  }

  void _showAddCriteriaDialog() {
    _newCriteriaController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.dialogRadius),
        ),
        title: Text(
          'Add New Criteria',
          style: AppTypography.sectionInnerTitle.copyWith(
            color: AppColors.textPurple,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _newCriteriaController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Enter criteria name (e.g., Price, Quality)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                  borderSide: const BorderSide(color: AppColors.primary88),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
              ),
              onSubmitted: (_) => _saveNewCriteria(context),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTypography.smallSemibold.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _saveNewCriteria(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary88,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              ),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _saveNewCriteria(BuildContext context) {
    final name = _newCriteriaController.text.trim();
    if (name.isEmpty || _selectedCriteria.containsKey(name)) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _selectedCriteria[name] = false; // Not selected by default
      _priorities[name] = 0; // Weight starts at 0
    });
    Navigator.of(context).pop();
  }

  Widget _buildOptionsSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter Your Selection...',
            style: AppTypography.small.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for options',
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 20,
                      color: AppColors.textTertiary,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                      borderSide: const BorderSide(color: AppColors.primary88),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                height: 44,
                child: OutlinedButton(
                  onPressed: _tappedOptions.isEmpty ? null : _addTappedOptions,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 20,
                    color: AppColors.textPurple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Available options list - tap to select, then click + to add
          ..._availableOptions.map((option) {
            final isAdded = _selectedOptions.contains(option);
            final isTapped = _tappedOptions.contains(option);
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isAdded ? null : () => _toggleTapOption(option),
                  borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: isAdded
                          ? AppColors.primary20
                          : (isTapped
                              ? AppColors.primary88.withValues(alpha: 0.1)
                              : Colors.transparent),
                      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                      border: Border.all(
                        color: isAdded
                            ? AppColors.primary88
                            : (isTapped ? AppColors.primary88 : AppColors.border),
                        width: isAdded || isTapped ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option,
                            style: AppTypography.body.copyWith(
                              color: isAdded
                                  ? AppColors.primary88
                                  : AppColors.textPrimary,
                              fontWeight: isAdded ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                        if (isAdded)
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.primary88,
                            size: 20,
                          )
                        else if (isTapped)
                          const Icon(
                            Icons.radio_button_checked,
                            color: AppColors.primary88,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),

          // Selected options count
          if (_selectedOptions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primary20,
                borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
              ),
              child: Text(
                'Options Compared (${_selectedOptions.length})',
                style: AppTypography.sectionInnerTitle.copyWith(
                  color: AppColors.primary88,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Selected options with remove button
            ..._selectedOptions.map((option) {
              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        option,
                        style: AppTypography.sectionInnerTitle,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _removeOption(option),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.error80,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildCriteriaCheckboxes() {
    return Column(
      children: [
        ..._selectedCriteria.entries.map((entry) {
          return CheckboxListTile(
            value: entry.value,
            onChanged: (value) => _toggleCriteria(entry.key),
            title: Text(entry.key, style: AppTypography.body),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            dense: true,
            activeColor: AppColors.primary88,
            checkColor: Colors.white,
          );
        }),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }

  Widget _buildPrioritySliders() {
    return Column(
      children: _priorities.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.key, style: AppTypography.sectionInnerTitle),
                  Text(
                    '${entry.value.toInt()}%',
                    style: AppTypography.sectionInnerTitle.copyWith(
                      color: AppColors.primary88,
                    ),
                  ),
                ],
              ),
              Slider(
                value: entry.value,
                min: 0,
                max: 100,
                divisions: 100,
                activeColor: AppColors.primary88,
                inactiveColor: AppColors.border,
                onChanged: (value) => _updatePriority(entry.key, value),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTotalPriority() {
    final isValid = _totalPriority == 100;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isValid ? AppColors.success20 : AppColors.error20,
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
        border: Border.all(
          color: isValid ? AppColors.success80 : AppColors.error80,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total',
            style: AppTypography.sectionTitle.copyWith(
              color: isValid ? AppColors.success80 : AppColors.error80,
            ),
          ),
          Text(
            '${_totalPriority.toInt()}%',
            style: AppTypography.sectionTitle.copyWith(
              color: isValid ? AppColors.success80 : AppColors.error80,
            ),
          ),
        ],
      ),
    );
  }
}

/// Category Card Widget with image asset
class _CategoryCard extends StatelessWidget {
  final String label;
  final String iconAsset;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.label,
    required this.iconAsset,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary20 : Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: isSelected ? AppColors.primary88 : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Image.asset(
                iconAsset,
                width: 32,
                height: 32,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    _getFallbackIcon(label),
                    size: 32,
                    color: isSelected ? AppColors.primary88 : AppColors.textSecondary,
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.small.copyWith(
                color: isSelected ? AppColors.primary88 : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFallbackIcon(String label) {
    switch (label) {
      case 'Technology':
        return Icons.laptop_mac;
      case 'Education':
        return Icons.school;
      case 'Fashion':
        return Icons.checkroom;
      default:
        return Icons.category;
    }
  }
}

/// Subcategory Chip Widget
class _SubcategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SubcategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? _getColor(label) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.small.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Color _getColor(String label) {
    final colors = [
      AppColors.primary88,
      AppColors.categoryEducation,
      AppColors.secondary80,
      AppColors.info80,
      AppColors.categoryTechnology,
    ];
    return colors[label.hashCode % colors.length];
  }
}

class _DecisionReviewDialog extends StatelessWidget {
  const _DecisionReviewDialog({
    required this.category,
    required this.subcategory,
    required this.options,
    required this.criteria,
    required this.priorities,
    required this.totalPriority,
  });

  final String? category;
  final String? subcategory;
  final List<String> options;
  final Map<String, bool> criteria;
  final Map<String, double> priorities;
  final double totalPriority;

  @override
  Widget build(BuildContext context) {
    final selectedCriteria = criteria.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 620),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.close, color: AppColors.textPurple),
                ),
              ),
              Text(
                'Almost done! 🎉',
                style: AppTypography.smallSemibold.copyWith(
                  color: AppColors.textPurple,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Double-check your choices and priorities before MyChoice calculates your results.',
                style: AppTypography.small.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Divider(height: 22),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ReviewSection(
                        title: 'Category',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.laptop_mac,
                              size: 19,
                              color: AppColors.textPurple,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                '${category ?? 'Not selected'}  ›  ${subcategory ?? 'Not selected'}',
                                style: AppTypography.small.copyWith(
                                  color: AppColors.textPurple,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _ReviewSection(
                        title: 'Options Compared',
                        child: options.isEmpty
                            ? Text(
                                'No options selected',
                                style: AppTypography.small.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (
                                    var index = 0;
                                    index < options.length;
                                    index++
                                  )
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3),
                                      child: Text(
                                        '${index + 1}. ${options[index]}',
                                        style: AppTypography.small.copyWith(
                                          color: AppColors.textPurple,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 12),
                      _ReviewSection(
                        title: 'Criteria',
                        child: Column(
                          children: [
                            for (final criterion in selectedCriteria)
                              Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      criterion,
                                      style: AppTypography.small.copyWith(
                                        color: AppColors.textPurple,
                                      ),
                                    ),
                                    Text(
                                      '${(priorities[criterion] ?? 0).toInt()}%',
                                      style: AppTypography.small.copyWith(
                                        color: AppColors.textPurple,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            const Divider(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Total: ${totalPriority.toInt()}%',
                                  style: AppTypography.smallSemibold.copyWith(
                                    color: AppColors.textPurple,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Edit Data'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Start Calculation'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.sectionInnerTitle.copyWith(
            fontSize: 15,
            color: AppColors.textPurple,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _ProcessingDecisionDialog extends StatefulWidget {
  const _ProcessingDecisionDialog();

  @override
  State<_ProcessingDecisionDialog> createState() =>
      _ProcessingDecisionDialogState();
}

class _ProcessingDecisionDialogState extends State<_ProcessingDecisionDialog> {
  static const _steps = [
    'Reviewing alternative data',
    'Determining criteria weights',
    'Performing normalization',
    'Calculating final scores',
  ];

  Timer? _timer;
  int _completedSteps = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 850), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _completedSteps++;
        if (_completedSteps == _steps.length) timer.cancel();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isComplete = _completedSteps == _steps.length;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.close, color: AppColors.textPurple),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isComplete)
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: SizedBox(
                        width: 19,
                        height: 19,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary88,
                        ),
                      ),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.check_circle,
                        color: AppColors.success80,
                        size: 21,
                      ),
                    ),
                  Text(
                    'Processing Decisions',
                    style: AppTypography.sectionInnerTitle.copyWith(
                      color: AppColors.textPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'MyChoice is comparing options based on your priorities.',
                textAlign: TextAlign.center,
                style: AppTypography.small.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 22),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: _completedSteps / _steps.length,
                  minHeight: 12,
                  backgroundColor: AppColors.primary20,
                  color: AppColors.primary88,
                ),
              ),
              const SizedBox(height: 22),
              for (var index = 0; index < _steps.length; index++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        index < _completedSteps
                            ? Icons.check
                            : Icons.circle_outlined,
                        size: 18,
                        color: index < _completedSteps
                            ? AppColors.textPurple
                            : AppColors.primary88,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _steps[index],
                        style: AppTypography.small.copyWith(
                          color: AppColors.textPurple,
                        ),
                      ),
                    ],
                  ),
                ),
              if (isComplete) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Decision Results'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Main Bottom Navigation — Home, Decision, Insight, History, Profile
class _MainBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _MainBottomNav({
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home,
                label: 'Home',
                isSelected: selectedIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.add_circle_outline,
                label: 'Decision',
                isSelected: selectedIndex == 1,
                onTap: () => onTap(1),
                isAction: true,
              ),
              _NavItem(
                icon: Icons.bar_chart,
                label: 'Insight',
                isSelected: selectedIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                icon: Icons.history,
                label: 'History',
                isSelected: selectedIndex == 3,
                onTap: () => onTap(3),
              ),
              _NavItem(
                icon: Icons.person_outline,
                label: 'Profile',
                isSelected: selectedIndex == 4,
                onTap: () => onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isAction;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    this.isAction = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primary88.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isAction
                  ? Colors.white
                  : (isSelected ? AppColors.primary88 : AppColors.textTertiary),
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.extraSmallSemibold.copyWith(
              color: isAction
                  ? AppColors.primaryDark
                  : (isSelected ? AppColors.primary88 : AppColors.textTertiary),
            ),
          ),
        ],
      ),
    );
  }
}
