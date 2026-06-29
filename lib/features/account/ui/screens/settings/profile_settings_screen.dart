import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:waslaq_app/core/api/medusa_client.dart';
import 'package:waslaq_app/core/auth/auth_notifier.dart';
import 'package:waslaq_app/shared/theme/app_colors.dart';
import 'package:waslaq_app/features/social/providers/social_providers.dart';
import 'package:waslaq_app/features/social/data/models/social_models.dart';
import 'package:waslaq_app/features/account/providers/account_providers.dart';
import 'package:waslaq_app/core/error/error_localizer.dart';

@RoutePage()
class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _displayNameController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;
  late TextEditingController _websiteController;
  late TextEditingController _usernameController;
  late TextEditingController _newHobbyController;
  late TextEditingController _twitterController;
  late TextEditingController _instagramController;
  late TextEditingController _facebookController;
  late TextEditingController _tiktokController;

  String? _gender;
  List<String> _hobbies = [];
  bool _showColorSwatches = false;
  String? _selectedBannerColor;
  String? _bannerUrl;
  String? _avatarUrl;
  String _avatarStyle = 'big-smile';
  String _avatarSeed = 'Felix';

  bool _isUploadingBanner = false;
  bool _isUploadingAvatar = false;
  bool _isSaving = false;
  bool _isChangingUsername = false;

  bool _initialized = false;
  bool _profileLoaded = false;
  String? _loadError;
  String? _customerId;
  String _profileUsername = '';
  DateTime? _profileUsernameChangedAt;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController();
    _bioController = TextEditingController();
    _locationController = TextEditingController();
    _websiteController = TextEditingController();
    _usernameController = TextEditingController();
    _newHobbyController = TextEditingController();
    _twitterController = TextEditingController();
    _instagramController = TextEditingController();
    _facebookController = TextEditingController();
    _tiktokController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProfileOnce());
  }

  Future<void> _loadProfileOnce() async {
    if (!mounted) return;
    final authState = ref.read(authNotifierProvider);
    final customerId = authState.maybeWhen(
      authenticated: (id, _, __, ___, ____) => id,
      orElse: () => null,
    );
    if (customerId == null) return;
    _customerId = customerId;
    try {
      final profile = await ref.read(userProfileProvider(customerId).future);
      if (!mounted) return;
      _initFields(profile);
      setState(() => _profileLoaded = true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadError = e.toString());
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    _usernameController.dispose();
    _newHobbyController.dispose();
    _twitterController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    _tiktokController.dispose();
    super.dispose();
  }

  void _initFields(UserProfileModel profile) {
    if (_initialized) return;
    _displayNameController.text = profile.displayName;
    _bioController.text = profile.bio;
    _locationController.text = profile.location ?? '';
    _websiteController.text = profile.website ?? '';
    _twitterController.text = profile.socialLinks['twitter'] ?? '';
    _instagramController.text = profile.socialLinks['instagram'] ?? '';
    _facebookController.text = profile.socialLinks['facebook'] ?? '';
    _tiktokController.text = profile.socialLinks['tiktok'] ?? '';
    _gender = profile.gender;
    _hobbies = List<String>.from(profile.hobbies);
    _selectedBannerColor = profile.bannerColor;
    _bannerUrl = profile.bannerUrl;
    _avatarUrl = profile.avatarUrl;
    _avatarStyle = profile.avatarStyle;
    _avatarSeed = profile.avatarSeed;
    _profileUsername = profile.username;
    _profileUsernameChangedAt = profile.usernameChangedAt;
    _initialized = true;
  }

  Color _parseHexColor(String? hex) {
    try {
      if (hex == null || hex.isEmpty) return const Color(0xFF6D28D9);
      final clean = hex.replaceAll('#', '');
      if (clean.length == 6) return Color(int.parse('FF$clean', radix: 16));
      if (clean.length == 8) return Color(int.parse(clean, radix: 16));
    } catch (_) {}
    return const Color(0xFF6D28D9);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    try { return DateFormat.yMMMMd().format(date); } catch (_) {}
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _uploadBanner() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;
    setState(() => _isUploadingBanner = true);
    try {
      final formData = FormData();
      formData.files.add(MapEntry('files',
          await MultipartFile.fromFile(picked.path, filename: picked.path.split('/').last)));
      final res = await MedusaClient.instance.post('/store/social/upload',
          data: formData, options: Options(contentType: 'multipart/form-data'));
      final urls = (res.data['urls'] as List<dynamic>?)?.map((u) => u.toString()).toList() ?? [];
      if (urls.isEmpty) throw Exception('Upload failed');
      setState(() { _bannerUrl = urls.first; _selectedBannerColor = null; _isUploadingBanner = false; });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Banner uploaded. Save to apply.'), backgroundColor: context.colors.success));
    } catch (e) {
      setState(() => _isUploadingBanner = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizeError(e)), backgroundColor: context.colors.error));
    }
  }

  Future<void> _uploadAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;
    setState(() => _isUploadingAvatar = true);
    try {
      final formData = FormData();
      formData.files.add(MapEntry('files',
          await MultipartFile.fromFile(picked.path, filename: picked.path.split('/').last)));
      final res = await MedusaClient.instance.post('/store/social/upload',
          data: formData, options: Options(contentType: 'multipart/form-data'));
      final urls = (res.data['urls'] as List<dynamic>?)?.map((u) => u.toString()).toList() ?? [];
      if (urls.isEmpty) throw Exception('Upload failed');
      setState(() { _avatarUrl = urls.first; _isUploadingAvatar = false; });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Avatar uploaded. Save to apply.'), backgroundColor: context.colors.success));
    } catch (e) {
      setState(() => _isUploadingAvatar = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizeError(e)), backgroundColor: context.colors.error));
    }
  }

  void _showAvatarGallery() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85, minChildSize: 0.5, maxChildSize: 0.95,
        builder: (ctx2, sc) => _AvatarGalleryModal(
          initialStyle: _avatarStyle,
          initialSeed: _avatarSeed,
          onApply: (style, seed) => setState(() { _avatarStyle = style; _avatarSeed = seed; _avatarUrl = null; }),
        ),
      ),
    );
  }

  Future<void> _saveProfile(String customerId) async {
    setState(() => _isSaving = true);
    try {
      await ref.read(accountRepositoryProvider).updateProfileExtended(
        customerId,
        displayName: _displayNameController.text.trim(),
        bio: _bioController.text.trim(),
        location: _locationController.text.trim(),
        website: _websiteController.text.trim(),
        gender: _gender,
        hobbies: _hobbies,
        socialLinks: {
          'twitter': _twitterController.text.trim(),
          'instagram': _instagramController.text.trim(),
          'facebook': _facebookController.text.trim(),
          'tiktok': _tiktokController.text.trim(),
        },
        bannerUrl: _bannerUrl ?? '',
        bannerColor: _selectedBannerColor ?? '',
        avatarUrl: _avatarUrl ?? '',
        avatarStyle: _avatarStyle,
        avatarSeed: _avatarSeed,
      );
      ref.invalidate(userProfileProvider(customerId));
      ref.read(authNotifierProvider.notifier).refreshProfile();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Profile saved!'), backgroundColor: context.colors.success));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizeError(e)), backgroundColor: context.colors.error));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _changeUsername() async {
    final newUsername = _usernameController.text.trim();
    if (newUsername.isEmpty) return;
    setState(() => _isChangingUsername = true);
    try {
      final res = await ref.read(accountRepositoryProvider).changeUsername(newUsername);
      final success = res['success'] as bool? ?? false;
      if (success) {
        setState(() => _profileUsername = newUsername);
        final cid = ref.read(authNotifierProvider).maybeWhen(
            authenticated: (id, _, __, ___, ____) => id, orElse: () => null);
        if (cid != null) {
          ref.invalidate(userProfileProvider(cid));
          ref.read(authNotifierProvider.notifier).refreshProfile();
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('Username changed!'), backgroundColor: context.colors.success));
      } else {
        final canChangeAt = res['canChangeAt'] as String?;
        if (canChangeAt != null && mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: context.colors.surface,
              title: const Text('Cannot Change Username'),
              content: Text('Next change allowed: ${_formatDate(DateTime.tryParse(canChangeAt))}'),
              actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizeError(e)), backgroundColor: context.colors.error));
    } finally {
      if (mounted) setState(() => _isChangingUsername = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: const Text('Profile Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (!_profileLoaded && _loadError == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_loadError != null) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.wifi_off_rounded, color: context.colors.error, size: 64),
          const SizedBox(height: 16),
          Text('Failed to load profile',
              style: TextStyle(color: context.colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(_loadError!, textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.textSecondary, fontSize: 13)),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: OutlinedButton.styleFrom(
                foregroundColor: context.colors.primary, side: BorderSide(color: context.colors.primary)),
            onPressed: () {
              setState(() { _profileLoaded = false; _loadError = null; _initialized = false; });
              _loadProfileOnce();
            },
          ),
        ]),
      ));
    }
    return _buildForm(context, _customerId!);
  }

  Widget _buildForm(BuildContext context, String customerId) {
    final hasAvatarUrl = _avatarUrl != null && _avatarUrl!.isNotEmpty &&
        (_avatarUrl!.startsWith('http://') || _avatarUrl!.startsWith('https://'));
    final diceBearStyle = _avatarStyle.isEmpty ? 'big-smile' : _avatarStyle;
    final diceBearSeed = _avatarSeed.isEmpty ? 'Felix' : _avatarSeed;
    final diceBearUrl = 'https://api.dicebear.com/9.x/$diceBearStyle/png?seed=$diceBearSeed&size=128';
    final hasBannerUrl = _bannerUrl != null && _bannerUrl!.isNotEmpty &&
        (_bannerUrl!.startsWith('http://') || _bannerUrl!.startsWith('https://'));

    return Form(
      key: _formKey,
      child: ListView(
        physics: const ClampingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: Stack(children: [
              Positioned(
                top: 0, left: 0, right: 0, height: 140,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.colors.border, width: 1),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: hasBannerUrl
                        ? CachedNetworkImage(imageUrl: _bannerUrl!, fit: BoxFit.cover,
                            placeholder: (_, __) => Container(color: _parseHexColor(_selectedBannerColor)),
                            errorWidget: (_, __, ___) => Container(color: _parseHexColor(_selectedBannerColor)))
                        : Container(color: _parseHexColor(_selectedBannerColor)),
                  ),
                ),
              ),
              Positioned(
                left: 16, bottom: 40,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: context.colors.background, width: 4),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.20), blurRadius: 8, offset: const Offset(0, 3))],
                  ),
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: context.colors.surface,
                    backgroundImage: hasAvatarUrl
                        ? CachedNetworkImageProvider(_avatarUrl!)
                        : CachedNetworkImageProvider(diceBearUrl),
                  ),
                ),
              ),
              Positioned(
                bottom: 0, left: 16 + 80 + 12, right: 16,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    _displayNameController.text.isEmpty ? _profileUsername : _displayNameController.text,
                    style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  Text('@$_profileUsername',
                      style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 16),

          const Text('Banner', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: OutlinedButton.icon(
              icon: _isUploadingBanner
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.upload),
              label: const Text('Upload Image'),
              onPressed: _isUploadingBanner ? null : _uploadBanner,
            )),
            const SizedBox(width: 12),
            Expanded(child: OutlinedButton.icon(
              icon: const Icon(Icons.palette_outlined),
              label: const Text('Color'),
              onPressed: () => setState(() => _showColorSwatches = !_showColorSwatches),
            )),
          ]),
          if (_showColorSwatches) ...[
            const SizedBox(height: 12),
            SizedBox(height: 48, child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              children: ['#6d28d9','#7c3aed','#4f46e5','#0ea5e9','#10b981',
                         '#f59e0b','#ef4444','#ec4899','#111827','#374151'].map((hex) {
                final isSel = _selectedBannerColor == hex;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() { _selectedBannerColor = hex; _bannerUrl = null; }),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: _parseHexColor(hex), shape: BoxShape.circle,
                        border: Border.all(color: isSel ? context.colors.primary : Colors.transparent, width: 2),
                      ),
                      child: isSel ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
                    ),
                  ),
                );
              }).toList(),
            )),
          ],
          const SizedBox(height: 20),
          const Text('Avatar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: OutlinedButton.icon(
              icon: const Icon(Icons.face), label: const Text('Avatar Gallery'),
              onPressed: _showAvatarGallery,
            )),
            const SizedBox(width: 12),
            Expanded(child: OutlinedButton.icon(
              icon: _isUploadingAvatar
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.photo_camera),
              label: const Text('Upload Photo'),
              onPressed: _isUploadingAvatar ? null : _uploadAvatar,
            )),
          ]),
          if (hasAvatarUrl) ...[
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () => setState(() => _avatarUrl = null),
                child: const Text('Clear Photo'),
              ),
            ),
          ],
          const SizedBox(height: 20),
          const Text('Profile Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          _ProfileField(label: 'Display Name', controller: _displayNameController),
          const SizedBox(height: 12),
          _ProfileField(label: 'Bio', controller: _bioController, maxLines: 4),
          const SizedBox(height: 12),
          _ProfileField(label: 'Location', controller: _locationController, hint: 'e.g. Nablus, West Bank'),
          const SizedBox(height: 12),
          _ProfileField(label: 'Website', controller: _websiteController, hint: 'https://...'),
          const SizedBox(height: 12),
          _GenderTile(value: _gender, onChanged: (val) => setState(() => _gender = val)),
          const SizedBox(height: 20),

          const Text('Hobbies', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: 6,
            children: _hobbies.map((h) =>
                _HobbyTag(label: h, onDelete: () => setState(() => _hobbies.remove(h)))).toList(),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _newHobbyController,
            style: TextStyle(color: context.colors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Add a hobby and press Enter',
              hintStyle: TextStyle(color: context.colors.textMuted),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  final v = _newHobbyController.text.trim();
                  if (v.isNotEmpty && _hobbies.length < 10) { setState(() => _hobbies.add(v)); _newHobbyController.clear(); }
                },
              ),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.border)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.primary)),
            ),
            onSubmitted: (v) {
              final c = v.trim();
              if (c.isNotEmpty && _hobbies.length < 10) { setState(() => _hobbies.add(c)); _newHobbyController.clear(); }
            },
          ),
          const SizedBox(height: 20),
          const Text('Social Links', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          _SocialField(icon: Icons.close, label: 'Twitter', controller: _twitterController),
          const SizedBox(height: 8),
          _SocialField(icon: Icons.camera_alt_outlined, label: 'Instagram', controller: _instagramController),
          const SizedBox(height: 8),
          _SocialField(icon: Icons.facebook_outlined, label: 'Facebook', controller: _facebookController),
          const SizedBox(height: 8),
          _SocialField(icon: Icons.music_note_outlined, label: 'TikTok', controller: _tiktokController),
          const SizedBox(height: 24),
          Card(
            elevation: 0, color: context.colors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: context.colors.border)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Username', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text('Current: @$_profileUsername', style: TextStyle(color: context.colors.textSecondary)),
                if (_profileUsernameChangedAt != null) ...[
                  const SizedBox(height: 4),
                  Text('Last changed: ${_formatDate(_profileUsernameChangedAt)}',
                      style: TextStyle(color: context.colors.textMuted, fontSize: 12)),
                ],
                const SizedBox(height: 8),
                Text('You can only change your username once per year.',
                    style: TextStyle(color: Colors.amber[800], fontSize: 12, fontWeight: FontWeight.w500)),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: TextField(
                    controller: _usernameController,
                    style: TextStyle(color: context.colors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'New username',
                      hintStyle: TextStyle(color: context.colors.textMuted),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.border)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.primary)),
                    ),
                  )),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: context.colors.primary, foregroundColor: Colors.white),
                    onPressed: _isChangingUsername ? null : _changeUsername,
                    child: _isChangingUsername
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Change'),
                  ),
                ]),
              ]),
            ),
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: _isSaving ? null : () => _saveProfile(customerId),
            style: FilledButton.styleFrom(
              backgroundColor: context.colors.primary,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isSaving
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Save Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

// ─── _GenderTile ─────────────────────────────────────────────────────────────
class _GenderTile extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  const _GenderTile({required this.value, required this.onChanged});

  static const _opts = [
    MapEntry('', 'Prefer not to say'),
    MapEntry('man', 'Man'),
    MapEntry('woman', 'Woman'),
    MapEntry('non-binary', 'Non-binary'),
    MapEntry('other', 'Other'),
  ];

  String _label() {
    try { return _opts.firstWhere((e) => e.key == (value ?? '')).value; }
    catch (_) { return 'Prefer not to say'; }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: context.colors.surface,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
          builder: (_) => SafeArea(child: Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(height: 8),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 12),
            ..._opts.map((e) => ListTile(
              title: Text(e.value, style: TextStyle(color: context.colors.textPrimary)),
              trailing: (value ?? '') == e.key ? Icon(Icons.check, color: context.colors.primary) : null,
              onTap: () { Navigator.pop(context); onChanged(e.key.isEmpty ? null : e.key); },
            )),
            const SizedBox(height: 8),
          ])),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(children: [
          Expanded(child: Text(_label(), style: TextStyle(color: context.colors.textPrimary))),
          Icon(Icons.arrow_drop_down, color: context.colors.textSecondary),
        ]),
      ),
    );
  }
}

