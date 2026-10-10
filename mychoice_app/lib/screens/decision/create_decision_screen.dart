import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';

/// Create New Decision Screen (MF-2 & MF-3)
/// All-in-one screen for creating a decision:
/// - Choose Category
/// - Choose Subcategory
/// - Add Options
/// - Select Criteria
/// - Set Priorities
class CreateDecisionScreen extends StatefulWidget {
  const CreateDecisionScreen({super.key});

  @override
  State<CreateDecisionScreen> createState() => _CreateDecisionScreenState();
}

class _CreateDecisionScreenState extends State<CreateDecisionScreen> {
  // Selected values
  String? _selectedCategory;
  String? _selectedSubcategory;
  final List<String> _selectedOptions = [];
  final Map<String, bool> _selectedCriteria = {
    'Price': true,
    'Performance': true,
    'Battery': true,
    'Weight': false,
    'Storage': true,
  };
  final Map<String, double> _priorities = {
    'Price': 30,
    'Performance': 25,
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

  // Categories
  final Map<String, IconData> _categories = {
    'Technology': Icons.laptop_mac,
    'Education': Icons.school,
    'Fashion': Icons.checkroom,
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
    setState(() {
      if (!_selectedOptions.contains(option)) {
        _selectedOptions.add(option);
      }
    });
  }

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

  void _makeDecision() {
    if (_totalPriority != 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Total priority must equal 100%!'),
          backgroundColor: AppColors.error80,
        ),
      );
      return;
    }

    // TODO: Navigate to result screen
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Making decision...')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'Create New Decision',
          style: AppTypography.sectionTitle.copyWith(
            color: AppColors.textPurple,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subtitle
            Text(
              'Make a Decision: Select the options you want to compare and set your priorities based on your personal needs',
              style: AppTypography.small.copyWith(
                color: AppColors.textSecondary,
              ),
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
              'Suggested criteria for comparing your options',
              style: AppTypography.small.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildCriteriaCheckboxes(),
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
      children: _categories.entries.map((entry) {
        final isSelected = _selectedCategory == entry.key;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _CategoryCard(
              label: entry.key,
              icon: entry.value,
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

  Widget _buildOptionsSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter Your Selection...',
            style: AppTypography.small.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),

          // Search field
          TextField(
            decoration: InputDecoration(
              hintText: 'Search for options',
              prefixIcon: const Icon(Icons.search, size: 20),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Available options list
          ..._availableOptions.map((option) {
            final isAdded = _selectedOptions.contains(option);
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(child: Text(option, style: AppTypography.body)),
                  TextButton(
                    onPressed: isAdded ? null : () => _addOption(option),
                    child: Text(
                      isAdded ? 'Added' : '+ Add',
                      style: AppTypography.smallSemibold.copyWith(
                        color: isAdded
                            ? AppColors.textTertiary
                            : AppColors.primary88,
                      ),
                    ),
                  ),
                ],
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
          );
        }).toList(),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () {
              // TODO: Add custom criteria
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add criteria coming soon')),
              );
            },
            icon: const Icon(Icons.add, size: 20),
            label: Text('Add Criteria', style: AppTypography.buttonMedium),
          ),
        ),
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
                divisions: 20,
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

/// Category Card Widget
class _CategoryCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.label,
    required this.icon,
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
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? AppColors.primary88 : AppColors.textSecondary,
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
    // Different colors for each subcategory
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
