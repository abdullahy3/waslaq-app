import 'package:isar/isar.dart';
part 'feed_post_cache.g.dart';

@collection
class FeedPostCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String postId;

  late String title;
  late String? body;
  late String authorId;
  late String? communityId;
  late String? communitySlug;
  late int score;
  late int upvotes;
  late int commentCount;
  late String cachedJson;
  late DateTime cachedAt;

  // TTL: 2 minutes
  bool get isStale =>
      DateTime.now().difference(cachedAt).inMinutes >= 2;
}
