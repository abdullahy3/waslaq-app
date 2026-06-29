// lib/features/vendor/ui/screens/vendor_dashboard_screen.dart
// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../core/api/medusa_client.dart';
import '../../../../router/app_router.dart';
import '../../data/models/vendor_dashboard_model.dart';
import '../../data/repositories/vendor_repository.dart';
import '../../providers/vendor_providers.dart';
import '../../../../../i18n/strings.g.dart';
import 'package:waslaq_app/core/error/error_localizer.dart';
import '../../../account/ui/screens/dispute_detail_screen.dart';
import '../../../account/data/models/dispute_model.dart';
import 'vendor_registry_notice_dialog.dart';

@RoutePage()
class VendorDashboardScreen extends ConsumerStatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  ConsumerState<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends ConsumerState<VendorDashboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  List<_TabDef> get _tabs => [
    _TabDef(icon: Icons.dashboard_outlined, label: t.vendor_dashboard.overview_tab),
    _TabDef(icon: Icons.receipt_long_outlined, label: t.vendor_dashboard.orders_tab, badgeKey: 'orders'),
    _TabDef(icon: Icons.inventory_2_outlined, label: t.vendor_dashboard.products_tab),
    _TabDef(icon: Icons.account_balance_wallet_outlined, label: t.vendor_dashboard.finances_tab),
    _TabDef(icon: Icons.question_answer_outlined, label: t.vendor_dashboard.qa_inbox_tab, badgeKey: 'questions'),
    _TabDef(icon: Icons.policy_outlined, label: t.vendor_dashboard.policies_tab),
    _TabDef(icon: Icons.settings_outlined, label: t.vendor_dashboard.settings_tab),
    _TabDef(icon: Icons.gavel_outlined, label: t.vendor_dashboard.disputes, badgeKey: 'disputes'),
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: _tabs.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final res = await MedusaClient.instance.get('/store/vendors/me');
        final agreed = res.data['vendor']?['ecommerce_registry_agreed'] ?? true;
        if (!agreed && mounted) await showVendorRegistryNotice(context);
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // t is available for future translation keys
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(t.vendor_dashboard.title,
            style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tab,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: context.colors.primary,
            labelColor: context.colors.primary,
            unselectedLabelColor: context.colors.textSecondary,
            indicatorWeight: 2.5,
            labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            tabs: _tabs.map((td) {
              bool hasBadge = false;
              if (td.badgeKey == 'orders') {
                final orders = ref.watch(vendorOrdersProvider).valueOrNull ?? [];
                hasBadge = orders.any((o) => o.vendorStatus == 'pending');
              } else if (td.badgeKey == 'questions') {
                final qs = ref.watch(vendorQuestionsProvider).valueOrNull ?? [];
                hasBadge = qs.any((q) => q.answer == null || q.answer!.isEmpty);
              } else if (td.badgeKey == 'disputes') {
                final dash = ref.watch(vendorDashboardProvider).valueOrNull;
                hasBadge = (dash?.kpis.openDisputes ?? 0) > 0;
              }

              return Tab(
                height: 44,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(clipBehavior: Clip.none, children: [
                      Icon(td.icon, size: 16),
                      if (hasBadge)
                        Positioned(right: -4, top: -4,
                          child: Container(width: 8, height: 8,
                            decoration: BoxDecoration(color: context.colors.error, shape: BoxShape.circle,
                              border: Border.all(color: context.colors.background, width: 1.5)))),
                    ]),
                    const SizedBox(width: 6),
                    Text(td.label),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          const _OverviewTab(),
          const _OrdersTab(),
          _ProductsTab(ref: ref),
          const _FinancesTab(),
          _QATab(ref: ref),
          _PoliciesTab(ref: ref),
          _SettingsTab(ref: ref),
          _DisputesTab(ref: ref),
        ],
      ),
    );
  }
}

class _TabDef {
  final IconData icon;
  final String label;
  final String? badgeKey;
  const _TabDef({required this.icon, required this.label, this.badgeKey});
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 1 — OVERVIEW
// ═══════════════════════════════════════════════════════════════════════════════

class _OverviewTab extends ConsumerWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashAsync = ref.watch(vendorDashboardProvider);
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(vendorDashboardProvider),
      child: dashAsync.when(
        loading: () => _shimmerList(context),
        error: (e, _) => _errorWidget(context, localizeError(e), () => ref.invalidate(vendorDashboardProvider)),
        data: (dash) => _OverviewBody(dash: dash),
      ),
    );
  }
}

class _OverviewBody extends StatelessWidget {
  final VendorDashboardModel dash;
  const _OverviewBody({required this.dash});

  @override
  Widget build(BuildContext context) {
    final k = dash.kpis;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // KPI grid
        GridView.count(
          crossAxisCount: 2, shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.55,
          children: [
            _StatCard(value: '₪${k.sales7d.toStringAsFixed(0)}', label: t.vendor_dashboard.revenue_7d,
                icon: Icons.trending_up, color: context.colors.success),
            _StatCard(value: '${k.orders7d}', label: t.vendor_dashboard.orders_7d,
                icon: Icons.shopping_bag_outlined, color: context.colors.primary),
            _StatCard(value: '₪${k.availableBalance.toStringAsFixed(0)}', label: t.vendor_dashboard.available,
                icon: Icons.account_balance_wallet_outlined, color: context.colors.primary),
            _StatCard(
                value: '${k.openDisputes}', label: t.vendor_dashboard.open_disputes,
                icon: Icons.gavel_outlined,
                color: k.openDisputes > 0 ? context.colors.error : context.colors.textMuted),
          ],
        ),
        if (k.pendingBalance > 0) ...[
          SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: context.colors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.colors.warning.withValues(alpha: 0.3)),
            ),
            child: Row(children: [
              Icon(Icons.schedule, color: context.colors.warning, size: 20),
              SizedBox(width: 10),
              Text(t.vendor_dashboard.in_escrow(amount: k.pendingBalance.toStringAsFixed(0)),
                  style: TextStyle(color: context.colors.warning, fontWeight: FontWeight.w600)),
            ]),
          ),
        ],
        SizedBox(height: 24),
        Text(t.vendor_dashboard.recent_orders,
            style: TextStyle(color: context.colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (dash.recentOrders.isEmpty)
          _emptyBox(context, Icons.receipt_long_outlined, t.account.no_orders)
        else
          ...dash.recentOrders.map((o) => _OrderTile(order: o)),
        const SizedBox(height: 32),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 2 — ORDERS
// ═══════════════════════════════════════════════════════════════════════════════

class _OrdersTab extends ConsumerWidget {
  const _OrdersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(vendorOrdersProvider);
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(vendorOrdersProvider),
      child: ordersAsync.when(
        loading: () => _shimmerList(context),
        error: (e, _) => _errorWidget(context, localizeError(e), () => ref.invalidate(vendorOrdersProvider)),
        data: (orders) {
          if (orders.isEmpty) {
            return Center(child: _emptyBox(context, Icons.receipt_long_outlined, t.account.no_orders));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _FullOrderTile(order: orders[i], ref: ref),
          );
        },
      ),
    );
  }
}

class _FullOrderTile extends StatefulWidget {
  final VendorOrder order;
  final WidgetRef ref;
  const _FullOrderTile({required this.order, required this.ref});

  @override
  State<_FullOrderTile> createState() => _FullOrderTileState();
}

class _FullOrderTileState extends State<_FullOrderTile> {
  bool _expanded = false;
  bool _shipping = false;

  Color _statusColor(String s) {
    switch (s.toLowerCase()) {
      case 'shipped': return Colors.blue;
      case 'delivered': case 'completed': return context.colors.success;
      case 'cancelled': return context.colors.error;
      default: return context.colors.warning;
    }
  }

