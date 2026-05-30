import 'package:isar/isar.dart';
part 'vendor_cache.g.dart';

@collection
class VendorCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String vendorId;

  late String? slug;
  late String storeName;
  late String? logoUrl;
  late String? description;
  late double rating;
  late String cachedJson;
  late DateTime cachedAt;

  // TTL: 10 minutes
  bool get isStale =>
      DateTime.now().difference(cachedAt).inMinutes >= 10;
}
