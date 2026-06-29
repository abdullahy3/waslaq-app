// lib/features/messages/ui/screens/chat_screen.dart
// Opens a single GetStream channel — full message list + input box.
// Receives a channel CID (e.g. "messaging:order_abc123") via route param.

import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../../../../router/app_router.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';
import '../../providers/stream_chat_provider.dart';

@RoutePage()
class ChatScreen extends ConsumerStatefulWidget {
  final String cid; // channel CID, e.g. "messaging:order_abc123"

  const ChatScreen({super.key, @PathParam('cid') required this.cid});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  Channel? _channel;
  String? _error;
  bool _loading = true;
  StreamSubscription<Event>? _subscription;

  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  Future<void> _initChannel() async {
    try {
      final client = ref.read(streamChatClientProvider);

      // Parse CID — format is "type:id"
      final parts = widget.cid.split(':');
      if (parts.length != 2) throw Exception('Invalid channel CID: ${widget.cid}');

      final channelType = parts[0];
      final channelId = parts[1];

      final channel = client.channel(channelType, id: channelId);
      await channel.watch();

      // 1. Mark the channel as read immediately on entry to clear unread counts on the server
      await channel.markRead();

      // 2. Automatically mark incoming messages as read while actively viewing the chat screen
      _subscription = channel.on().listen((event) {
        if (event.type == 'message.new' &&
            event.user?.id != client.state.currentUser?.id) {
          if (mounted) {
            channel.markRead();
          }
        }
      });

      if (mounted) {
        setState(() {
          _channel = channel;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: context.colors.background,
        appBar: AppBar(
          backgroundColor: context.colors.background,
          iconTheme: IconThemeData(color: context.colors.textPrimary),
          elevation: 0,
        ),
        body: Center(
          child: CircularProgressIndicator(color: context.colors.primary),
        ),
      );
    }

    if (_error != null || _channel == null) {
      return Scaffold(
        backgroundColor: context.colors.background,
        appBar: AppBar(
          backgroundColor: context.colors.background,
          iconTheme: IconThemeData(color: context.colors.textPrimary),
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: context.colors.textMuted),
                SizedBox(height: 16),
                Text(
                  'Could not open conversation',
                  style: TextStyle(color: context.colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  _error ?? 'Unknown error',
                  style: TextStyle(color: context.colors.textSecondary, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return StreamChannel(
      channel: _channel!,
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: _buildHeader(context),
        body: Column(
          children: [
            Expanded(
              child: const StreamMessageListView(),
            ),
            const StreamMessageInput(),
          ],
        ),
      ),
    );
  }

  // Custom header: resolves the other member's real name + avatar (never the
  // raw "customer_xxx" id) and makes the title tappable → their profile.
  PreferredSizeWidget _buildHeader(BuildContext context) {
    final client = ref.read(streamChatClientProvider);
    final me = client.state.currentUser?.id;
    final members = _channel?.state?.members ?? const <Member>[];
    final others = members.where((m) => m.userId != me).toList();
    final other = others.length == 1 ? others.first : null;

    final rawName = other?.user?.name ?? '';
    final title = (rawName.isNotEmpty && !rawName.startsWith('customer_'))
        ? rawName
        : (others.length == 1
            ? t.common.unknown_user
            : (_channel?.name ?? t.messages.title));
    final image = other?.user?.image;
    final customerId = (other?.userId ?? '').startsWith('customer_')
        ? other!.userId!.substring('customer_'.length)
        : '';

    void openProfile() {
      if (customerId.isNotEmpty) {
        context.router.push(UserProfileRoute(userId: customerId));
      }
    }

    return AppBar(
      backgroundColor: context.colors.surface,
      elevation: 0,
      titleSpacing: 0,
      iconTheme: IconThemeData(color: context.colors.textPrimary),
      leading: IconButton(
        icon: const BackButtonIcon(),
        onPressed: () => context.router.maybePop(),
      ),
      title: InkWell(
        onTap: customerId.isEmpty ? null : openProfile,
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: context.colors.primary.withValues(alpha: 0.15),
              backgroundImage: (image != null && image.isNotEmpty) ? NetworkImage(image) : null,
              child: (image == null || image.isEmpty)
                  ? Text(title.isNotEmpty ? title[0].toUpperCase() : '?',
                      style: TextStyle(color: context.colors.primary, fontWeight: FontWeight.bold))
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
