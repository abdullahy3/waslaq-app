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
    // Medusa v2 uses POST (not PATCH) to update carts
    await MedusaClient.instance.post(
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

  /// Initializes (or retrieves existing) Stripe payment session for the cart.
  /// Returns the PaymentIntent clientSecret needed for flutter_stripe PaymentSheet.
  ///
  /// Medusa v2 requires two steps:
  ///   1. POST /store/payment-collections  — create/get the collection
  ///   2. POST /store/payment-collections/:id/payment-sessions  — init Stripe session
  static Future<String> initPaymentSession(String cartId) async {
    // Step 1: create or retrieve the payment collection for this cart
    final colResponse = await MedusaClient.instance.post(
      '/store/payment-collections',
      data: {'cart_id': cartId},
    );

    final collection = colResponse.data['payment_collection'] as Map<String, dynamic>?;
    if (collection == null) {
      throw Exception('Failed to create payment collection for cart $cartId');
    }

    final collectionId = collection['id'] as String?;
    if (collectionId == null || collectionId.isEmpty) {
      throw Exception('Payment collection ID missing');
    }

    // Step 2: initialize the Stripe payment session inside the collection
    final sessionResponse = await MedusaClient.instance.post(
      '/store/payment-collections/$collectionId/payment-sessions',
      data: {'provider_id': 'pp_stripe_stripe'},
    );

    // Response: { payment_collection: { payment_sessions: [...] } }
    final updatedCollection =
        sessionResponse.data['payment_collection'] as Map<String, dynamic>?;
    final sessions =
        updatedCollection?['payment_sessions'] as List<dynamic>?;

    if (sessions == null || sessions.isEmpty) {
      throw Exception('No Stripe payment session returned for collection $collectionId');
    }

    final session = sessions.first as Map<String, dynamic>;
    final data = session['data'] as Map<String, dynamic>?;
    final clientSecret = data?['client_secret'] as String?;

    if (clientSecret == null || clientSecret.isEmpty) {
      throw Exception('Stripe clientSecret missing from payment session');
    }

    CrashReporter.log('Payment session initialized for cart: $cartId');
    return clientSecret;
  }

  static Future<Order> placeOrder(String cartId) async {
    final response = await MedusaClient.instance.post(
      '/store/carts/$cartId/complete',
    );
    final type = response.data['type'] as String;
    if (type == 'order') {
      return Order.fromJson(
        response.data['order'] as Map<String, dynamic>,
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
