import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../core/api/medusa_client.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../router/app_router.dart';

/// Fetches all categories with children from Medusa
final _categoriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final res = await MedusaClient.instance.get(
    '/store/product-categories',
    queryParameters: {'limit': 100, 'include_descendants_tree': true},
  );
  final cats = res.data['product_categories'] as List<dynamic>? ?? [];
  // Return only root categories (parent categories)
  return cats
      .map((c) => c as Map<String, dynamic>)
      .where((c) => c['parent_category_id'] == null)
      .toList();
});

@RoutePage()
class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});
  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  int _selectedIndex = 0;

  String _catName(Map<String, dynamic> cat, String lang) {
    final meta = cat['metadata'] as Map<String, dynamic>?;
    // Arabic: use name_ar from metadata, English: use name (Medusa default)
    if (lang == 'ar') return meta?['name_ar'] as String? ?? cat['name'] as String? ?? '';
    return cat['name'] as String? ?? meta?['name_ar'] as String? ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final catsAsync = ref.watch(_categoriesProvider);
    final lang = ref.watch(localeProvider).languageCode;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(t.common.categories,
            style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: context.colors.border),
        ),
      ),
      body: catsAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: context.colors.primary)),
        error: (e, _) => Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.error_outline, color: context.colors.error, size: 40),
            SizedBox(height: 12),
            Text(t.common.failed_load_categories, style: TextStyle(color: context.colors.textSecondary)),
            SizedBox(height: 8),
            TextButton(
              onPressed: () => ref.invalidate(_categoriesProvider),
              child: Text(t.common.retry),
            ),
          ]),
        ),
        data: (rootCats) {
          if (rootCats.isEmpty) {
            return Center(child: Text(t.common.no_categories, style: TextStyle(color: context.colors.textSecondary)));
          }
          if (_selectedIndex >= rootCats.length) _selectedIndex = 0;
          final selected = rootCats[_selectedIndex];
          final children = (selected['category_children'] as List<dynamic>?) ?? [];

          return Row(children: [
            // LEFT SIDEBAR — parent categories
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.28,
              child: Container(
                color: context.colors.background,
                child: ListView.builder(
                  itemCount: rootCats.length,
                  itemBuilder: (ctx, i) {
                    final cat = rootCats[i];
                    final isActive = i == _selectedIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIndex = i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        decoration: BoxDecoration(
                          color: isActive ? context.colors.surface : Colors.transparent,
                          border: Border(
                            left: BorderSide(
                              color: isActive ? context.colors.primary : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                        child: Text(
                          _catName(cat, lang),
                          style: TextStyle(
                            color: isActive ? context.colors.primary : context.colors.textSecondary,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Divider
            Container(width: 0.5, color: context.colors.border),

            // RIGHT PANEL — subcategories grid
            Expanded(
              child: Container(
                color: context.colors.surface,
                child: children.isEmpty
                    ? Center(
                        child: Text(t.common.no_subcategories,
                            style: TextStyle(color: context.colors.textMuted, fontSize: 13, fontStyle: FontStyle.italic)))
                    : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: children.length,
                        itemBuilder: (ctx, i) {
                          final sub = children[i] as Map<String, dynamic>;
                          final name = _catName(sub, lang);
                          final meta = sub['metadata'] as Map<String, dynamic>?;
                          final imageUrl = meta?['image'] as String?;
                          final handle = sub['handle'] as String? ?? '';
                          final parentHandle = selected['handle'] as String? ?? '';
                          final id = sub['id'] as String? ?? '';

                          return GestureDetector(
                            onTap: () {
                              // Navigate to products filtered by this subcategory
                              context.router.push(StoreRoute(categoryId: id));
                            },
                            child: Column(children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: context.colors.primary.withValues(alpha: 0.06),
                                    border: Border.all(color: context.colors.border.withValues(alpha: 0.5)),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: imageUrl != null && imageUrl.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                          placeholder: (_, __) => Center(
                                            child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900,
                                                    color: context.colors.primary.withValues(alpha: 0.2))),
                                          ),
                                          errorWidget: (_, __, ___) => Center(
                                            child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900,
                                                    color: context.colors.primary.withValues(alpha: 0.2))),
                                          ),
                                        )
                                      : Center(
                                          child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900,
                                                  color: context.colors.primary.withValues(alpha: 0.2))),
                                        ),
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(name,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: context.colors.textPrimary, fontSize: 11,
                                      fontWeight: FontWeight.w500)),
                            ]),
                          );
                        },
                      ),
              ),
            ),
          ]);
        },
      ),
    );
  }
}
