import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../router/app_router.dart';
import '../../../../../i18n/strings.g.dart';
import '../../../../../shared/theme/app_colors.dart';
import '../../../data/models/social_models.dart';
import '../../../providers/social_providers.dart';

@RoutePage()
class CommunityExploreScreen extends ConsumerWidget {
  const CommunityExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communitiesState = ref.watch(communitiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.community.explore_communities),
      ),
      body: communitiesState.when(
        data: (communities) {
          if (communities.isEmpty) {
            return Center(
              child: Text(t.community.no_communities_found, style: TextStyle(color: context.colors.textMuted)),
            );
          }
          return RefreshIndicator(
            color: context.colors.primary,
            onRefresh: () async => ref.invalidate(communitiesProvider),
            child: ListView.separated(
              itemCount: communities.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return _CommunityListTile(community: communities[index]);
              },
            ),
          );
        },
        loading: () => ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => Shimmer.fromColors(
            baseColor: context.colors.surfaceVariant,
            highlightColor: context.colors.border,
            child: Container(
              height: 80,
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: context.colors.error, size: 48),
              SizedBox(height: 16),
              Text(err.toString(), style: TextStyle(color: context.colors.textMuted)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(communitiesProvider),
                child: Text(t.common.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommunityListTile extends ConsumerWidget {
  final CommunityModel community;

  const _CommunityListTile({required this.community});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: context.colors.primary,
        child: Text(
          community.name.isNotEmpty ? community.name.substring(0, 1).toUpperCase() : '?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        community.title,
        style: TextStyle(
          color: context.colors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          'r/${community.slug} · ${t.community.members_count(count: community.memberCount.toString())}',
          style: TextStyle(
            color: context.colors.textMuted,
            fontSize: 13,
          ),
        ),
      ),
      trailing: community.isMember
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: context.colors.border),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(t.community.joined, style: TextStyle(color: context.colors.textSecondary, fontSize: 12)),
            )
          : FilledButton(
              onPressed: () async {
                await ref.read(socialRepositoryProvider).joinCommunity(community.slug);
                ref.invalidate(communitiesProvider);
              },
              style: FilledButton.styleFrom(
                backgroundColor: context.colors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                minimumSize: const Size(60, 32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(t.community.join, style: const TextStyle(fontSize: 12)),
            ),
      onTap: () => context.pushRoute(CommunityRoute(communitySlug: community.slug)),
    );
  }
}
