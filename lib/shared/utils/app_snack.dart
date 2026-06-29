// lib/shared/utils/app_snack.dart
// Friendly, localized snackbars. Errors go through localizeError() —
// never show raw exception text to the user.

import 'package:flutter/material.dart';

import '../../core/error/error_localizer.dart';
import '../theme/app_colors.dart';

class AppSnack {
  AppSnack._();

  static void error(BuildContext context, Object? error) {
    _show(
      context,
      message: localizeError(error),
      background: context.colors.error,
      icon: Icons.error_outline_rounded,
    );
  }

  static void success(BuildContext context, String message) {
    _show(
      context,
      message: message,
      background: context.colors.success,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  static void info(BuildContext context, String message) {
    _show(
      context,
      message: message,
      background: context.colors.surfaceVariant,
      icon: Icons.info_outline_rounded,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required Color background,
    required IconData icon,
  }) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 13.5),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
