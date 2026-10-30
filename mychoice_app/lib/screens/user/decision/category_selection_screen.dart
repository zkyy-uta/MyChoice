import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mychoice_app/features/category_selection/presentation/providers/category_provider.dart';
import 'package:mychoice_app/features/alternative_management/presentation/providers/alternative_provider.dart';
import 'package:mychoice_app/core/theme/app_colors.dart';
import 'package:mychoice_app/core/theme/app_spacing.dart';
import 'package:mychoice_app/core/theme/app_typography.dart';

/// Category selection screen
class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  @override
  void initState() {
    super.initState();
    // Load categories on initialization
    Future.microtask(() {
      context.read<CategoryProvider>().loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, _) {
          if (categoryProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (categoryProvider.error != null) {
            return Center(
              child: Text(
                categoryProvider.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.error80),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Instructions
                Text(
                  'Select a category and subcategory to get started',
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Categories
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categoryProvider.categories.length,
                  itemBuilder: (context, index) {
                    final category = categoryProvider.categories[index];
                    final isSelected =
                        categoryProvider.selectedCategory?.id == category.id;

                    return _CategoryCard(
                      category: category,
                      isSelected: isSelected,
                      onTap: () {
                        categoryProvider.selectCategory(category);
                      },
                      isExpanded: isSelected,
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xl),

                // Next button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: categoryProvider.isSelectionComplete
                        ? () {
                            // Load alternatives for selected subcategory
                            context
                                .read<AlternativeProvider>()
                                .loadCatalogAlternatives(
                                  categoryProvider.selectedSubcategory!.id,
                                );
                            // Navigate to alternative management
                            Navigator.of(
                              context,
                            ).pushNamed('/alternative-management');
                          }
                        : null,
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Category card widget
class _CategoryCard extends StatelessWidget {
  final dynamic category;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isExpanded;

  const _CategoryCard({
    required this.category,
    required this.isSelected,
    required this.onTap,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Category button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? AppColors.primary88 : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                color: isSelected ? AppColors.primary20 : Colors.transparent,
              ),
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(
                    _getCategoryIcon(category.icon),
                    size: 32,
                    color: isSelected
                        ? AppColors.primary88
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: AppTypography.sectionInnerTitle.copyWith(
                            color: isSelected
                                ? AppColors.primary88
                                : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          category.description,
                          style: AppTypography.small.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isSelected ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Subcategories
        if (isExpanded) ...[
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.lg),
            child: Consumer<CategoryProvider>(
              builder: (context, categoryProvider, _) {
                return Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: category.subcategories.map<Widget>((subcategory) {
                    final isSubSelected =
                        categoryProvider.selectedSubcategory?.id ==
                        subcategory.id;

                    return FilterChip(
                      label: Text(
                        subcategory.name,
                        style: AppTypography.small.copyWith(
                          color: isSubSelected
                              ? AppColors.textWhite
                              : AppColors.textPrimary,
                          fontWeight: isSubSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                      selected: isSubSelected,
                      onSelected: (_) {
                        categoryProvider.selectSubcategory(subcategory);
                      },
                      selectedColor: AppColors.primary88,
                      backgroundColor: AppColors.surface,
                      side: BorderSide(
                        color: isSubSelected
                            ? AppColors.primary88
                            : AppColors.border,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ],
    );
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'technology':
        return Icons.computer;
      case 'education':
        return Icons.school;
      case 'fashion':
        return Icons.shopping_bag;
      default:
        return Icons.category;
    }
  }
}
