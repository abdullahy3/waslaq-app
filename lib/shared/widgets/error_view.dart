// lib/shared/widgets/error_view.dart
// Full-screen / inline friendly error state with retry.
// Use anywhere a load fails: ErrorView(error: e, onRetry: _reload)

import 'package:flutter/material.dart';

import '../../core/error/error_localizer.dart';
import '../../i18n/strings.g.dart';
import '../theme/app_colors.dart';

class ErrorView extends StatelessWidget {
  final Object? error;
  final VoidCallback? onRetry;
  final bool compact;

  const ErrorView({
    super.key,
    this.error,
    this.onRetry,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final message = localizeError(error);
    final isNetwork = message == t.errors.network || message == t.errors.timeout;
    final icon = isNetwork ? Icons.wifi_off_rounded : Icons.error_outline_rounded;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 56 : 72,
          height: compact ? 56 : 72,
          decoration: BoxDecoration(
            color: context.colors.surfaceVariant,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: compact ? 28 : 36, color: context.colors.textMuted),
        ),
        SizedBox(height: compact ? 12 : 16),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: context.colors.textSecondary,
            fontSize: compact ? 13 : 14.5,
            height: 1.5,
          ),
        ),
        if (onRetry != null) ...[
          SizedBox(height: compact ? 12 : 20),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(t.common.retry),
            style: FilledButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(120, 44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            ),
          ),
        ],
      ],
    );

    if (compact) {
      return Padding(padding: const EdgeInsets.all(24), child: Center(child: content));
    }
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: content,
      ),
    );
  }
}
