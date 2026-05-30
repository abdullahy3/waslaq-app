// lib/features/cart/providers/cart_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/cart_repository.dart';
import '../data/models/cart_model.dart';

part 'cart_provider.g.dart';

@riverpod
class Cart extends _$Cart {
  @override
  Future<CartModel> build() async {
    return CartRepository.getOrCreateCart();
  }

  Future<void> addItem(String variantId, {int quantity = 1}) async {
    final cart = state.valueOrNull;
    if (cart == null) return;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => CartRepository.addItem(
          cartId: cart.id,
          variantId: variantId,
          quantity: quantity,
        ));
  }

  Future<void> updateItem(String lineItemId, int quantity) async {
    final cart = state.valueOrNull;
    if (cart == null) return;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => CartRepository.updateItem(
          cartId: cart.id,
          lineItemId: lineItemId,
          quantity: quantity,
        ));
  }

  Future<void> removeItem(String lineItemId) async {
    final cart = state.valueOrNull;
    if (cart == null) return;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => CartRepository.removeItem(
          cartId: cart.id,
          lineItemId: lineItemId,
        ));
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => CartRepository.getOrCreateCart(),
    );
  }
}

/// Simple count provider used for the cart badge on the bottom navigation bar.
@riverpod
int cartItemCount(CartItemCountRef ref) {
  return ref.watch(cartProvider).valueOrNull?.itemCount ?? 0;
}
