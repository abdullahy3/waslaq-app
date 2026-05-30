// lib/features/account/ui/screens/saved_items_screen.dart

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../product/providers/product_provider.dart';
import '../../../../router/app_router.dart';
import '../../providers/account_providers.dart';
import '../../data/models/saved_item_model.dart';

@RoutePage()
class SavedItemsScreen extends ConsumerStatefulWidget {
  const SavedItemsScreen({super.key});

  @override
  ConsumerState<SavedItemsScreen> createState() => _SavedItemsScreenState();
}

class _SavedItemsScreenState extends ConsumerState<SavedItemsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final savedAsync = ref.watch(savedItemsProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(t.saved_items.title,
            style: TextStyle(
                color: context.colors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(49),
          child: TabBar(
            controller: _tabs,
            labelColor: context.colors.primary,
            unselectedLabelColor: context.colors.textSecondary,
            indicatorColor: context.colors.primary,
            tabs: [
              Tab(text: t.saved_items.products_tab),
              Tab(text: t.saved_items.posts_tab),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(savedItemsProvider),
        child: savedAsync.when(
          loading: () => _Skeleton(),
          error: (e, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    size: 48, color: context.colors.error),
                SizedBox(height: 12),
                Text(t.saved_items.failed_load,
                    style: TextStyle(color: context.colors.textPrimary)),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => ref.invalidate(savedItemsProvider),
                  child: Text(t.saved_items.retry),
                ),
              ],
            ),
          ),
          data: (saved) => TabBarView(
            controller: _tabs,
            children: [
              _SavedProductsTab(productIds: saved.savedProductIds),
              _SavedPostsTab(posts: saved.posts),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Saved Products tab ───────────────────────────────────────────────────────

class _SavedProductsTab extends ConsumerWidget {
  final List<String> productIds;
  const _SavedProductsTab({required this.productIds});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (productIds.isEmpty) {
      return _EmptyState(
        icon: Icons.favorite_border,
        message: t.saved_items.no_products,
        sub: t.saved_items.no_products_sub,
      );
    }

    // Fetch all products and filter to saved ones
    final productsAsync = ref.watch(productListProvider());
    return productsAsync.when(
      loading: () => _Skeleton(),
      error: (_, __) => _EmptyState(
        icon: Icons.error_outline,
        message: t.saved_items.could_not_load,
      ),
      data: (products) {
        final saved =
            products.where((p) => productIds.contains(p.id)).toList();
        if (saved.isEmpty) {
          return _EmptyState(
            icon: Icons.favorite_border,
            message: t.saved_items.no_products,
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.68,
          ),
          itemCount: saved.length,
          itemBuilder: (_, i) => ProductCard(product: saved[i]),
        );
      },
    );
  }
}

// ─── Saved Posts tab ──────────────────────────────────────────────────────────

class _SavedPostsTab extends StatelessWidget {
  final List<SavedPostModel> posts;
  const _SavedPostsTab({required this.posts});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return _EmptyState(
        icon: Icons.bookmark_border,
        message: t.saved_items.no_posts,
        sub: t.saved_items.no_posts_sub,
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: posts.length,
      separatorBuilder: (_, __) => SizedBox(height: 10),
      itemBuilder: (context, i) => _SavedPostTile(post: posts[i]),
    );
  }
}

class _SavedPostTile extends StatelessWidget {
  final SavedPostModel post;
  const _SavedPostTile({required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.push(PostDetailRoute(
        community: post.communitySlug,
        postId: post.id,
      )),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.mediaUrls.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: post.mediaUrls.first,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    width: 60,
                    height: 60,
                    color: context.colors.surfaceVariant,
                    child: Icon(Icons.image_outlined,
                        color: context.colors.textMuted),
                  ),
                ),
              ),
            if (post.mediaUrls.isNotEmpty) SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: TextStyle(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Text(
                    'r/${post.communityName}',
                    style: TextStyle(
                        color: context.colors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ],
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

// ─── Shared ───────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? sub;
  const _EmptyState({required this.icon, required this.message, this.sub});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: context.colors.border),
          SizedBox(height: 16),
          Text(message,
              style: TextStyle(
                  color: context.colors.textSecondary, fontSize: 16)),
          if (sub != null) ...[
            SizedBox(height: 8),
            Text(sub!,
                style: TextStyle(
                    color: context.colors.textMuted, fontSize: 13),
                textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.surfaceVariant,
      highlightColor: context.colors.border,
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.68,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
