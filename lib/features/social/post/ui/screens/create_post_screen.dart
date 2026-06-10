import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../i18n/strings.g.dart';
import '../../../../../core/api/social_client.dart';
import '../../../../../core/api/medusa_client.dart';

@RoutePage()
class CreatePostScreen extends ConsumerStatefulWidget {
  final String? communitySlug;
  final String? prefilledProductId;
  const CreatePostScreen({
    super.key,
    @QueryParam('community') this.communitySlug,
    @QueryParam('productId') this.prefilledProductId,
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
  String? _selectedCommunityId;
  List<Map<String, dynamic>> _communities = [];
  bool _loadingCommunities = true;

  @override
  void initState() {
    super.initState();
    _loadCommunities();
    _titleCtrl.addListener(() => setState(() {}));
    _contentCtrl.addListener(() => setState(() {}));
  }

  Future<void> _loadCommunities() async {
    try {
      final res = await SocialClient.instance.get('/store/social/communities');
      final list = res.data['communities'] as List<dynamic>? ?? [];
      setState(() {
        _communities = list.map((c) => c as Map<String, dynamic>).toList();
        _loadingCommunities = false;
        if (widget.communitySlug != null && widget.communitySlug != 'general') {
          final match = _communities.where((c) => c['slug'] == widget.communitySlug).firstOrNull;
          if (match != null) _selectedCommunityId = match['id'] as String;
        }
      });
    } catch (e) {
      setState(() => _loadingCommunities = false);
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(imageQuality: 80);
    if (picked.isNotEmpty) {
      setState(() => _images = [..._images, ...picked.map((x) => File(x.path))].take(5).toList());
    }
  }

  Future<void> _submit() async {
    if (_titleCtrl.text.trim().isEmpty) {
      setState(() => _error = t.community.title_required);
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

      await SocialClient.instance.post('/store/social/posts', data: {
        'title': _titleCtrl.text.trim(),
        'content': _contentCtrl.text.trim(),
        'communityId': _selectedCommunityId ?? 'general',
        'contentType': imageUrls.isNotEmpty ? 'IMAGE' : 'TEXT',
        if (imageUrls.isNotEmpty) 'mediaUrls': imageUrls,
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

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: _posting ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: context.colors.primary,
                minimumSize: const Size(64, 34),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: _posting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text(t.community.post_action,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ─── COMMUNITY SELECTOR ───────────────────────────────
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
                  Localizations.localeOf(context).languageCode == 'ar'
                      ? 'نشر في:'
                      : 'Post to:',
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
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Global option
                            _CommunityChip(
                              label: Localizations.localeOf(context).languageCode == 'ar'
                                  ? 'عام'
                                  : 'Global',
                              isSelected: _selectedCommunityId == null || _selectedCommunityId == 'general',
                              icon: Icons.public_outlined,
                              onTap: () =>
                                  setState(() => _selectedCommunityId = null),
                            ),
                            const SizedBox(width: 8),
                            // Community options
                            ..._communities.where((c) => c['slug'] != 'general').map((c) {
                              final id = c['id'] as String;
                              final slug = c['slug'] as String? ?? '';
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: _CommunityChip(
                                  label: 'r/$slug',
                                  isSelected: _selectedCommunityId == id,
                                  icon: Icons.people_outline,
                                  onTap: () =>
                                      setState(() => _selectedCommunityId = id),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
              ],
            ),
          ),

          // ─── CONTENT AREA ─────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Error
                  if (_error != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: context.colors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(_error!,
                          style: TextStyle(
                              color: context.colors.error, fontSize: 13)),
                    ),

                  // Title
                  TextField(
                    controller: _titleCtrl,
                    style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        height: 1.3),
                    decoration: InputDecoration(
                      hintText: t.community.title,
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

                  // Content Input Box (Softer textarea border)
                  Container(
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.colors.border),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: TextField(
                      controller: _contentCtrl,
                      style: TextStyle(
                          color: context.colors.textPrimary,
                          fontSize: 14,
                          height: 1.5),
                      decoration: InputDecoration(
                        hintText: t.community.write_post_hint,
                        hintStyle: TextStyle(
                            color: context.colors.textMuted, fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        counterText: '',
                      ),
                      maxLines: null,
                      minLines: 8,
                      maxLength: 10000,
                    ),
                  ),

                  // Image strip (Visually separated media upload section)
                  if (_images.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      Localizations.localeOf(context).languageCode == 'ar'
                          ? 'الصور المرفقة (${_images.length}/5)'
                          : 'Attached Images (${_images.length}/5)',
                      style: TextStyle(
                        color: context.colors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
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
                                child: Image.file(_images[i],
                                    width: 90, height: 90, fit: BoxFit.cover),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => _images.removeAt(i)),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(Icons.close,
                                        color: Colors.white, size: 12),
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

          // ─── BOTTOM ACTION BAR ────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: context.colors.surface,
              border:
                  Border(top: BorderSide(color: context.colors.border, width: 0.5)),
            ),
            padding: EdgeInsets.fromLTRB(
                12, 8, 12, MediaQuery.of(context).padding.bottom + 8),
            child: Row(
              children: [
                // Image picker
                _ToolbarButton(
                  icon: Icons.image_outlined,
                  label: Localizations.localeOf(context).languageCode == 'ar'
                      ? 'صورة'
                      : 'Image',
                  onTap: _pickImages,
                  badgeCount: _images.length,
                ),
                const SizedBox(width: 4),
                // Character count hint
                const Spacer(),
                Text(
                  '${_titleCtrl.text.length + _contentCtrl.text.length}/10300',
                  style: TextStyle(
                      color: context.colors.textMuted, fontSize: 11),
                ),
              ],
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
          color: isSelected
              ? context.colors.primary
              : context.colors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? context.colors.primary
                : context.colors.border,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.colors.primary.withOpacity(0.18),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? Colors.white : context.colors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : context.colors.textSecondary,
                fontSize: 12,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w600,
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
              child: Icon(icon,
                  size: 18, color: context.colors.textSecondary),
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
