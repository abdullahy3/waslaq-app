import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../router/app_router.dart';
import '../../../../core/api/medusa_client.dart';
import '../../../../core/api/social_client.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../social/providers/social_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

// ─── Categories provider (same logic as categories_screen) ───────────────────
final _exploreCategoriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
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
final _exploreStoresProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final res = await MedusaClient.instance.get('/store/vendors');
  final vendors = res.data['vendors'] as List<dynamic>? ?? [];
  return vendors.map((v) => v as Map<String, dynamic>).toList();
});

@RoutePage()
class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen>
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surfaceVariant,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ──────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              decoration: BoxDecoration(
                color: context.colors.background,
                border: Border(bottom: BorderSide(color: context.colors.border, width: 0.5)),
              ),
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
                  // Search bar — tappable, pushes to SearchRoute
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
                            style: TextStyle(color: context.colors.textMuted, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Tab bar
                  TabBar(
                    controller: _tabController,
                    labelColor: context.colors.primary,
                    unselectedLabelColor: context.colors.textMuted,
                    indicatorColor: context.colors.primary,
                    indicatorWeight: 2.5,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
                    tabs: [
                      Tab(text: t.explore.products),
                      Tab(text: t.explore.communities),
                      Tab(text: t.explore.stores),
                    ],
                  ),
                ],
              ),
            ),

            // ─── Tab views ────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _ProductsTab(),
                  _CommunitiesTab(),
                  _StoresTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── PRODUCTS TAB — category grid ────────────────────────────────────────────

class _ProductsTab extends ConsumerWidget {
  const _ProductsTab();

