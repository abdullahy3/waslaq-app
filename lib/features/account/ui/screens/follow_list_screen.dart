// lib/features/account/ui/screens/follow_list_screen.dart
// Followers / Following lists for a profile. The owner can remove a follower
// or block a user inline; everyone can tap a row to open that user's profile.

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../i18n/strings.g.dart';
import '../../../../router/app_router.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/utils/app_snack.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../social/data/models/social_models.dart';
import '../../../social/providers/social_providers.dart';

@RoutePage()
class FollowListScreen extends ConsumerStatefulWidget {
  final String userId;
  final int initialIndex;
  final bool isOwner;

  const FollowListScreen({
    super.key,
    @PathParam('userId') required this.userId,
    this.initialIndex = 0,
    this.isOwner = false,
  });

  @override
  ConsumerState<FollowListScreen> createState() => _FollowListScreenState();
}

class _FollowListScreenState extends ConsumerState<FollowListScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialIndex.clamp(0, 1),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
        title: Text(t.connections.title,
            style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: context.colors.primary,
          labelColor: context.colors.primary,
          unselectedLabelColor: context.colors.textMuted,
          tabs: [
            Tab(text: t.connections.followers),
            Tab(text: t.connections.following),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _FollowList(
            userId: widget.userId,
            mode: _ListMode.followers,
            isOwner: widget.isOwner,
          ),
          _FollowList(
            userId: widget.userId,
            mode: _ListMode.following,
            isOwner: widget.isOwner,
          ),
        ],
      ),
    );
  }
}

enum _ListMode { followers, following }

class _FollowList extends ConsumerStatefulWidget {
  final String userId;
  final _ListMode mode;
  final bool isOwner;

  const _FollowList({required this.userId, required this.mode, required this.isOwner});

  @override
  ConsumerState<_FollowList> createState() => _FollowListState();
}

class _FollowListState extends ConsumerState<_FollowList>
    with AutomaticKeepAliveClientMixin {
  final _scroll = ScrollController();
  final List<SocialUserLite> _users = [];
  final Set<String> _removed = {}; // customerIds removed/blocked this session

  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  Object? _error;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _load(reset: true);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300) {
      _loadMore();
    }
  }

  Future<List<SocialUserLite>> _fetch(int skip) {
    final repo = ref.read(socialRepositoryProvider);
    return widget.mode == _ListMode.followers
        ? repo.getFollowers(widget.userId, skip: skip)
        : repo.getFollowing(widget.userId, skip: skip);
  }

  Future<void> _load({bool reset = false}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await _fetch(0);
      if (!mounted) return;
      setState(() {
        _users
          ..clear()
          ..addAll(list);
        _hasMore = list.length >= 30;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || !_hasMore || _loading) return;
    setState(() => _loadingMore = true);
    try {
      final list = await _fetch(_users.length);
      if (!mounted) return;
      setState(() {
        _users.addAll(list);
        _hasMore = list.length >= 30;
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
    }
  }

  Future<void> _removeFollower(SocialUserLite u) async {
    final ok = await _confirm(
      title: t.connections.remove_follower,
      message: t.connections.remove_follower_confirm(name: u.displayName),
      confirmLabel: t.connections.remove,
    );
    if (ok != true) return;
    try {
      await ref.read(socialRepositoryProvider).removeFollower(u.customerId);
      if (!mounted) return;
      setState(() => _removed.add(u.customerId));
      AppSnack.success(context, t.connections.removed);
    } catch (e) {
      if (mounted) AppSnack.error(context, e);
    }
  }

  Future<void> _block(SocialUserLite u) async {
    final ok = await _confirm(
      title: t.connections.block,
      message: t.connections.block_confirm(name: u.displayName),
      confirmLabel: t.connections.block,
      destructive: true,
    );
    if (ok != true) return;
    try {
      await ref.read(socialRepositoryProvider).blockUser(u.customerId);
      if (!mounted) return;
      setState(() => _removed.add(u.customerId));
      AppSnack.success(context, t.connections.blocked);
    } catch (e) {
      if (mounted) AppSnack.error(context, e);
    }
  }

  Future<bool?> _confirm({
    required String title,
    required String message,
    required String confirmLabel,
    bool destructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: Text(title, style: TextStyle(color: context.colors.textPrimary)),
        content: Text(message, style: TextStyle(color: context.colors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t.common.cancel, style: TextStyle(color: context.colors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmLabel,
                style: TextStyle(
                    color: destructive ? context.colors.error : context.colors.primary,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_loading) {
      return Center(child: CircularProgressIndicator(color: context.colors.primary));
    }
    if (_error != null) {
      return ErrorView(error: _error, onRetry: () => _load(reset: true));
    }

    final visible = _users.where((u) => !_removed.contains(u.customerId)).toList();
    if (visible.isEmpty) {
      return Center(
        child: Text(
          widget.mode == _ListMode.followers
              ? t.connections.no_followers
              : t.connections.no_following,
          style: TextStyle(color: context.colors.textMuted),
        ),
      );
    }

    return RefreshIndicator(
      color: context.colors.primary,
      onRefresh: () => _load(reset: true),
      child: ListView.builder(
        controller: _scroll,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: visible.length + (_loadingMore ? 1 : 0),
        itemBuilder: (context, i) {
          if (i >= visible.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }
          return _row(visible[i]);
        },
      ),
    );
  }

  Widget _row(SocialUserLite u) {
    final canManage = widget.isOwner && !u.isMe;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: () => context.router.push(UserProfileRoute(userId: u.customerId)),
      leading: UserAvatar(
        fallbackSeed: u.customerId,
        avatarUrl: u.avatarUrl,
        avatarStyle: u.avatarStyle,
        avatarSeed: u.avatarSeed,
        size: 44,
      ),
      title: Text(
        u.displayName.isNotEmpty ? u.displayName : u.username,
        style: TextStyle(color: context.colors.textPrimary, fontWeight: FontWeight.w600),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: u.username.isNotEmpty
          ? Text('@${u.username}',
              style: TextStyle(color: context.colors.textMuted, fontSize: 13))
          : null,
      trailing: canManage
          ? PopupMenuButton<String>(
              icon: Icon(Icons.more_horiz, color: context.colors.textMuted),
              color: context.colors.surface,
              onSelected: (v) {
                if (v == 'remove') _removeFollower(u);
                if (v == 'block') _block(u);
              },
              itemBuilder: (_) => [
                if (widget.mode == _ListMode.followers)
                  PopupMenuItem(
                    value: 'remove',
                    child: Text(t.connections.remove_follower,
                        style: TextStyle(color: context.colors.textPrimary)),
                  ),
                PopupMenuItem(
                  value: 'block',
                  child: Text(t.connections.block,
                      style: TextStyle(color: context.colors.error)),
                ),
              ],
            )
          : Icon(Icons.chevron_right, color: context.colors.textMuted, size: 18),
    );
  }
}