  Future<void> _markShipped() async {
    setState(() => _shipping = true);
    try {
      await widget.ref.read(vendorRepositoryProvider).markShipped(widget.order.id);
      widget.ref.invalidate(vendorOrdersProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.vendor_dashboard.order_marked_shipped), backgroundColor: context.colors.success));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizeError(e)), backgroundColor: context.colors.error));
      }
    } finally {
      if (mounted) setState(() => _shipping = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    final diff = DateTime.now().difference(o.createdAt);
    final timeStr = diff.inDays == 0 ? '${diff.inHours}h ago' : '${diff.inDays}d ago';

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header row
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.receipt_outlined, color: context.colors.primary, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(o.displayId != null ? 'Order #${o.displayId}' : o.id.substring(0, 8),
                    style: TextStyle(color: context.colors.textPrimary,
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(timeStr,
                    style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('₪${o.total.toStringAsFixed(0)}',
                    style: TextStyle(color: context.colors.primary,
                        fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _statusColor(o.vendorStatus).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(o.vendorStatus,
                      style: TextStyle(color: _statusColor(o.vendorStatus),
                          fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ]),
              SizedBox(width: 8),
              Icon(_expanded ? Icons.expand_less : Icons.expand_more,
                  color: context.colors.textSecondary, size: 20),
            ]),
          ),
        ),
        // Expanded details
        if (_expanded) ...[
          Divider(height: 1, color: context.colors.border),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (o.shippingName != null) ...[
                Text(t.vendor_dashboard.ship_to(name: o.shippingName!),
                    style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
                SizedBox(height: 10),
              ],
              ...o.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  if (item.thumbnail != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedNetworkImage(
                          imageUrl: item.thumbnail!, width: 40, height: 40, fit: BoxFit.cover),
                    )
                  else
                    Container(width: 40, height: 40,
                        decoration: BoxDecoration(color: context.colors.surfaceVariant,
                            borderRadius: BorderRadius.circular(6)),
                        child: Icon(Icons.image_outlined,
                            color: context.colors.textMuted, size: 20)),
                  SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item.title,
                        style: TextStyle(color: context.colors.textPrimary, fontSize: 13),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(t.vendor_dashboard.qty_price(qty: item.quantity.toString(), price: item.unitPrice.toStringAsFixed(0)),
                        style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
                  ])),
                ]),
              )),
              if (o.vendorStatus == 'pending') ...[
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _shipping ? null : _markShipped,
                    icon: _shipping
                        ? SizedBox(width: 16, height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Icon(Icons.local_shipping_outlined, size: 18),
                    label: Text(_shipping ? t.vendor_dashboard.marking : t.vendor_dashboard.mark_as_shipped),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  ),
                ),
              ],
            ]),
          ),
        ],
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 3 — PRODUCTS
// ═══════════════════════════════════════════════════════════════════════════════

class _ProductsTab extends ConsumerStatefulWidget {
  final WidgetRef ref;
  const _ProductsTab({required this.ref});

  @override
  ConsumerState<_ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends ConsumerState<_ProductsTab> {
  bool _showForm = false;

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(vendorProductsProvider);
    return productsAsync.when(
      loading: () => _shimmerList(context),
      error: (e, _) => _errorWidget(context, localizeError(e), () => ref.invalidate(vendorProductsProvider)),
      data: (products) => Stack(children: [
        RefreshIndicator(
          onRefresh: () async => ref.invalidate(vendorProductsProvider),
          child: products.isEmpty && !_showForm
              ? Center(child: _emptyBox(context, Icons.inventory_2_outlined, t.vendor_dashboard.no_products_yet))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  children: [
                    if (_showForm) ...[
                      _AddProductForm(
                        ref: ref,
                        onSuccess: () {
                          setState(() => _showForm = false);
                          ref.invalidate(vendorProductsProvider);
                        },
                        onCancel: () => setState(() => _showForm = false),
                      ),
                      SizedBox(height: 16),
                    ],
                    // ValueKey ties each tile's State (incl. its _deleting spinner) to the product
                    // id, so removing one product can't recycle a sibling's delete-in-progress state.
                    ...products.map((p) => _ProductTile(key: ValueKey(p.id), product: p, ref: ref)),
                  ],
                ),
        ),
        if (!_showForm)
          Positioned(
            bottom: 20, right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.small(
                  heroTag: 'fab_import_export',
                  onPressed: () => context.router.push(const VendorImportRoute()),
                  backgroundColor: context.colors.surface,
                  foregroundColor: context.colors.primary,
                  elevation: 1.0,
                  highlightElevation: 1.5,
                  shape: CircleBorder(side: BorderSide(color: context.colors.primary.withValues(alpha: 0.3))),
                  child: const Icon(Icons.upload_file_outlined, size: 16),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'fab_add_product',
                  onPressed: () => setState(() => _showForm = true),
                  backgroundColor: context.colors.primary,
                  foregroundColor: Colors.white,
                  elevation: 1.0,
                  highlightElevation: 1.5,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ],
            ),
          ),
      ]),
    );
  }
}

class _ProductTile extends StatefulWidget {
  final VendorProduct product;
  final WidgetRef ref;
  const _ProductTile({super.key, required this.product, required this.ref});

