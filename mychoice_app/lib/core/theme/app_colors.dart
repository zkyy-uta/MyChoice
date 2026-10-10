import 'package:flutter/material.dart';

/// MyChoice Color Palette
/// Based on design system specifications
class AppColors {
  AppColors._();

  // ==================== BASE COLORS ====================

  /// Primary Gradient (Purple)
  static const Color primaryGradient = Color(0xFF8B7EF2); // Primary / 88
  static const Color primaryLight = Color(0xFFB4A7FF); // Light
  static const Color primaryDark = Color(0xFF5546A0); // Dark

  /// Primary Colors
  static const Color primary88 = Color(0xFF8B7EF2);
  static const Color primary80 = Color(0xFFA99AFF);
  static const Color primary60 = Color(0xFFC7BBFF);
  static const Color primary40 = Color(0xFFE3DDFF);
  static const Color primary20 = Color(0xFFF3F1FF);

  // ==================== SECONDARY COLORS ====================

  /// Secondary (Pink/Magenta)
  static const Color secondary80 = Color(0xFFFFB6E5);
  static const Color secondary60 = Color(0xFFFFD1EE);
  static const Color secondary40 = Color(0xFFFFE8F7);
  static const Color secondary20 = Color(0xFFFFF5FC);

  // ==================== NEUTRAL COLORS ====================

  /// Grey Scale
  static const Color grey50 = Color(0xFFF8F9FA);
  static const Color grey100 = Color(0xFFF1F3F5);
  static const Color grey200 = Color(0xFFE9ECEF);
  static const Color grey300 = Color(0xFFDEE2E6);
  static const Color grey400 = Color(0xFFCED4DA);
  static const Color grey500 = Color(0xFFADB5BD);
  static const Color grey600 = Color(0xFF6C757D);
  static const Color grey700 = Color(0xFF495057);
  static const Color grey800 = Color(0xFF343A40);
  static const Color grey900 = Color(0xFF212529);

  // ==================== SEMANTIC COLORS ====================

  /// Error Colors
  static const Color error80 = Color(0xFFFF6B6B);
  static const Color error60 = Color(0xFFFF8787);
  static const Color error40 = Color(0xFFFFA3A3);
  static const Color error20 = Color(0xFFFFD1D1);

  /// Success Colors
  static const Color success80 = Color(0xFF51CF66);
  static const Color success60 = Color(0xFF8CE99A);
  static const Color success40 = Color(0xFFB2F2BB);
  static const Color success20 = Color(0xFFD3F9D8);

  /// Warning Colors
  static const Color warning80 = Color(0xFFFFC078);
  static const Color warning60 = Color(0xFFFFD8A8);
  static const Color warning40 = Color(0xFFFFE8CC);
  static const Color warning20 = Color(0xFFFFF4E6);

  /// Info Colors
  static const Color info80 = Color(0xFF4DABF7);
  static const Color info60 = Color(0xFF74C0FC);
  static const Color info40 = Color(0xFFA5D8FF);
  static const Color info20 = Color(0xFFD0EBFF);

  // ==================== BACKGROUND & SURFACE ====================

  /// Background Gradient (Simple - Original)
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFB4A7FF), // Light Purple
      Color(0xFF8B7EF2), // Primary Purple
    ],
  );

  /// Soft Gradient Background (Like UI/UX Design)
  /// Purple top → White center → Purple bottom with blur effect
  static const LinearGradient softGradientBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.3, 0.7, 1.0],
    colors: [
      Color(0xFFB4A7FF), // Purple top
      Color(0xFFF5F3FF), // Very light purple/white
      Color(0xFFF5F3FF), // Very light purple/white
      Color(0xFFB4A7FF), // Purple bottom
    ],
  );

  /// Animated Gradient Colors (for shimmer effect)
  static const List<Color> animatedGradientColors = [
    Color(0xFFE3DDFF), // Light purple
    Color(0xFFB4A7FF), // Medium purple
    Color(0xFF8B7EF2), // Primary purple
    Color(0xFFB4A7FF), // Medium purple
    Color(0xFFE3DDFF), // Light purple
  ];

  /// Surface Colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFFAF9FF);
  static const Color surfaceDark = Color(0xFF5546A0);

  /// Card Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBackgroundPurple = Color(0xFFE3DDFF);
  static const Color cardBackgroundLight = Color(0xFFF8F7FF);

  // ==================== TEXT COLORS ====================

  /// Text
  static const Color textPrimary = Color(0xFF212529); // Grey-900
  static const Color textSecondary = Color(0xFF6C757D); // Grey-600
  static const Color textTertiary = Color(0xFFADB5BD); // Grey-500
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textPurple = Color(0xFF5546A0); // Dark Purple

  // ==================== CATEGORY COLORS ====================

  /// Technology
  static const Color categoryTechnology = Color(0xFF8B7EF2); // Primary
  static const Color categoryTechnologyLight = Color(0xFFE3DDFF);

  /// Education
  static const Color categoryEducation = Color(0xFFFF6B9D); // Secondary-ish
  static const Color categoryEducationLight = Color(0xFFFFE8F7);

  /// Fashion
  static const Color categoryFashion = Color(0xFFFFC078); // Warning
  static const Color categoryFashionLight = Color(0xFFFFF4E6);

  // ==================== UTILITY ====================

  /// Borders
  static const Color border = Color(0xFFE9ECEF); // Grey-200
  static const Color borderLight = Color(0xFFF1F3F5); // Grey-100
  static const Color borderDark = Color(0xFFDEE2E6); // Grey-300

  /// Shadows
  static Color shadow = const Color(0xFF5546A0).withValues(alpha: 0.15);
  static Color shadowLight = const Color(0xFF8B7EF2).withValues(alpha: 0.08);

  /// Overlay
  static Color overlay = const Color(0xFF000000).withValues(alpha: 0.5);
  static Color overlayLight = const Color(0xFF000000).withValues(alpha: 0.3);

  /// Divider
  static const Color divider = Color(0xFFE9ECEF);

  // ==================== INDICATOR ====================

  /// Page Indicators
  static const Color indicatorActive = Color(0xFF5546A0);
  static const Color indicatorInactive = Color(0xFFDEE2E6);
}
