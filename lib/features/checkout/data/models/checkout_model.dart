// lib/features/checkout/data/models/checkout_model.dart
// All amounts are raw ILS — NEVER divide or multiply by 100.

enum CheckoutStatus {
  pending,
  processing,
  succeeded,
  failed,
}

enum CheckoutStep { address, shipping, review, processing, done, failed }

class ShippingAddress {
  final String firstName, lastName, address1, city, phone;
  final String? province, postalCode, company;
  const ShippingAddress({
    required this.firstName,
    required this.lastName,
    required this.address1,
    required this.city,
    required this.phone,
    this.province,
    this.postalCode,
    this.company,
  });
  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'address_1': address1,
        'city': city,
        'phone': phone,
        'country_code': 'ps',
        if (province != null) 'province': province,
        if (postalCode != null) 'postal_code': postalCode,
        if (company != null) 'company': company,
      };
}

class ShippingOption {
  final String id, name;
  final double amount;
  const ShippingOption({
    required this.id,
    required this.name,
    required this.amount,
  });
  factory ShippingOption.fromJson(Map<String, dynamic> json) => ShippingOption(
        id: json['id'] as String,
        name: json['name'] as String,
        amount: (json['amount'] as num).toDouble(),
      );
}

class CheckoutSession {
  final String cartId;
  final double total;
  final String? paymentSessionId;
  final CheckoutStatus status;
  final ShippingAddress? shippingAddress;
  final String? selectedShippingOptionId;
  final CheckoutStep step;
  final List<ShippingOption> shippingOptions;
  final String? errorMessage;

  const CheckoutSession({
    required this.cartId,
    required this.total,
    this.paymentSessionId,
    required this.status,
    this.shippingAddress,
    this.selectedShippingOptionId,
    this.step = CheckoutStep.address,
    this.shippingOptions = const [],
    this.errorMessage,
  });
  
  CheckoutSession copyWith({
    String? cartId,
    double? total,
    String? paymentSessionId,
    CheckoutStatus? status,
    ShippingAddress? shippingAddress,
    String? selectedShippingOptionId,
    CheckoutStep? step,
    List<ShippingOption>? shippingOptions,
    String? errorMessage,
  }) {
    return CheckoutSession(
      cartId: cartId ?? this.cartId,
      total: total ?? this.total,
      paymentSessionId: paymentSessionId ?? this.paymentSessionId,
      status: status ?? this.status,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      selectedShippingOptionId: selectedShippingOptionId ?? this.selectedShippingOptionId,
      step: step ?? this.step,
      shippingOptions: shippingOptions ?? this.shippingOptions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Mirrors the Medusa StoreOrder object.
/// Field names confirmed from /store/orders/:id in the storefront's
/// order confirmed page fetch at confirmed/page.tsx line 32.
class Order {
  final String id;
  final String displayId;
  final double total;
  final String status;
  final DateTime createdAt;
  final List<OrderItem> items;

  const Order({
    required this.id,
    required this.displayId,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      // display_id is an int from Medusa — prefix with '#'
      displayId: '#${json['display_id']}',
      total: (json['total'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      items: (json['items'] as List? ?? [])
          .map((i) => OrderItem.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Mirrors StoreOrderLineItem.
/// product_title confirmed as top-level field in line item components.
class OrderItem {
  final String id;
  final String title;
  final String? thumbnail;
  final int quantity;
  final double unitPrice;

  const OrderItem({
    required this.id,
    required this.title,
    this.thumbnail,
    required this.quantity,
    required this.unitPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json['id'] as String,
        // product_title is the Medusa v2 field for line items
        title: json['product_title'] as String? ??
            json['title'] as String? ??
            '',
        thumbnail: json['thumbnail'] as String?,
        quantity: json['quantity'] as int,
        unitPrice: (json['unit_price'] as num).toDouble(),
      );
}
