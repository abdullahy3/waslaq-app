// lib/features/product/data/product_repository.dart
// Cache strategy: check Isar → render cached → fetch fresh in background → update cache
// Price rule: NEVER divide or multiply — amounts are raw ILS from API

import 'dart:convert';
import 'package:isar/isar.dart';
import '../../../core/api/medusa_client.dart';
import '../../../core/storage/isar_service.dart';
import '../../../core/storage/isar/product_cache.dart';
import '../../../core/storage/isar/category_cache.dart';
import '../../../core/crashlytics/crash_reporter.dart';
import 'models/product_model.dart';
import 'models/category_model.dart';

class ProductRepository {
  ProductRepository._();

  // ---------------------------------------------------------------------------
  // Products
  // ---------------------------------------------------------------------------

  /// Fetch product listing. Mirrors GET /store/products.
  ///
  /// For the first page with no filters: returns cached data immediately
  /// (if within TTL) and fires a background refresh. For filtered/paginated
  /// requests: always fetches live.
  static Future<List<ProductModel>> getProducts({
    int limit = 20,
    int offset = 0,
    String? categoryId,
    String? query,
    String? order,
  }) async {
    final isFirstPageNoFilter =
        offset == 0 && categoryId == null && query == null;

    if (isFirstPageNoFilter) {
      final isar = await IsarService.db;
      final cached = await isar.productCaches
          .filter()
          .cachedAtGreaterThan(
            DateTime.now().subtract(const Duration(minutes: 5)),
          )
          .findAll();

      if (cached.isNotEmpty) {
        // Return cached immediately; refresh in background (fire-and-forget)
        _fetchAndCacheProducts(limit: limit, offset: offset)
            .catchError((e, st) {
          CrashReporter.reportError(e, st,
              reason: 'Background product refresh failed');
          return <ProductModel>[];
        });
        return cached
            .map((c) =>
                ProductModel.fromJson(jsonDecode(c.cachedJson) as Map<String, dynamic>))
            .toList();
      }
    }

    return _fetchAndCacheProducts(
      limit: limit,
      offset: offset,
      categoryId: categoryId,
      query: query,
      order: order,
    );
  }

  static Future<List<ProductModel>> _fetchAndCacheProducts({
    int limit = 20,
    int offset = 0,
    String? categoryId,
    String? query,
    String? order,
  }) async {
    // Fields include calculated_price for variants (raw ILS — do NOT divide)
    // region_id is required by Medusa for price calculation
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      'fields':
          '*variants,*variants.calculated_price,*images,*categories,+metadata',
      'region_id': 'reg_01KQ6035AK6FMA4R1XJ76RTPGH',
      if (categoryId != null) 'category_id[]': categoryId,
      if (query != null) 'q': query,
      if (order != null) 'order': order,
    };

    final response = await MedusaClient.instance.get(
      '/store/products',
      queryParameters: queryParams,
    );

    final rawList = response.data['products'] as List;
    final products = rawList
        .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
        .toList();

    // Cache first page with no filters only
    if (offset == 0 && categoryId == null && query == null) {
      _writeProdcutCache(products, rawList).catchError((e, st) {
        CrashReporter.reportError(e, st,
            reason: 'ProductCache write failed');
      });
    }

