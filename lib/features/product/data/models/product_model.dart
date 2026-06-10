// lib/features/product/data/models/product_model.dart
// Price rule: NEVER divide or multiply — calculated_amount is raw ILS from API

class ProductModel {
  final String id;
  final String title;
  final String? description;
  final String? thumbnail;
  final String? handle;
  final List<ProductVariant> variants;
  final List<ProductImage> images;
  final String? categoryId;
  final String? categoryName;
  final ProductVendor? vendor;
  final bool isDigital;
  final double? avgRating;
  final int? soldCount;

  const ProductModel({
    required this.id,
    required this.title,
    this.description,
    this.thumbnail,
    this.handle,
    required this.variants,
    required this.images,
    this.categoryId,
    this.categoryName,
    this.vendor,
    this.isDigital = false,
    this.avgRating,
    this.soldCount,
  });

  /// Get lowest price across all variants.
  /// Value is raw ILS — do NOT divide by 100.
  /// Source: variant.calculated_price.calculated_amount
  double? get lowestPrice {
    final prices = variants
        .where((v) => v.price != null)
        .map((v) => v.price!)
        .toList();
    if (prices.isEmpty) return null;
    prices.sort();
    return prices.first;
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Variants — may come as null or empty list
    final variantsList = (json['variants'] as List? ?? [])
        .map((v) => ProductVariant.fromJson(v as Map<String, dynamic>))
        .toList();

    // Images — array of {id, url}
    final imagesList = (json['images'] as List? ?? [])
        .map((i) => ProductImage.fromJson(i as Map<String, dynamic>))
        .toList();

    // Vendor — nested object from custom backend join (store/vendors route)
    ProductVendor? vendor;
    if (json['vendor'] != null) {
      vendor = ProductVendor.fromJson(json['vendor'] as Map<String, dynamic>);
    }

    // isDigital — product-card checks metadata.type OR type.value
    // Source: ~/waslaq-storefront/src/modules/home/components/product-card/index.tsx
    final metadata = json['metadata'] as Map<String, dynamic>?;
    final typeObj = json['type'] as Map<String, dynamic>?;
    final isDigital =
        metadata?['type'] == 'digital' ||
        typeObj?['value'] == 'digital' ||
        metadata?['is_digital'] == true ||
        metadata?['is_digital'] == 'true';

    final avgRating = (json['avg_rating'] as num?)?.toDouble()
        ?? (metadata?['avg_rating'] as num?)?.toDouble();
    final soldCount = (json['sales_count'] as num?)?.toInt()
        ?? (metadata?['sales_count'] as num?)?.toInt()
        ?? (json['sold_count'] as num?)?.toInt();

    // Categories — first element from categories array
    final categories = json['categories'] as List?;
    final firstCat = categories?.isNotEmpty == true
        ? categories!.first as Map<String, dynamic>?
        : null;

    return ProductModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      thumbnail: json['thumbnail'] as String?,
      handle: json['handle'] as String?,
      variants: variantsList,
      images: imagesList,
      categoryId: firstCat?['id'] as String?,
      categoryName: firstCat?['name'] as String?,
      vendor: vendor,
      isDigital: isDigital,
      avgRating: avgRating,
      soldCount: soldCount,
    );
  }
}

class ProductVariant {
  final String id;
  final String? title;

  /// Raw ILS amount — do NOT divide by 100.
  /// Source: variant.calculated_price.calculated_amount
  /// Confirmed by ~/waslaq-storefront/src/lib/util/get-product-price.ts
  final double? price;

  /// Original (pre-sale) price. Null if not a sale price.
  /// Source: variant.calculated_price.original_amount
  final double? originalPrice;

  final int? inventoryQuantity;
  final bool allowBackorder;

  const ProductVariant({
    required this.id,
    this.title,
    this.price,
    this.originalPrice,
    this.inventoryQuantity,
    this.allowBackorder = false,
  });

  bool get isOnSale =>
      originalPrice != null && price != null && price! < originalPrice!;

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    // Price shape from get-product-price.ts:
    //   variant.calculated_price.calculated_amount  ← use this
    //   variant.calculated_price.original_amount    ← pre-sale price
    double? price;
    double? originalPrice;
    final calcPrice = json['calculated_price'] as Map<String, dynamic>?;
    if (calcPrice != null) {
      price = (calcPrice['calculated_amount'] as num?)?.toDouble();
      originalPrice = (calcPrice['original_amount'] as num?)?.toDouble();
    }

    return ProductVariant(
      id: json['id'] as String,
      title: json['title'] as String?,
      price: price,
      originalPrice: originalPrice,
      inventoryQuantity: json['inventory_quantity'] as int?,
      allowBackorder: json['allow_backorder'] as bool? ?? false,
    );
  }
}

class ProductImage {
  final String id;
  final String url;

  const ProductImage({required this.id, required this.url});

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        id: json['id'] as String,
        url: json['url'] as String,
      );
}

class ProductVendor {
  final String id;
  final String? storeName;
  final String? slug;
  final String? logoUrl;

  const ProductVendor({
    required this.id,
    this.storeName,
    this.slug,
    this.logoUrl,
  });

  /// fromJson matches the GET /store/vendors response shape:
  ///   { id, store_name, slug, logo_url, banner_url, ... }
  /// Source: ~/waslaq-backend/src/api/store/vendors/route.ts
  factory ProductVendor.fromJson(Map<String, dynamic> json) => ProductVendor(
        id: json['id'] as String,
        storeName: json['store_name'] as String?,
        slug: json['slug'] as String?,
        logoUrl: json['logo_url'] as String?,
      );
}