  String _catName(Map<String, dynamic> cat, String lang) {
    final meta = cat['metadata'] as Map<String, dynamic>?;
    if (lang == 'ar') return meta?['name_ar'] as String? ?? cat['name'] as String? ?? '';
    return cat['name'] as String? ?? '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catsAsync = ref.watch(_exploreCategoriesProvider);
    final lang = ref.watch(localeProvider).languageCode;

    return catsAsync.when(
      loading: () => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.colors.border),
          ),
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.82,
            ),
            itemCount: 9,
            itemBuilder: (_, __) => Shimmer.fromColors(
              baseColor: context.colors.surfaceVariant,
              highlightColor: context.colors.border,
              child: Container(
                decoration: BoxDecoration(
                  color: context.colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
      error: (_, __) => Center(child: Text(t.common.failed_load_categories,
          style: TextStyle(color: context.colors.textMuted))),
      data: (cats) {
        final popularSearches = [
          'أيفون', 'لاب توب', 'كيبورد', 'سماعات', 'ساعة ذكية',
          'iPhone', 'Keyboard', 'Headphones',
        ];
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title: Categories
              Padding(
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
              // Categories Card Block
              Container(
                decoration: BoxDecoration(
                  color: context.colors.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.colors.border),
                ),
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: cats.length,
                  itemBuilder: (ctx, i) {
                    final cat = cats[i];
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
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: context.colors.surfaceVariant,
                                border: Border.all(
                                    color: context.colors.border.withOpacity(0.5)),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: imageUrl != null && imageUrl.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      errorWidget: (_, __, ___) =>
                                          _catInitial(context, name))
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
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Section Title: Popular Searches
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
              // Popular Searches Card Block
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
                      onTap: () => context.router.push(
                        const SearchRoute(),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
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
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _catInitial(BuildContext context, String name) => Center(
    child: Text(
      name.isNotEmpty ? name[0].toUpperCase() : '?',
      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900,
          color: context.colors.primary.withOpacity(0.25)),
    ),
  );
}

// ─── COMMUNITIES TAB ─────────────────────────────────────────────────────────

class _CommunitiesTab extends ConsumerWidget {
  const _CommunitiesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communitiesState = ref.watch(communitiesProvider);

    return communitiesState.when(
      loading: () => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: context.colors.surfaceVariant,
          highlightColor: context.colors.border,
          child: Container(
            height: 72,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: context.colors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      error: (_, __) => Center(child: Text(t.community.error_loading,
          style: TextStyle(color: context.colors.textMuted))),
      data: (communities) {
        if (communities.isEmpty) {
          return Center(child: Text(t.community.no_communities_found,
              style: TextStyle(color: context.colors.textMuted)));
        }
        return RefreshIndicator(
          color: context.colors.primary,
          onRefresh: () async => ref.invalidate(communitiesProvider),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: communities.length,
            itemBuilder: (ctx, i) {
              final c = communities[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: context.colors.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.colors.border),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: context.colors.primary.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                        style: TextStyle(
                            color: context.colors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  title: Text(
                    c.title,
                    style: TextStyle(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  subtitle: Text(
                    'r/${c.slug} · ${t.community.members_count(count: c.memberCount.toString())}',
                    style: TextStyle(color: context.colors.textMuted, fontSize: 11),
                  ),
                  trailing: c.isMember
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: context.colors.border),
                            borderRadius: BorderRadius.circular(20),
                            color: context.colors.surfaceVariant,
                          ),
                          child: Text(
                            t.community.joined,
                            style: TextStyle(
                                color: context.colors.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : FilledButton(
                          onPressed: () async {
                            await ref.read(socialRepositoryProvider).joinCommunity(c.slug);
                            ref.invalidate(communitiesProvider);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: context.colors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            minimumSize: const Size(60, 30),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text(
                            t.community.join,
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                  onTap: () => context.pushRoute(CommunityRoute(communitySlug: c.slug)),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ─── STORES TAB ──────────────────────────────────────────────────────────────

class _StoresTab extends StatefulWidget {
  const _StoresTab();

  @override
  State<_StoresTab> createState() => _StoresTabState();
}

class _StoresTabState extends State<_StoresTab> {
  // Tracks optimistic follow state per customer_id
  final Map<String, bool> _followedIds = {};

  Future<void> _toggleFollow(String customerId) async {
    final prev = _followedIds[customerId] ?? false;
    setState(() => _followedIds[customerId] = !prev);
    try {
      await SocialClient.instance.post('/store/social/follow/$customerId');
    } catch (_) {
      // Revert on error
      if (mounted) setState(() => _followedIds[customerId] = prev);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final storesAsync = ref.watch(_exploreStoresProvider);
        return storesAsync.when(
          loading: () => GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.82,
            ),
            itemCount: 6,
            itemBuilder: (_, __) => Shimmer.fromColors(
              baseColor: context.colors.surfaceVariant,
              highlightColor: context.colors.border,
              child: Container(
                  decoration: BoxDecoration(
                    color: context.colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                  )),
            ),
          ),
          error: (_, __) => Center(
              child: Text(t.vendor.failed_load_store,
                  style: TextStyle(color: context.colors.textMuted))),
          data: (stores) {
            if (stores.isEmpty) {
              return Center(
                  child: Text(t.vendor.no_stores_yet,
                      style: TextStyle(color: context.colors.textMuted)));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.82,
              ),
              itemCount: stores.length,
              itemBuilder: (ctx, i) {
                final v = stores[i];
                final name = v['store_name'] as String? ?? 'Store';
                final logo = v['logo_url'] as String?;
                final slug = v['slug'] as String?;
                final customerId = v['customer_id'] as String?;
                final rating =
                    double.tryParse('${v['avg_rating'] ?? 0}') ?? 0;
                final isFollowed = _followedIds[customerId] ?? false;

                return GestureDetector(
                  onTap: () {
                    if (slug != null) {
                      context.router.push(VendorProfileRoute(slug: slug));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colors.background,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.colors.border),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.colors.primary.withOpacity(0.08)),
                          clipBehavior: Clip.antiAlias,
                          child: logo != null
                              ? CachedNetworkImage(
                                  imageUrl: logo,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) =>
                                      _storeInitial(context, name))
                              : _storeInitial(context, name),
                        ),
                        const SizedBox(height: 8),
                        Text(name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: context.colors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                        const SizedBox(height: 4),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: Colors.amber, size: 13),
                              const SizedBox(width: 2),
                              Text(rating.toStringAsFixed(1),
                                  style: TextStyle(
                                      color: context.colors.textSecondary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600)),
                            ]),
                        const SizedBox(height: 10),
                        if (customerId != null)
                          GestureDetector(
                            onTap: () => _toggleFollow(customerId),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                color: isFollowed
                                    ? context.colors.surfaceVariant
                                    : context.colors.primary,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isFollowed
                                      ? context.colors.border
                                      : context.colors.primary,
                                ),
                              ),
                              child: Text(
                                isFollowed
                                    ? (Localizations.localeOf(context)
                                                .languageCode ==
                                             'ar'
                                          ? 'متابَع'
                                          : 'Following')
                                    : (Localizations.localeOf(context)
                                                .languageCode ==
                                             'ar'
                                          ? 'متابعة'
                                          : 'Follow'),
                                style: TextStyle(
                                  color: isFollowed
                                      ? context.colors.textSecondary
                                      : Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _storeInitial(BuildContext context, String name) => Center(
        child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'S',
            style: TextStyle(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
      );
}
