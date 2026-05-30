import 'dart:convert';

class CommunityModel {
  final String id, slug, name, title;
  final String? description;
  final bool isPrivate;
  final int memberCount;
  final String createdBy;
  final DateTime createdAt;
  final bool isMember;
  final bool isCreator;

  CommunityModel({
    required this.id,
    required this.slug,
    required this.name,
    required this.title,
    this.description,
    required this.isPrivate,
    required this.memberCount,
    required this.createdBy,
    required this.createdAt,
    required this.isMember,
    required this.isCreator,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    return CommunityModel(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      isPrivate: json['isPrivate'] as bool? ?? false,
      memberCount: json['memberCount'] as int? ?? 0,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isMember: json['isMember'] as bool? ?? false,
      isCreator: json['isCreator'] as bool? ?? false,
    );
  }
}

class PostAuthor {
  final String customerId, username, displayName, avatarStyle, avatarSeed;

  PostAuthor({
    required this.customerId,
    required this.username,
    required this.displayName,
    required this.avatarStyle,
    required this.avatarSeed,
  });

  factory PostAuthor.fromJson(Map<String, dynamic> json) {
    return PostAuthor(
      customerId: json['customerId'] as String,
      username: json['username'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      avatarStyle: json['avatarStyle'] as String? ?? '',
      avatarSeed: json['avatarSeed'] as String? ?? 'Felix',
    );
  }
}

class PostModel {
  final String id, title, content, contentType, authorId, communityId, communitySlug, communityName;
  final int score;
  final bool isFlagged;
  final DateTime createdAt;
  final PostAuthor? author;
  final List<String> mediaUrls;

  PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.contentType,
    required this.authorId,
    required this.communityId,
    required this.communitySlug,
    required this.communityName,
    required this.score,
    required this.isFlagged,
    required this.createdAt,
    this.author,
    required this.mediaUrls,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final cType = json['contentType'] as String? ?? '';
    final contentStr = json['content'] as String? ?? '';
    final community = json['community'] as Map<String, dynamic>?;

    List<String> mUrls = [];
    if (cType == 'IMAGE') {
      mUrls = (json['mediaUrls'] as List<dynamic>? ?? []).map((e) => e.toString()).toList();
    }

    return PostModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: contentStr,
      contentType: cType,
      authorId: json['authorId'] as String,
      communityId: json['communityId'] as String,
      communitySlug: community?['slug'] as String? ?? '',
      communityName: community?['name'] as String? ?? '',
      score: json['score'] as int? ?? 0,
      isFlagged: json['isFlagged'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      author: json['author'] != null ? PostAuthor.fromJson(json['author'] as Map<String, dynamic>) : null,
      mediaUrls: mUrls,
    );
  }
}

class CommentModel {
  final String id, content, authorId, postId;
  final String? parentId;
  final int depth, score;
  final DateTime createdAt;
  final PostAuthor? author;

  CommentModel({
    required this.id,
    required this.content,
    required this.authorId,
    required this.postId,
    this.parentId,
    required this.depth,
    required this.score,
    required this.createdAt,
    this.author,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      content: json['content'] as String,
      authorId: json['authorId'] as String,
      postId: json['postId'] as String,
      parentId: json['parentId'] as String?,
      depth: json['depth'] as int? ?? 0,
      score: json['score'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      author: json['author'] != null ? PostAuthor.fromJson(json['author'] as Map<String, dynamic>) : null,
    );
  }
}

class UserProfileModel {
  final String customerId, username, displayName, bio, avatarStyle, avatarSeed;
  final int followerCount;
  final bool isFollowing;
  final List<PostModel> recentPosts;
  final String? bannerUrl;
  final bool isPrivate;

  UserProfileModel({
    required this.customerId,
    required this.username,
    required this.displayName,
    required this.bio,
    required this.avatarStyle,
    required this.avatarSeed,
    required this.followerCount,
    required this.isFollowing,
    required this.recentPosts,
    this.bannerUrl,
    this.isPrivate = false,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      customerId: json['customerId'] as String,
      username: json['username'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      avatarStyle: json['avatarStyle'] as String? ?? '',
      avatarSeed: json['avatarSeed'] as String? ?? 'Felix',
      followerCount: json['followerCount'] as int? ?? 0,
      isFollowing: json['isFollowing'] as bool? ?? false,
      recentPosts: (json['posts'] as List<dynamic>? ?? [])
          .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      bannerUrl: json['bannerUrl'] as String?,
      isPrivate: json['isPrivate'] as bool? ?? false,
    );
  }
}

class NotificationModel {
  final String id, recipientId, type, message;
  final String? senderId;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.recipientId,
    required this.type,
    required this.message,
    this.senderId,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      recipientId: json['recipientId'] as String,
      type: json['type'] as String,
      message: json['message'] as String,
      senderId: json['senderId'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
