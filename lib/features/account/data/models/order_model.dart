// lib/features/account/data/models/order_model.dart

class OrderItemModel {
  final String id, title;
  final int quantity;
  final double unitPrice;
  final String? thumbnail;

  OrderItemModel({
    required this.id,
    required this.title,
    required this.quantity,
    required this.unitPrice,
    this.thumbnail,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0,
      thumbnail: json['thumbnail'] as String?,
    );
  }
}

class OrderModel {
  final String id;
  final int displayId;
  final String status;
  final String paymentStatus;
  final String fulfillmentStatus;
  final double total;
  final String currencyCode;
  final DateTime createdAt;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.displayId,
    required this.status,
    required this.paymentStatus,
    required this.fulfillmentStatus,
    required this.total,
    required this.currencyCode,
    required this.createdAt,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final itemsRaw = json['items'] as List<dynamic>? ?? [];
    return OrderModel(
      id: json['id'] as String,
      displayId: (json['display_id'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'pending',
      paymentStatus: json['payment_status'] as String? ?? '',
      fulfillmentStatus: json['fulfillment_status'] as String? ?? '',
      total: (json['total'] as num?)?.toDouble() ?? 0,
      currencyCode: json['currency_code'] as String? ?? 'ils',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      items: itemsRaw.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
