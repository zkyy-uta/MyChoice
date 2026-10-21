
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/admin_bottom_navigation.dart';
import 'manage_subcategory_screen.dart';

class TechnologyScreen extends StatelessWidget {
  const TechnologyScreen({super.key});

  static const Color _darkPurple = AppColors.textPurple;

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
                    Row(
                      children: [
                        _statCard('5', 'Subcategories'),
                        const SizedBox(width: 8),
                        _statCard('23', 'Criteria'),
                        const SizedBox(width: 8),
                        _statCard('38', 'Options'),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Subcategories',
                      style: AppTypography.sectionInnerTitle.copyWith(
                        color: _darkPurple,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 1. LAPTOP
                    _subcategoryCard(
                      context: context,
                      name: 'Laptop',
                      icon: Icons.laptop_mac_rounded,
                      incomplete: true,
                    ),

                    // 2. SMARTPHONE
                    _subcategoryCard(
                      context: context,
                      name: 'Smartphone',
                      icon: Icons.smartphone_rounded,
                      incomplete: false,
                    ),

                    // 3. TABLET
                    _subcategoryCard(
                      context: context,
                      name: 'Tablet',
                      icon: Icons.tablet_mac_rounded,
                      incomplete: false,
                    ),

                    // 4. PC
                    _subcategoryCard(
                      context: context,
                      name: 'PC',
                      icon: Icons.desktop_windows_rounded,
                      incomplete: false,
                      criteriaTags: const [
                        'Price',
                        'RAM',
                        'Storage',
                        'CPU Score',
                      ],
                    ),

                    // 5. MONITOR
                    _subcategoryCard(
                      context: context,
                      name: 'Monitor',
                      icon: Icons.monitor_rounded,
                      incomplete: false,
                      criteriaTags: const [
                        'Price',
                        'Screen Size',
                        'Refresh Rate',
                        'Response Time',
                        'Resolution',
                      ],
                    ),
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
      padding: const EdgeInsets.fromLTRB(12, 10, 20, 12),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back to Catalogue',
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: _darkPurple,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Technology',
                  style: AppTypography.sectionInnerTitle.copyWith(
                    color: AppColors.primaryDark,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "Manage what's available in Technology",
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

  Widget _statCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFA18DE1),
              Color(0xFF634A9E),
            ],
          ),
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _subcategoryCard({
    required BuildContext context,
    required String name,
    required IconData icon,
    required bool incomplete,
    List<String>? criteriaTags,
  }) {
    final tags = criteriaTags ??
        const [
          'Price',
          'RAM',
          'Storage',
          'Weight',
        ];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white,
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 7,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 37,
                  height: 37,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE8E0F0),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: _darkPurple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    name,
                    style: AppTypography.sectionInnerTitle.copyWith(
                      color: _darkPurple,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Icon(
                  Icons.auto_awesome,
                  color: Color(0xFFB9A7D5),
                  size: 17,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: [
                for (final tag in tags) _miniTag(tag),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: incomplete
                          ? const Color(0xFFF7E8BD)
                          : const Color(0xFFD7F5D9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      incomplete
                          ? '1 Option Incomplete'
                          : 'All Options Complete',
                      style: TextStyle(
                        color: incomplete
                            ? const Color(0xFF8A6916)
                            : const Color(0xFF287A37),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 34,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) =>
                              ManageSubcategoryScreen(
                            subcategory: name,
                          ),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: _darkPurple,
                      elevation: 1,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                      ),
                      shape: const StadiumBorder(),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'OPEN',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EAF8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: AppTypography.extraSmallSemibold.copyWith(
          color: _darkPurple,
          fontSize: 9,
        ),
      ),
    );
  }
}
