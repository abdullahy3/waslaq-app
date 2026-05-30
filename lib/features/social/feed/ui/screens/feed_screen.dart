import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../router/app_router.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../i18n/strings.g.dart';
import '../../../../../shared/widgets/post_card.dart';
import '../../../../../shared/widgets/post_card_skeleton.dart';
import '../../../providers/social_providers.dart';
import '../../../data/models/social_models.dart';
import '../../../../../core/auth/auth_notifier.dart';
import '../../../../../core/api/social_client.dart';

@RoutePage()
class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});
  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final _scrollController = ScrollController();
  String _sort = 'hot';
  bool _isLoadingMore = false;
  List<Map<String, dynamic>> _trendingCommunities = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadTrendingCommunities();
  }

  @override
  void dispose() { _scrollController.dispose(); super.dispose(); }

  void _onScroll() {
    if (_isLoadingMore) return;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      _isLoadingMore = true;
      ref.read(feedPostsNotifierProvider(sort: _sort).notifier).loadMore().whenComplete(() {
        if (mounted) setState(() => _isLoadingMore = false);
      });
    }
  }

  Future<void> _loadTrendingCommunities() async {
    try {
      final res = await SocialClient.instance.get('/store/social/communities');
      final list = (res.data['communities'] as List<dynamic>? ?? [])
          .map((c) => c as Map<String, dynamic>).take(8).toList();
      if (mounted) setState(() => _trendingCommunities = list);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final postsState = ref.watch(feedPostsNotifierProvider(sort: _sort));
    final authState = ref.watch(authNotifierProvider);
    final isLoggedIn = authState.maybeWhen(authenticated: (_, __, ___, ____, _____) => true, orElse: () => false);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: RefreshIndicator(
        color: context.colors.primary,
        onRefresh: () async {
          ref.invalidate(feedPostsNotifierProvider(sort: _sort));
          await _loadTrendingCommunities();
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // ─── APP BAR ─────────────────────────────────────
            SliverAppBar(
              floating: true, snap: true,
              backgroundColor: context.colors.surface, surfaceTintColor: context.colors.surface,
              elevation: 0,
              title: Row(children: [
                Text(t.community.community, style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.w800, fontSize: 20)),
                const Spacer(),
                IconButton(icon: Icon(Icons.search, color: context.colors.textSecondary),
                    onPressed: () => context.router.push(const SearchRoute())),
                IconButton(icon: Icon(Icons.explore_outlined, color: context.colors.textSecondary),
                    onPressed: () => context.router.push(const CommunityExploreRoute())),
              ]),
              automaticallyImplyLeading: false,
            ),

            // ─── CREATE POST BOX ─────────────────────────────
            if (isLoggedIn)
              SliverToBoxAdapter(child: Container(
                margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.colors.surface, borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.colors.border),
                ),
                child: GestureDetector(
                  onTap: () => context.router.push(CreatePostRoute()),
                  child: Row(children: [
                    authState.maybeWhen(
                      authenticated: (_, __, ___, avatarUrl, ____) => CircleAvatar(
                        radius: 18, backgroundColor: context.colors.primary,
                        backgroundImage: avatarUrl != null ? CachedNetworkImageProvider(avatarUrl) : null,
                        child: avatarUrl == null ? Icon(Icons.person, color: Colors.white, size: 16) : null,
                      ),
                      orElse: () => CircleAvatar(radius: 18, backgroundColor: context.colors.surfaceVariant,
                          child: Icon(Icons.person, color: context.colors.textMuted, size: 16)),
                    ),
                    SizedBox(width: 10),
                    Expanded(child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: context.colors.surfaceVariant, borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: context.colors.border),
                      ),
                      child: Text(t.community.whats_on_your_mind,
                          style: TextStyle(color: context.colors.textMuted, fontSize: 13)),
                    )),
                    SizedBox(width: 8),
                    Icon(Icons.image_outlined, color: context.colors.textMuted, size: 22),
                  ]),
                ),
              )),

            // ─── TRENDING COMMUNITIES ────────────────────────
            if (_trendingCommunities.isNotEmpty)
              SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                  child: Row(children: [
                    Text(t.community.trending_communities, style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => context.router.push(const CommunityExploreRoute()),
                      child: Text(t.common.view_all, style: TextStyle(color: context.colors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ])),
                SizedBox(height: 76, child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _trendingCommunities.length,
                  itemBuilder: (ctx, i) {
                    final c = _trendingCommunities[i];
                    final name = c['name'] as String? ?? '';
                    final slug = c['slug'] as String? ?? '';
                    final icon = c['iconUrl'] as String?;
                    final members = c['memberCount'] as int? ?? 0;
                    final colors = [Colors.red, Colors.blue, Colors.green, Colors.amber, Colors.purple, Colors.pink, Colors.indigo, Colors.teal];

                    return GestureDetector(
                      onTap: () => context.router.push(CommunityRoute(communitySlug: slug)),
                      child: Container(
                        width: 130, margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: context.colors.surface, borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: context.colors.border),
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                          Row(children: [
                            Container(width: 28, height: 28,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: colors[i % colors.length]),
                              child: icon != null
                                  ? ClipOval(child: CachedNetworkImage(imageUrl: icon, width: 28, height: 28, fit: BoxFit.cover,
                                      errorWidget: (_, __, ___) => _communityInitial(name)))
                                  : _communityInitial(name)),
                            SizedBox(width: 6),
                            Expanded(child: Text('r/$slug', maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.w600, fontSize: 12))),
                          ]),
                          SizedBox(height: 6),
                          Text(t.community.members_count(count: members.toString()), style: TextStyle(color: context.colors.textMuted, fontSize: 10)),
                        ]),
                      ),
                    );
                  },
                )),
              ])),

            // ─── SORT PILLS ──────────────────────────────────
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
              child: Row(children: [
                _SortPill(label: '✨ ${t.community.hot}', active: _sort == 'hot', onTap: () => setState(() => _sort = 'hot')),
                SizedBox(width: 6),
                _SortPill(label: '🌟 ${t.community.new_label}', active: _sort == 'new', onTap: () => setState(() => _sort = 'new')),
                SizedBox(width: 6),
                _SortPill(label: '📈 ${t.community.top}', active: _sort == 'top', onTap: () => setState(() => _sort = 'top')),
              ]),
            )),

            // ─── POST FEED ──────────────────────────────────
            postsState.when(
              data: (posts) {
                if (posts.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.forum_outlined, size: 56, color: context.colors.border),
                      SizedBox(height: 12),
                      Text(t.community.no_posts, style: TextStyle(color: context.colors.textMuted, fontSize: 15)),
                      SizedBox(height: 4),
                      Text(t.community.no_posts_subtitle, style: TextStyle(color: context.colors.textMuted, fontSize: 12)),
                    ])),
                  );
                }
                return SliverList(delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    if (i == posts.length) {
                      return Padding(padding: const EdgeInsets.all(16),
                        child: Center(child: _isLoadingMore
                            ? CircularProgressIndicator(color: context.colors.primary, strokeWidth: 2)
                            : SizedBox(height: 24)));
                    }
                    final post = posts[i];
                    return PostCard(
                      post: post,
                      onTap: () => context.pushRoute(PostDetailRoute(
                          community: post.communitySlug.isNotEmpty ? post.communitySlug : 'all', postId: post.id)),
                      onAuthorTap: (userId) => context.pushRoute(UserProfileRoute(userId: userId)),
                    );
                  },
                  childCount: posts.length + 1,
                ));
              },
              loading: () => SliverList(delegate: SliverChildBuilderDelegate(
                (ctx, i) => const PostCardSkeleton(),
                childCount: 6,
              )),
              error: (err, _) => SliverFillRemaining(
                child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.error_outline, color: context.colors.error, size: 48),
                  SizedBox(height: 12),
                  Text(err.toString(), style: TextStyle(color: context.colors.textMuted, fontSize: 13)),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(feedPostsNotifierProvider(sort: _sort)),
                    child: Text(t.common.retry)),
                ])),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isLoggedIn ? FloatingActionButton(
        onPressed: () => context.router.push(CreatePostRoute()),
        backgroundColor: context.colors.primary, elevation: 4,
        child: const Icon(Icons.edit, color: Colors.white),
      ) : null,
    );
  }

  Widget _communityInitial(String name) => Center(
    child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)));
}

class _SortPill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _SortPill({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? context.colors.primary : context.colors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: TextStyle(
          color: active ? Colors.white : context.colors.textSecondary,
          fontWeight: FontWeight.w700, fontSize: 12)),
      ),
    );
  }
}
