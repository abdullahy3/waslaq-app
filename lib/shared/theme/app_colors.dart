// lib/shared/theme/app_colors.dart
import 'package:flutter/material.dart';

/// Runtime-switchable color palette.
/// Use [context.colors] inside build methods — never [AppColors.dark] or [AppColors.light] directly in UI.
class AppColors {
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;

  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color border;

  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  final Color error;
  final Color success;
  final Color warning;

  final Color upvote;
  final Color downvote;

  const AppColors._({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.error,
    required this.success,
    required this.warning,
    required this.upvote,
    required this.downvote,
  });

  // ─── Dark palette (original app theme) ──────────────────────────────────────
  static const AppColors dark = AppColors._(
    primary:        Color(0xFF7C3AED), // violet-600
    primaryLight:   Color(0xFF8B5CF6), // violet-500
    primaryDark:    Color(0xFF6D28D9), // violet-700

    background:     Color(0xFF000000), // black
    surface:        Color(0xFF111111),
    surfaceVariant: Color(0xFF1A1A1A),
    border:         Color(0xFF2A2A2A),

    textPrimary:    Color(0xFFFFFFFF),
    textSecondary:  Color(0xFF9CA3AF), // gray-400
    textMuted:      Color(0xFF6B7280), // gray-500

    error:          Color(0xFFEF4444),
    success:        Color(0xFF22C55E),
    warning:        Color(0xFFF59E0B),

    upvote:         Color(0xFF22C55E),
    downvote:       Color(0xFFEF4444),
  );

  // ─── Light palette (mirrors the web app) ────────────────────────────────────
  static const AppColors light = AppColors._(
    primary:        Color(0xFF7C3AED), // violet-600 — same brand colour
    primaryLight:   Color(0xFF8B5CF6),
    primaryDark:    Color(0xFF6D28D9),

    background:     Color(0xFFFFFFFF), // white
    surface:        Color(0xFFF9FAFB), // gray-50
    surfaceVariant: Color(0xFFF3F4F6), // gray-100
    border:         Color(0xFFE5E7EB), // gray-200

    textPrimary:    Color(0xFF111827), // gray-900
    textSecondary:  Color(0xFF6B7280), // gray-500
    textMuted:      Color(0xFF9CA3AF), // gray-400

    error:          Color(0xFFEF4444),
    success:        Color(0xFF22C55E),
    warning:        Color(0xFFF59E0B),

    upvote:         Color(0xFF22C55E),
    downvote:       Color(0xFFEF4444),
  );
}

/// Use this inside every build method instead of AppColors.xxx directly.
/// It automatically returns the right colours based on the current theme.
extension WaslaqColorsX on BuildContext {
  AppColors get colors =>
      Theme.of(this).brightness == Brightness.dark ? AppColors.dark : AppColors.light;
}
