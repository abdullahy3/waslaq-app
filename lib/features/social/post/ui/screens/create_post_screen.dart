import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../i18n/strings.g.dart';
import '../../../../../core/api/social_client.dart';
import '../../../../../core/api/medusa_client.dart';
import '../../../../../features/product/data/models/product_model.dart';
import '../../../../../features/social/data/models/social_models.dart';
import 'product_picker_sheet.dart';

@RoutePage()
class CreatePostScreen extends ConsumerStatefulWidget {
  /// Post creation mode — determines community picker visibility and product card.
  final PostCreationType type;
  /// Pre-selected community ID (passed from community screen).
  final String? preselectedCommunityId;
  /// Pre-selected product (passed from product screen or picker).
  final ProductModel? preselectedProduct;
  /// Legacy query param — community slug for backward-compat AutoRoute navigation.
  final String? communitySlug;

  const CreatePostScreen({
    super.key,
    this.type = PostCreationType.general,
    this.preselectedCommunityId,
    this.preselectedProduct,
    @QueryParam('community') this.communitySlug,
  });

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  List<File> _images = [];
  bool _posting = false;
  String? _error;
  bool _showCommunityValidation = false;

  // Community state
  String? _selectedCommunityId;
  String? _selectedCommunitySlug;
  List<Map<String, dynamic>> _communities = [];
  bool _loadingCommunities = true;

  // Product state — mutable so "تغيير المنتج" can replace it
  ProductModel? _product;

  @override
  void initState() {
    super.initState();
    _product = widget.preselectedProduct;
    _selectedCommunityId = widget.preselectedCommunityId;
    _loadCommunities();
    _titleCtrl.addListener(() => setState(() {}));
    _contentCtrl.addListener(() => setState(() {}));
  }

  Future<void> _loadCommunities() async {
    try {
      final res = await SocialClient.instance.get('/store/social/communities');
      final list = res.data['communities'] as List<dynamic>? ?? [];
      final mapped = list.map((c) => c as Map<String, dynamic>).toList();

      // Check if product-questions is in the returned list
      var productQuestionsMatch = mapped.where((c) => c['slug'] == 'product-questions').firstOrNull;

      // If it's not found, we fetch it explicitly
      if (productQuestionsMatch == null) {
        try {
          final pqRes = await SocialClient.instance.get('/store/social/communities/product-questions');
          final pqData = pqRes.data['community'] as Map<String, dynamic>?;
          if (pqData != null) {
            final Map<String, dynamic> enrichedPq = Map<String, dynamic>.from(pqData);
            enrichedPq['isMember'] = pqRes.data['isMember'] ?? false;
            enrichedPq['isCreator'] = pqRes.data['isCreator'] ?? false;
            mapped.add(enrichedPq);
            productQuestionsMatch = enrichedPq;
          }
        } catch (e) {
          // ignore
        }
      }

      final productQuestionsId = productQuestionsMatch?['id'] as String?;

      String? resolvedId = _selectedCommunityId;
      String? resolvedSlug = _selectedCommunitySlug;

      // Default resolution rules
      final generalMatch = mapped.where((c) => c['slug'] == 'general').firstOrNull;
      final generalId = generalMatch?['id'] as String?;

      if (resolvedId == null) {
        if (widget.type == PostCreationType.productQuestion && productQuestionsId != null) {
          // Default ask_product to r/product-questions
          resolvedId = productQuestionsId;
          resolvedSlug = 'product-questions';
        } else if (widget.type == PostCreationType.general ||
            widget.type == PostCreationType.productShare) {
          resolvedId = generalId;
          resolvedSlug = 'general';
        } else if (widget.communitySlug != null) {
          final match = mapped.where((c) => c['slug'] == widget.communitySlug).firstOrNull;
          if (match != null) {
            resolvedId = match['id'] as String;
            resolvedSlug = match['slug'] as String?;
          }
        }
      }

      setState(() {
        _communities = mapped;
        _selectedCommunityId = resolvedId;
        _selectedCommunitySlug = resolvedSlug;
        _loadingCommunities = false;
      });
    } catch (e) {
      setState(() => _loadingCommunities = false);
    }
  }

  Future<void> _changeProduct() async {
    final picked = await showModalBottomSheet<ProductModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ProductPickerSheet(),
    );
    if (picked != null && mounted) {
      setState(() => _product = picked);
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(imageQuality: 80);
    if (picked.isNotEmpty) {
      setState(() => _images = [..._images, ...picked.map((x) => File(x.path))].take(5).toList());
    }
  }

