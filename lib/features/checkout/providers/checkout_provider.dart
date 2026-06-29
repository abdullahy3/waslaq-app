// lib/features/checkout/providers/checkout_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/checkout_repository.dart';
import '../data/models/checkout_model.dart';
import '../../cart/providers/cart_provider.dart';

part 'checkout_provider.g.dart';

@riverpod
class CheckoutNotifier extends _$CheckoutNotifier {
  @override
  CheckoutSession? build() => null;

  Future<void> startCheckout() async {
    final cart = ref.read(cartProvider).valueOrNull;
    if (cart == null) return;

    state = CheckoutSession(
      cartId: cart.id,
      total: cart.total,
      status: CheckoutStatus.pending,
      step: CheckoutStep.address,
    );
  }

  Future<void> submitAddress(ShippingAddress address, String email) async {
    final current = state;
    if (current == null) return;

    try {
      await CheckoutRepository.setShippingAddress(current.cartId, address, email);
      final options = await CheckoutRepository.getShippingOptions(current.cartId);
      state = current.copyWith(
        shippingAddress: address,
        shippingOptions: options,
        step: CheckoutStep.shipping,
        errorMessage: null,
      );
    } catch (e) {
      state = current.copyWith(
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> selectShipping(String optionId) async {
    final current = state;
    if (current == null) return;

    try {
      await CheckoutRepository.selectShippingMethod(current.cartId, optionId);
      // Refresh cart so total in review screen includes shipping cost
      await ref.read(cartProvider.notifier).refresh();
      final clientSecret = await CheckoutRepository.initPaymentSession(current.cartId);
      state = current.copyWith(
        selectedShippingOptionId: optionId,
        clientSecret: clientSecret,
        step: CheckoutStep.review,
        errorMessage: null,
      );
    } catch (e) {
      state = current.copyWith(
        errorMessage: e.toString(),
      );
    }
  }

  Future<Order?> placeOrder() async {
    final current = state;
    if (current == null) return null;

    state = current.copyWith(step: CheckoutStep.processing, errorMessage: null);

    try {
      final order = await CheckoutRepository.placeOrder(current.cartId);
      await ref.read(cartProvider.notifier).refresh();
      state = current.copyWith(step: CheckoutStep.done);
      return order;
    } catch (e) {
      state = current.copyWith(
        step: CheckoutStep.failed,
        errorMessage: e.toString(),
      );
      return null;
    }
  }
}

/// Provider for the order confirmation screen.
@riverpod
Future<Order> orderDetail(OrderDetailRef ref, String orderId) {
  return CheckoutRepository.getOrder(orderId);
}
