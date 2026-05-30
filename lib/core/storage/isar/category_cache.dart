import 'package:isar/isar.dart';
part 'category_cache.g.dart';

@collection
class CategoryCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String categoryId;

  late String name;
  late String? handle;
  late String? parentId;
  late String cachedJson;
  late DateTime cachedAt;

  // TTL: 1 hour
  bool get isStale =>
      DateTime.now().difference(cachedAt).inHours >= 1;
}
