import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth/auth_notifier.dart';
import '../../router/app_router.dart';
import '../theme/app_colors.dart';
import '../../features/social/post/providers/fab_context_provider.dart';
import '../../i18n/strings.g.dart';

// ─── ContextAwareScaffold ────────────────────────────────────────────────────
// Wrap any screen's Scaffold with this to set/clear FAB context automatically.
// The child must be the screen's own Scaffold widget.

class ContextAwareScaffold extends ConsumerStatefulWidget {
  final Widget child;
  final FabContextData? fabContext;

  const ContextAwareScaffold({
    super.key,
    required this.child,
    this.fabContext,
  });

  @override
  ConsumerState<ContextAwareScaffold> createState() =>
      _ContextAwareScaffoldState();
}

class _ContextAwareScaffoldState extends ConsumerState<ContextAwareScaffold> {
  @override
  void initState() {
    super.initState();
    if (widget.fabContext != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(fabContextProvider.notifier).setContext(widget.fabContext);
        }
      });
    }
  }

  @override
  void dispose() {
    ref.read(fabContextProvider.notifier).clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

// ─── WaslaqFAB ───────────────────────────────────────────────────────────────
// Drop this into any Scaffold.floatingActionButton that needs it.

class WaslaqFAB extends ConsumerWidget {
  const WaslaqFAB({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.small(
      backgroundColor: const Color(0xFF7C3AED),
      elevation: 1.0,
      highlightElevation: 1.5,
      shape: const CircleBorder(),
      onPressed: () => _handleTap(context, ref),
      child: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
    );
  }

  void _handleTap(BuildContext context, WidgetRef ref) {
    final authState = ref.read(authNotifierProvider);
    final isAuth = authState.maybeWhen(
      authenticated: (_, __, ___, ____, _____) => true,
      orElse: () => false,
    );

    if (!isAuth) {
      context.router.push(const SignInRoute());
      return;
    }

    final fabCtx = ref.read(fabContextProvider);
    _showCreateSheet(context, fabCtx);
  }

  void _showCreateSheet(BuildContext context, FabContextData? fabCtx) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      isScrollControlled: true,
      builder: (_) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        builder: (_, value, child) => Transform.translate(
          offset: Offset(0, 40 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        ),
        child: _CreatePostSheet(fabContext: fabCtx),
      ),
    );
  }
}

// ─── _CreatePostSheet ─────────────────────────────────────────────────────────

class _CreatePostSheet extends StatelessWidget {
  final FabContextData? fabContext;
  const _CreatePostSheet({this.fabContext});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, MediaQuery.of(context).padding.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            t.create_post.sheet_title,
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _SheetOption(
            icon: Icons.public_outlined,
            label: t.create_post.general_post,
            onTap: () {
              Navigator.pop(context);
              context.router.push(CreatePostRoute());
            },
          ),
          _SheetOption(
            icon: Icons.group_outlined,
            label: fabContext?.communitySlug != null
                ? t.create_post.community_post_in(
                    slug: fabContext!.communitySlug!)
                : t.create_post.community_post,
            onTap: () {
              Navigator.pop(context);
              context.router.push(CreatePostRoute(
                communitySlug: fabContext?.communitySlug,
              ));
            },
          ),
          _SheetOption(
            icon: Icons.shopping_bag_outlined,
            label: fabContext?.productTitle != null
                ? t.create_post.share_product_named(
                    title: fabContext!.productTitle!)
                : t.create_post.share_product,
            onTap: () {
              Navigator.pop(context);
              context.router.push(CreatePostRoute(
                prefilledProductId: fabContext?.productId,
              ));
            },
          ),
          _SheetOption(
            icon: Icons.help_outline,
            label: t.create_post.ask_product,
            onTap: () {
              Navigator.pop(context);
              context.router.push(CreatePostRoute());
            },
          ),
        ],
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        constraints: const BoxConstraints(minHeight: 52),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: context.colors.primary, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right,
                color: context.colors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}
