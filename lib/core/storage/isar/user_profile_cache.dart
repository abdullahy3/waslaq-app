import 'package:isar/isar.dart';
part 'user_profile_cache.g.dart';

@collection
class UserProfileCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String customerId;

  late String? username;
  late String? displayName;
  late String? avatarUrl;
  late bool isVerified;
  late String cachedJson;
  late DateTime cachedAt;

  // TTL: 10 minutes
  bool get isStale =>
      DateTime.now().difference(cachedAt).inMinutes >= 10;
}
