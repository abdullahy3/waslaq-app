import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../core/api/medusa_client.dart';
import '../../../../router/app_router.dart';

final _vendorsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final res = await MedusaClient.instance.get('/store/vendors');
  final vendors = res.data['vendors'] as List<dynamic>? ?? [];
  return vendors.map((v) => v as Map<String, dynamic>).toList();
});

@RoutePage()
class BrowseStoresScreen extends ConsumerWidget {
  const BrowseStoresScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendorsAsync = ref.watch(_vendorsProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(t.stores.title, style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background, iconTheme: IconThemeData(color: context.colors.textPrimary), elevation: 0,
      ),
      body: vendorsAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: context.colors.primary)),
        error: (e, _) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.error_outline, color: context.colors.error, size: 40),
          SizedBox(height: 8),
          TextButton(onPressed: () => ref.invalidate(_vendorsProvider), child: Text(t.stores.retry)),
        ])),
        data: (vendors) {
          if (vendors.isEmpty) {
            return Center(child: Text(t.stores.no_stores_yet, style: TextStyle(color: context.colors.textSecondary)));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(_vendorsProvider),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.85,
              ),
              itemCount: vendors.length,
              itemBuilder: (ctx, i) {
                final v = vendors[i];
                final name = v['store_name'] as String? ?? 'Store';
                final slug = v['slug'] as String? ?? '';
                final logo = v['logo_url'] as String?;
                final desc = v['description'] as String? ?? '';

                return GestureDetector(
                  onTap: () => context.router.push(VendorProfileRoute(slug: slug)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: context.colors.border),
                    ),
                    child: Column(children: [
                      SizedBox(height: 16),
                      // Logo
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.colors.primary.withValues(alpha: 0.1),
                          border: Border.all(color: context.colors.border),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: logo != null && logo.isNotEmpty
                            ? CachedNetworkImage(imageUrl: logo, memCacheWidth: 600, fit: BoxFit.cover, width: 56, height: 56,
                                errorWidget: (_, __, ___) => _initial(context, name))
                            : _initial(context, name),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(name, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                      SizedBox(height: 2),
                      Text('@$slug', style: TextStyle(color: context.colors.textMuted, fontSize: 11)),
                      if (desc.isNotEmpty) ...[
                        SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(desc, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: context.colors.textSecondary, fontSize: 11)),
                        ),
                      ],
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

  static Widget _initial(BuildContext context, String name) {
    return Center(child: Text(
      name.isNotEmpty ? name[0].toUpperCase() : '?',
      style: TextStyle(color: context.colors.primary, fontWeight: FontWeight.bold, fontSize: 22),
    ));
  }
}
