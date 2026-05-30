import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import '../../../../core/auth/auth_notifier.dart';
import '../../../../core/auth/firebase_service.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/api/medusa_client.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';
import '../../../social/providers/social_providers.dart';
import '../../providers/account_providers.dart';

@RoutePage()
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _orderUpdates = true;
  bool _socialActivity = true;
  bool _promotions = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final customerId = authState.maybeWhen(
      authenticated: (id, _, __, ___, ____) => id,
      orElse: () => null,
    );
    final displayName = authState.maybeWhen(
      authenticated: (_, __, name, ___, ____) => name ?? '',
      orElse: () => '',
    );
    final username = authState.maybeWhen(
      authenticated: (_, __, ___, ____, name) => name ?? '',
      orElse: () => '',
    );
    final email = authState.maybeWhen(
      authenticated: (_, mail, __, ___, ____) => mail ?? '',
      orElse: () => '',
    );

    // Watch active social profile details from database
    final profileAsync = customerId != null ? ref.watch(userProfileProvider(customerId)) : null;

    final isPrivate = profileAsync?.valueOrNull?.isPrivate ?? false;
    final avatarStyle = profileAsync?.valueOrNull?.avatarStyle ?? 'big-smile';
    final avatarSeed = profileAsync?.valueOrNull?.avatarSeed ?? 'Felix';
    final bannerUrl = profileAsync?.valueOrNull?.bannerUrl;
    final bio = profileAsync?.valueOrNull?.bio ?? '';

    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(t.settings.title,
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
      body: ListView(
        children: [
          // ─── Profile Details ───────────────────────────────────────
          _SectionHeader(title: t.settings.profile_section),
          _SettingsTile(
            icon: Icons.person_outline,
            label: t.settings.edit_display_name,
            subtitle: displayName.isNotEmpty ? displayName : t.settings.not_set,
            onTap: customerId == null
                ? null
                : () => _showEditDialog(
                      context,
                      title: t.settings.display_name_dialog,
                      hint: t.settings.enter_display_name_hint,
                      initial: displayName,
                      onSave: (val) => _updateProfile(
                          customerId, displayName: val),
                    ),
          ),
          _SettingsTile(
            icon: Icons.edit_note_outlined,
            label: t.settings.edit_bio,
            subtitle: bio.isNotEmpty ? bio : t.settings.bio_subtitle,
            onTap: customerId == null
                ? null
                : () => _showEditDialog(
                      context,
                      title: t.settings.bio_dialog,
                      hint: t.settings.bio_hint,
                      initial: bio,
                      multiline: true,
                      onSave: (val) =>
                          _updateProfile(customerId, bio: val),
                    ),
          ),
          _SettingsTile(
            icon: Icons.alternate_email,
            label: t.settings.username_label,
            subtitle: username.isNotEmpty ? '@$username' : t.settings.username_subtitle,
            onTap: customerId == null
                ? null
                : () => _showEditDialog(
                      context,
                      title: t.settings.username_label,
                      hint: t.settings.username_label,
                      initial: username,
                      onSave: (val) => _updateProfile(
                          customerId, username: val),
                    ),
          ),

          // ─── Profile Customization ───────────────────────────────
          _SectionHeader(title: isAr ? 'تخصيص الحساب' : 'Profile Customization'),
          _SettingsTile(
            icon: Icons.face_retouching_natural_outlined,
            label: isAr ? 'نمط الصورة الرمزية' : 'Avatar Style',
            subtitle: avatarStyle,
            onTap: customerId == null
                ? null
                : () => _showAvatarStylePicker(context, customerId, avatarStyle),
          ),
          _SettingsTile(
            icon: Icons.bubble_chart_outlined,
            label: isAr ? 'بذرة الصورة الرمزية' : 'Avatar Seed',
            subtitle: avatarSeed,
            onTap: customerId == null
                ? null
                : () => _showEditDialog(
                      context,
                      title: isAr ? 'بذرة الصورة الرمزية' : 'Avatar Seed',
                      hint: isAr ? 'أدخل اسمًا أو بذرة لتوليد صورة فريدة' : 'Enter seed to generate custom avatar',
                      initial: avatarSeed,
                      onSave: (val) => _updateProfile(customerId, avatarSeed: val),
                    ),
          ),
          _SettingsTile(
            icon: Icons.photo_camera_outlined,
            label: isAr ? 'تحميل صورة شخصية خاصة' : 'Upload Custom Photo',
            subtitle: isAr ? 'تحميل ملف صورة من المعرض' : 'Upload an image file from gallery',
            onTap: customerId == null ? null : _uploadAvatar,
          ),
          _SettingsTile(
            icon: Icons.wallpaper_outlined,
            label: isAr ? 'تحميل غلاف مخصص' : 'Upload Custom Banner',
            subtitle: bannerUrl != null ? (isAr ? 'تم تعيين الغلاف' : 'Custom banner active') : (isAr ? 'لم يتم التعيين بعد' : 'Not set yet'),
            onTap: customerId == null ? null : _uploadBanner,
          ),

          // ─── Account & Security ──────────────────────────────────
          _SectionHeader(title: isAr ? 'الحساب والأمان' : 'Account & Security'),
          _SettingsTile(
            icon: Icons.email_outlined,
            label: isAr ? 'تغيير البريد الإلكتروني' : 'Change Email',
            subtitle: email.isNotEmpty ? email : t.settings.not_set,
            onTap: customerId == null
                ? null
                : () => _showEditDialog(
                      context,
                      title: isAr ? 'تغيير البريد الإلكتروني' : 'Change Email',
                      hint: isAr ? 'البريد الإلكتروني الجديد' : 'New Email Address',
                      initial: email,
                      onSave: _updateEmail,
                    ),
          ),
          _SettingsTile(
            icon: Icons.lock_reset_outlined,
            label: isAr ? 'إعادة تعيين كلمة المرور' : 'Reset Password',
            subtitle: isAr ? 'إرسال رابط استعادة كلمة المرور' : 'Send password reset link',
            onTap: email.isEmpty ? null : () => _sendPasswordReset(email),
          ),

          // ─── Privacy Settings ─────────────────────────────────────
          _SectionHeader(title: isAr ? 'إعدادات الخصوصية' : 'Privacy Settings'),
          _SettingsSwitch(
            icon: Icons.privacy_tip_outlined,
            label: isAr ? 'حساب خاص' : 'Private Account',
            subtitle: isAr ? 'فقط المتابعين المعتمدين يمكنهم رؤية منشوراتك' : 'Only approved followers can view your posts',
            value: isPrivate,
            onChanged: customerId == null
                ? null
                : (v) => _updateProfile(customerId, isPrivate: v),
          ),

          // ── Appearance ─────────────────────────────────────────────
          _SectionHeader(title: 'Appearance'),
          _ThemeSelector(),

          // ── Notifications ──────────────────────────────────────────────
          _SectionHeader(title: t.settings.notifications_section),
          _SettingsSwitch(
            icon: Icons.notifications_outlined,
            label: t.settings.push_notifications,
            subtitle: t.settings.push_notifications_subtitle,
            value: _notificationsEnabled,
            onChanged: (v) => setState(() => _notificationsEnabled = v),
          ),
          _SettingsSwitch(
            icon: Icons.shopping_bag_outlined,
            label: t.settings.order_updates,
            subtitle: t.settings.order_updates_subtitle,
            value: _orderUpdates,
            onChanged: _notificationsEnabled
                ? (v) => setState(() => _orderUpdates = v)
                : null,
          ),
          _SettingsSwitch(
            icon: Icons.people_outlined,
            label: t.settings.social_activity,
            subtitle: t.settings.social_activity_subtitle,
            value: _socialActivity,
            onChanged: _notificationsEnabled
                ? (v) => setState(() => _socialActivity = v)
                : null,
          ),
          _SettingsSwitch(
            icon: Icons.local_offer_outlined,
            label: t.settings.promotions,
            subtitle: t.settings.promotions_subtitle,
            value: _promotions,
            onChanged: _notificationsEnabled
                ? (v) => setState(() => _promotions = v)
                : null,
          ),

          _SectionHeader(title: t.settings.about_section),
          _SettingsTile(
            icon: Icons.info_outline,
            label: t.settings.app_version,
            subtitle: '1.0.0 (build 1)',
            onTap: null,
            trailing: const SizedBox.shrink(),
          ),
          _SettingsTile(
            icon: Icons.description_outlined,
            label: t.settings.terms_label,
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            label: t.settings.privacy_label,
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.support_agent_outlined,
            label: t.settings.contact_support,
            onTap: () {},
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _updateProfile(
    String customerId, {
    String? displayName,
    String? bio,
    String? username,
    String? avatarStyle,
    String? avatarSeed,
    String? avatarUrl,
    String? bannerUrl,
    bool? isPrivate,
  }) async {
    try {
      await ref.read(accountRepositoryProvider).updateProfile(
            customerId,
            displayName: displayName,
            bio: bio,
            username: username,
            avatarStyle: avatarStyle,
            avatarSeed: avatarSeed,
            avatarUrl: avatarUrl,
            bannerUrl: bannerUrl,
            isPrivate: isPrivate,
          );
      ref.invalidate(userProfileProvider(customerId));
      await ref.read(authNotifierProvider.notifier).refreshProfile();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.settings.saved_ok),
          backgroundColor: context.colors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.settings.save_failed(error: e.toString())),
          backgroundColor: context.colors.error,
        ),
      );
    }
  }

  Future<void> _updateEmail(String newEmail) async {
    try {
      final user = FirebaseService.currentUser;
      if (user != null) {
        await user.updateEmail(newEmail);
      }
      // If Firebase update succeeds, update in Medusa!
      await MedusaClient.instance.patch('/store/customers/me', data: {'email': newEmail});
      await ref.read(authNotifierProvider.notifier).refreshProfile();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.settings.saved_ok), backgroundColor: context.colors.success),
      );
    } catch (e) {
      if (!mounted) return;
      String errMsg = e.toString();
      if (errMsg.contains('requires-recent-login')) {
        errMsg = Localizations.localeOf(context).languageCode == 'ar'
            ? 'هذه عملية حساسة. يرجى تسجيل الخروج وإعادة تسجيل الدخول لتغيير بريدك الإلكتروني.'
            : 'This is a sensitive operation. Please sign out and sign back in to change your email.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errMsg), backgroundColor: context.colors.error),
      );
    }
  }

  Future<void> _sendPasswordReset(String email) async {
    if (email.isEmpty) return;
    try {
      await FirebaseService.sendPasswordResetEmail(email);
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: context.colors.surface,
          title: Text(
            Localizations.localeOf(context).languageCode == 'ar' ? 'إعادة تعيين كلمة المرور' : 'Password Reset',
            style: TextStyle(color: context.colors.textPrimary),
          ),
          content: Text(
            Localizations.localeOf(context).languageCode == 'ar'
                ? 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني.'
                : 'A password reset link has been sent to your email address.',
            style: TextStyle(color: context.colors.textSecondary),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              style: FilledButton.styleFrom(backgroundColor: context.colors.primary),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: context.colors.error),
      );
    }
  }

  Future<void> _uploadAvatar() async {
    final authState = ref.read(authNotifierProvider);
    final customerId = authState.maybeWhen(
      authenticated: (id, _, __, ___, ____) => id,
      orElse: () => null,
    );
    if (customerId == null) return;

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (picked == null) return;

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Localizations.localeOf(context).languageCode == 'ar' ? 'جاري رفع الصورة...' : 'Uploading avatar...'),
          duration: const Duration(seconds: 1),
        ),
      );

      final formData = FormData();
      formData.files.add(MapEntry(
        'files',
        await MultipartFile.fromFile(picked.path, filename: picked.path.split('/').last),
      ));

      final uploadRes = await MedusaClient.instance.post(
        '/store/social/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      final urls = (uploadRes.data['urls'] as List<dynamic>?)?.map((u) => u.toString()).toList() ?? [];
      if (urls.isEmpty) throw Exception('Upload failed');

      await _updateProfile(customerId, avatarUrl: urls.first);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload avatar: $e'), backgroundColor: context.colors.error),
      );
    }
  }

  Future<void> _uploadBanner() async {
    final authState = ref.read(authNotifierProvider);
    final customerId = authState.maybeWhen(
      authenticated: (id, _, __, ___, ____) => id,
      orElse: () => null,
    );
    if (customerId == null) return;

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (picked == null) return;

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Localizations.localeOf(context).languageCode == 'ar' ? 'جاري رفع الغلاف...' : 'Uploading banner...'),
          duration: const Duration(seconds: 1),
        ),
      );

      final formData = FormData();
      formData.files.add(MapEntry(
        'files',
        await MultipartFile.fromFile(picked.path, filename: picked.path.split('/').last),
      ));

      final uploadRes = await MedusaClient.instance.post(
        '/store/social/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      final urls = (uploadRes.data['urls'] as List<dynamic>?)?.map((u) => u.toString()).toList() ?? [];
      if (urls.isEmpty) throw Exception('Upload failed');

      await _updateProfile(customerId, bannerUrl: urls.first);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload banner: $e'), backgroundColor: context.colors.error),
      );
    }
  }

  void _showAvatarStylePicker(BuildContext context, String customerId, String currentStyle) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final styles = ['big-smile', 'bottts', 'adventurer', 'fun-emoji', 'pixel-art', 'lorelei'];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: Text(isAr ? 'اختر نمط الصورة الرمزية' : 'Select Avatar Style',
            style: TextStyle(color: context.colors.textPrimary)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: styles.length,
            separatorBuilder: (_, __) => Divider(color: context.colors.border, height: 1),
            itemBuilder: (c, idx) {
              final s = styles[idx];
              final isSel = s == currentStyle;
              return ListTile(
                title: Text(s, style: TextStyle(color: isSel ? context.colors.primary : context.colors.textPrimary, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
                trailing: isSel ? Icon(Icons.check, color: context.colors.primary) : null,
                onTap: () {
                  Navigator.pop(ctx);
                  _updateProfile(customerId, avatarStyle: s);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context, {
    required String title,
    required String hint,
    String initial = '',
    bool multiline = false,
    required void Function(String) onSave,
  }) {
    final controller = TextEditingController(text: initial);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: Text(title,
            style: TextStyle(color: context.colors.textPrimary)),
        content: TextField(
          controller: controller,
          maxLines: multiline ? 4 : 1,
          style: TextStyle(color: context.colors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: context.colors.textMuted),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: context.colors.border)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: context.colors.primary)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.settings.cancel,
                style: TextStyle(color: context.colors.textMuted)),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              final val = controller.text.trim();
              if (val.isNotEmpty) onSave(val);
            },
            style:
                FilledButton.styleFrom(backgroundColor: context.colors.primary),
            child: Text(t.settings.save),
          ),
        ],
      ),
    );
  }
}

