import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/api/medusa_client.dart';
import '../../../../router/app_router.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';

// Data models
class _ProductHit {
  final String id, title;
  final String? description, thumbnail;
  const _ProductHit({required this.id, required this.title, this.description, this.thumbnail});
}

class _VendorHit {
  final String id, storeName, slug;
  final String? description, logoUrl;
  const _VendorHit({required this.id, required this.storeName, required this.slug, this.description, this.logoUrl});
}

class _CommunityHit {
  final String id, name;
  final String? description;
  const _CommunityHit({required this.id, required this.name, this.description});
}

class _UserHit {
  final String id, displayName;
  const _UserHit({required this.id, required this.displayName});
}

class _PostHit {
  final String id, title, authorDisplayName, communitySlug;
  final int score;
  const _PostHit({required this.id, required this.title, required this.authorDisplayName, required this.score, required this.communitySlug});
}

@RoutePage()
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';
  Timer? _debounce;
  bool _loading = false;

  List<_ProductHit> _products = [];
  List<_VendorHit> _vendors = [];
  List<_CommunityHit> _communities = [];
  List<_UserHit> _users = [];
  List<_PostHit> _posts = [];

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() => _query = value.trim());
      if (value.trim().isNotEmpty) _performSearch(value.trim());
      else setState(() { _products = []; _vendors = []; _communities = []; _users = []; _posts = []; });
    });
  }

  Future<void> _performSearch(String q) async {
    setState(() => _loading = true);
    try {
      final res = await MedusaClient.instance.get(
        '/store/search',
        queryParameters: {'q': q},
      );
      final d = res.data as Map<String, dynamic>;
      setState(() {
        _products = ((d['products'] as List?) ?? []).map((e) => _ProductHit(
          id: e['id'] ?? '', title: e['title'] ?? '',
          description: e['description'], thumbnail: e['thumbnail'],
        )).toList();
        _vendors = ((d['vendors'] as List?) ?? []).map((e) => _VendorHit(
          id: e['id'] ?? '', storeName: e['store_name'] ?? '',
          slug: e['slug'] ?? '', description: e['description'], logoUrl: e['logo_url'],
        )).toList();
        _communities = ((d['communities'] as List?) ?? []).map((e) => _CommunityHit(
          id: e['id'] ?? '', name: e['name'] ?? e['slug'] ?? '', description: e['description'],
        )).toList();
        _users = ((d['users'] as List?) ?? []).map((e) => _UserHit(
          id: e['customerId'] ?? '', displayName: e['displayName'] ?? e['username'] ?? '',
        )).toList();
        _posts = ((d['posts'] as List?) ?? []).map((e) => _PostHit(
          id: e['id'] ?? '', title: e['title'] ?? '',
          authorDisplayName: e['authorDisplayName'] ?? '', score: e['score'] ?? 0,
          communitySlug: e['communitySlug'] ?? '',
        )).toList();
      });
    } catch (_) {
      // silently fail — keep previous results
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.colors.border, width: 0.5)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: context.colors.textPrimary),
            onPressed: () => context.router.maybePop(),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: true,
              style: TextStyle(color: context.colors.textPrimary, fontSize: 15),
              cursorColor: context.colors.primary,
              decoration: InputDecoration(
                hintText: t.search.placeholder,
                hintStyle: TextStyle(color: context.colors.textMuted, fontSize: 15),
                border: InputBorder.none,
                filled: true,
                fillColor: context.colors.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          if (_query.isNotEmpty)
            IconButton(
              icon: Icon(Icons.close, color: context.colors.textSecondary),
              onPressed: () {
                _controller.clear();
                setState(() {
                  _query = '';
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_query.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_rounded, size: 64, color: context.colors.border),
          SizedBox(height: 16),
          Text(t.search.initial_title, style: TextStyle(color: context.colors.textSecondary, fontSize: 16)),
          Text(t.search.initial_subtitle, style: TextStyle(color: context.colors.textSecondary, fontSize: 16)),
        ],
      );
    }

    if (_loading) {
      return Center(child: CircularProgressIndicator(color: context.colors.primary));
    }

    final bool hasResults = _products.isNotEmpty ||
        _vendors.isNotEmpty ||
        _communities.isNotEmpty ||
        _users.isNotEmpty ||
        _posts.isNotEmpty;

    if (!hasResults) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🔍', style: TextStyle(fontSize: 48)),
          SizedBox(height: 16),
          Text(t.search.no_results_query(query: _query), style: TextStyle(color: context.colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(t.search.try_different, style: TextStyle(color: context.colors.textSecondary, fontSize: 14)),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        if (_products.isNotEmpty) ...[
          _SectionHeader(title: t.search.products, emoji: '🛍️', count: _products.length),
          ..._products.map((p) => _ProductCard(hit: p)),
        ],
        if (_vendors.isNotEmpty) ...[
          _SectionHeader(title: t.search.vendor_stores, emoji: '🏪', count: _vendors.length),
          ..._vendors.map((v) => _VendorCard(vendor: v)),
        ],
        if (_communities.isNotEmpty) ...[
          _SectionHeader(title: t.search.communities, emoji: '🌐', count: _communities.length),
          ..._communities.map((c) => _CommunityCard(community: c)),
        ],
        if (_users.isNotEmpty) ...[
          _SectionHeader(title: t.search.users, emoji: '👤', count: _users.length),
          ..._users.map((u) => _UserCard(user: u)),
        ],
        if (_posts.isNotEmpty) ...[
          _SectionHeader(title: t.search.posts, emoji: '📝', count: _posts.length),
          ..._posts.map((p) => _PostCard(post: p)),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String emoji;
  final int count;

  const _SectionHeader({required this.title, required this.emoji, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 16)),
          SizedBox(width: 8),
          Text(title, style: TextStyle(color: context.colors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold)),
          SizedBox(width: 6),
          Text('($count)', style: TextStyle(color: context.colors.textMuted, fontSize: 13)),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final _ProductHit hit;
  const _ProductCard({required this.hit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.push(ProductRoute(id: hit.id)),
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(11)),
              ),
              clipBehavior: Clip.hardEdge,
              child: hit.thumbnail != null && hit.thumbnail!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: hit.thumbnail!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: context.colors.surfaceVariant),
                      errorWidget: (context, url, error) => Container(color: context.colors.surfaceVariant),
                    )
                  : Container(color: context.colors.surfaceVariant),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hit.title, style: TextStyle(color: context.colors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4),
                  if (hit.description != null)
                    Text(hit.description!, style: TextStyle(color: context.colors.textMuted, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: context.colors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(t.search.type_product, style: TextStyle(color: context.colors.primary, fontSize: 10)),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

class _VendorCard extends StatelessWidget {
  final _VendorHit vendor;
  const _VendorCard({required this.vendor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.push(VendorProfileRoute(slug: vendor.slug)),
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            SizedBox(width: 4),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.surfaceVariant,
              ),
              clipBehavior: Clip.hardEdge,
              child: vendor.logoUrl != null && vendor.logoUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: vendor.logoUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: context.colors.surfaceVariant),
                      errorWidget: (context, url, error) => _buildPlaceholder(context),
                    )
                  : _buildPlaceholder(context),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vendor.storeName, style: TextStyle(color: context.colors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4),
                  if (vendor.description != null)
                    Text(vendor.description!, style: TextStyle(color: context.colors.textMuted, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(t.search.type_store, style: TextStyle(color: Colors.blue, fontSize: 10)),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Center(
      child: Text(
        vendor.storeName.isNotEmpty ? vendor.storeName[0].toUpperCase() : '?',
        style: TextStyle(color: context.colors.primary, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  final _CommunityHit community;
  const _CommunityCard({required this.community});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.push(CommunityRoute(communitySlug: community.name)),
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            SizedBox(width: 4),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.surfaceVariant,
              ),
              child: Center(
                child: Text(
                  'r/',
                  style: TextStyle(color: Colors.orange, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('r/${community.name}', style: TextStyle(color: context.colors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4),
                  if (community.description != null)
                    Text(community.description!, style: TextStyle(color: context.colors.textMuted, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(t.search.type_community, style: const TextStyle(color: Colors.orange, fontSize: 10)),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final _UserHit user;
  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.push(UserProfileRoute(userId: user.id)),
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.border),
        ),
        child: Row(
          children: [
            SizedBox(width: 4),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.surfaceVariant,
              ),
              child: Center(
                child: Text(
                  user.displayName.isNotEmpty ? user.displayName[0].toUpperCase() : '?',
                  style: TextStyle(color: context.colors.primary, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('u/${user.displayName}', style: TextStyle(color: context.colors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: context.colors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(t.search.type_user, style: TextStyle(color: context.colors.primary, fontSize: 10)),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final _PostHit post;
  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.push(PostDetailRoute(community: post.communitySlug.isNotEmpty ? post.communitySlug : 'general', postId: post.id)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title, style: TextStyle(color: context.colors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(t.search.post_author_votes(author: post.authorDisplayName, score: post.score.toString()), style: TextStyle(color: context.colors.textMuted, fontSize: 12)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(t.search.type_post, style: const TextStyle(color: Colors.grey, fontSize: 10)),
            ),
          ],
        ),
      ),
    );
  }
}
