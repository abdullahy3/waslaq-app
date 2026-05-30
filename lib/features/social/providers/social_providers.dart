import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/social_client.dart';
import '../data/social_repository.dart';
import '../data/models/social_models.dart';

part 'social_providers.g.dart';

@riverpod
Dio socialClient(Ref ref) {
  return SocialClient.instance;
}

@riverpod
SocialRepository socialRepository(Ref ref) {
  final client = ref.watch(socialClientProvider);
  return SocialRepository(client);
}

@riverpod
Future<List<CommunityModel>> communities(Ref ref) {
  return ref.watch(socialRepositoryProvider).getCommunities();
}

@riverpod
Future<CommunityModel> community(Ref ref, String slug) {
  return ref.watch(socialRepositoryProvider).getCommunity(slug);
}

@riverpod
class FeedPostsNotifier extends _$FeedPostsNotifier {
  static const _pageSize = 20;

  @override
  Future<List<PostModel>> build({String? communityId, String sort = 'hot'}) async {
    return _fetch(offset: 0);
  }

  Future<List<PostModel>> _fetch({required int offset}) {
    return ref.read(socialRepositoryProvider).getPosts(
      communityId: communityId,
      limit: _pageSize,
      offset: offset,
      sort: sort,
    );
  }

  Future<void> loadMore() async {
    // Don't set AsyncLoading — it replaces the list with skeleton and resets scroll.
    if (state.isLoading) return;
    final currentPosts = state.valueOrNull ?? [];
    if (currentPosts.isEmpty) return;
    try {
      final newPosts = await _fetch(offset: currentPosts.length);
      if (newPosts.isNotEmpty) {
        state = AsyncData([...currentPosts, ...newPosts]);
      }
    } catch (_) {
      // silently ignore pagination errors — keep existing posts visible
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch(offset: 0));
  }
}

@riverpod
Future<PostModel> post(Ref ref, String postId) {
  return ref.watch(socialRepositoryProvider).getPost(postId);
}

@riverpod
Future<UserProfileModel> userProfile(Ref ref, String userId) {
  return ref.watch(socialRepositoryProvider).getProfile(userId);
}

@riverpod
Future<List<NotificationModel>> notifications(Ref ref) {
  return ref.watch(socialRepositoryProvider).getNotifications();
}
