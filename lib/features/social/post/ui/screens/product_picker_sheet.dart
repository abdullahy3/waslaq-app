import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../features/account/providers/account_providers.dart';
import '../../../../../features/product/data/product_repository.dart';
import '../../../../../features/product/data/models/product_model.dart';
import '../../../../../shared/theme/app_colors.dart';

class ProductPickerSheet extends ConsumerStatefulWidget {
  const ProductPickerSheet({super.key});

  @override
  ConsumerState<ProductPickerSheet> createState() => _ProductPickerSheetState();
}

class _ProductPickerSheetState extends ConsumerState<ProductPickerSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchCtrl = TextEditingController();

  List<ProductModel> _allProducts = [];
  List<ProductModel> _filtered = [];
  bool _loading = true;
  bool _loadingMore = false;
  int _offset = 0;
  static const int _pageSize = 20;
  bool _hasMore = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadProducts();
    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final q = _searchCtrl.text.trim();
    if (q == _query) return;
    _query = q;
    if (q.isEmpty) {
      setState(() => _filtered = List.of(_allProducts));
    } else {
      setState(() {
        _filtered = _allProducts
            .where((p) => p.title.toLowerCase().contains(q.toLowerCase()))
            .toList();
      });
    }
  }

  Future<void> _loadProducts({bool reset = false}) async {
    if (reset) {
      setState(() { _offset = 0; _hasMore = true; _loading = true; _allProducts = []; _filtered = []; });
    }
    try {
      final results = await ProductRepository.getProducts(
        limit: _pageSize,
        offset: _offset,
        query: _query.isNotEmpty ? _query : null,
      );
      setState(() {
        _allProducts = [..._allProducts, ...results];
        _filtered = _query.isEmpty
            ? List.of(_allProducts)
            : _allProducts.where((p) => p.title.toLowerCase().contains(_query.toLowerCase())).toList();
        _hasMore = results.length == _pageSize;
        _offset += results.length;
        _loading = false;
        _loadingMore = false;
      });
    } catch (_) {
      setState(() { _loading = false; _loadingMore = false; });
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || !_hasMore || _query.isNotEmpty) return;
    setState(() => _loadingMore = true);
    await _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final savedAsync = ref.watch(savedItemsProvider);
    final savedIds = savedAsync.maybeWhen(data: (s) => s.savedProductIds, orElse: () => <String>[]);
    final savedProducts = _allProducts.where((p) => savedIds.contains(p.id)).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'اختر منتجاً',
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: context.colors.textMuted, size: 22),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              style: TextStyle(color: context.colors.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'ابحث عن منتج...',
                hintStyle: TextStyle(color: context.colors.textMuted, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: context.colors.textMuted, size: 20),
                filled: true,
                fillColor: context.colors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          // Tabs
          TabBar(
            controller: _tabController,
            labelColor: context.colors.primary,
            unselectedLabelColor: context.colors.textMuted,
            indicatorColor: context.colors.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(text: 'كل المنتجات'),
              Tab(text: 'المحفوظة'),
            ],
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProductGrid(_filtered),
                _buildProductGrid(savedProducts),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<ProductModel> products) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (products.isEmpty) {
      return Center(
        child: Text(
          'لا توجد منتجات',
          style: TextStyle(color: context.colors.textMuted, fontSize: 14),
        ),
      );
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n is ScrollEndNotification && n.metrics.pixels >= n.metrics.maxScrollExtent - 100) {
          _loadMore();
        }
        return false;
      },
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.72,
        ),
        itemCount: products.length + (_loadingMore ? 1 : 0),
        itemBuilder: (ctx, i) {
          if (i == products.length) {
            return const Center(child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ));
          }
          return _ProductCard(
            product: products[i],
            onTap: () => Navigator.pop(context, products[i]),
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final price = product.lowestPrice;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              child: AspectRatio(
                aspectRatio: 1,
                child: product.thumbnail != null
                    ? CachedNetworkImage(
                        imageUrl: product.thumbnail!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(color: context.colors.surfaceVariant),
                        errorWidget: (_, __, ___) => Container(
                          color: context.colors.surfaceVariant,
                          child: Icon(Icons.image_outlined, color: context.colors.textMuted),
                        ),
                      )
                    : Container(
                        color: context.colors.surfaceVariant,
                        child: Icon(Icons.image_outlined, color: context.colors.textMuted),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (price != null)
                    Text(
                      '₪${price.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: context.colors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
