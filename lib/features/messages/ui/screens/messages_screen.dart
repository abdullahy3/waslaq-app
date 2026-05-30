// lib/features/messages/ui/screens/messages_screen.dart

import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../../../../core/api/social_client.dart';
import '../../../../core/auth/auth_notifier.dart';
import '../../../../router/app_router.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';
import '../../providers/stream_chat_provider.dart';

@RoutePage()
class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    final isAuthenticated = authState.maybeWhen(
      authenticated: (_, __, ___, ____, _____) => true,
      orElse: () => false,
    );

    if (!isAuthenticated) {
      return _buildUnauthenticated(context);
    }

    return _StreamMessagesBody(key: const ValueKey('stream_messages'));
  }

  Widget _buildUnauthenticated(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(t.messages.title,
            style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: context.colors.background,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: context.colors.border),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble_outline, size: 72, color: context.colors.border),
              SizedBox(height: 20),
              Text(t.messages.sign_in_view,
                  style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                t.messages.connect_vendors_buyers,
                style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              FilledButton(
                onPressed: () => context.router.push(const SignInRoute()),
                style: FilledButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  minimumSize: const Size(180, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(t.auth.sign_in,
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Separate widget — only mounts when authenticated.
class _StreamMessagesBody extends ConsumerWidget {
  const _StreamMessagesBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionAsync = ref.watch(streamChatConnectionProvider);
    final client = ref.watch(streamChatClientProvider);

    return connectionAsync.when(
      loading: () => Scaffold(
        backgroundColor: context.colors.background,
        appBar: _buildAppBar(context),
        body: Center(
          child: CircularProgressIndicator(color: context.colors.primary),
        ),
      ),
      error: (err, _) => Scaffold(
        backgroundColor: context.colors.background,
        appBar: _buildAppBar(context),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off, size: 56, color: context.colors.textMuted),
                SizedBox(height: 16),
                Text(t.messages.could_not_connect,
                    style: TextStyle(
                        color: context.colors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(
                  err.toString(),
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      data: (connected) {
        if (!connected) {
          return Scaffold(
            backgroundColor: context.colors.background,
            appBar: _buildAppBar(context),
            body: Center(
              child: Text(t.messages.not_connected, style: TextStyle(color: context.colors.textMuted)),
            ),
          );
        }

        return Scaffold(
            backgroundColor: context.colors.background,
            appBar: _buildAppBar(context),
            floatingActionButton: FloatingActionButton(
              backgroundColor: context.colors.primary,
              foregroundColor: Colors.white,
              onPressed: () => _openUserSearch(context, ref, client),
              child: const Icon(Icons.edit_outlined),
            ),
            body: StreamChannelListView(
              controller: StreamChannelListController(
                client: client,
                filter: Filter.in_('members', [client.state.currentUser!.id]),
                channelStateSort: const [SortOption('last_message_at')],
                limit: 30,
              ),
              onChannelTap: (channel) {
                final cid = channel.cid;
                if (cid != null) {
                  context.router.push(ChatRoute(cid: cid));
                }
              },
              // Show the OTHER member's real name, not their Stream ID
              itemBuilder: (context, channels, index, defaultWidget) {
                final channel = channels[index];
                final currentUserId = client.state.currentUser?.id;
                final otherMember = channel.state?.members
                    .where((m) => m.userId != currentUserId)
                    .firstOrNull;
                final otherName = otherMember?.user?.name?.isNotEmpty == true
                    ? otherMember!.user!.name!
                    : (otherMember?.userId ?? '...');
                final otherImage = otherMember?.user?.image;
                final lastMsg = channel.state?.messages.lastOrNull;
                final lastText = lastMsg?.text ?? '';

                return StreamBuilder<int>(
                  stream: channel.state?.unreadCountStream,
                  initialData: channel.state?.unreadCount ?? 0,
                  builder: (context, snapshot) {
                    final unread = snapshot.data ?? 0;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: context.colors.primary.withValues(alpha: 0.15),
                        backgroundImage: otherImage != null ? NetworkImage(otherImage) : null,
                        child: otherImage == null
                            ? Text(otherName.isNotEmpty ? otherName[0].toUpperCase() : '?',
                                style: TextStyle(color: context.colors.primary, fontWeight: FontWeight.bold))
                            : null,
                      ),
                      title: Text(otherName,
                          style: TextStyle(
                              color: context.colors.textPrimary,
                              fontWeight: unread > 0 ? FontWeight.bold : FontWeight.w500)),
                      subtitle: lastText.isNotEmpty
                          ? Text(lastText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: context.colors.textSecondary, fontSize: 13))
                          : null,
                      trailing: unread > 0
                          ? CircleAvatar(
                              radius: 10,
                              backgroundColor: context.colors.primary,
                              child: Text('$unread',
                                  style: const TextStyle(color: Colors.white, fontSize: 10)))
                          : null,
                      onTap: () {
                        final cid = channel.cid;
                        if (cid != null) context.router.push(ChatRoute(cid: cid));
                      },
                    );
                  },
                );
              },
              emptyBuilder: (context) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          size: 64, color: context.colors.border),
                      SizedBox(height: 20),
                      Text(
                        t.messages.no_conversations,
                        style: TextStyle(
                            color: context.colors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        t.messages.tap_pencil_start,
                        style: TextStyle(
                            color: context.colors.textSecondary, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(t.messages.title,
          style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold)),
      backgroundColor: context.colors.background,
      iconTheme: IconThemeData(color: context.colors.textPrimary),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Container(height: 0.5, color: context.colors.border),
      ),
    );
  }

  void _openUserSearch(BuildContext context, WidgetRef ref, StreamChatClient client) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProviderScope(
        parent: ProviderScope.containerOf(context),
        child: _UserSearchSheet(client: client),
      ),
    );
  }
}

// ── Local model ───────────────────────────────────────────────
class _UserResult {
  final String customerId, username, displayName;
  final String? avatarStyle, avatarSeed;

  _UserResult({
    required this.customerId,
    required this.username,
    required this.displayName,
    this.avatarStyle,
    this.avatarSeed,
  });

  factory _UserResult.fromJson(Map<String, dynamic> j) => _UserResult(
        customerId: j['customerId'] as String,
        username: (j['username'] as String?) ?? '',
        displayName: (j['displayName'] as String?) ?? '',
        avatarStyle: j['avatarStyle'] as String?,
        avatarSeed: j['avatarSeed'] as String?,
      );
}

// ── Search sheet ──────────────────────────────────────────────
class _UserSearchSheet extends ConsumerStatefulWidget {
  final StreamChatClient client;
  const _UserSearchSheet({required this.client});

  @override
  ConsumerState<_UserSearchSheet> createState() => _UserSearchSheetState();
}

class _UserSearchSheetState extends ConsumerState<_UserSearchSheet> {
  final _controller = TextEditingController();
  Timer? _debounce;
  List<_UserResult> _users = [];
  bool _loading = false;
  bool _creatingChannel = false;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _search);
  }

  Future<void> _search() async {
    final q = _controller.text.trim();
    if (q.isEmpty) {
      setState(() => _users = []);
      return;
    }
    setState(() => _loading = true);
    try {
      final res = await SocialClient.instance
          .get('/store/social/users/search', queryParameters: {'q': q});
      final list = res.data['users'] as List<dynamic>;
      setState(() => _users = list
          .map((e) => _UserResult.fromJson(e as Map<String, dynamic>))
          .toList());
    } catch (_) {
      // silently fail — show empty list
      setState(() => _users = []);
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _startChat(_UserResult user) async {
    if (_creatingChannel) return;
    setState(() => _creatingChannel = true);

    try {
      final myId = widget.client.state.currentUser!.id; // "customer_xxx"
      final theirId = 'customer_${user.customerId}';

      // Ensure target user exists in GetStream before channel creation.
      // They may never have opened messages — this upserts them server-side.
      await SocialClient.instance.post(
        '/store/social/users/${user.customerId}/sync-chat',
      );

      // Deterministic channel ID — same pair always gets same channel
      final members = [myId, theirId]..sort();
      final channelId = members.join('__');

      final channel = widget.client.channel(
        'messaging',
        id: channelId,
        extraData: {'members': members},
      );
      await channel.watch();

      if (mounted) {
        Navigator.of(context).pop(); // close sheet
        context.router.push(ChatRoute(cid: channel.cid!));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.messages.could_not_open_chat(error: e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _creatingChannel = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.colors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              t.messages.new_message,
              style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
          ),
          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: _onChanged,
              style: TextStyle(color: context.colors.textPrimary),
              decoration: InputDecoration(
                hintText: t.messages.search_hint,
                hintStyle: TextStyle(color: context.colors.textMuted),
                prefixIcon:
                    Icon(Icons.search, color: context.colors.textMuted),
                filled: true,
                fillColor: context.colors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          // Results
          Expanded(
            child: _loading
                ? Center(
                    child: CircularProgressIndicator(color: context.colors.primary))
                : _users.isEmpty && _controller.text.isNotEmpty
                    ? Center(
                        child: Text(t.messages.no_users_found,
                            style: TextStyle(color: context.colors.textMuted)))
                    : ListView.builder(
                        itemCount: _users.length,
                        itemBuilder: (context, i) {
                          final user = _users[i];
                          final avatarUrl =
                              'https://api.dicebear.com/9.x/${user.avatarStyle ?? 'big-smile'}/svg?seed=${user.avatarSeed ?? user.customerId}';
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: context.colors.surfaceVariant,
                              child: ClipOval(
                                child: SvgPicture.network(
                                  avatarUrl,
                                  width: 40,
                                  height: 40,
                                  placeholderBuilder: (_) =>
                                      SizedBox(),
                                ),
                              ),
                            ),
                            title: Text(
                              user.displayName,
                              style: TextStyle(
                                  color: context.colors.textPrimary,
                                  fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              '@${user.username}',
                              style: TextStyle(
                                  color: context.colors.textMuted, fontSize: 13),
                            ),
                            trailing: _creatingChannel
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: context.colors.primary))
                                : Icon(Icons.arrow_forward_ios,
                                    size: 14, color: context.colors.textMuted),
                            onTap: () => _startChat(user),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
