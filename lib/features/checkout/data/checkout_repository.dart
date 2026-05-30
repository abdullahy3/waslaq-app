// lib/features/checkout/data/checkout_repository.dart
// Mirrors every API call in ~/waslaq-storefront/src/lib/data/cart.ts
// All amounts are raw ILS — NEVER divide or multiply by 100.

import '../../../core/api/medusa_client.dart';
import '../../../core/crashlytics/crash_reporter.dart';
import 'models/checkout_model.dart';

class CheckoutRepository {
  CheckoutRepository._();

  static Future<void> setShippingAddress(
      String cartId, ShippingAddress address, String email) async {
    await MedusaClient.instance.patch(
      '/store/carts/$cartId',
      data: {
        'shipping_address': address.toJson(),
        'email': email,
      },
    );
  }

  static Future<List<ShippingOption>> getShippingOptions(String cartId) async {
    final response = await MedusaClient.instance.get(
      '/store/shipping-options',
      queryParameters: {'cart_id': cartId},
    );
    final options = (response.data['shipping_options'] as List)
        .map((o) => ShippingOption.fromJson(o as Map<String, dynamic>))
        .toList();
    return options;
  }

  static Future<void> selectShippingMethod(
      String cartId, String optionId) async {
    await MedusaClient.instance.post(
      '/store/carts/$cartId/shipping-methods',
      data: {'option_id': optionId},
    );
  }

  static Future<void> initPaymentSession(String cartId) async {
    await MedusaClient.instance.post(
      '/store/payment-collections',
      data: {'cart_id': cartId},
    );
    CrashReporter.log('Payment session initialized for cart: $cartId');
  }

  static Future<Order> placeOrder(String cartId) async {
    final response = await MedusaClient.instance.post(
      '/store/carts/$cartId/complete',
    );
    final type = response.data['type'] as String;
    if (type == 'order') {
      return Order.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    }
    throw Exception('Cart completion returned type=$type (expected "order")');
  }

  static Future<Order> getOrder(String orderId) async {
    final response = await MedusaClient.instance.get(
      '/store/orders/$orderId',
      queryParameters: {
        'fields':
            '*items,*items.variant,*shipping_address,'
            '*payment_collections,+total,+subtotal,+tax_total,'
            '+item_subtotal,+shipping_subtotal',
      },
    );
    return Order.fromJson(
      response.data['order'] as Map<String, dynamic>,
    );
  }

  static bool isSuccessUrl(String url) {
    return url.contains('/order/') && url.endsWith('/confirmed');
  }

  static bool isFailureUrl(String url) {
    return url.contains('/checkout?error') ||
        url.contains('payment_failed') ||
        url.contains('checkout?step=payment&error');
  }

  static String? extractOrderId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;
    final segments = uri.pathSegments;
    if (segments.length >= 2 && segments.last == 'confirmed') {
      return segments[segments.length - 2];
    }
    return null;
  }
}
