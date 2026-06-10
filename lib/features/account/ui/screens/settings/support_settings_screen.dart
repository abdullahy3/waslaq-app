import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waslaq_app/shared/theme/app_colors.dart';
import 'package:waslaq_app/router/app_router.dart';
import 'package:waslaq_app/features/account/providers/account_providers.dart';

@RoutePage()
class SupportSettingsScreen extends ConsumerWidget {
  const SupportSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);
    final escrowCount = ordersAsync.valueOrNull
            ?.where((o) => o.status != 'completed' && o.status != 'canceled')
            .length ??
        0;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: const Text('Support & Escrow', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ─── GET HELP SECTION ───
          _buildSectionHeader(context, 'Get Help'),
          Card(
            color: context.colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: context.colors.border),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.support_agent_outlined, color: context.colors.primary),
                  title: const Text('Contact Support', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  subtitle: const Text('Talk to a WaslaQ support agent', style: TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.router.push(const ContactRoute()),
                ),
                Divider(height: 1, color: context.colors.border),
                ListTile(
                  leading: Icon(Icons.bug_report_outlined, color: context.colors.primary),
                  title: const Text('Report a Bug', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  subtitle: const Text('Help us improve the app by reporting issues', style: TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.router.push(const FeedbackRoute()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ─── LEGAL SECTION ───
          _buildSectionHeader(context, 'Legal'),
          Card(
            color: context.colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: context.colors.border),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.gavel_outlined, color: context.colors.primary),
                  title: const Text('Terms of Use', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.router.push(const TermsRoute()),
                ),
                Divider(height: 1, color: context.colors.border),
                ListTile(
                  leading: Icon(Icons.privacy_tip_outlined, color: context.colors.primary),
                  title: const Text('Privacy Policy', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.router.push(const PrivacyPolicyRoute()),
                ),
                Divider(height: 1, color: context.colors.border),
                ListTile(
                  leading: Icon(Icons.assignment_return_outlined, color: context.colors.primary),
                  title: const Text('Refund Policy', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.router.push(const RefundPolicyRoute()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ─── ESCROW & DISPUTES SECTION ───
          _buildSectionHeader(context, 'Escrow & Disputes'),
          Card(
            color: context.colors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text('🔐 ', style: TextStyle(fontSize: 20)),
                      Text('WaslaQ Escrow Protection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your money is protected by WaslaQ Escrow. Funds are held securely until you confirm delivery or 24 hours pass. If anything goes wrong, open a dispute within 4 days of delivery.',
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: context.colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: context.colors.border),
            ),
            child: ListTile(
              leading: Icon(Icons.assignment_late_outlined, color: context.colors.primary),
              title: const Text('My Disputes', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              subtitle: const Text('Manage your active purchase disputes', style: TextStyle(fontSize: 11)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (escrowCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: context.colors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        '$escrowCount',
                        style: TextStyle(color: context.colors.primary, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              onTap: () => context.router.push(const OrdersRoute()),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(color: context.colors.textMuted, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.1),
      ),
    );
  }
}
