import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waslaq_app/i18n/strings.g.dart';
import 'package:share_plus/share_plus.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:waslaq_app/shared/theme/app_colors.dart';

@RoutePage()
class AppInfoSettingsScreen extends ConsumerStatefulWidget {
  const AppInfoSettingsScreen({super.key});

  @override
  ConsumerState<AppInfoSettingsScreen> createState() => _AppInfoSettingsScreenState();
}

class _AppInfoSettingsScreenState extends ConsumerState<AppInfoSettingsScreen> {
  String _versionInfo = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        _versionInfo = 'Version ${info.version} (build ${info.buildNumber})';
      });
    } catch (_) {
      setState(() => _versionInfo = 'Version 1.0.0 (build 1)');
    }
  }

  Future<void> _shareApp() async {
    await Share.share(
      'Download WaslaQ, the Palestinian social marketplace!\nhttps://play.google.com/store/apps/details?id=com.waslaq.app',
    );
  }

  Future<void> _rateApp() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    } else {
      await inAppReview.openStoreListing();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(t.settings.appScreenTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Logo or Banner
          const SizedBox(height: 24),
          const Center(
            child: Column(
              children: [
                Text('واصلك', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: 2)),
                Text('WaslaQ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 48),

          // ─── SHARE & RATE SECTION ───
          _buildSectionHeader(t.settings.appShareSection),
          Card(
            color: context.colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: context.colors.border),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.share_outlined, color: context.colors.primary),
                  title: const Text('Share WaslaQ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  subtitle: const Text('Tell your friends about the Palestinian marketplace', style: TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _shareApp,
                ),
                Divider(height: 1, color: context.colors.border),
                ListTile(
                  leading: Icon(Icons.star_outline, color: context.colors.primary),
                  title: const Text('Rate WaslaQ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  subtitle: const Text('Leave a review on the store', style: TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _rateApp,
                ),
                Divider(height: 1, color: context.colors.border),
                ListTile(
                  leading: Icon(Icons.settings_phone_outlined, color: context.colors.primary),
                  title: const Text('App Permissions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  subtitle: const Text('Manage storage, camera, and notification permissions', style: TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: openAppSettings,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ─── ABOUT SECTION ───
          _buildSectionHeader(t.settings.appAboutSection),
          Card(
            color: context.colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: context.colors.border),
            ),
            child: ListTile(
              leading: Icon(Icons.info_outline, color: context.colors.primary),
              title: const Text('App Version', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              subtitle: Text(_versionInfo, style: const TextStyle(fontSize: 11)),
              trailing: const SizedBox.shrink(),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(color: context.colors.textMuted, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.1),
      ),
    );
  }
}
