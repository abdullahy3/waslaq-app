// lib/features/account/ui/screens/order_detail_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';
import '../../data/models/order_model.dart';
import '../../providers/dispute_providers.dart';

class OrderDetailScreen extends ConsumerWidget {
  final OrderModel order;
  const OrderDetailScreen({super.key, required this.order});

  // Vendor flow is two-state (mirrors web order-tracking):
  //   vendor_sub_order.status 'shipped' => Delivered, anything else => Processing.
  bool get _delivered => order.fulfillmentStatus.toLowerCase() == 'shipped';

  // Timeline: Order Placed (0) -> Processing (1) -> Delivered (2).
  int get _currentStep => _delivered ? 2 : 1;

  // Dispute eligibility:
  // - Shipped: always show (backend enforces 1h min / 4-day max after ship date)
  // - Not shipped: show only between 72h and 30 days after order placement
  bool get _canOpenDispute {
    if (_delivered) return true;
    final hoursSinceOrder =
        DateTime.now().difference(order.createdAt).inHours;
    return hoursSinceOrder >= 72 && hoursSinceOrder <= 720;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(t.account.order_number(id: order.displayId.toString()),
            style: TextStyle(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.bold)),
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
          // ── Header: placed date + status pill ───────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '${t.account.placed} ${_formatDate(order.createdAt)}',
                  style: TextStyle(
                      color: context.colors.textSecondary, fontSize: 13),
                ),
              ),
              _StatusPill(delivered: _delivered),
            ],
          ),

          const SizedBox(height: 16),

          // ── Order Progress stepper ──────────────────────────────
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.account.order_progress,
                    style: TextStyle(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                const SizedBox(height: 24),
                _ProgressStepper(currentStep: _currentStep),
                const SizedBox(height: 8),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Items + Total ───────────────────────────────────────
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.account.items,
                    style: TextStyle(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                Divider(color: context.colors.border, height: 1),
                const SizedBox(height: 16),
                Row(
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
                          fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (_canOpenDispute) ...[
            const SizedBox(height: 8),
            _OpenDisputeButton(order: order),
          ],
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

// ─── Open Dispute Button ──────────────────────────────────────────────────────

class _OpenDisputeButton extends ConsumerWidget {
  final OrderModel order;
  const _OpenDisputeButton({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: OutlinedButton.icon(
        onPressed: () => _showDisputeSheet(context, ref),
        icon: const Icon(Icons.gavel_outlined, size: 18),
        label: const Text('Open a Dispute'),
        style: OutlinedButton.styleFrom(
          foregroundColor: context.colors.error,
          side: BorderSide(color: context.colors.error),
          minimumSize: const Size(double.infinity, 48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  void _showDisputeSheet(BuildContext context, WidgetRef ref) {
    String selectedType = 'not_delivered';
    final descController = TextEditingController();
    bool loading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.fromLTRB(
              20, 24, 20, 20 + MediaQuery.of(ctx).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Open a Dispute',
                style: TextStyle(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: InputDecoration(
                  labelText: 'Reason',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'not_delivered', child: Text('Not Delivered')),
                  DropdownMenuItem(
                      value: 'damaged', child: Text('Damaged')),
                  DropdownMenuItem(
                      value: 'product_not_as_described',
                      child: Text('Not as Described')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (v) =>
                    setState(() => selectedType = v ?? selectedType),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Describe your issue',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: loading
                      ? null
                      : () async {
                          if (descController.text.trim().isEmpty) return;
                          setState(() => loading = true);
                          try {
                            final itemId = order.items.isNotEmpty
                                ? order.items[0].id
                                : '';
                            await ref
                                .read(disputeRepositoryProvider)
                                .openDispute(
                                  orderId: order.id,
                                  orderItemId: itemId,
                                  disputeType: selectedType,
                                  description:
                                      descController.text.trim(),
                                );
                            if (ctx.mounted) Navigator.pop(ctx);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Dispute opened successfully. We will review it shortly.')),
                              );
                            }
                          } catch (e) {
                            setState(() => loading = false);
                            if (ctx.mounted) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          }
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: context.colors.error,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text('Submit Dispute'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Status pill (Delivered = green, Processing = amber) ──────────────────────

class _StatusPill extends StatelessWidget {
  final bool delivered;
  const _StatusPill({required this.delivered});

  @override
  Widget build(BuildContext context) {
    final color =
        delivered ? context.colors.success : context.colors.warning;
    final label = delivered ? t.account.delivered : t.account.processing;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style:
            TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ─── 3-step progress timeline ─────────────────────────────────────────────────

class _ProgressStepper extends StatelessWidget {
  final int currentStep; // 0..2
  const _ProgressStepper({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = <(String, String)>[
      ('🛒', t.account.order_placed),
      ('⚙️', t.account.processing),
      ('✅', t.account.delivered),
    ];
    const circle = 40.0;

    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final trackLeft = (w / 3) / 2;
        final trackWidth = w - 2 * trackLeft;
        final fillWidth = trackWidth * (currentStep / (steps.length - 1));

        return Stack(
          children: [
            Positioned(
              left: trackLeft,
              top: circle / 2 - 1,
              child: Container(
                  width: trackWidth, height: 2, color: context.colors.border),
            ),
            Positioned(
              left: trackLeft,
              top: circle / 2 - 1,
              child: Container(
                  width: fillWidth,
                  height: 2,
                  color: context.colors.primary),
            ),
            Row(
              children: List.generate(steps.length, (i) {
                final done = i <= currentStep;
                return Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: circle,
                        height: circle,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: done
                              ? context.colors.primary
                              : context.colors.surface,
                          border: Border.all(
                            color: done
                                ? context.colors.primary
                                : context.colors.border,
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(steps[i].$1,
                            style: const TextStyle(fontSize: 17)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        steps[i].$2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: done
                              ? context.colors.primary
                              : context.colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
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
        const SizedBox(width: 12),
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
              const SizedBox(height: 4),
              Text(t.account.qty_label(count: item.quantity.toString()),
                  style: TextStyle(
                      color: context.colors.textSecondary, fontSize: 12)),
            ],
          ),
        ),
        Text(
          '₪${(item.unitPrice * item.quantity).toStringAsFixed(2)}',
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
      child:
          Icon(Icons.image_outlined, color: context.colors.textMuted, size: 24),
    );
  }
}
