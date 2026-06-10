// lib/features/home/ui/screens/home_screen.dart

import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../product/providers/product_provider.dart';
import '../../../product/data/models/category_model.dart';
import '../../../../router/app_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/auth/auth_notifier.dart';
import '../../../../core/auth/auth_state.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../vendor/providers/vendor_providers.dart';
import '../../../cart/providers/cart_provider.dart';
import '../../../../core/api/social_client.dart';
import '../../../../core/api/medusa_client.dart';
import '../../../../i18n/strings.g.dart';
import '../../../social/providers/social_providers.dart';
import '../../../../shared/widgets/post_card.dart';
import '../../../social/data/models/social_models.dart';
import '../../../../core/notifications/notification_bus.dart';

// ── Home-specific providers (small, fast fetches for the home feed) ──────────

final _homeFeedPostsProvider = FutureProvider<List<PostModel>>((ref) async {
  return ref.read(socialRepositoryProvider).getPosts(
    limit: 3,
    offset: 0,
    sort: 'hot',
  );
});

final _homeStoresProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final res = await MedusaClient.instance.get('/store/vendors');
  final vendors = res.data['vendors'] as List<dynamic>? ?? [];
  return vendors.map((v) => v as Map<String, dynamic>).take(6).toList();
});

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider());

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            const _WaslaqTopNav(),
            Expanded(
              child: RefreshIndicator(
                color: context.colors.primary,
                backgroundColor: context.colors.surface,
                onRefresh: () async {
                  ref.invalidate(productListProvider());
                  ref.invalidate(_homeFeedPostsProvider);
                  ref.invalidate(_homeStoresProvider);
                },
                child: CustomScrollView(
                  slivers: [
                    // ─── Trust bar ──────────────────────────
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: _TrustBar(),
                      ),
                    ),

                    // ─── Category pills ──────────────────────
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: _CategoryPills(),
                      ),
                    ),

                    // ─── SECTION: Featured Products ──────────
                    SliverToBoxAdapter(
                      child: _HomeSectionHeader(
                        title: t.home.featured_products,
                        onSeeAll: () => context.router.push(StoreRoute()),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: productsAsync.when(
                        loading: () => SizedBox(
                          height: 265,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: 4,
                            itemBuilder: (_, __) => Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SizedBox(
                                width: 150,
                                child: const ProductCardSkeleton(),
                              ),
                            ),
                          ),
                        ),
                        error: (_, __) => const SizedBox.shrink(),
                        data: (products) {
                          final featured = products.take(4).toList();
                          if (featured.isEmpty) return const SizedBox.shrink();
                          return SizedBox(
                            height: 265,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              itemCount: featured.length,
                              itemBuilder: (ctx, i) => Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: SizedBox(
                                  width: 150,
                                  child: ProductCard(product: featured[i]),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // ─── SECTION: Trending Discussions ────────
                    SliverToBoxAdapter(
                      child: _HomeSectionHeader(
                        title: t.home.trending_discussions,
                        onSeeAll: () => context.router.push(const FeedRoute()),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _DiscussionsSection(),
                    ),

                    // ─── SECTION: Top Stores ──────────────────
                    SliverToBoxAdapter(
                      child: _HomeSectionHeader(
                        title: t.home.top_stores,
                        onSeeAll: () => context.router.push(const BrowseStoresRoute()),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _StoresSection(),
                    ),

                    // ─── SECTION: More Products (2-col grid) ─
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                        child: Text(
                          t.home.more_products,
                          style: TextStyle(
                            color: context.colors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    productsAsync.when(
                      loading: () => SliverGrid(
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
                      error: (e, _) => SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              t.home.failed_load_products,
                              style: TextStyle(color: context.colors.textSecondary),
                            ),
                          ),
                        ),
                      ),
                      data: (products) {
                        // Skip first 4 (already shown in featured horizontal scroll)
                        final remaining = products.skip(4).toList();
                        if (remaining.isEmpty) {
                          return const SliverToBoxAdapter(child: SizedBox(height: 24));
                        }
                        return SliverPadding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                          sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (ctx, i) => ProductCard(product: remaining[i]),
                              childCount: remaining.length,
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.58,
                            ),
                          ),
                        );
                      },
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

// ── Hero Banner ───────────────────────────────────────────────────────────────

class _HeroBanner extends StatefulWidget {
  const _HeroBanner();

  @override
  State<_HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<_HeroBanner> {
  final _controller = PageController();
  int _current = 0;
  Timer? _timer;

  List<({String title, String subtitle, String buttonText})> get _slides => [
        (
          title: t.home.hero_title,
          subtitle: t.home.hero_subtitle,
          buttonText: t.home.shop_now
        ),
      ];

  @override
  void initState() {
    super.initState();
    if (_slides.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 5), (_) {
        if (_controller.hasClients) {
          _current = (_current + 1) % _slides.length;
          _controller.animateToPage(_current,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut);
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _current = i),
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                      isRtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(slide.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            height: 1.3),
                        textAlign: isRtl ? TextAlign.right : TextAlign.left),
                    const SizedBox(height: 8),
                    Text(slide.subtitle,
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 14),
                        textAlign: isRtl ? TextAlign.right : TextAlign.left),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 10),
                      ),
                      onPressed: () {
                        context.router.push(StoreRoute());
                      },
                      child: Text(slide.buttonText,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            },
          ),
          if (_slides.length > 1)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_slides.length, (i) {
                  final active = i == _current;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Trust Bar ──────────────────────────────────────────────────────────────────

class _TrustBar extends StatelessWidget {
  const _TrustBar();

  @override
  Widget build(BuildContext context) {
    final items = [
      (icon: Icons.verified_user_outlined, label: t.home.secure_escrow),
      (icon: Icons.badge_outlined, label: t.home.verified_sellers),
      (icon: Icons.support_agent_outlined, label: t.home.local_support),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: items
            .map((item) => Expanded(
                  child: Column(
                    children: [
                      Icon(item.icon, color: context.colors.primary, size: 22),
                      SizedBox(height: 4),
                      Text(item.label,
                          style: TextStyle(
                              color: context.colors.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

// ── Category Pills — wired to real Medusa categories ─────────────────────────

class _CategoryPills extends ConsumerWidget {
  const _CategoryPills();

  // Icon mapping for known category handles
  static const _icons = {
    'electronics': Icons.devices_outlined,
    'cell-phones-accessories': Icons.phone_android_outlined,
    'womens-clothing': Icons.checkroom_outlined,
    'mens-clothing': Icons.checkroom_outlined,
    'shoes': Icons.directions_walk_outlined,
    'beauty-health': Icons.spa_outlined,
    'furniture': Icons.chair_outlined,
    'toys-games': Icons.toys_outlined,
    'baby-maternity': Icons.child_care_outlined,
    'jewelry-accessories': Icons.diamond_outlined,
    'appliances': Icons.kitchen_outlined,
    'tools-home-improvement': Icons.handyman_outlined,
    'automotive': Icons.directions_car_outlined,
    'pet-supplies': Icons.pets_outlined,
    'patio-lawn-garden': Icons.grass_outlined,
    'sports-outdoors': Icons.sports_soccer_outlined,
  };

  static const _shortNames = {
    'pet-supplies': 'Pets',
    'beauty-health': 'Beauty',
    'tools-home-improvement': 'Tools',
    'jewelry-accessories': 'Jewelry',
    'sports-outdoors': 'Sports',
    'baby-maternity': 'Baby',
    'patio-lawn-garden': 'Garden',
    'cell-phones-accessories': 'Phones',
    'womens-clothing': 'Women',
    'mens-clothing': 'Men',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final lang = ref.watch(localeProvider).languageCode;

    return SizedBox(
      height: 100,
      child: categoriesAsync.when(
        loading: () => _buildList(context, null, ref, lang),
        error: (_, __) => _buildList(context, null, ref, lang),
        data: (cats) => _buildList(context, cats, ref, lang),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<CategoryModel>? cats, WidgetRef ref, String lang) {
    // Use real categories if loaded, else show empty shimmer row
    final items = cats ?? [];

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      itemCount: items.length + 1,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return _CategoryPill(
            icon: Icons.grid_view_outlined,
            name: t.common.view_all,
            onTap: () => context.router.push(const CategoriesRoute()),
          );
        }
        final cat = items[index];
        final icon = _icons[cat.handle] ?? Icons.category_outlined;
        final shortName = lang == 'en'
            ? (_shortNames[cat.handle] ?? cat.localizedName(lang))
            : cat.localizedName(lang);
        return _CategoryPill(
          icon: icon,
          name: shortName,
          onTap: () => context.router.push(
            CategoriesRoute(),
          ),
        );
      },
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final IconData icon;
  final String name;
  final VoidCallback onTap;

  const _CategoryPill({
    required this.icon,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 64,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                shape: BoxShape.circle,
                border: Border.all(color: context.colors.border, width: 1.5),
              ),
              child: Icon(icon, color: context.colors.textPrimary, size: 22),
            ),
            SizedBox(height: 4),
            Text(
              name,
              style: TextStyle(
                  color: context.colors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Top Nav ────────────────────────────────────────────────────────────────────

class _WaslaqTopNav extends ConsumerWidget {
  const _WaslaqTopNav();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return Container(
      decoration: BoxDecoration(
        color: context.colors.background,
        border:
            Border(bottom: BorderSide(color: context.colors.border, width: 0.5)),
      ),
      child: Column(
        children: [
          // ROW 1
          SizedBox(
            height: 48,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Bell — left
                  authState.maybeWhen(
                    authenticated: (_, __, ___, ____, _____) =>
                        const _BellIconWithBadge(),
                    orElse: () => const SizedBox(width: 40),
                  ),
                  // Brand — center
                  Expanded(
                    child: Center(
                      child: Text(
                        'WASLAQ',
                        style: TextStyle(
                          color: context.colors.primary,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  // Right: Wishlist & Cart horizontally aligned
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Wishlist (Heart)
                      authState.maybeWhen(
                        authenticated: (_, __, ___, ____, _____) => IconButton(
                          icon: Icon(Icons.favorite_border,
                              color: context.colors.textPrimary, size: 24),
                          onPressed: () => context.router.push(const SavedItemsRoute()),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                        ),
                        orElse: () => IconButton(
                          icon: Icon(Icons.favorite_border,
                              color: context.colors.textPrimary, size: 24),
                          onPressed: () => context.router.push(const SignInRoute()),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Cart
                      Consumer(
                        builder: (context, ref, _) {
                          final cartCount = ref.watch(cartItemCountProvider);
                          return IconButton(
                            icon: Badge(
                              isLabelVisible: cartCount > 0,
                              label: Text('$cartCount'),
                              child: Icon(Icons.shopping_cart_outlined,
                                  color: context.colors.textPrimary, size: 24),
                            ),
                            onPressed: () => context.router.push(const CartRoute()),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // ROW 2
          SizedBox(
            height: 44,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.router.push(const SearchRoute()),
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: context.colors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: context.colors.border),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            Icon(Icons.search,
                                color: context.colors.textSecondary, size: 18),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                t.home.search_placeholder,
                                style: TextStyle(
                                    color: context.colors.textSecondary, fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Side Drawer ───────────────────────────────────────────────────────────────

class _WaslaqDrawer extends ConsumerStatefulWidget {
  const _WaslaqDrawer();
  @override
  ConsumerState<_WaslaqDrawer> createState() => _WaslaqDrawerState();
}

class _WaslaqDrawerState extends ConsumerState<_WaslaqDrawer> {
  bool _communitiesOpen = true;
  bool _storesOpen = false;
  List<Map<String, dynamic>> _communities = [];
  bool _loadingCommunities = false;
  String? _vendorSlug;
  bool _isVendor = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Load joined communities
    setState(() => _loadingCommunities = true);
    try {
      final res = await SocialClient.instance.get('/store/social/communities');
      final list = (res.data['communities'] as List<dynamic>? ?? [])
          .map((c) => c as Map<String, dynamic>)
          .where((c) => c['isMember'] == true)
          .toList();
      if (mounted) setState(() { _communities = list; _loadingCommunities = false; });
    } catch (_) {
      if (mounted) setState(() => _loadingCommunities = false);
    }
    // Load vendor status
    try {
      final res = await MedusaClient.instance.get('/store/vendors/me');
      if (res.data['is_vendor'] == true) {
        if (mounted) setState(() { _isVendor = true; _vendorSlug = res.data['vendor']?['slug'] as String?; });
      }
    } catch (_) {}
  }

  void _nav(Widget Function() routeBuilder) {
    Navigator.pop(context);
    context.router.push(routeBuilder() as PageRouteInfo);
  }

  void _navRoute(PageRouteInfo route) {
    Navigator.pop(context);
    context.router.push(route);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoggedIn = authState.maybeWhen(authenticated: (_, __, ___, ____, _____) => true, orElse: () => false);
    final communityColors = [Colors.red, Colors.blue, Colors.green, Colors.amber, Colors.purple, Colors.pink, Colors.indigo, Colors.teal];

    return Drawer(
      backgroundColor: context.colors.background,
      child: Column(children: [
        // STICKY HEADER
        Container(
          height: MediaQuery.of(context).padding.top + 72,
          padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top, 16, 0),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.colors.border))),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            GestureDetector(
              onTap: () => _navRoute(const HomeRoute()),
              behavior: HitTestBehavior.opaque,
              child: Image.asset('assets/images/logo.png', height: 44, fit: BoxFit.contain),
            ),
            if (isLoggedIn)
              authState.maybeWhen(
                authenticated: (_, __, ___, avatarUrl, ____) => GestureDetector(
                  onTap: () => _navRoute(const AccountRoute()),
                  child: Container(
                    padding: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: context.colors.border),
                    ),
                    child: CircleAvatar(
                      radius: 19, backgroundColor: context.colors.surfaceVariant,
                      backgroundImage: avatarUrl != null ? CachedNetworkImageProvider(avatarUrl) : null,
                      child: avatarUrl == null ? Icon(Icons.person, color: context.colors.textMuted, size: 20) : null,
                    ),
                  ),
                ),
                orElse: () => SizedBox.shrink(),
              ),
          ]),
        ),

        // SCROLLABLE BODY
        Expanded(child: ListView(padding: EdgeInsets.zero, children: [
          // SIGN IN PROMPT (unauthenticated)
          if (!isLoggedIn) Container(
            padding: EdgeInsets.all(16), color: context.colors.surfaceVariant,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t.home.drawer_sign_in_hint, style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
              SizedBox(height: 10),
              SizedBox(width: double.infinity, child: ElevatedButton(
                onPressed: () => _navRoute(const SignInRoute()),
                style: ElevatedButton.styleFrom(backgroundColor: context.colors.primary, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.symmetric(vertical: 12)),
                child: Text(t.auth.sign_in, style: TextStyle(fontWeight: FontWeight.bold)),
              )),
            ]),
          ),

          // ─── BROWSE ────────────────────────────────────────────
          _sectionLabel(t.home.drawer_browse),
          _navItem(Icons.home_outlined, t.nav.home, () => _navRoute(const HomeRoute()), activeName: 'HomeRoute'),
          _navItem(Icons.grid_view_outlined, t.nav.category, () => _navRoute(const CategoriesRoute()), activeName: 'CategoriesRoute'),
          _navItem(Icons.trending_up, t.home.drawer_popular, null, disabled: true, badge: 'beta'),
          _navItem(Icons.newspaper_outlined, t.home.drawer_news, null, disabled: true, badge: 'beta'),
          _navItem(Icons.favorite_border, t.nav.saved, () => isLoggedIn ? _navRoute(const SavedItemsRoute()) : _navRoute(const SignInRoute()), activeName: 'SavedItemsRoute'),
          Divider(height: 1, indent: 16, endIndent: 16, color: context.colors.border),

          // ─── COMMUNITY (collapsible) ───────────────────────────
          _collapsibleHeader(t.home.drawer_community, _communitiesOpen, () => setState(() => _communitiesOpen = !_communitiesOpen)),
          if (_communitiesOpen) ...[
            _navItem(Icons.add, t.home.drawer_create_community, () => _navRoute(CommunityExploreRoute()), iconColor: context.colors.primary, labelColor: context.colors.primary),
            if (_loadingCommunities) ...[
              for (var i = 0; i < 3; i++) Container(height: 40, margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                decoration: BoxDecoration(color: context.colors.surfaceVariant, borderRadius: BorderRadius.circular(10))),
            ] else if (_communities.isNotEmpty) ...[
              ..._communities.asMap().entries.map((e) {
                final idx = e.key;
                final c = e.value;
                final name = c['name'] as String? ?? '';
                final slug = c['slug'] as String? ?? '';
                final color = communityColors[idx % communityColors.length];
                return InkWell(
                  onTap: () => _navRoute(CommunityRoute(communitySlug: slug)),
                  child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(children: [
                      Container(width: 30, height: 30, decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                        child: Center(child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)))),
                      SizedBox(width: 10),
                      Text('r/$slug', style: TextStyle(color: context.colors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
                    ])),
                );
              }),
            ] else if (isLoggedIn) Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(t.home.drawer_no_communities, style: TextStyle(color: context.colors.textMuted, fontSize: 12, fontStyle: FontStyle.italic))),
          ],
          Divider(height: 1, indent: 16, endIndent: 16, color: context.colors.border),

          // ─── STORES (collapsible) ──────────────────────────────
          _collapsibleHeader(t.home.drawer_stores, _storesOpen, () => setState(() => _storesOpen = !_storesOpen)),
          if (_storesOpen) ...[
            _navItem(Icons.shopping_bag_outlined, t.vendor.store, () => _navRoute(StoreRoute())),
            _navItem(Icons.store_outlined, t.home.drawer_browse_stores, () => _navRoute(const BrowseStoresRoute())),
            _navItem(Icons.favorite_border_rounded, 'Following Stores', () => _navRoute(const FollowingStoresRoute())),
            if (_isVendor && _vendorSlug != null)
              _navItem(Icons.store_outlined, t.home.drawer_my_store, () => _navRoute(VendorProfileRoute(slug: _vendorSlug!)), iconColor: context.colors.primary, labelColor: context.colors.primary)
            else if (isLoggedIn)
              InkWell(
                onTap: () => _navRoute(const BecomeVendorRoute()),
                child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [Icon(Icons.store_outlined, color: context.colors.textMuted, size: 20), SizedBox(width: 12),
                      Text(t.home.drawer_my_store, style: TextStyle(color: context.colors.textMuted, fontSize: 14))]),
                    Padding(padding: const EdgeInsets.only(left: 32),
                      child: Text(t.home.drawer_become_vendor_hint, style: TextStyle(color: context.colors.primary, fontSize: 12, fontWeight: FontWeight.w500))),
                  ])),
              ),
          ],
          Divider(height: 1, indent: 16, endIndent: 16, color: context.colors.border),

          // ─── ACCOUNT ───────────────────────────────────────────
          if (isLoggedIn) ...[
            _sectionLabel(t.home.drawer_account),
            _navItem(Icons.settings_outlined, t.account.settings, () => _navRoute(const SettingsRoute()), activeName: 'SettingsRoute'),
            _navItem(Icons.notifications_none, t.account.notifications, () => _navRoute(const NotificationsRoute()), activeName: 'NotificationsRoute'),
            Divider(height: 1, indent: 16, endIndent: 16, color: context.colors.border),
          ],

          // ─── INFO ──────────────────────────────────────────────
          _sectionLabel(t.home.drawer_info),
          _navItem(Icons.info_outline, t.home.drawer_about, () => _navRoute(const AboutRoute())),
          _navItem(Icons.phone_outlined, t.home.drawer_contact, () => _navRoute(const ContactRoute())),
          _navItem(Icons.message_outlined, t.home.drawer_feedback, () => _navRoute(const FeedbackRoute())),
          Divider(height: 1, indent: 16, endIndent: 16, color: context.colors.border),

          // ─── LEGAL ─────────────────────────────────────────────
          _sectionLabel(t.home.drawer_legal),
          _navItem(Icons.description_outlined, t.footer.privacy_policy, () => _navRoute(const PrivacyPolicyRoute()), small: true),
          _navItem(Icons.article_outlined, t.footer.terms_of_use, () => _navRoute(const TermsRoute()), small: true),
          _navItem(Icons.assignment_return_outlined, 'Refund & Return Policy', () => _navRoute(const RefundPolicyRoute()), small: true),
          SizedBox(height: 8),
        ])),

        // SIGN OUT — bottom sticky
        if (isLoggedIn)
          Container(
            decoration: BoxDecoration(color: context.colors.surface, border: Border(top: BorderSide(color: context.colors.border))),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: InkWell(
              onTap: () { Navigator.pop(context); ref.read(authNotifierProvider.notifier).signOut(); },
              borderRadius: BorderRadius.circular(12),
              child: Padding(padding: const EdgeInsets.all(8),
                child: Row(children: [
                  Icon(Icons.logout, color: Colors.red, size: 20),
                  SizedBox(width: 12),
                  Text(t.auth.sign_out, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14)),
                ])),
            ),
          ),
      ]),
    );
  }

  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
    child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: context.colors.textMuted)),
  );

  Widget _collapsibleHeader(String text, bool isOpen, VoidCallback onTap) => InkWell(
    onTap: onTap,
    child: Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Row(children: [
        Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: context.colors.textSecondary)),
        const Spacer(),
        Icon(isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 16, color: context.colors.textMuted),
      ])),
  );

  Widget _navItem(IconData icon, String label, VoidCallback? onTap, {bool disabled = false, String? badge, Color? iconColor, Color? labelColor, bool small = false, String? activeName}) {
    final isActive = activeName != null && context.router.current.name == activeName;
    final fg = isActive
        ? context.colors.primary
        : (disabled ? context.colors.textMuted : (labelColor ?? context.colors.textPrimary));
    final ic = isActive
        ? context.colors.primary
        : (disabled ? context.colors.border : (iconColor ?? context.colors.textSecondary));
    return InkWell(
      onTap: disabled ? null : onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        alignment: Alignment.centerLeft,
        color: isActive ? context.colors.primary.withValues(alpha: 0.10) : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: small ? 8 : 10),
        child: Row(children: [
          Icon(icon, size: 20, color: ic),
          SizedBox(width: 12),
          Text(label, style: TextStyle(fontSize: 14, color: fg,
              fontWeight: (isActive || iconColor != null || labelColor != null) ? FontWeight.w600 : FontWeight.normal)),
          if (badge != null) ...[
            SizedBox(width: 8),
            Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: context.colors.textMuted, borderRadius: BorderRadius.circular(10)),
              child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))),
          ],
        ]),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;
  final String? badge;

  const _DrawerItem({required this.icon, required this.label, required this.onTap, this.iconColor, this.labelColor, this.badge});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? context.colors.textPrimary, size: 20),
      title: Row(
        children: [
          Text(label, style: TextStyle(color: labelColor ?? context.colors.textPrimary, fontSize: 14)),
          if (badge != null) ...[
            SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: context.colors.border),
              ),
              child: Text(badge!, style: TextStyle(color: context.colors.textMuted, fontSize: 10)),
            ),
          ],
        ],
      ),
      onTap: onTap,
      dense: true,
      visualDensity: const VisualDensity(vertical: -1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}

// ── Avatar dropdown — matches web UI ─────────────────────────────────────────

class _AvatarDropdown extends ConsumerStatefulWidget {
  final AuthState authState;
  const _AvatarDropdown({required this.authState});
  @override
  ConsumerState<_AvatarDropdown> createState() => _AvatarDropdownState();
}

class _AvatarDropdownState extends ConsumerState<_AvatarDropdown> {
  final GlobalKey _menuKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);

    return widget.authState.maybeWhen(
      authenticated: (customerId, email, displayName, avatarUrl, username) {
        final name = (displayName?.isNotEmpty == true)
            ? displayName!
            : email.split('@').first;
        final letter = name[0].toUpperCase();
        final isVendorAsync = ref.watch(isVendorProvider);
        final isVendor = isVendorAsync.valueOrNull ?? false;

        return PopupMenuButton<String>(
          key: _menuKey,
          offset: const Offset(0, 44),
          color: context.colors.surface,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: context.colors.border, width: 0.5),
          ),
          constraints: const BoxConstraints(minWidth: 220),
          onSelected: (value) {
            if (value == 'profile') context.router.push(UserProfileRoute(userId: customerId));
            if (value == 'dashboard') context.router.push(const AccountRoute());
            if (value == 'vendor') context.router.push(const VendorDashboardRoute());
            if (value == 'signout') ref.read(authNotifierProvider.notifier).signOut();
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              enabled: false, height: 52,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text(t.account_dropdown.signed_in_as, style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
                Text(name, style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
              ]),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(value: 'profile', height: 40, child: Row(children: [
              Icon(Icons.person_outline, size: 18, color: context.colors.textPrimary), SizedBox(width: 10),
              Text(t.account_dropdown.my_profile, style: TextStyle(color: context.colors.textPrimary, fontSize: 14)),
            ])),
            PopupMenuItem(value: 'dashboard', height: 40, child: Row(children: [
              Icon(Icons.dashboard_outlined, size: 18, color: context.colors.textPrimary), SizedBox(width: 10),
              Text(t.account_dropdown.account_dashboard, style: TextStyle(color: context.colors.textPrimary, fontSize: 14)),
            ])),
            if (isVendor)
              PopupMenuItem(value: 'vendor', height: 40, child: Row(children: [
                Icon(Icons.store_outlined, size: 18, color: context.colors.textPrimary), SizedBox(width: 10),
                Text(t.account_dropdown.vendor_dashboard, style: TextStyle(color: context.colors.textPrimary, fontSize: 14)),
              ])),
            const PopupMenuDivider(),
            PopupMenuItem(
              enabled: false, height: 48,
              child: Row(children: [
                Text(t.account_dropdown.language, style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
                const Spacer(),
                _LangBtn(label: 'English', active: locale.languageCode == 'en', onTap: () {
                  Navigator.pop(context); // close dropdown first
                  ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                }),
                SizedBox(width: 6),
                _LangBtn(label: 'عربي', active: locale.languageCode == 'ar', onTap: () {
                  Navigator.pop(context); // close dropdown first
                  ref.read(localeProvider.notifier).setLocale(const Locale('ar'));
                }),
              ]),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(value: 'signout', height: 40, child: Row(children: [
              Icon(Icons.logout, size: 18, color: context.colors.error), SizedBox(width: 10),
              Text(t.account_dropdown.log_out, style: TextStyle(color: context.colors.error, fontSize: 14)),
            ])),
          ],
          child: CircleAvatar(
            radius: 18, backgroundColor: context.colors.primary,
            backgroundImage: avatarUrl != null ? CachedNetworkImageProvider(avatarUrl) : null,
            child: avatarUrl == null ? Text(letter, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)) : null,
          ),
        );
      },
      orElse: () => IconButton(
        icon: Icon(Icons.person_outline, color: context.colors.textPrimary),
        onPressed: () => context.router.push(const SignInRoute()),
      ),
    );
  }
}

