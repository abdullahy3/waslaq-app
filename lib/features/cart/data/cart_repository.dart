// lib/features/cart/data/cart_repository.dart
// Mirrors every endpoint in ~/waslaq-storefront/src/lib/data/cart.ts
// All amounts are raw ILS — NEVER divide or multiply by 100.

import '../../../core/api/medusa_client.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../core/config/app_config.dart';
import '../../../core/crashlytics/crash_reporter.dart';
import 'models/cart_model.dart';

class CartRepository {
  CartRepository._();

  // ── Public entry-point ────────────────────────────────────────────────────

  /// Returns the persisted cart or creates a fresh one.
  /// Mirrors the retrieveCart → getOrSetCart flow in cart.ts.
  static Future<CartModel> getOrCreateCart() async {
    final existingCartId = await SecureStorage.getCartId();
    if (existingCartId != null) {
      try {
        return await _getCart(existingCartId);
      } catch (_) {
        // Cart expired, completed, or not found — start fresh
        await SecureStorage.deleteCartId();
      }
    }

    // No valid local cart — check if this customer has an active cart on the server.
    // This makes the cart follow the account across devices.
    try {
      final resp = await MedusaClient.instance.get('/store/customer/active-cart');
      final serverCartId = resp.data['cart_id'] as String?;
      if (serverCartId != null && serverCartId.isNotEmpty) {
        try {
          final cart = await _getCart(serverCartId);
          await SecureStorage.saveCartId(serverCartId);
          CrashReporter.log('Cart recovered from server: $serverCartId');
          return cart;
        } catch (_) {}
      }
    } catch (_) {}

    return _createCart();
  }

  // ── Internal helpers ──────────────────────────────────────────────────────

  /// POST /store/carts — matches sdk.store.cart.create() in cart.ts
  static Future<CartModel> _createCart() async {
    final response = await MedusaClient.instance.post(
      '/store/carts',
      data: {
        'region_id': AppConfig.palestineRegionId,
        'sales_channel_id': AppConfig.salesChannelId,
      },
    );
    final cart = CartModel.fromJson(
      response.data['cart'] as Map<String, dynamic>,
    );
    await SecureStorage.saveCartId(cart.id);
    CrashReporter.log('Cart created: ${cart.id}');
    return cart;
  }

  /// GET /store/carts/:id — matches retrieveCart() in cart.ts
  static Future<CartModel> _getCart(String cartId) async {
    final response = await MedusaClient.instance.get(
      '/store/carts/$cartId',
      queryParameters: {
        // Same field expansion as the storefront
        'fields':
            '*items,*region,*items.product,*items.variant,'
            '*items.thumbnail,+items.total,+shipping_methods.name',
      },
    );
    final data = response.data['cart'] as Map<String, dynamic>;
    // Mirror the storefront: if cart is completed, treat as gone
    if (data['completed_at'] != null || data['status'] == 'completed') {
      await SecureStorage.deleteCartId();
      throw Exception('Cart already completed');
    }
    return CartModel.fromJson(data);
  }

  // ── Public mutations ──────────────────────────────────────────────────────

  /// POST /store/carts/:id/line-items — mirrors sdk.store.cart.createLineItem()
  static Future<CartModel> addItem({
    required String cartId,
    required String variantId,
    required int quantity,
  }) async {
    final response = await MedusaClient.instance.post(
      '/store/carts/$cartId/line-items',
      data: {
        'variant_id': variantId,
        'quantity': quantity,
      },
    );
    return CartModel.fromJson(
      response.data['cart'] as Map<String, dynamic>,
    );
  }

  /// POST /store/carts/:id/line-items/:lineId — mirrors sdk.store.cart.updateLineItem()
  static Future<CartModel> updateItem({
    required String cartId,
    required String lineItemId,
    required int quantity,
  }) async {
    final response = await MedusaClient.instance.post(
      '/store/carts/$cartId/line-items/$lineItemId',
      data: {'quantity': quantity},
    );
    return CartModel.fromJson(
      response.data['cart'] as Map<String, dynamic>,
    );
  }

  /// DELETE /store/carts/:id/line-items/:lineId — mirrors sdk.store.cart.deleteLineItem()
  static Future<CartModel> removeItem({
    required String cartId,
    required String lineItemId,
  }) async {
    final response = await MedusaClient.instance.delete(
      '/store/carts/$cartId/line-items/$lineItemId',
    );
    return CartModel.fromJson(
      response.data['cart'] as Map<String, dynamic>,
    );
  }

  /// POST /store/carts/:id — mirrors sdk.store.cart.update() with shipping_address
  static Future<CartModel> updateShippingAddress({
    required String cartId,
    required Map<String, dynamic> address,
  }) async {
    final response = await MedusaClient.instance.post(
      '/store/carts/$cartId',
      data: {'shipping_address': address},
    );
    return CartModel.fromJson(
      response.data['cart'] as Map<String, dynamic>,
    );
  }
}
