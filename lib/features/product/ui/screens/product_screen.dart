// lib/features/product/ui/screens/product_screen.dart
// Layout: image gallery + thumbnails, vendor card, trust banner,
// variant selector, description, sticky add-to-cart bar.

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/utils/ils_formatter.dart';
import '../../../product/providers/product_provider.dart';
import '../../../cart/providers/cart_provider.dart';
import '../../../../core/api/medusa_client.dart';
import '../../../../router/app_router.dart';
import '../../../../i18n/strings.g.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/models/product_model.dart';

@RoutePage()
class ProductScreen extends ConsumerStatefulWidget {
  final String id;
  const ProductScreen({
    super.key,
    @PathParam('id') required this.id,
  });

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  String? _selectedVariantId;
  int _selectedImageIndex = 0;
  bool _addingToCart = false;
  // Reviews, Q&A, Related
  List<dynamic> _reviews = [];
  List<dynamic> _questions = [];
  List<dynamic> _relatedProducts = [];
  bool _extrasLoaded = false;
  // Review/Question form state
  bool _showReviewForm = false;
  bool _showQuestionForm = false;
  int _reviewRating = 5;
  final _reviewCommentCtrl = TextEditingController();
  final _questionCtrl = TextEditingController();
  bool _submittingReview = false;
  bool _submittingQuestion = false;
  String? _reviewError;
  String? _questionError;
  String? _reviewSuccess;
  String? _questionSuccess;

  void _loadExtras(String productId) {
    if (_extrasLoaded) return;
    _extrasLoaded = true;
    // Load reviews
    MedusaClient.instance.get('/store/products/$productId/reviews').then((res) {
      if (mounted) setState(() => _reviews = res.data['reviews'] as List<dynamic>? ?? []);
    }).catchError((_) {});
    // Load Q&A
    MedusaClient.instance.get('/store/products/$productId/questions').then((res) {
      if (mounted) setState(() => _questions = res.data['questions'] as List<dynamic>? ?? []);
    }).catchError((_) {});
    // Load related products (same tags/collection)
    MedusaClient.instance.get('/store/products', queryParameters: {
      'limit': 10, 'region_id': 'reg_01KQ6035AK6FMA4R1XJ76RTPGH',
      'fields': '*variants.calculated_price',
    }).then((res) {
      final all = res.data['products'] as List<dynamic>? ?? [];
      if (mounted) setState(() => _relatedProducts = all.where((p) => p['id'] != productId).take(6).toList());
    }).catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailProvider(widget.id));

