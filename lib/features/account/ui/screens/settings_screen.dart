import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waslaq_app/i18n/strings.g.dart';
import 'package:waslaq_app/shared/theme/app_colors.dart';
import '../../../../router/app_router.dart';
import '../../../vendor/providers/vendor_providers.dart';

@RoutePage()
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVendor = ref.watch(isVendorProvider).valueOrNull ?? false;
    final s = t.settings;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(s.title, style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold)),
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
          _SettingsGroup(children: [
            _SettingsHubTile(icon: Icons.person_outline, label: s.hubProfile, subtitle: s.hubProfileSub, onTap: () => context.router.push(const ProfileSettingsRoute())),
            _SettingsHubTile(icon: Icons.security_outlined, label: s.hubAccount, subtitle: s.hubAccountSub, onTap: () => context.router.push(const AccountSettingsRoute())),
            _SettingsHubTile(icon: Icons.location_on_outlined, label: s.hubAddress, subtitle: s.hubAddressSub, onTap: () => context.router.push(const AddressBookRoute())),
            _SettingsHubTile(icon: Icons.account_balance_outlined, label: s.hubRefund, subtitle: s.hubRefundSub, onTap: () => context.router.push(const RefundDetailsRoute())),
          ]),
          _SettingsGroup(children: [
            _SettingsHubTile(icon: Icons.privacy_tip_outlined, label: s.hubPrivacy, subtitle: s.hubPrivacySub, onTap: () => context.router.push(const PrivacySettingsRoute())),
            _SettingsHubTile(icon: Icons.notifications_outlined, label: s.hubNotifications, subtitle: s.hubNotificationsSub, onTap: () => context.router.push(const NotificationSettingsRoute())),
            _SettingsHubTile(icon: Icons.tune_outlined, label: s.hubContent, subtitle: s.hubContentSub, onTap: () => context.router.push(const ContentSettingsRoute())),
          ]),
          _SettingsGroup(children: [
            _SettingsHubTile(icon: Icons.palette_outlined, label: s.hubAppearance, subtitle: s.hubAppearanceSub, onTap: () => context.router.push(const AppearanceSettingsRoute())),
            _SettingsHubTile(icon: Icons.storage_outlined, label: s.hubStorage, subtitle: s.hubStorageSub, onTap: () => context.router.push(const StorageSettingsRoute())),
          ]),
          if (isVendor) _SettingsGroup(children: [
            _SettingsHubTile(icon: Icons.store_outlined, label: s.hubVendor, subtitle: s.hubVendorSub, onTap: () => context.router.push(const VendorSettingsRoute())),
          ]),
          _SettingsGroup(children: [
            _SettingsHubTile(icon: Icons.apps_outlined, label: s.hubApp, subtitle: s.hubAppSub, onTap: () => context.router.push(const AppInfoSettingsRoute())),
            _SettingsHubTile(icon: Icons.help_outline, label: s.hubSupport, subtitle: s.hubSupportSub, onTap: () => context.router.push(const SupportSettingsRoute())),
          ]),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          children: children.asMap().entries.map((e) {
            final isLast = e.key == children.length - 1;
            return Column(children: [
              e.value,
              if (!isLast) Divider(height: 1, color: context.colors.border, indent: 52),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}

class _SettingsHubTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsHubTile({required this.icon, required this.label, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(color: context.colors.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: context.colors.primary, size: 20),
      ),
      title: Text(label, style: TextStyle(color: context.colors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(color: context.colors.textMuted, fontSize: 12)),
      trailing: Icon(Icons.chevron_right, color: context.colors.textSecondary, size: 18),
      onTap: onTap,
    );
  }
}
