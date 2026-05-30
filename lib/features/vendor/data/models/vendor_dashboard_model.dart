// lib/features/vendor/data/models/vendor_dashboard_model.dart

// ─── Overview ─────────────────────────────────────────────────────────────────

class VendorKpis {
  final int orders7d;
  final double sales7d;
  final double profit7d;
  final int openDisputes;
  final double availableBalance;
  final double pendingBalance;

  VendorKpis({
    required this.orders7d,
    required this.sales7d,
    required this.profit7d,
    required this.openDisputes,
    required this.availableBalance,
    required this.pendingBalance,
  });

  factory VendorKpis.fromJson(Map<String, dynamic> json) => VendorKpis(
        orders7d: int.tryParse(json['orders_7d']?.toString() ?? '') ?? 0,
        sales7d: double.tryParse(json['sales_7d']?.toString() ?? '') ?? 0,
        profit7d: double.tryParse(json['profit_7d']?.toString() ?? '') ?? 0,
        openDisputes: int.tryParse(json['open_disputes']?.toString() ?? '') ?? 0,
        availableBalance: double.tryParse(json['available_balance']?.toString() ?? '') ?? 0,
        pendingBalance: double.tryParse(json['pending_balance']?.toString() ?? '') ?? 0,
      );
}

class VendorRecentOrder {
  final String id;
  final String? displayId;
  final String status;
  final double total;
  final DateTime createdAt;

  VendorRecentOrder({
    required this.id,
    this.displayId,
    required this.status,
    required this.total,
    required this.createdAt,
  });

