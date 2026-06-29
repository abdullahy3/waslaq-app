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
  ///
  /// [currentCustomerId] is null while auth is loading or user is a guest.
  /// We must NOT clear a customer's saved cart ID during auth loading —
  /// the cart provider rebuilds once auth resolves, and then the ID is
  /// used to restore the customer's cart with all items intact.
  static Future<CartModel> getOrCreateCart({String? currentCustomerId}) async {
    final existingCartId = await SecureStorage.getCartId();
    if (existingCartId != null) {
      try {
        final cart = await _getCart(existingCartId);

        // 1. Auth not yet resolved (loading) or confirmed guest
        if (currentCustomerId == null) {
          if (cart.customerId == null) {
            // Guest cart — use it
            return cart;
          } else {
            // Saved cart belongs to a customer, but auth is null (could be
            // loading). DON'T clear the cart ID — preserve it for recovery
            // when auth resolves. Return a temporary guest cart instead,
            // without persisting its ID (so the customer's ID stays saved).
            CrashReporter.log(
                'Auth unresolved — deferring customer cart ${cart.customerId}. Creating temp guest cart.');
            return await _createCart(persist: false);
          }
        }

        // 2. Authenticated
        if (cart.customerId == currentCustomerId) {
          return cart;
        } else if (cart.customerId == null) {
          // Local cart is a guest cart, but user is now logged in.
          // Check if they already have an active cart on the server.
          final serverCart = await _recoverServerActiveCart(currentCustomerId);
          if (serverCart != null) {
            return serverCart;
          }
          // No server cart — adopt this guest cart as-is
          return cart;
        } else {
          // Belongs to a different customer
          CrashReporter.log(
              'Cart belongs to different customer: ${cart.customerId}. Clearing local cart ID.');
          await SecureStorage.deleteCartId();
        }
      } catch (e) {
        CrashReporter.log('Existing cart $existingCartId unusable: $e');
        await SecureStorage.deleteCartId();
      }
    }

    // No valid local cart:
    // If authenticated: try to recover their server cart first.
    if (currentCustomerId != null) {
      final serverCart = await _recoverServerActiveCart(currentCustomerId);
      if (serverCart != null) {
        return serverCart;
      }
    }

    // Create a fresh cart — retry once on transient network failure
    try {
      return await _createCart();
    } catch (e) {
      CrashReporter.log('Cart create attempt 1 failed: $e — retrying in 2s');
      await Future.delayed(const Duration(seconds: 2));
      return await _createCart();
    }
  }

  static Future<CartModel?> _recoverServerActiveCart(String currentCustomerId) async {
    try {
      final resp = await MedusaClient.instance.get('/store/customer/active-cart');
      final serverCartId = resp.data['cart_id'] as String?;
      if (serverCartId != null && serverCartId.isNotEmpty) {
        try {
          final cart = await _getCart(serverCartId);
          if (cart.customerId == currentCustomerId) {
            await SecureStorage.saveCartId(serverCartId);
            CrashReporter.log('Cart recovered from server: $serverCartId');
            return cart;
          }
        } catch (e) {
          CrashReporter.log('Server cart $serverCartId unusable: $e');
        }
      }
    } catch (_) {
      // expected when network fails or no active cart
    }
    return null;
  }

  // ── Internal helpers ──────────────────────────────────────────────────────

  /// Creates a new cart.
  /// [persist] = true (default): saves the cart ID to SecureStorage.
  /// [persist] = false: returns the cart without saving — used when auth
  ///   is unresolved and we don't want to overwrite the existing customer cart ID.
  static Future<CartModel> _createCart({bool persist = true}) async {
    final response = await MedusaClient.instance.post(
      '/store/carts',
      data: {
        'region_id': AppConfig.palestineRegionId,
        'sales_channel_id': AppConfig.salesChannelId,
      },
    );
    final cartData = response.data['cart'];
    if (cartData == null) {
      throw Exception('Cart creation response missing cart object');
    }
    final cart = CartModel.fromJson(cartData as Map<String, dynamic>);
    if (persist) {
      await SecureStorage.saveCartId(cart.id);
      CrashReporter.log('Cart created: ${cart.id}');
    }
    return cart;
  }

  static Future<CartModel> _getCart(String cartId) async {
    final response = await MedusaClient.instance.get(
      '/store/carts/$cartId',
      queryParameters: {
        'fields':
            '*items,*region,*items.product,*items.variant,'
            '*items.thumbnail,+items.total,'
            '+items.product_type_id,+items.product.type_id,+shipping_methods.name,'
            '*items.product.type,*items.product.metadata',
      },
    );
    final data = response.data['cart'];
    if (data == null) {
      throw Exception('Cart $cartId not found in response');
    }
    final cartMap = data as Map<String, dynamic>;
    if (cartMap['completed_at'] != null || cartMap['status'] == 'completed') {
      await SecureStorage.deleteCartId();
      throw Exception('Cart already completed');
    }
    return CartModel.fromJson(cartMap);
  }

  // ── Public mutations ──────────────────────────────────────────────────────

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

  /// DELETE /store/carts/:id/line-items/:lineId
  /// Medusa v2 DELETE returns {"id":..., "deleted":true, "parent":{...cart...}}
  /// NOT {"cart":{...}} — the updated cart is under the "parent" key.
  static Future<CartModel> removeItem({
    required String cartId,
    required String lineItemId,
  }) async {
    final response = await MedusaClient.instance.delete(
      '/store/carts/$cartId/line-items/$lineItemId',
    );
    // Medusa v2: cart is under "parent", not "cart"
    final cartData = response.data['parent'] ?? response.data['cart'];
    if (cartData == null) {
      throw Exception('Remove item response missing cart data');
    }
    return CartModel.fromJson(cartData as Map<String, dynamic>);
  }

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
