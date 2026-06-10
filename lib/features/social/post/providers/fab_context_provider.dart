import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fab_context_provider.g.dart';

class FabContextData {
  final String? communitySlug;
  final String? productId;
  final String? productTitle;
  final String? storeSlug;

  const FabContextData({
    this.communitySlug,
    this.productId,
    this.productTitle,
    this.storeSlug,
  });
}

@riverpod
class FabContext extends _$FabContext {
  @override
  FabContextData? build() => null;

  void setCommunity(String slug) =>
      state = FabContextData(communitySlug: slug);

  void setProduct(String productId, String productTitle) =>
      state = FabContextData(productId: productId, productTitle: productTitle);

  void setStore(String storeSlug) =>
      state = FabContextData(storeSlug: storeSlug);

  void setContext(FabContextData? data) => state = data;

  void clear() => state = null;
}
