import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';
import '../../../social/data/models/social_models.dart';
import '../../../social/providers/social_providers.dart';
import '../../../../router/app_router.dart';

@RoutePage()
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Mark all notifications as read when screen opens → resets bell badge to 0
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await ref.read(socialRepositoryProvider).markAllNotificationsRead();
        ref.invalidate(notificationsProvider);
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.notifications.title, style: TextStyle(color: context.colors.textPrimary)),
        backgroundColor: context.colors.surface,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
      ),
      backgroundColor: context.colors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(notificationsProvider);
        },
        child: notificationsAsync.when(
          loading: () => ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Shimmer.fromColors(
                baseColor: context.colors.surfaceVariant,
                highlightColor: context.colors.border,
                child: Container(
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          error: (err, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: context.colors.error),
                SizedBox(height: 16),
                Text(t.notifications.failed_load, style: TextStyle(color: context.colors.textPrimary)),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => ref.invalidate(notificationsProvider),
                  child: Text(t.notifications.retry),
                ),
              ],
            ),
          ),
          data: (notifications) {
            if (notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_none, size: 64, color: context.colors.textMuted),
                    SizedBox(height: 16),
                    Text(t.notifications.no_notifications, style: TextStyle(color: context.colors.textMuted, fontSize: 16)),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return NotificationTile(notification: notifications[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

void _navigateNotification(BuildContext context, NotificationModel notification) {
  final postId = notification.postId;
  final slug = notification.communitySlug ?? notification.communityId;
  final senderId = notification.senderId;

  switch (notification.type) {
    case 'COMMENT_ON_POST':
    case 'REPLY_TO_COMMENT':
    case 'UPVOTE_POST':
    case 'UPVOTE_COMMENT':
      if (postId != null && slug != null) {
        context.router.navigate(PostDetailRoute(community: slug, postId: postId));
      }
      break;
    case 'NEW_FOLLOWER':
    case 'FOLLOW_REQUEST':
    case 'FOLLOW_ACCEPTED':
    case 'JOIN_REJECTED':
    case 'NEW_MEMBER':
      if (senderId != null) {
        context.router.navigate(UserProfileRoute(userId: senderId));
      }
      break;
    case 'ORDER_UPDATE':
    case 'NEW_ORDER':
    case 'DISPUTE_OPENED':
      context.router.navigate(const OrdersRoute());
      break;
    case 'PAYOUT_PROCESSED':
      context.router.navigate(const VendorDashboardRoute());
      break;
    case 'NEW_PRODUCT':
      // Navigate to vendor store if we have senderId (vendor's customerId)
      // For now navigate to store browse — in future could deep-link to product
      if (senderId != null) {
        context.router.navigate(const BrowseStoresRoute());
      }
      break;
    default:
      break;
  }
}

class NotificationTile extends ConsumerWidget {
  final NotificationModel notification;

  const NotificationTile({super.key, required this.notification});

  String _getTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 365) return '${diff.inDays ~/ 365}y';
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'now';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case 'ORDER_UPDATE':
      case 'NEW_ORDER':
        iconData = Icons.shopping_bag_outlined;
        iconColor = context.colors.primary;
        break;
      case 'PAYOUT_PROCESSED':
        iconData = Icons.account_balance_wallet_outlined;
        iconColor = context.colors.success;
        break;
      case 'NEW_FOLLOWER':
        iconData = Icons.person_add_outlined;
        iconColor = context.colors.primary;
        break;
      case 'NEW_MEMBER':
        iconData = Icons.group_outlined;
        iconColor = context.colors.success;
        break;
      case 'JOIN_REJECTED':
        iconData = Icons.group_off_outlined;
        iconColor = context.colors.error;
        break;
      case 'ESCROW_DISPUTED':
        iconData = Icons.gavel_outlined;
        iconColor = context.colors.warning;
        break;
      case 'NEW_PRODUCT':
        iconData = Icons.new_releases_outlined;
        iconColor = context.colors.primary;
        break;
      case 'NEW_REVIEW':
        iconData = Icons.star_outline;
        iconColor = Colors.amber;
        break;
      case 'NEW_QA':
        iconData = Icons.help_outline;
        iconColor = context.colors.primary;
        break;
      default:
        iconData = Icons.notifications_outlined;
        iconColor = context.colors.textMuted;
    }

    return InkWell(
      onTap: () async {
        // Mark as read
        if (!notification.isRead) {
          try {
            await ref.read(socialRepositoryProvider).markNotificationRead(notification.id);
            ref.invalidate(notificationsProvider);
          } catch (_) {}
        }
        // Navigate to relevant content based on notification type
        _navigateNotification(context, notification);
      },
      child: Container(
        color: notification.isRead ? context.colors.surface : context.colors.primary.withOpacity(0.05),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: iconColor, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.message,
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 14,
                      fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _getTimeAgo(notification.createdAt),
                    style: TextStyle(color: context.colors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (!notification.isRead) ...[
              SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
