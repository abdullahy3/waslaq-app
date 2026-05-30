import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../router/app_router.dart';
import '../../../../../i18n/strings.g.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/post_card.dart';
import '../../../../../shared/widgets/post_card_skeleton.dart';
import '../../../providers/social_providers.dart';

@RoutePage()
class CommunityScreen extends ConsumerStatefulWidget {
  final String communitySlug;

  const CommunityScreen({
    super.key,
    @PathParam('community') required this.communitySlug,
  });

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  final _scrollController = ScrollController();
  String? _communityId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_communityId != null &&
        _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(feedPostsNotifierProvider(communityId: _communityId).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final communityState = ref.watch(communityProvider(widget.communitySlug));

    return Scaffold(
      body: communityState.when(
        data: (community) {
          // Store community ID for pagination
          if (_communityId != community.id) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() => _communityId = community.id);
            });
          }

          final postsState = ref.watch(feedPostsNotifierProvider(communityId: community.id));

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 140,
                pinned: true,
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    community.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  background: Container(
                    color: context.colors.primary,
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.only(left: 16, bottom: 48, right: 16),
                    child: Text(
                      t.community.members_count(count: community.memberCount.toString()),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: context.colors.surface,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (community.description != null && community.description!.isNotEmpty) ...[
                        Text(
                          community.description!,
                          style: TextStyle(color: context.colors.textPrimary, fontSize: 14),
                        ),
                        SizedBox(height: 16),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            t.community.members_label(count: community.memberCount.toString()),
                            style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
                          ),
                          if (community.isMember)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: context.colors.border),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(t.community.joined_checkmark, style: TextStyle(color: context.colors.textSecondary)),
                            )
                          else
                            FilledButton(
                              onPressed: () async {
                                await ref.read(socialRepositoryProvider).joinCommunity(widget.communitySlug);
                                ref.invalidate(communityProvider(widget.communitySlug));
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: context.colors.primary,
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              child: Text(t.community.join),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(top: 8)),
              postsState.when(
                data: (posts) {
                  if (posts.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(
                          child: Text(t.community.no_posts, style: TextStyle(color: context.colors.textMuted)),
                        ),
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == posts.length) {
                          final isLoading = ref.watch(feedPostsNotifierProvider(communityId: community.id)).isLoading;
                          return isLoading ? Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator(color: context.colors.primary)),
                          ) : const SizedBox(height: 24);
                        }
                        final post = posts[index];
                        return PostCard(
                          post: post,
                          onTap: () => context.pushRoute(PostDetailRoute(community: post.communitySlug.isNotEmpty ? post.communitySlug : 'all', postId: post.id)),
                        );
                      },
                      childCount: posts.length + 1,
                    ),
                  );
                },
                loading: () => SliverToBoxAdapter(
                  child: Column(
                    children: List.generate(4, (index) => const PostCardSkeleton()),
                  ),
                ),
                error: (err, stack) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Text(t.community.error_loading_posts(error: err.toString()), style: TextStyle(color: context.colors.error)),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => Center(child: CircularProgressIndicator(color: context.colors.primary)),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: context.colors.error, size: 48),
              SizedBox(height: 16),
              Text(err.toString(), style: TextStyle(color: context.colors.textMuted)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(communityProvider(widget.communitySlug)),
                child: Text(t.common.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