class _LangBtn extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _LangBtn({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: active ? context.colors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: active ? context.colors.primary : context.colors.border),
        ),
        child: Text(label,
            style: TextStyle(
              color: active ? Colors.white : context.colors.textSecondary,
              fontSize: 12,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            )),
      ),
    );
  }
}

// ── Home section header ────────────────────────────────────────────────────

class _HomeSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const _HomeSectionHeader({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
              color: context.colors.primary.withOpacity(0.7),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                t.common.view_all,
                style: TextStyle(
                  color: context.colors.primary.withOpacity(0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Discussions section — 2-3 PostCards from global hot feed ─────────────────

class _DiscussionsSection extends ConsumerWidget {
  const _DiscussionsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(_homeFeedPostsProvider);

    return postsAsync.when(
      loading: () => Column(
        children: List.generate(
          2,
          (_) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (posts) {
        if (posts.isEmpty) return const SizedBox.shrink();
        final preview = posts.take(2).toList();
        return Column(
          children: preview
              .map((post) => PostCard(
                    post: post,
                    onTap: () => context.router.push(
                      PostDetailRoute(
                        community: post.communitySlug.isNotEmpty
                            ? post.communitySlug
                            : 'all',
                        postId: post.id,
                      ),
                    ),
                    onAuthorTap: (userId) =>
                        context.router.push(UserProfileRoute(userId: userId)),
                    onVote: null,
                  ))
              .toList(),
        );
      },
    );
  }
}

// ── Stores section — horizontal scroll ───────────────────────────────────────

class _StoresSection extends ConsumerWidget {
  const _StoresSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storesAsync = ref.watch(_homeStoresProvider);

    return storesAsync.when(
      loading: () => SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: 4,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 80,
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (stores) {
        if (stores.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 108,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: stores.length,
            itemBuilder: (ctx, i) {
              final v = stores[i];
              final name = v['store_name'] as String? ?? 'Store';
              final logo = v['logo_url'] as String?;
              final slug = v['slug'] as String?;
              final rating = double.tryParse('${v['avg_rating'] ?? 0}') ?? 0;

              return GestureDetector(
                onTap: () {
                  if (slug != null) {
                    context.router.push(VendorProfileRoute(slug: slug));
                  }
                },
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.colors.primary,
                          border: Border.all(color: context.colors.border),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: logo != null
                            ? CachedNetworkImage(
                                imageUrl: logo,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => Center(
                                  child: Text(
                                    name.isNotEmpty
                                        ? name[0].toUpperCase()
                                        : 'S',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  name.isNotEmpty ? name[0].toUpperCase() : 'S',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.colors.textPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star_rounded, color: Colors.amber, size: 11),
                          const SizedBox(width: 2),
                          Text(
                            rating.toStringAsFixed(1),
                            style: TextStyle(
                              color: context.colors.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ── Bell icon with unread-notification badge ─────────────────────────────────
// Refreshes badge count:
//   • Instantly on foreground FCM (via notification_bus.dart)
//   • On app resume from background (WidgetsBindingObserver)
//   • On navigation to/from NotificationsScreen (invalidate in that screen)

class _BellIconWithBadge extends ConsumerStatefulWidget {
  const _BellIconWithBadge();

  @override
  ConsumerState<_BellIconWithBadge> createState() => _BellIconWithBadgeState();
}

class _BellIconWithBadgeState extends ConsumerState<_BellIconWithBadge>
    with WidgetsBindingObserver {

  void _onNewNotification() {
    if (mounted) ref.invalidate(notificationsProvider);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    addNotifRefreshListener(_onNewNotification);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    removeNotifRefreshListener(_onNewNotification);
    super.dispose();
  }

  /// Refresh badge when app returns from background (e.g. user tapped push
  /// notification from system tray — new notification may have arrived).
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      ref.invalidate(notificationsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = ref.watch(notificationsProvider).valueOrNull
            ?.where((n) => !n.isRead)
            .length ??
        0;
    return Badge(
      isLabelVisible: unreadCount > 0,
      label: Text('$unreadCount'),
      backgroundColor: context.colors.error,
      child: IconButton(
        icon: Icon(Icons.notifications_outlined,
            color: context.colors.textPrimary, size: 24),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        onPressed: () => context.router.push(const NotificationsRoute()),
      ),
    );
  }
}
