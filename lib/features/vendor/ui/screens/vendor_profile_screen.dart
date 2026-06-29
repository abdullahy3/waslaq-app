import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/utils/ils_formatter.dart';
import '../../../../core/api/medusa_client.dart';
import '../../../../core/api/social_client.dart';
import '../../../../router/app_router.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../shared/widgets/context_aware_scaffold.dart';
import '../../../../features/social/post/providers/fab_context_provider.dart';
import 'package:waslaq_app/core/error/error_localizer.dart';

@RoutePage()
class VendorProfileScreen extends ConsumerStatefulWidget {
  final String? slug;
  const VendorProfileScreen({super.key, @PathParam('slug') this.slug});
  @override
  ConsumerState<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends ConsumerState<VendorProfileScreen> with SingleTickerProviderStateMixin {
  Map<String, dynamic>? _vendor;
  List<dynamic> _products = [];
  List<dynamic> _reviews = [];
  List<dynamic> _questions = [];
  Map<String, dynamic>? _policy;
  bool _loading = true;
  String? _error;
  late TabController _tabCtrl;
  bool _isFollowing = false;
  int _followerCount = 0;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
    _loadVendor();
  }

  @override
  void dispose() { _tabCtrl.dispose(); super.dispose(); }

  Future<void> _loadVendor() async {
    setState(() { _loading = true; _error = null; });
    try {
      final res = await MedusaClient.instance.get('/store/vendors/${widget.slug}');
      final data = res.data;
      _vendor = data['vendor'] as Map<String, dynamic>?;
      _products = data['products'] as List<dynamic>? ?? [];
      _followerCount = (_vendor?['follower_count'] as num?)?.toInt() ?? 0;

      // Load Q&A, reviews, policy in parallel (safe — catch errors individually)
      dynamic qRes, rRes, pRes;
      await Future.wait([
        MedusaClient.instance.get('/store/vendors/${widget.slug}/questions').then<void>((r) => qRes = r).catchError((_) {}),
        MedusaClient.instance.get('/store/vendors/${widget.slug}/review').then<void>((r) => rRes = r).catchError((_) {}),
        MedusaClient.instance.get('/store/vendors/${widget.slug}/policy').then<void>((r) => pRes = r).catchError((_) {}),
      ]);
      _questions = (qRes?.data['questions'] as List<dynamic>?) ?? [];
      _reviews = (rRes?.data['reviews'] as List<dynamic>?) ?? [];
      _policy = pRes?.data['policy'] as Map<String, dynamic>?;

      // Look up follow status
      final vendorCustomerId = _vendor?['customer_id'] as String?;
      if (vendorCustomerId != null) {
        try {
          final profileRes = await SocialClient.instance.get('/store/social/profiles/$vendorCustomerId');
          _isFollowing = profileRes.data['isFollowing'] ?? false;
          _notificationsEnabled = profileRes.data['notificationsEnabled'] ?? true;
        } catch (_) {}
      }

      if (mounted) setState(() => _loading = false);
    } catch (e) {
      if (mounted) setState(() { _error = t.vendor.failed_load_store; _loading = false; });
    }
  }

