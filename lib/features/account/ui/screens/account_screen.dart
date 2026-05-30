import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../vendor/providers/vendor_providers.dart';
import '../../../../core/auth/auth_notifier.dart';
import '../../../../router/app_router.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

@RoutePage()
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return authState.maybeWhen(
      authenticated: (customerId, email, displayName, avatarUrl, username) =>
          _AuthenticatedView(
            customerId: customerId,
            email: email,
            displayName: displayName,
            avatarUrl: avatarUrl,
          ),
      orElse: () => const _UnauthenticatedView(),
    );
  }
}

class _AuthenticatedView extends ConsumerWidget {
  final String customerId;
  final String email;
  final String? displayName;
  final String? avatarUrl;

  const _AuthenticatedView({
    required this.customerId,
    required this.email,
    required this.displayName,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = (displayName != null && displayName!.isNotEmpty)
        ? displayName!
        : email.split('@').first;

    final vendorCheck = ref.watch(isVendorProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        title: Text(t.account.title,
            style: TextStyle(color: context.colors.textPrimary)),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: context.colors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: context.colors.primary,
                  backgroundImage: avatarUrl != null
                      ? CachedNetworkImageProvider(avatarUrl!)
                      : null,
                  child: avatarUrl == null
                      ? Text(
                          name.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: TextStyle(
                              color: context.colors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      Text(email,
                          style: TextStyle(
                              color: context.colors.textSecondary, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _AccountTile(
            icon: Icons.shopping_bag_outlined,
            label: t.account.my_orders_label,
            onTap: () => context.router.push(const OrdersRoute()),
          ),
          _AccountTile(
            icon: Icons.favorite_border,
            label: t.account.saved_items_label,
            onTap: () => context.router.push(const SavedItemsRoute()),
          ),

          vendorCheck.when(
            data: (isVendor) {
              if (isVendor) {
                return _AccountTile(
                  icon: Icons.store_outlined,
                  label: t.account.vendor_dashboard_label,
                  onTap: () =>
                      context.router.push(const VendorDashboardRoute()),
                );
              } else {
                return _AccountTile(
                  icon: Icons.store_outlined,
                  label: t.account.become_vendor_label,
                  onTap: () =>
                      context.router.push(const BecomeVendorRoute()),
                );
              }
            },
            loading: () => Shimmer.fromColors(
              baseColor: Colors.grey.shade900,
              highlightColor: Colors.grey.shade800,
              child: ListTile(
                leading:
                    const Icon(Icons.store_outlined, color: Colors.white),
                title: Container(
                    height: 16, width: double.infinity, color: Colors.white),
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),

          _AccountTile(
            icon: Icons.message_outlined,
            label: t.account.messages_label,
            onTap: () => context.router.push(const MessagesRoute()),
          ),
          _AccountTile(
            icon: Icons.notifications_outlined,
            label: t.account.notifications_label,
            onTap: () => context.router.push(const NotificationsRoute()),
          ),
          _AccountTile(
            icon: Icons.settings_outlined,
            label: t.account.settings_label,
            onTap: () => context.router.push(const SettingsRoute()),
          ),
          SizedBox(height: 16),
          const Divider(color: Colors.grey),
          SizedBox(height: 8),
          _AccountTile(
            icon: Icons.privacy_tip_outlined,
            label: t.account.privacy_policy_label,
            onTap: () => context.router.push(const PrivacyPolicyRoute()),
          ),
          _AccountTile(
            icon: Icons.description_outlined,
            label: t.account.terms_label,
            onTap: () => context.router.push(const TermsRoute()),
          ),
          SizedBox(height: 8),
          _AccountTile(
            icon: Icons.logout,
            label: t.account.sign_out_label,
            iconColor: context.colors.error,
            labelColor: context.colors.error,
            onTap: () async =>
                ref.read(authNotifierProvider.notifier).signOut(),
          ),
        ],
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;

  const _AccountTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? context.colors.primary),
      title: Text(label,
          style: TextStyle(
              color: labelColor ?? context.colors.textPrimary, fontSize: 15)),
      trailing: Icon(Icons.chevron_right, color: context.colors.textSecondary),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    );
  }
}

class _UnauthenticatedView extends StatelessWidget {
  const _UnauthenticatedView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_outline,
                  size: 80, color: context.colors.primary),
              SizedBox(height: 24),
              Text(t.account.sign_in_welcome,
                  style: TextStyle(
                      color: context.colors.primary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                t.account.sign_in_desc,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: context.colors.textSecondary, fontSize: 14, height: 1.5),
              ),
              SizedBox(height: 36),
              FilledButton(
                onPressed: () => context.router.push(const SignInRoute()),
                style: FilledButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(t.account.sign_in_btn,
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.router.push(const SignUpRoute()),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  side: BorderSide(color: context.colors.primary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(t.account.create_account_btn,
                    style: TextStyle(fontSize: 16, color: context.colors.primary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
