import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waslaq_app/i18n/strings.g.dart';
import 'package:waslaq_app/shared/theme/app_colors.dart';
import 'package:waslaq_app/core/auth/auth_notifier.dart';
import 'package:waslaq_app/features/social/providers/social_providers.dart';
import 'package:waslaq_app/features/account/data/models/social_settings_model.dart';
import 'package:waslaq_app/features/account/providers/account_providers.dart';

@RoutePage()
class PrivacySettingsScreen extends ConsumerStatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  ConsumerState<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends ConsumerState<PrivacySettingsScreen> {
  bool _isLoading = true;
  UserSocialSettingsModel? _socialSettings;
  List<Map<String, dynamic>> _blockedUsers = [];
  List<Map<String, dynamic>> _followRequests = [];

  @override
  void initState() {
    super.initState();
    _loadPrivacyData();
  }

  Future<void> _loadPrivacyData() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(accountRepositoryProvider);
      final settingsMap = await repo.getSocialSettings();
      final blocked = await repo.getBlockedUsers();
      final requests = await repo.getFollowRequests();

      setState(() {
        _socialSettings = UserSocialSettingsModel.fromJson(settingsMap);
        _blockedUsers = blocked;
        _followRequests = requests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load privacy data: $e'), backgroundColor: context.colors.error),
      );
    }
  }

  Future<void> _updateProfilePrivacy(String customerId, {bool? isPrivate, bool? showActivityStatus}) async {
    try {
      await ref.read(accountRepositoryProvider).updateProfileExtended(
        customerId,
        isPrivate: isPrivate,
        showActivityStatus: showActivityStatus,
      );
      ref.invalidate(userProfileProvider(customerId));
      await ref.read(authNotifierProvider.notifier).refreshProfile();
      _loadPrivacyData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update privacy profile: $e'), backgroundColor: context.colors.error),
      );
    }
  }

  Future<void> _updateSocialSettings(UserSocialSettingsModel newSettings) async {
    try {
      setState(() => _socialSettings = newSettings);
      await ref.read(accountRepositoryProvider).updateSocialSettings(newSettings.toJson());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update social settings: $e'), backgroundColor: context.colors.error),
      );
    }
  }

  Future<void> _unblockUser(String blockedCustomerId) async {
    try {
      await ref.read(accountRepositoryProvider).unblockUser(blockedCustomerId);
      final blocked = await ref.read(accountRepositoryProvider).getBlockedUsers();
      setState(() {
        _blockedUsers = blocked;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User unblocked successfully'), backgroundColor: Colors.green),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to unblock user: $e'), backgroundColor: context.colors.error),
      );
    }
  }

  Future<void> _handleFollowRequest(String requestId, bool approve) async {
    try {
      final repo = ref.read(accountRepositoryProvider);
      if (approve) {
        await repo.approveFollowRequest(requestId);
      } else {
        await repo.rejectFollowRequest(requestId);
      }
      final requests = await repo.getFollowRequests();
      setState(() {
        _followRequests = requests;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(approve ? 'Follow request approved' : 'Follow request rejected'),
          backgroundColor: context.colors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error handling request: $e'), backgroundColor: context.colors.error),
      );
    }
  }

  void _showBlockedUsers() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: context.colors.background,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: context.colors.border, borderRadius: BorderRadius.circular(2)),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(t.settings.privacyBlockedSection, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _blockedUsers.isEmpty
                        ? const Center(child: Text('No blocked users.'))
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: _blockedUsers.length,
                            itemBuilder: (context, idx) {
                              final u = _blockedUsers[idx];
                              final displayName = u['displayName'] as String? ?? 'User';
                              final username = u['username'] as String? ?? '';
                              final avatarStyle = u['avatarStyle'] as String? ?? 'big-smile';
                              final avatarSeed = u['avatarSeed'] as String? ?? 'Felix';
                              final avatarUrl = u['avatarUrl'] as String?;
                              final diceBearUrl = 'https://api.dicebear.com/9.x/$avatarStyle/png?seed=$avatarSeed&size=128';

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: context.colors.surface,
                                  backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                                      ? CachedNetworkImageProvider(avatarUrl)
                                      : CachedNetworkImageProvider(diceBearUrl) as ImageProvider,
                                ),
                                title: Text(displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('@$username', style: TextStyle(color: context.colors.textSecondary)),
                                trailing: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: context.colors.primary,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _unblockUser(u['customerId'] as String);
                                  },
                                  child: const Text('Unblock'),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = t.settings;
    final authState = ref.watch(authNotifierProvider);
    final customerId = authState.maybeWhen(
      authenticated: (id, _, __, ___, ____) => id,
      orElse: () => null,
    );

    if (customerId == null) {
      return const Scaffold(body: Center(child: Text('Sign in to view privacy settings')));
    }

    final profileAsync = ref.watch(userProfileProvider(customerId));

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(s.privacyScreenTitle, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ─── ACCOUNT PRIVACY SECTION ───
                _buildSectionHeader(s.privacyAccountSection),
                Card(
                  color: context.colors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: context.colors.border),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        activeColor: context.colors.primary,
                        title: Text(s.privacyPrivateAccount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: Text(s.privacyPrivateAccountSub, style: TextStyle(fontSize: 12)),
                        value: profileAsync.valueOrNull?.isPrivate ?? false,
                        onChanged: (val) => _updateProfilePrivacy(customerId, isPrivate: val),
                      ),
                      Divider(height: 1, color: context.colors.border),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.privacyActivityStatus, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: SegmentedButton<String>(
                                style: SegmentedButton.styleFrom(
                                  selectedBackgroundColor: context.colors.primary,
                                  selectedForegroundColor: Colors.white,
                                ),
                                segments: const [
                                  ButtonSegment(value: 'everyone', label: Text('Everyone', style: TextStyle(fontSize: 12))),
                                  ButtonSegment(value: 'followers', label: Text('Followers', style: TextStyle(fontSize: 12))),
                                  ButtonSegment(value: 'nobody', label: Text('No One', style: TextStyle(fontSize: 12))),
                                ],
                                selected: {
                                  profileAsync.valueOrNull?.showActivityStatus ?? true
                                      ? 'everyone'
                                      : 'nobody'
                                },
                                onSelectionChanged: (val) {
                                  final isShow = val.first == 'everyone' || val.first == 'followers';
                                  _updateProfilePrivacy(customerId, showActivityStatus: isShow);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ─── MESSAGING & CHAT SECTION ───
                _buildSectionHeader(s.privacyMessagingSection),
                if (_socialSettings != null)
                  Card(
                    color: context.colors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: context.colors.border),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Who Can Message Me', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: SegmentedButton<String>(
                              style: SegmentedButton.styleFrom(
                                selectedBackgroundColor: context.colors.primary,
                                selectedForegroundColor: Colors.white,
                              ),
                              segments: const [
                                ButtonSegment(value: 'everyone', label: Text('Everyone', style: TextStyle(fontSize: 12))),
                                ButtonSegment(value: 'followers', label: Text('Followers', style: TextStyle(fontSize: 12))),
                                ButtonSegment(value: 'nobody', label: Text('No One', style: TextStyle(fontSize: 12))),
                              ],
                              selected: {_socialSettings!.whoCanMessage},
                              onSelectionChanged: (val) {
                                _updateSocialSettings(_socialSettings!.copyWith(whoCanMessage: val.first));
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          Divider(height: 1, color: context.colors.border),
                          const SizedBox(height: 12),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            activeColor: context.colors.primary,
                            title: Text(s.privacyReadReceipts, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: Text(s.privacyReadReceiptsSub, style: TextStyle(fontSize: 12)),
                            value: _socialSettings!.readReceipts,
                            onChanged: (val) {
                              _updateSocialSettings(_socialSettings!.copyWith(readReceipts: val));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),

                // ─── BLOCKED USERS SECTION ───
                _buildSectionHeader(s.privacyBlockedSection),
                Card(
                  color: context.colors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: context.colors.border),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.block, color: context.colors.primary),
                    title: const Text('Manage Blocked Users', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            '${_blockedUsers.length}',
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: _showBlockedUsers,
                  ),
                ),
                const SizedBox(height: 20),

                // ─── FOLLOW REQUESTS SECTION ───
                if (_followRequests.isNotEmpty) ...[
                  _buildSectionHeader(s.privacyFollowReqSection),
                  Card(
                    color: context.colors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: context.colors.border),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _followRequests.length,
                      separatorBuilder: (_, __) => Divider(height: 1, color: context.colors.border),
                      itemBuilder: (context, idx) {
                        final req = _followRequests[idx];
                        final id = req['id'] as String;
                        final sender = req['sender'] as Map<String, dynamic>? ?? {};
                        final name = sender['displayName'] as String? ?? 'User';
                        final username = sender['username'] as String? ?? '';
                        final style = sender['avatarStyle'] as String? ?? 'big-smile';
                        final seed = sender['avatarSeed'] as String? ?? 'Felix';
                        final url = sender['avatarUrl'] as String?;
                        final diceBearUrl = 'https://api.dicebear.com/9.x/$style/png?seed=$seed&size=128';

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: context.colors.surface,
                            backgroundImage: url != null && url.isNotEmpty
                                ? CachedNetworkImageProvider(url)
                                : CachedNetworkImageProvider(diceBearUrl) as ImageProvider,
                          ),
                          title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          subtitle: Text('@$username', style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check, color: Colors.green),
                                onPressed: () => _handleFollowRequest(id, true),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () => _handleFollowRequest(id, false),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // ─── PRIVACY DISCLAIMER SECTION ───
                Card(
                  color: context.colors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: context.colors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('🚚 ', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Vendor & Delivery Privacy',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'When you place an order, your phone number and delivery address are shared with the vendor solely for delivery coordination. This information is never used for marketing and is not shared with any third parties.',
                                style: TextStyle(color: context.colors.textSecondary, fontSize: 12, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
