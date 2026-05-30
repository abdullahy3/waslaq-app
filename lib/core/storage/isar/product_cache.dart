import 'package:isar/isar.dart';
part 'product_cache.g.dart';

@collection
class ProductCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String productId;

  late String title;
  late String? thumbnail;
  late double price;
  late String? vendorName;
  late String? vendorSlug;
  late String? categoryId;
  late String cachedJson; // full product JSON as string
  late DateTime cachedAt;

  // TTL: 5 minutes
  bool get isStale =>
      DateTime.now().difference(cachedAt).inMinutes >= 5;
}
