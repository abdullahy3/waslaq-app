// lib/shared/widgets/user_avatar.dart
// Single source of truth for rendering a user's avatar:
//   - custom uploaded picture (avatarUrl) when present, else
//   - a DiceBear PNG built from avatarStyle + avatarSeed.
// DiceBear PNG (not SVG) so CachedNetworkImageProvider renders it natively
// (global Flutter rule #4). Used by search, messages and follower lists.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String? avatarStyle;
  final String? avatarSeed;

  /// Stable fallback seed (use the customerId) when avatarSeed is missing.
  final String fallbackSeed;
  final double size;

  const UserAvatar({
    super.key,
    required this.fallbackSeed,
    this.avatarUrl,
    this.avatarStyle,
    this.avatarSeed,
    this.size = 44,
  });

  String get _resolvedUrl {
    if (avatarUrl != null && avatarUrl!.trim().isNotEmpty) return avatarUrl!.trim();
    final style = (avatarStyle != null && avatarStyle!.isNotEmpty) ? avatarStyle! : 'big-smile';
    final seed = Uri.encodeComponent(
      (avatarSeed != null && avatarSeed!.isNotEmpty) ? avatarSeed! : fallbackSeed,
    );
    return 'https://api.dicebear.com/9.x/$style/png?seed=$seed';
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: _resolvedUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        memCacheWidth: (size * 3).round(),
        placeholder: (_, __) => Container(
          width: size,
          height: size,
          color: context.colors.surfaceVariant,
        ),
        errorWidget: (_, __, ___) => Container(
          width: size,
          height: size,
          color: context.colors.surfaceVariant,
          child: Icon(Icons.person, size: size * 0.55, color: context.colors.textMuted),
        ),
      ),
    );
  }
}
