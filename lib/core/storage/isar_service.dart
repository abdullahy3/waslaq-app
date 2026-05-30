// lib/core/storage/isar_service.dart
// Isar is a speed cache — NOT offline sync.
// Its job: serve stale data instantly while fresh data loads from API.

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'isar/product_cache.dart';
import 'isar/category_cache.dart';
import 'isar/vendor_cache.dart';
import 'isar/feed_post_cache.dart';
import 'isar/user_profile_cache.dart';

class IsarService {
  IsarService._();
  static Isar? _isar;

  static Future<Isar> get db async {
    _isar ??= await _init();
    return _isar!;
  }

  static Future<Isar> _init() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [
        ProductCacheSchema,
        CategoryCacheSchema,
        VendorCacheSchema,
        FeedPostCacheSchema,
        UserProfileCacheSchema,
      ],
      directory: dir.path,
      name: 'waslaq_cache',
    );
  }

  // Clear all cache — called on sign-out
  static Future<void> clearAll() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  // Check if cache entry is still fresh
  static bool isFresh(DateTime cachedAt, {required int ttlMinutes}) {
    return DateTime.now().difference(cachedAt).inMinutes < ttlMinutes;
  }
}
