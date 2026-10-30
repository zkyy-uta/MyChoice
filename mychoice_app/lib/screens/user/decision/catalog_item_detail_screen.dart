import 'package:flutter/material.dart';
import 'package:mychoice_app/core/theme/app_spacing.dart';
import 'package:mychoice_app/core/theme/app_colors.dart';
import 'package:mychoice_app/core/widgets/mobile_background.dart';

class CatalogItemDetailScreen extends StatefulWidget {
  final String categoryId;

  const CatalogItemDetailScreen({super.key, required this.categoryId});

  @override
  State<CatalogItemDetailScreen> createState() =>
      _CatalogItemDetailScreenState();
}

class _CatalogItemDetailScreenState extends State<CatalogItemDetailScreen> {
  // Mock alternatives data
  final Map<String, List<Map<String, String>>> mockAlternatives = {
    'laptop': [
      {
        'name': 'MacBook Pro 16"',
        'brand': 'Apple',
        'specs': 'M3 Pro, 16GB RAM, 512GB SSD',
        'price': '\$3,499',
      },
      {
        'name': 'Dell XPS 15',
        'brand': 'Dell',
        'specs': 'Intel i7, 16GB RAM, 512GB SSD',
        'price': '\$1,999',
      },
      {
        'name': 'Lenovo ThinkPad X1',
        'brand': 'Lenovo',
        'specs': 'Intel i7, 16GB RAM, 512GB SSD',
        'price': '\$1,599',
      },
      {
        'name': 'ASUS VivoBook Pro',
        'brand': 'ASUS',
        'specs': 'AMD Ryzen 7, 16GB RAM, 512GB SSD',
        'price': '\$1,299',
      },
      {
        'name': 'HP ZBook',
        'brand': 'HP',
        'specs': 'Intel i9, 32GB RAM, 1TB SSD',
        'price': '\$2,499',
      },
      {
        'name': 'MSI GE76 Raider',
        'brand': 'MSI',
        'specs': 'Intel i9, 32GB RAM, 1TB SSD',
        'price': '\$2,299',
      },
    ],
    'smartphone': [
      {
        'name': 'iPhone 15 Pro',
        'brand': 'Apple',
        'specs': 'A17 Pro, 128GB, 6.1"',
        'price': '\$999',
      },
      {
        'name': 'Samsung S24 Ultra',
        'brand': 'Samsung',
        'specs': 'Snapdragon 8 Gen 3, 256GB, 6.8"',
        'price': '\$1,299',
      },
      {
        'name': 'Google Pixel 8',
        'brand': 'Google',
        'specs': 'Tensor G3, 128GB, 6.2"',
        'price': '\$799',
      },
      {
        'name': 'OnePlus 12',
        'brand': 'OnePlus',
        'specs': 'Snapdragon 8 Gen 3, 256GB, 6.7"',
        'price': '\$799',
      },
    ],
    'tablet': [
      {
        'name': 'iPad Pro 11"',
        'brand': 'Apple',
        'specs': 'M2, 128GB, 11" display',
        'price': '\$1,099',
      },
      {
        'name': 'Samsung Galaxy Tab S9',
        'brand': 'Samsung',
        'specs': 'Snapdragon 8 Gen 2, 128GB, 11"',
        'price': '\$799',
      },
      {
        'name': 'Microsoft Surface Pro 9',
        'brand': 'Microsoft',
        'specs': 'Intel i7, 256GB, 13"',
        'price': '\$1,299',
      },
    ],
    'course': [
      {
        'name': 'Python for Data Science',
        'brand': 'Coursera',
        'specs': '4 weeks, Intermediate level',
        'price': 'Free/\$49',
      },
      {
        'name': 'Machine Learning A-Z',
        'brand': 'Udemy',
        'specs': '40 hours, Beginner level',
        'price': '\$99',
      },
      {
        'name': 'Web Development Bootcamp',
        'brand': 'Udemy',
        'specs': '56 hours, Complete guide',
        'price': '\$119',
      },
      {
        'name': 'React & Node.js',
        'brand': 'Pluralsight',
        'specs': '15 hours, Intermediate',
        'price': '\$299/year',
      },
    ],
    'shoes': [
      {
        'name': 'Nike Air Max 90',
        'brand': 'Nike',
        'specs': 'Casual, Multiple colors',
        'price': '\$129',
      },
      {
        'name': 'Adidas Ultraboost 22',
        'brand': 'Adidas',
        'specs': 'Running, Comfortable',
        'price': '\$189',
      },
      {
        'name': 'Puma RS-X',
        'brand': 'Puma',
        'specs': 'Retro style, Lightweight',
        'price': '\$99',
      },
      {
        'name': 'New Balance 990v6',
        'brand': 'New Balance',
        'specs': 'Premium, Durable',
        'price': '\$185',
      },
    ],
  };

