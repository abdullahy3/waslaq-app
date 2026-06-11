import 'package:dio/dio.dart';
import '../../../core/error/app_exception.dart';
import 'models/social_models.dart';

class SocialRepository {
  final Dio _socialClient;

  SocialRepository(this._socialClient);

  // Communities
  Future<List<CommunityModel>> getCommunities() async {
    try {
      final response = await _socialClient.get('/store/social/communities');
      final data = response.data['communities'] as List;
      return data.map((e) => CommunityModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<CommunityModel> createCommunity({
    required String name,
    required String title,
    String? description,
    bool isPrivate = false,
  }) async {
    try {
      final response = await _socialClient.post('/store/social/communities', data: {
        'name': name,
        'title': title,
        if (description != null) 'description': description,
        'isPrivate': isPrivate,
      });
      return CommunityModel.fromJson(response.data['community'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<CommunityModel> getCommunity(String slug) async {
    try {
      final response = await _socialClient.get('/store/social/communities/$slug');
      final data = Map<String, dynamic>.from(response.data['community'] as Map);
      data['isMember'] = response.data['isMember'];
      data['isCreator'] = response.data['isCreator'];
      return CommunityModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> joinCommunity(String slug) async {
    try {
      await _socialClient.post('/store/social/communities/$slug/join');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> leaveCommunity(String slug) async {
    try {
      // The backend uses /join as a toggle for both join and leave actions
      await _socialClient.post('/store/social/communities/$slug/join');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<CommunityModel> updateCommunity(
    String slug, {
    String? name,
    String? title,
    String? description,
    String? iconUrl,
    String? bannerUrl,
    bool? isPrivate,
  }) async {
    try {
      final response = await _socialClient.patch('/store/social/communities/$slug', data: {
        if (name != null) 'name': name,
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (iconUrl != null) 'iconUrl': iconUrl,
        if (bannerUrl != null) 'bannerUrl': bannerUrl,
        if (isPrivate != null) 'isPrivate': isPrivate,
      });
      return CommunityModel.fromJson(response.data['community'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Posts
  Future<List<PostModel>> getPosts({
    String? communityId,
    int limit = 20,
    int offset = 0,
    String sort = 'hot',
  }) async {
    try {
      final queryParams = {
        if (communityId != null) 'communityId': communityId,
        'limit': limit,
        'offset': offset,
        'sort': sort,
      };
      final response = await _socialClient.get('/store/social/posts', queryParameters: queryParams);
      final data = response.data['posts'] as List;
      return data.map((e) => PostModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<PostModel> getPost(String postId) async {
    try {
      final response = await _socialClient.get('/store/social/posts/$postId');
      return PostModel.fromJson(response.data['post'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<PostModel> createPost({
    required String title,
    required String content,
    required String contentType,
    required String communityId,
    String? productId,
  }) async {
    try {
      final response = await _socialClient.post('/store/social/posts', data: {
        'title': title,
        'content': content,
        'contentType': contentType,
        'communityId': communityId,
        'productId': productId,
      });
      return PostModel.fromJson(response.data['post'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> votePost(String postId, int value) async {
    try {
      await _socialClient.post('/store/social/posts/$postId/vote', data: {'value': value});
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Comments
  Future<List<CommentModel>> getComments(String postId) async {
    try {
      final response = await _socialClient.get('/store/social/posts/$postId');
      final data = response.data['comments'] as List;
      return data.map((e) => CommentModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<CommentModel> createComment({
    required String postId,
    required String content,
    String? parentId,
  }) async {
    try {
      final response = await _socialClient.post('/store/social/comments', data: {
        'postId': postId,
        'content': content,
        if (parentId != null) 'parentId': parentId,
      });
      return CommentModel.fromJson(response.data['comment'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> voteComment(String commentId, int value) async {
    try {
      await _socialClient.post('/store/social/comments/$commentId/vote', data: {'value': value});
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Profiles
  Future<UserProfileModel> getProfile(String userId) async {
    try {
      final response = await _socialClient.get('/store/social/profiles/$userId');
      final map = {
        ...response.data['profile'] as Map<String, dynamic>,
        'posts': response.data['posts'],
        'comments': response.data['comments'],
        'mediaPosts': response.data['mediaPosts'],
        'isFollowing': response.data['isFollowing'] ?? false,
      };
      return UserProfileModel.fromJson(map);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> toggleFollow(String userId) async {
    try {
      await _socialClient.post('/store/social/follow/$userId');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Notifications
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _socialClient.get('/store/social/notifications');
      final listData = response.data is List ? response.data as List : (response.data['notifications'] ?? []) as List;
      return listData.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> markAllNotificationsRead() async {
    try {
      await _socialClient.patch('/store/social/notifications');
    } catch (_) {}
  }

  Future<List<Map<String, dynamic>>> getFollowingStores() async {
    try {
      final response = await _socialClient.get('/store/social/following-stores');
      final stores = response.data['stores'] as List<dynamic>? ?? [];
      return stores.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<bool> toggleStoreFollow(String vendorCustomerId) async {
    try {
      final response = await _socialClient.post('/store/social/follow/$vendorCustomerId');
      return response.data['following'] as bool? ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> toggleStoreNotifications(String vendorCustomerId) async {
    try {
      final response = await _socialClient.patch('/store/social/follow/$vendorCustomerId');
      return response.data['notificationsEnabled'] as bool? ?? true;
    } catch (_) {
      return true;
    }
  }

  Future<void> markNotificationRead(String notifId) async {
    try {
      await _socialClient.post('/store/social/notifications/$notifId/read');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<String> queryAssistant({
    required String message,
    List<Map<String, dynamic>> history = const [],
  }) async {
    try {
      final response = await _socialClient.post('/store/social/assistant', data: {
        'message': message,
        'history': history,
      });
      return response.data['reply'] as String? ?? '';
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }


  Exception _handleDioError(DioException e) {
    if (e.error is AppException) {
      return e.error as AppException;
    }
    final message = (e.response?.data is Map)
        ? (e.response?.data as Map)['message']?.toString()
        : null;
    return AppException(
      message: message ?? e.message ?? 'Unknown error',
      statusCode: e.response?.statusCode,
      endpoint: e.requestOptions.path,
    );
  }
}
