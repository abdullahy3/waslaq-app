import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> with SingleTickerProviderStateMixin {
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
  Future<void> _startDM(BuildContext context, WidgetRef ref, String targetCustomerId) async {
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

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 1. Await dynamic connection initialization to Stream Chat
      await ref.read(streamChatConnectionProvider.future);

      final client = ref.read(streamChatClientProvider);
      final myId = client.state.currentUser?.id;
      if (myId == null) {
        throw Exception('Not connected to chat server');
      }

      final theirId = 'customer_$targetCustomerId';

      // Sync the target user into Stream so they have a real name
      try {
        await SocialClient.instance.post(
          '/store/social/users/$targetCustomerId/sync-chat',
        );
      } catch (_) {}

      // Deterministic channel ID — same pair always gets same channel
      final members = [myId, theirId]..sort();
      final channelId = members.join('__');

      final channel = client.channel(
        'messaging',
        id: channelId,
        extraData: {'members': members},
      );
      await channel.watch();

      if (context.mounted) {
        Navigator.of(context).pop(); // dismiss loading
        context.router.push(ChatRoute(cid: channel.cid!));
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // dismiss loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.messages.could_not_open_chat(error: e.toString()))),
        );
      }
    }
  }

  String _getAvatarUrl(String? styleStr, String? seedStr) {
    final style = (styleStr != null && styleStr.isNotEmpty) ? styleStr : 'bottts';
    final seed = (seedStr != null && seedStr.isNotEmpty) ? seedStr : 'default';
    return 'https://api.dicebear.com/7.x/$style/svg?seed=$seed';
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
        loading: () => Center(child: CircularProgressIndicator(color: context.colors.primary)),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: context.colors.error),
              SizedBox(height: 16),
              Text(t.user_profile.failed_load, style: TextStyle(color: context.colors.textPrimary)),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.invalidate(userProfileProvider(widget.userId)),
                child: Text(t.common.retry),
              ),
            ],
          ),
        ),
        data: (profile) {
          final hasStore = profile.recentPosts.any((p) => p.contentType == 'PRODUCT');

          return DefaultTabController(
            length: 3,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 160,
                    pinned: true,
                    backgroundColor: context.colors.surface,
                    iconTheme: IconThemeData(color: Colors.white),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            height: 120, // top half
                            child: Container(color: context.colors.primary),
                          ),
                          Positioned(
                            left: 16,
                            bottom: 0,
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: context.colors.surfaceVariant,
                                shape: BoxShape.circle,
                                border: Border.all(color: context.colors.background, width: 3),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(36),
                                child: SvgPicture.network(
                                  _getAvatarUrl(profile.avatarStyle, profile.avatarSeed),
                                  placeholderBuilder: (_) => const SizedBox(),
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
                          onPressed: () => context.router.push(const SettingsRoute()),
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: () {},
                        ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profile.displayName,
                                      style: TextStyle(
                                        color: context.colors.textPrimary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
                                    // Message button
                                    OutlinedButton.icon(
                                      onPressed: () => _startDM(context, ref, profile.customerId),
                                      icon: const Icon(Icons.chat_bubble_outline, size: 16),
                                      label: Text(t.messages.title),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: context.colors.primary),
                                        foregroundColor: context.colors.primary,
                                        minimumSize: const Size(0, 36),
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Follow / Unfollow button
                                    profile.isFollowing
                                        ? OutlinedButton(
                                            onPressed: () async {
                                              await ref.read(socialRepositoryProvider).toggleFollow(profile.customerId);
                                              ref.invalidate(userProfileProvider(widget.userId));
                                            },
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(color: context.colors.border),
                                              foregroundColor: context.colors.textPrimary,
                                              minimumSize: const Size(0, 36),
                                            ),
                                            child: Text(t.user_profile.following),
                                          )
                                        : FilledButton(
                                            onPressed: () async {
                                              await ref.read(socialRepositoryProvider).toggleFollow(profile.customerId);
                                              ref.invalidate(userProfileProvider(widget.userId));
                                            },
                                            style: FilledButton.styleFrom(
                                              backgroundColor: context.colors.primary,
                                              minimumSize: const Size(0, 36),
                                            ),
                                            child: Text(t.vendor.follow),
                                          ),
                                  ],
                                ),
                            ],
                          ),
                          if (profile.bio.isNotEmpty) ...[
                            SizedBox(height: 12),
                            Text(
                              profile.bio,
                              style: TextStyle(color: context.colors.textSecondary, fontSize: 13),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          SizedBox(height: 12),
                          Text(
                            t.user_profile.stats(followers: profile.followerCount.toString(), posts: profile.recentPosts.length.toString()),
                            style: TextStyle(color: context.colors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          if (hasStore) ...[
                            SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  context.pushRoute(VendorProfileRoute(slug: profile.username));
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: context.colors.primary),
                                  foregroundColor: context.colors.primary,
                                ),
                                child: Text(t.user_profile.view_store),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        controller: _tabController,
                        indicatorColor: context.colors.primary,
                        labelColor: context.colors.primary,
                        unselectedLabelColor: context.colors.textMuted,
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
                      ? Center(child: Text(t.user_profile.no_posts_yet, style: TextStyle(color: context.colors.textMuted)))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: profile.recentPosts.length,
                          itemBuilder: (context, index) {
                            final post = profile.recentPosts[index];
                            return PostCard(
                              post: post,
                              onTap: () {
                                context.pushRoute(PostDetailRoute(
                                  community: post.communitySlug.isNotEmpty ? post.communitySlug : 'all',
                                  postId: post.id,
                                ));
                              },
                              onAuthorTap: (userId) => context.pushRoute(UserProfileRoute(userId: userId)),
                            );
                          },
                        ),
                  // Replies
                  Center(child: Text(t.user_profile.coming_soon, style: TextStyle(color: context.colors.textMuted))),
                  // Media
                  Center(child: Text(t.user_profile.coming_soon, style: TextStyle(color: context.colors.textMuted))),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: context.colors.surface,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
