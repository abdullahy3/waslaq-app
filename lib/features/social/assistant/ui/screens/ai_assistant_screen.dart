import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../../router/app_router.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../data/social_repository.dart';
import '../../../providers/social_providers.dart';

class AiMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  AiMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'role': isUser ? 'user' : 'model',
        'content': text,
      };
}

class AiAssistantScreen extends ConsumerStatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  ConsumerState<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends ConsumerState<AiAssistantScreen> {
  final List<AiMessage> _messages = [];
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Add welcome message depending on locale
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isAr = Localizations.localeOf(context).languageCode == 'ar';
      setState(() {
        _messages.add(
          AiMessage(
            text: isAr
                ? 'مرحباً! أنا مساعد WaslaQ الذكي. كيف يمكنني مساعدتك اليوم؟\n\nيمكنك سؤالي عن المنتجات أو مشاركة رابط منشور أو منتج معي وسأقوم بقراءته وتوضيحه لك!'
                : 'Hello! I am your WaslaQ AI Assistant. How can I help you today?\n\nYou can ask me about products, or send me a product or community post link, and I will read and explain it for you!',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = AiMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMsg);
      _isTyping = true;
    });
    _textController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    try {
      final historyList = _messages
          .sublist(0, _messages.length - 1)
          .map((m) => m.toJson())
          .toList();

      final reply = await ref.read(socialRepositoryProvider).queryAssistant(
            message: userMsg.text,
            history: historyList,
          );

      if (mounted) {
        setState(() {
          _messages.add(
            AiMessage(
              text: reply,
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
        });
      }
    } catch (e) {
      if (mounted) {
        final isAr = Localizations.localeOf(context).languageCode == 'ar';
        setState(() {
          _messages.add(
            AiMessage(
              text: isAr
                  ? 'عذراً، حدث خطأ أثناء الاتصال بالمساعد الذكي. يرجى المحاولة لاحقاً.'
                  : 'Sorry, an error occurred while connecting to the assistant. Please try again later.',
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isTyping = false);
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.smart_toy_outlined, color: colors.primary, size: 22),
            ),
            const SizedBox(width: 10),
            Text(isAr ? 'مساعد وصلاق (AI)' : 'WaslaQ AI Assistant'),
          ],
        ),
        backgroundColor: colors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.textPrimary),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? Center(child: CircularProgressIndicator(color: colors.primary))
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _buildMessageBubble(_messages[index], colors);
                      },
                    ),
            ),
            if (_isTyping) _buildTypingIndicator(colors, isAr),
            _buildSuggestionChips(isAr, colors),
            _buildInputSection(isAr, colors),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChips(bool isAr, AppColors colors) {
    if (_messages.length > 1) return const SizedBox.shrink();

    final suggestions = isAr
        ? [
            'ما هو مجتمع r/general؟',
            'كيف أبحث عن المنتجات؟',
            'كيف يعمل نظام وصلاق؟',
          ]
        : [
            'What is the r/general community?',
            'How do I search for products?',
            'How does WaslaQ work?',
          ];

    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(
                suggestions[index],
                style: TextStyle(color: colors.primary, fontSize: 12),
              ),
              backgroundColor: colors.primary.withOpacity(0.05),
              side: BorderSide(color: colors.primary.withOpacity(0.2)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              onPressed: () => _sendMessage(suggestions[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(AiMessage message, AppColors colors) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? colors.primary : colors.surfaceVariant,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: message.isUser ? const Radius.circular(16) : Radius.zero,
            bottomRight: message.isUser ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: message.isUser
            ? Text(
                message.text,
                style: const TextStyle(color: Colors.white, fontSize: 14.5),
              )
            : _buildRichTextWithLinks(message.text, colors),
      ),
    );
  }

  // Parses URLs like waslaq.com/products/prod_xxx or waslaq.com/r/xxx/comments/xxx and makes them clickable
  Widget _buildRichTextWithLinks(String text, AppColors colors) {
    final List<InlineSpan> spans = [];

    // Regex to detect product or post paths
    final regExp = RegExp(
      r'((?:https?://[^\s]+)?/(?:products|product|r/[a-zA-Z0-9_]+/comments|posts|post)/(?:prod_)?[a-zA-Z0-9_-]+)|(prod_[a-zA-Z0-9_]+)|(post_[a-zA-Z0-9_]+)',
      caseSensitive: false,
    );

    int start = 0;
    for (final match in regExp.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(
          text: text.substring(start, match.start),
          style: TextStyle(color: colors.textPrimary, fontSize: 14.5),
        ));
      }

      final matchedText = match.group(0)!;
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: InkWell(
            onTap: () => _handleLinkClick(matchedText),
            child: Text(
              matchedText,
              style: TextStyle(
                color: colors.primaryLight,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 14.5,
              ),
            ),
          ),
        ),
      );

      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: TextStyle(color: colors.textPrimary, fontSize: 14.5),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  void _handleLinkClick(String link) {
    // Determine target from link format
    if (link.contains('prod_') || link.startsWith('prod_')) {
      final match = RegExp(r'(prod_[a-zA-Z0-9_]+)').firstMatch(link);
      if (match != null) {
        context.pushRoute(ProductRoute(id: match.group(1)!));
      }
    } else if (link.contains('/comments/') || link.contains('/posts/') || link.contains('/post/') || link.startsWith('post_')) {
      final postMatch = RegExp(r'(post_[a-zA-Z0-9_]+)').firstMatch(link);
      final communityMatch = RegExp(r'/r/([a-zA-Z0-9_]+)/comments/').firstMatch(link);

      final postId = postMatch?.group(1);
      final community = communityMatch?.group(1) ?? 'general';

      if (postId != null) {
        context.pushRoute(PostDetailRoute(community: community, postId: postId));
      }
    } else if (link.contains('/r/')) {
      final match = RegExp(r'/r/([a-zA-Z0-9_]+)').firstMatch(link);
      if (match != null) {
        context.pushRoute(CommunityRoute(communitySlug: match.group(1)!));
      }
    }
  }

  Widget _buildTypingIndicator(AppColors colors, bool isAr) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(color: colors.primary, strokeWidth: 2),
            ),
            const SizedBox(width: 10),
            Text(
              isAr ? 'المساعد يكتب...' : 'Assistant is typing...',
              style: TextStyle(color: colors.textSecondary, fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection(bool isAr, AppColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colors.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _textController,
                style: TextStyle(color: colors.textPrimary),
                decoration: InputDecoration(
                  hintText: isAr ? 'اسأل المساعد...' : 'Ask the assistant...',
                  hintStyle: TextStyle(color: colors.textMuted),
                  border: InputBorder.none,
                ),
                onSubmitted: _sendMessage,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _sendMessage(_textController.text),
            icon: Icon(
              Icons.send,
              color: colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
