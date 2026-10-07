import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

/// MyChoice App Theme
/// Centralized theme configuration for the entire app
class AppTheme {
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // ==================== COLOR SCHEME ====================
      colorScheme: ColorScheme.light(
        primary: AppColors.primary88,
        secondary: AppColors.secondary80,
        surface: AppColors.surface,
        error: AppColors.error80,
        onPrimary: AppColors.textWhite,
        onSecondary: AppColors.textWhite,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textWhite,
      ),

      // ==================== SCAFFOLD ====================
      scaffoldBackgroundColor: AppColors.surfaceLight,

      // ==================== APP BAR ====================
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTypography.sectionTitle,
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: AppSpacing.iconMd,
        ),
      ),

      // ==================== ELEVATED BUTTON ====================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary88,
          foregroundColor: AppColors.textWhite,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonHorizontal,
            vertical: AppSpacing.buttonVertical,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          textStyle: AppTypography.buttonLarge,
        ),
      ),

      // ==================== TEXT BUTTON ====================
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary88,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          textStyle: AppTypography.buttonMedium,
        ),
      ),

      // ==================== OUTLINED BUTTON ====================
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary88,
          side: const BorderSide(color: AppColors.primary88, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonHorizontal,
            vertical: AppSpacing.buttonVertical,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          textStyle: AppTypography.buttonLarge,
        ),
      ),

      // ==================== INPUT DECORATION ====================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.inputHorizontal,
          vertical: AppSpacing.inputVertical,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: const BorderSide(color: AppColors.primary88, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: const BorderSide(color: AppColors.error80, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
          borderSide: const BorderSide(color: AppColors.error80, width: 2),
        ),
        hintStyle: AppTypography.inputHint,
        labelStyle: AppTypography.inputLabel,
        errorStyle: AppTypography.small.copyWith(color: AppColors.error80),
      ),

      // ==================== CARD ====================
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.cardBackground,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        margin: const EdgeInsets.all(AppSpacing.cardMargin),
      ),

      // ==================== BOTTOM SHEET ====================
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.bottomSheetRadius),
          ),
        ),
        elevation: 8,
      ),

      // ==================== DIALOG ====================
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.dialogRadius),
        ),
        titleTextStyle: AppTypography.sectionTitle,
        contentTextStyle: AppTypography.body,
      ),

      // ==================== DIVIDER ====================
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: AppSpacing.md,
      ),

      // ==================== ICON ====================
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size: AppSpacing.iconMd,
      ),

      // ==================== CHECKBOX ====================
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary88;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.textWhite),
        side: const BorderSide(color: AppColors.border, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // ==================== RADIO ====================
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary88;
          }
          return AppColors.border;
        }),
      ),

      // ==================== SWITCH ====================
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.textWhite;
          }
          return AppColors.grey300;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary88;
          }
          return AppColors.grey200;
        }),
      ),

      // ==================== SLIDER ====================
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary88,
        inactiveTrackColor: AppColors.primary20,
        thumbColor: AppColors.primary88,
        overlayColor: AppColors.primary20,
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      ),

      // ==================== PROGRESS INDICATOR ====================
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary88,
        linearTrackColor: AppColors.primary20,
        circularTrackColor: AppColors.primary20,
      ),

      // ==================== FLOATING ACTION BUTTON ====================
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary88,
        foregroundColor: AppColors.textWhite,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // ==================== NAVIGATION BAR ====================
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        elevation: 8,
        height: 72,
        labelTextStyle: WidgetStateProperty.all(
          AppTypography.extraSmallSemibold,
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppColors.primary88,
              size: AppSpacing.iconMd,
            );
          }
          return const IconThemeData(
            color: AppColors.textTertiary,
            size: AppSpacing.iconMd,
          );
        }),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),

      // ==================== TEXT THEME ====================
      textTheme: TextTheme(
        displayLarge: AppTypography.screenTitle,
        titleLarge: AppTypography.sectionTitle,
        titleMedium: AppTypography.sectionInnerTitle,
        bodyLarge: AppTypography.body,
        bodyMedium: AppTypography.oneLiner,
        bodySmall: AppTypography.small,
        labelLarge: AppTypography.buttonLarge,
        labelMedium: AppTypography.buttonMedium,
        labelSmall: AppTypography.extraSmallSemibold,
      ),
    );
  }
}