  @override
  State<_ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<_ProductTile> {
  bool _deleting = false;

  Future<void> _showEditSheet(BuildContext context) async {
    final titleCtrl = TextEditingController(text: widget.product.title);
    final descCtrl = TextEditingController(text: widget.product.description ?? '');
    final priceCtrl = TextEditingController(
        text: widget.product.price?.toStringAsFixed(2) ?? '');

    final skuCtrl = TextEditingController(text: widget.product.sku ?? '');
    final inventoryCtrl = TextEditingController(text: widget.product.manageInventory ? widget.product.inventoryQuantity.toString() : '');
    bool manageInventory = widget.product.manageInventory;

    final digitalUrlCtrl = TextEditingController();

    // Existing image URLs from product
    final existingUrls = List<String>.from(widget.product.images);
    if (widget.product.thumbnail != null &&
        !existingUrls.contains(widget.product.thumbnail)) {
      existingUrls.insert(0, widget.product.thumbnail!);
    }
    List<File> newImages = [];       // newly picked local files
    List<String> keptUrls = List<String>.from(existingUrls); // existing kept
    bool saving = false;
    String? error;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          Future<void> pickImages() async {
            final picker = ImagePicker();
            final picked = await picker.pickMultiImage(imageQuality: 80);
            if (picked.isNotEmpty) {
              setModalState(() =>
                  newImages = [...newImages, ...picked.map((x) => File(x.path))].take(5).toList());
            }
          }

          return SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                left: 16, right: 16, top: 20),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(t.vendor_dashboard.edit_product,
                    style: TextStyle(color: context.colors.textPrimary,
                        fontWeight: FontWeight.bold, fontSize: 16)),
                IconButton(
                    icon: Icon(Icons.close, color: context.colors.textSecondary),
                    onPressed: () => Navigator.pop(ctx)),
              ]),
              if (error != null) ...[
                SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: context.colors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(error!, style: TextStyle(color: context.colors.error, fontSize: 13)),
                ),
              ],
              SizedBox(height: 12),
              // ── Images section ──────────────────────────────────
              Text(t.vendor.product_images, style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
              SizedBox(height: 8),
              SizedBox(
                height: 80,
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  // Existing images (kept)
                  ...keptUrls.asMap().entries.map((entry) => Stack(children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                            imageUrl: entry.value, width: 72, height: 80, fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(top: 2, right: 10,
                      child: GestureDetector(
                        onTap: () => setModalState(() => keptUrls.removeAt(entry.key)),
                        child: Container(
                          width: 20, height: 20,
                          decoration: BoxDecoration(
                              color: context.colors.error, shape: BoxShape.circle),
                          child: Icon(Icons.close, color: Colors.white, size: 13),
                        ),
                      ),
                    ),
                  ])),
                  // New local images
                  ...newImages.asMap().entries.map((entry) => Stack(children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(entry.value, width: 72, height: 80, fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(top: 2, right: 10,
                      child: GestureDetector(
                        onTap: () => setModalState(() => newImages.removeAt(entry.key)),
                        child: Container(
                          width: 20, height: 20,
                          decoration: BoxDecoration(
                              color: context.colors.error, shape: BoxShape.circle),
                          child: Icon(Icons.close, color: Colors.white, size: 13),
                        ),
                      ),
                    ),
                  ])),
                  // Add button
                  GestureDetector(
                    onTap: pickImages,
                    child: Container(
                      width: 72, height: 80,
                      decoration: BoxDecoration(
                          border: Border.all(color: context.colors.border),
                          borderRadius: BorderRadius.circular(8),
                          color: context.colors.surfaceVariant),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.add_photo_alternate_outlined, color: context.colors.textMuted, size: 24),
                        SizedBox(height: 4),
                        Text(t.vendor_dashboard.add, style: TextStyle(color: context.colors.textMuted, fontSize: 10)),
                      ]),
                    ),
                  ),
                ]),
              ),
              SizedBox(height: 12),
              // Title
              _editField(context, t.community.title, titleCtrl),
              SizedBox(height: 10),
              _editField(context, t.vendor.description, descCtrl, maxLines: 3),
              SizedBox(height: 10),
              _editField(context, t.vendor_dashboard.price_ils, priceCtrl,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  prefixText: '₪ '),
              SizedBox(height: 10),
              _editField(context, t.vendor_dashboard.sku_optional, skuCtrl),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(t.vendor_dashboard.manage_inventory, style: TextStyle(color: context.colors.textPrimary)),
                  const Spacer(),
                  Switch(
                    value: manageInventory,
                    activeThumbColor: context.colors.primary,
                    onChanged: (val) => setModalState(() => manageInventory = val),
                  ),
                ],
              ),
              if (manageInventory) ...[
                const SizedBox(height: 10),
                _editField(context, t.vendor_dashboard.inventory_quantity, inventoryCtrl, keyboardType: TextInputType.number),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saving ? null : () async {
                    if (titleCtrl.text.trim().isEmpty) {
                      if (ctx.mounted) setModalState(() => error = t.vendor_dashboard.title_required);
                      return;
                    }
                    if (ctx.mounted) setModalState(() { saving = true; error = null; });
                    try {
                      final repo = widget.ref.read(vendorRepositoryProvider);
                      // Upload any new images
                      List<String> uploadedUrls = [];
                      if (newImages.isNotEmpty) {
                         uploadedUrls = await repo.uploadImages(newImages);
                      }
                      final allImageUrls = [...keptUrls, ...uploadedUrls];

                      String? finalDigitalUrl;
                      if (widget.product.productType == 'virtual') {
                        if (digitalUrlCtrl.text.trim().isNotEmpty) {
                        finalDigitalUrl = digitalUrlCtrl.text.trim();
                      }
                      }

                      final variantId = widget.product.variantId;
                      final allVariantIds = widget.product.allVariantIds;
                      await repo.updateProduct(
                        widget.product.id,
                        title: titleCtrl.text.trim(),
                        description: descCtrl.text.trim(),
                        price: double.tryParse(priceCtrl.text.trim()),
                        imageUrls: allImageUrls.isNotEmpty ? allImageUrls : null,
                        sku: skuCtrl.text.trim(),
                        manageInventory: manageInventory,
                        inventoryQuantity: int.tryParse(inventoryCtrl.text.trim()),
                        variantId: variantId,
                        allVariantIds: allVariantIds,
                          digitalFileUrl: finalDigitalUrl,
                      );
                      // Pop first, then invalidate — avoids rebuilding a disposed StatefulBuilder
                      if (ctx.mounted) Navigator.pop(ctx);
                      widget.ref.invalidate(vendorProductsProvider);
                    } catch (e) {
                      if (ctx.mounted) setModalState(() { error = e.toString(); saving = false; });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ctx.colors.primary, foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: saving
                      ? const SizedBox(width: 20, height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(t.vendor.save_changes,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ]),
          );
        },
      ),
    );
    titleCtrl.dispose(); descCtrl.dispose(); priceCtrl.dispose();
  }

  // Helper for edit sheet text fields
  static Widget _editField(BuildContext context, String label, TextEditingController ctrl,
      {int maxLines = 1,
      TextInputType keyboardType = TextInputType.text,
      String? prefixText}) {
    return TextField(
      controller: ctrl, maxLines: maxLines, keyboardType: keyboardType,
      style: TextStyle(color: context.colors.textPrimary),
      decoration: InputDecoration(
        labelText: label, labelStyle: TextStyle(color: context.colors.textSecondary),
        prefixText: prefixText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: context.colors.border)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: Text(t.vendor_dashboard.delete_product, style: TextStyle(color: context.colors.textPrimary)),
        content: Text(t.vendor_dashboard.delete_confirm(title: widget.product.title),
            style: TextStyle(color: context.colors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
              child: Text(t.common.cancel_label)),
          TextButton(onPressed: () => Navigator.pop(context, true),
              child: Text(t.common.delete, style: TextStyle(color: context.colors.error))),
        ],
      ),
    );
    if (confirm != true) return;
    setState(() => _deleting = true);
    try {
      await widget.ref.read(vendorRepositoryProvider).deleteProduct(widget.product.id);
      widget.ref.invalidate(vendorProductsProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizeError(e)), backgroundColor: context.colors.error));
      }
      setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.surface, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: p.thumbnail != null
              ? CachedNetworkImage(imageUrl: p.thumbnail!,
                  width: 56, height: 56, fit: BoxFit.cover)
              : Container(width: 56, height: 56,
                  color: context.colors.surfaceVariant,
                  child: Icon(Icons.image_outlined, color: context.colors.textMuted)),
        ),
        SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p.title,
              style: TextStyle(color: context.colors.textPrimary,
                  fontWeight: FontWeight.w600, fontSize: 14),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          SizedBox(height: 2),
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: p.status == 'published'
                    ? context.colors.success.withValues(alpha: 0.15)
                    : context.colors.warning.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(p.status,
                  style: TextStyle(
                      color: p.status == 'published' ? context.colors.success : context.colors.warning,
                      fontSize: 10, fontWeight: FontWeight.bold)),
            ),
            SizedBox(width: 8),
            Text(p.productType,
                style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
          ]),
          if (p.price != null)
            Text('₪${p.price!.toStringAsFixed(2)}',
                style: TextStyle(color: context.colors.primary,
                    fontWeight: FontWeight.bold, fontSize: 13)),
          if (p.sku != null)
            Text('SKU: ${p.sku}',
                style: TextStyle(color: context.colors.textMuted, fontSize: 11)),
          Text(
            p.manageInventory
                ? t.vendor_dashboard.stock_count(count: p.inventoryQuantity.toString())
                : t.vendor_dashboard.inventory_untracked,
            style: TextStyle(
                color: p.manageInventory && p.inventoryQuantity == 0
                    ? context.colors.error
                    : context.colors.textMuted,
                fontSize: 11)),
        ])),
        if (_deleting)
          SizedBox(width: 20, height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: context.colors.error))
        else
          Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: context.colors.primary, size: 20),
              onPressed: () => _showEditSheet(context),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: context.colors.error, size: 20),
              onPressed: _delete,
            ),
          ]),
      ]),
    );
  }
}

class _AddProductForm extends ConsumerStatefulWidget {
  final WidgetRef ref;
  final VoidCallback onSuccess;
  final VoidCallback onCancel;
  const _AddProductForm({required this.ref, required this.onSuccess, required this.onCancel});

  @override
  ConsumerState<_AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends ConsumerState<_AddProductForm> with AutomaticKeepAliveClientMixin {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _digitalUrlCtrl = TextEditingController();
  final _skuCtrl = TextEditingController();
  final _inventoryCtrl = TextEditingController();

  String _type = 'physical'; // physical or virtual
  File? _digitalFile;
  bool _saving = false;
  String? _error;

  List<dynamic> rootCats = [];
  String? _selectedCategoryId;
  bool _manageInventory = false;
  List<File> _images = [];

  @override
  bool get wantKeepAlive => true;



  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _digitalUrlCtrl.dispose();
    _skuCtrl.dispose();
    _inventoryCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(imageQuality: 80);
    if (picked.isNotEmpty) {
      setState(() => _images = [..._images, ...picked.map((x) => File(x.path))].take(5).toList());
    }
  }