// ─── _ProfileField ────────────────────────────────────────────────────────────
class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;
  final String? hint;
  const _ProfileField({required this.label, required this.controller, this.maxLines = 1, this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: context.colors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: context.colors.textSecondary),
        hintText: hint,
        hintStyle: TextStyle(color: context.colors.textMuted),
        filled: true,
        fillColor: context.colors.surface,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.border)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.primary)),
      ),
    );
  }
}

// ─── _SocialField ─────────────────────────────────────────────────────────────
class _SocialField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  const _SocialField({required this.icon, required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: context.colors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: context.colors.textSecondary),
        prefixIcon: Icon(icon, color: context.colors.primary, size: 20),
        filled: true,
        fillColor: context.colors.surface,
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.border)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: context.colors.primary)),
      ),
    );
  }
}

// ─── _HobbyTag ────────────────────────────────────────────────────────────────
class _HobbyTag extends StatelessWidget {
  final String label;
  final VoidCallback onDelete;
  const _HobbyTag({required this.label, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(label, style: TextStyle(color: context.colors.textPrimary, fontSize: 13)),
        const SizedBox(width: 4),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onDelete,
          child: Icon(Icons.close, size: 14, color: context.colors.textSecondary),
        ),
      ]),
    );
  }
}

// ─── _AvatarGalleryModal ──────────────────────────────────────────────────────
class _AvatarGalleryModal extends StatefulWidget {
  final String initialStyle;
  final String initialSeed;
  final void Function(String style, String seed) onApply;
  const _AvatarGalleryModal({required this.initialStyle, required this.initialSeed, required this.onApply});

