// lib/features/home/ui/screens/explore_screen.dart

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/api/medusa_client.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/auth/auth_notifier.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../router/app_router.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/post_card.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../product/providers/product_provider.dart';
import '../../../product/data/models/category_model.dart';
import '../../../social/data/models/social_models.dart';
import '../../../social/providers/social_providers.dart';

// ─── Categories provider ──────────────────────────────────────────────────────
final _exploreCategoriesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final res = await MedusaClient.instance.get(
    '/store/product-categories',
    queryParameters: {'limit': 100, 'include_descendants_tree': true},
  );
  final cats = res.data['product_categories'] as List<dynamic>? ?? [];
  return cats
      .map((c) => c as Map<String, dynamic>)
      .where((c) => c['parent_category_id'] == null)
      .toList();
});

// ─── Stores provider ──────────────────────────────────────────────────────────
final _exploreStoresProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final res = await MedusaClient.instance.get('/store/vendors');
  final vendors = res.data['vendors'] as List<dynamic>? ?? [];
  return vendors.map((v) => v as Map<String, dynamic>).toList();
});

// ═════════════════════════════════════════════════════════════════════════════
// ExploreScreen
// ═════════════════════════════════════════════════════════════════════════════

@RoutePage()
class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Lazy-init tracking for IndexedStack tabs
  int _currentTab = 0;
  final Set<int> _initializedTabs = {0};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.value = 1.0; // Start fully visible
  }

  void _onTabChanged() {
    final idx = _tabController.index;
    if (idx == _currentTab) return;
    setState(() {
      _currentTab = idx;
      _initializedTabs.add(idx);
    });
    // Reset top bar on every tab switch
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Called by each tab's scroll listener with the user scroll direction.
  void _onUserScroll(ScrollDirection direction) {
    if (direction == ScrollDirection.reverse) {
      // User is scrolling down — hide header
      if (_animationController.value > 0 && !_animationController.isAnimating) {
        _animationController.reverse();
      }
    } else if (direction == ScrollDirection.forward) {
      // User is scrolling up — show header
      if (_animationController.value < 1 && !_animationController.isAnimating) {
        _animationController.forward();
      }
    }
  }

  Widget _buildTitleSearch(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.nav.explore,
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => context.router.push(const SearchRoute()),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: context.colors.border),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Icon(Icons.search, color: context.colors.textMuted, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    t.home.search_placeholder,
                    style: TextStyle(
                        color: context.colors.textMuted, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surfaceVariant,
      body: SafeArea(
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            _onUserScroll(notification.direction);
            return false;
          },
          child: Column(
            children: [
              // ─── Header (title+search static, tab chips sticky) ──
              Container(
                color: context.colors.background,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizeTransition(
                      sizeFactor: _animation,
                      alignment: Alignment.topCenter,
                      child: _buildTitleSearch(context),
                    ),
                    // Tab chips — always visible, never hides
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: context.colors.border, width: 0.5),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: context.colors.primary,
                      unselectedLabelColor: context.colors.textMuted,
                      indicatorColor: context.colors.primary,
                      indicatorWeight: 2.5,
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 13),
                      unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 13),
                      tabs: [
                        Tab(text: t.explore.products),
                        Tab(text: t.explore.communities),
                        Tab(text: t.explore.stores),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ─── Tab content — IndexedStack keeps tabs alive ───────
            Expanded(
              child: IndexedStack(
                index: _currentTab,
                children: [
                  _ProductsTab(
                    initialized: _initializedTabs.contains(0),
                  ),
                  _CommunitiesTab(
                    initialized: _initializedTabs.contains(1),
                  ),
                  _StoresTab(
                    initialized: _initializedTabs.contains(2),
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// PRODUCTS TAB — category grid + popular searches (unchanged behavior)
// ═════════════════════════════════════════════════════════════════════════════

class _ProductsTab extends ConsumerWidget {
  final bool initialized;

  const _ProductsTab({required this.initialized});

  String _catName(Map<String, dynamic> cat, String lang) {
    final meta = cat['metadata'] as Map<String, dynamic>?;
    if (lang == 'ar') {
      return meta?['name_ar'] as String? ?? cat['name'] as String? ?? '';
    }
    return cat['name'] as String? ?? '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!initialized) return const SizedBox.shrink();

    final catsAsync = ref.watch(_exploreCategoriesProvider);
    final lang = ref.watch(localeProvider).languageCode;

    return catsAsync.when(
        loading: () => CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, left: 4, right: 4),
                    child: Shimmer.fromColors(
                      baseColor: context.colors.surfaceVariant,
                      highlightColor: context.colors.border,
                      child: Container(
                        width: 120,
                        height: 16,
                        color: context.colors.surfaceVariant,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: context.colors.background,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.colors.border),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        for (var r = 0; r < 3; r++) ...[
                          if (r > 0) const SizedBox(height: 12),
                          Row(
                            children: [
                              for (var c = 0; c < 3; c++) ...[
                                if (c > 0) const SizedBox(width: 12),
                                Expanded(
                                  child: Shimmer.fromColors(
                                    baseColor: context.colors.surfaceVariant,
                                    highlightColor: context.colors.border,
                                    child: AspectRatio(
                                      aspectRatio: 0.82,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: context.colors.surfaceVariant,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
        error: (_, __) => Center(
          child: Text(t.common.failed_load_categories,
              style: TextStyle(color: context.colors.textMuted)),
        ),
        data: (cats) {
          final popularSearches = [
            'أيفون',
            'لاب توب',
            'كيبورد',
            'سماعات',
            'ساعة ذكية',
            'iPhone',
            'Keyboard',
            'Headphones',
          ];

          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, left: 4, right: 4),
                    child: Text(
                      t.explore.browse_categories,
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _buildCategoryItem(context, cats[index], lang);
                    },
                    childCount: cats.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.82,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 4, right: 4),
                        child: Text(
                          t.explore.popular_searches,
                          style: TextStyle(
                            color: context.colors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: context.colors.background,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: context.colors.border),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: popularSearches.map((term) {
                            return GestureDetector(
                              onTap: () => context.router.push(const SearchRoute()),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                decoration: BoxDecoration(
                                  color: context.colors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: context.colors.border),
                                ),
                                child: Text(
                                  term,
                                  style: TextStyle(
                                    color: context.colors.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      );
  }

  Widget _buildCategoryItem(BuildContext context, Map<String, dynamic> cat, String lang) {
    final name = _catName(cat, lang);
    final meta = cat['metadata'] as Map<String, dynamic>?;
    final imageUrl = meta?['image'] as String?;

    return GestureDetector(
      onTap: () {
        final id = cat['id'] as String? ?? '';
        context.router.push(StoreRoute(categoryId: id));
      },
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: context.colors.surfaceVariant,
                border: Border.all(color: context.colors.border.withValues(alpha: 0.5)),
              ),
              clipBehavior: Clip.antiAlias,
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorWidget: (_, __, ___) => _catInitial(context, name),
                    )
                  : _catInitial(context, name),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _catInitial(BuildContext context, String name) => Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: context.colors.primary.withValues(alpha: 0.25),
          ),
        ),
      );
}

// ═════════════════════════════════════════════════════════════════════════════
// COMMUNITIES TAB — post creator + communities horizontal strip + sorting filters + live post feed
// ═════════════════════════════════════════════════════════════════════════════

class _CommunitiesTab extends ConsumerStatefulWidget {
  final bool initialized;

  const _CommunitiesTab({required this.initialized});

  @override
  ConsumerState<_CommunitiesTab> createState() => _CommunitiesTabState();
}

class _CommunitiesTabState extends ConsumerState<_CommunitiesTab> {
  String _sort = 'hot';
  String? _filterCommunityId;
  String? _filterCommunityName;

  void _changeSort(String s) {
    setState(() {
      _sort = s;
      // Clear community filter when switching sort modes
      if (s != 'community') {
        _filterCommunityId = null;
        _filterCommunityName = null;
      }
    });
  }

  void _setCommunityFilter(String? communityId, String? communityName) {
    setState(() {
      _filterCommunityId = communityId;
      _filterCommunityName = communityName;
      if (communityId != null) {
        _sort = 'community';
      } else {
        _sort = 'hot';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.initialized) return const SizedBox.shrink();

    final communitiesAsync = ref.watch(communitiesProvider);
    // Use community filter when a community is selected
    final effectiveCommunityId = _sort == 'community' ? _filterCommunityId : null;
    final effectiveSort = _sort == 'community' ? 'hot' : _sort;
    final postsAsync = ref.watch(
      feedPostsNotifierProvider(
          communityId: effectiveCommunityId, sort: effectiveSort),
    );

    return RefreshIndicator(
      color: context.colors.primary,
      onRefresh: () => ref
          .read(feedPostsNotifierProvider(
                  communityId: effectiveCommunityId, sort: effectiveSort)
              .notifier)
          .refresh(),
      child: CustomScrollView(
        slivers: [
          // ─── Post creator box ──────────────────────────────
          const SliverToBoxAdapter(
            child: _PostCreatorBox(communitySlug: null),
          ),

          // ─── Community horizontal list for opening ─────────
          SliverToBoxAdapter(
            child: communitiesAsync.maybeWhen(
              data: (communities) => _CommunityHorizontalList(
                communities: communities,
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 10)),

          // ─── Feed sort & community selector row ────────────
          SliverToBoxAdapter(
            child: communitiesAsync.maybeWhen(
              data: (communities) => _FeedSortSelector(
                currentSort: _sort,
                onSortChanged: _changeSort,
                communities: communities,
                filterCommunityName: _filterCommunityName,
                onCommunityFilterSelected: _setCommunityFilter,
              ),
              orElse: () => _FeedSortSelector(
                currentSort: _sort,
                onSortChanged: _changeSort,
                communities: const [],
                onCommunityFilterSelected: _setCommunityFilter,
              ),
            ),
          ),

            const SliverToBoxAdapter(child: SizedBox(height: 10)),

            // ─── Active community filter indicator ────────────
            if (_sort == 'community' && _filterCommunityName != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: context.colors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: context.colors.primary.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.filter_list, color: context.colors.primary, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'r/$_filterCommunityName',
                            style: TextStyle(
                              color: context.colors.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _setCommunityFilter(null, null),
                          child: Icon(Icons.close, color: context.colors.primary, size: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // ─── Post feed ─────────────────────────────────────
            postsAsync.when(
              loading: () => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, __) => _PostSkeletonItem(context: context),
                  childCount: 4,
                ),
              ),
              error: (_, __) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      t.community.error_loading,
                      style:
                          TextStyle(color: context.colors.textMuted),
                    ),
                  ),
                ),
              ),
              data: (posts) {
                if (posts.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.article_outlined,
                                size: 48,
                                color: context.colors.textMuted),
                            const SizedBox(height: 12),
                            Text(
                              t.community.no_posts,
                              style: TextStyle(
                                  color: context.colors.textMuted,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      // Load more trigger — fires when second-to-last item scrolls into view
                      if (i == posts.length) {
                        return _LoadMoreTrigger(
                          onLoad: () => ref
                              .read(feedPostsNotifierProvider(
                                      communityId: effectiveCommunityId,
                                      sort: effectiveSort)
                                  .notifier)
                              .loadMore(),
                        );
                      }
                      final post = posts[i];
                      return PostCard(
                        post: post,
                        onTap: () => context.router.push(
                          PostDetailRoute(
                            community:
                                post.communitySlug.isNotEmpty
                                    ? post.communitySlug
                                    : 'all',
                            postId: post.id,
                          ),
                        ),
                        onAuthorTap: (userId) => context.router
                            .push(UserProfileRoute(userId: userId)),
                        onCommunityTap: (slug) => context.router.push(
                            CommunityRoute(communitySlug: slug)),
                        onVote: (direction) => ref
                            .read(feedPostsNotifierProvider(
                                    communityId: effectiveCommunityId,
                                    sort: effectiveSort)
                                .notifier)
                            .votePost(post.id, direction),
                      );
                    },
                    childCount: posts.length + 1,
                  ),
                );
              },
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      );
  }
}

// ─── Post skeleton placeholder ────────────────────────────────────────────────

class _PostSkeletonItem extends StatelessWidget {
  final BuildContext context;
  const _PostSkeletonItem({required this.context});

  @override
  Widget build(BuildContext _) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Shimmer.fromColors(
        baseColor: context.colors.surfaceVariant,
        highlightColor: context.colors.border,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: context.colors.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

// ─── Load-more trigger (fires onLoad when scrolled into view) ─────────────────

class _LoadMoreTrigger extends StatefulWidget {
  final VoidCallback onLoad;
  const _LoadMoreTrigger({super.key, required this.onLoad});

  @override
  State<_LoadMoreTrigger> createState() => _LoadMoreTriggerState();
}

class _LoadMoreTriggerState extends State<_LoadMoreTrigger> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onLoad();
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

// ─── Post creator box ─────────────────────────────────────────────────────────

class _PostCreatorBox extends ConsumerWidget {
  final String? communitySlug;
  const _PostCreatorBox({this.communitySlug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final avatarUrl = authState.maybeWhen(
      authenticated: (_, __, ___, avatarUrl, ____) => avatarUrl,
      orElse: () => null,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
      child: GestureDetector(
        onTap: () => context.router
            .push(CreatePostRoute(communitySlug: communitySlug)),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: context.colors.border.withValues(alpha: 0.6)),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.surfaceVariant,
                  border: Border.all(color: context.colors.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: avatarUrl != null
                    ? CachedNetworkImage(
                        imageUrl: avatarUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(color: context.colors.surfaceVariant),
                        errorWidget: (_, __, ___) => Icon(Icons.person_outline, color: context.colors.textMuted, size: 20),
                      )
                    : Icon(Icons.person_outline, color: context.colors.textMuted, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      t.community.whats_on_your_mind,
                      style: TextStyle(
                          color: context.colors.textMuted, fontSize: 14),
                    ),
                    if (communitySlug != null)
                      Text(
                        'r/$communitySlug',
                        style: TextStyle(
                          color: context.colors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(Icons.add_circle_outline,
                  color: context.colors.primary, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Community horizontal list for opening ───────────────────────────────────

class _CommunityHorizontalList extends StatelessWidget {
  final List<CommunityModel> communities;

  const _CommunityHorizontalList({required this.communities});

  @override
  Widget build(BuildContext context) {
    // Exclude general and questions from the horizontal scroll view
    final filtered = communities
        .where((c) => c.slug != 'general' && c.slug != 'product-questions')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المجتمعات',
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () => context.router.push(const CommunityExploreRoute()),
                child: Row(
                  children: [
                    Text(
                      'عرض الكل',
                      style: TextStyle(
                        color: context.colors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: context.colors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 84,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: filtered.length,
            itemBuilder: (ctx, i) {
              final community = filtered[i];
              final name = community.name;
              final iconUrl = community.iconUrl;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: GestureDetector(
                  onTap: () => context.router.push(CommunityRoute(communitySlug: community.slug)),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.colors.border),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.colors.surfaceVariant,
                            border: Border.all(color: context.colors.border),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: iconUrl != null && iconUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: iconUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Container(color: context.colors.surfaceVariant),
                                  errorWidget: (_, __, ___) => _initialPlaceholder(context, name),
                                )
                              : _initialPlaceholder(context, name),
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            'r/${community.slug}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: context.colors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _initialPlaceholder(BuildContext context, String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'r',
        style: TextStyle(
          color: context.colors.primary,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Feed community filter removed (integrated into sort selector)

// ─── Feed sort selector (Hot / New / Top / Communities dropdown) ─────────────

class _FeedSortSelector extends StatelessWidget {
  final String currentSort;
  final void Function(String) onSortChanged;
  final List<CommunityModel> communities;
  final String? filterCommunityName;
  final void Function(String? communityId, String? communityName) onCommunityFilterSelected;

  const _FeedSortSelector({
    required this.currentSort,
    required this.onSortChanged,
    required this.communities,
    this.filterCommunityName,
    required this.onCommunityFilterSelected,
  });

  void _showCommunityFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetCtx) {
        return _CommunityFilterPopup(
          communities: communities,
          onCommunitySelected: (communityId, communitySlug) {
            Navigator.pop(sheetCtx);
            onCommunityFilterSelected(communityId, communitySlug);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _SortButton(
              icon: Icons.whatshot_outlined,
              label: 'شائع', // Hot
              selected: currentSort == 'hot',
              onTap: () => onSortChanged('hot'),
            ),
            const SizedBox(width: 8),
            _SortButton(
              icon: Icons.new_releases_outlined,
              label: 'جديد', // New
              selected: currentSort == 'new',
              onTap: () => onSortChanged('new'),
            ),
            const SizedBox(width: 8),
            _SortButton(
              icon: Icons.trending_up_outlined,
              label: 'الأعلى', // Top
              selected: currentSort == 'top',
              onTap: () => onSortChanged('top'),
            ),
            const SizedBox(width: 8),
            _SortButton(
              icon: Icons.group_outlined,
              label: t.explore.communities,
              selected: currentSort == 'community',
              onTap: () => _showCommunityFilterSheet(context),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Community Filter Popup for Explorer page ────────────────────────────────

class _CommunityFilterPopup extends StatefulWidget {
  final List<CommunityModel> communities;
  final void Function(String communityId, String communitySlug) onCommunitySelected;

  const _CommunityFilterPopup({
    required this.communities,
    required this.onCommunitySelected,
  });

  @override
  State<_CommunityFilterPopup> createState() => _CommunityFilterPopupState();
}

class _CommunityFilterPopupState extends State<_CommunityFilterPopup> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CommunityModel> get _filteredCommunities {
    // Show joined + public communities
    final selectable = widget.communities
        .where((c) => c.isMember || !c.isPrivate)
        .toList();

    if (_searchQuery.isEmpty) return selectable;
    return selectable.where((c) {
      return c.name.toLowerCase().contains(_searchQuery) ||
          c.slug.toLowerCase().contains(_searchQuery) ||
          c.title.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredCommunities;
    final lang = Translations.of(context).$meta.locale.languageCode;
    final title = lang == 'ar' ? 'اختر مجتمعاً لتصفية المنشورات' : 'Select a community to filter posts';
    final searchHint = lang == 'ar' ? 'ابحث عن مجتمعات...' : 'Search communities...';
    final emptyText = lang == 'ar' ? 'لم يتم العثور على مجتمعات' : 'No communities found';
    final exploreBtnText = lang == 'ar' ? 'استكشف المجتمعات' : 'Explore Communities';

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.filter_list, color: context.colors.primary, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: context.colors.textMuted, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: context.colors.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: searchHint,
                hintStyle: TextStyle(color: context.colors.textMuted, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: context.colors.textMuted, size: 20),
                filled: true,
                fillColor: context.colors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.colors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.colors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.colors.primary, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Community list
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 48, color: context.colors.textMuted),
                        const SizedBox(height: 12),
                        Text(
                          emptyText,
                          style: TextStyle(color: context.colors.textMuted, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final c = filtered[index];
                      // Private communities can't be selected if not a member
                      final canSelect = !c.isPrivate || c.isMember;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: context.colors.primary.withValues(alpha: 0.15),
                            backgroundImage: c.iconUrl != null && c.iconUrl!.isNotEmpty
                                ? NetworkImage(c.iconUrl!)
                                : null,
                            child: c.iconUrl == null || c.iconUrl!.isEmpty
                                ? Text(
                                    c.name.isNotEmpty ? c.name[0].toUpperCase() : 'r',
                                    style: TextStyle(
                                      color: context.colors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  )
                                : null,
                          ),
                          title: Text(
                            c.title,
                            style: TextStyle(
                              color: canSelect ? context.colors.textPrimary : context.colors.textMuted,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                'r/${c.slug}',
                                style: TextStyle(color: context.colors.textMuted, fontSize: 11),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${c.memberCount} ${lang == 'ar' ? 'عضو' : 'members'}',
                                style: TextStyle(color: context.colors.textMuted, fontSize: 11),
                              ),
                            ],
                          ),
                          trailing: canSelect
                              ? (c.isMember
                                  ? Icon(Icons.check_circle_outline, color: context.colors.success, size: 20)
                                  : Icon(Icons.public, color: context.colors.textMuted, size: 20))
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.lock_outlined, color: context.colors.textMuted, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      lang == 'ar' ? 'خاص' : 'Private',
                                      style: TextStyle(color: context.colors.textMuted, fontSize: 11),
                                    ),
                                  ],
                                ),
                          onTap: () {
                            if (!canSelect) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(lang == 'ar'
                                      ? 'انضم لهذا المجتمع الخاص لاختياره'
                                      : 'Join this private community to select it'),
                                  backgroundColor: context.colors.error,
                                ),
                              );
                              return;
                            }
                            widget.onCommunitySelected(c.id, c.slug);
                          },
                        ),
                      );
                    },
                  ),
          ),
          // Explore communities button at bottom
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  context.router.push(const CommunityExploreRoute());
                },
                icon: const Icon(Icons.explore_outlined, size: 18),
                label: Text(exploreBtnText),
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.colors.primary,
                  side: BorderSide(color: context.colors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _SortButton({
    required this.icon,
    required this.label,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? context.colors.primary : context.colors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? context.colors.primary : context.colors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? Colors.white : context.colors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : context.colors.textSecondary,
                fontSize: 12,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// STORES TAB — horizontal store strip + product grid
// ═════════════════════════════════════════════════════════════════════════════

class _StoresTab extends ConsumerStatefulWidget {
  final bool initialized;

  const _StoresTab({required this.initialized});

  @override
  ConsumerState<_StoresTab> createState() => _StoresTabState();
}

class _StoresTabState extends ConsumerState<_StoresTab> {
  String _sortBy = 'created_at'; // created_at, price_asc, price_desc
  int _currentPage = 1;
  static const int _pageSize = 20;

  String? _selectedCategoryId;
  String? _brandFilter;
  String? _colorFilter;

  void _onSortChanged(String sort) {
    if (_sortBy == sort) return;
    setState(() {
      _sortBy = sort;
      _currentPage = 1;
    });
  }

  void _onPageChanged(int page) {
    if (_currentPage == page) return;
    setState(() {
      _currentPage = page;
    });
  }

  String _sortLabel() => switch (_sortBy) {
    'price_asc' => t.store.price_low_high,
    'price_desc' => t.store.price_high_low,
    _ => t.store.latest_arrivals,
  };

  @override
  Widget build(BuildContext context) {
    if (!widget.initialized) return const SizedBox.shrink();

    final catsAsync = ref.watch(allCategoriesProvider);
    final storesAsync = ref.watch(_exploreStoresProvider);
    final productsAsync = ref.watch(
      paginatedProductsProvider(
        page: _currentPage,
        limit: _pageSize,
        categoryId: _selectedCategoryId,
        order: _sortBy,
      ),
    );

    return CustomScrollView(
        slivers: [
          // ─── Horizontal store cards strip ──────────────────
          SliverToBoxAdapter(
            child: storesAsync.when(
              loading: () => SizedBox(
                height: 148,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  itemCount: 5,
                  itemBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Shimmer.fromColors(
                      baseColor: context.colors.surfaceVariant,
                      highlightColor: context.colors.border,
                      child: Container(
                        width: 120,
                        decoration: BoxDecoration(
                          color: context.colors.surfaceVariant,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              error: (_, __) => const SizedBox.shrink(),
              data: (stores) {
                if (stores.isEmpty) return const SizedBox.shrink();
                return SizedBox(
                  height: 148,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    itemCount: stores.length,
                    itemBuilder: (ctx, i) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _StoreCard(store: stores[i]),
                    ),
                  ),
                );
              },
            ),
          ),

          // ─── Products section header with Sort popup and Filters ───
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Text(
                    t.home.more_products,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    onSelected: _onSortChanged,
                    color: context.colors.surface,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.sort, color: context.colors.textSecondary, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          _sortLabel(),
                          style: TextStyle(
                            color: context.colors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, color: context.colors.textSecondary, size: 16),
                      ],
                    ),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'created_at',
                        child: Text(t.store.latest_arrivals, style: TextStyle(color: context.colors.textPrimary, fontSize: 13)),
                      ),
                      PopupMenuItem(
                        value: 'price_asc',
                        child: Text(t.store.price_low_high, style: TextStyle(color: context.colors.textPrimary, fontSize: 13)),
                      ),
                      PopupMenuItem(
                        value: 'price_desc',
                        child: Text(t.store.price_high_low, style: TextStyle(color: context.colors.textPrimary, fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      final cats = catsAsync.value ?? const <CategoryModel>[];
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => _StoresFilterSheet(
                          categories: cats,
                          initialCategoryId: _selectedCategoryId,
                          initialBrand: _brandFilter,
                          initialColor: _colorFilter,
                          onApply: (catId, brand, color) {
                            setState(() {
                              _selectedCategoryId = catId;
                              _brandFilter = brand;
                              _colorFilter = color;
                              _currentPage = 1;
                            });
                          },
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.filter_list,
                          color: (_selectedCategoryId != null || _brandFilter != null || _colorFilter != null)
                              ? context.colors.primary
                              : context.colors.textSecondary,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          t.explore.filter,
                          style: TextStyle(
                            color: (_selectedCategoryId != null || _brandFilter != null || _colorFilter != null)
                                ? context.colors.primary
                                : context.colors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Product grid ──────────────────────────────────
          productsAsync.when(
            loading: () => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (_, __) => const ProductCardSkeleton(),
                  childCount: 6,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.58,
                ),
              ),
            ),
            error: (_, __) => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(t.home.failed_load_products,
                      style: TextStyle(color: context.colors.textMuted)),
                ),
              ),
            ),
            data: (response) {
              // Client-side filtering by brand and color
              final products = response.products.where((p) {
                if (_brandFilter != null && _brandFilter!.isNotEmpty) {
                  final title = p.title.toLowerCase();
                  final desc = (p.description ?? '').toLowerCase();
                  final vendor = (p.vendor?.storeName ?? '').toLowerCase();
                  final brand = _brandFilter!.toLowerCase();
                  if (!title.contains(brand) && !desc.contains(brand) && !vendor.contains(brand)) {
                    return false;
                  }
                }
                if (_colorFilter != null && _colorFilter!.isNotEmpty) {
                  final title = p.title.toLowerCase();
                  final color = _colorFilter!.toLowerCase();
                  bool hasColor = title.contains(color);
                  if (p.variants != null) {
                    for (final v in p.variants!) {
                      if (v.title?.toLowerCase().contains(color) ?? false) {
                        hasColor = true;
                        break;
                      }
                    }
                  }
                  if (!hasColor) return false;
                }
                return true;
              }).toList();

              if (products.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Text(t.store.no_products_found,
                          style: TextStyle(color: context.colors.textMuted)),
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => ProductCard(product: products[i]),
                    childCount: products.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.58,
                  ),
                ),
              );
            },
          ),

          // ─── Numbered pagination row at bottom ─────────────
          productsAsync.maybeWhen(
            data: (response) {
              final totalPages = (response.count / _pageSize).ceil();
              if (totalPages <= 1) return const SliverToBoxAdapter(child: SizedBox(height: 24));
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: _PaginationBar(
                    currentPage: _currentPage,
                    totalPages: totalPages,
                    onPageChanged: _onPageChanged,
                  ),
                ),
              );
            },
            orElse: () => const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ),
        ],
      );
  }
}

// ─── Pagination bar component ────────────────────────────────────────────────

class _PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const _PaginationBar({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final pages = <dynamic>[];
    
    if (totalPages <= 7) {
      for (var i = 1; i <= totalPages; i++) {
        pages.add(i);
      }
    } else {
      pages.add(1);
      
      final start = currentPage - 1 > 2 ? currentPage - 1 : 2;
      final end = currentPage + 1 < totalPages - 1 ? currentPage + 1 : totalPages - 1;
      
      if (start > 2) {
        pages.add('...');
      }
      
      for (var i = start; i <= end; i++) {
        pages.add(i);
      }
      
      if (end < totalPages - 1) {
        pages.add('...');
      }
      
      pages.add(totalPages);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PaginationArrowButton(
          icon: Icons.chevron_left,
          enabled: currentPage > 1,
          onTap: () => onPageChanged(currentPage - 1),
        ),
        const SizedBox(width: 8),
        ...pages.map((p) {
          if (p == '...') {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '...',
                style: TextStyle(
                  color: context.colors.textMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          final pageNum = p as int;
          final isSelected = pageNum == currentPage;
          return GestureDetector(
            onTap: () => onPageChanged(pageNum),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? context.colors.primary : context.colors.surface,
                border: Border.all(
                  color: isSelected ? context.colors.primary : context.colors.border,
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: context.colors.primary.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  pageNum.toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : context.colors.textPrimary,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(width: 8),
        _PaginationArrowButton(
          icon: Icons.chevron_right,
          enabled: currentPage < totalPages,
          onTap: () => onPageChanged(currentPage + 1),
        ),
      ],
    );
  }
}

class _PaginationArrowButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _PaginationArrowButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled ? context.colors.surface : context.colors.surfaceVariant.withValues(alpha: 0.5),
          border: Border.all(
            color: enabled ? context.colors.border : context.colors.border.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? context.colors.textPrimary : context.colors.textMuted.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

// ─── Store card (horizontal strip item with overlapping logo) ────────────────

class _StoreCard extends ConsumerWidget {
  final Map<String, dynamic> store;

  const _StoreCard({super.key, required this.store});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = store['store_name'] as String? ?? 'Store';
    final logo = store['logo_url'] as String?;
    final banner = store['banner_url'] as String?;
    final id = store['id'] as String?;
    final category = store['category'] as String? ??
        store['store_category'] as String?;
    final slug = store['slug'] as String?;

    return GestureDetector(
      onTap: () {
        if (slug != null) {
          context.router.push(VendorProfileRoute(slug: slug));
        }
      },
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner background with circular logo overlay
            SizedBox(
              height: 84,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Banner background
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 60,
                    child: (banner != null && banner.isNotEmpty)
                        ? CachedNetworkImage(
                            imageUrl: banner,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => _StoreFallbackBanner(name: name),
                          )
                        : _StoreFallbackBanner(name: name),
                  ),
                  // Logo circular overlay
                  Positioned(
                    bottom: 0,
                    left: 8,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.colors.surface,
                        border: Border.all(color: context.colors.surface, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: (logo != null && logo.isNotEmpty)
                          ? CachedNetworkImage(
                              imageUrl: logo,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => _StoreLogoPlaceholder(name: name),
                            )
                          : _StoreLogoPlaceholder(name: name),
                    ),
                  ),
                ],
              ),
            ),
            // Store name + category label
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 1),
                    if (category != null && category.isNotEmpty)
                      Text(
                        category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: context.colors.textMuted, fontSize: 9),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreFallbackBanner extends StatelessWidget {
  final String name;
  const _StoreFallbackBanner({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.primary.withValues(alpha: 0.08),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'S',
          style: TextStyle(
            color: context.colors.primary.withValues(alpha: 0.3),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _StoreLogoPlaceholder extends StatelessWidget {
  final String name;
  const _StoreLogoPlaceholder({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.primary.withValues(alpha: 0.1),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'S',
          style: TextStyle(
            color: context.colors.primary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _StoresFilterSheet extends StatefulWidget {
  final List<CategoryModel> categories;
  final String? initialCategoryId;
  final String? initialBrand;
  final String? initialColor;
  final void Function(String? catId, String? brand, String? color) onApply;

  const _StoresFilterSheet({
    required this.categories,
    required this.initialCategoryId,
    required this.initialBrand,
    required this.initialColor,
    required this.onApply,
  });

  @override
  State<_StoresFilterSheet> createState() => _StoresFilterSheetState();
}

class _StoresFilterSheetState extends State<_StoresFilterSheet> {
  String? _selectedCategoryId;
  late TextEditingController _brandCtrl;
  late TextEditingController _colorCtrl;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialCategoryId;
    _brandCtrl = TextEditingController(text: widget.initialBrand ?? '');
    _colorCtrl = TextEditingController(text: widget.initialColor ?? '');
  }

  @override
  void dispose() {
    _brandCtrl.dispose();
    _colorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.explore.filter,
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategoryId = null;
                      _brandCtrl.clear();
                      _colorCtrl.clear();
                    });
                  },
                  child: Text(t.explore.clear_filters, style: TextStyle(color: context.colors.primary)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(t.explore.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String?>(
              value: _selectedCategoryId,
              dropdownColor: context.colors.surface,
              style: TextStyle(color: context.colors.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              items: [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text(t.store.all_categories),
                ),
                ...widget.categories.map((c) => DropdownMenuItem<String?>(
                  value: c.id,
                  child: Text(c.name),
                )),
              ],
              onChanged: (val) {
                setState(() => _selectedCategoryId = val);
              },
            ),
            const SizedBox(height: 16),
            Text(t.explore.brand, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              controller: _brandCtrl,
              style: TextStyle(color: context.colors.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: t.explore.brand,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            Text(t.explore.color, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              controller: _colorCtrl,
              style: TextStyle(color: context.colors.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: t.explore.color,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  widget.onApply(
                    _selectedCategoryId,
                    _brandCtrl.text.trim().isEmpty ? null : _brandCtrl.text.trim(),
                    _colorCtrl.text.trim().isEmpty ? null : _colorCtrl.text.trim(),
                  );
                  Navigator.pop(context);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(t.explore.apply, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
