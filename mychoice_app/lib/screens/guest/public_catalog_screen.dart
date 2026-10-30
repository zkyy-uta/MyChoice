import 'package:flutter/material.dart';
import 'package:mychoice_app/core/theme/app_spacing.dart';
import 'package:mychoice_app/core/theme/app_colors.dart';
import 'package:mychoice_app/core/widgets/mobile_background.dart';

class PublicCatalogScreen extends StatefulWidget {
  const PublicCatalogScreen({super.key});

  @override
  State<PublicCatalogScreen> createState() => _PublicCatalogScreenState();
}

class _PublicCatalogScreenState extends State<PublicCatalogScreen> {
  late TextEditingController _searchController;
  final List<Map<String, dynamic>> categories = [
    {
      'id': 'technology',
      'name': 'Technology',
      'description': 'Electronics and computing devices',
      'icon': Icons.devices,
      'color': Colors.blue,
      'subcategories': 7,
    },
    {
      'id': 'education',
      'name': 'Education',
      'description': 'Learning and courses',
      'icon': Icons.school,
      'color': Colors.purple,
      'subcategories': 5,
    },
    {
      'id': 'fashion',
      'name': 'Fashion',
      'description': 'Clothing and accessories',
      'icon': Icons.checkroom,
      'color': Colors.pink,
      'subcategories': 6,
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileBackground(
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.md),
                    Text(
                      'Browse Categories',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // Search Field
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search categories...',
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppSpacing.cardRadiusLarge,
                      ),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.md),

              // Categories Grid
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Column(
                    children: List.generate(categories.length, (index) {
                      final category = categories[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.md),
                        child: _buildCategoryCard(context, category),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    Map<String, dynamic> category,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLarge),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(
              context,
            ).pushNamed('/catalog-item-detail', arguments: category['id']);
          },
          borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLarge),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: (category['color'] as Color).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(
                      AppSpacing.cardRadiusLarge,
                    ),
                  ),
                  child: Icon(
                    category['icon'] as IconData,
                    color: category['color'],
                    size: 36,
                  ),
                ),

                SizedBox(height: AppSpacing.md),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category['name'] as String,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category['description'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${category['subcategories']} subcategories',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textTertiary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
