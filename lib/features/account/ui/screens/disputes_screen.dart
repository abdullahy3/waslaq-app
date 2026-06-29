// lib/features/account/ui/screens/disputes_screen.dart

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../data/models/dispute_model.dart';
import '../../providers/dispute_providers.dart';
import 'dispute_detail_screen.dart';

@RoutePage()
class DisputesScreen extends ConsumerWidget {
  const DisputesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disputesAsync = ref.watch(myDisputesProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text('My Disputes',
            style: TextStyle(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: context.colors.border),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(myDisputesProvider),
        child: disputesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: context.colors.error),
                const SizedBox(height: 12),
                Text('Failed to load disputes',
                    style: TextStyle(color: context.colors.textPrimary, fontSize: 16)),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => ref.invalidate(myDisputesProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (disputes) {
            if (disputes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.gavel_outlined, size: 72, color: context.colors.border),
                    const SizedBox(height: 16),
                    Text('No disputes yet',
                        style: TextStyle(
                            color: context.colors.textSecondary, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('You can open a dispute from your order details.',
                        style: TextStyle(
                            color: context.colors.textMuted, fontSize: 13),
                        textAlign: TextAlign.center),
                  ],
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: disputes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) => _DisputeTile(
                dispute: disputes[i],
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => DisputeDetailScreen(dispute: disputes[i]),
                )),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Dispute Tile ────────────────────────────────────────────────────────────

class _DisputeTile extends StatelessWidget {
  final DisputeModel dispute;
  final VoidCallback onTap;
  const _DisputeTile({required this.dispute, required this.onTap});

  Color _statusColor(BuildContext context) {
    switch (dispute.status) {
      case 'open':
        return context.colors.warning;
      case 'vendor_responded':
        return Colors.blue;
      case 'admin_review':
        return Colors.purple;
      case 'resolved_refund':
        return context.colors.success;
      case 'resolved_release':
      case 'resolved_split':
        return Colors.grey;
      default:
        return context.colors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: dispute.thumbnail != null
                  ? CachedNetworkImage(
                      imageUrl: dispute.thumbnail!,
                      width: 56, height: 56, fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => _placeholder(context),
                    )
                  : _placeholder(context),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dispute.productTitle ?? 'Order item',
                      style: TextStyle(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.w600, fontSize: 14),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(dispute.typeLabel,
                      style: TextStyle(
                          color: context.colors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(dispute.statusLabel,
                            style: TextStyle(
                                color: statusColor,
                                fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: context.colors.textMuted, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      width: 56, height: 56,
      color: context.colors.surfaceVariant,
      child: Icon(Icons.image_outlined, color: context.colors.textMuted, size: 24),
    );
  }
}