  @override
  State<_AvatarGalleryModal> createState() => _AvatarGalleryModalState();
}

class _AvatarGalleryModalState extends State<_AvatarGalleryModal> {
  late String _selectedStyle;
  late String _selectedSeed;

  final _styles = ['big-smile','bottts','adventurer','fun-emoji','pixel-art',
      'lorelei','micah','notionists','open-peeps','personas','rings','shapes'];
  final _seeds = ['Felix','Aneka','Milo','Lola','Patches','Nala','Jasper','Garfield',
      'Boots','Tigger','Whiskers','Mittens','Shadow','Oliver','Luna','Max','Bella','Charlie','Lucy','Daisy'];

  @override
  void initState() {
    super.initState();
    _selectedStyle = widget.initialStyle;
    _selectedSeed = widget.initialSeed;
  }

  @override
  Widget build(BuildContext context) {
    final previewUrl = 'https://api.dicebear.com/9.x/$_selectedStyle/png?seed=$_selectedSeed&size=128';
    return Container(
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Container(width: 40, height: 4, decoration: BoxDecoration(color: context.colors.border, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: context.colors.primary, width: 2)),
          child: CircleAvatar(radius: 40, backgroundColor: context.colors.surface,
              backgroundImage: CachedNetworkImageProvider(previewUrl)),
        ),
        const SizedBox(height: 16),
        Align(alignment: Alignment.centerLeft,
            child: const Text('Choose Style', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
        const SizedBox(height: 8),
        SizedBox(height: 160, child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 1.1),
          itemCount: _styles.length,
          itemBuilder: (ctx, idx) {
            final s = _styles[idx];
            final isSel = s == _selectedStyle;
            return GestureDetector(
              onTap: () => setState(() => _selectedStyle = s),
              child: Card(
                color: isSel ? context.colors.primary.withValues(alpha: 0.12) : context.colors.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: isSel ? context.colors.primary : context.colors.border)),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(width: 40, height: 40,
                      child: CachedNetworkImage(imageUrl: 'https://api.dicebear.com/9.x/$s/png?seed=$_selectedSeed&size=64')),
                  const SizedBox(height: 4),
                  Text(s, style: TextStyle(fontSize: 10, color: context.colors.textPrimary,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
                ]),
              ),
            );
          },
        )),
        const SizedBox(height: 16),
        Align(alignment: Alignment.centerLeft,
            child: const Text('Choose Character', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
        const SizedBox(height: 8),
        Expanded(child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, crossAxisSpacing: 6, mainAxisSpacing: 6, childAspectRatio: 1.0),
          itemCount: _seeds.length,
          itemBuilder: (ctx, idx) {
            final seed = _seeds[idx];
            final isSel = seed == _selectedSeed;
            return GestureDetector(
              onTap: () => setState(() => _selectedSeed = seed),
              child: Container(
                decoration: BoxDecoration(
                  color: isSel ? context.colors.primary.withValues(alpha: 0.12) : context.colors.surface,
                  border: Border.all(color: isSel ? context.colors.primary : context.colors.border, width: isSel ? 2 : 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(4),
                child: CachedNetworkImage(
                    imageUrl: 'https://api.dicebear.com/9.x/$_selectedStyle/png?seed=$seed&size=48'),
              ),
            );
          },
        )),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () { widget.onApply(_selectedStyle, _selectedSeed); Navigator.pop(context); },
          style: FilledButton.styleFrom(backgroundColor: context.colors.primary,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          child: const Text('Apply Customization', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ]),
    );
  }
}