  late String _selectedSubcategory;
  List<Map<String, String>> _currentAlternatives = [];

  @override
  void initState() {
    super.initState();
    _initializeSubcategory();
  }

  void _initializeSubcategory() {
    // Default to first available alternative list
    switch (widget.categoryId) {
      case 'technology':
        _selectedSubcategory = 'laptop';
        break;
      case 'education':
        _selectedSubcategory = 'course';
        break;
      case 'fashion':
        _selectedSubcategory = 'shoes';
        break;
      default:
        _selectedSubcategory = 'laptop';
    }
    _updateAlternatives();
  }

  void _updateAlternatives() {
    setState(() {
      _currentAlternatives = mockAlternatives[_selectedSubcategory] ?? [];
    });
  }

  Map<String, dynamic> _getCategoryInfo() {
    switch (widget.categoryId) {
      case 'technology':
        return {
          'name': 'Technology',
          'icon': Icons.devices,
          'color': Colors.blue,
        };
      case 'education':
        return {
          'name': 'Education',
          'icon': Icons.school,
          'color': Colors.purple,
        };
      case 'fashion':
        return {
          'name': 'Fashion',
          'icon': Icons.checkroom,
          'color': Colors.pink,
        };
      default:
        return {
          'name': 'Category',
          'icon': Icons.category,
          'color': Colors.grey,
        };
    }
  }

  List<String> _getSubcategories() {
    switch (widget.categoryId) {
      case 'technology':
        return [
          'laptop',
          'smartphone',
          'tablet',
          'monitor',
          'gaming_pc',
          'processor',
          'graphics_card',
        ];
      case 'education':
        return [
          'course',
          'certification',
          'bootcamp',
          'university',
          'training_program',
        ];
      case 'fashion':
        return [
          'dress',
          'shoes',
          'accessories',
          'bags',
          'jewelry',
          'outerwear',
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryInfo = _getCategoryInfo();
    final subcategories = _getSubcategories();

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
                      categoryInfo['name'] as String,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // Subcategory Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: List.generate(subcategories.length, (index) {
                    final subcategory = subcategories[index];
                    final isSelected = _selectedSubcategory == subcategory;
                    return Padding(
                      padding: EdgeInsets.only(right: AppSpacing.sm),
                      child: FilterChip(
                        label: Text(
                          subcategory.replaceAll('_', ' ').toUpperCase(),
                        ),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            _selectedSubcategory = subcategory;
                            _updateAlternatives();
                          });
                        },
                        selectedColor: categoryInfo['color'],
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              SizedBox(height: AppSpacing.md),

              // Alternatives List
              Expanded(
                child: _currentAlternatives.isEmpty
                    ? Center(
                        child: Text(
                          'No alternatives available',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        itemCount: _currentAlternatives.length,
                        itemBuilder: (context, index) {
                          final alt = _currentAlternatives[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: AppSpacing.md),
                            child: _buildAlternativeCard(
                              context,
                              alt,
                              categoryInfo,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlternativeCard(
    BuildContext context,
    Map<String, String> alternative,
    Map<String, dynamic> categoryInfo,
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tap to compare: ${alternative['name']}'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLarge),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alternative['name']!,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          alternative['brand']!,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    Text(
                      alternative['price']!,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: categoryInfo['color'],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  'Specs: ${alternative['specs']!}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Learn more about ${alternative['name']}',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: categoryInfo['color']),
                    ),
                    child: Text(
                      'Learn More',
                      style: TextStyle(color: categoryInfo['color']),
                    ),
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
