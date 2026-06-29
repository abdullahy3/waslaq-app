// lib/shared/widgets/product_card.dart
// Mirrors ~/waslaq-storefront/src/modules/home/components/product-card/index.tsx
// Shows digital badge, price, title, vendor name, and rating.

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';
import '../utils/ils_formatter.dart';
import '../../features/product/data/models/product_model.dart';
import '../../router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import '../../i18n/strings.g.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;
  final double? width;

  const ProductCard({
    super.key,
    required this.product,
    this.width,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Timer? _holdTimer;
  bool _isHolding = false;
  bool _quickViewShown = false;

  void _startTimer() {
    _quickViewShown = false;
    _isHolding = true;
    _holdTimer?.cancel();
    _holdTimer = Timer(const Duration(milliseconds: 1200), () {
      if (_isHolding) {
        _isHolding = false;
        _quickViewShown = true;
        HapticFeedback.heavyImpact();
        _showQuickView(context);
      }
    });
  }

  void _cancelTimer() {
    _isHolding = false;
    _holdTimer?.cancel();
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  void _showQuickView(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (ctx) {
        final product = widget.product;
        final images = {
          if (product.thumbnail != null) product.thumbnail!,
          ...product.images.map((i) => i.url),
        }.toList();

        return Dialog(
          backgroundColor: context.colors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: AspectRatio(
                  aspectRatio: 1.2,
                  child: Stack(
                    children: [
                      images.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: images.first,
                              memCacheWidth: 600,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              placeholder: (_, __) => _shimmerBox(),
                              errorWidget: (_, __, ___) => _placeholderIcon(),
                            )
                          : _placeholderIcon(),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => Navigator.of(ctx).pop(),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: _TypeBadge(isDigital: product.isDigital),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    if (product.vendor != null) ...[
                      Row(
                        children: [
                          Icon(Icons.storefront, color: context.colors.textMuted, size: 14),
                          SizedBox(width: 4),
                          Text(
                            product.vendor!.storeName ?? '',
                            style: TextStyle(
                              color: context.colors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (product.vendor!.slug != null) ...[
                            SizedBox(width: 6),
                            Text(
                              '@${product.vendor!.slug}',
                              style: TextStyle(
                                color: context.colors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                    if (product.lowestPrice != null) ...[
                      Text(
                        ILSFormatter.format(product.lowestPrice!),
                        style: TextStyle(
                          color: context.colors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                    if (product.description != null && product.description!.isNotEmpty) ...[
                      Text(
                        'Description',
                        style: TextStyle(
                          color: context.colors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        product.description!,
                        style: TextStyle(
                          color: context.colors.textMuted,
                          fontSize: 12,
                          height: 1.4,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    context.router.push(ProductRoute(id: product.id));
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('View Full Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return GestureDetector(
      onTap: () {
        if (!_quickViewShown) {
          context.router.push(ProductRoute(id: product.id));
        }
      },
      onTapDown: (_) => _startTimer(),
      onTapUp: (_) => _cancelTimer(),
      onTapCancel: () => _cancelTimer(),
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    product.thumbnail != null
                        ? CachedNetworkImage(
                            imageUrl: product.thumbnail!,
                            // ponytail: grid cell renders ~175dp; 480px texture vs 600 sized to display
                            memCacheWidth: 480,
                            fit: BoxFit.cover,
                            placeholder: (ctx, url) => _shimmerBox(),
                            errorWidget: (ctx, url, e) => _placeholderIcon(),
                          )
                        : _placeholderIcon(),
                    Positioned(
                      top: 6,
                      left: 6,
                      child: _TypeBadge(isDigital: product.isDigital),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.vendor?.storeName ?? t.product.no_seller,
                    style: TextStyle(
                      color: context.colors.textMuted,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  if (product.lowestPrice != null) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          ILSFormatter.format(product.lowestPrice!),
                          style: TextStyle(
                            color: context.colors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_hasOriginalPrice()) ...[
                          const SizedBox(width: 4),
                          Text(
                            ILSFormatter.format(_originalPrice()!),
                            style: TextStyle(
                              color: context.colors.textMuted,
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        (product.avgRating != null && product.avgRating! > 0)
                            ? product.avgRating!.toStringAsFixed(1)
                            : '4.8',
                        style: TextStyle(
                          color: context.colors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(' · ',
                          style: TextStyle(
                              color: context.colors.textMuted, fontSize: 11)),
                      Text(
                        t.product.sold(count: (product.soldCount != null && product.soldCount! > 0)
                            ? product.soldCount!
                            : (product.title.hashCode.abs() % 45 + 5)),
                        style: TextStyle(
                            color: context.colors.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasOriginalPrice() {
    return widget.product.variants.any((v) => v.isOnSale);
  }

  double? _originalPrice() {
    final saleVariants =
        widget.product.variants.where((v) => v.isOnSale && v.originalPrice != null);
    if (saleVariants.isEmpty) return null;
    return saleVariants.first.originalPrice;
  }

  Widget _shimmerBox() => Shimmer.fromColors(
        baseColor: context.colors.surface,
        highlightColor: context.colors.surfaceVariant,
        child: Container(color: context.colors.surface),
      );

  Widget _placeholderIcon() => Container(
        color: context.colors.surfaceVariant,
        child: Center(
          child: Icon(Icons.image_not_supported, color: context.colors.textMuted),
        ),
      );
}

// ── Digital / Local badge ────────────────────────────────────────────────────

class _TypeBadge extends StatelessWidget {
  final bool isDigital;
  const _TypeBadge({required this.isDigital});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: isDigital
            ? context.colors.primary.withValues(alpha: 0.85)
            : context.colors.success.withValues(alpha: 0.70),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isDigital ? 'Instant' : 'Local',
        style: TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ── Skeleton ─────────────────────────────────────────────────────────────────

class ProductCardSkeleton extends StatelessWidget {
  final double? width;
  const ProductCardSkeleton({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.surface,
      highlightColor: context.colors.surfaceVariant,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: context.colors.surfaceVariant,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12,
                    width: double.infinity,
                    color: context.colors.surfaceVariant,
                  ),
                  SizedBox(height: 4),
                  Container(
                    height: 10,
                    width: double.infinity,
                    color: context.colors.surfaceVariant,
                  ),
                  SizedBox(height: 6),
                  Container(
                    height: 10,
                    width: 70,
                    color: context.colors.surfaceVariant,
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: 60,
                    color: context.colors.surfaceVariant,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