  bool get _canPublish {
    if (_titleCtrl.text.trim().isEmpty) return false;
    if (_loadingCommunities) return false;
    if (_selectedCommunityId == null) return false;
    return true;
  }

  Future<void> _submit() async {
    if (_titleCtrl.text.trim().isEmpty) {
      setState(() => _error = t.community.title_required);
      return;
    }
    if (_selectedCommunityId == null) {
      setState(() => _showCommunityValidation = true);
      return;
    }
    setState(() { _posting = true; _error = null; });
    try {
      List<String> imageUrls = [];
      if (_images.isNotEmpty) {
        final formData = FormData();
        for (final file in _images) {
          formData.files.add(MapEntry('files', await MultipartFile.fromFile(file.path, filename: file.path.split('/').last)));
        }
        final uploadRes = await MedusaClient.instance.post('/store/social/upload', data: formData,
            options: Options(contentType: 'multipart/form-data'));
        imageUrls = (uploadRes.data['urls'] as List<dynamic>?)?.map((u) => u.toString()).toList() ?? [];
      }

      final generalMatch = _communities.where((c) => c['slug'] == 'general').firstOrNull;
      final generalId = generalMatch?['id'] ?? 'general';
      final communityId = _selectedCommunityId ?? generalId;

      await SocialClient.instance.post('/store/social/posts', data: {
        'title': _titleCtrl.text.trim(),
        'content': _contentCtrl.text.trim(),
        'communityId': communityId,
        'contentType': imageUrls.isNotEmpty ? 'IMAGE' : 'TEXT',
        if (imageUrls.isNotEmpty) 'mediaUrls': imageUrls,
        'productId': _product?.id,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(t.community.post_created), backgroundColor: context.colors.success));
        context.router.maybePop();
      }
    } catch (e) {
      setState(() { _error = t.community.failed_create_post; _posting = false; });
    }
  }

  /// Opens a full-screen community picker popup with search
  void _showCommunityPickerPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CommunityPickerSheet(
        communities: _communities,
        selectedCommunityId: _selectedCommunityId,
        postType: widget.type,
        onCommunitySelected: (id, slug) {
          setState(() {
            _selectedCommunityId = id;
            _selectedCommunitySlug = slug;
            _showCommunityValidation = false;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  // ── Derived helpers ───────────────────────────────────────────────────────────

  bool get _showCommunityChips =>
      widget.type == PostCreationType.community ||
      widget.type == PostCreationType.productShare ||
      widget.type == PostCreationType.productQuestion;

  bool get _showProductCard =>
      widget.type == PostCreationType.productShare ||
      widget.type == PostCreationType.productQuestion;

  String get _titleHint {
    switch (widget.type) {
      case PostCreationType.productShare:
        return 'شارك رأيك في هذا المنتج...';
      case PostCreationType.productQuestion:
        return 'ما سؤالك عن هذا المنتج؟';
      default:
        return t.community.title;
    }
  }

  String get _bodyHint {
    switch (widget.type) {
      case PostCreationType.productShare:
        return 'اكتب تجربتك... (اختياري)';
      case PostCreationType.productQuestion:
        return 'أضف تفاصيل سؤالك... (اختياري)';
      default:
        return t.community.write_post_hint;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build the selectable communities list:
    // For productQuestion: show r/product-questions as the first option + other communities
    // For others: exclude general and product-questions from the chips, show general as "عام"
    final selectableCommunities = _communities
        .where((c) => c['slug'] != 'general' && c['slug'] != 'product-questions')
        .toList();

    final generalMatch = _communities.where((c) => c['slug'] == 'general').firstOrNull;
    final generalId = generalMatch?['id'];

    final productQuestionsMatch = _communities.where((c) => c['slug'] == 'product-questions').firstOrNull;
    final productQuestionsId = productQuestionsMatch?['id'];

    // Max chips to show before "Show more"
    const maxVisibleChips = 5;
    final hasMoreCommunities = selectableCommunities.length > maxVisibleChips;
    final visibleCommunities = hasMoreCommunities
        ? selectableCommunities.take(maxVisibleChips).toList()
        : selectableCommunities;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: context.colors.textPrimary),
          onPressed: () => context.router.maybePop(),
        ),
        title: Text(
          t.community.create_post,
          style: TextStyle(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: context.colors.border),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              onPressed: (_posting || !_canPublish) ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: context.colors.primary,
                disabledBackgroundColor: context.colors.primary.withValues(alpha: 0.4),
                minimumSize: const Size(64, 34),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: _posting
                  ? const SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(t.community.post_action,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ─── COMMUNITY SELECTOR (conditional) ─────────────────────────────
          if (_showCommunityChips) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              decoration: BoxDecoration(
                color: context.colors.background,
                border: Border(bottom: BorderSide(color: context.colors.border, width: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'نشر في:',
                    style: TextStyle(
                      color: context.colors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _loadingCommunities
                      ? LinearProgressIndicator(
                          color: context.colors.primary,
                          backgroundColor: context.colors.surfaceVariant,
                        )
                      : selectableCommunities.isEmpty && generalId == null && productQuestionsId == null
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'لا توجد مجتمعات متاحة للنشر فيها. انضم إلى مجتمعات أولاً.',
                                style: TextStyle(color: context.colors.textMuted, fontSize: 13),
                              ),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  // "r/product-questions" chip — for ask_product type
                                  if (widget.type == PostCreationType.productQuestion && productQuestionsId != null) ...[
                                    _CommunityChip(
                                      label: 'r/product-questions',
                                      isSelected: _selectedCommunityId == productQuestionsId,
                                      icon: Icons.help_outline,
                                      onTap: () => setState(() {
                                        _selectedCommunityId = productQuestionsId;
                                        _selectedCommunitySlug = 'product-questions';
                                        _showCommunityValidation = false;
                                      }),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  // "Global" chip — for general feed
                                  if (generalId != null) ...[
                                    _CommunityChip(
                                      label: 'عام',
                                      isSelected: _selectedCommunityId == generalId,
                                      icon: Icons.public_outlined,
                                      onTap: () => setState(() {
                                        _selectedCommunityId = generalId;
                                        _selectedCommunitySlug = 'general';
                                        _showCommunityValidation = false;
                                      }),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  // Communities list (limited to maxVisibleChips)
                                  ...visibleCommunities.map((c) {
                                    final id = c['id'] as String;
                                    final slug = c['slug'] as String? ?? '';
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: _CommunityChip(
                                        label: 'r/$slug',
                                        isSelected: _selectedCommunityId == id,
                                        icon: Icons.people_outline,
                                        onTap: () => setState(() {
                                          _selectedCommunityId = id;
                                          _selectedCommunitySlug = slug;
                                          _showCommunityValidation = false;
                                        }),
                                      ),
                                    );
                                  }),
                                  // "Show more" button (always show so users can select/search any community)
                                  GestureDetector(
                                    onTap: _showCommunityPickerPopup,
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 180),
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: context.colors.surfaceVariant,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: context.colors.primary.withValues(alpha: 0.4)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.add_circle_outline, size: 15, color: context.colors.primary),
                                          const SizedBox(width: 6),
                                          Text(
                                            t.common.show_more,
                                            style: TextStyle(
                                              color: context.colors.primary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                  // Validation message for community type
                  if (_showCommunityValidation && _selectedCommunityId == null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'اختر مجتمعاً للنشر فيه',
                      style: TextStyle(color: context.colors.error, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
          ],

          // ─── CONTENT AREA ─────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── PRODUCT CARD ───────────────────────────────────────
                  if (_showProductCard) ...[
                    if (_product == null) ...[
                      // Prompt to pick a product if none selected
                      GestureDetector(
                        onTap: _changeProduct,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: context.colors.surfaceVariant,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: context.colors.border, style: BorderStyle.solid),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.add_shopping_cart_outlined, color: context.colors.primary, size: 22),
                              const SizedBox(width: 12),
                              Text(
                                'اختر منتجاً',
                                style: TextStyle(color: context.colors.primary, fontWeight: FontWeight.w600, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ] else ...[
                      _ProductCard(
                        product: _product!,
                        onChangeProduct: _changeProduct,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],

                  // ─── ERROR ─────────────────────────────────────────────
                  if (_error != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: context.colors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(_error!, style: TextStyle(color: context.colors.error, fontSize: 13)),
                    ),

                  // ─── TITLE ─────────────────────────────────────────────
                  TextField(
                    controller: _titleCtrl,
                    style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        height: 1.3),
                    decoration: InputDecoration(
                      hintText: _titleHint,
                      hintStyle: TextStyle(
                          color: context.colors.textMuted,
                          fontSize: 22,
                          fontWeight: FontWeight.w400),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      counterText: '',
                    ),
                    maxLength: 300,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 8),
                  Divider(color: context.colors.border, height: 1),
                  const SizedBox(height: 16),

                  // ─── BODY ──────────────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.colors.border),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: TextField(
                      controller: _contentCtrl,
                      style: TextStyle(color: context.colors.textPrimary, fontSize: 14, height: 1.5),
                      decoration: InputDecoration(
                        hintText: _bodyHint,
                        hintStyle: TextStyle(color: context.colors.textMuted, fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        counterText: '',
                      ),
                      maxLines: null,
                      minLines: 8,
                      maxLength: 10000,
                    ),
                  ),

                  // ─── IMAGE STRIP ───────────────────────────────────────
                  if (_images.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      'الصور المرفقة (${_images.length}/5)',
                      style: TextStyle(color: context.colors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: context.colors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: context.colors.border),
                      ),
                      child: SizedBox(
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _images.length,
                          itemBuilder: (ctx, i) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Stack(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(_images[i], width: 90, height: 90, fit: BoxFit.cover),
                              ),
                              Positioned(
                                top: 4, right: 4,
                                child: GestureDetector(
                                  onTap: () => setState(() => _images.removeAt(i)),
                                  child: Container(
                                    decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(Icons.close, color: Colors.white, size: 12),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ─── BOTTOM ACTION BAR ─────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: context.colors.surface,
              border: Border(top: BorderSide(color: context.colors.border, width: 0.5)),
            ),
            padding: EdgeInsets.fromLTRB(12, 8, 12, MediaQuery.of(context).padding.bottom + 8),
            child: Row(
              children: [
                _ToolbarButton(
                  icon: Icons.image_outlined,
                  label: 'صورة',
                  onTap: _pickImages,
                  badgeCount: _images.length,
                ),
                const Spacer(),
                Text(
                  '${_titleCtrl.text.length + _contentCtrl.text.length}/10300',
                  style: TextStyle(color: context.colors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// COMMUNITY PICKER SHEET — Full popup with search for selecting any community
// ══════════════════════════════════════════════════════════════════════════════

class _CommunityPickerSheet extends StatefulWidget {
  final List<Map<String, dynamic>> communities;
  final String? selectedCommunityId;
  final PostCreationType postType;
  final void Function(String id, String slug) onCommunitySelected;

  const _CommunityPickerSheet({
    required this.communities,
    this.selectedCommunityId,
    required this.postType,
    required this.onCommunitySelected,
  });

  @override
  State<_CommunityPickerSheet> createState() => _CommunityPickerSheetState();
}

class _CommunityPickerSheetState extends State<_CommunityPickerSheet> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, dynamic>> _allCommunities = [];

  @override
  void initState() {
    super.initState();
    _allCommunities = widget.communities;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    if (query == _searchQuery) return;
    setState(() => _searchQuery = query);
  }

  List<Map<String, dynamic>> get _filteredCommunities {
    if (_searchQuery.isEmpty) return _allCommunities;
    return _allCommunities.where((c) {
      final name = (c['name'] as String? ?? '').toLowerCase();
      final slug = (c['slug'] as String? ?? '').toLowerCase();
      final title = (c['title'] as String? ?? '').toLowerCase();
      return name.contains(_searchQuery) ||
          slug.contains(_searchQuery) ||
          title.contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredCommunities;
    final lang = Translations.of(context).$meta.locale.languageCode;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // ── Handle bar ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // ── Title ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.people_outline, color: context.colors.primary, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    lang == 'ar' ? 'اختر مجتمعاً' : 'Select Community',
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: context.colors.textMuted, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // ── Search bar ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: context.colors.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: lang == 'ar' ? 'ابحث عن مجتمعات...' : 'Search communities...',
                hintStyle: TextStyle(color: context.colors.textMuted, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: context.colors.textMuted, size: 20),
                filled: true,
                fillColor: context.colors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.colors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.colors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: context.colors.primary, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // ── Community list ─────────────────────────────────────
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 48, color: context.colors.textMuted),
                        const SizedBox(height: 12),
                        Text(
                          lang == 'ar' ? 'لم يتم العثور على مجتمعات' : 'No communities found',
                          style: TextStyle(color: context.colors.textMuted, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final c = filtered[index];
                      final id = c['id'] as String;
                      final slug = c['slug'] as String? ?? '';
                      final title = c['title'] as String? ?? c['name'] as String? ?? '';
                      final isPrivate = c['isPrivate'] as bool? ?? false;
                      final isMember = c['isMember'] as bool? ?? false;
                      final memberCount = c['memberCount'] as int? ?? 0;
                      final iconUrl = c['iconUrl'] as String?;
                      final isSelected = widget.selectedCommunityId == id;

                      // Private communities can't be selected unless user is a member
                      final canSelect = !isPrivate || isMember;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? context.colors.primary.withValues(alpha: 0.08)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(color: context.colors.primary.withValues(alpha: 0.3))
                              : null,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: context.colors.primary.withValues(alpha: 0.15),
                            backgroundImage: iconUrl != null && iconUrl.isNotEmpty
                                ? NetworkImage(iconUrl)
                                : null,
                            child: iconUrl == null || iconUrl.isEmpty
                                ? Text(
                                    title.isNotEmpty ? title[0].toUpperCase() : 'r',
                                    style: TextStyle(
                                      color: context.colors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  )
                                : null,
                          ),
                          title: Text(
                            title,
                            style: TextStyle(
                              color: canSelect ? context.colors.textPrimary : context.colors.textMuted,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                'r/$slug',
                                style: TextStyle(color: context.colors.textMuted, fontSize: 11),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$memberCount ${lang == 'ar' ? 'عضو' : 'members'}',
                                style: TextStyle(color: context.colors.textMuted, fontSize: 11),
                              ),
                            ],
                          ),
                          trailing: _buildTrailing(context, isSelected, isPrivate, isMember, canSelect, lang),
                          onTap: () {
                            if (!canSelect) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(lang == 'ar'
                                      ? 'انضم لهذا المجتمع الخاص لاختياره'
                                      : 'Join this private community to select it'),
                                  backgroundColor: context.colors.error,
                                ),
                              );
                              return;
                            }
                            widget.onCommunitySelected(id, slug);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrailing(BuildContext context, bool isSelected, bool isPrivate, bool isMember, bool canSelect, String lang) {
    if (isSelected) {
      return Icon(Icons.check_circle, color: context.colors.primary, size: 22);
    }
    if (!canSelect) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_outlined, color: context.colors.textMuted, size: 16),
          const SizedBox(width: 4),
          Text(
            lang == 'ar' ? 'خاص' : 'Private',
            style: TextStyle(color: context.colors.textMuted, fontSize: 11),
          ),
        ],
      );
    }
    if (isMember) {
      return Icon(Icons.check_circle_outline, color: context.colors.success, size: 20);
    }
    return Icon(Icons.public, color: context.colors.textMuted, size: 20);
  }
}

// ── Product card (shown at top when a product is linked) ─────────────────────

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onChangeProduct;

  const _ProductCard({required this.product, required this.onChangeProduct});

  @override
  Widget build(BuildContext context) {
    final price = product.lowestPrice;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 56, height: 56,
              child: product.thumbnail != null
                  ? CachedNetworkImage(
                      imageUrl: product.thumbnail!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: context.colors.surfaceVariant),
                      errorWidget: (_, __, ___) => Container(
                        color: context.colors.surfaceVariant,
                        child: const Icon(Icons.image_outlined, color: Colors.grey, size: 20),
                      ),
                    )
                  : Container(
                      color: context.colors.surfaceVariant,
                      child: const Icon(Icons.image_outlined, color: Colors.grey, size: 20),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (price != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    '₪${price.toStringAsFixed(0)}',
                    style: TextStyle(color: context.colors.primary, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ],
            ),
          ),
          TextButton(
            onPressed: onChangeProduct,
            child: Text(
              'تغيير المنتج',
              style: TextStyle(color: context.colors.primary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Community chip selector ───────────────────────────────────────────────────

class _CommunityChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final IconData icon;
  final VoidCallback onTap;

  const _CommunityChip({
    required this.label,
    required this.isSelected,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? context.colors.primary : context.colors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? context.colors.primary : context.colors.border,
          ),
          boxShadow: isSelected
              ? [BoxShadow(
                  color: context.colors.primary.withValues(alpha: 0.18),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: isSelected ? Colors.white : context.colors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : context.colors.textSecondary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Toolbar button ────────────────────────────────────────────────────────────

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int badgeCount;

  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: context.colors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Badge(
              isLabelVisible: badgeCount > 0,
              label: Text('$badgeCount'),
              backgroundColor: context.colors.primary,
              child: Icon(icon, size: 18, color: context.colors.textSecondary),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                  color: context.colors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