  Future<void> _pickDigitalFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() => _digitalFile = File(result.files.single.path!));
      _digitalUrlCtrl.clear();
    }
  }

  Future<void> _submit() async {
    if (_titleCtrl.text.trim().isEmpty) {
      setState(() => _error = t.vendor_dashboard.title_required);
      return;
    }
    if (_type == 'virtual' && _digitalUrlCtrl.text.trim().isEmpty && _digitalFile == null) {
      setState(() => _error = t.vendor_dashboard.virtual_require_file);
      return;
    }

    setState(() { _saving = true; _error = null; });
    try {
      final repo = widget.ref.read(vendorRepositoryProvider);
      List<String> imageUrls = [];
      if (_images.isNotEmpty) {
        imageUrls = await repo.uploadImages(_images);
      }
      if (_digitalFile != null && _type == 'virtual') {
        final uploaded = await repo.uploadImages([_digitalFile!]);
        if (uploaded.isNotEmpty) {
          _digitalUrlCtrl.text = uploaded.first;
        }
      }

      await repo.createProduct(
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        productType: _type,
        price: double.tryParse(_priceCtrl.text.trim()) ?? 0,
        imageUrls: imageUrls,
        categoryId: _selectedCategoryId,
        digitalFileUrl: _type == 'virtual' ? _digitalUrlCtrl.text.trim() : null,
        sku: _skuCtrl.text.trim(),
        inventoryQuantity: int.tryParse(_inventoryCtrl.text.trim()),
        manageInventory: _manageInventory,
      );
      widget.onSuccess();
    } catch (e) {
      setState(() { _error = e.toString(); _saving = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final categoriesAsync = ref.watch(vendorCategoriesProvider);
    final allRootCats = categoriesAsync.valueOrNull
        ?.where((c) => c['parent_category_id'] == null).toList() ?? [];
    // Digital products: only 3D and Digital Vault categories
    // Physical products: everything except those two
    const digitalHandles = ['3d', 'digital-vault'];
    final rootCats = _type == 'virtual'
        ? allRootCats.where((c) => digitalHandles.contains(c['handle'])).toList()
        : allRootCats.where((c) => !digitalHandles.contains(c['handle'])).toList();

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.primary.withValues(alpha: 0.4)),
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(t.vendor_dashboard.add_product,
              style: TextStyle(color: context.colors.textPrimary,
                  fontWeight: FontWeight.bold, fontSize: 16)),
          IconButton(icon: Icon(Icons.close, color: context.colors.textSecondary),
              onPressed: widget.onCancel),
        ]),
        SizedBox(height: 12),
        if (_error != null)
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: context.colors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(_error!, style: TextStyle(color: context.colors.error, fontSize: 13)),
          ),
        _field(t.vendor_dashboard.title_label, _titleCtrl),
        SizedBox(height: 10),
        _field(t.vendor.description, _descCtrl, maxLines: 3),
        SizedBox(height: 10),
        _field(t.vendor_dashboard.price_ils_label, _priceCtrl, keyboardType: TextInputType.number),
        SizedBox(height: 10),
        // Type selector
        Row(children: [
          Text(t.vendor_dashboard.type_label, style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
          SizedBox(width: 12),
          ...['physical', 'virtual'].map((type) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(type, style: TextStyle(fontSize: 12)),
              selected: _type == type,
              selectedColor: context.colors.primary,
              onSelected: (_) => setState(() { _type = type; _selectedCategoryId = null; }),
            ),
          )),
        ]),
        SizedBox(height: 10),
        // Digital file URL (only for virtual products)
        if (_type == 'virtual') ...[
            TextField(
              controller: _digitalUrlCtrl,
              style: TextStyle(color: context.colors.textPrimary),
              decoration: InputDecoration(
                labelText: t.vendor_dashboard.digital_file_url,
                labelStyle: TextStyle(color: context.colors.textSecondary),
                hintText: 'https://example.com/file.pdf',
                hintStyle: TextStyle(color: context.colors.textMuted, fontSize: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: context.colors.border)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                prefixIcon: Icon(Icons.link, color: context.colors.textMuted, size: 18),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _pickDigitalFile,
                icon: Icon(Icons.upload_file, size: 18, color: Colors.white),
                label: Text(t.vendor_dashboard.upload_file_instead, style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),

          if (_digitalFile != null) ...[
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.check_circle, color: context.colors.success, size: 16),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    t.vendor_dashboard.file_selected(filename: _digitalFile!.path.split('/').last),
                    style: TextStyle(color: context.colors.success, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 16, color: context.colors.error),
                  onPressed: () => setState(() => _digitalFile = null),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ],
          SizedBox(height: 4),
          Text(t.vendor_dashboard.digital_hint,
              style: TextStyle(color: context.colors.textMuted, fontSize: 11)),
          SizedBox(height: 10),
        ],
        // Category
        if (rootCats.isNotEmpty) ...[
          DropdownButtonFormField<String>(
            initialValue: _selectedCategoryId,
            hint: Text(t.vendor_dashboard.select_category, style: TextStyle(color: context.colors.textMuted)),
            style: TextStyle(color: context.colors.textPrimary, fontSize: 14),
            dropdownColor: context.colors.surface,
            decoration: InputDecoration(
              labelText: t.vendor.category,
              labelStyle: TextStyle(color: context.colors.textSecondary),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: context.colors.border),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            items: rootCats.map((c) => DropdownMenuItem<String>(
              value: c['id'] as String,
              child: Text(c['name'] as String? ?? '',
                  style: TextStyle(color: context.colors.textPrimary, fontSize: 14)),
            )).toList(),
            onChanged: (v) => setState(() => _selectedCategoryId = v),
          ),
          SizedBox(height: 10),
        ],
        // SKU & Inventory
        _field(t.vendor_dashboard.sku_optional, _skuCtrl),
        SizedBox(height: 10),
        Row(
          children: [
            Text(t.vendor_dashboard.manage_inventory, style: TextStyle(color: context.colors.textPrimary)),
            const Spacer(),
            Switch(
              value: _manageInventory,
              activeThumbColor: context.colors.primary,
              onChanged: (val) => setState(() => _manageInventory = val),
            ),
          ],
        ),
        if (_manageInventory) ...[
          SizedBox(height: 10),
          _field(t.vendor_dashboard.inventory_quantity, _inventoryCtrl, keyboardType: TextInputType.number),
        ],
        SizedBox(height: 10),
        // Images
        GestureDetector(
          onTap: _pickImages,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: context.colors.border, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8),
              color: context.colors.surfaceVariant,
            ),
            child: _images.isEmpty
                ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.add_photo_alternate_outlined,
                        color: context.colors.textMuted, size: 28),
                    SizedBox(height: 4),
                    Text(t.vendor.add_images, style: TextStyle(color: context.colors.textMuted, fontSize: 12)),
                  ]))
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(8),
                    itemCount: _images.length + 1,
                    separatorBuilder: (_, __) => SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      if (i == _images.length) {
                        return GestureDetector(
                          onTap: _pickImages,
                          child: Container(
                            width: 60,
                            decoration: BoxDecoration(
                              color: context.colors.surface, borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: context.colors.border)),
                            child: Icon(Icons.add, color: context.colors.textMuted),
                          ),
                        );
                      }
                      return Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.file(_images[i],
                              width: 60, height: 64, fit: BoxFit.cover),
                        ),
                        Positioned(top: 2, right: 2,
                          child: GestureDetector(
                            onTap: () => setState(() => _images.removeAt(i)),
                            child: Container(
                              width: 18, height: 18,
                              decoration: BoxDecoration(
                                color: context.colors.error, shape: BoxShape.circle),
                              child: Icon(Icons.close, color: Colors.white, size: 12),
                            ),
                          ),
                        ),
                      ]);
                    },
                  ),
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saving ? null : _submit,
            style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 14)),
            child: _saving
                ? SizedBox(width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text(t.vendor_dashboard.create_product, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ]),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: ctrl, maxLines: maxLines, keyboardType: keyboardType,
      style: TextStyle(color: context.colors.textPrimary),
      decoration: InputDecoration(
        labelText: label, labelStyle: TextStyle(color: context.colors.textSecondary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: context.colors.border)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 4 — FINANCES
// ═══════════════════════════════════════════════════════════════════════════════

class _FinancesTab extends ConsumerWidget {
  const _FinancesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('🟣 [FinancesTab] build START');
    try {
      final balanceAsync = ref.watch(vendorBalanceProvider);
      debugPrint('🟣 [FinancesTab] state hasValue=${balanceAsync.hasValue} hasError=${balanceAsync.hasError} isLoading=${balanceAsync.isLoading}');
      if (balanceAsync.hasError) {
        debugPrint('🟣 [FinancesTab] ERROR: ${balanceAsync.error}');
        debugPrint('🟣 [FinancesTab] STACK: ${balanceAsync.stackTrace}');
      }
      if (balanceAsync.hasValue && balanceAsync.value != null) {
        final b = balanceAsync.value!;
        debugPrint('🟣 [FinancesTab] DATA avail=${b.availableBalance} pending=${b.pendingBalance} earned=${b.totalEarned} paidOut=${b.totalPaidOut} payouts=${b.payoutRequests.length} ledger=${b.ledger.length}');
      }
      return RefreshIndicator(
        onRefresh: () async => ref.invalidate(vendorBalanceProvider),
        child: balanceAsync.when(
          loading: () => _shimmerList(context),
          error: (e, st) => _errorWidget(context, localizeError(e), () => ref.invalidate(vendorBalanceProvider)),
          data: (balance) {
            try {
              return _FinancesContent(balance: balance, onReload: () async => ref.invalidate(vendorBalanceProvider));
            } catch (e, st) {
              debugPrint('🟣 [FinancesTab] _FinancesContent ctor threw: $e\n$st');
              return Container(
                color: Colors.red,
                padding: const EdgeInsets.all(16),
                child: Text('CONTENT CTOR THREW:\n$e\n\n$st',
                    style: const TextStyle(color: Colors.white, fontSize: 11)),
              );
            }
          },
        ),
      );
    } catch (e, st) {
      debugPrint('🟣 [FinancesTab] BUILD THREW: $e\n$st');
      return Container(
        color: Colors.red,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text('BUILD THREW:\n$e\n\n$st', style: const TextStyle(color: Colors.white, fontSize: 11)),
        ),
      );
    }
  }
}

