// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productDetailHash() => r'938418d08ce37810589290337d63bca3ebe420bc';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [productDetail].
@ProviderFor(productDetail)
const productDetailProvider = ProductDetailFamily();

/// See also [productDetail].
class ProductDetailFamily extends Family<AsyncValue<ProductModel>> {
  /// See also [productDetail].
  const ProductDetailFamily();

  /// See also [productDetail].
  ProductDetailProvider call(
    String id,
  ) {
    return ProductDetailProvider(
      id,
    );
  }

  @override
  ProductDetailProvider getProviderOverride(
    covariant ProductDetailProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productDetailProvider';
}

/// See also [productDetail].
class ProductDetailProvider extends AutoDisposeFutureProvider<ProductModel> {
  /// See also [productDetail].
  ProductDetailProvider(
    String id,
  ) : this._internal(
          (ref) => productDetail(
            ref as ProductDetailRef,
            id,
          ),
          from: productDetailProvider,
          name: r'productDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productDetailHash,
          dependencies: ProductDetailFamily._dependencies,
          allTransitiveDependencies:
              ProductDetailFamily._allTransitiveDependencies,
          id: id,
        );

  ProductDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<ProductModel> Function(ProductDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductDetailProvider._internal(
        (ref) => create(ref as ProductDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ProductModel> createElement() {
    return _ProductDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProductDetailRef on AutoDisposeFutureProviderRef<ProductModel> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ProductDetailProviderElement
    extends AutoDisposeFutureProviderElement<ProductModel>
    with ProductDetailRef {
  _ProductDetailProviderElement(super.provider);

  @override
  String get id => (origin as ProductDetailProvider).id;
}

String _$categoriesHash() => r'dbb2899d028b59a5238c07390cf71c24b47fd31a';

/// See also [categories].
@ProviderFor(categories)
final categoriesProvider =
    AutoDisposeFutureProvider<List<CategoryModel>>.internal(
  categories,
  name: r'categoriesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$categoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CategoriesRef = AutoDisposeFutureProviderRef<List<CategoryModel>>;
String _$allCategoriesHash() => r'9b34bd5b5871e183eaad4bed83c0e57eb8015adf';

/// See also [allCategories].
@ProviderFor(allCategories)
final allCategoriesProvider =
    AutoDisposeFutureProvider<List<CategoryModel>>.internal(
  allCategories,
  name: r'allCategoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllCategoriesRef = AutoDisposeFutureProviderRef<List<CategoryModel>>;
String _$paginatedProductsHash() => r'88ad9680279ad36b113980caefac667aa4c941c0';

/// See also [paginatedProducts].
@ProviderFor(paginatedProducts)
const paginatedProductsProvider = PaginatedProductsFamily();

/// See also [paginatedProducts].
class PaginatedProductsFamily extends Family<AsyncValue<ProductsResponse>> {
  /// See also [paginatedProducts].
  const PaginatedProductsFamily();

  /// See also [paginatedProducts].
  PaginatedProductsProvider call({
    int page = 1,
    int limit = 20,
    String? categoryId,
    String? query,
    String? order,
  }) {
    return PaginatedProductsProvider(
      page: page,
      limit: limit,
      categoryId: categoryId,
      query: query,
      order: order,
    );
  }

  @override
  PaginatedProductsProvider getProviderOverride(
    covariant PaginatedProductsProvider provider,
  ) {
    return call(
      page: provider.page,
      limit: provider.limit,
      categoryId: provider.categoryId,
      query: provider.query,
      order: provider.order,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'paginatedProductsProvider';
}

/// See also [paginatedProducts].
class PaginatedProductsProvider
    extends AutoDisposeFutureProvider<ProductsResponse> {
  /// See also [paginatedProducts].
  PaginatedProductsProvider({
    int page = 1,
    int limit = 20,
    String? categoryId,
    String? query,
    String? order,
  }) : this._internal(
          (ref) => paginatedProducts(
            ref as PaginatedProductsRef,
            page: page,
            limit: limit,
            categoryId: categoryId,
            query: query,
            order: order,
          ),
          from: paginatedProductsProvider,
          name: r'paginatedProductsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$paginatedProductsHash,
          dependencies: PaginatedProductsFamily._dependencies,
          allTransitiveDependencies:
              PaginatedProductsFamily._allTransitiveDependencies,
          page: page,
          limit: limit,
          categoryId: categoryId,
          query: query,
          order: order,
        );

  PaginatedProductsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.limit,
    required this.categoryId,
    required this.query,
    required this.order,
  }) : super.internal();

  final int page;
  final int limit;
  final String? categoryId;
  final String? query;
  final String? order;

  @override
  Override overrideWith(
    FutureOr<ProductsResponse> Function(PaginatedProductsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PaginatedProductsProvider._internal(
        (ref) => create(ref as PaginatedProductsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        limit: limit,
        categoryId: categoryId,
        query: query,
        order: order,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ProductsResponse> createElement() {
    return _PaginatedProductsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PaginatedProductsProvider &&
        other.page == page &&
        other.limit == limit &&
        other.categoryId == categoryId &&
        other.query == query &&
        other.order == order;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);
    hash = _SystemHash.combine(hash, order.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PaginatedProductsRef on AutoDisposeFutureProviderRef<ProductsResponse> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `limit` of this provider.
  int get limit;

  /// The parameter `categoryId` of this provider.
  String? get categoryId;

  /// The parameter `query` of this provider.
  String? get query;

  /// The parameter `order` of this provider.
  String? get order;
}

class _PaginatedProductsProviderElement
    extends AutoDisposeFutureProviderElement<ProductsResponse>
    with PaginatedProductsRef {
  _PaginatedProductsProviderElement(super.provider);

  @override
  int get page => (origin as PaginatedProductsProvider).page;
  @override
  int get limit => (origin as PaginatedProductsProvider).limit;
  @override
  String? get categoryId => (origin as PaginatedProductsProvider).categoryId;
  @override
  String? get query => (origin as PaginatedProductsProvider).query;
  @override
  String? get order => (origin as PaginatedProductsProvider).order;
}

String _$productListHash() => r'b3e057db8074046eaa5885824839707661f2de9b';

abstract class _$ProductList
    extends BuildlessAutoDisposeAsyncNotifier<List<ProductModel>> {
  late final String? categoryId;
  late final String? query;

  FutureOr<List<ProductModel>> build({
    String? categoryId,
    String? query,
  });
}

/// See also [ProductList].
@ProviderFor(ProductList)
const productListProvider = ProductListFamily();

/// See also [ProductList].
class ProductListFamily extends Family<AsyncValue<List<ProductModel>>> {
  /// See also [ProductList].
  const ProductListFamily();

  /// See also [ProductList].
  ProductListProvider call({
    String? categoryId,
    String? query,
  }) {
    return ProductListProvider(
      categoryId: categoryId,
      query: query,
    );
  }

  @override
  ProductListProvider getProviderOverride(
    covariant ProductListProvider provider,
  ) {
    return call(
      categoryId: provider.categoryId,
      query: provider.query,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productListProvider';
}

/// See also [ProductList].
class ProductListProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ProductList, List<ProductModel>> {
  /// See also [ProductList].
  ProductListProvider({
    String? categoryId,
    String? query,
  }) : this._internal(
          () => ProductList()
            ..categoryId = categoryId
            ..query = query,
          from: productListProvider,
          name: r'productListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productListHash,
          dependencies: ProductListFamily._dependencies,
          allTransitiveDependencies:
              ProductListFamily._allTransitiveDependencies,
          categoryId: categoryId,
          query: query,
        );

  ProductListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
    required this.query,
  }) : super.internal();

  final String? categoryId;
  final String? query;

  @override
  FutureOr<List<ProductModel>> runNotifierBuild(
    covariant ProductList notifier,
  ) {
    return notifier.build(
      categoryId: categoryId,
      query: query,
    );
  }

  @override
  Override overrideWith(ProductList Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProductListProvider._internal(
        () => create()
          ..categoryId = categoryId
          ..query = query,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ProductList, List<ProductModel>>
      createElement() {
    return _ProductListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductListProvider &&
        other.categoryId == categoryId &&
        other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProductListRef
    on AutoDisposeAsyncNotifierProviderRef<List<ProductModel>> {
  /// The parameter `categoryId` of this provider.
  String? get categoryId;

  /// The parameter `query` of this provider.
  String? get query;
}

class _ProductListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ProductList,
        List<ProductModel>> with ProductListRef {
  _ProductListProviderElement(super.provider);

  @override
  String? get categoryId => (origin as ProductListProvider).categoryId;
  @override
  String? get query => (origin as ProductListProvider).query;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
