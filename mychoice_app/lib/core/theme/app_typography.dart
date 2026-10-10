import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// MyChoice Typography System
/// Based on design specifications with Lexend font family
class AppTypography {
  AppTypography._();

  // ==================== SCREEN TITLE ====================

  /// Screen Title - Extra Bold
  /// Font: Lexend, Size: 28sp, Weight: 800, Line Height: 32sp
  static TextStyle screenTitle = GoogleFonts.lexend(
    fontSize: 28,
    fontWeight: FontWeight.w800, // Extra Bold
    height: 32 / 28,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  // ==================== SECTION TITLE ====================

  /// Section Title - Bold
  /// Font: Lexend, Size: 20sp, Weight: 700, Line Height: 24sp
  static TextStyle sectionTitle = GoogleFonts.lexend(
    fontSize: 20,
    fontWeight: FontWeight.w700, // Bold
    height: 24 / 20,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  // ==================== SECTION INNER TITLE ====================

  /// Section Inner Title - Semibold (600)
  /// Font: Lexend, Size: 16sp, Weight: 600, Line Height: 20sp
  static TextStyle sectionInnerTitle = GoogleFonts.lexend(
    fontSize: 16,
    fontWeight: FontWeight.w600, // Semibold
    height: 20 / 16,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  // ==================== BODY TEXT ====================

  /// Body - Regular
  /// Font: Lexend, Size: 14sp, Weight: 400, Line Height: 20sp
  static TextStyle body = GoogleFonts.lexend(
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    height: 20 / 14,
    color: AppColors.textSecondary,
    letterSpacing: 0,
  );

  // ==================== ONE LINER ====================

  /// One Liner - Regular
  /// Font: Lexend, Size: 14sp, Weight: 400, Line Height: 16sp
  static TextStyle oneLiner = GoogleFonts.lexend(
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    height: 16 / 14,
    color: AppColors.textSecondary,
    letterSpacing: 0,
  );

  /// One Liner - Semibold
  /// Font: Lexend, Size: 14sp, Weight: 600, Line Height: 16sp
  static TextStyle oneLinerSemibold = GoogleFonts.lexend(
    fontSize: 14,
    fontWeight: FontWeight.w600, // Semibold
    height: 16 / 14,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  // ==================== SMALL TEXT ====================

  /// Small - Regular
  /// Font: Lexend, Size: 12sp, Weight: 400, Line Height: 16sp
  static TextStyle small = GoogleFonts.lexend(
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
    height: 16 / 12,
    color: AppColors.textSecondary,
    letterSpacing: 0,
  );

  /// Small - Semibold
  /// Font: Lexend, Size: 12sp, Weight: 600, Line Height: 16sp
  static TextStyle smallSemibold = GoogleFonts.lexend(
    fontSize: 12,
    fontWeight: FontWeight.w600, // Semibold
    height: 16 / 12,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  // ==================== EXTRA SMALL TEXT ====================

  /// Extra Small - Semibold
  /// Font: Lexend, Size: 10sp, Weight: 600, Line Height: 12sp
  static TextStyle extraSmallSemibold = GoogleFonts.lexend(
    fontSize: 10,
    fontWeight: FontWeight.w600, // Semibold
    height: 12 / 10,
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  // ==================== BUTTON TEXT ====================

  /// Button Large - Semibold
  /// Font: Lexend, Size: 16sp, Weight: 600
  static TextStyle buttonLarge = GoogleFonts.lexend(
    fontSize: 16,
    fontWeight: FontWeight.w600, // Semibold
    color: AppColors.textWhite,
    letterSpacing: 0,
  );

  /// Button Medium - Semibold
  /// Font: Lexend, Size: 14sp, Weight: 600
  static TextStyle buttonMedium = GoogleFonts.lexend(
    fontSize: 14,
    fontWeight: FontWeight.w600, // Semibold
    color: AppColors.textWhite,
    letterSpacing: 0,
  );

  /// Button Small - Semibold
  /// Font: Lexend, Size: 12sp, Weight: 600
  static TextStyle buttonSmall = GoogleFonts.lexend(
    fontSize: 12,
    fontWeight: FontWeight.w600, // Semibold
    color: AppColors.textWhite,
    letterSpacing: 0,
  );

  // ==================== INPUT TEXT ====================

  /// Input Text - Regular
  /// Font: Lexend, Size: 14sp, Weight: 400
  static TextStyle input = GoogleFonts.lexend(
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  /// Input Hint - Regular
  /// Font: Lexend, Size: 14sp, Weight: 400
  static TextStyle inputHint = GoogleFonts.lexend(
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.textTertiary,
    letterSpacing: 0,
  );

  /// Input Label - Semibold
  /// Font: Lexend, Size: 14sp, Weight: 600
  static TextStyle inputLabel = GoogleFonts.lexend(
    fontSize: 14,
    fontWeight: FontWeight.w600, // Semibold
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  // ==================== HELPER METHODS ====================

  /// Copy text style with custom color
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Copy text style with custom weight
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// Copy text style with custom size
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }
}
