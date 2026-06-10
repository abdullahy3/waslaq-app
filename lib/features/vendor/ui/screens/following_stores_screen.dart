import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../router/app_router.dart';
import '../../../social/data/social_repository.dart';
import '../../../social/providers/social_providers.dart';

final followingStoresProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  return ref.read(socialRepositoryProvider).getFollowingStores();
});

@RoutePage()
class FollowingStoresScreen extends ConsumerStatefulWidget {
  const FollowingStoresScreen({super.key});

  @override
  ConsumerState<FollowingStoresScreen> createState() => _FollowingStoresScreenState();
}

class _FollowingStoresScreenState extends ConsumerState<FollowingStoresScreen> {
  // Track optimistic state changes per store
  final Map<String, bool> _followingOverride = {};
  final Map<String, bool> _notifOverride = {};

  Future<void> _handleUnfollow(String vendorCustomerId) async {
    setState(() => _followingOverride[vendorCustomerId] = false);
    await ref.read(socialRepositoryProvider).toggleStoreFollow(vendorCustomerId);
    ref.invalidate(followingStoresProvider);
  }

  Future<void> _handleNotifToggle(String vendorCustomerId, bool current) async {
    setState(() => _notifOverride[vendorCustomerId] = !current);
    await ref.read(socialRepositoryProvider).toggleStoreNotifications(vendorCustomerId);
    ref.invalidate(followingStoresProvider);
  }

  @override
  Widget build(BuildContext context) {
    final storesAsync = ref.watch(followingStoresProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        title: Text(
          'Following Stores',
          style: TextStyle(
            color: context.colors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: storesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.error_outline, color: context.colors.textMuted, size: 48),
            const SizedBox(height: 12),
            Text('Could not load followed stores',
                style: TextStyle(color: context.colors.textSecondary)),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => ref.invalidate(followingStoresProvider),
              child: const Text('Retry'),
            ),
          ]),
        ),
        data: (stores) {
          // Filter out unfollowed stores (optimistic)
          final visible = stores.where((s) {
            final cid = (s['vendorCustomerId'] ?? '') as String;
            return _followingOverride[cid] != false;
          }).toList();

          if (visible.isEmpty) {
            return Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.store_outlined, size: 72, color: context.colors.border),
                const SizedBox(height: 16),
                Text(
                  'No followed stores yet',
                  style: TextStyle(
                    color: context.colors.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Follow stores to see them here',
                  style: TextStyle(color: context.colors.textMuted, fontSize: 13),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => context.router.push(const BrowseStoresRoute()),
                  icon: const Icon(Icons.explore_outlined, size: 16),
                  label: const Text('Browse Stores'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ]),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(followingStoresProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: visible.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) {
                final item = visible[i];
                final vendor = (item['vendor'] ?? {}) as Map<String, dynamic>;
                final vendorCustomerId = (item['vendorCustomerId'] ?? '') as String;
                final slug = vendor['slug'] as String? ?? '';
                final storeName = vendor['store_name'] as String? ?? 'Store';
                final logo = vendor['logo_url'] as String?;
                final banner = vendor['banner_url'] as String?;
                final notifEnabled = _notifOverride[vendorCustomerId]
                    ?? (item['notificationsEnabled'] as bool? ?? true);

                return GestureDetector(
                  onTap: () => context.router.push(VendorProfileRoute(slug: slug)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.colors.border),
                    ),
                    child: Column(children: [
                      // Mini banner
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                        child: SizedBox(
                          height: 70,
                          width: double.infinity,
                          child: banner != null
                              ? CachedNetworkImage(
                                  imageUrl: banner,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => _gradientBanner(context),
                                )
                              : _gradientBanner(context),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                        child: Row(children: [
                          // Logo (overlaps banner)
                          Transform.translate(
                            offset: const Offset(0, -20),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: context.colors.surface, width: 2),
                                color: context.colors.surface,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: logo != null
                                  ? CachedNetworkImage(
                                      imageUrl: logo,
                                      fit: BoxFit.cover,
                                      errorWidget: (_, __, ___) => _initial(storeName, context),
                                    )
                                  : _initial(storeName, context),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Transform.translate(
                              offset: const Offset(0, -8),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(
                                  storeName,
                                  style: TextStyle(
                                    color: context.colors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  '@$slug',
                                  style: TextStyle(
                                    color: context.colors.textMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          // Action buttons
                          Row(mainAxisSize: MainAxisSize.min, children: [
                            // Notification toggle bell
                            IconButton(
                              onPressed: () => _handleNotifToggle(vendorCustomerId, notifEnabled),
                              tooltip: notifEnabled ? 'Turn off notifications' : 'Turn on notifications',
                              icon: Icon(
                                notifEnabled
                                    ? Icons.notifications_active_rounded
                                    : Icons.notifications_off_outlined,
                                color: notifEnabled
                                    ? context.colors.primary
                                    : context.colors.textMuted,
                                size: 22,
                              ),
                            ),
                            // Unfollow button
                            TextButton.icon(
                              onPressed: () => _showUnfollowDialog(context, storeName, vendorCustomerId),
                              icon: Icon(Icons.person_remove_outlined,
                                  size: 14, color: context.colors.textMuted),
                              label: Text(
                                'Unfollow',
                                style: TextStyle(
                                  color: context.colors.textMuted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                backgroundColor: context.colors.surfaceVariant,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                minimumSize: Size.zero,
                              ),
                            ),
                          ]),
                        ]),
                      ),
                    ]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showUnfollowDialog(BuildContext context, String storeName, String vendorCustomerId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Unfollow $storeName?',
            style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold)),
        content: Text(
          "You'll stop receiving new product notifications from this store.",
          style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: context.colors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _handleUnfollow(vendorCustomerId);
            },
            child: Text('Unfollow', style: TextStyle(color: context.colors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _gradientBanner(BuildContext context) => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF7C3AED), Color(0xFF4C1D95)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  );

  Widget _initial(String name, BuildContext context) => Container(
    decoration: BoxDecoration(
      color: context.colors.primary.withValues(alpha: 0.1),
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'S',
        style: TextStyle(
          color: context.colors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    ),
  );
}
