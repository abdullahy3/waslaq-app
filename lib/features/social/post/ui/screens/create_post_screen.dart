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
  const CreatePostScreen({super.key, @QueryParam('community') this.communitySlug});
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
  }

  Future<void> _loadCommunities() async {
    try {
      final res = await SocialClient.instance.get('/store/social/communities');
      final list = res.data['communities'] as List<dynamic>? ?? [];
      setState(() {
        _communities = list.map((c) => c as Map<String, dynamic>).toList();
        _loadingCommunities = false;
        if (widget.communitySlug != null) {
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
    if (_selectedCommunityId == null) {
      setState(() => _error = t.community.select_community_required);
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
        'communityId': _selectedCommunityId,
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
  void dispose() { _titleCtrl.dispose(); _contentCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(t.community.create_post, style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background, iconTheme: IconThemeData(color: context.colors.textPrimary), elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: _posting ? null : _submit,
              child: _posting
                  ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: context.colors.primary))
                  : Text(t.community.post_action, style: TextStyle(color: context.colors.primary, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (_error != null)
            Container(
              width: double.infinity, padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: context.colors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(_error!, style: TextStyle(color: context.colors.error, fontSize: 13)),
            ),
          Text(t.community.community, style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
          SizedBox(height: 8),
          _loadingCommunities
              ? LinearProgressIndicator(color: context.colors.primary)
              : DropdownButtonFormField<String>(
                  value: _selectedCommunityId,
                  hint: Text(t.community.select_community, style: TextStyle(color: context.colors.textMuted, fontSize: 14)),
                  style: TextStyle(color: context.colors.textPrimary, fontSize: 14),
                  dropdownColor: context.colors.surface,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.colors.border)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                  items: _communities.map((c) => DropdownMenuItem<String>(
                    value: c['id'] as String,
                    child: Text('r/${c['slug'] ?? c['name']}', style: TextStyle(color: context.colors.textPrimary, fontSize: 14)),
                  )).toList(),
                  onChanged: (v) => setState(() => _selectedCommunityId = v),
                ),
          SizedBox(height: 20),
          TextField(
            controller: _titleCtrl,
            style: TextStyle(color: context.colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: t.community.title,
              hintStyle: TextStyle(color: context.colors.textMuted, fontWeight: FontWeight.normal),
              border: InputBorder.none, contentPadding: EdgeInsets.zero,
            ),
            maxLength: 300,
          ),
          TextField(
            controller: _contentCtrl,
            style: TextStyle(color: context.colors.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: t.community.write_post_hint,
              hintStyle: TextStyle(color: context.colors.textMuted),
              border: InputBorder.none, contentPadding: EdgeInsets.zero,
            ),
            maxLines: null, minLines: 5, maxLength: 10000,
          ),
          const SizedBox(height: 12),
          if (_images.isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _images.length,
                itemBuilder: (ctx, i) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Stack(children: [
                    ClipRRect(borderRadius: BorderRadius.circular(10),
                      child: Image.file(_images[i], width: 100, height: 100, fit: BoxFit.cover)),
                    Positioned(top: 4, right: 4, child: GestureDetector(
                      onTap: () => setState(() => _images.removeAt(i)),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                        padding: const EdgeInsets.all(4),
                        child: Icon(Icons.close, color: Colors.white, size: 14),
                      ),
                    )),
                  ]),
                ),
              ),
            ),
          SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickImages,
            icon: Icon(Icons.image_outlined, size: 18),
            label: Text(_images.isEmpty ? t.community.add_images : t.community.add_more_images_param(count: _images.length.toString())),
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colors.textSecondary,
              side: BorderSide(color: context.colors.border),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ]),
      ),
    );
  }
}