    return Scaffold(
      backgroundColor: context.colors.background,
      body: productAsync.when(
        loading: () => _buildSkeleton(),
        error: (e, _) => Center(
          child: Text(t.product.product_not_found,
              style: TextStyle(color: context.colors.textPrimary)),
        ),
        data: (product) {
          _selectedVariantId ??= product.variants.isNotEmpty
              ? product.variants.first.id
              : null;
          _loadExtras(product.id);
          final selectedVariant = product.variants
              .where((v) => v.id == _selectedVariantId)
              .firstOrNull;

          final images = {
            if (product.thumbnail != null) product.thumbnail!,
            ...product.images.map((i) => i.url),
          }.toList();

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 340,
                backgroundColor: context.colors.background,
                pinned: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      color: context.colors.textPrimary),
                  onPressed: () => context.router.maybePop(),
                ),
                actions: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4), shape: BoxShape.circle),
                      child: Icon(Icons.share_rounded, color: Colors.white, size: 18),
                    ),
                    onPressed: () {
                      final url = 'https://waslaq.com/products/${product.handle ?? product.id}';
                      Share.share(t.product.share_product(title: product.title, url: url));
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: images.isEmpty
                      ? Container(color: context.colors.surfaceVariant)
                      : GestureDetector(
                          onTap: () => _openFullImageViewer(context, images, _selectedImageIndex),
                          child: CachedNetworkImage(
                            imageUrl: images[_selectedImageIndex],
                            fit: BoxFit.cover,
                            placeholder: (ctx, url) => Shimmer.fromColors(
                              baseColor: context.colors.surface,
                              highlightColor: context.colors.surfaceVariant,
                              child: Container(color: context.colors.surface),
                            ),
                            errorWidget: (ctx, url, e) => Container(
                              color: context.colors.surfaceVariant,
                              child: Center(
                                child: Icon(Icons.image_not_supported,
                                    color: context.colors.textMuted, size: 64),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thumbnail strip
                    if (images.length > 1)
                      SizedBox(
                        height: 72,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          itemCount: images.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(width: 8),
                          itemBuilder: (ctx, idx) => GestureDetector(
                            onTap: () =>
                                setState(() => _selectedImageIndex = idx),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _selectedImageIndex == idx
                                      ? context.colors.primary
                                      : context.colors.border,
                                  width: _selectedImageIndex == idx ? 2 : 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: CachedNetworkImage(
                                    imageUrl: images[idx],
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Title + price
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.title,
                              style: TextStyle(
                                  color: context.colors.textPrimary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  height: 1.3)),
                          SizedBox(height: 10),
                          if (selectedVariant?.price != null)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    ILSFormatter.format(
                                        selectedVariant!.price!),
                                    style: TextStyle(
                                        color: context.colors.primary,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold)),
                                if (selectedVariant.isOnSale &&
                                    selectedVariant.originalPrice != null) ...[
                                  SizedBox(width: 8),
                                  Text(
                                      ILSFormatter.format(
                                          selectedVariant.originalPrice!),
                                      style: TextStyle(
                                          color: context.colors.textMuted,
                                          fontSize: 16,
                                          decoration:
                                              TextDecoration.lineThrough)),
                                ],
                              ],
                            ),
                        ],
                      ),
                    ),

                    // Vendor card
                    if (product.vendor != null) ...[
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GestureDetector(
                          onTap: () {
                            if (product.vendor!.slug != null) {
                              context.router.push(VendorProfileRoute(slug: product.vendor!.slug!));
                            }
                          },
                          child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: context.colors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: context.colors.border),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: product.vendor!.logoUrl != null
                                      ? CachedNetworkImage(
                                          imageUrl: product.vendor!.logoUrl!,
                                          fit: BoxFit.cover,
                                          errorWidget: (_, __, ___) =>
                                              _vendorInitial(
                                                  product.vendor!.storeName))
                                      : _vendorInitial(
                                          product.vendor!.storeName),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(product.vendor!.storeName ?? '',
                                            style: TextStyle(
                                                color: context.colors.textPrimary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                        if (product.vendor!.slug != null) ...[
                                          SizedBox(width: 6),
                                          Text(
                                            '@${product.vendor!.slug}',
                                            style: TextStyle(
                                                color: context.colors.primary,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 11),
                                          ),
                                        ],
                                      ],
                                    ),
                                    Text(t.product.official_store,
                                        style: TextStyle(
                                            color: context.colors.textMuted,
                                            fontSize: 11)),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right,
                                  color: context.colors.textMuted),
                            ],
                          ),
                        ),
                        ),
                      ),
                    ],

                    // Trust banner
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: context.colors.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: context.colors.primary.withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          children: [
                            _TrustRow(
                                icon: Icons.local_shipping_outlined,
                                label: t.product.delivery_hint_trust),
                            SizedBox(height: 10),
                            _TrustRow(
                                icon: Icons.verified_user_outlined,
                                label:
                                    t.product.buyer_protection_trust),
                          ],
                        ),
                      ),
                    ),

                    // Variant selector
                    if (product.variants.length > 1) ...[
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(t.product.options,
                            style: TextStyle(
                                color: context.colors.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: product.variants
                              .map((v) => GestureDetector(
                                    onTap: () => setState(
                                        () => _selectedVariantId = v.id),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 150),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: _selectedVariantId == v.id
                                            ? context.colors.primary
                                            : context.colors.surface,
                                        borderRadius:
                                            BorderRadius.circular(8),
                                        border: Border.all(
                                          color: _selectedVariantId == v.id
                                              ? context.colors.primary
                                              : context.colors.border,
                                        ),
                                      ),
                                      child: Text(
                                        v.title ?? t.product.default_variant,
                                        style: TextStyle(
                                          color: _selectedVariantId == v.id
                                              ? Colors.white
                                              : context.colors.textPrimary,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],

                    // Description
                    if (product.description != null) ...[
                      SizedBox(height: 20),
                      Divider(color: context.colors.border, height: 1),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(t.product.product_info,
                                style: TextStyle(
                                    color: context.colors.textSecondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(height: 8),
                            Text(product.description!,
                                style: TextStyle(
                                    color: context.colors.textPrimary,
                                    height: 1.6,
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                    SizedBox(height: 100),

                    // ── Reviews Section ──────────────────────
                    Divider(color: context.colors.border, height: 1),
                    Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(children: [
                        Text(t.product.customer_reviews_count(count: _reviews.length.toString()), style: TextStyle(color: context.colors.textSecondary, fontSize: 14, fontWeight: FontWeight.w600)),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => setState(() { _showReviewForm = !_showReviewForm; _reviewError = null; _reviewSuccess = null; }),
                          child: Text(_showReviewForm ? t.common.cancel : t.product.write_review,
                              style: TextStyle(color: context.colors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                      ])),
                    if (_reviewSuccess != null)
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Text(_reviewSuccess!, style: TextStyle(color: context.colors.success, fontSize: 12))),
                    // Review form
                    if (_showReviewForm)
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Container(padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: context.colors.surface, borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: context.colors.border)),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(t.product.your_rating, style: TextStyle(color: context.colors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                            SizedBox(height: 6),
                            Row(children: List.generate(5, (i) => GestureDetector(
                              onTap: () => setState(() => _reviewRating = i + 1),
                              child: Padding(padding: const EdgeInsets.only(right: 4),
                                child: Icon(i < _reviewRating ? Icons.star_rounded : Icons.star_outline_rounded,
                                    color: Colors.amber, size: 32)),
                            ))),
                            SizedBox(height: 12),
                            TextField(controller: _reviewCommentCtrl, maxLines: 3,
                              style: TextStyle(color: context.colors.textPrimary, fontSize: 13),
                              decoration: InputDecoration(hintText: t.product.write_your_review, hintStyle: TextStyle(color: context.colors.textMuted),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.colors.border)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.colors.primary)),
                                contentPadding: const EdgeInsets.all(10))),
                            if (_reviewError != null) Padding(padding: const EdgeInsets.only(top: 6),
                              child: Text(_reviewError!, style: TextStyle(color: context.colors.error, fontSize: 11))),
                            SizedBox(height: 10),
                            Align(alignment: Alignment.centerRight, child: ElevatedButton(
                              onPressed: _submittingReview ? null : () => _submitReview(product.id),
                              style: ElevatedButton.styleFrom(backgroundColor: context.colors.primary, foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                              child: _submittingReview ? SizedBox(width: 16, height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : Text(t.product.submit_review, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)))),
                          ]))),
                    // Existing reviews
                    if (_reviews.isNotEmpty) ...[
                      ..._reviews.take(3).map((r) {
                        final rv = r as Map<String, dynamic>;
                        final rating = (rv['rating'] as num?)?.toInt() ?? 0;
                        final comment = rv['comment'] as String? ?? rv['content'] as String? ?? '';
                        final name = rv['display_name'] as String? ?? t.product.verified_buyer;
                        return Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: Container(padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: context.colors.surface, borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: context.colors.border)),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(children: [
                                ...List.generate(5, (s) => Icon(s < rating ? Icons.star_rounded : Icons.star_outline_rounded, color: Colors.amber, size: 14)),
                                SizedBox(width: 6),
                                Text(name, style: TextStyle(color: context.colors.textMuted, fontSize: 11)),
                              ]),
                              if (comment.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6),
                                child: Text(comment, style: TextStyle(color: context.colors.textPrimary, fontSize: 13, height: 1.4))),
                            ])));
                      }),
                    ],

                    // ── Q&A Section ──────────────────────────
                    Divider(color: context.colors.border, height: 1),
                    Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(children: [
                        Text(t.product.questions_answers_count(count: _questions.length.toString()), style: TextStyle(color: context.colors.textSecondary, fontSize: 14, fontWeight: FontWeight.w600)),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => setState(() { _showQuestionForm = !_showQuestionForm; _questionError = null; _questionSuccess = null; }),
                          child: Text(_showQuestionForm ? t.common.cancel : t.product.ask_question,
                              style: TextStyle(color: context.colors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                      ])),
                    if (_questionSuccess != null)
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Text(_questionSuccess!, style: TextStyle(color: context.colors.success, fontSize: 12))),
                    // Question form
                    if (_showQuestionForm)
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Container(padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: context.colors.surface, borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: context.colors.border)),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            TextField(controller: _questionCtrl, maxLines: 3,
                              style: TextStyle(color: context.colors.textPrimary, fontSize: 13),
                              decoration: InputDecoration(hintText: t.product.type_your_question,
                                hintStyle: TextStyle(color: context.colors.textMuted),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.colors.border)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.colors.primary)),
                                contentPadding: const EdgeInsets.all(10))),
                            if (_questionError != null) Padding(padding: const EdgeInsets.only(top: 6),
                              child: Text(_questionError!, style: TextStyle(color: context.colors.error, fontSize: 11))),
                            SizedBox(height: 10),
                            Align(alignment: Alignment.centerRight, child: ElevatedButton(
                              onPressed: _submittingQuestion ? null : () => _submitQuestion(product),
                              style: ElevatedButton.styleFrom(backgroundColor: context.colors.primary, foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                              child: _submittingQuestion ? SizedBox(width: 16, height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : Text(t.product.submit_question, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)))),
                          ]))),
                    // Existing questions
                    if (_questions.isNotEmpty) ...[
                      ..._questions.take(3).map((q) {
                        final qa = q as Map<String, dynamic>;
                        return Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: Container(padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: context.colors.surface, borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: context.colors.border)),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('Q: ${qa['question'] ?? ''}', style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                              if (qa['answer'] != null && (qa['answer'] as String).isNotEmpty) ...[                                
                                SizedBox(height: 8),
                                Container(padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(color: context.colors.primary.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border(left: BorderSide(color: context.colors.primary, width: 3))),
                                  child: Text(qa['answer'] as String, style: TextStyle(color: context.colors.textPrimary, fontSize: 12))),
                                                            ] else
                                Padding(padding: const EdgeInsets.only(top: 4),
                                  child: Text(t.product.waiting_answer, style: TextStyle(color: context.colors.textMuted, fontSize: 11, fontStyle: FontStyle.italic))),
                            ])));
                      }),
                    ],

                    // ── You Might Also Like ──────────────────
                    if (_relatedProducts.isNotEmpty) ...[                      
                      Divider(color: context.colors.border, height: 1),
                      Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Text(t.product.you_might_also_like, style: TextStyle(color: context.colors.textSecondary, fontSize: 14, fontWeight: FontWeight.w600))),
                      SizedBox(height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: _relatedProducts.length,
                          itemBuilder: (ctx, i) {
                            final rp = _relatedProducts[i] as Map<String, dynamic>;
                            final title = rp['title'] as String? ?? '';
                            final thumb = rp['thumbnail'] as String?;
                            final handle = rp['handle'] as String?;
                            final variants = rp['variants'] as List<dynamic>? ?? [];
                            final priceObj = variants.isNotEmpty
                                ? (variants[0] as Map<String, dynamic>)['calculated_price'] as Map<String, dynamic>?
                                : null;
                            final price = priceObj?['calculated_amount'];
                            return GestureDetector(
                              onTap: () { if (handle != null) context.router.push(ProductRoute(id: handle)); },
                              child: Container(width: 140, margin: const EdgeInsets.symmetric(horizontal: 4),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(10),
                                    child: thumb != null
                                        ? CachedNetworkImage(imageUrl: thumb, fit: BoxFit.cover, width: 140,
                                            errorWidget: (_, __, ___) => Container(color: context.colors.surfaceVariant))
                                        : Container(color: context.colors.surfaceVariant,
                                            child: Center(child: Icon(Icons.image_outlined, color: context.colors.textMuted))))),
                                  SizedBox(height: 6),
                                  Text(title, maxLines: 2, overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: context.colors.textPrimary, fontSize: 12, fontWeight: FontWeight.w500)),
                                  if (price != null)
                                    Text(ILSFormatter.format(price is num ? price.toDouble() : double.tryParse('$price') ?? 0),
                                        style: TextStyle(color: context.colors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                                ])),
                            );
                          },
                        ),
                      ),
                    ],
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: productAsync.valueOrNull == null
          ? null
          : Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              decoration: BoxDecoration(
                color: context.colors.surface,
                border:
                    Border(top: BorderSide(color: context.colors.border)),
              ),
              child: SafeArea(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          context.colors.primary.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26)),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed:
                        _selectedVariantId == null || _addingToCart
                            ? null
                            : _addToCart,
                    child: _addingToCart
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(t.product.add_to_cart),
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> _submitReview(String productId) async {
    if (_reviewRating < 1) { setState(() => _reviewError = t.product.please_select_rating); return; }
    setState(() { _submittingReview = true; _reviewError = null; _reviewSuccess = null; });
    try {
      await MedusaClient.instance.post('/store/products/$productId/review', data: {
        'rating': _reviewRating, 'comment': _reviewCommentCtrl.text.trim(),
      });
      _reviewCommentCtrl.clear();
      setState(() { _reviewSuccess = t.product.review_submitted; _showReviewForm = false; _reviewRating = 5; });
      // Reload reviews
      _extrasLoaded = false; _loadExtras(productId);
    } catch (e) {
      final msg = e.toString();
      setState(() => _reviewError = msg.contains('purchased') ? t.product.must_purchase :
          msg.contains('401') ? t.product.sign_in_to_review : t.product.failed_submit_review);
    } finally { if (mounted) setState(() => _submittingReview = false); }
  }

  Future<void> _submitQuestion(ProductModel product) async {
    if (_questionCtrl.text.trim().isEmpty) { setState(() => _questionError = t.product.please_enter_question); return; }
    setState(() { _submittingQuestion = true; _questionError = null; _questionSuccess = null; });
    try {
      await MedusaClient.instance.post('/store/products/${product.id}/question', data: {
        'question': _questionCtrl.text.trim(),
        if (product.vendor?.id != null) ...{
          'vendor_id': product.vendor!.id,
          'store_id': product.vendor!.id,
        }
      });
      _questionCtrl.clear();
      setState(() { _questionSuccess = t.product.question_submitted; _showQuestionForm = false; });
      _extrasLoaded = false; _loadExtras(product.id);
    } catch (e) {
      setState(() => _questionError = e.toString().contains('401') ? t.product.sign_in_to_ask : t.product.failed_submit_question);
    } finally { if (mounted) setState(() => _submittingQuestion = false); }
  }

  Future<void> _addToCart() async {
    if (_selectedVariantId == null) return;
    setState(() => _addingToCart = true);
    try {
      await ref.read(cartProvider.notifier).addItem(_selectedVariantId!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(t.product.added_to_cart_success),
          backgroundColor: context.colors.success,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(t.product.failed_add_to_cart),
          backgroundColor: context.colors.error,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } finally {
      if (mounted) setState(() => _addingToCart = false);
    }
  }

  Widget _vendorInitial(String? name) => Container(
        color: context.colors.primary.withValues(alpha: 0.15),
        child: Center(
          child: Text(
            name?.isNotEmpty == true ? name![0].toUpperCase() : 'V',
            style: TextStyle(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
        ),
      );

  void _openFullImageViewer(BuildContext context, List<String> imageUrls, int initialIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.9),
        pageBuilder: (context, _, __) {
          int currentIndex = initialIndex;
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: [
                    PageView.builder(
                      itemCount: imageUrls.length,
                      controller: PageController(initialPage: initialIndex),
                      onPageChanged: (idx) => setDialogState(() => currentIndex = idx),
                      itemBuilder: (context, idx) {
                        return Center(
                          child: InteractiveViewer(
                            minScale: 0.5,
                            maxScale: 4.0,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: CachedNetworkImage(
                                imageUrl: imageUrls[idx],
                                fit: BoxFit.contain,
                                placeholder: (_, __) => Center(
                                  child: CircularProgressIndicator(color: context.colors.primary),
                                ),
                                errorWidget: (_, __, ___) => Icon(
                                  Icons.image_not_supported,
                                  color: context.colors.textMuted,
                                  size: 64,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 10,
                      right: 16,
                      child: IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 20),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).padding.bottom + 20,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${currentIndex + 1} / ${imageUrls.length}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSkeleton() => Shimmer.fromColors(
        baseColor: context.colors.surface,
        highlightColor: context.colors.surfaceVariant,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 340, color: context.colors.surface),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 24,
                      width: 220,
                      color: context.colors.surfaceVariant),
                  SizedBox(height: 12),
                  Container(
                      height: 32,
                      width: 120,
                      color: context.colors.surfaceVariant),
                  SizedBox(height: 20),
                  Container(
                      height: 60,
                      width: double.infinity,
                      color: context.colors.surfaceVariant),
                ],
              ),
            ),
          ],
        ),
      );
}

class _TrustRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TrustRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: context.colors.primary, size: 16),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(label,
              style: TextStyle(
                  color: context.colors.textPrimary, fontSize: 12)),
        ),
      ],
    );
  }
}
