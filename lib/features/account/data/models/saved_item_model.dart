// lib/features/account/data/models/saved_item_model.dart

class SavedPostModel {
  final String id, title;
  final String communitySlug, communityName;
  final List<String> mediaUrls;
  final DateTime createdAt;

  SavedPostModel({
    required this.id,
    required this.title,
    required this.communitySlug,
    required this.communityName,
    required this.mediaUrls,
    required this.createdAt,
  });

  factory SavedPostModel.fromJson(Map<String, dynamic> json) {
    final community = json['community'] as Map<String, dynamic>? ?? {};
    return SavedPostModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      communitySlug: community['slug'] as String? ?? '',
      communityName: community['name'] as String? ?? '',
      mediaUrls: (json['mediaUrls'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

class SavedItemsModel {
  final List<String> savedProductIds;
  final List<String> savedPostIds;
  final List<SavedPostModel> posts;

  const SavedItemsModel({
    required this.savedProductIds,
    required this.savedPostIds,
    required this.posts,
  });

  factory SavedItemsModel.fromJson(Map<String, dynamic> json) {
    return SavedItemsModel(
      savedProductIds: (json['savedProductIds'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      savedPostIds: (json['savedPostIds'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      posts: (json['posts'] as List<dynamic>? ?? [])
          .map((e) => SavedPostModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  bool isProductSaved(String id) => savedProductIds.contains(id);
  bool isPostSaved(String id) => savedPostIds.contains(id);
}
