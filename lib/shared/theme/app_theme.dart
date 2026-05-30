// lib/shared/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  // ─── Dark ────────────────────────────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary:    AppColors.dark.primary,
      onPrimary:  AppColors.dark.textPrimary,
      secondary:  AppColors.dark.primaryLight,
      surface:    AppColors.dark.surface,
      onSurface:  AppColors.dark.textPrimary,
      error:      AppColors.dark.error,
      outline:    AppColors.dark.border,
    ),
    scaffoldBackgroundColor: AppColors.dark.background,
    appBarTheme: AppBarTheme(
      backgroundColor:          AppColors.dark.background,
      foregroundColor:          AppColors.dark.textPrimary,
      elevation:                0,
      scrolledUnderElevation:   0,
      centerTitle:              false,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor:      AppColors.dark.surface,
      selectedItemColor:    AppColors.dark.primary,
      unselectedItemColor:  AppColors.dark.textMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: AppColors.dark.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: AppColors.dark.border, width: 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled:     true,
      fillColor:  AppColors.dark.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.dark.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.dark.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.dark.primary, width: 2),
      ),
      labelStyle: TextStyle(color: AppColors.dark.textSecondary),
      hintStyle:  TextStyle(color: AppColors.dark.textMuted),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.dark.primary,
        foregroundColor: AppColors.dark.textPrimary,
        minimumSize:     const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    dividerTheme: DividerThemeData(
      color:     AppColors.dark.border,
      thickness: 1,
    ),
  );

  // ─── Light (mirrors web app) ─────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary:    AppColors.light.primary,
      onPrimary:  Colors.white,
      secondary:  AppColors.light.primaryLight,
      surface:    AppColors.light.surface,
      onSurface:  AppColors.light.textPrimary,
      error:      AppColors.light.error,
      outline:    AppColors.light.border,
    ),
    scaffoldBackgroundColor: AppColors.light.background,
    appBarTheme: AppBarTheme(
      backgroundColor:          AppColors.light.background,
      foregroundColor:          AppColors.light.textPrimary,
      elevation:                0,
      scrolledUnderElevation:   0.5,
      shadowColor:              AppColors.light.border,
      centerTitle:              false,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor:      AppColors.light.background,
      selectedItemColor:    AppColors.light.primary,
      unselectedItemColor:  AppColors.light.textMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: AppColors.light.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: AppColors.light.border, width: 1),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled:     true,
      fillColor:  AppColors.light.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.light.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.light.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.light.primary, width: 2),
      ),
      labelStyle: TextStyle(color: AppColors.light.textSecondary),
      hintStyle:  TextStyle(color: AppColors.light.textMuted),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.light.primary,
        foregroundColor: Colors.white,
        minimumSize:     const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    dividerTheme: DividerThemeData(
      color:     AppColors.light.border,
      thickness: 1,
    ),
  );
}
