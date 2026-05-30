// lib/features/product/providers/product_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/product_repository.dart';
import '../data/models/product_model.dart';
import '../data/models/category_model.dart';

part 'product_provider.g.dart';

// ---------------------------------------------------------------------------
// Product listing — supports optional categoryId and search query filters
// ---------------------------------------------------------------------------

@riverpod
class ProductList extends _$ProductList {
  @override
  Future<List<ProductModel>> build({
    String? categoryId,
    String? query,
  }) async {
    return ProductRepository.getProducts(
      categoryId: categoryId,
      query: query,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ProductRepository.getProducts(
        categoryId: categoryId,
        query: query,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Single product — keyed by product ID
// ---------------------------------------------------------------------------

@riverpod
Future<ProductModel> productDetail(ProductDetailRef ref, String id) {
  return ProductRepository.getProductById(id);
}

// ---------------------------------------------------------------------------
// Categories — root-only list (filter applied after fetch like storefront does)
// ---------------------------------------------------------------------------

@riverpod
Future<List<CategoryModel>> categories(CategoriesRef ref) async {
  final all = await ProductRepository.getCategories();
  // Mirror getAllCategoriesWithChildren() — return only root categories
  // Children are already nested inside each root's .children list
  return all.where((c) => c.isRoot).toList();
}

// ---------------------------------------------------------------------------
// All categories flat — useful for category pickers
// ---------------------------------------------------------------------------

@riverpod
Future<List<CategoryModel>> allCategories(AllCategoriesRef ref) {
  return ProductRepository.getCategories();
}
