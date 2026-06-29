// lib/features/account/data/models/dispute_model.dart

class DisputeMessageModel {
  final String id;
  final String senderId;
  final String senderRole; // buyer | vendor | admin
  final String message;
  final String? mediaUrl;
  final String? mediaType;
  final List<String> seenBy;
  final DateTime createdAt;

  DisputeMessageModel({
    required this.id,
    required this.senderId,
    required this.senderRole,
    required this.message,
    this.mediaUrl,
    this.mediaType,
    required this.seenBy,
    required this.createdAt,
  });

  factory DisputeMessageModel.fromJson(Map<String, dynamic> json) {
    return DisputeMessageModel(
      id: json['id'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      senderRole: json['senderRole'] as String? ?? 'buyer',
      message: json['message'] as String? ?? '',
      mediaUrl: json['mediaUrl'] as String?,
      mediaType: json['mediaType'] as String?,
      seenBy: (json['seenBy'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class DisputeModel {
  final String id;
  final String orderId;
  final String vendorId;
  final String customerId;
  final String disputeType;
  final String? description;
  final String status;
  final DateTime createdAt;
  final String? productTitle;
  final String? thumbnail;

  DisputeModel({
    required this.id,
    required this.orderId,
    required this.vendorId,
    required this.customerId,
    required this.disputeType,
    this.description,
    required this.status,
    required this.createdAt,
    this.productTitle,
    this.thumbnail,
  });

  factory DisputeModel.fromJson(Map<String, dynamic> json) {
    return DisputeModel(
      id: json['id'] as String? ?? '',
      orderId: json['order_id'] as String? ?? '',
      vendorId: json['vendor_id'] as String? ?? '',
      customerId: json['customer_id'] as String? ?? '',
      disputeType: json['dispute_type'] as String? ?? 'other',
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'open',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      productTitle: json['product_title'] as String?,
      thumbnail: json['thumbnail'] as String?,
    );
  }

  String get statusLabel {
    switch (status) {
      case 'open': return 'Open';
      case 'vendor_responded': return 'Under Review';
      case 'admin_review': return 'Admin Review';
      case 'resolved_refund': return 'Resolved (Refunded)';
      case 'resolved_release': return 'Resolved (Released)';
      case 'resolved_split': return 'Resolved (Split)';
      default: return 'Open';
    }
  }

  String get typeLabel {
    switch (disputeType) {
      case 'not_delivered': return 'Not Delivered';
      case 'damaged': return 'Damaged';
      case 'not_as_described':
      case 'product_not_as_described': return 'Not as Described';
      default: return 'Other';
    }
  }

  bool get isResolved => status == 'resolved_refund' || status == 'resolved_release' || status == 'resolved_split';
}