// Payout form + balance display — StatefulWidget for local form state
class _FinancesContent extends StatefulWidget {
  final VendorBalance balance;
  final Future<void> Function() onReload;
  const _FinancesContent({required this.balance, required this.onReload});

  @override
  State<_FinancesContent> createState() => _FinancesContentState();
}

class _FinancesContentState extends State<_FinancesContent> {
  final _amountCtrl = TextEditingController();
  bool _submitting = false;
  String? _error;
  String? _success;

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _requestPayout() async {
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (amount == null || amount <= 0) {
      setState(() => _error = t.vendor_dashboard.invalid_amount);
      return;
    }
    if (amount > widget.balance.availableBalance) {
      setState(() => _error = t.vendor_dashboard.amount_exceeds(balance: widget.balance.availableBalance.toStringAsFixed(2)));
      return;
    }
    setState(() { _submitting = true; _error = null; _success = null; });
    try {
      await VendorRepository(MedusaClient.instance).requestPayout(amount);
      _amountCtrl.clear();
      await widget.onReload();
      setState(() => _success = t.vendor_dashboard.payout_submitted);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _dateStr(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';

  Widget _statusBadge(String status) {
    Color color;
    switch (status) {
      case 'paid': color = context.colors.success; break;
      case 'rejected': color = context.colors.error; break;
      default: color = context.colors.warning;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBalanceCard({
    required String label,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    try {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(height: 8),
            Text(
              '₪${amount.toStringAsFixed(2)}',
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 2),
            Text(label, style: TextStyle(color: context.colors.textSecondary, fontSize: 11)),
          ],
        ),
      );
    } catch (e) {
      return Container(
        padding: const EdgeInsets.all(8),
        color: Colors.red.withValues(alpha: 0.1),
        child: Text('Card Error: $e', style: TextStyle(color: Colors.red, fontSize: 9)),
      );
    }
  }

  Widget _buildPayoutForm() {
    try {
      final balance = widget.balance;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (balance.payoutAccount != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.account_balance, color: context.colors.textSecondary, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      t.vendor_dashboard.payout_to(account: balance.payoutAccount!),
                      style: TextStyle(color: context.colors.textSecondary, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
          ],
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.vendor_dashboard.request_withdrawal,
                  style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: 12),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(_error!, style: TextStyle(color: context.colors.error, fontSize: 13)),
                  ),
                if (_success != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(_success!, style: TextStyle(color: context.colors.success, fontSize: 13)),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amountCtrl,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        style: TextStyle(color: context.colors.textPrimary),
                        decoration: InputDecoration(
                          labelText: t.vendor_dashboard.amount_ils,
                          labelStyle: TextStyle(color: context.colors.textSecondary),
                          hintText: '0.00',
                          hintStyle: TextStyle(color: context.colors.textMuted),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: context.colors.border),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          prefixText: '₪ ',
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _submitting ? null : _requestPayout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        minimumSize: const Size(0, 0), // Override global full-width minimum size
                      ),
                      child: _submitting
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text(t.vendor_dashboard.withdraw),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  t.vendor_dashboard.payout_hint,
                  style: TextStyle(color: context.colors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      );
    } catch (e) {
      return Container(
        padding: const EdgeInsets.all(12),
        color: Colors.red.withValues(alpha: 0.1),
        child: Text('Form Error: $e', style: TextStyle(color: Colors.red, fontSize: 11)),
      );
    }
  }

  Widget _buildPayoutHistory(List<PayoutRequest> requests) {
    try {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.vendor_dashboard.payout_history,
            style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(height: 10),
          ...requests.map((p) {
            try {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: context.colors.border),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₪${p.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: context.colors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        if (p.requestedAt != null)
                          Text(
                            _dateStr(p.requestedAt!),
                            style: TextStyle(color: context.colors.textMuted, fontSize: 11),
                          ),
                      ],
                    ),
                    const Spacer(),
                    _statusBadge(p.status),
                  ],
                ),
              );
            } catch (e) {
              return Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 8),
                color: Colors.red.withValues(alpha: 0.1),
                child: Text('Request Item Error: $e', style: TextStyle(color: Colors.red, fontSize: 9)),
              );
            }
          }),
        ],
      );
    } catch (e) {
      return Text('History Section Error: $e', style: TextStyle(color: Colors.red, fontSize: 11));
    }
  }

  Widget _buildLedger(List<LedgerEntry> ledger) {
    try {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.vendor_dashboard.transaction_ledger,
            style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(height: 10),
          ...ledger.take(20).map((e) {
            try {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: context.colors.border),
                ),
                child: Row(
                  children: [
                    Icon(
                      e.type == 'CREDIT' ? Icons.add_circle_outline : Icons.remove_circle_outline,
                      color: e.type == 'CREDIT' ? context.colors.success : context.colors.error,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${e.type} · ${e.status}',
                            style: TextStyle(color: context.colors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          if (e.referenceType != null)
                            Text(
                              e.referenceType!,
                              style: TextStyle(color: context.colors.textSecondary, fontSize: 11),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${e.type == 'CREDIT' ? '+' : '-'}₪${e.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: e.type == 'CREDIT' ? context.colors.success : context.colors.error,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          _dateStr(e.createdAt),
                          style: TextStyle(color: context.colors.textMuted, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } catch (err) {
              return Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 8),
                color: Colors.red.withValues(alpha: 0.1),
                child: Text('Ledger Item Error: $err', style: const TextStyle(color: Colors.red, fontSize: 9)),
              );
            }
          }),
        ],
      );
    } catch (e) {
      return Text('Ledger Section Error: $e', style: const TextStyle(color: Colors.red, fontSize: 11));
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🟣 [FinancesContent] build START');
    try {
      final balance = widget.balance;
      debugPrint('🟣 [FinancesContent] payoutRequests=${balance.payoutRequests.length} ledger=${balance.ledger.length} payoutAccount=${balance.payoutAccount}');
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildBalanceCard(
                    label: t.vendor_dashboard.available,
                    amount: balance.availableBalance,
                    color: context.colors.success,
                    icon: Icons.check_circle_outline,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildBalanceCard(
                    label: t.vendor_dashboard.pending,
                    amount: balance.pendingBalance,
                    color: context.colors.warning,
                    icon: Icons.schedule,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildBalanceCard(
                    label: t.vendor_dashboard.total_earned,
                    amount: balance.totalEarned,
                    color: context.colors.primary,
                    icon: Icons.trending_up,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildBalanceCard(
                    label: t.vendor_dashboard.paid_out,
                    amount: balance.totalPaidOut,
                    color: context.colors.textMuted,
                    icon: Icons.send_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildPayoutForm(),
            if (balance.payoutRequests.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildPayoutHistory(balance.payoutRequests),
            ],
            if (balance.ledger.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildLedger(balance.ledger),
            ],
            const SizedBox(height: 32),
          ],
        ),
      );
    } catch (e, st) {
      debugPrint('🟣 [FinancesContent] BUILD THREW: $e\n$st');
      return Container(
        color: Colors.red,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            'CONTENT BUILD THREW:\n$e\n\n$st',
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ),
      );
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 5 — Q&A
// ═══════════════════════════════════════════════════════════════════════════════

class _QATab extends ConsumerStatefulWidget {
  final WidgetRef ref;
  const _QATab({required this.ref});

  @override
  ConsumerState<_QATab> createState() => _QATabState();
}

class _QATabState extends ConsumerState<_QATab> {
  String? _answeringId;
  final _answerCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _answerCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitAnswer(String questionId) async {
    if (_answerCtrl.text.trim().isEmpty) return;
    setState(() => _submitting = true);
    try {
      await ref.read(vendorRepositoryProvider).answerQuestion(questionId, _answerCtrl.text.trim());
      _answerCtrl.clear();
      setState(() => _answeringId = null);
      ref.invalidate(vendorQuestionsProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizeError(e)), backgroundColor: context.colors.error));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _toggleVisibility(String questionId, bool currentIsPublic) async {
    try {
      await ref.read(vendorRepositoryProvider)
          .toggleQuestionVisibility(questionId, isPublic: !currentIsPublic);
      ref.invalidate(vendorQuestionsProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizeError(e)), backgroundColor: context.colors.error));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(vendorQuestionsProvider);
    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(vendorQuestionsProvider),
      child: questionsAsync.when(
        loading: () => _shimmerList(context),
        error: (e, _) => _errorWidget(context, localizeError(e), () => ref.invalidate(vendorQuestionsProvider)),
        data: (questions) {
          if (questions.isEmpty) {
            return Center(child: _emptyBox(context, Icons.question_answer_outlined, t.vendor_dashboard.no_questions));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: questions.length,
            separatorBuilder: (_, __) => SizedBox(height: 12),
            itemBuilder: (_, i) {
              final q = questions[i];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.colors.surface, borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.colors.border)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Product reference
                  if (q.productTitle != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.colors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6)),
                      child: Text(t.vendor_dashboard.re_product(title: q.productTitle!),
                          style: TextStyle(color: context.colors.primary,
                              fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                  // Question
                  Text(q.question,
                      style: TextStyle(color: context.colors.textPrimary,
                          fontSize: 14, fontWeight: FontWeight.w500)),
                  SizedBox(height: 4),
                  Row(children: [
                    Text(_dateStr(q.createdAt),
                        style: TextStyle(color: context.colors.textMuted, fontSize: 11)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _toggleVisibility(q.id, q.isPublic),
                      child: Row(children: [
                        Icon(q.isPublic ? Icons.visibility : Icons.visibility_off,
                            color: context.colors.textSecondary, size: 16),
                        SizedBox(width: 4),
                        Text(q.isPublic ? t.vendor_dashboard.public : t.vendor_dashboard.private,
                            style: TextStyle(color: context.colors.textSecondary, fontSize: 11)),
                      ]),
                    ),
                  ]),
                  // Existing answer
                  if (q.answer != null && _answeringId != q.id) ...[
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: context.colors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border(left: BorderSide(color: context.colors.primary, width: 3))),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(t.vendor_dashboard.your_answer,
                            style: TextStyle(color: context.colors.primary,
                                fontSize: 11, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(q.answer!, style: TextStyle(color: context.colors.textPrimary, fontSize: 13)),
                        SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {
                            _answerCtrl.text = q.answer!;
                            setState(() => _answeringId = q.id);
                          },
                          child: Text(t.vendor_dashboard.edit_answer,
                              style: TextStyle(color: context.colors.primary,
                                  fontSize: 11, decoration: TextDecoration.underline)),
                        ),
                      ]),
                    ),
                  ],
                  // Answer input
                  if (_answeringId == q.id) ...[
                    SizedBox(height: 10),
                    TextField(
                      controller: _answerCtrl, maxLines: 3,
                      style: TextStyle(color: context.colors.textPrimary, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: t.vendor_dashboard.type_answer_placeholder,
                        hintStyle: TextStyle(color: context.colors.textMuted),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: context.colors.border)),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      TextButton(
                        onPressed: () => setState(() => _answeringId = null),
                        child: Text(t.common.cancel_label, style: TextStyle(color: context.colors.textSecondary)),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _submitting ? null : () => _submitAnswer(q.id),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.primary, foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            minimumSize: const Size(0, 0)), // Override global full-width minimum size
                        child: _submitting
                            ? SizedBox(width: 16, height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : Text(t.common.submit),
                      ),
                    ]),
                  ] else if (q.answer == null) ...[
                    SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _answeringId = q.id),
                      icon: Icon(Icons.reply, size: 16),
                      label: Text(t.community.reply, style: TextStyle(fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: context.colors.primary,
                          side: BorderSide(color: context.colors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    ),
                  ],
                ]),
              );
            },
          );
        },
      ),
    );
  }

  String _dateStr(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 6 — POLICIES
// ═══════════════════════════════════════════════════════════════════════════════

class _PoliciesTab extends ConsumerStatefulWidget {
  final WidgetRef ref;
  const _PoliciesTab({required this.ref});

  @override
  ConsumerState<_PoliciesTab> createState() => _PoliciesTabState();
}

class _PoliciesTabState extends ConsumerState<_PoliciesTab> {
  final _shipping = TextEditingController();
  final _refund = TextEditingController();
  final _return = TextEditingController();
  final _privacy = TextEditingController();
  final _terms = TextEditingController();
  bool _loaded = false;
  bool _saving = false;
  String? _error;
  String? _success;
  int _version = 0;

  @override
  void dispose() {
    _shipping.dispose(); _refund.dispose(); _return.dispose();
    _privacy.dispose(); _terms.dispose();
    super.dispose();
  }

  void _loadPolicy(VendorPolicy? policy) {
    if (_loaded) return;
    if (policy != null) {
      _shipping.text = policy.shippingPolicy;
      _refund.text = policy.refundPolicy;
      _return.text = policy.returnPolicy;
      _privacy.text = policy.privacyPolicy;
      _terms.text = policy.termsOfUse;
      _version = policy.version;
    }
    _loaded = true;
  }

  Future<void> _save() async {
    setState(() { _saving = true; _error = null; _success = null; });
    try {
      final result = await ref.read(vendorRepositoryProvider).savePolicy(
        shippingPolicy: _shipping.text,
        refundPolicy: _refund.text,
        returnPolicy: _return.text,
        privacyPolicy: _privacy.text,
        termsOfUse: _terms.text,
      );
      setState(() {
        _version = result.version;
        _success = t.vendor_dashboard.saved_version(version: _version.toString());
      });
      ref.invalidate(vendorPolicyProvider);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final policyAsync = ref.watch(vendorPolicyProvider);
    policyAsync.whenData((p) => _loadPolicy(p));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(t.vendor_dashboard.store_policies,
              style: TextStyle(color: context.colors.textPrimary,
                  fontWeight: FontWeight.bold, fontSize: 16)),
          if (_version > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant, borderRadius: BorderRadius.circular(20)),
              child: Text('v$_version',
                  style: TextStyle(color: context.colors.textSecondary,
                      fontSize: 12, fontWeight: FontWeight.bold)),
            ),
        ]),
        SizedBox(height: 4),
        Text(t.vendor_dashboard.policies_hint,
            style: TextStyle(color: context.colors.textMuted, fontSize: 12)),
        SizedBox(height: 16),
        if (_error != null)
          Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: context.colors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Text(_error!, style: TextStyle(color: context.colors.error, fontSize: 13))),
        if (_success != null)
          Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: context.colors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Text(_success!, style: TextStyle(color: context.colors.success, fontSize: 13))),
        _policyField(t.vendor_dashboard.shipping_policy, _shipping, t.vendor_dashboard.shipping_hint),
        SizedBox(height: 12),
        _policyField(t.vendor_dashboard.refund_policy, _refund, t.vendor_dashboard.refund_hint),
        SizedBox(height: 12),
        _policyField(t.vendor_dashboard.return_policy, _return, t.vendor_dashboard.return_hint),
        SizedBox(height: 12),
        _policyField(t.privacy.page_title, _privacy, t.vendor_dashboard.privacy_hint),
        SizedBox(height: 12),
        _policyField(t.footer.terms_of_use, _terms, t.vendor_dashboard.terms_hint),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saving ? null : _save,
            style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 14)),
            child: _saving
                ? SizedBox(width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text(t.vendor_dashboard.save_policies, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        SizedBox(height: 32),
      ]),
    );
  }

  Widget _policyField(String label, TextEditingController ctrl, String hint) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(color: context.colors.textPrimary,
          fontWeight: FontWeight.w600, fontSize: 14)),
      SizedBox(height: 6),
      TextField(
        controller: ctrl, maxLines: 5,
        style: TextStyle(color: context.colors.textPrimary, fontSize: 13),
        decoration: InputDecoration(
          hintText: hint, hintStyle: TextStyle(color: context.colors.textMuted, fontSize: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.colors.border)),
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 7 — SETTINGS
// ═══════════════════════════════════════════════════════════════════════════════

class _SettingsTab extends ConsumerStatefulWidget {
  final WidgetRef ref;
  const _SettingsTab({required this.ref});

  @override
  ConsumerState<_SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends ConsumerState<_SettingsTab> {
  final _storeNameCtrl = TextEditingController();
  final _slugCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _payoutCtrl = TextEditingController();
  bool _loaded = false;
  bool _saving = false;
  String? _error;
  String? _success;
  File? _logoFile;
  String? _currentLogoUrl;
  File? _bannerFile;
  String? _currentBannerUrl;

  @override
  void dispose() {
    _storeNameCtrl.dispose(); _slugCtrl.dispose();
    _descCtrl.dispose(); _emailCtrl.dispose();
    _phoneCtrl.dispose(); _payoutCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickBanner() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) setState(() => _bannerFile = File(picked.path));
  }

  void _loadSettings(VendorSettings s) {
    if (_loaded) return;
    _storeNameCtrl.text = s.storeName;
    _slugCtrl.text = s.slug;
    _descCtrl.text = s.description ?? '';
    _emailCtrl.text = s.email ?? '';
    _phoneCtrl.text = s.phone ?? '';
    _payoutCtrl.text = s.payoutAccountId ?? '';
    _currentLogoUrl = s.logoUrl;
    _currentBannerUrl = s.bannerUrl;
    _loaded = true;
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) setState(() => _logoFile = File(picked.path));
  }

  Future<void> _save() async {
    if (_storeNameCtrl.text.trim().isEmpty) {
      setState(() => _error = t.vendor_dashboard.store_name_required);
      return;
    }
    setState(() { _saving = true; _error = null; _success = null; });
    try {
      await ref.read(vendorRepositoryProvider).updateSettings(
        storeName: _storeNameCtrl.text.trim(),
        slug: _slugCtrl.text.trim().isNotEmpty ? _slugCtrl.text.trim() : null,
        description: _descCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        payoutAccountId: _payoutCtrl.text.trim(),
        logoFile: _logoFile,
        bannerFile: _bannerFile,
      );
      ref.invalidate(vendorSettingsProvider);
      setState(() {
        _success = t.vendor_dashboard.settings_saved;
        _logoFile = null;
        _bannerFile = null;
        _loaded = false; // force reload on next render
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(vendorSettingsProvider);
    settingsAsync.whenData((s) => _loadSettings(s));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(t.vendor_dashboard.store_settings,
            style: TextStyle(color: context.colors.textPrimary,
                fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 16),
        if (_error != null)
          Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: context.colors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Text(_error!, style: TextStyle(color: context.colors.error, fontSize: 13))),
        if (_success != null)
          Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: context.colors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Text(_success!, style: TextStyle(color: context.colors.success, fontSize: 13))),
        // Logo picker
        GestureDetector(
          onTap: _pickLogo,
          child: Row(children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: context.colors.surfaceVariant,
              backgroundImage: _logoFile != null
                  ? FileImage(_logoFile!) as ImageProvider
                  : (_currentLogoUrl != null
                      ? CachedNetworkImageProvider(_currentLogoUrl!)
                      : null),
              child: (_logoFile == null && _currentLogoUrl == null)
                  ? Icon(Icons.store, color: context.colors.textMuted, size: 32)
                  : null,
            ),
            SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t.vendor_dashboard.store_logo,
                  style: TextStyle(color: context.colors.textPrimary,
                      fontWeight: FontWeight.w600, fontSize: 14)),
              SizedBox(height: 2),
              TextButton.icon(
                onPressed: _pickLogo,
                icon: Icon(Icons.upload_outlined, size: 16),
                label: Text(t.vendor_dashboard.change_logo),
                style: TextButton.styleFrom(foregroundColor: context.colors.primary,
                    padding: EdgeInsets.zero, minimumSize: Size.zero),
              ),
            ]),
          ]),
        ),
        SizedBox(height: 16),
        // Banner picker
        Text(t.vendor_dashboard.store_banner, style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
        SizedBox(height: 8),
        GestureDetector(
          onTap: _pickBanner,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.colors.border),
              color: context.colors.surfaceVariant,
            ),
            clipBehavior: Clip.antiAlias,
            child: _bannerFile != null
                ? Image.file(_bannerFile!, width: double.infinity, fit: BoxFit.cover)
                : (_currentBannerUrl != null
                    ? CachedNetworkImage(imageUrl: _currentBannerUrl!,
                        width: double.infinity, fit: BoxFit.cover)
                    : Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.add_photo_alternate_outlined, color: context.colors.textMuted, size: 28),
                        SizedBox(height: 4),
                        Text(t.vendor_dashboard.add_store_banner, style: TextStyle(color: context.colors.textMuted, fontSize: 12)),
                      ]))),
          ),
        ),
        const SizedBox(height: 16),
        _settingField('${t.become_vendor.store_name} *', _storeNameCtrl),
        SizedBox(height: 10),
        _settingField(t.vendor_dashboard.slug_label, _slugCtrl,
            hint: 'waslaq.com/vendors/your-slug'),
        SizedBox(height: 10),
        _settingField(t.vendor.description, _descCtrl, maxLines: 3),
        SizedBox(height: 10),
        _settingField(t.vendor_dashboard.contact_email, _emailCtrl,
            keyboardType: TextInputType.emailAddress),
        SizedBox(height: 10),
        _settingField(t.checkout.phone, _phoneCtrl,
            keyboardType: TextInputType.phone),
        SizedBox(height: 10),
        _settingField(t.vendor_dashboard.payout_iban, _payoutCtrl,
            hint: 'IL62 0108 0000 0009 9999 999'),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saving ? null : _save,
            style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 14)),
            child: _saving
                ? SizedBox(width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text(t.vendor_dashboard.save_settings,
                    style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        SizedBox(height: 32),
      ]),
    );
  }

  Widget _settingField(String label, TextEditingController ctrl,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text, String? hint}) {
    return TextField(
      controller: ctrl, maxLines: maxLines, keyboardType: keyboardType,
      style: TextStyle(color: context.colors.textPrimary),
      decoration: InputDecoration(
        labelText: label, labelStyle: TextStyle(color: context.colors.textSecondary),
        hintText: hint, hintStyle: TextStyle(color: context.colors.textMuted, fontSize: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: context.colors.border)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SHARED WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

class _StatCard extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;
  const _StatCard({required this.value, required this.label,
      required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colors.surface, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(icon, color: color, size: 20),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: TextStyle(color: context.colors.textPrimary,
              fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 2),
          Text(label, style: TextStyle(color: context.colors.textSecondary, fontSize: 11)),
        ]),
      ]),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final VendorRecentOrder order;
  const _OrderTile({required this.order});

  Color _statusColor(BuildContext context) {
    switch (order.status.toLowerCase()) {
      case 'completed': return context.colors.success;
      case 'cancelled': return context.colors.error;
      case 'pending': return context.colors.warning;
      default: return context.colors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final diff = DateTime.now().difference(order.createdAt);
    final timeStr = diff.inDays == 0 ? '${diff.inHours}h ago' : '${diff.inDays}d ago';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: context.colors.surface,
          borderRadius: BorderRadius.circular(12), border: Border.all(color: context.colors.border)),
      child: Row(children: [
        Container(width: 40, height: 40,
            decoration: BoxDecoration(color: context.colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.receipt_outlined, color: context.colors.primary, size: 20)),
        SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(order.displayId != null ? 'Order #${order.displayId}' : order.id.substring(0, 8),
              style: TextStyle(color: context.colors.textPrimary,
                  fontWeight: FontWeight.w600, fontSize: 14)),
          Text(timeStr, style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('₪${order.total.toStringAsFixed(0)}',
              style: TextStyle(color: context.colors.primary,
                  fontWeight: FontWeight.bold, fontSize: 14)),
          SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
                color: _statusColor(context).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20)),
            child: Text(order.status,
                style: TextStyle(color: _statusColor(context), fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ]),
      ]),
    );
  }
}

