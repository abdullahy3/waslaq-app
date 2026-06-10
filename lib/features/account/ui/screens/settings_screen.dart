import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waslaq_app/shared/theme/app_colors.dart';
import '../../../../router/app_router.dart';
import '../../../vendor/providers/vendor_providers.dart';

@RoutePage()
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVendor = ref.watch(isVendorProvider).valueOrNull ?? false;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
        bottom: PreferredSize(preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: context.colors.border)),
      ),
      body: ListView(
        children: [
          _SettingsGroup(children: [
            _SettingsHubTile(icon: Icons.person_outline, label: 'Profile', subtitle: 'Avatar, bio, social links', onTap: () => context.router.push(const ProfileSettingsRoute())),
            _SettingsHubTile(icon: Icons.security_outlined, label: 'Account & Security', subtitle: 'Email, password, biometric lock', onTap: () => context.router.push(const AccountSettingsRoute())),
            _SettingsHubTile(icon: Icons.location_on_outlined, label: 'Address Book', subtitle: 'Palestine delivery addresses', onTap: () => context.router.push(const AddressBookRoute())),
            _SettingsHubTile(icon: Icons.account_balance_outlined, label: 'Refund Details', subtitle: 'Bank details for dispute refunds', onTap: () => context.router.push(const RefundDetailsRoute())),
          ]),
          _SettingsGroup(children: [
            _SettingsHubTile(icon: Icons.privacy_tip_outlined, label: 'Privacy & Safety', subtitle: 'Visibility, blocked users, follow requests', onTap: () => context.router.push(const PrivacySettingsRoute())),
            _SettingsHubTile(icon: Icons.notifications_outlined, label: 'Notifications', subtitle: 'Push, orders, social alerts', onTap: () => context.router.push(const NotificationSettingsRoute())),
            _SettingsHubTile(icon: Icons.tune_outlined, label: 'Content & Feed', subtitle: 'Language filter, muted words', onTap: () => context.router.push(const ContentSettingsRoute())),
          ]),
          _SettingsGroup(children: [
            _SettingsHubTile(icon: Icons.palette_outlined, label: 'Appearance & Language', subtitle: 'Theme, language, font, accessibility', onTap: () => context.router.push(const AppearanceSettingsRoute())),
            _SettingsHubTile(icon: Icons.storage_outlined, label: 'Storage & Performance', subtitle: 'Cache, data usage', onTap: () => context.router.push(const StorageSettingsRoute())),
          ]),
          if (isVendor) _SettingsGroup(children: [
            _SettingsHubTile(icon: Icons.store_outlined, label: 'Vendor Settings', subtitle: 'Vacation mode, delivery zones', onTap: () => context.router.push(const VendorSettingsRoute())),
          ]),
          _SettingsGroup(children: [
            _SettingsHubTile(icon: Icons.apps_outlined, label: 'App', subtitle: 'Share, rate, permissions, version', onTap: () => context.router.push(const AppInfoSettingsRoute())),
            _SettingsHubTile(icon: Icons.help_outline, label: 'Support & Escrow', subtitle: 'Help, disputes, legal', onTap: () => context.router.push(const SupportSettingsRoute())),
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
