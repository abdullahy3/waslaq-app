import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/social_client.dart';
import '../../../../core/auth/auth_notifier.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../router/app_router.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/post_card.dart';
import '../../../messages/providers/stream_chat_provider.dart';
import '../../../social/providers/social_providers.dart';

@RoutePage()
class UserProfileScreen extends ConsumerStatefulWidget {
  final String userId;

  const UserProfileScreen({
    super.key,
    @PathParam('userId') this.userId = '',
  });

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Opens a DM channel with the given user, syncing their profile into Stream first.
  Future<void> _startDM(
      BuildContext context, WidgetRef ref, String targetCustomerId) async {
    final authState = ref.read(authNotifierProvider);
    final currentCustomerId = authState.maybeWhen(
      authenticated: (id, _, __, ___, ____) => id,
      orElse: () => null,
    );

    if (currentCustomerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to send messages')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await ref.read(streamChatConnectionProvider.future);

      final client = ref.read(streamChatClientProvider);
      final myId = client.state.currentUser?.id;
      if (myId == null) throw Exception('Not connected to chat server');

      final theirId = 'customer_$targetCustomerId';

      try {
        await SocialClient.instance
            .post('/store/social/users/$targetCustomerId/sync-chat');
      } catch (_) {}

      final members = [myId, theirId]..sort();
      final channelId = members.join('__');

      final channel = client.channel(
        'messaging',
        id: channelId,
        extraData: {'members': members},
      );
      await channel.watch();

      if (context.mounted) {
        Navigator.of(context).pop();
        context.router.push(ChatRoute(cid: channel.cid!));
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  t.messages.could_not_open_chat(error: e.toString()))),
        );
      }
    }
  }

  /// Returns the correct avatar URL — real photo first, DiceBear PNG fallback.
  String _resolveAvatar(
      String? avatarUrl, String? styleStr, String? seedStr, String userId) {
    if (avatarUrl != null && avatarUrl.isNotEmpty) return avatarUrl;
    final style =
        (styleStr != null && styleStr.isNotEmpty) ? styleStr : 'big-smile';
    final seed = (seedStr != null && seedStr.isNotEmpty) ? seedStr : userId;
    return 'https://api.dicebear.com/9.x/$style/png?seed=${Uri.encodeComponent(seed)}&size=128';
  }

  /// Parses a hex color string (e.g. '#6d28d9') into a Flutter Color.
  /// Falls back to the default violet if null or invalid — matching the web.
  Color _parseBannerColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return const Color(0xFF6D28D9); // default purple — same as web
    }
    try {
      String hex = hexColor.replaceAll('#', '');
      if (hex.length == 3) {
        hex = hex.split('').map((c) => '$c$c').join();
      }
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      }
      if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (_) {}
    return const Color(0xFF6D28D9);
  }

  String _getTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 365) return t.social.years_short(n: diff.inDays ~/ 365);
    if (diff.inDays > 0) return t.social.days_short(n: diff.inDays);
    if (diff.inHours > 0) return t.social.hours_short(n: diff.inHours);
    if (diff.inMinutes > 0) return t.social.minutes_short(n: diff.inMinutes);
    return t.social.now_short;
  }

  // A single "12 Followers" style stat; tappable when [onTap] is provided.
  Widget _statItem(
    BuildContext context, {
    required String value,
    required String label,
    VoidCallback? onTap,
  }) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value,
            style: TextStyle(
                color: context.colors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(color: context.colors.textSecondary, fontSize: 14)),
      ],
    );
    if (onTap == null) return child;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider(widget.userId));
    final authState = ref.watch(authNotifierProvider);
    final currentUserId = authState.maybeWhen(
      authenticated: (id, _, __, ___, ____) => id,
      orElse: () => '',
    );
    final isOwnProfile = currentUserId == widget.userId;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: profileAsync.when(
        loading: () => Center(
            child:
                CircularProgressIndicator(color: context.colors.primary)),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline,
                  size: 48, color: context.colors.error),
              const SizedBox(height: 16),
              Text(t.user_profile.failed_load,
                  style:
                      TextStyle(color: context.colors.textPrimary)),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () =>
                    ref.invalidate(userProfileProvider(widget.userId)),
                child: Text(t.common.retry),
              ),
            ],
          ),
        ),
        data: (profile) {
          final avatarUrl = _resolveAvatar(
            profile.avatarUrl,
            profile.avatarStyle,
            profile.avatarSeed,
            profile.customerId,
          );

          // Vendor store card: only when profile has a real vendorSlug
          final hasVendorStore = profile.vendorSlug != null &&
              profile.vendorSlug!.isNotEmpty;

          return DefaultTabController(
            length: 3,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  // ── Banner + Avatar ──────────────────────────────
                  SliverAppBar(
                    expandedHeight: 160,
                    pinned: true,
                    backgroundColor: context.colors.surface,
                    iconTheme:
                        const IconThemeData(color: Colors.white),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Banner
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            height: 120,
                            child: profile.bannerUrl != null &&
                                    profile.bannerUrl!.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: profile.bannerUrl!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorWidget: (_, __, ___) =>
                                        Container(
                                            color: _parseBannerColor(
                                                profile.bannerColor)),
                                  )
                                : Container(
                                    color: _parseBannerColor(
                                        profile.bannerColor)),
                          ),
                          // Avatar circle
                          Positioned(
                            left: 16,
                            bottom: 0,
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: context.colors.surfaceVariant,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: context.colors.background,
                                    width: 3),
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(36),
                                child: CachedNetworkImage(
                                  imageUrl: avatarUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) =>
                                      const SizedBox(),
                                  errorWidget: (_, __, ___) =>
                                      const Icon(Icons.person),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      if (isOwnProfile)
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () =>
                              context.router.push(const SettingsRoute()),
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: () {},
                        ),
                    ],
                  ),

                  // ── Profile info ─────────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name row + action buttons
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    // Display name + badge inline
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            profile.displayName,
                                            style: TextStyle(
                                              color: context
                                                  .colors.textPrimary,
                                              fontSize: 18,
                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                            overflow:
                                                TextOverflow.ellipsis,
                                          ),
                                        ),
                                        // ── Verified Admin badge ──
                                        if (profile.isAdmin) ...[
                                          const SizedBox(width: 4),
                                          _BadgeIcon(
                                            icon: Icons.star_rounded,
                                            color: const Color(0xFFF59E0B),
                                            tooltip: 'Verified Admin',
                                          ),
                                        ],
                                        // ── Trusted Vendor badge ──
                                        if (profile.isTrustedVendor &&
                                            !profile.isAdmin) ...[
                                          const SizedBox(width: 4),
                                          _BadgeIcon(
                                            icon: Icons.verified_rounded,
                                            color: const Color(0xFFF59E0B),
                                            tooltip: 'Trusted Vendor',
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '@${profile.username}',
                                      style: TextStyle(
                                        color: context.colors.textMuted,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (!isOwnProfile)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () => _startDM(
                                          context, ref, profile.customerId),
                                      icon: const Icon(
                                          Icons.chat_bubble_outline,
                                          size: 16),
                                      label: Text(t.messages.title),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            color:
                                                context.colors.primary),
                                        foregroundColor:
                                            context.colors.primary,
                                        minimumSize: const Size(0, 36),
                                        padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    profile.isFollowing
                                        ? OutlinedButton(
                                            onPressed: () async {
                                              await ref
                                                  .read(
                                                      socialRepositoryProvider)
                                                  .toggleFollow(
                                                      profile.customerId);
                                              ref.invalidate(
                                                  userProfileProvider(
                                                      widget.userId));
                                            },
                                            style:
                                                OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                  color: context
                                                      .colors.border),
                                              foregroundColor: context
                                                  .colors.textPrimary,
                                              minimumSize:
                                                  const Size(0, 36),
                                            ),
                                            child: Text(
                                                t.user_profile.following),
                                          )
                                        : FilledButton(
                                            onPressed: () async {
                                              await ref
                                                  .read(
                                                      socialRepositoryProvider)
                                                  .toggleFollow(
                                                      profile.customerId);
                                              ref.invalidate(
                                                  userProfileProvider(
                                                      widget.userId));
                                            },
                                            style: FilledButton.styleFrom(
                                              backgroundColor:
                                                  context.colors.primary,
                                              minimumSize:
                                                  const Size(0, 36),
                                            ),
                                            child:
                                                Text(t.vendor.follow),
                                          ),
                                  ],
                                ),
                            ],
                          ),

                          // Bio
                          if (profile.bio.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              profile.bio,
                              style: TextStyle(
                                  color: context.colors.textSecondary,
                                  fontSize: 13),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],

                          // Stats — followers & following are tappable.
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _statItem(
                                context,
                                value: profile.followerCount.toString(),
                                label: t.connections.followers,
                                onTap: () => context.router.push(FollowListRoute(
                                  userId: widget.userId,
                                  initialIndex: 0,
                                  isOwner: isOwnProfile,
                                )),
                              ),
                              const SizedBox(width: 20),
                              _statItem(
                                context,
                                value: profile.followingCount.toString(),
                                label: t.connections.following,
                                onTap: () => context.router.push(FollowListRoute(
                                  userId: widget.userId,
                                  initialIndex: 1,
                                  isOwner: isOwnProfile,
                                )),
                              ),
                              const SizedBox(width: 20),
                              _statItem(
                                context,
                                value: profile.recentPosts.length.toString(),
                                label: t.user_profile.posts_tab,
                                onTap: null,
                              ),
                            ],
                          ),

                          // ── Visit My Store card ────────────────────
                          if (hasVendorStore) ...[
                            const SizedBox(height: 16),
                            _VisitStoreCard(
                              storeName: profile.vendorStoreName ??
                                  profile.displayName,
                              slug: profile.vendorSlug!,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // ── Tab bar ──────────────────────────────────────
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        controller: _tabController,
                        indicatorColor: context.colors.primary,
                        labelColor: context.colors.primary,
                        unselectedLabelColor:
                            context.colors.textMuted,
                        tabs: [
                          Tab(text: t.user_profile.posts_tab),
                          Tab(text: t.user_profile.replies_tab),
                          Tab(text: t.user_profile.media_tab),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  // Posts
                  profile.recentPosts.isEmpty
                      ? Center(
                          child: Text(t.user_profile.no_posts_yet,
                              style: TextStyle(
                                  color: context.colors.textMuted)))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8),
                          itemCount: profile.recentPosts.length,
                          itemBuilder: (context, index) {
                            final post = profile.recentPosts[index];
                            return PostCard(
                              post: post,
                              onTap: () {
                                context.pushRoute(PostDetailRoute(
                                  community: post.communitySlug
                                          .isNotEmpty
                                      ? post.communitySlug
                                      : 'all',
                                  postId: post.id,
                                ));
                              },
                              onAuthorTap: (userId) =>
                                  context.pushRoute(
                                      UserProfileRoute(userId: userId)),
                              onVote: (direction) async {
                                try {
                                  await ref.read(socialRepositoryProvider).votePost(post.id, direction);
                                  ref.invalidate(userProfileProvider(widget.userId));
                                  ref.invalidate(feedPostsNotifierProvider);
                                } catch (_) {}
                              },
                            );
                          },
                        ),
                  // Replies
                  profile.recentComments.isEmpty
                      ? Center(
                          child: Text(t.user_profile.no_replies,
                              style: TextStyle(
                                  color: context.colors.textMuted)))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: profile.recentComments.length,
                          itemBuilder: (context, index) {
                            final comment = profile.recentComments[index];
                            final isAr = Localizations.localeOf(context).languageCode == 'ar';
                            final repliedToText = comment.post != null
                                ? (isAr ? 'رد على: ${comment.post!.title}' : 'Replied to: ${comment.post!.title}')
                                : (isAr ? 'رد على منشور' : 'Replied to a post');
                            
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: context.colors.border),
                              ),
                              color: context.colors.surface,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  if (comment.postId.isNotEmpty) {
                                    context.pushRoute(PostDetailRoute(
                                      community: (comment.post?.communitySlug.isNotEmpty ?? false)
                                          ? comment.post!.communitySlug
                                          : 'all',
                                      postId: comment.postId,
                                    ));
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.reply, size: 14, color: context.colors.textMuted),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              repliedToText,
                                              style: TextStyle(
                                                color: context.colors.textMuted,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              color: context.colors.surfaceVariant,
                                              child: CachedNetworkImage(
                                                imageUrl: _resolveAvatar(
                                                  comment.author?.avatarUrl ?? profile.avatarUrl,
                                                  comment.author?.avatarStyle ?? profile.avatarStyle,
                                                  comment.author?.avatarSeed ?? profile.avatarSeed,
                                                  comment.author?.customerId ?? profile.customerId,
                                                ),
                                                fit: BoxFit.cover,
                                                errorWidget: (_, __, ___) => const Icon(Icons.person, size: 12),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            comment.author?.displayName ?? profile.displayName,
                                            style: TextStyle(
                                              color: context.colors.textPrimary,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            _getTimeAgo(comment.createdAt),
                                            style: TextStyle(color: context.colors.textMuted, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        comment.content,
                                        style: TextStyle(
                                          color: context.colors.textSecondary,
                                          fontSize: 13,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                  // Media
                  profile.mediaPosts.isEmpty
                      ? Center(
                          child: Text(
                            Localizations.localeOf(context).languageCode == 'ar'
                                ? 'لا توجد وسائط بعد'
                                : 'No media yet',
                            style: TextStyle(color: context.colors.textMuted),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: profile.mediaPosts.length,
                          itemBuilder: (context, index) {
                            final post = profile.mediaPosts[index];
                            final imageUrl = post.mediaUrls.isNotEmpty ? post.mediaUrls.first : '';
                            return GestureDetector(
                              onTap: () {
                                context.pushRoute(PostDetailRoute(
                                  community: post.communitySlug.isNotEmpty ? post.communitySlug : 'all',
                                  postId: post.id,
                                ));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    if (imageUrl.isNotEmpty)
                                      CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) => Container(color: context.colors.surfaceVariant),
                                        errorWidget: (_, __, ___) => Container(
                                          color: context.colors.surfaceVariant,
                                          child: const Icon(Icons.broken_image, size: 24),
                                        ),
                                      )
                                    else
                                      Container(
                                        color: context.colors.surfaceVariant,
                                        child: Icon(
                                          post.contentType == 'VIDEO' ? Icons.play_circle_outline : Icons.image,
                                          color: context.colors.textMuted,
                                          size: 32,
                                        ),
                                      ),
                                    if (post.mediaUrls.length > 1)
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withValues(alpha: 0.6),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '+${post.mediaUrls.length - 1}',
                                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    if (post.contentType == 'VIDEO')
                                      Positioned(
                                        bottom: 4,
                                        left: 4,
                                        child: Icon(Icons.play_arrow, color: Colors.white.withValues(alpha: 0.8), size: 20),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Badge icon widget ─────────────────────────────────────────────────────────

class _BadgeIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;

  const _BadgeIcon({
    required this.icon,
    required this.color,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      triggerMode: TooltipTriggerMode.tap,
      child: Icon(icon, size: 18, color: color),
    );
  }
}

// ── Visit My Store card ───────────────────────────────────────────────────────

class _VisitStoreCard extends StatelessWidget {
  final String storeName;
  final String slug;

  const _VisitStoreCard({
    required this.storeName,
    required this.slug,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.push(VendorProfileRoute(slug: slug)),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: context.colors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.colors.primary.withValues(alpha: 0.18),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                    context.colors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.storefront_outlined,
                color: context.colors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VISIT MY STORE',
                    style: TextStyle(
                      color: context.colors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    storeName,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: context.colors.primary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sliver tab bar delegate ───────────────────────────────────────────────────

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return Container(
      color: context.colors.surface,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
