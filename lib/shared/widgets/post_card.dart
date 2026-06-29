import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/account/providers/account_providers.dart';
import '../../features/social/data/models/social_models.dart';
import '../theme/app_colors.dart';
import '../../i18n/strings.g.dart';
import 'package:share_plus/share_plus.dart';
import 'package:waslaq_app/core/error/error_localizer.dart';
import 'user_avatar.dart';

// Strips common markdown syntax so preview text is readable in card context.
String _stripMarkdown(String s) => s
    .replaceAllMapped(RegExp(r'\*\*(.+?)\*\*'), (m) => m[1]!)
    .replaceAllMapped(RegExp(r'\*(.+?)\*'), (m) => m[1]!)
    .replaceAllMapped(RegExp(r'\[(.+?)\]\(.+?\)'), (m) => m[1]!)
    .replaceAll(RegExp(r'#{1,6} '), '')
    .replaceAll('`', '');

// ponytail: StatelessWidget (not ConsumerWidget) so a bookmark toggle / savedItems
// invalidation only rebuilds the one _BookmarkButton — not every card + its image.
class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback? onTap;
  final void Function(String userId)? onAuthorTap;
  final void Function(String slug)? onCommunityTap;
  final void Function(int direction)? onVote;

  const PostCard({
    super.key,
    required this.post,
    this.onTap,
    this.onAuthorTap,
    this.onCommunityTap,
    this.onVote,
  });

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 365) return t.social.years_ago(n: diff.inDays ~/ 365);
    if (diff.inDays > 30) return t.social.months_ago(n: diff.inDays ~/ 30);
    if (diff.inDays > 0) return t.social.days_ago(n: diff.inDays);
    if (diff.inHours > 0) return t.social.hours_ago(n: diff.inHours);
    if (diff.inMinutes > 0) return t.social.minutes_ago(n: diff.inMinutes);
    return t.social.just_now;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.border.withValues(alpha: 0.6)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ─── HEADER ────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Row(children: [
              // Community badge first (Reddit style)
              if (post.communitySlug.isNotEmpty)
                GestureDetector(
                  onTap: () => onCommunityTap?.call(post.communitySlug),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: context.colors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('r/${post.communitySlug}',
                            style: TextStyle(color: context.colors.primary, fontSize: 11, fontWeight: FontWeight.w700)),
                        if (post.communityIsOfficial) ...[
                          const SizedBox(width: 3),
                          Icon(Icons.verified_rounded, size: 11, color: context.colors.primary),
                        ],
                      ],
                    ),
                  ),
                ),
              if (post.communitySlug.isNotEmpty) const SizedBox(width: 8),
              // Author
              GestureDetector(
                onTap: () { if (post.author != null) onAuthorTap?.call(post.author!.customerId); },
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  UserAvatar(
                    fallbackSeed: post.author?.customerId ?? 'anon',
                    avatarUrl: post.author?.avatarUrl,
                    avatarStyle: post.author?.avatarStyle,
                    avatarSeed: post.author?.avatarSeed,
                    size: 22,
                  ),
                  const SizedBox(width: 6),
                  Text(post.author?.displayName ?? 'Unknown',
                      style: TextStyle(color: context.colors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500)),
                  // Admin / trusted-vendor badge (mirrors storefront PostItem)
                  if (post.author?.isAdmin == true) ...[
                    const SizedBox(width: 3),
                    const Icon(Icons.verified_rounded, size: 13, color: Color(0xFFF59E0B)),
                  ] else if (post.author?.isTrustedVendor == true) ...[
                    const SizedBox(width: 3),
                    const Icon(Icons.verified_rounded, size: 13, color: Color(0xFFEAB308)),
                  ],
                ]),
              ),
              const SizedBox(width: 6),
              Text('·', style: TextStyle(color: context.colors.textMuted.withValues(alpha: 0.5), fontSize: 10)),
              const SizedBox(width: 6),
              Text(_timeAgo(post.createdAt),
                  style: TextStyle(color: context.colors.textMuted, fontSize: 10)),
            ]),
          ),

          // ─── TITLE ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
            child: Text(post.title,
                style: TextStyle(color: context.colors.textPrimary, fontSize: 15, fontWeight: FontWeight.w800, height: 1.3),
                maxLines: 3, overflow: TextOverflow.ellipsis),
          ),

          // ─── CONTENT PREVIEW ───────────────────────
          if (post.contentType == 'TEXT' && post.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 5, 14, 0),
              child: Text(_stripMarkdown(post.content),
                  style: TextStyle(color: context.colors.textMuted, fontSize: 12, height: 1.4),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
            ),

          // ─── IMAGE ─────────────────────────────────
          if (post.contentType == 'IMAGE' && post.mediaUrls.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(children: [
                  CachedNetworkImage(
                    imageUrl: post.mediaUrls.first,
                    memCacheWidth: 800,
                    height: 200, width: double.infinity, fit: BoxFit.cover,
                    placeholder: (_, __) => Container(height: 200, color: context.colors.surfaceVariant),
                    errorWidget: (_, __, ___) => Container(height: 200, color: context.colors.surfaceVariant,
                        child: Center(child: Icon(Icons.broken_image, color: context.colors.textMuted))),
                  ),
                  if (post.mediaUrls.length > 1)
                    Positioned(top: 8, right: 8, child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(12)),
                      child: Text('+${post.mediaUrls.length - 1}',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    )),
                ]),
              ),
            ),

          // ─── ACTION BAR ────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 8, 14, 8),
            child: Row(children: [
              Container(
                decoration: BoxDecoration(
                  color: context.colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  _VoteButton(
                    icon: Icons.arrow_upward_rounded,
                    onTap: () => onVote?.call(1),
                    color: post.userVote == 1 ? context.colors.upvote : context.colors.textMuted,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 6),
                    child: Text(
                      '${post.upvotes}',
                      style: TextStyle(
                        color: post.userVote == 1 ? context.colors.upvote : context.colors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 12,
                    color: context.colors.textMuted.withValues(alpha: 0.2),
                  ),
                  _VoteButton(
                    icon: Icons.arrow_downward_rounded,
                    onTap: () => onVote?.call(-1),
                    color: post.userVote == -1 ? context.colors.downvote : context.colors.textMuted,
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: Text(
                      '${post.downvotes}',
                      style: TextStyle(
                        color: post.userVote == -1 ? context.colors.downvote : context.colors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ]),
              ),
              const SizedBox(width: 8),
              // Comments
              _ActionChip(icon: Icons.chat_bubble_outline_rounded, label: t.social.comment_button, onTap: onTap),
              const SizedBox(width: 8),
              // Share
              _ActionChip(
                icon: Icons.ios_share_rounded,
                label: t.social.share_button,
                onTap: () {
                  final community = post.communitySlug.isNotEmpty ? post.communitySlug : 'all';
                  final url = 'https://waslaq.com/r/$community/comments/${post.id}';
                  Share.share(t.social.share_post(title: post.title, url: url));
                },
              ),
              const Spacer(),
              // Bookmark — isolated so only it rebuilds on savedItems changes
              _BookmarkButton(postId: post.id),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ponytail: own ConsumerWidget so savedItemsProvider rebuilds touch only this icon,
// and loading/error show a static icon (no per-card CircularProgressIndicator repainting every frame).
class _BookmarkButton extends ConsumerWidget {
  final String postId;
  const _BookmarkButton({required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mutedIcon = Icon(
      Icons.bookmark_outline_rounded,
      color: context.colors.textMuted.withValues(alpha: 0.6),
      size: 20,
    );

    return ref.watch(savedItemsProvider).when(
      data: (savedItems) {
        final isSaved = savedItems.isPostSaved(postId);
        return GestureDetector(
          onTap: () async {
            try {
              final newSavedState = await ref.read(accountRepositoryProvider).toggleSave('post', postId);
              ref.invalidate(savedItemsProvider);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(newSavedState
                      ? t.settings.saved_ok
                      : (Localizations.localeOf(context).languageCode == 'ar' ? 'تمت الإزالة من المحفوظات' : 'Removed from saved items')),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localizeError(e))),
                );
              }
            }
          },
          child: Icon(
            isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
            color: isSaved ? context.colors.primary : context.colors.textMuted.withValues(alpha: 0.6),
            size: 20,
          ),
        );
      },
      loading: () => mutedIcon,
      error: (_, __) => GestureDetector(
        onTap: () => ref.invalidate(savedItemsProvider),
        child: mutedIcon,
      ),
    );
  }
}

class _VoteButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  const _VoteButton({required this.icon, this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _ActionChip({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: context.colors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 14, color: context.colors.textMuted),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: context.colors.textMuted, fontSize: 11, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}
