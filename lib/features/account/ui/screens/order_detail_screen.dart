// lib/features/account/ui/screens/order_detail_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';
import '../../data/models/order_model.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;
  const OrderDetailScreen({super.key, required this.order});

  Color _statusColor(BuildContext context, String s) {
    switch (s.toLowerCase()) {
      case 'completed':
      case 'fulfilled':
      case 'captured':
        return context.colors.success;
      case 'cancelled':
      case 'failed':
      case 'rejected':
        return context.colors.error;
      case 'pending':
      case 'not_fulfilled':
      case 'partially_fulfilled':
      case 'partially_captured':
        return context.colors.warning;
      case 'shipped':
        return context.colors.primary;
      default:
        return context.colors.textMuted;
    }
  }

  Widget _statusBadge(BuildContext context, String label, String status) {
    final color = _statusColor(context, status);
    return Row(
      children: [
        Text(label,
            style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
        SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status[0].toUpperCase() + status.substring(1),
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(t.account.order_number(id: order.displayId.toString()),
            style: TextStyle(
                color: context.colors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: context.colors.border),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Status card ─────────────────────────────────────────
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.account.order_status_title,
                    style: TextStyle(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                SizedBox(height: 12),
                _statusBadge(context, t.account.order_label, order.status),
                SizedBox(height: 8),
                _statusBadge(context, t.account.payment_label, order.paymentStatus),
                SizedBox(height: 8),
                _statusBadge(context, t.account.fulfillment_label, order.fulfillmentStatus),
                SizedBox(height: 12),
                Divider(color: context.colors.border, height: 1),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(t.account.placed,
                        style: TextStyle(
                            color: context.colors.textSecondary, fontSize: 13)),
                    Text(
                      _formatDate(order.createdAt),
                      style: TextStyle(
                          color: context.colors.textPrimary, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // ── Items ───────────────────────────────────────────────
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.account.items_count(count: order.items.length.toString()),
                    style: TextStyle(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                SizedBox(height: 12),
                ...order.items.asMap().entries.map((entry) {
                  final i = entry.key;
                  final item = entry.value;
                  return Column(
                    children: [
                      if (i > 0)
                        Divider(color: context.colors.border, height: 24),
                      _ItemRow(item: item),
                    ],
                  );
                }),
              ],
            ),
          ),

          SizedBox(height: 16),

          // ── Total ───────────────────────────────────────────────
          _Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(t.account.total,
                    style: TextStyle(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Text(
                  '₪${order.total.toStringAsFixed(2)}',
                  style: TextStyle(
                      color: context.colors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    final months = t.common.months;
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

// ─── Shared widgets ──────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: child,
    );
  }
}

class _ItemRow extends StatelessWidget {
  final OrderItemModel item;
  const _ItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: item.thumbnail != null
              ? CachedNetworkImage(
                  imageUrl: item.thumbnail!,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => _placeholder(context),
                )
              : _placeholder(context),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title,
                  style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              SizedBox(height: 4),
              Text(t.account.qty_label(count: item.quantity.toString()),
                  style: TextStyle(
                      color: context.colors.textSecondary, fontSize: 12)),
            ],
          ),
        ),
        Text(
          '₪${(item.unitPrice * item.quantity).toStringAsFixed(0)}',
          style: TextStyle(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 14),
        ),
      ],
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      color: context.colors.surfaceVariant,
      child: Icon(Icons.image_outlined,
          color: context.colors.textMuted, size: 24),
    );
  }
}
