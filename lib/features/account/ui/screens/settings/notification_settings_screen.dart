import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:waslaq_app/i18n/strings.g.dart';
import 'package:waslaq_app/shared/theme/app_colors.dart';
import 'package:waslaq_app/features/vendor/providers/vendor_providers.dart';
import 'package:waslaq_app/features/account/data/models/social_settings_model.dart';
import 'package:waslaq_app/features/account/providers/account_providers.dart';
import 'package:waslaq_app/core/error/error_localizer.dart';

@RoutePage()
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen> {
  PermissionStatus _notificationStatus = PermissionStatus.denied;
  bool _isLoadingStatus = true;
  bool _isLoadingSettings = true;

  UserSocialSettingsModel? _socialSettings;

  bool _newFollowers = true;
  bool _commentsOnPosts = true;
  bool _upvotesOnPosts = true;
  bool _mentions = true;
  bool _followRequests = true;
  String _communityNotifications = 'All';
  bool _promotions = false;

  bool _orderConfirmed = true;
  bool _orderShipped = true;
  bool _orderDelivered = true;
  bool _refundProcessed = true;

  @override
  void initState() {
    super.initState();
    _checkPermissionStatus();
    _loadSettings();
  }

  Future<void> _checkPermissionStatus() async {
    try {
      final status = await Permission.notification.status;
      setState(() {
        _notificationStatus = status;
        _isLoadingStatus = false;
      });
    } catch (_) {
      setState(() => _isLoadingStatus = false);
    }
  }

  Future<void> _loadSettings() async {
    try {
      final map = await ref.read(accountRepositoryProvider).getSocialSettings();
      setState(() {
        _socialSettings = UserSocialSettingsModel.fromJson(map);
        _isLoadingSettings = false;
      });
    } catch (_) {
      setState(() => _isLoadingSettings = false);
    }
  }

  Future<void> _updateSocialSettings(UserSocialSettingsModel newSettings) async {
    try {
      setState(() => _socialSettings = newSettings);
      await ref.read(accountRepositoryProvider).updateSocialSettings(newSettings.toJson());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizeError(e)), backgroundColor: context.colors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isVendor = ref.watch(isVendorProvider).valueOrNull ?? false;
    final isGranted = _notificationStatus == PermissionStatus.granted;
    final s = t.settings;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(s.hubNotifications, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
      ),
      body: _isLoadingSettings
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ─── PUSH NOTIFICATION HEADER ───
                Card(
                  color: context.colors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: context.colors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.notifications_active_outlined, color: context.colors.primary, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.pushNotifications, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              const SizedBox(height: 2),
                              Text(
                                isGranted ? s.notifPushEnabled : s.notifPushDisabled,
                                style: TextStyle(color: context.colors.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        if (_isLoadingStatus)
                          const CircularProgressIndicator()
                        else ...[
                          Chip(
                            label: Text(
                              isGranted ? s.notifEnabledChip : s.notifDisabledChip,
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: isGranted ? Colors.green : Colors.red,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          if (!isGranted) ...[
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: openAppSettings,
                              child: Text(s.notifOpenSettingsBtn, style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ─── SOCIAL SECTION ───
                _buildSectionHeader(s.notifSocialSection),
                Card(
                  color: context.colors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: context.colors.border),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        activeThumbColor: context.colors.primary,
                        title: Text(s.notifNewFollowers, style: TextStyle(fontSize: 14)),
                        value: _newFollowers,
                        onChanged: (val) => setState(() => _newFollowers = val),
                      ),
                      Divider(height: 1, color: context.colors.border),
                      SwitchListTile(
                        activeThumbColor: context.colors.primary,
                        title: Text(s.notifComments, style: TextStyle(fontSize: 14)),
                        value: _commentsOnPosts,
                        onChanged: (val) => setState(() => _commentsOnPosts = val),
                      ),
                      Divider(height: 1, color: context.colors.border),
                      SwitchListTile(
                        activeThumbColor: context.colors.primary,
                        title: Text(s.notifUpvotes, style: TextStyle(fontSize: 14)),
                        value: _upvotesOnPosts,
                        onChanged: (val) => setState(() => _upvotesOnPosts = val),
                      ),
                      Divider(height: 1, color: context.colors.border),
                      SwitchListTile(
                        activeThumbColor: context.colors.primary,
                        title: Text(s.notifMentions, style: TextStyle(fontSize: 14)),
                        value: _mentions,
                        onChanged: (val) => setState(() => _mentions = val),
                      ),
                      Divider(height: 1, color: context.colors.border),
                      SwitchListTile(
                        activeThumbColor: context.colors.primary,
                        title: Text(s.notifFollowRequests, style: TextStyle(fontSize: 14)),
                        value: _followRequests,
                        onChanged: (val) => setState(() => _followRequests = val),
                      ),
                      Divider(height: 1, color: context.colors.border),
                      ListTile(
                        title: Text(s.notifCommunityLabel, style: TextStyle(fontSize: 14)),
                        trailing: DropdownButton<String>(
                          value: _communityNotifications,
                          dropdownColor: context.colors.surface,
                          style: TextStyle(color: context.colors.textPrimary),
                          underline: const SizedBox(),
                          items: [
                            DropdownMenuItem(value: 'All', child: Text(s.notifAll)),
                            DropdownMenuItem(value: 'Mentions Only', child: Text(s.notifMentionsOnly)),
                            DropdownMenuItem(value: 'Off', child: Text(s.notifOff)),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _communityNotifications = val);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ─── COMMERCE SECTION ───
                _buildSectionHeader(s.notifCommerceSection),
                Card(
                  color: context.colors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: context.colors.border),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        activeThumbColor: context.colors.primary,
                        title: Text(s.notifOrderConfirmed, style: TextStyle(fontSize: 14)),
                        value: _orderConfirmed,
                        onChanged: (val) => setState(() => _orderConfirmed = val),
                      ),
                      Divider(height: 1, color: context.colors.border),
                      SwitchListTile(
                        activeThumbColor: context.colors.primary,
                        title: Text(s.notifOrderShipped, style: TextStyle(fontSize: 14)),
                        value: _orderShipped,
                        onChanged: (val) => setState(() => _orderShipped = val),
                      ),
                      Divider(height: 1, color: context.colors.border),
                      SwitchListTile(
                        activeThumbColor: context.colors.primary,
                        title: Text(s.notifOrderDelivered, style: TextStyle(fontSize: 14)),
                        value: _orderDelivered,
                        onChanged: (val) => setState(() => _orderDelivered = val),
                      ),
                      Divider(height: 1, color: context.colors.border),
                      SwitchListTile(
                        activeThumbColor: context.colors.primary,
                        title: Text(s.notifRefundProcessed, style: TextStyle(fontSize: 14)),
                        value: _refundProcessed,
                        onChanged: (val) => setState(() => _refundProcessed = val),
                      ),
                      if (_socialSettings != null) ...[
                        Divider(height: 1, color: context.colors.border),
                        SwitchListTile(
                          activeThumbColor: context.colors.primary,
                          title: Text(s.notifPriceDrop, style: TextStyle(fontSize: 14)),
                          value: _socialSettings!.priceDropAlerts,
                          onChanged: (val) {
                            _updateSocialSettings(_socialSettings!.copyWith(priceDropAlerts: val));
                          },
                        ),
                        Divider(height: 1, color: context.colors.border),
                        SwitchListTile(
                          activeThumbColor: context.colors.primary,
                          title: Text(s.notifBackInStock, style: TextStyle(fontSize: 14)),
                          value: _socialSettings!.backInStockAlerts,
                          onChanged: (val) {
                            _updateSocialSettings(_socialSettings!.copyWith(backInStockAlerts: val));
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ─── VENDOR SECTION ───
                if (isVendor && _socialSettings != null) ...[
                  _buildSectionHeader(s.notifVendorSection),
                  Card(
                    color: context.colors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: context.colors.border),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          activeThumbColor: context.colors.primary,
                          title: Text(s.notifOrderSound, style: TextStyle(fontSize: 14)),
                          subtitle: Text(s.notifOrderSoundSub, style: TextStyle(fontSize: 11)),
                          value: _socialSettings!.vendorNewOrderSound,
                          onChanged: (val) {
                            _updateSocialSettings(_socialSettings!.copyWith(vendorNewOrderSound: val));
                          },
                        ),
                        Divider(height: 1, color: context.colors.border),
                        SwitchListTile(
                          activeThumbColor: context.colors.primary,
                          title: Text(s.notifDailySummary, style: TextStyle(fontSize: 14)),
                          subtitle: Text(s.notifDailySummarySub, style: TextStyle(fontSize: 11)),
                          value: _socialSettings!.vendorDailySummary,
                          onChanged: (val) {
                            _updateSocialSettings(_socialSettings!.copyWith(vendorDailySummary: val));
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // ─── GENERAL & SYSTEM SECTION ───
                _buildSectionHeader(s.notifGeneralSection),
                Card(
                  color: context.colors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: context.colors.border),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        activeThumbColor: context.colors.primary,
                        title: Text(s.notifPromotionsToggle, style: TextStyle(fontSize: 14)),
                        value: _promotions,
                        onChanged: (val) => setState(() => _promotions = val),
                      ),
                      if (_socialSettings != null) ...[
                        Divider(height: 1, color: context.colors.border),
                        SwitchListTile(
                          activeThumbColor: context.colors.primary,
                          title: Text(s.notifLoginAlerts, style: TextStyle(fontSize: 14)),
                          subtitle: Text(s.notifLoginAlertsSub, style: TextStyle(fontSize: 11)),
                          value: _socialSettings!.loginNotifications,
                          onChanged: (val) {
                            _updateSocialSettings(_socialSettings!.copyWith(loginNotifications: val));
                          },
                        ),
                      ],
                      Divider(height: 1, color: context.colors.border),
                      ListTile(
                        leading: Icon(Icons.settings_suggest_outlined, color: context.colors.primary),
                        title: Text(s.notifManageChannels, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        subtitle: Text(s.notifManageChannelsSub, style: TextStyle(fontSize: 11)),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: openAppSettings,
                      ),
                    ],
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
