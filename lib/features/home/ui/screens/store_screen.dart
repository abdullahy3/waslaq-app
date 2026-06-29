import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../shared/utils/ils_formatter.dart';
import '../../../../core/api/medusa_client.dart';
import '../../../../router/app_router.dart';

@RoutePage()
class StoreScreen extends ConsumerStatefulWidget {
  final String? categoryId;
  const StoreScreen({super.key, this.categoryId});
  @override
  ConsumerState<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen> {
  List<dynamic> _products = [];
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _allCategories = [];
  bool _loading = true;
  String _sortBy = 'created_at'; // created_at, price_asc, price_desc
  String? _selectedCategoryId;
  int _offset = 0;
  bool _hasMore = true;
  bool _loadingMore = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.categoryId;
    _scrollController.addListener(_onScroll);
    _loadCategories();
    _loadProducts(reset: true);
  }

  @override
  void dispose() { _scrollController.dispose(); super.dispose(); }

  void _onScroll() {
    if (_loadingMore || !_hasMore) return;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 400) {
      _loadProducts(reset: false);
    }
  }

  Future<void> _loadCategories() async {
    try {
      final res = await MedusaClient.instance.get('/store/product-categories',
          queryParameters: {'limit': 100, 'include_descendants_tree': true});
      final rawCats = (res.data['product_categories'] as List<dynamic>? ?? [])
          .map((c) => c as Map<String, dynamic>).toList();
      final cats = rawCats.where((c) => c['parent_category_id'] == null).toList();
      if (mounted) {
        setState(() {
          _allCategories = rawCats;
          _categories = cats;
        });
      }
    } catch (_) {}
  }

  Future<void> _loadProducts({required bool reset}) async {
    if (reset) { _offset = 0; _hasMore = true; setState(() => _loading = true); }
    else { setState(() => _loadingMore = true); }

    try {
      final params = <String, dynamic>{
        'limit': 20, 'offset': _offset,
        'region_id': 'reg_01KQ6035AK6FMA4R1XJ76RTPGH',
        'fields': '*variants.calculated_price',
      };
      if (_selectedCategoryId != null) params['category_id[0]'] = _selectedCategoryId;
      if (_sortBy == 'created_at') params['order'] = 'created_at';
      if (_sortBy == 'price_asc') params['order'] = 'variants.calculated_price.calculated_amount';
      if (_sortBy == 'price_desc') params['order'] = '-variants.calculated_price.calculated_amount';

      final res = await MedusaClient.instance.get('/store/products', queryParameters: params);
      final newProducts = res.data['products'] as List<dynamic>? ?? [];
      final count = res.data['count'] as int? ?? 0;

      if (mounted) {
        setState(() {
        if (reset) {
          _products = newProducts;
        } else {
          _products.addAll(newProducts);
        }
        _offset += newProducts.length;
        _hasMore = _products.length < count;
        _loading = false; _loadingMore = false;
      });
      }
    } catch (e) {
      if (mounted) setState(() { _loading = false; _loadingMore = false; });
    }
  }

  void _onSortChanged(String sort) {
    if (_sortBy == sort) return;
    setState(() => _sortBy = sort);
    _loadProducts(reset: true);
  }

  void _onCategoryChanged(String? catId) {
    setState(() => _selectedCategoryId = catId);
    _loadProducts(reset: true);
  }

  String _catName(Map<String, dynamic> cat, String lang) {
    final meta = cat['metadata'] as Map<String, dynamic>?;
    if (lang == 'ar') return meta?['name_ar'] as String? ?? cat['name'] as String? ?? '';
    return cat['name'] as String? ?? meta?['name_ar'] as String? ?? '';
  }

  String? get _selectedCategoryName {
    if (_selectedCategoryId == null) return null;
    final lang = ref.read(localeProvider).languageCode;
    final found = _allCategories.firstWhere(
      (c) => c['id'] == _selectedCategoryId,
      orElse: () => <String, dynamic>{},
    );
    if (found.isEmpty) return null;
    return _catName(found, lang);
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(localeProvider).languageCode;
    final activeCatName = _selectedCategoryName;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: activeCatName == null 
          ? Text(t.store.title, style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(t.store.title, style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                Text(activeCatName, style: TextStyle(color: context.colors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
        backgroundColor: context.colors.background, iconTheme: IconThemeData(color: context.colors.textPrimary), elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.search, color: context.colors.textSecondary),
              onPressed: () => context.router.push(const SearchRoute())),
        ],
      ),
      body: Column(children: [
        // ─── CATEGORY FILTER (horizontal scroll) ─────────
        if (_categories.isNotEmpty) SizedBox(height: 40, child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: [
            _FilterChip(label: t.store.all_categories, active: _selectedCategoryId == null,
                onTap: () => _onCategoryChanged(null)),
            ..._categories.map((c) => _FilterChip(
              label: _catName(c, lang),
              active: _selectedCategoryId == c['id'],
              onTap: () => _onCategoryChanged(c['id'] as String),
            )),
          ],
        )),
        SizedBox(height: 8),

        // ─── SORT BAR ────────────────────────────────────
        Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(children: [
            Text(t.store.products_count(count: _products.length.toString()), style: TextStyle(color: context.colors.textMuted, fontSize: 12)),
            const Spacer(),
            PopupMenuButton<String>(
              onSelected: _onSortChanged,
              color: context.colors.surface,
              child: Row(children: [
                Icon(Icons.sort, color: context.colors.textSecondary, size: 16),
                SizedBox(width: 4),
                Text(_sortLabel(), style: TextStyle(color: context.colors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                Icon(Icons.arrow_drop_down, color: context.colors.textSecondary, size: 16),
              ]),
              itemBuilder: (_) => [
                PopupMenuItem(value: 'created_at', child: Text(t.store.latest_arrivals, style: TextStyle(color: context.colors.textPrimary, fontSize: 13))),
                PopupMenuItem(value: 'price_asc', child: Text(t.store.price_low_high, style: TextStyle(color: context.colors.textPrimary, fontSize: 13))),
                PopupMenuItem(value: 'price_desc', child: Text(t.store.price_high_low, style: TextStyle(color: context.colors.textPrimary, fontSize: 13))),
              ],
            ),
          ])),
        SizedBox(height: 8),

        // ─── PRODUCT GRID ────────────────────────────────
        Expanded(child: _loading
            ? Center(child: CircularProgressIndicator(color: context.colors.primary))
            : _products.isEmpty
                ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.inventory_2_outlined, size: 48, color: context.colors.border),
                    SizedBox(height: 12),
                    Text(t.store.no_products_found, style: TextStyle(color: context.colors.textSecondary)),
                  ]))
                : RefreshIndicator(
                    onRefresh: () => _loadProducts(reset: true),
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.62),
                      itemCount: _products.length + (_loadingMore ? 2 : 0),
                      itemBuilder: (ctx, i) {
                        if (i >= _products.length) {
                          return Center(child: Padding(padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(color: context.colors.primary, strokeWidth: 2)));
                        }
                        final p = _products[i] as Map<String, dynamic>;
                        final id = p['id'] as String?;
                        final title = p['title'] as String? ?? '';
                        final thumb = p['thumbnail'] as String?;
                        final variants = p['variants'] as List<dynamic>? ?? [];
                        final priceObj = variants.isNotEmpty
                            ? (variants[0] as Map<String, dynamic>)['calculated_price'] as Map<String, dynamic>?
                            : null;
                        final price = priceObj?['calculated_amount'];

                        return GestureDetector(
                          onTap: () { if (id != null) context.router.push(ProductRoute(id: id)); },
                          child: Container(
                            decoration: BoxDecoration(color: context.colors.surface, borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: context.colors.border)),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Expanded(child: ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
                                child: thumb != null
                                    ? CachedNetworkImage(imageUrl: thumb, memCacheWidth: 600, fit: BoxFit.cover, width: double.infinity,
                                        errorWidget: (_, __, ___) => Container(color: context.colors.surfaceVariant,
                                            child: Center(child: Icon(Icons.image_outlined, color: context.colors.textMuted, size: 32))))
                                    : Container(color: context.colors.surfaceVariant,
                                        child: Center(child: Icon(Icons.image_outlined, color: context.colors.textMuted, size: 32))))),
                              Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(title, maxLines: 2, overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: context.colors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
                                SizedBox(height: 4),
                                if (price != null)
                                  Text(ILSFormatter.format(price is num ? price.toDouble() : double.tryParse('$price') ?? 0),
                                      style: TextStyle(color: context.colors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
                              ])),
                            ]),
                          ),
                        );
                      },
                    ),
                  )),
      ]),
    );
  }

  String _sortLabel() => switch (_sortBy) {
    'price_asc' => t.store.price_low_high,
    'price_desc' => t.store.price_high_low,
    _ => t.common.latest,
  };
}

class _FilterChip extends StatelessWidget {
  final String label; final bool active; final VoidCallback onTap;
  const _FilterChip({required this.label, required this.active, required this.onTap});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 6),
    child: GestureDetector(onTap: onTap, child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active ? context.colors.primary : context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: active ? context.colors.primary : context.colors.border)),
      child: Text(label, style: TextStyle(color: active ? Colors.white : context.colors.textSecondary,
          fontSize: 12, fontWeight: FontWeight.w600)),
    )),
  );
}
