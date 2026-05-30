// lib/features/cart/ui/screens/cart_screen.dart
// Mirrors ~/waslaq-storefront/src/modules/cart/components/item/index.tsx
// and ~/waslaq-storefront/src/modules/common/components/cart-totals/index.tsx

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../shared/utils/ils_formatter.dart';
import '../../../cart/providers/cart_provider.dart';
import '../../../../router/app_router.dart';

@RoutePage()
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(t.cart.title,
            style: TextStyle(color: context.colors.textPrimary)),
        backgroundColor: context.colors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: cartAsync.when(
        loading: () => Center(
            child: CircularProgressIndicator(color: context.colors.primary)),
        error: (e, _) => Center(
          child: Text(t.cart.could_not_load,
              style: TextStyle(color: context.colors.textPrimary)),
        ),
        data: (cart) => cart.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined,
                        color: context.colors.textMuted, size: 64),
                    SizedBox(height: 16),
                    Text(t.cart.empty_title,
                        style: TextStyle(
                            color: context.colors.textSecondary, fontSize: 16)),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.router.replace(const HomeRoute()),
                      child: Text(t.cart.start_shopping),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  // ── Line items ──────────────────────────────────────
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: cart.items.length,
                      separatorBuilder: (_, __) =>
                          Divider(color: context.colors.border, height: 24),
                      itemBuilder: (ctx, i) {
                        final item = cart.items[i];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Thumbnail
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                width: 72,
                                height: 72,
                                child: item.thumbnail != null
                                    ? CachedNetworkImage(
                                        imageUrl: item.thumbnail!,
                                        fit: BoxFit.cover,
                                        errorWidget: (_, __, ___) =>
                                            Container(
                                              color: context.colors.surfaceVariant,
                                              child: Icon(
                                                  Icons.image_not_supported,
                                                  color: context.colors.textMuted),
                                            ),
                                      )
                                    : Container(
                                        color: context.colors.surfaceVariant,
                                        child: Icon(
                                            Icons.image_not_supported,
                                            color: context.colors.textMuted),
                                      ),
                              ),
                            ),
                            SizedBox(width: 12),

                            // Title + variant + price
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: TextStyle(
                                        color: context.colors.textPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (item.variantTitle != null)
                                    Text(item.variantTitle!,
                                        style: TextStyle(
                                            color: context.colors.textMuted,
                                            fontSize: 12)),
                                  SizedBox(height: 4),
                                  // unit_price — raw ILS
                                  Text(
                                    ILSFormatter.format(item.unitPrice),
                                    style: TextStyle(
                                        color: context.colors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),

                            // Quantity controls
                            Column(
                              children: [
                                _QtyButton(
                                  icon: item.quantity <= 1
                                      ? Icons.delete_outline
                                      : Icons.remove,
                                  onTap: item.quantity <= 1
                                      ? () => ref
                                          .read(cartProvider.notifier)
                                          .removeItem(item.id)
                                      : () => ref
                                          .read(cartProvider.notifier)
                                          .updateItem(
                                              item.id, item.quantity - 1),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Text('${item.quantity}',
                                      style: TextStyle(
                                          color: context.colors.textPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600)),
                                ),
                                _QtyButton(
                                  icon: Icons.add,
                                  onTap: () => ref
                                      .read(cartProvider.notifier)
                                      .updateItem(
                                          item.id, item.quantity + 1),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // ── Order summary + checkout ─────────────────────────
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      border:
                          Border(top: BorderSide(color: context.colors.border)),
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          // item_subtotal
                          _SummaryRow(
                            label: t.cart.subtotal,
                            value: ILSFormatter.format(cart.subtotal),
                          ),
                          // shipping_subtotal (if non-zero)
                          if ((cart.shippingSubtotal ?? 0) > 0) ...[
                            SizedBox(height: 6),
                            _SummaryRow(
                              label: t.cart.shipping,
                              value: ILSFormatter.format(cart.shippingSubtotal!),
                            ),
                          ],
                          // discount_subtotal (if non-zero)
                          if ((cart.discountSubtotal ?? 0) > 0) ...[
                            SizedBox(height: 6),
                            _SummaryRow(
                              label: t.cart.discount,
                              value:
                                  '–${ILSFormatter.format(cart.discountSubtotal!)}' ,
                              valueColor: context.colors.success,
                            ),
                          ],
                          Divider(color: context.colors.border, height: 20),
                          // total
                          _SummaryRow(
                            label: t.cart.total,
                            value: ILSFormatter.format(cart.total),
                            labelStyle: TextStyle(
                                color: context.colors.textPrimary,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                            valueStyle: TextStyle(
                                color: context.colors.primary,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.colors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26)),
                                textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () =>
                                  context.router.push(const CheckoutRoute()),
                              child: Text(t.cart.proceed_to_checkout),
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: context.colors.surfaceVariant,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: context.colors.textPrimary),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: labelStyle ??
                TextStyle(
                    color: context.colors.textSecondary, fontSize: 14)),
        Text(value,
            style: valueStyle ??
                TextStyle(
                    color: valueColor ?? context.colors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
      ],
    );
  }
}
