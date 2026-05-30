// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$socialClientHash() => r'af3bba2f840f4faa0d1cb72f819f3a2c8138d85c';

/// See also [socialClient].
@ProviderFor(socialClient)
final socialClientProvider = AutoDisposeProvider<Dio>.internal(
  socialClient,
  name: r'socialClientProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$socialClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SocialClientRef = AutoDisposeProviderRef<Dio>;
String _$socialRepositoryHash() => r'd1e49e9d18505461d4558cf38e76882ff607cefd';

/// See also [socialRepository].
@ProviderFor(socialRepository)
final socialRepositoryProvider = AutoDisposeProvider<SocialRepository>.internal(
  socialRepository,
  name: r'socialRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$socialRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SocialRepositoryRef = AutoDisposeProviderRef<SocialRepository>;
String _$communitiesHash() => r'10a7094d4be12f1c0524fc98159f71af14d26f3e';

/// See also [communities].
@ProviderFor(communities)
final communitiesProvider =
    AutoDisposeFutureProvider<List<CommunityModel>>.internal(
  communities,
  name: r'communitiesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$communitiesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CommunitiesRef = AutoDisposeFutureProviderRef<List<CommunityModel>>;
String _$communityHash() => r'7573651670418b2c014545fcd4b46229dff111ef';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [community].
@ProviderFor(community)
const communityProvider = CommunityFamily();

/// See also [community].
class CommunityFamily extends Family<AsyncValue<CommunityModel>> {
  /// See also [community].
  const CommunityFamily();

  /// See also [community].
  CommunityProvider call(
    String slug,
  ) {
    return CommunityProvider(
      slug,
    );
  }

  @override
  CommunityProvider getProviderOverride(
    covariant CommunityProvider provider,
  ) {
    return call(
      provider.slug,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'communityProvider';
}

/// See also [community].
class CommunityProvider extends AutoDisposeFutureProvider<CommunityModel> {
  /// See also [community].
  CommunityProvider(
    String slug,
  ) : this._internal(
          (ref) => community(
            ref as CommunityRef,
            slug,
          ),
          from: communityProvider,
          name: r'communityProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$communityHash,
          dependencies: CommunityFamily._dependencies,
          allTransitiveDependencies: CommunityFamily._allTransitiveDependencies,
          slug: slug,
        );

  CommunityProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.slug,
  }) : super.internal();

  final String slug;

  @override
  Override overrideWith(
    FutureOr<CommunityModel> Function(CommunityRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CommunityProvider._internal(
        (ref) => create(ref as CommunityRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        slug: slug,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<CommunityModel> createElement() {
    return _CommunityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CommunityProvider && other.slug == slug;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, slug.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CommunityRef on AutoDisposeFutureProviderRef<CommunityModel> {
  /// The parameter `slug` of this provider.
  String get slug;
}

class _CommunityProviderElement
    extends AutoDisposeFutureProviderElement<CommunityModel> with CommunityRef {
  _CommunityProviderElement(super.provider);

  @override
  String get slug => (origin as CommunityProvider).slug;
}

String _$postHash() => r'1d89c33d234c3fd09d94841860545f857c66e8bd';

/// See also [post].
@ProviderFor(post)
const postProvider = PostFamily();

/// See also [post].
class PostFamily extends Family<AsyncValue<PostModel>> {
  /// See also [post].
  const PostFamily();

  /// See also [post].
  PostProvider call(
    String postId,
  ) {
    return PostProvider(
      postId,
    );
  }

  @override
  PostProvider getProviderOverride(
    covariant PostProvider provider,
  ) {
    return call(
      provider.postId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'postProvider';
}

/// See also [post].
class PostProvider extends AutoDisposeFutureProvider<PostModel> {
  /// See also [post].
  PostProvider(
    String postId,
  ) : this._internal(
          (ref) => post(
            ref as PostRef,
            postId,
          ),
          from: postProvider,
          name: r'postProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$postHash,
          dependencies: PostFamily._dependencies,
          allTransitiveDependencies: PostFamily._allTransitiveDependencies,
          postId: postId,
        );

  PostProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
  }) : super.internal();

  final String postId;

  @override
  Override overrideWith(
    FutureOr<PostModel> Function(PostRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PostProvider._internal(
        (ref) => create(ref as PostRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PostModel> createElement() {
    return _PostProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PostRef on AutoDisposeFutureProviderRef<PostModel> {
  /// The parameter `postId` of this provider.
  String get postId;
}

class _PostProviderElement extends AutoDisposeFutureProviderElement<PostModel>
    with PostRef {
  _PostProviderElement(super.provider);

  @override
  String get postId => (origin as PostProvider).postId;
}

String _$userProfileHash() => r'd06795ff6c12a4ec06ffe166f20b7635b862b971';

/// See also [userProfile].
@ProviderFor(userProfile)
const userProfileProvider = UserProfileFamily();

/// See also [userProfile].
class UserProfileFamily extends Family<AsyncValue<UserProfileModel>> {
  /// See also [userProfile].
  const UserProfileFamily();

  /// See also [userProfile].
  UserProfileProvider call(
    String userId,
  ) {
    return UserProfileProvider(
      userId,
    );
  }

  @override
  UserProfileProvider getProviderOverride(
    covariant UserProfileProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userProfileProvider';
}

/// See also [userProfile].
class UserProfileProvider extends AutoDisposeFutureProvider<UserProfileModel> {
  /// See also [userProfile].
  UserProfileProvider(
    String userId,
  ) : this._internal(
          (ref) => userProfile(
            ref as UserProfileRef,
            userId,
          ),
          from: userProfileProvider,
          name: r'userProfileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userProfileHash,
          dependencies: UserProfileFamily._dependencies,
          allTransitiveDependencies:
              UserProfileFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserProfileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<UserProfileModel> Function(UserProfileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserProfileProvider._internal(
        (ref) => create(ref as UserProfileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<UserProfileModel> createElement() {
    return _UserProfileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserProfileProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserProfileRef on AutoDisposeFutureProviderRef<UserProfileModel> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserProfileProviderElement
    extends AutoDisposeFutureProviderElement<UserProfileModel>
    with UserProfileRef {
  _UserProfileProviderElement(super.provider);

  @override
  String get userId => (origin as UserProfileProvider).userId;
}

String _$notificationsHash() => r'10c9442ab296eca94d2aedf48c620968ba47aeee';

/// See also [notifications].
@ProviderFor(notifications)
final notificationsProvider =
    AutoDisposeFutureProvider<List<NotificationModel>>.internal(
  notifications,
  name: r'notificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NotificationsRef
    = AutoDisposeFutureProviderRef<List<NotificationModel>>;
String _$feedPostsNotifierHash() => r'07288c874d4d5fd7017725d618573c6168c947e5';

abstract class _$FeedPostsNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<PostModel>> {
  late final String? communityId;
  late final String sort;

  FutureOr<List<PostModel>> build({
    String? communityId,
    String sort = 'hot',
  });
}

/// See also [FeedPostsNotifier].
@ProviderFor(FeedPostsNotifier)
const feedPostsNotifierProvider = FeedPostsNotifierFamily();

/// See also [FeedPostsNotifier].
class FeedPostsNotifierFamily extends Family<AsyncValue<List<PostModel>>> {
  /// See also [FeedPostsNotifier].
  const FeedPostsNotifierFamily();

  /// See also [FeedPostsNotifier].
  FeedPostsNotifierProvider call({
    String? communityId,
    String sort = 'hot',
  }) {
    return FeedPostsNotifierProvider(
      communityId: communityId,
      sort: sort,
    );
  }

  @override
  FeedPostsNotifierProvider getProviderOverride(
    covariant FeedPostsNotifierProvider provider,
  ) {
    return call(
      communityId: provider.communityId,
      sort: provider.sort,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'feedPostsNotifierProvider';
}

/// See also [FeedPostsNotifier].
class FeedPostsNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    FeedPostsNotifier, List<PostModel>> {
  /// See also [FeedPostsNotifier].
  FeedPostsNotifierProvider({
    String? communityId,
    String sort = 'hot',
  }) : this._internal(
          () => FeedPostsNotifier()
            ..communityId = communityId
            ..sort = sort,
          from: feedPostsNotifierProvider,
          name: r'feedPostsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$feedPostsNotifierHash,
          dependencies: FeedPostsNotifierFamily._dependencies,
          allTransitiveDependencies:
              FeedPostsNotifierFamily._allTransitiveDependencies,
          communityId: communityId,
          sort: sort,
        );

  FeedPostsNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.communityId,
    required this.sort,
  }) : super.internal();

  final String? communityId;
  final String sort;

  @override
  FutureOr<List<PostModel>> runNotifierBuild(
    covariant FeedPostsNotifier notifier,
  ) {
    return notifier.build(
      communityId: communityId,
      sort: sort,
    );
  }

  @override
  Override overrideWith(FeedPostsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: FeedPostsNotifierProvider._internal(
        () => create()
          ..communityId = communityId
          ..sort = sort,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        communityId: communityId,
        sort: sort,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<FeedPostsNotifier, List<PostModel>>
      createElement() {
    return _FeedPostsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FeedPostsNotifierProvider &&
        other.communityId == communityId &&
        other.sort == sort;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, communityId.hashCode);
    hash = _SystemHash.combine(hash, sort.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FeedPostsNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<PostModel>> {
  /// The parameter `communityId` of this provider.
  String? get communityId;

  /// The parameter `sort` of this provider.
  String get sort;
}

class _FeedPostsNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<FeedPostsNotifier,
        List<PostModel>> with FeedPostsNotifierRef {
  _FeedPostsNotifierProviderElement(super.provider);

  @override
  String? get communityId => (origin as FeedPostsNotifierProvider).communityId;
  @override
  String get sort => (origin as FeedPostsNotifierProvider).sort;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
