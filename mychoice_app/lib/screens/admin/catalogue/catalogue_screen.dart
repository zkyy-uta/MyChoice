import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/admin_bottom_navigation.dart';
import '../../../core/widgets/mobile_background.dart';
import 'technology_screen.dart';

class CatalogueScreen extends StatelessWidget {
  const CatalogueScreen({super.key});

  static const Color _darkPurple = AppColors.textPurple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: MobileBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Categories',
                        style: AppTypography.sectionInnerTitle.copyWith(
                          color: _darkPurple,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildCategoryCard(
                        context: context,
                        title: 'Technology',
                        icon: Icons.laptop_mac_rounded,
                        criteria: 23,
                        subcategories: 5,
                        accent: const Color(0xFFD9C7F0),
                      ),
                      _buildCategoryCard(
                        context: context,
                        title: 'Education',
                        icon: Icons.school_outlined,
                        criteria: 11,
                        subcategories: 3,
                        accent: const Color(0xFFD6E6F7),
                      ),
                      _buildCategoryCard(
                        context: context,
                        title: 'Fashion',
                        icon: Icons.checkroom_outlined,
                        criteria: 19,
                        subcategories: 5,
                        accent: const Color(0xFFF4D6E5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AdminBottomNavigation(selectedIndex: 2),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Catalogue',
                  style: AppTypography.sectionInnerTitle.copyWith(
                    color: AppColors.primaryDark,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Keep categories and choices up to date',
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
  // CATEGORY CARD
  // ============================================================

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required int criteria,
    required int subcategories,
    required Color accent,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 7,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (title == 'Technology') {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const TechnologyScreen(),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$title screen will be connected next.'),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE8E0F0)),
                      ),
                      child: Icon(icon, size: 21, color: _darkPurple),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        title,
                        style: AppTypography.sectionInnerTitle.copyWith(
                          color: _darkPurple,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F0FA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.layers_outlined,
                            size: 12,
                            color: _darkPurple,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$subcategories Subcategories',
                            style: AppTypography.extraSmallSemibold.copyWith(
                              color: _darkPurple,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '$criteria Criteria',
                  style: AppTypography.extraSmallSemibold.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _categoryIcon(icon, accent),
                    const SizedBox(width: 7),
                    _categoryIcon(
                      Icons.school_outlined,
                      const Color(0xFFF3D4BB),
                    ),
                    const SizedBox(width: 7),
                    _categoryIcon(
                      Icons.shopping_bag_outlined,
                      const Color(0xFFF2D4E5),
                    ),
                    const SizedBox(width: 6),
                    if (subcategories > 3)
                      Container(
                        width: 31,
                        height: 31,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '+${subcategories - 3}',
                          style: AppTypography.extraSmallSemibold.copyWith(
                            color: _darkPurple,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    const Spacer(),
                    Container(
                      width: 43,
                      height: 37,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: accent, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: _darkPurple,
                        size: 23,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORY ICON
  // ============================================================

  Widget _categoryIcon(IconData icon, Color color) {
    return Container(
      width: 31,
      height: 31,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, color: _darkPurple, size: 16),
    );
  }
}
