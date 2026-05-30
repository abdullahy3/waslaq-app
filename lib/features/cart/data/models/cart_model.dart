// lib/features/cart/data/models/cart_model.dart
// All amounts are raw ILS values — NEVER divide or multiply by 100.
// Field names match the Medusa StoreCart / StoreCartLineItem types exactly
// as used in ~/waslaq-storefront/src/lib/data/cart.ts and
// src/modules/cart/components/item/index.tsx

class CartModel {
  final String id;
  final List<CartItem> items;
  // item_subtotal = sum of line-item totals (before shipping/tax)
  final double subtotal;
  // total = grand total (after shipping + tax - discounts)
  final double total;
  final double? shippingSubtotal; // shipping_subtotal
  final double? taxTotal;         // tax_total
  final double? discountSubtotal; // discount_subtotal
  final String? regionId;
  final String? customerId;
  final ShippingAddress? shippingAddress;

  // Computed helpers
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => items.isEmpty;

  const CartModel({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.total,
    this.shippingSubtotal,
    this.taxTotal,
    this.discountSubtotal,
    this.regionId,
    this.customerId,
    this.shippingAddress,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    // Medusa v2 returns item_subtotal for the items-only sum.
    // Fall back to subtotal if item_subtotal is absent.
    final rawSubtotal =
        json['item_subtotal'] ?? json['subtotal'];

    return CartModel(
      id: json['id'] as String,
      items: (json['items'] as List? ?? [])
          .map((i) => CartItem.fromJson(i as Map<String, dynamic>))
          .toList(),
      subtotal: (rawSubtotal as num? ?? 0).toDouble(),
      total: (json['total'] as num? ?? 0).toDouble(),
      // shipping_subtotal is the Medusa v2 field name
      shippingSubtotal: (json['shipping_subtotal'] as num?)?.toDouble(),
      taxTotal: (json['tax_total'] as num?)?.toDouble(),
      discountSubtotal: (json['discount_subtotal'] as num?)?.toDouble(),
      regionId: json['region_id'] as String?,
      customerId: json['customer_id'] as String?,
      shippingAddress: json['shipping_address'] != null
          ? ShippingAddress.fromJson(
              json['shipping_address'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CartItem {
  final String id;
  final String variantId;
  final String productId;
  // product_title is the top-level field on StoreCartLineItem (not 'title')
  final String title;
  final String? thumbnail;
  final int quantity;
  final double unitPrice;   // unit_price
  final double subtotal;    // line-item subtotal
  final String? variantTitle;

  const CartItem({
    required this.id,
    required this.variantId,
    required this.productId,
    required this.title,
    this.thumbnail,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    this.variantTitle,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    // StoreCartLineItem uses product_title (confirmed in item/index.tsx line 59)
    final rawTitle =
        json['product_title'] as String? ??
        json['title'] as String? ??
        '';

    return CartItem(
      id: json['id'] as String,
      variantId: json['variant_id'] as String,
      productId: json['product_id'] as String,
      title: rawTitle,
      thumbnail: json['thumbnail'] as String?,
      quantity: json['quantity'] as int,
      unitPrice: (json['unit_price'] as num).toDouble(),
      subtotal: (json['subtotal'] as num? ?? 0).toDouble(),
      // variant?.title nested object
      variantTitle: (json['variant'] as Map<String, dynamic>?)?['title']
          as String?,
    );
  }
}

class ShippingAddress {
  final String? firstName;
  final String? lastName;
  final String? address1;
  final String? city;
  final String? phone;
  final String? countryCode;

  const ShippingAddress({
    this.firstName,
    this.lastName,
    this.address1,
    this.city,
    this.phone,
    this.countryCode,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      ShippingAddress(
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
        address1: json['address_1'] as String?,
        city: json['city'] as String?,
        phone: json['phone'] as String?,
        countryCode: json['country_code'] as String?,
      );
}