Widget _emptyBox(BuildContext context, IconData icon, String message) {
  return Container(
    padding: const EdgeInsets.all(32),
    decoration: BoxDecoration(color: context.colors.surface,
        borderRadius: BorderRadius.circular(12), border: Border.all(color: context.colors.border)),
    child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 48, color: context.colors.border),
      SizedBox(height: 12),
      Text(message, style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
          textAlign: TextAlign.center),
    ])),
  );
}

Widget _errorWidget(BuildContext context, String msg, VoidCallback retry) {
  return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Icon(Icons.error_outline, size: 48, color: context.colors.error),
    SizedBox(height: 12),
    Text(msg, style: TextStyle(color: context.colors.textPrimary),
        textAlign: TextAlign.center),
    SizedBox(height: 12),
    ElevatedButton(onPressed: retry, child: Text(t.common.retry)),
  ]));
}

Widget _shimmerList(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: context.colors.surfaceVariant,
    highlightColor: context.colors.border,
    child: ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => Container(height: 72,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 8 — DISPUTES
// ═══════════════════════════════════════════════════════════════════════════════

class _DisputesTab extends StatefulWidget {
  final WidgetRef ref;
  const _DisputesTab({required this.ref});

  @override
  State<_DisputesTab> createState() => _DisputesTabState();
}

class _DisputesTabState extends State<_DisputesTab> {
  List<VendorDispute> _disputes = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      // Disputes come from the dashboard's recent_disputes
      final dash = await VendorRepository(MedusaClient.instance).getDashboard();
      if (mounted) setState(() { _disputes = dash.recentDisputes; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _openChat(VendorDispute d) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DisputeDetailScreen(
          isVendorView: true,
          dispute: DisputeModel(
            id: d.id,
            orderId: d.orderId,
            vendorId: '',
            customerId: '',
            disputeType: d.disputeType,
            description: d.description,
            status: d.status,
            createdAt: d.createdAt,
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    if (status == 'open') return context.colors.error;
    if (status == 'vendor_responded') return context.colors.warning;
    if (status == 'admin_review') return Colors.blue;
    if (status.startsWith('resolved_')) return context.colors.success;
    return context.colors.textMuted;
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'open': return 'Open';
      case 'vendor_responded': return 'Under Review';
      case 'admin_review': return 'Admin Review';
      case 'resolved_refund': return 'Resolved – Refunded';
      case 'resolved_release': return 'Resolved – Released';
      default: return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator(color: context.colors.primary));
    }
    if (_error != null) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.error_outline, color: context.colors.error, size: 48),
          SizedBox(height: 12),
          Text(_error!, style: TextStyle(color: context.colors.textPrimary), textAlign: TextAlign.center),
          SizedBox(height: 16),
          ElevatedButton(onPressed: _load, child: Text(t.common.retry_label)),
        ]),
      ));
    }
    if (_disputes.isEmpty) {
      return Center(child: _emptyBox(context, Icons.gavel_outlined, t.vendor_dashboard.no_disputes_hint));
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _disputes.length,
        separatorBuilder: (_, __) => SizedBox(height: 12),
        itemBuilder: (_, i) {
          final d = _disputes[i];
          final color = _statusColor(d.status);
          return InkWell(
            onTap: () => _openChat(d),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: context.colors.surface, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: d.isOpen ? context.colors.error.withValues(alpha: 0.3) : context.colors.border)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Header
                Row(children: [
                  Icon(Icons.gavel_outlined, color: color, size: 20),
                  SizedBox(width: 8),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(d.disputeType.replaceAll('_', ' ').toUpperCase(),
                        style: TextStyle(color: context.colors.textPrimary,
                            fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('${t.account.orders.replaceAll("s", "")}: ...${d.orderId.length > 8 ? d.orderId.substring(d.orderId.length - 8) : d.orderId}',
                        style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
                  ])),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
                    child: Text(_statusLabel(d.status),
                        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ]),
                if (d.description != null) ...[
                  SizedBox(height: 8),
                  Text(d.description!,
                      style: TextStyle(color: context.colors.textSecondary, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
                // Dates
                SizedBox(height: 8),
                Row(children: [
                  Text(t.vendor_dashboard.opened_date(date: '${d.createdAt.day}/${d.createdAt.month}/${d.createdAt.year}'),
                      style: TextStyle(color: context.colors.textMuted, fontSize: 11)),
                  if (d.resolvedAt != null) ...[
                    Text(' · ', style: TextStyle(color: context.colors.textMuted)),
                    Text(t.vendor_dashboard.resolved_date(date: '${d.resolvedAt!.day}/${d.resolvedAt!.month}/${d.resolvedAt!.year}'),
                        style: TextStyle(color: context.colors.textMuted, fontSize: 11)),
                  ],
                ]),
                // Open chat button
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _openChat(d),
                    icon: Icon(Icons.chat_bubble_outline, size: 16),
                    label: Text(
                      d.isOpen ? t.vendor_dashboard.respond : 'View Chat',
                      style: TextStyle(fontSize: 13),
                    ),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: context.colors.primary,
                        side: BorderSide(color: context.colors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  ),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}
