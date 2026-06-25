import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import '../../../../../router/app_router.dart';
import '../../../../../i18n/strings.g.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../../../shared/widgets/post_card.dart';
import '../../../../../shared/widgets/post_card_skeleton.dart';
import '../../../../../shared/widgets/user_avatar.dart';
import '../../../../../core/api/medusa_client.dart';
import '../../../../../core/auth/auth_notifier.dart';
import '../../../providers/social_providers.dart';
import '../../../data/models/social_models.dart';
import '../../../../../shared/widgets/context_aware_scaffold.dart';
import '../../../../../features/social/post/providers/fab_context_provider.dart';

@RoutePage()
class CommunityScreen extends ConsumerStatefulWidget {
  final String communitySlug;

  const CommunityScreen({
    super.key,
    @PathParam('community') required this.communitySlug,
  });

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  final _scrollController = ScrollController();
  String? _communityId;
  bool _joiningOrLeaving = false;
  bool? _isMemberOverride;
  bool? _isPendingOverride;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(communityProvider(widget.communitySlug));
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_communityId != null &&
        _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(feedPostsNotifierProvider(communityId: _communityId).notifier).loadMore();
    }
  }

  void _openSettings(BuildContext context, CommunityModel community) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CommunitySettingsSheet(community: community, ref: ref),
    );
  }

  Widget _bannerPlaceholder(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colors.primary,
            context.colors.primary.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _iconPlaceholder(BuildContext context, String name) {
    return Container(
      color: context.colors.primary.withValues(alpha: 0.1),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'r',
          style: TextStyle(
            color: context.colors.primary,
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final communityState = ref.watch(communityProvider(widget.communitySlug));
    final authState = ref.watch(authNotifierProvider);
    final isWaslaqAdmin = authState.maybeWhen(
      authenticated: (_, __, displayName, ___, ____) =>
          displayName?.toLowerCase().trim() == 'waslaq admin',
      orElse: () => false,
    );

    return ContextAwareScaffold(
      fabContext: FabContextData(communitySlug: widget.communitySlug),
      child: Scaffold(
        body: communityState.when(
          data: (community) {
            final isMember = _isMemberOverride ?? community.isMember;
            final isPending = _isPendingOverride ?? community.isPending;

            if (_communityId != community.id) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => _communityId = community.id);
              });
            }

            final postsState = ref.watch(feedPostsNotifierProvider(communityId: community.id));

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                // ─── Slivers App Bar ───
                SliverAppBar(
                  pinned: true,
                  elevation: 0,
                  backgroundColor: context.colors.surface,
                  foregroundColor: context.colors.textPrimary,
                  title: Text(
                    community.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  actions: [
                    if (isWaslaqAdmin || (community.isCreator && community.slug != 'general' && community.slug != 'product-questions'))
                      IconButton(
                        icon: const Icon(Icons.settings_outlined),
                        onPressed: () => _openSettings(context, community),
                      ),
                  ],
                ),

                // ─── Header Section ───
                SliverToBoxAdapter(
                  child: Container(
                    color: context.colors.surface,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            SizedBox(
                              height: 120,
                              width: double.infinity,
                              child: community.bannerUrl != null && community.bannerUrl!.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: community.bannerUrl!,
                                      fit: BoxFit.cover,
                                      placeholder: (_, __) => Container(color: context.colors.primary.withValues(alpha: 0.1)),
                                      errorWidget: (_, __, ___) => _bannerPlaceholder(context),
                                    )
                                  : _bannerPlaceholder(context),
                            ),
                            Positioned(
                              bottom: -36,
                              right: Directionality.of(context) == TextDirection.rtl ? 16 : null,
                              left: Directionality.of(context) != TextDirection.rtl ? 16 : null,
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: context.colors.surface,
                                  border: Border.all(color: context.colors.surface, width: 4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: community.iconUrl != null && community.iconUrl!.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: community.iconUrl!,
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) => Container(color: context.colors.surfaceVariant),
                                        errorWidget: (_, __, ___) => _iconPlaceholder(context, community.name),
                                      )
                                    : _iconPlaceholder(context, community.name),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 44),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.community.members_count(count: community.memberCount.toString()),
                                style: TextStyle(
                                  color: context.colors.textMuted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(
                                    'r/${community.slug}',
                                    style: TextStyle(
                                      color: context.colors.textPrimary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  if (community.isOfficial) ...[
                                    const SizedBox(width: 6),
                                    Icon(Icons.verified_rounded, size: 20, color: context.colors.primary),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                community.title,
                                style: TextStyle(
                                  color: context.colors.textSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (community.description != null && community.description!.isNotEmpty) ...[
                                const SizedBox(height: 10),
                                Text(
                                  community.description!,
                                  style: TextStyle(
                                    color: context.colors.textPrimary,
                                    fontSize: 13,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),

                              // ─── Join / Leave / Pending / Founder buttons ───
                              Row(
                                children: [
                                  Expanded(
                                    child: community.isCreator
                                        // ponytail: creators can't leave — backend 403 enforces; chip is just the UX signal
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: context.colors.primary.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(color: context.colors.primary.withValues(alpha: 0.3)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.star_rounded, size: 14, color: context.colors.primary),
                                                const SizedBox(width: 6),
                                                Text(
                                                  'مؤسس المجتمع',
                                                  style: TextStyle(
                                                    color: context.colors.primary,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : isMember
                                            ? OutlinedButton.icon(
                                                onPressed: _joiningOrLeaving ? null : () async {
                                                  final confirm = await showDialog<bool>(
                                                    context: context,
                                                    builder: (ctx) => AlertDialog(
                                                      title: Text(t.community.leave_title),
                                                      content: Text(t.community.leave_confirm),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(ctx, false),
                                                          child: Text(t.community.cancel),
                                                        ),
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(ctx, true),
                                                          child: Text(t.community.leave, style: const TextStyle(color: Colors.red)),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                  if (confirm != true) return;

                                                  setState(() {
                                                    _isMemberOverride = false;
                                                    _joiningOrLeaving = true;
                                                  });
                                                  try {
                                                    await ref.read(socialRepositoryProvider).leaveCommunity(widget.communitySlug);
                                                    ref.invalidate(communitiesProvider);
                                                    await ref.refresh(communityProvider(widget.communitySlug).future).then<void>((_) {});
                                                  } catch (e) {
                                                    if (mounted) setState(() => _isMemberOverride = null);
                                                  } finally {
                                                    if (mounted) setState(() => _joiningOrLeaving = false);
                                                  }
                                                },
                                                icon: _joiningOrLeaving
                                                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                                    : const Icon(Icons.check, size: 16),
                                                label: Text(_joiningOrLeaving ? '...' : t.community.joined_checkmark),
                                                style: OutlinedButton.styleFrom(
                                                  foregroundColor: context.colors.textSecondary,
                                                  side: BorderSide(color: context.colors.border),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                                ),
                                              )
                                            : isPending
                                                ? OutlinedButton.icon(
                                                    onPressed: _joiningOrLeaving ? null : () async {
                                                      // Tap again to cancel pending request (toggle endpoint)
                                                      setState(() => _joiningOrLeaving = true);
                                                      try {
                                                        final result = await ref.read(socialRepositoryProvider).joinCommunity(widget.communitySlug);
                                                        setState(() {
                                                          _isMemberOverride = result['joined'];
                                                          _isPendingOverride = result['pending'];
                                                        });
                                                        ref.invalidate(communitiesProvider);
                                                      } catch (e) {
                                                        if (mounted) setState(() => _isPendingOverride = null);
                                                      } finally {
                                                        if (mounted) setState(() => _joiningOrLeaving = false);
                                                      }
                                                    },
                                                    icon: _joiningOrLeaving
                                                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                                        : const Icon(Icons.schedule, size: 16),
                                                    label: Text(_joiningOrLeaving ? '...' : 'تم إرسال الطلب'),
                                                    style: OutlinedButton.styleFrom(
                                                      foregroundColor: context.colors.textMuted,
                                                      side: BorderSide(color: context.colors.border),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                                    ),
                                                  )
                                                : FilledButton(
                                                    onPressed: _joiningOrLeaving ? null : () async {
                                                      setState(() => _joiningOrLeaving = true);
                                                      try {
                                                        final result = await ref.read(socialRepositoryProvider).joinCommunity(widget.communitySlug);
                                                        setState(() {
                                                          _isMemberOverride = result['joined'];
                                                          _isPendingOverride = result['pending'];
                                                        });
                                                        ref.invalidate(communitiesProvider);
                                                        await ref.refresh(communityProvider(widget.communitySlug).future).then<void>((_) {});
                                                      } catch (e) {
                                                        if (mounted) setState(() { _isMemberOverride = null; _isPendingOverride = null; });
                                                      } finally {
                                                        if (mounted) setState(() => _joiningOrLeaving = false);
                                                      }
                                                    },
                                                    style: FilledButton.styleFrom(
                                                      backgroundColor: context.colors.primary,
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                                    ),
                                                    child: _joiningOrLeaving
                                                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                                        : Text(t.community.join),
                                                  ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(height: 8, color: context.colors.surfaceVariant),
                      ],
                    ),
                  ),
                ),

                // ─── Inline post creation box (Bug 3A) ───
                if (isMember || community.isCreator)
                  SliverToBoxAdapter(
                    child: GestureDetector(
                      onTap: () => context.pushRoute(CreatePostRoute(
                        type: PostCreationType.community,
                        preselectedCommunityId: community.id,
                      )),
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: context.colors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: context.colors.border.withValues(alpha: 0.6)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.edit_note_outlined, size: 22, color: context.colors.textMuted),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'ما الذي يدور في ذهنك؟',
                                style: TextStyle(
                                  color: context.colors.textMuted.withValues(alpha: 0.7),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.image_outlined, size: 20, color: context.colors.textMuted),
                          ],
                        ),
                      ),
                    ),
                  ),

                // ─── Post feed ───
                postsState.when(
                  data: (posts) {
                    if (posts.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.article_outlined, size: 48, color: context.colors.textMuted),
                                const SizedBox(height: 12),
                                Text(t.community.no_posts, style: TextStyle(color: context.colors.textMuted)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == posts.length) {
                            final isLoading = ref.watch(feedPostsNotifierProvider(communityId: community.id)).isLoading;
                            return isLoading ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator(color: context.colors.primary)),
                            ) : const SizedBox(height: 24);
                          }
                          final post = posts[index];
                          return PostCard(
                            post: post,
                            onTap: () => context.pushRoute(PostDetailRoute(community: post.communitySlug.isNotEmpty ? post.communitySlug : 'all', postId: post.id)),
                            onVote: (direction) {
                              ref.read(feedPostsNotifierProvider(communityId: community.id).notifier).votePost(post.id, direction);
                            },
                          );
                        },
                        childCount: posts.length + 1,
                      ),
                    );
                  },
                  loading: () => SliverToBoxAdapter(
                    child: Column(
                      children: List.generate(4, (index) => const PostCardSkeleton()),
                    ),
                  ),
                  error: (err, stack) => SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Center(
                        child: Text(t.community.error_loading_posts(error: err.toString()), style: TextStyle(color: context.colors.error)),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: context.colors.error),
                const SizedBox(height: 12),
                Text(
                  err.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.colors.textMuted, fontSize: 13),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => ref.invalidate(communityProvider(widget.communitySlug)),
                  style: FilledButton.styleFrom(backgroundColor: context.colors.primary),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Community Settings Sheet Widget ───
class _CommunitySettingsSheet extends StatefulWidget {
  final CommunityModel community;
  final WidgetRef ref;

  const _CommunitySettingsSheet({required this.community, required this.ref});

  @override
  State<_CommunitySettingsSheet> createState() => _CommunitySettingsSheetState();
}

class _CommunitySettingsSheetState extends State<_CommunitySettingsSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late bool _isPrivate;
  String? _iconUrl;
  String? _bannerUrl;

  bool _uploadingIcon = false;
  bool _uploadingBanner = false;
  bool _saving = false;
  String? _error;

  List<dynamic> _members = [];
  List<dynamic> _filteredMembers = [];
  bool _loadingMembers = true;
  final _memberSearchCtrl = TextEditingController();

  // ─── Pending requests state ───
  List<Map<String, dynamic>> _pendingRequests = [];
  bool _loadingPending = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.community.name);
    _titleCtrl = TextEditingController(text: widget.community.title);
    _descCtrl = TextEditingController(text: widget.community.description ?? '');
    _isPrivate = widget.community.isPrivate;
    _iconUrl = widget.community.iconUrl;
    _bannerUrl = widget.community.bannerUrl;

    _loadMembers();
    _loadPendingRequests();
    _memberSearchCtrl.addListener(_filterMembers);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _memberSearchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadMembers() async {
    if (!mounted) return;
    setState(() => _loadingMembers = true);
    try {
      final res = await MedusaClient.instance.get(
        '/store/social/communities/${widget.community.slug}/members',
      );
      if (mounted) {
        setState(() {
          _members = res.data['members'] as List<dynamic>? ?? [];
          _filteredMembers = _members;
          _loadingMembers = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingMembers = false);
    }
  }

  Future<void> _loadPendingRequests() async {
    if (!mounted) return;
    setState(() => _loadingPending = true);
    try {
      final res = await MedusaClient.instance.get(
        '/store/social/communities/${widget.community.slug}/pending-requests',
      );
      if (mounted) {
        final list = res.data['requests'] as List<dynamic>? ?? [];
        setState(() => _pendingRequests = list.cast<Map<String, dynamic>>());
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loadingPending = false);
    }
  }

  Future<void> _acceptPendingRequest(String memberId) async {
    try {
      await MedusaClient.instance.post(
        '/store/social/communities/${widget.community.slug}/pending-requests/$memberId',
      );
      if (!mounted) return;
      setState(() => _pendingRequests.removeWhere((m) => m['customerId'] == memberId));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم قبول الطلب بنجاح'), backgroundColor: Colors.green),
      );
      widget.ref.invalidate(communityProvider(widget.community.slug));
      _loadMembers();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل قبول الطلب'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _rejectPendingRequest(String memberId) async {
    try {
      await MedusaClient.instance.delete(
        '/store/social/communities/${widget.community.slug}/pending-requests/$memberId',
      );
      if (!mounted) return;
      setState(() => _pendingRequests.removeWhere((m) => m['customerId'] == memberId));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم رفض الطلب'), backgroundColor: Colors.orange),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل رفض الطلب'), backgroundColor: Colors.red),
      );
    }
  }

  void _filterMembers() {
    final query = _memberSearchCtrl.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() => _filteredMembers = _members);
    } else {
      setState(() {
        _filteredMembers = _members.where((m) {
          final dn = (m['displayName'] as String? ?? '').toLowerCase();
          final un = (m['username'] as String? ?? '').toLowerCase();
          return dn.contains(query) || un.contains(query);
        }).toList();
      });
    }
  }

  Future<void> _removeMember(String memberId) async {
    try {
      await MedusaClient.instance.delete(
        '/store/social/communities/${widget.community.slug}/members/$memberId',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إزالة العضو بنجاح'), backgroundColor: Colors.green),
      );
      _loadMembers();
      widget.ref.invalidate(communityProvider(widget.community.slug));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل إزالة العضو'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _banMember(String memberId) async {
    final reasonController = TextEditingController();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حظر عضو'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('هل أنت متأكد من حظر هذا العضو؟ لن يتمكن من المشاركة.'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'سبب الحظر (اختياري)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('حظر', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await MedusaClient.instance.post(
        '/store/social/communities/${widget.community.slug}/members/$memberId/ban',
        data: {'reason': reasonController.text.trim()},
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حظر العضو بنجاح'), backgroundColor: Colors.green),
      );
      _loadMembers();
      widget.ref.invalidate(communityProvider(widget.community.slug));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل حظر العضو'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _unbanMember(String memberId) async {
    try {
      await MedusaClient.instance.delete(
        '/store/social/communities/${widget.community.slug}/members/$memberId/ban',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إلغاء حظر العضو بنجاح'), backgroundColor: Colors.green),
      );
      _loadMembers();
      widget.ref.invalidate(communityProvider(widget.community.slug));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل إلغاء الحظر'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _pickAndUploadImage(bool isBanner) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file == null) return;

    setState(() {
      if (isBanner) { _uploadingBanner = true; } else { _uploadingIcon = true; }
      _error = null;
    });

    try {
      final formData = FormData();
      formData.files.add(MapEntry(
        'files',
        await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      ));

      final uploadRes = await MedusaClient.instance.post(
        '/store/social/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final urls = (uploadRes.data['urls'] as List<dynamic>?)?.map((u) => u.toString()).toList() ?? [];
      if (urls.isNotEmpty) {
        setState(() {
          if (isBanner) { _bannerUrl = urls.first; } else { _iconUrl = urls.first; }
        });
      }
    } catch (e) {
      setState(() => _error = 'فشل تحميل الصورة. حاول مرة أخرى.');
    } finally {
      setState(() {
        _uploadingIcon = false;
        _uploadingBanner = false;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final isDefault = widget.community.slug == 'general' || widget.community.slug == 'product-questions';

      final updated = await widget.ref.read(socialRepositoryProvider).updateCommunity(
        widget.community.slug,
        name: isDefault ? null : _nameCtrl.text.trim(),
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        iconUrl: _iconUrl,
        bannerUrl: _bannerUrl,
        isPrivate: _isPrivate,
      );

      if (mounted) {
        final newSlug = updated.slug;
        widget.ref.invalidate(communityProvider(widget.community.slug));

        Navigator.pop(context);

        if (newSlug != widget.community.slug) {
          context.router.replace(CommunityRoute(communitySlug: newSlug));
        } else {
          widget.ref.invalidate(communityProvider(newSlug));
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ الإعدادات بنجاح'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      setState(() {
        _error = 'فشل حفظ الإعدادات. حاول مرة أخرى.';
        _saving = false;
      });
    }
  }

  // Bug 7 fix: check real avatarUrl before falling back to DiceBear
  Widget _memberAvatar(dynamic member) {
    return UserAvatar(
      fallbackSeed: member['customerId'] as String? ?? 'anon',
      avatarUrl: member['avatarUrl'] as String?,
      avatarStyle: member['avatarStyle'] as String?,
      avatarSeed: member['avatarSeed'] as String?,
      size: 40,
    );
  }

  Widget _pendingAvatar(Map<String, dynamic> member) {
    return UserAvatar(
      fallbackSeed: member['customerId'] as String? ?? 'anon',
      avatarUrl: member['avatarUrl'] as String?,
      avatarStyle: member['avatarStyle'] as String?,
      avatarSeed: member['avatarSeed'] as String?,
      size: 40,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDefault = widget.community.slug == 'general' || widget.community.slug == 'product-questions';

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'إدارة المجتمع',
                    style: TextStyle(
                      color: context.colors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: context.colors.textMuted),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            TabBar(
              isScrollable: true,
              labelColor: context.colors.primary,
              unselectedLabelColor: context.colors.textMuted,
              indicatorColor: context.colors.primary,
              tabAlignment: TabAlignment.start,
              tabs: const [
                Tab(text: 'الإعدادات'),
                Tab(text: 'الأعضاء'),
                Tab(text: 'طلبات الانضمام'),
              ],
            ),

            Expanded(
              child: TabBarView(
                children: [
                  // ─── Tab 1: General Settings ───
                  Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_error != null) ...[
                            Text(_error!, style: TextStyle(color: context.colors.error, fontSize: 13)),
                            const SizedBox(height: 12),
                          ],

                          const Text('صورة الغلاف (الخلفية)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: _uploadingBanner ? null : () => _pickAndUploadImage(true),
                            child: Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: context.colors.surfaceVariant,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: context.colors.border),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: _uploadingBanner
                                  ? const Center(child: CircularProgressIndicator())
                                  : _bannerUrl != null && _bannerUrl!.isNotEmpty
                                      ? CachedNetworkImage(imageUrl: _bannerUrl!, fit: BoxFit.cover)
                                      : const Center(child: Icon(Icons.add_a_photo_outlined, size: 28)),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('أيقونة المجتمع', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  const SizedBox(height: 6),
                                  GestureDetector(
                                    onTap: _uploadingIcon ? null : () => _pickAndUploadImage(false),
                                    child: Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: context.colors.surfaceVariant,
                                        border: Border.all(color: context.colors.border),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: _uploadingIcon
                                          ? const Center(child: CircularProgressIndicator())
                                          : _iconUrl != null && _iconUrl!.isNotEmpty
                                              ? CachedNetworkImage(imageUrl: _iconUrl!, fit: BoxFit.cover)
                                              : const Center(child: Icon(Icons.add_a_photo_outlined, size: 20)),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: Text(
                                  'تغيير صور المجتمع لتخصيص مظهره وجعله مميزاً للجميع.',
                                  style: TextStyle(color: context.colors.textMuted, fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          if (!isDefault) ...[
                            TextFormField(
                              controller: _nameCtrl,
                              style: TextStyle(color: context.colors.textPrimary, fontSize: 14),
                              decoration: InputDecoration(
                                labelText: 'اسم المجتمع الفريد (الرابط)',
                                labelStyle: TextStyle(color: context.colors.textMuted, fontSize: 13),
                                prefixText: 'r/',
                                prefixStyle: TextStyle(color: context.colors.textMuted, fontSize: 14, fontWeight: FontWeight.bold),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) return 'الاسم مطلوب';
                                if (val.contains(' ')) return 'يجب ألا يحتوي الاسم على مسافات';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                          ],

                          TextFormField(
                            controller: _titleCtrl,
                            style: TextStyle(color: context.colors.textPrimary, fontSize: 14),
                            decoration: InputDecoration(
                              labelText: 'عنوان المجتمع (للعرض)',
                              labelStyle: TextStyle(color: context.colors.textMuted, fontSize: 13),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            validator: (val) => val == null || val.trim().isEmpty ? 'العنوان مطلوب' : null,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _descCtrl,
                            style: TextStyle(color: context.colors.textPrimary, fontSize: 14),
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'وصف المجتمع',
                              labelStyle: TextStyle(color: context.colors.textMuted, fontSize: 13),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                          ),
                          const SizedBox(height: 16),

                          SwitchListTile(
                            value: _isPrivate,
                            onChanged: (val) => setState(() => _isPrivate = val),
                            title: const Text('مجتمع خاص', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: const Text('عند تفعيل هذا الخيار، سيتمكن الأعضاء الموافق عليهم فقط من رؤية المشاركات والمحتوى.', style: TextStyle(fontSize: 11)),
                            contentPadding: EdgeInsets.zero,
                            activeThumbColor: context.colors.primary,
                          ),
                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: _saving || _uploadingIcon || _uploadingBanner ? null : _save,
                              style: FilledButton.styleFrom(
                                backgroundColor: context.colors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: _saving
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text('حفظ التغييرات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ─── Tab 2: Members ───
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextField(
                          controller: _memberSearchCtrl,
                          style: TextStyle(color: context.colors.textPrimary, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'البحث عن عضو بالاسم...',
                            hintStyle: TextStyle(color: context.colors.textMuted, fontSize: 13),
                            prefixIcon: Icon(Icons.search, size: 18, color: context.colors.textMuted),
                            filled: true,
                            fillColor: context.colors.surfaceVariant,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),

                      Expanded(
                        child: _loadingMembers
                            ? Center(child: CircularProgressIndicator(color: context.colors.primary))
                            : _filteredMembers.isEmpty
                                ? Center(
                                    child: Text(
                                      'لا يوجد أعضاء مطابقين للبحث',
                                      style: TextStyle(color: context.colors.textMuted, fontSize: 13),
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: _filteredMembers.length,
                                    separatorBuilder: (_, __) => const Divider(height: 1),
                                    itemBuilder: (ctx, idx) {
                                      final m = _filteredMembers[idx];
                                      final displayName = m['displayName'] as String? ?? '';
                                      final username = m['username'] as String? ?? '';
                                      final customerId = m['customerId'] as String;
                                      final isBanned = m['isBanned'] as bool? ?? false;
                                      final banReason = m['banReason'] as String?;
                                      final isOwner = customerId == widget.community.createdBy;

                                      return ListTile(
                                        leading: _memberAvatar(m),
                                        title: Text(
                                          displayName.isNotEmpty ? displayName : (username.isNotEmpty ? 'r/$username' : 'مستخدم'),
                                          style: TextStyle(
                                            color: context.colors.textPrimary,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (username.isNotEmpty)
                                              Text('@$username', style: TextStyle(color: context.colors.textMuted, fontSize: 11)),
                                            if (isOwner)
                                              Text('مؤسس المجتمع (Owner)', style: TextStyle(color: context.colors.primary, fontSize: 10, fontWeight: FontWeight.bold))
                                            else if (isBanned)
                                              Text('محظور: ${banReason ?? "لا يوجد سبب"}', style: const TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.w600)),
                                          ],
                                        ),
                                        trailing: isOwner
                                            ? null
                                            : Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  if (!isBanned) ...[
                                                    IconButton(
                                                      icon: const Icon(Icons.person_remove_outlined, color: Colors.orange, size: 20),
                                                      tooltip: 'إزالة العضو',
                                                      onPressed: () => _removeMember(customerId),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(Icons.block_outlined, color: Colors.red, size: 20),
                                                      tooltip: 'حظر العضو',
                                                      onPressed: () => _banMember(customerId),
                                                    ),
                                                  ] else ...[
                                                    IconButton(
                                                      icon: const Icon(Icons.lock_open_outlined, color: Colors.green, size: 20),
                                                      tooltip: 'إلغاء حظر العضو',
                                                      onPressed: () => _unbanMember(customerId),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ),

                  // ─── Tab 3: Pending Join Requests (Bug 3B) ───
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'طلبات الانضمام المعلقة',
                              style: TextStyle(
                                color: context.colors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (_pendingRequests.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: context.colors.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${_pendingRequests.length}',
                                  style: TextStyle(color: context.colors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                            IconButton(
                              icon: Icon(Icons.refresh, size: 18, color: context.colors.textMuted),
                              onPressed: _loadPendingRequests,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _loadingPending
                            ? Center(child: CircularProgressIndicator(color: context.colors.primary))
                            : _pendingRequests.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.how_to_reg_outlined, size: 48, color: context.colors.textMuted.withValues(alpha: 0.4)),
                                        const SizedBox(height: 12),
                                        Text(
                                          widget.community.isPrivate
                                              ? 'لا توجد طلبات انضمام معلقة'
                                              : 'المجتمع عام — لا توجد طلبات',
                                          style: TextStyle(color: context.colors.textMuted, fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.separated(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    itemCount: _pendingRequests.length,
                                    separatorBuilder: (_, __) => const Divider(height: 1),
                                    itemBuilder: (ctx, idx) {
                                      final m = _pendingRequests[idx];
                                      final displayName = m['displayName'] as String? ?? '';
                                      final username = m['username'] as String? ?? '';
                                      final customerId = m['customerId'] as String;

                                      return ListTile(
                                        leading: _pendingAvatar(m),
                                        title: Text(
                                          displayName.isNotEmpty ? displayName : (username.isNotEmpty ? '@$username' : 'مستخدم'),
                                          style: TextStyle(
                                            color: context.colors.textPrimary,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: username.isNotEmpty
                                            ? Text('@$username', style: TextStyle(color: context.colors.textMuted, fontSize: 11))
                                            : null,
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Accept button
                                            IconButton(
                                              icon: const Icon(Icons.check_circle_outline, color: Colors.green, size: 26),
                                              tooltip: 'قبول الطلب',
                                              onPressed: () => _acceptPendingRequest(customerId),
                                            ),
                                            // Reject button
                                            IconButton(
                                              icon: const Icon(Icons.cancel_outlined, color: Colors.red, size: 26),
                                              tooltip: 'رفض الطلب',
                                              onPressed: () => _rejectPendingRequest(customerId),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
