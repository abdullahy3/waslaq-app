// lib/features/account/ui/screens/orders_screen.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';
import '../../data/models/order_model.dart';
import '../../providers/account_providers.dart';
import 'order_detail_screen.dart';

@RoutePage()
class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(t.orders.title,
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
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(ordersProvider),
        child: ordersAsync.when(
          loading: () => _Skeleton(),
          error: (err, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: context.colors.error),
                SizedBox(height: 12),
                Text(t.orders.failed_load,
                    style: TextStyle(color: context.colors.textPrimary, fontSize: 16)),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => ref.invalidate(ordersProvider),
                  child: Text(t.orders.retry),
                ),
              ],
            ),
          ),
          data: (orders) {
            if (orders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined,
                        size: 72, color: context.colors.border),
                    SizedBox(height: 16),
                    Text(t.orders.no_orders,
                        style: TextStyle(color: context.colors.textSecondary, fontSize: 16)),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _OrderTile(
                order: orders[index],
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => OrderDetailScreen(order: orders[index]),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Skeleton loader ────────────────────────────────────────────────────────

class _Skeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, __) => SizedBox(height: 12),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: context.colors.surfaceVariant,
        highlightColor: context.colors.border,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

// ─── Order tile ──────────────────────────────────────────────────────────────

class _OrderTile extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;
  const _OrderTile({required this.order, required this.onTap});

  // Two-state vendor flow (mirrors web): 'shipped' => Delivered (green),
  // anything else => Processing (amber).
  bool get _delivered => order.fulfillmentStatus.toLowerCase() == 'shipped';

  Color _statusColor(BuildContext context) =>
      _delivered ? context.colors.success : context.colors.warning;

  String _statusLabel() =>
      _delivered ? t.account.delivered : t.account.processing;

  String _timeAgo(BuildContext context) {
    final diff = DateTime.now().difference(order.createdAt);
    if (diff.inDays == 0) return t.orders.today;
    if (diff.inDays == 1) return t.orders.yesterday;
    if (diff.inDays < 7) return t.orders.days_ago(n: diff.inDays);
    if (diff.inDays < 30) return t.orders.weeks_ago(n: diff.inDays ~/ 7);
    return t.orders.months_ago(n: diff.inDays ~/ 30);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.receipt_long_outlined,
                  color: context.colors.primary, size: 24),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('#${order.displayId}',
                      style: TextStyle(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  SizedBox(height: 4),
                  Text(
                    '${order.items.length} item${order.items.length != 1 ? 's' : ''} · ${_timeAgo(context)}',
                    style: TextStyle(
                        color: context.colors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₪${order.total.toStringAsFixed(0)}',
                  style: TextStyle(
                      color: context.colors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statusColor(context).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel(),
                    style: TextStyle(
                        color: _statusColor(context),
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(width: 4),
            Icon(Icons.chevron_right, color: context.colors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