// ─── Theme Selector ────────────────────────────────────────────────────────

class _ThemeSelector extends ConsumerWidget {
  const _ThemeSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(themeProvider);

    final options = [
      (AppThemeMode.dark,   Icons.dark_mode_outlined,        'Dark'),
      (AppThemeMode.light,  Icons.light_mode_outlined,       'Light'),
      (AppThemeMode.system, Icons.brightness_auto_outlined,  'Follow System'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          children: options.asMap().entries.map((entry) {
            final idx  = entry.key;
            final mode = entry.value.$1;
            final icon = entry.value.$2;
            final label = entry.value.$3;
            final selected = current == mode;

            return Column(
              children: [
                ListTile(
                  leading: Icon(
                    icon,
                    color: selected ? context.colors.primary : context.colors.textSecondary,
                    size: 22,
                  ),
                  title: Text(
                    label,
                    style: TextStyle(
                      color: selected ? context.colors.primary : context.colors.textPrimary,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  trailing: selected
                      ? Icon(Icons.check_circle, color: context.colors.primary, size: 20)
                      : Icon(Icons.radio_button_unchecked, color: context.colors.border, size: 20),
                  onTap: () => ref.read(themeProvider.notifier).setMode(mode),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top:    Radius.circular(idx == 0 ? 12 : 0),
                      bottom: Radius.circular(idx == options.length - 1 ? 12 : 0),
                    ),
                  ),
                ),
                if (idx < options.length - 1)
                  Divider(height: 1, color: context.colors.border, indent: 16, endIndent: 16),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
            color: context.colors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: context.colors.primary, size: 22),
      title: Text(label,
          style: TextStyle(color: context.colors.textPrimary, fontSize: 14)),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: TextStyle(color: context.colors.textMuted, fontSize: 12))
          : null,
      trailing: trailing ??
          Icon(Icons.chevron_right,
              color: context.colors.textSecondary, size: 18),
      onTap: onTap,
      enabled: onTap != null,
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _SettingsSwitch({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon,
          color: onChanged != null
              ? context.colors.primary
              : context.colors.textMuted,
          size: 22),
      title: Text(label,
          style: TextStyle(
              color: onChanged != null
                  ? context.colors.textPrimary
                  : context.colors.textMuted,
              fontSize: 14)),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: TextStyle(
                  color: context.colors.textMuted, fontSize: 12))
          : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: context.colors.primary,
        inactiveTrackColor: context.colors.border,
      ),
    );
  }
}