    return products;
  }

  static Future<void> _writeProdcutCache(
    List<ProductModel> products,
    List<dynamic> rawList,
  ) async {
    final isar = await IsarService.db;
    // Build a map of id → raw JSON for O(1) lookup when building cache entries
    final rawMap = {
      for (final raw in rawList) (raw as Map<String, dynamic>)['id'] as String: raw,
    };

    await isar.writeTxn(() async {
      await isar.productCaches.clear();
      await isar.productCaches.putAll(
        products.map((p) {
          final entry = ProductCache()
            ..productId = p.id
            ..title = p.title
            ..thumbnail = p.thumbnail
            ..price = p.lowestPrice ?? 0.0
            ..vendorName = p.vendor?.storeName
            ..vendorSlug = p.vendor?.slug
            ..categoryId = p.categoryId
            ..cachedJson = jsonEncode(rawMap[p.id])
            ..cachedAt = DateTime.now();
          return entry;
        }).toList(),
      );
    });
  }

  /// Fetch a single product by ID or handle. Mirrors GET /store/products/:id.
  static Future<ProductModel> getProductById(String id) async {
    final bool isId = id.startsWith('prod_');
    final String path = isId ? '/store/products/$id' : '/store/products';
    final queryParams = {
      'fields':
          '*variants,*variants.calculated_price,*images,*categories,+metadata',
      'region_id': 'reg_01KQ6035AK6FMA4R1XJ76RTPGH',
      if (!isId) 'handle': id,
    };

    final response = await MedusaClient.instance.get(
      path,
      queryParameters: queryParams,
    );

    final Map<String, dynamic> productJson;
    if (isId) {
      productJson = Map<String, dynamic>.from(response.data['product'] as Map);
    } else {
      final list = response.data['products'] as List;
      if (list.isEmpty) {
        throw Exception('Product not found by handle: $id');
      }
      productJson = Map<String, dynamic>.from(list.first as Map);
    }

    final String realId = productJson['id'] as String;
    try {
      final vendorResponse = await MedusaClient.instance.get('/store/products/$realId/vendor');
      if (vendorResponse.data != null && vendorResponse.data['vendor'] != null) {
        productJson['vendor'] = vendorResponse.data['vendor'];
      }
    } catch (e, st) {
      CrashReporter.reportError(e, st, reason: 'Failed to fetch vendor for product $realId');
    }
    return ProductModel.fromJson(productJson);
  }

  // ---------------------------------------------------------------------------
  // Categories
  // ---------------------------------------------------------------------------

  /// Fetch product categories. Mirrors GET /store/product-categories.
  ///
  /// Caches for 1 hour. Returns cached data immediately if fresh; otherwise
  /// fetches live and updates cache.
  static Future<List<CategoryModel>> getCategories() async {
    final isar = await IsarService.db;

    final cached = await isar.categoryCaches
        .filter()
        .cachedAtGreaterThan(
          DateTime.now().subtract(const Duration(hours: 1)),
        )
        .findAll();

    if (cached.isNotEmpty) {
      // Return cached; fire background refresh
      _fetchAndCacheCategories().catchError((e, st) {
        CrashReporter.reportError(e, st,
            reason: 'Background category refresh failed');
        return <CategoryModel>[];
      });
      return cached
          .map((c) => CategoryModel.fromJson(
                jsonDecode(c.cachedJson) as Map<String, dynamic>,
              ))
          .toList();
    }

    return _fetchAndCacheCategories();
  }

  static Future<List<CategoryModel>> _fetchAndCacheCategories() async {
    // Field names from ~/waslaq-storefront/src/lib/data/categories.ts:
    //   fields: "*category_children, *parent_category, *parent_category.parent_category"
    // getAllCategoriesWithChildren() also passes include_ancestors_tree: true
    final response = await MedusaClient.instance.get(
      '/store/product-categories',
      queryParameters: {
        'fields':
            '*category_children,*parent_category,*parent_category.parent_category',
        'include_ancestors_tree': true,
        'limit': 100,
      },
    );

    final rawList = response.data['product_categories'] as List;
    final categories = rawList
        .map((c) => CategoryModel.fromJson(c as Map<String, dynamic>))
        .toList();

    _writeCategoryCache(categories, rawList).catchError((e, st) {
      CrashReporter.reportError(e, st,
          reason: 'CategoryCache write failed');
    });

    return categories;
  }

  static Future<void> _writeCategoryCache(
    List<CategoryModel> categories,
    List<dynamic> rawList,
  ) async {
    final isar = await IsarService.db;
    final rawMap = {
      for (final raw in rawList) (raw as Map<String, dynamic>)['id'] as String: raw,
    };

    await isar.writeTxn(() async {
      await isar.categoryCaches.clear();
      await isar.categoryCaches.putAll(
        categories.map((c) {
          final entry = CategoryCache()
            ..categoryId = c.id
            ..name = c.name
            ..handle = c.handle
            ..parentId = c.parentId
            ..cachedJson = jsonEncode(rawMap[c.id])
            ..cachedAt = DateTime.now();
          return entry;
        }).toList(),
      );
    });
  }

  /// Fetch products with total count for paginated store grid.
  static Future<ProductsResponse> getProductsPaginated({
    int limit = 20,
    int offset = 0,
    String? categoryId,
    String? query,
    String? order,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      'fields':
          '*variants,*variants.calculated_price,*images,*categories,+metadata',
      'region_id': 'reg_01KQ6035AK6FMA4R1XJ76RTPGH',
      if (categoryId != null) 'category_id[]': categoryId,
      if (query != null) 'q': query,
      if (order != null) 'order': order,
    };

    final response = await MedusaClient.instance.get(
      '/store/products',
      queryParameters: queryParams,
    );

    final rawList = response.data['products'] as List;
    final products = rawList
        .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
        .toList();
    final count = response.data['count'] as int? ?? 0;

    return ProductsResponse(products: products, count: count);
  }
}

class ProductsResponse {
  final List<ProductModel> products;
  final int count;

  ProductsResponse({required this.products, required this.count});
}
