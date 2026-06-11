enum PostCreationType {
  general,        // auto community: r/general
  community,      // user picks community (required)
  productShare,   // product picker → any community
  productQuestion // product picker → auto: r/product-questions
}

class CommunityModel {
  final String id, slug, name, title;
  final String? description;
  final bool isPrivate;
  final int memberCount;
  final String createdBy;
  final DateTime createdAt;
  final bool isMember;
  final bool isCreator;
  final String? iconUrl;
  final String? bannerUrl;

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
    this.iconUrl,
    this.bannerUrl,
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
      iconUrl: json['iconUrl'] as String?,
      bannerUrl: json['bannerUrl'] as String?,
    );
  }
}

class PostAuthor {
  final String customerId, username, displayName, avatarStyle, avatarSeed;
  final String? avatarUrl;

  PostAuthor({
    required this.customerId,
    required this.username,
    required this.displayName,
    required this.avatarStyle,
    required this.avatarSeed,
    this.avatarUrl,
  });

  factory PostAuthor.fromJson(Map<String, dynamic> json) {
    return PostAuthor(
      customerId: json['customerId'] as String,
      username: json['username'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      avatarStyle: json['avatarStyle'] as String? ?? '',
      avatarSeed: json['avatarSeed'] as String? ?? 'Felix',
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}

class PostModel {
  final String id, title, content, contentType, authorId, communityId, communitySlug, communityName;
  final int score;
  final int upvotes;
  final int downvotes;
  final int userVote;
  final bool isFlagged;
  final DateTime createdAt;
  final PostAuthor? author;
  final List<String> mediaUrls;
  final String? productId;

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
    required this.upvotes,
    required this.downvotes,
    required this.userVote,
    required this.isFlagged,
    required this.createdAt,
    this.author,
    required this.mediaUrls,
    this.productId,
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
      upvotes: json['upvotes'] as int? ?? 0,
      downvotes: json['downvotes'] as int? ?? 0,
      userVote: json['userVote'] as int? ?? 0,
      isFlagged: json['isFlagged'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      author: json['author'] != null ? PostAuthor.fromJson(json['author'] as Map<String, dynamic>) : null,
      mediaUrls: mUrls,
      productId: json['productId'] as String?,
    );
  }

  PostModel copyWith({
    String? id,
    String? title,
    String? content,
    String? contentType,
    String? authorId,
    String? communityId,
    String? communitySlug,
    String? communityName,
    int? score,
    int? upvotes,
    int? downvotes,
    int? userVote,
    bool? isFlagged,
    DateTime? createdAt,
    PostAuthor? author,
    List<String>? mediaUrls,
    String? productId,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      contentType: contentType ?? this.contentType,
      authorId: authorId ?? this.authorId,
      communityId: communityId ?? this.communityId,
      communitySlug: communitySlug ?? this.communitySlug,
      communityName: communityName ?? this.communityName,
      score: score ?? this.score,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      userVote: userVote ?? this.userVote,
      isFlagged: isFlagged ?? this.isFlagged,
      createdAt: createdAt ?? this.createdAt,
      author: author ?? this.author,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      productId: productId ?? this.productId,
    );
  }
}

class CommentModel {
  final String id, content, authorId, postId;
  final String? parentId;
  final int depth, score;
  final DateTime createdAt;
  final PostAuthor? author;
  final PostModel? post;

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
    this.post,
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
      post: json['post'] != null ? PostModel.fromJson(json['post'] as Map<String, dynamic>) : null,
    );
  }
}

class UserProfileModel {
  final String customerId, username, displayName, bio, avatarStyle, avatarSeed;
  final int followerCount;
  final bool isFollowing;
  final List<PostModel> recentPosts;
  final List<CommentModel> recentComments;
  final List<PostModel> mediaPosts;
  final String? avatarUrl, bannerUrl, bannerColor;
  final String? location, website, gender;
  final List<String> hobbies;
  final Map<String, String> socialLinks;
  final bool isPrivate, showActivityStatus;
  final bool isAdmin, isTrustedVendor;
  final String? vendorSlug, vendorStoreName;
  final DateTime? usernameChangedAt;

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
    this.recentComments = const [],
    this.mediaPosts = const [],
    this.avatarUrl,
    this.bannerUrl,
    this.bannerColor,
    this.location,
    this.website,
    this.gender,
    this.hobbies = const [],
    this.socialLinks = const {},
    this.isPrivate = false,
    this.showActivityStatus = true,
    this.isAdmin = false,
    this.isTrustedVendor = false,
    this.vendorSlug,
    this.vendorStoreName,
    this.usernameChangedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      customerId: json['customerId'] as String,
      username: json['username'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      avatarStyle: json['avatarStyle'] as String? ?? 'big-smile',
      avatarSeed: json['avatarSeed'] as String? ?? 'Felix',
      avatarUrl: json['avatarUrl'] as String?,
      bannerUrl: json['bannerUrl'] as String?,
      bannerColor: json['bannerColor'] as String?,
      location: json['location'] as String?,
      website: json['website'] as String?,
      gender: json['gender'] as String?,
      hobbies: (json['hobbies'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      socialLinks: (json['socialLinks'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, v.toString())) ?? {},
      followerCount: json['followerCount'] as int? ?? 0,
      isFollowing: json['isFollowing'] as bool? ?? false,
      isPrivate: json['isPrivate'] as bool? ?? false,
      showActivityStatus: json['showActivityStatus'] as bool? ?? true,
      isAdmin: json['isAdmin'] as bool? ?? false,
      isTrustedVendor: json['isTrustedVendor'] as bool? ?? false,
      vendorSlug: json['vendorSlug'] as String?,
      vendorStoreName: json['vendorStoreName'] as String?,
      usernameChangedAt: json['usernameChangedAt'] != null ? DateTime.tryParse(json['usernameChangedAt'] as String) : null,
      recentPosts: (json['posts'] as List<dynamic>? ?? [])
          .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentComments: (json['comments'] as List<dynamic>? ?? [])
          .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      mediaPosts: (json['mediaPosts'] as List<dynamic>? ?? [])
          .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class NotificationModel {
  final String id, recipientId, type, message;
  final String? senderId;
  final String? postId;
  final String? communityId;
  final String? communitySlug;
  final String? commentId;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.recipientId,
    required this.type,
    required this.message,
    this.senderId,
    this.postId,
    this.communityId,
    this.communitySlug,
    this.commentId,
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
      postId: json['postId'] as String?,
      communityId: json['communityId'] as String?,
      communitySlug: json['communitySlug'] as String?,
      commentId: json['commentId'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