  factory VendorRecentOrder.fromJson(Map<String, dynamic> json) {
    final order = json['order'] as Map<String, dynamic>?;
    return VendorRecentOrder(
      id: json['id'] as String,
      displayId: order?['display_id']?.toString(),
      status: json['status'] as String? ?? json['vendor_status'] as String? ?? order?['status'] as String? ?? 'pending',
      total: (json['amount'] as num?)?.toDouble() ?? (order?['total'] as num?)?.toDouble() ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class VendorDashboardModel {
  final VendorKpis kpis;
  final List<VendorRecentOrder> recentOrders;
  final List<VendorDispute> recentDisputes;
  final int totalProducts;

  VendorDashboardModel({
    required this.kpis,
    required this.recentOrders,
    this.recentDisputes = const [],
    required this.totalProducts,
  });

  factory VendorDashboardModel.fromJson(Map<String, dynamic> json) {
    final stats = json['store_stats'] as Map<String, dynamic>? ?? {};
    return VendorDashboardModel(
      kpis: VendorKpis.fromJson(json['kpis'] as Map<String, dynamic>? ?? {}),
      recentOrders: (json['recent_orders'] as List<dynamic>? ?? [])
          .map((e) => VendorRecentOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentDisputes: (json['recent_disputes'] as List<dynamic>? ?? [])
          .map((e) => VendorDispute.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalProducts: (stats['total_products'] as num?)?.toInt() ?? 0,
    );
  }
}

// ─── Dispute ──────────────────────────────────────────────────────────────────

class VendorDispute {
  final String id;
  final String orderId;
  final String disputeType;
  final String? description;
  final String status;
  final String? vendorResponse;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  VendorDispute({
    required this.id,
    required this.orderId,
    required this.disputeType,
    this.description,
    required this.status,
    this.vendorResponse,
    required this.createdAt,
    this.resolvedAt,
  });

  bool get isOpen => status == 'open' || status == 'vendor_responded' || status == 'admin_review';
  bool get isResolved => status.startsWith('resolved_');

  factory VendorDispute.fromJson(Map<String, dynamic> json) => VendorDispute(
        id: json['id'] as String,
        orderId: json['order_id'] as String? ?? '',
        disputeType: json['dispute_type'] as String? ?? 'other',
        description: json['description'] as String?,
        status: json['status'] as String? ?? 'open',
        vendorResponse: json['vendor_response'] as String?,
        createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
        resolvedAt: DateTime.tryParse(json['resolved_at'] as String? ?? ''),
      );
}

// ─── Orders ───────────────────────────────────────────────────────────────────

class VendorOrder {
  final String id;
  final String? displayId;
  final String vendorStatus;
  final String? orderStatus;
  final double total;
  final DateTime createdAt;
  final List<VendorOrderItem> items;
  final String? shippingName;

  VendorOrder({
    required this.id,
    this.displayId,
    required this.vendorStatus,
    this.orderStatus,
    required this.total,
    required this.createdAt,
    required this.items,
    this.shippingName,
  });

  factory VendorOrder.fromJson(Map<String, dynamic> json) {
    final order = json['order'] as Map<String, dynamic>?;
    final addr = order?['shipping_address'] as Map<String, dynamic>?;
    final rawItems = order?['items'] as List<dynamic>? ?? [];
    return VendorOrder(
      id: json['id'] as String,
      displayId: order?['display_id']?.toString(),
      // Backend VendorSubOrder model uses 'status' not 'vendor_status'
      vendorStatus: json['status'] as String? ?? 'pending',
      orderStatus: order?['status'] as String?,
      // Use VendorSubOrder.amount (vendor's portion) — order.total requires computed field prefix
      total: (json['amount'] as num?)?.toDouble() ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      items: rawItems.map((i) => VendorOrderItem.fromJson(i as Map<String, dynamic>)).toList(),
      shippingName: addr != null
          ? '${addr['first_name'] ?? ''} ${addr['last_name'] ?? ''}'.trim()
          : null,
    );
  }
}

class VendorOrderItem {
  final String id;
  final String title;
  final int quantity;
  final double unitPrice;
  final String? thumbnail;

  VendorOrderItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.unitPrice,
    this.thumbnail,
  });

  factory VendorOrderItem.fromJson(Map<String, dynamic> json) {
    final variant = json['variant'] as Map<String, dynamic>?;
    final product = variant?['product'] as Map<String, dynamic>?;
    return VendorOrderItem(
      id: json['id'] as String,
      title: json['title'] as String? ?? product?['title'] as String? ?? 'Product',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0,
      thumbnail: product?['thumbnail'] as String?,
    );
  }
}

// ─── Products ─────────────────────────────────────────────────────────────────

class VendorProduct {
  final String id;
  final String title;
  final String? description;
  final String? thumbnail;
  final List<String> images;
  final String status;
  final String productType;
  final double? price;
  final String? variantId;  // primary variant id (inventory-linked, for updates)
  final List<String> allVariantIds; // ALL variant ids — needed to update inventory on all
  final String? sku;
  final int inventoryQuantity;
  final bool manageInventory;

  VendorProduct({
    required this.id,
    required this.title,
    this.description,
    this.thumbnail,
    this.images = const [],
    required this.status,
    required this.productType,
    this.price,
    this.variantId,
    this.allVariantIds = const [],
    this.sku,
    this.inventoryQuantity = 0,
    this.manageInventory = false,
  });

  factory VendorProduct.fromJson(Map<String, dynamic> json) {
    final variants = json['variants'] as List<dynamic>?;
    double? price;
    String? variantId;
    String? sku;
    int inventoryQty = 0;
    bool manageInv = false;
    if (variants != null && variants.isNotEmpty) {
      // Sum inventory across ALL variants — a product may have multiple variants
      for (final raw in variants) {
        final v = raw as Map<String, dynamic>;
        final qty = (v['inventory_quantity'] as num?)?.toInt() ?? 0;
        inventoryQty += qty;
        if (v['manage_inventory'] as bool? ?? false) manageInv = true;
      }
      // For price/variantId/sku: prefer the variant that has a linked inventory item (qty > 0),
      // fall back to the first variant.
      final primary = variants
          .cast<Map<String, dynamic>>()
          .firstWhere(
            (v) => ((v['inventory_quantity'] as num?)?.toInt() ?? 0) > 0,
            orElse: () => variants.first as Map<String, dynamic>,
          );
      variantId = primary['id'] as String?;
      sku = primary['sku'] as String?;
      final prices = primary['prices'] as List<dynamic>?;
      if (prices != null && prices.isNotEmpty) {
        price = (prices.first['amount'] as num?)?.toDouble();
      }
    }
    final allVariantIds = (variants ?? [])
        .cast<Map<String, dynamic>>()
        .map((v) => v['id'] as String?)
        .whereType<String>()
        .toList();
    final rawImages = json['images'] as List<dynamic>? ?? [];
    return VendorProduct(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      thumbnail: json['thumbnail'] as String?,
      images: rawImages
          .map((i) => (i is Map ? i['url'] as String? : i as String?) ?? '')
          .where((s) => s.isNotEmpty)
          .toList(),
      status: json['status'] as String? ?? 'draft',
      productType: json['metadata']?['is_digital'] == true ? 'digital' : 'physical',
      price: price,
      variantId: variantId,
      allVariantIds: allVariantIds,
      sku: sku,
      inventoryQuantity: inventoryQty,
      manageInventory: manageInv,
    );
  }
}

// ─── Finances ─────────────────────────────────────────────────────────────────

class VendorBalance {
  final double availableBalance;
  final double pendingBalance;
  final double totalEarned;
  final double totalPaidOut;
  final String? payoutAccount;
  final List<LedgerEntry> ledger;
  final List<PayoutRequest> payoutRequests;

  VendorBalance({
    required this.availableBalance,
    required this.pendingBalance,
    required this.totalEarned,
    required this.totalPaidOut,
    this.payoutAccount,
    required this.ledger,
    required this.payoutRequests,
  });

  factory VendorBalance.fromJson(Map<String, dynamic> json) => VendorBalance(
        availableBalance: double.tryParse(json['available_balance']?.toString() ?? '') ?? 0,
        pendingBalance: double.tryParse(json['pending_balance']?.toString() ?? '') ?? 0,
        totalEarned: double.tryParse(json['total_earned']?.toString() ?? '') ?? 0,
        totalPaidOut: double.tryParse(json['total_paid_out']?.toString() ?? '') ?? 0,
        payoutAccount: json['payout_account'] as String?,
        ledger: (json['ledger'] as List<dynamic>? ?? [])
            .map((e) => LedgerEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
        payoutRequests: (json['payout_requests'] as List<dynamic>? ?? [])
            .map((e) => PayoutRequest.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class LedgerEntry {
  final String id;
  final String type;   // CREDIT / DEBIT
  final String status; // AVAILABLE / PENDING / REVERSED
  final double amount;
  final String? referenceType;
  final String? referenceId;
  final DateTime createdAt;

  LedgerEntry({
    required this.id,
    required this.type,
    required this.status,
    required this.amount,
    this.referenceType,
    this.referenceId,
    required this.createdAt,
  });

  factory LedgerEntry.fromJson(Map<String, dynamic> json) => LedgerEntry(
        id: json['id'] as String,
        type: json['type'] as String? ?? 'CREDIT',
        status: json['status'] as String? ?? 'AVAILABLE',
        amount: double.tryParse(json['amount']?.toString() ?? '') ?? 0,
        referenceType: json['reference_type'] as String?,
        referenceId: json['reference_id'] as String?,
        createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      );
}

class PayoutRequest {
  final String id;
  final double amount;
  final String status; // pending / approved / paid / rejected
  final DateTime? requestedAt;

  PayoutRequest({
    required this.id,
    required this.amount,
    required this.status,
    this.requestedAt,
  });

  factory PayoutRequest.fromJson(Map<String, dynamic> json) => PayoutRequest(
        id: json['id'] as String,
        amount: double.tryParse(json['amount']?.toString() ?? '') ?? 0,
        status: json['status'] as String? ?? 'pending',
        requestedAt: DateTime.tryParse(json['requested_at'] as String? ?? ''),
      );
}

// ─── Q&A ──────────────────────────────────────────────────────────────────────

class VendorQuestion {
  final String id;
  final String question;
  final String? answer;
  final bool isPublic;
  final String? productId;
  final String? productTitle;
  final String? productThumbnail;
  final DateTime createdAt;
  final DateTime? answeredAt;

  VendorQuestion({
    required this.id,
    required this.question,
    this.answer,
    required this.isPublic,
    this.productId,
    this.productTitle,
    this.productThumbnail,
    required this.createdAt,
    this.answeredAt,
  });

  factory VendorQuestion.fromJson(Map<String, dynamic> json) {
    final product = json['product'] as Map<String, dynamic>?;
    return VendorQuestion(
      id: json['id'] as String,
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String?,
      isPublic: json['is_public'] as bool? ?? false,
      productId: json['product_id'] as String?,
      productTitle: product?['title'] as String?,
      productThumbnail: product?['thumbnail'] as String?,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      answeredAt: DateTime.tryParse(json['answered_at'] as String? ?? ''),
    );
  }
}

// ─── Policies ─────────────────────────────────────────────────────────────────

class VendorPolicy {
  final String id;
  final int version;
  final String shippingPolicy;
  final String refundPolicy;
  final String returnPolicy;
  final String privacyPolicy;
  final String termsOfUse;

  VendorPolicy({
    required this.id,
    required this.version,
    required this.shippingPolicy,
    required this.refundPolicy,
    required this.returnPolicy,
    required this.privacyPolicy,
    required this.termsOfUse,
  });

  factory VendorPolicy.fromJson(Map<String, dynamic> json) => VendorPolicy(
        id: json['id'] as String,
        version: (json['version'] as num?)?.toInt() ?? 1,
        shippingPolicy: json['shipping_policy'] as String? ?? '',
        refundPolicy: json['refund_policy'] as String? ?? '',
        returnPolicy: json['return_policy'] as String? ?? '',
        privacyPolicy: json['privacy_policy'] as String? ?? '',
        termsOfUse: json['terms_of_use'] as String? ?? '',
      );
}
// Append to end of vendor_dashboard_model.dart — VendorSettings model

class VendorSettings {
  final String id;
  final String storeName;
  final String slug;
  final String? description;
  final String? logoUrl;
  final String? bannerUrl;
  final String? email;
  final String? phone;
  final String? payoutAccountId;

  VendorSettings({
    required this.id,
    required this.storeName,
    required this.slug,
    this.description,
    this.logoUrl,
    this.bannerUrl,
    this.email,
    this.phone,
    this.payoutAccountId,
  });

  factory VendorSettings.fromJson(Map<String, dynamic> json) => VendorSettings(
        id: json['id'] as String,
        storeName: json['store_name'] as String? ?? '',
        slug: json['slug'] as String? ?? '',
        description: json['description'] as String?,
        logoUrl: json['logo_url'] as String?,
        bannerUrl: json['banner_url'] as String?,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        payoutAccountId: json['payout_account_id'] as String?,
      );
}