  Future<void> _toggleFollow(String vendorCustomerId) async {
    try {
      final res = await SocialClient.instance.post('/store/social/follow/$vendorCustomerId');
      if (mounted) {
        setState(() {
          _isFollowing = res.data['following'] ?? !_isFollowing;
          _followerCount += _isFollowing ? 1 : -1;
          if (_followerCount < 0) _followerCount = 0;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isFollowing
                ? (Localizations.localeOf(context).languageCode == 'ar' ? 'تمت المتابعة' : 'Followed successfully')
                : (Localizations.localeOf(context).languageCode == 'ar' ? 'تم إلغاء المتابعة' : 'Unfollowed successfully')),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizeError(e)), backgroundColor: context.colors.error),
        );
      }
    }
  }

  Future<void> _toggleNotifications(String vendorCustomerId) async {
    try {
      final res = await SocialClient.instance.patch('/store/social/follow/$vendorCustomerId');
      if (mounted) setState(() => _notificationsEnabled = res.data['notificationsEnabled'] ?? !_notificationsEnabled);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(backgroundColor: context.colors.background,
        appBar: AppBar(backgroundColor: context.colors.background, iconTheme: IconThemeData(color: context.colors.textPrimary)),
        body: Center(child: CircularProgressIndicator(color: context.colors.primary)));
    }
    if (_error != null || _vendor == null) {
      return Scaffold(backgroundColor: context.colors.background,
        appBar: AppBar(backgroundColor: context.colors.background, iconTheme: IconThemeData(color: context.colors.textPrimary)),
        body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.store_outlined, color: context.colors.textMuted, size: 48),
          SizedBox(height: 12),
          Text(_error ?? t.vendor.store_not_found, style: TextStyle(color: context.colors.textSecondary)),
          SizedBox(height: 12),
          TextButton(onPressed: _loadVendor, child: Text(t.common.retry)),
        ])));
    }

    final v = _vendor!;
    final name = v['store_name'] as String? ?? 'Store';
    final desc = v['description'] as String? ?? '';
    final logo = v['logo_url'] as String?;
    final banner = v['banner_url'] as String?;
    final avgRating = double.tryParse('${v['avg_rating']}') ?? 0;
    final totalReviews = v['total_reviews'] as int? ?? 0;

    return ContextAwareScaffold(
      fabContext: FabContextData(storeSlug: widget.slug ?? ''),
      child: Scaffold(
        backgroundColor: context.colors.background,
        body: RefreshIndicator(
        onRefresh: _loadVendor,
        child: NestedScrollView(
          headerSliverBuilder: (ctx, innerBoxScrolled) => [
            SliverAppBar(
              expandedHeight: 180, pinned: true, backgroundColor: context.colors.primary,
              iconTheme: const IconThemeData(color: Colors.white),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(fit: StackFit.expand, children: [
                  if (banner != null) CachedNetworkImage(imageUrl: banner, fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => _gradientBanner())
                  else _gradientBanner(),
                  Container(decoration: BoxDecoration(gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)]))),
                  Positioned(bottom: 16, left: 16, right: 16, child: Row(children: [
                    Container(width: 56, height: 56,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white,
                        border: Border.all(color: Colors.white, width: 2)),
                      clipBehavior: Clip.antiAlias,
                      child: logo != null ? CachedNetworkImage(imageUrl: logo, fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => _initial(name)) : _initial(name)),
                    SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(name, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Row(children: [
                        ...List.generate(5, (i) => Icon(i < avgRating.round() ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: Colors.amber, size: 14)),
                        SizedBox(width: 4),
                        Text(t.vendor.reviews_count(count: totalReviews.toString()), style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ]),
                    ])),
                    if (v['customer_id'] != null) ...[
                      const SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          // Follow / Unfollow button
                          GestureDetector(
                            onTap: () => _toggleFollow(v['customer_id'] as String),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: _isFollowing ? Colors.white.withValues(alpha: 0.15) : Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: _isFollowing ? Colors.white60 : Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                Icon(
                                  _isFollowing ? Icons.check_rounded : Icons.add_rounded,
                                  color: _isFollowing ? Colors.white : context.colors.primary,
                                  size: 13,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _isFollowing
                                      ? (Localizations.localeOf(context).languageCode == 'ar' ? 'متابَع' : 'Following')
                                      : (Localizations.localeOf(context).languageCode == 'ar' ? 'متابعة' : 'Follow'),
                                  style: TextStyle(
                                    color: _isFollowing ? Colors.white : context.colors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          // Notification bell — only visible when following
                          if (_isFollowing) ...[
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _toggleNotifications(v['customer_id'] as String),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                  color: _notificationsEnabled
                                      ? Colors.white.withValues(alpha: 0.25)
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white60, width: 1.5),
                                ),
                                child: Icon(
                                  _notificationsEnabled
                                      ? Icons.notifications_active_rounded
                                      : Icons.notifications_off_outlined,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ]),
                        const SizedBox(height: 4),
                        Text(
                          _followerCount > 0
                              ? '$_followerCount ${Localizations.localeOf(context).languageCode == 'ar' ? 'متابع' : 'followers'}'
                              : (Localizations.localeOf(context).languageCode == 'ar' ? 'لا متابعين' : 'No followers'),
                          style: const TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                      ]),
                    ],
                  ])),
                ]),
              ),
            ),
            // Description
            if (desc.isNotEmpty) SliverToBoxAdapter(child: Container(
              padding: EdgeInsets.all(16), color: context.colors.surface,
              child: Text(desc, style: TextStyle(color: context.colors.textSecondary, fontSize: 13, height: 1.5)))),
            // Tab bar
            SliverPersistentHeader(pinned: true, delegate: _TabBarDelegate(
              TabBar(controller: _tabCtrl, isScrollable: true,
                labelColor: context.colors.primary, unselectedLabelColor: context.colors.textMuted,
                indicatorColor: context.colors.primary, indicatorWeight: 2.5,
                labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                tabs: [
                  Tab(text: t.vendor.tab_products(count: _products.length.toString())),
                  Tab(text: t.vendor.tab_qa(count: _questions.length.toString())),
                  Tab(text: t.vendor.tab_reviews(count: _reviews.length.toString())),
                  Tab(text: t.vendor.tab_policies),
                ]),
            )),
          ],
          body: TabBarView(controller: _tabCtrl, children: [
            _buildProductsTab(),
            _buildQATab(),
            _buildReviewsTab(),
            _buildPoliciesTab(),
          ]),
        ),
      ),
    ),
  );
}

  // ─── PRODUCTS TAB ───────────────────────────────────────
  Widget _buildProductsTab() {
    if (_products.isEmpty) return _emptyState(Icons.inventory_2_outlined, t.vendor.no_products_yet);
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.65),
      itemCount: _products.length,
      itemBuilder: (ctx, i) {
        final p = _products[i] as Map<String, dynamic>;
        final id = p['id'] as String?;
        final title = p['title'] as String? ?? '';
        final thumbnail = p['thumbnail'] as String?;
        final variants = p['variants'] as List<dynamic>? ?? [];
        final firstPrice = variants.isNotEmpty
            ? ((variants[0] as Map<String, dynamic>)['prices'] as List<dynamic>?)?.firstOrNull
            : null;
        final amount = firstPrice != null ? (firstPrice as Map<String, dynamic>)['amount'] : null;
        final isDigital = p['product_type'] == 'virtual' || p['product_type'] == 'digital';

        return GestureDetector(
          onTap: () { if (id != null) context.router.push(ProductRoute(id: id)); },
          child: Container(
            decoration: BoxDecoration(color: context.colors.surface, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.colors.border)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: ClipRRect(borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
                child: thumbnail != null
                    ? CachedNetworkImage(imageUrl: thumbnail, fit: BoxFit.cover, width: double.infinity,
                        errorWidget: (_, __, ___) => _productPlaceholder())
                    : _productPlaceholder())),
              Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: context.colors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
                SizedBox(height: 4),
                if (amount != null)
                  Text(ILSFormatter.format(amount is num ? amount.toDouble() : double.tryParse('$amount') ?? 0),
                      style: TextStyle(color: context.colors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
                if (isDigital)
                  Container(margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.purple.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                    child: Text(t.common.digital, style: TextStyle(color: Colors.purple, fontSize: 10, fontWeight: FontWeight.bold))),
              ])),
            ]),
          ),
        );
      },
    );
  }

  // ─── Q&A TAB ────────────────────────────────────────────
  Widget _buildQATab() {
    if (_questions.isEmpty) return _emptyState(Icons.help_outline, t.vendor.no_questions_yet);
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _questions.length,
      separatorBuilder: (_, __) => SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        final q = _questions[i] as Map<String, dynamic>;
        return Container(padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: context.colors.surface, borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.colors.border)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Q: ${q['question'] ?? ''}', style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
            SizedBox(height: 4),
            Text('Asked ${_formatDate(q['created_at'])}', style: TextStyle(color: context.colors.textMuted, fontSize: 11)),
            if (q['answer'] != null && (q['answer'] as String).isNotEmpty) ...[
              SizedBox(height: 10),
              Container(padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: context.colors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border(left: BorderSide(color: context.colors.primary, width: 3))),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t.product.vendor_answer, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: context.colors.textMuted, letterSpacing: 0.5)),
                  SizedBox(height: 4),
                  Text(q['answer'] as String, style: TextStyle(color: context.colors.textPrimary, fontSize: 13)),
                ])),
            ] else
              Padding(padding: const EdgeInsets.only(top: 6),
                child: Text(t.vendor.awaiting_response, style: TextStyle(color: context.colors.textMuted, fontSize: 12, fontStyle: FontStyle.italic))),
          ]));
      },
    );
  }

  // ─── REVIEWS TAB ────────────────────────────────────────
  Widget _buildReviewsTab() {
    if (_reviews.isEmpty) return _emptyState(Icons.rate_review_outlined, t.vendor.no_reviews_yet);
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _reviews.length,
      separatorBuilder: (_, __) => SizedBox(height: 10),
      itemBuilder: (ctx, i) {
        final r = _reviews[i] as Map<String, dynamic>;
        final rating = (r['rating'] as num?)?.toInt() ?? 0;
        final comment = r['comment'] as String? ?? r['content'] as String? ?? '';
        final name = r['display_name'] as String? ?? 'Verified Buyer';
        final verified = r['is_verified_purchase'] == true;

        return Container(padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: context.colors.surface, borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.colors.border)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              ...List.generate(5, (s) => Icon(s < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: Colors.amber, size: 16)),
              SizedBox(width: 6),
              Text(t.vendor.rating_out_of_five(rating: rating.toString()), style: TextStyle(color: context.colors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
              if (verified) ...[
                SizedBox(width: 8),
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: context.colors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                  child: Text('✓ ${t.product.verified}', style: TextStyle(color: context.colors.success, fontSize: 10, fontWeight: FontWeight.bold))),
              ],
            ]),
            if (comment.isNotEmpty) ...[SizedBox(height: 8),
              Text(comment, style: TextStyle(color: context.colors.textPrimary, fontSize: 13, height: 1.4))],
            SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(name, style: TextStyle(color: context.colors.textMuted, fontSize: 11, fontWeight: FontWeight.w500)),
              Text(_formatDate(r['created_at']), style: TextStyle(color: context.colors.textMuted, fontSize: 11)),
            ]),
          ]));
      },
    );
  }

  // ─── POLICIES TAB ───────────────────────────────────────
  Widget _buildPoliciesTab() {
    if (_policy == null) return _emptyState(Icons.policy_outlined, t.vendor.no_policies_yet);
    return SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (_policy!['shipping_policy'] != null) _policySection(t.vendor.shipping_policy, _policy!['shipping_policy']),
      if (_policy!['refund_policy'] != null) _policySection(t.vendor.refund_policy, _policy!['refund_policy']),
      if (_policy!['terms_of_use'] != null) _policySection(t.vendor.terms_of_use, _policy!['terms_of_use']),
      if (_policy!['privacy_policy'] != null) _policySection(t.vendor.privacy_policy, _policy!['privacy_policy']),
      SizedBox(height: 20),
    ]));
  }

  Widget _policySection(String title, dynamic text) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: TextStyle(color: context.colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
      SizedBox(height: 2), Container(height: 1, color: context.colors.border), SizedBox(height: 10),
      Text('$text', style: TextStyle(color: context.colors.textSecondary, fontSize: 13, height: 1.6)),
    ]),
  );

  // ─── Helpers ────────────────────────────────────────────
  Widget _emptyState(IconData icon, String text) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 48, color: context.colors.border), SizedBox(height: 12),
    Text(text, style: TextStyle(color: context.colors.textSecondary, fontSize: 14))]));

  Widget _initial(String name) => Center(child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'V',
      style: TextStyle(color: context.colors.primary, fontWeight: FontWeight.bold, fontSize: 22)));

  Widget _gradientBanner() => Container(decoration: BoxDecoration(
    gradient: LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF4C1D95)], begin: Alignment.topLeft, end: Alignment.bottomRight)));

  Widget _productPlaceholder() => Container(color: context.colors.surfaceVariant,
    child: Center(child: Icon(Icons.image_outlined, color: context.colors.textMuted, size: 32)));

  String _formatDate(dynamic dt) {
    if (dt == null) return '';
    try { final d = DateTime.parse('$dt'); return '${d.day}/${d.month}/${d.year}'; } catch (_) { return ''; }
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);
  @override double get minExtent => tabBar.preferredSize.height;
  @override double get maxExtent => tabBar.preferredSize.height;
  @override Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Container(color: context.colors.background, child: tabBar);
  @override bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
