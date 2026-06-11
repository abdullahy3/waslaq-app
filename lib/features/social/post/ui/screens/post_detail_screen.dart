import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/auth/auth_notifier.dart';
import '../../../../../i18n/strings.g.dart';
import '../../../../../router/app_router.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../data/models/social_models.dart';
import '../../../providers/social_providers.dart';

final postCommentsProvider = FutureProvider.autoDispose.family<List<CommentModel>, String>((ref, id) {
  return ref.watch(socialRepositoryProvider).getComments(id);
});

@RoutePage()
class PostDetailScreen extends ConsumerStatefulWidget {
  final String community;
  final String postId;

  const PostDetailScreen({
    super.key,
    @PathParam('community') this.community = '',
    @PathParam('postId') this.postId = '',
  });

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final _commentController = TextEditingController();
  CommentModel? _replyToComment;

  String _getTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 365) return t.social.years_short(n: diff.inDays ~/ 365);
    if (diff.inDays > 0) return t.social.days_short(n: diff.inDays);
    if (diff.inHours > 0) return t.social.hours_short(n: diff.inHours);
    if (diff.inMinutes > 0) return t.social.minutes_short(n: diff.inMinutes);
    return t.social.now_short;
  }

  String _getAvatarUrl(String? styleStr, String? seedStr) {
    final style = (styleStr != null && styleStr.isNotEmpty) ? styleStr : 'bottts';
    final seed = (seedStr != null && seedStr.isNotEmpty) ? seedStr : 'default';
    return 'https://api.dicebear.com/7.x/$style/svg?seed=$seed';
  }

  Future<void> _submitComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;
    try {
      await ref.read(socialRepositoryProvider).createComment(
        postId: widget.postId,
        content: content,
        parentId: _replyToComment?.id,
      );
      _commentController.clear();
      setState(() {
        _replyToComment = null;
      });
      if (mounted) {
        FocusScope.of(context).unfocus();
      }
      ref.invalidate(postCommentsProvider(widget.postId));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.common.error_prefix(error: e.toString()))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final postAsync = ref.watch(postProvider(widget.postId));
    final authState = ref.watch(authNotifierProvider);
    final isAuthenticated = authState.maybeWhen(
      authenticated: (_, __, ___, ____, _____) => true,
      orElse: () => false,
    );
    
    final currentUserSeed = authState.maybeWhen(
      authenticated: (id, _, __, ___, ____) => id,
      orElse: () => 'default',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'r/${widget.community}',
          style: TextStyle(color: context.colors.primary),
        ),
        iconTheme: IconThemeData(color: context.colors.primary),
        backgroundColor: context.colors.surface,
      ),
      backgroundColor: context.colors.background,
      body: Column(
        children: [
          Expanded(
            child: postAsync.when(
              loading: () => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Shimmer.fromColors(
                    baseColor: context.colors.surfaceVariant,
                    highlightColor: context.colors.border,
                    child: Container(
                      height: 200,
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
                    Text(t.community.failed_load_post, style: TextStyle(color: context.colors.textPrimary)),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(postProvider(widget.postId)),
                      child: Text(t.common.retry),
                    ),
                  ],
                ),
              ),
              data: (post) {
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(postProvider(widget.postId));
                    ref.invalidate(postCommentsProvider(widget.postId));
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Post Body Section
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Author Row
                              GestureDetector(
                                onTap: () {
                                  if (post.author != null) {
                                    context.pushRoute(UserProfileRoute(userId: post.author!.customerId));
                                  }
                                },
                                child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Container(
                                      width: 36,
                                      height: 36,
                                      color: context.colors.surfaceVariant,
                                      child: SvgPicture.network(
                                        _getAvatarUrl(post.author?.avatarStyle, post.author?.avatarSeed),
                                        width: 36,
                                        height: 36,
                                        placeholderBuilder: (_) => SizedBox(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          post.author?.displayName ?? t.common.unknown_user,
                                          style: TextStyle(
                                            color: context.colors.textPrimary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              post.author?.username ?? '',
                                              style: TextStyle(color: context.colors.textMuted, fontSize: 13),
                                            ),
                                            SizedBox(width: 4),
                                            Text('·', style: TextStyle(color: context.colors.textMuted)),
                                            SizedBox(width: 4),
                                            Text(
                                              _getTimeAgo(post.createdAt),
                                              style: TextStyle(color: context.colors.textMuted, fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),  // end Row
                              ),  // end GestureDetector
                              SizedBox(height: 16),
                              Text(
                                post.title,
                                style: TextStyle(
                                  color: context.colors.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 12),
                              
                              // Content
                              if (post.contentType == 'TEXT' && post.content.isNotEmpty)
                                Text(
                                  post.content,
                                  style: TextStyle(color: context.colors.textSecondary, fontSize: 14),
                                ),
                              
                              if (post.contentType == 'IMAGE' && post.mediaUrls.isNotEmpty)
                                SizedBox(
                                  height: 280,
                                  child: PageView.builder(
                                    itemCount: post.mediaUrls.length,
                                    itemBuilder: (context, index) {
                                      return CachedNetworkImage(
                                        imageUrl: post.mediaUrls[index],
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) => Container(color: context.colors.surfaceVariant),
                                        errorWidget: (_, __, ___) => Container(
                                          color: context.colors.surfaceVariant,
                                          child: Icon(Icons.broken_image, color: context.colors.textMuted),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              
                              SizedBox(height: 16),
                              
                              // Footer / Vote row
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: context.colors.surfaceVariant,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            await ref.read(socialRepositoryProvider).votePost(post.id, 1);
                                            ref.invalidate(postProvider(widget.postId));
                                            ref.invalidate(feedPostsNotifierProvider);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Icon(
                                              Icons.arrow_upward_rounded,
                                              color: post.userVote == 1 ? context.colors.upvote : context.colors.textMuted,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional.only(end: 8),
                                          child: Text(
                                            '${post.upvotes}',
                                            style: TextStyle(
                                              color: post.userVote == 1 ? context.colors.upvote : context.colors.textMuted,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 1,
                                          height: 14,
                                          color: context.colors.textMuted.withValues(alpha: 0.2),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            await ref.read(socialRepositoryProvider).votePost(post.id, -1);
                                            ref.invalidate(postProvider(widget.postId));
                                            ref.invalidate(feedPostsNotifierProvider);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Icon(
                                              Icons.arrow_downward_rounded,
                                              color: post.userVote == -1 ? context.colors.downvote : context.colors.textMuted,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional.only(end: 10),
                                          child: Text(
                                            '${post.downvotes}',
                                            style: TextStyle(
                                              color: post.userVote == -1 ? context.colors.downvote : context.colors.textMuted,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  if (post.communitySlug.isNotEmpty)
                                    GestureDetector(
                                      onTap: () => context.pushRoute(CommunityRoute(communitySlug: post.communitySlug)),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: context.colors.primary.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Text(
                                          'r/${post.communitySlug}',
                                          style: TextStyle(
                                            color: context.colors.primary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        Divider(color: context.colors.border),
                        
                        // Comments Section
                        Consumer(
                          builder: (context, ref, child) {
                            final commentsAsync = ref.watch(postCommentsProvider(widget.postId));
                            return commentsAsync.when(
                              loading: () => Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(child: CircularProgressIndicator(color: context.colors.primary)),
                              ),
                              error: (e, _) => Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(t.community.error_loading_comments, style: TextStyle(color: context.colors.error)),
                              ),
                              data: (comments) {
                                if (comments.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(32.0),
                                    child: Center(
                                      child: Text(
                                        t.community.no_comments_yet,
                                        style: TextStyle(color: context.colors.textMuted),
                                      ),
                                    ),
                                  );
                                }
                                
                                final rootComments = comments.where((c) => c.parentId == null).toList()
                                  ..sort((a, b) => b.score.compareTo(a.score));
                                  
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: rootComments.length,
                                  itemBuilder: (context, index) {
                                    final root = rootComments[index];
                                    final children1 = comments.where((c) => c.parentId == root.id).toList()
                                      ..sort((a, b) => b.score.compareTo(a.score));
                                      
                                    return Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         CommentTile(
                                           comment: root,
                                           leftPadding: 16.0,
                                           onReply: (replyTo) {
                                             setState(() {
                                               _replyToComment = replyTo;
                                             });
                                             final username = replyTo.author?.username ?? "user";
                                             _commentController.text = '@$username ';
                                             FocusScope.of(context).requestFocus();
                                           },
                                         ),
                                         for (final child1 in children1) ...[
                                           IntrinsicHeight(
                                             child: Row(
                                               crossAxisAlignment: CrossAxisAlignment.stretch,
                                               children: [
                                                 Container(
                                                   width: 2,
                                                   margin: const EdgeInsets.only(left: 27, right: 0),
                                                   color: context.colors.border.withValues(alpha: 0.5),
                                                 ),
                                                 Expanded(
                                                   child: CommentTile(
                                                     comment: child1,
                                                     leftPadding: 8.0,
                                                     onReply: (replyTo) {
                                                       setState(() {
                                                         _replyToComment = replyTo;
                                                       });
                                                       final username = replyTo.author?.username ?? "user";
                                                       _commentController.text = '@$username ';
                                                       FocusScope.of(context).requestFocus();
                                                     },
                                                   ),
                                                 ),
                                               ],
                                             ),
                                           ),
                                           Builder(
                                             builder: (context) {
                                               final children2 = comments.where((c) => c.parentId == child1.id).toList()
                                                 ..sort((a, b) => b.score.compareTo(a.score));
                                               if (children2.isEmpty) return const SizedBox();
                                               return Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   for (final child2 in children2)
                                                     IntrinsicHeight(
                                                       child: Row(
                                                         crossAxisAlignment: CrossAxisAlignment.stretch,
                                                         children: [
                                                           Container(
                                                             width: 2,
                                                             margin: const EdgeInsets.only(left: 27, right: 0),
                                                             color: context.colors.border.withValues(alpha: 0.5),
                                                           ),
                                                           Container(
                                                             width: 2,
                                                             margin: const EdgeInsets.only(left: 19, right: 0),
                                                             color: context.colors.border.withValues(alpha: 0.5),
                                                           ),
                                                           Expanded(
                                                             child: CommentTile(
                                                               comment: child2,
                                                               leftPadding: 8.0,
                                                               onReply: (replyTo) {
                                                                 setState(() {
                                                                   _replyToComment = replyTo;
                                                                 });
                                                                 final username = replyTo.author?.username ?? "user";
                                                                 _commentController.text = '@$username ';
                                                                 FocusScope.of(context).requestFocus();
                                                               },
                                                             ),
                                                           ),
                                                         ],
                                                       ),
                                                     ),
                                                   if (comments.any((c) => children2.map((e)=>e.id).contains(c.parentId)))
                                                     IntrinsicHeight(
                                                       child: Row(
                                                         crossAxisAlignment: CrossAxisAlignment.stretch,
                                                         children: [
                                                           Container(
                                                             width: 2,
                                                             margin: const EdgeInsets.only(left: 27, right: 0),
                                                             color: context.colors.border.withValues(alpha: 0.5),
                                                           ),
                                                           Container(
                                                             width: 2,
                                                             margin: const EdgeInsets.only(left: 19, right: 0),
                                                             color: context.colors.border.withValues(alpha: 0.5),
                                                           ),
                                                           const SizedBox(width: 8),
                                                           Expanded(
                                                             child: Padding(
                                                               padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, top: 4.0),
                                                               child: Text(
                                                                 t.community.view_more_replies,
                                                                 style: TextStyle(color: context.colors.primary, fontSize: 13, fontWeight: FontWeight.bold),
                                                               ),
                                                             ),
                                                           ),
                                                         ],
                                                       ),
                                                     ),
                                                 ],
                                               );
                                             },
                                           ),
                                         ],
                                       ],
                                     );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Comment Input Bar
          Container(
            padding: EdgeInsets.only(
              left: 16, 
              right: 16, 
              top: 12, 
              bottom: MediaQuery.of(context).padding.bottom + 12
            ),
            decoration: BoxDecoration(
              color: context.colors.surface,
              border: Border(top: BorderSide(color: context.colors.border)),
            ),
            child: isAuthenticated
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_replyToComment != null) ...[
                        Row(
                          children: [
                            Icon(Icons.reply, size: 14, color: context.colors.textMuted),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                Localizations.localeOf(context).languageCode == 'ar'
                                    ? 'الرد على @${_replyToComment!.author?.username ?? "user"}'
                                    : 'Replying to @${_replyToComment!.author?.username ?? "user"}',
                                style: TextStyle(
                                  color: context.colors.textMuted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                final username = _replyToComment?.author?.username ?? "user";
                                setState(() {
                                  _replyToComment = null;
                                });
                                final prefix = '@$username ';
                                if (_commentController.text.startsWith(prefix)) {
                                  _commentController.text = _commentController.text.substring(prefix.length);
                                }
                              },
                              child: Icon(Icons.close, size: 16, color: context.colors.textMuted),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 24,
                              height: 24,
                              color: context.colors.surfaceVariant,
                              child: SvgPicture.network(
                                'https://api.dicebear.com/7.x/bottts/svg?seed=$currentUserSeed',
                                width: 24,
                                height: 24,
                                placeholderBuilder: (_) => SizedBox(),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              style: TextStyle(color: context.colors.textPrimary, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: t.community.add_comment,
                                hintStyle: TextStyle(color: context.colors.textMuted),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: context.colors.surfaceVariant,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                isDense: true,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            onPressed: _submitComment,
                            icon: Icon(Icons.send, color: context.colors.primary),
                          ),
                        ],
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      t.community.login_to_comment,
                      style: TextStyle(color: context.colors.textMuted, fontSize: 14),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class CommentTile extends ConsumerWidget {
  final CommentModel comment;
  final Function(CommentModel) onReply;
  final double leftPadding;

  const CommentTile({
    super.key,
    required this.comment,
    required this.onReply,
    this.leftPadding = 16.0,
  });

  String _getTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 365) return t.social.years_short(n: diff.inDays ~/ 365);
    if (diff.inDays > 0) return t.social.days_short(n: diff.inDays);
    if (diff.inHours > 0) return t.social.hours_short(n: diff.inHours);
    if (diff.inMinutes > 0) return t.social.minutes_short(n: diff.inMinutes);
    return t.social.now_short;
  }

  String _getAvatarUrl(String? styleStr, String? seedStr) {
    final style = (styleStr != null && styleStr.isNotEmpty) ? styleStr : 'bottts';
    final seed = (seedStr != null && seedStr.isNotEmpty) ? seedStr : 'default';
    return 'https://api.dicebear.com/7.x/$style/svg?seed=$seed';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding, right: 16.0, top: 8.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (comment.author != null) {
                    context.pushRoute(UserProfileRoute(userId: comment.author!.customerId));
                  }
                },
                child: Row(
                  children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 24,
                  height: 24,
                  color: context.colors.surfaceVariant,
                  child: SvgPicture.network(
                    _getAvatarUrl(comment.author?.avatarStyle, comment.author?.avatarSeed),
                    width: 24,
                    height: 24,
                    placeholderBuilder: (_) => SizedBox(),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                comment.author?.displayName ?? t.common.unknown_user,
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 6),
              Text(
                _getTimeAgo(comment.createdAt),
                style: TextStyle(color: context.colors.textMuted, fontSize: 12),
              ),
                  ],
                ),  // end inner Row
              ),  // end GestureDetector
            ],
          ),  // end outer Row
          SizedBox(height: 6),
          Text(
            comment.content,
            style: TextStyle(color: context.colors.textSecondary, fontSize: 13),
          ),
          SizedBox(height: 6),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  ref.read(socialRepositoryProvider).voteComment(comment.id, 1);
                  ref.invalidate(postCommentsProvider(comment.postId));
                },
                child: Icon(Icons.keyboard_arrow_up, color: context.colors.textMuted, size: 16),
              ),
              SizedBox(width: 4),
              Text(
                '${comment.score}',
                style: TextStyle(
                  color: comment.score > 0 ? context.colors.upvote : comment.score < 0 ? context.colors.downvote : context.colors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  ref.read(socialRepositoryProvider).voteComment(comment.id, -1);
                  ref.invalidate(postCommentsProvider(comment.postId));
                },
                child: Icon(Icons.keyboard_arrow_down, color: context.colors.textMuted, size: 16),
              ),
              SizedBox(width: 16),
              GestureDetector(
                onTap: () => onReply(comment),
                child: Text(
                  t.community.reply,
                  style: TextStyle(color: context.colors.textMuted, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
