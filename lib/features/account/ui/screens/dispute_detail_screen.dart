// lib/features/account/ui/screens/dispute_detail_screen.dart

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../data/models/dispute_model.dart';
import '../../providers/dispute_providers.dart';

class DisputeDetailScreen extends ConsumerStatefulWidget {
  final DisputeModel dispute;
  final bool isVendorView;
  const DisputeDetailScreen({super.key, required this.dispute, this.isVendorView = false});

  @override
  ConsumerState<DisputeDetailScreen> createState() => _DisputeDetailScreenState();
}

class _DisputeDetailScreenState extends ConsumerState<DisputeDetailScreen> {
  late DisputeModel _dispute;
  List<DisputeMessageModel>? _messages;
  final _controller = TextEditingController();
  bool _sending = false;
  bool _loading = true;
  bool _uploading = false;
  Timer? _timer;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _dispute = widget.dispute;
    _loadMessages();
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _pollMessages());
  }

  Future<void> _pollMessages() async {
    try {
      final result = await ref
          .read(disputeRepositoryProvider)
          .getDisputeDetails(_dispute.id);
      if (mounted) {
        final hasNewMessages = _messages == null || result.messages.length != _messages!.length;
        setState(() {
          _messages = result.messages;
          _dispute = result.dispute;
        });
        if (hasNewMessages) {
          _scrollToBottom();
        }
      }
    } catch (_) {}
  }

  Future<void> _loadMessages() async {
    setState(() => _loading = true);
    try {
      final result = await ref
          .read(disputeRepositoryProvider)
          .getDisputeDetails(_dispute.id);
      if (mounted) {
        setState(() {
          _messages = result.messages;
          _dispute = result.dispute;
          _loading = false;
        });
        _scrollToBottom();
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _messages = [];
          _loading = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      await ref
          .read(disputeRepositoryProvider)
          .sendMessage(_dispute.id, text);
      _controller.clear();
      await _loadMessages();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _pickAndUploadMedia() async {
    if (_uploading || _sending) return;
    final picker = ImagePicker();

    final source = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.image_outlined, color: context.colors.textPrimary),
              title: Text('Pick Image', style: TextStyle(color: context.colors.textPrimary)),
              onTap: () => Navigator.pop(ctx, 'image'),
            ),
            ListTile(
              leading: Icon(Icons.videocam_outlined, color: context.colors.textPrimary),
              title: Text('Pick Video', style: TextStyle(color: context.colors.textPrimary)),
              onTap: () => Navigator.pop(ctx, 'video'),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final XFile? pickedFile = source == 'image'
        ? await picker.pickImage(source: ImageSource.gallery, imageQuality: 80)
        : await picker.pickVideo(source: ImageSource.gallery, maxDuration: const Duration(minutes: 2));

    if (pickedFile == null) return;

    setState(() => _uploading = true);
    try {
      final repo = ref.read(disputeRepositoryProvider);
      final uploadRes = await repo.uploadAttachment(_dispute.id, pickedFile.path);

      final label = source == 'image' ? '📎 Sent an image' : '📎 Sent a video';
      await repo.sendMessage(
        _dispute.id,
        label,
        mediaUrl: uploadRes.url,
        mediaType: uploadRes.mediaType,
      );
      await _loadMessages();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text('Dispute Details',
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
      body: Column(
        children: [
          _DisputeHeaderCard(dispute: _dispute),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadMessages,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : (_messages == null || _messages!.isEmpty)
                      ? ListView(
                          children: [
                            const SizedBox(height: 60),
                            Center(
                              child: Text(
                                'No messages yet.',
                                style: TextStyle(
                                    color: context.colors.textSecondary),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          itemCount: _messages!.length,
                          itemBuilder: (context, i) =>
                              _MessageBubble(
                                msg: _messages![i],
                                isVendorView: widget.isVendorView,
                              ),
                        ),
            ),
          ),
          if (_dispute.isResolved)
            _ResolutionBanner(status: _dispute.status)
          else
            _MessageInput(
              controller: _controller,
              sending: _sending,
              uploading: _uploading,
              onSend: _send,
              onPickAttachment: _pickAndUploadMedia,
            ),
        ],
      ),
    );
  }
}

// ─── Header card ─────────────────────────────────────────────────────────────

class _DisputeHeaderCard extends StatelessWidget {
  final DisputeModel dispute;
  const _DisputeHeaderCard({required this.dispute});

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
        return Colors.grey;
      case 'resolved_split':
        return Colors.grey;
      default:
        return context.colors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(context);
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: dispute.thumbnail != null
                ? CachedNetworkImage(
                    imageUrl: dispute.thumbnail!,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => _placeholder(context),
                  )
                : _placeholder(context),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dispute.productTitle ?? 'Order item',
                  style: TextStyle(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  dispute.typeLabel,
                  style: TextStyle(
                      color: context.colors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    dispute.statusLabel,
                    style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      color: context.colors.surfaceVariant,
      child:
          Icon(Icons.image_outlined, color: context.colors.textMuted, size: 24),
    );
  }
}

// ─── Media Attachment ────────────────────────────────────────────────────────

class _MediaAttachment extends StatelessWidget {
  final String mediaUrl;
  final String? mediaType;
  const _MediaAttachment({required this.mediaUrl, this.mediaType});

  @override
  Widget build(BuildContext context) {
    final isVideo = mediaType == 'video';

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: GestureDetector(
          onTap: () async {
            final uri = Uri.tryParse(mediaUrl);
            if (uri != null) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
          child: isVideo
              ? Container(
                  width: 240,
                  height: 140,
                  color: Colors.black87,
                  child: const Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        child: Icon(Icons.play_circle_fill,
                            color: Colors.white, size: 50),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Row(
                          children: [
                            Icon(Icons.videocam_outlined,
                                color: Colors.white70, size: 16),
                            SizedBox(width: 4),
                            Text('Video Attachment',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  constraints: const BoxConstraints(
                    maxWidth: 240,
                    maxHeight: 200,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: mediaUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 240,
                      height: 150,
                      color: Colors.grey[200],
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: 240,
                      height: 150,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image_outlined,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

// ─── Message bubbles ──────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final DisputeMessageModel msg;
  final bool isVendorView;
  const _MessageBubble({required this.msg, this.isVendorView = false});

  String get _timeStr {
    final h = msg.createdAt.hour.toString().padLeft(2, '0');
    final m = msg.createdAt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    if (msg.senderRole == 'admin') {
      return _AdminBubble(msg: msg, timeStr: _timeStr);
    }
    // In vendor view: vendor's messages are "You" (right), buyer messages on left labeled "Buyer"
    // In buyer view: buyer's messages are "You" (right), vendor messages on left labeled "Vendor"
    final isMyMessage = isVendorView
        ? msg.senderRole == 'vendor'
        : msg.senderRole == 'buyer';
    if (isMyMessage) {
      return _MyBubble(msg: msg, timeStr: _timeStr);
    }
    final otherLabel = isVendorView ? 'Buyer' : 'Vendor';
    final otherColor = isVendorView ? Colors.blue[700]! : const Color(0xFF4CAF50);
    return _OtherBubble(msg: msg, timeStr: _timeStr, label: otherLabel, color: otherColor);
  }
}

class _MyBubble extends StatelessWidget {
  final DisputeMessageModel msg;
  final String timeStr;
  const _MyBubble({required this.msg, required this.timeStr});

  @override
  Widget build(BuildContext context) {
    final isSeen = msg.seenBy.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('You',
                    style: TextStyle(
                        fontSize: 11, color: context.colors.textMuted)),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: context.colors.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(msg.message,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14)),
                      if (msg.mediaUrl != null)
                        _MediaAttachment(
                          mediaUrl: msg.mediaUrl!,
                          mediaType: msg.mediaType,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(timeStr,
                        style: TextStyle(
                            fontSize: 10, color: context.colors.textMuted)),
                    const SizedBox(width: 4),
                    Text(
                      isSeen ? '✓✓' : '✓',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isSeen ? context.colors.primary : context.colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OtherBubble extends StatelessWidget {
  final DisputeMessageModel msg;
  final String timeStr;
  final String label;
  final Color color;
  const _OtherBubble({
    required this.msg,
    required this.timeStr,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 11, color: color)),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(msg.message,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14)),
                      if (msg.mediaUrl != null)
                        _MediaAttachment(
                          mediaUrl: msg.mediaUrl!,
                          mediaType: msg.mediaType,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(timeStr,
                    style: TextStyle(
                        fontSize: 10, color: context.colors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminBubble extends StatelessWidget {
  final DisputeMessageModel msg;
  final String timeStr;
  const _AdminBubble({required this.msg, required this.timeStr});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Center(
        child: Column(
          children: [
            const Text(
              'Admin',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF9800)),
            ),
            const SizedBox(height: 2),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9800).withValues(alpha: 0.15),
                border: Border.all(
                    color: const Color(0xFFFF9800).withValues(alpha: 0.4)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    msg.message,
                    style: const TextStyle(
                        color: Color(0xFFE65100),
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  if (msg.mediaUrl != null)
                    _MediaAttachment(
                      mediaUrl: msg.mediaUrl!,
                      mediaType: msg.mediaType,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(timeStr,
                style: TextStyle(
                    fontSize: 10, color: context.colors.textMuted)),
          ],
        ),
      ),
    );
  }
}

// ─── Resolution banner ────────────────────────────────────────────────────────

class _ResolutionBanner extends StatelessWidget {
  final String status;
  const _ResolutionBanner({required this.status});

  @override
  Widget build(BuildContext context) {
    final isRefund = status == 'resolved_refund';
    final isSplit = status == 'resolved_split';
    final color = isRefund
        ? Colors.green[700]!
        : (isSplit ? Colors.purple[700]! : Colors.blue[700]!);
    final text = isRefund
        ? '✅ Dispute resolved — Full refund issued'
        : (isSplit
            ? '✅ Dispute resolved — Custom split resolved'
            : '✅ Dispute resolved — Funds released to vendor');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: color.withValues(alpha: 0.12),
      child: Text(
        text,
        style: TextStyle(
            color: color, fontSize: 14, fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// ─── Message input ────────────────────────────────────────────────────────────

class _MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final bool sending;
  final bool uploading;
  final VoidCallback onSend;
  final VoidCallback onPickAttachment;

  const _MessageInput({
    required this.controller,
    required this.sending,
    required this.uploading,
    required this.onSend,
    required this.onPickAttachment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          8, 8, 8, 8 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.border)),
      ),
      child: Row(
        children: [
          uploading
              ? const SizedBox(
                  width: 48,
                  height: 48,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  onPressed: onPickAttachment,
                  icon: Icon(Icons.attach_file, color: context.colors.textSecondary),
                ),
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write a message...',
                hintStyle:
                    TextStyle(color: context.colors.textMuted),
                filled: true,
                fillColor: context.colors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 4),
          sending
              ? const SizedBox(
                  width: 48,
                  height: 48,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ))
              : IconButton(
                  onPressed: onSend,
                  icon: Icon(Icons.send_rounded,
                      color: context.colors.primary),
                  iconSize: 26,
                ),
        ],
      ),
    );
  }
}
