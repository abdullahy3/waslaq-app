// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AboutScreen]
class AboutRoute extends PageRouteInfo<void> {
  const AboutRoute({List<PageRouteInfo>? children})
      : super(
          AboutRoute.name,
          initialChildren: children,
        );

  static const String name = 'AboutRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AboutScreen();
    },
  );
}

/// generated route for
/// [AccountScreen]
class AccountRoute extends PageRouteInfo<void> {
  const AccountRoute({List<PageRouteInfo>? children})
      : super(
          AccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AccountScreen();
    },
  );
}

/// generated route for
/// [AppShellPage]
class Shell extends PageRouteInfo<void> {
  const Shell({List<PageRouteInfo>? children})
      : super(
          Shell.name,
          initialChildren: children,
        );

  static const String name = 'Shell';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AppShellPage();
    },
  );
}

/// generated route for
/// [BecomeVendorScreen]
class BecomeVendorRoute extends PageRouteInfo<void> {
  const BecomeVendorRoute({List<PageRouteInfo>? children})
      : super(
          BecomeVendorRoute.name,
          initialChildren: children,
        );

  static const String name = 'BecomeVendorRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BecomeVendorScreen();
    },
  );
}

/// generated route for
/// [BrowseStoresScreen]
class BrowseStoresRoute extends PageRouteInfo<void> {
  const BrowseStoresRoute({List<PageRouteInfo>? children})
      : super(
          BrowseStoresRoute.name,
          initialChildren: children,
        );

  static const String name = 'BrowseStoresRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BrowseStoresScreen();
    },
  );
}

/// generated route for
/// [CartScreen]
class CartRoute extends PageRouteInfo<void> {
  const CartRoute({List<PageRouteInfo>? children})
      : super(
          CartRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CartScreen();
    },
  );
}

/// generated route for
/// [CategoriesScreen]
class CategoriesRoute extends PageRouteInfo<void> {
  const CategoriesRoute({List<PageRouteInfo>? children})
      : super(
          CategoriesRoute.name,
          initialChildren: children,
        );

  static const String name = 'CategoriesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CategoriesScreen();
    },
  );
}

/// generated route for
/// [ChatScreen]
class ChatRoute extends PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    Key? key,
    required String cid,
    List<PageRouteInfo>? children,
  }) : super(
          ChatRoute.name,
          args: ChatRouteArgs(
            key: key,
            cid: cid,
          ),
          rawPathParams: {'cid': cid},
          initialChildren: children,
        );

  static const String name = 'ChatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ChatRouteArgs>(
          orElse: () => ChatRouteArgs(cid: pathParams.getString('cid')));
      return ChatScreen(
        key: args.key,
        cid: args.cid,
      );
    },
  );
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    required this.cid,
  });

  final Key? key;

  final String cid;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, cid: $cid}';
  }
}

/// generated route for
/// [CheckoutScreen]
class CheckoutRoute extends PageRouteInfo<void> {
  const CheckoutRoute({List<PageRouteInfo>? children})
      : super(
          CheckoutRoute.name,
          initialChildren: children,
        );

  static const String name = 'CheckoutRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CheckoutScreen();
    },
  );
}

/// generated route for
/// [CommunityExploreScreen]
class CommunityExploreRoute extends PageRouteInfo<void> {
  const CommunityExploreRoute({List<PageRouteInfo>? children})
      : super(
          CommunityExploreRoute.name,
          initialChildren: children,
        );

  static const String name = 'CommunityExploreRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CommunityExploreScreen();
    },
  );
}

/// generated route for
/// [CommunityScreen]
class CommunityRoute extends PageRouteInfo<CommunityRouteArgs> {
  CommunityRoute({
    Key? key,
    required String communitySlug,
    List<PageRouteInfo>? children,
  }) : super(
          CommunityRoute.name,
          args: CommunityRouteArgs(
            key: key,
            communitySlug: communitySlug,
          ),
          rawPathParams: {'community': communitySlug},
          initialChildren: children,
        );

  static const String name = 'CommunityRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CommunityRouteArgs>(
          orElse: () => CommunityRouteArgs(
              communitySlug: pathParams.getString('community')));
      return CommunityScreen(
        key: args.key,
        communitySlug: args.communitySlug,
      );
    },
  );
}

class CommunityRouteArgs {
  const CommunityRouteArgs({
    this.key,
    required this.communitySlug,
  });

  final Key? key;

  final String communitySlug;

  @override
  String toString() {
    return 'CommunityRouteArgs{key: $key, communitySlug: $communitySlug}';
  }
}

/// generated route for
/// [ContactScreen]
class ContactRoute extends PageRouteInfo<void> {
  const ContactRoute({List<PageRouteInfo>? children})
      : super(
          ContactRoute.name,
          initialChildren: children,
        );

  static const String name = 'ContactRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ContactScreen();
    },
  );
}

/// generated route for
/// [CreatePostScreen]
class CreatePostRoute extends PageRouteInfo<CreatePostRouteArgs> {
  CreatePostRoute({
    Key? key,
    String? communitySlug,
    List<PageRouteInfo>? children,
  }) : super(
          CreatePostRoute.name,
          args: CreatePostRouteArgs(
            key: key,
            communitySlug: communitySlug,
          ),
          rawQueryParams: {'community': communitySlug},
          initialChildren: children,
        );

  static const String name = 'CreatePostRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<CreatePostRouteArgs>(
          orElse: () => CreatePostRouteArgs(
              communitySlug: queryParams.optString('community')));
      return CreatePostScreen(
        key: args.key,
        communitySlug: args.communitySlug,
      );
    },
  );
}

class CreatePostRouteArgs {
  const CreatePostRouteArgs({
    this.key,
    this.communitySlug,
  });

  final Key? key;

  final String? communitySlug;

  @override
  String toString() {
    return 'CreatePostRouteArgs{key: $key, communitySlug: $communitySlug}';
  }
}

/// generated route for
/// [FeedScreen]
class FeedRoute extends PageRouteInfo<void> {
  const FeedRoute({List<PageRouteInfo>? children})
      : super(
          FeedRoute.name,
          initialChildren: children,
        );

  static const String name = 'FeedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FeedScreen();
    },
  );
}

/// generated route for
/// [FeedbackScreen]
class FeedbackRoute extends PageRouteInfo<void> {
  const FeedbackRoute({List<PageRouteInfo>? children})
      : super(
          FeedbackRoute.name,
          initialChildren: children,
        );

  static const String name = 'FeedbackRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FeedbackScreen();
    },
  );
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [MessagesScreen]
class MessagesRoute extends PageRouteInfo<void> {
  const MessagesRoute({List<PageRouteInfo>? children})
      : super(
          MessagesRoute.name,
          initialChildren: children,
        );

  static const String name = 'MessagesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MessagesScreen();
    },
  );
}

/// generated route for
/// [NotificationsScreen]
class NotificationsRoute extends PageRouteInfo<void> {
  const NotificationsRoute({List<PageRouteInfo>? children})
      : super(
          NotificationsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotificationsScreen();
    },
  );
}

/// generated route for
/// [OrderConfirmationScreen]
class OrderConfirmationRoute extends PageRouteInfo<OrderConfirmationRouteArgs> {
  OrderConfirmationRoute({
    Key? key,
    required String orderId,
    List<PageRouteInfo>? children,
  }) : super(
          OrderConfirmationRoute.name,
          args: OrderConfirmationRouteArgs(
            key: key,
            orderId: orderId,
          ),
          rawPathParams: {'orderId': orderId},
          initialChildren: children,
        );

  static const String name = 'OrderConfirmationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<OrderConfirmationRouteArgs>(
          orElse: () => OrderConfirmationRouteArgs(
              orderId: pathParams.getString('orderId')));
      return OrderConfirmationScreen(
        key: args.key,
        orderId: args.orderId,
      );
    },
  );
}

class OrderConfirmationRouteArgs {
  const OrderConfirmationRouteArgs({
    this.key,
    required this.orderId,
  });

  final Key? key;

  final String orderId;

  @override
  String toString() {
    return 'OrderConfirmationRouteArgs{key: $key, orderId: $orderId}';
  }
}

/// generated route for
/// [OrdersScreen]
class OrdersRoute extends PageRouteInfo<void> {
  const OrdersRoute({List<PageRouteInfo>? children})
      : super(
          OrdersRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrdersRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OrdersScreen();
    },
  );
}

/// generated route for
/// [PostDetailScreen]
class PostDetailRoute extends PageRouteInfo<PostDetailRouteArgs> {
  PostDetailRoute({
    Key? key,
    String community = '',
    String postId = '',
    List<PageRouteInfo>? children,
  }) : super(
          PostDetailRoute.name,
          args: PostDetailRouteArgs(
            key: key,
            community: community,
            postId: postId,
          ),
          rawPathParams: {
            'community': community,
            'postId': postId,
          },
          initialChildren: children,
        );

  static const String name = 'PostDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<PostDetailRouteArgs>(
          orElse: () => PostDetailRouteArgs(
                community: pathParams.getString(
                  'community',
                  '',
                ),
                postId: pathParams.getString(
                  'postId',
                  '',
                ),
              ));
      return PostDetailScreen(
        key: args.key,
        community: args.community,
        postId: args.postId,
      );
    },
  );
}

class PostDetailRouteArgs {
  const PostDetailRouteArgs({
    this.key,
    this.community = '',
    this.postId = '',
  });

  final Key? key;

  final String community;

  final String postId;

  @override
  String toString() {
    return 'PostDetailRouteArgs{key: $key, community: $community, postId: $postId}';
  }
}

/// generated route for
/// [PrivacyPolicyScreen]
class PrivacyPolicyRoute extends PageRouteInfo<void> {
  const PrivacyPolicyRoute({List<PageRouteInfo>? children})
      : super(
          PrivacyPolicyRoute.name,
          initialChildren: children,
        );

  static const String name = 'PrivacyPolicyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PrivacyPolicyScreen();
    },
  );
}

/// generated route for
/// [ProductScreen]
class ProductRoute extends PageRouteInfo<ProductRouteArgs> {
  ProductRoute({
    Key? key,
    required String id,
    List<PageRouteInfo>? children,
  }) : super(
          ProductRoute.name,
          args: ProductRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'ProductRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ProductRouteArgs>(
          orElse: () => ProductRouteArgs(id: pathParams.getString('id')));
      return ProductScreen(
        key: args.key,
        id: args.id,
      );
    },
  );
}

class ProductRouteArgs {
  const ProductRouteArgs({
    this.key,
    required this.id,
  });

  final Key? key;

  final String id;

  @override
  String toString() {
    return 'ProductRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [RefundPolicyScreen]
class RefundPolicyRoute extends PageRouteInfo<void> {
  const RefundPolicyRoute({List<PageRouteInfo>? children})
      : super(
          RefundPolicyRoute.name,
          initialChildren: children,
        );

  static const String name = 'RefundPolicyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RefundPolicyScreen();
    },
  );
}

/// generated route for
/// [SavedItemsScreen]
class SavedItemsRoute extends PageRouteInfo<void> {
  const SavedItemsRoute({List<PageRouteInfo>? children})
      : super(
          SavedItemsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SavedItemsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SavedItemsScreen();
    },
  );
}

/// generated route for
/// [SearchScreen]
class SearchRoute extends PageRouteInfo<void> {
  const SearchRoute({List<PageRouteInfo>? children})
      : super(
          SearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SearchScreen();
    },
  );
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsScreen();
    },
  );
}

/// generated route for
/// [SignInScreen]
class SignInRoute extends PageRouteInfo<void> {
  const SignInRoute({List<PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignInScreen();
    },
  );
}

/// generated route for
/// [SignUpScreen]
class SignUpRoute extends PageRouteInfo<void> {
  const SignUpRoute({List<PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignUpScreen();
    },
  );
}

/// generated route for
/// [StoreScreen]
class StoreRoute extends PageRouteInfo<StoreRouteArgs> {
  StoreRoute({
    Key? key,
    String? categoryId,
    List<PageRouteInfo>? children,
  }) : super(
          StoreRoute.name,
          args: StoreRouteArgs(
            key: key,
            categoryId: categoryId,
          ),
          initialChildren: children,
        );

  static const String name = 'StoreRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<StoreRouteArgs>(orElse: () => const StoreRouteArgs());
      return StoreScreen(
        key: args.key,
        categoryId: args.categoryId,
      );
    },
  );
}

class StoreRouteArgs {
  const StoreRouteArgs({
    this.key,
    this.categoryId,
  });

  final Key? key;

  final String? categoryId;

  @override
  String toString() {
    return 'StoreRouteArgs{key: $key, categoryId: $categoryId}';
  }
}

/// generated route for
/// [TermsScreen]
class TermsRoute extends PageRouteInfo<void> {
  const TermsRoute({List<PageRouteInfo>? children})
      : super(
          TermsRoute.name,
          initialChildren: children,
        );

  static const String name = 'TermsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TermsScreen();
    },
  );
}

/// generated route for
/// [UserProfileScreen]
class UserProfileRoute extends PageRouteInfo<UserProfileRouteArgs> {
  UserProfileRoute({
    Key? key,
    String userId = '',
    List<PageRouteInfo>? children,
  }) : super(
          UserProfileRoute.name,
          args: UserProfileRouteArgs(
            key: key,
            userId: userId,
          ),
          rawPathParams: {'userId': userId},
          initialChildren: children,
        );

  static const String name = 'UserProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<UserProfileRouteArgs>(
          orElse: () => UserProfileRouteArgs(
                  userId: pathParams.getString(
                'userId',
                '',
              )));
      return UserProfileScreen(
        key: args.key,
        userId: args.userId,
      );
    },
  );
}

class UserProfileRouteArgs {
  const UserProfileRouteArgs({
    this.key,
    this.userId = '',
  });

  final Key? key;

  final String userId;

  @override
  String toString() {
    return 'UserProfileRouteArgs{key: $key, userId: $userId}';
  }
}

/// generated route for
/// [VendorDashboardScreen]
class VendorDashboardRoute extends PageRouteInfo<void> {
  const VendorDashboardRoute({List<PageRouteInfo>? children})
      : super(
          VendorDashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'VendorDashboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const VendorDashboardScreen();
    },
  );
}

/// generated route for
/// [VendorProfileScreen]
class VendorProfileRoute extends PageRouteInfo<VendorProfileRouteArgs> {
  VendorProfileRoute({
    Key? key,
    String? slug,
    List<PageRouteInfo>? children,
  }) : super(
          VendorProfileRoute.name,
          args: VendorProfileRouteArgs(
            key: key,
            slug: slug,
          ),
          rawPathParams: {'slug': slug},
          initialChildren: children,
        );

  static const String name = 'VendorProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<VendorProfileRouteArgs>(
          orElse: () =>
              VendorProfileRouteArgs(slug: pathParams.optString('slug')));
      return VendorProfileScreen(
        key: args.key,
        slug: args.slug,
      );
    },
  );
}

class VendorProfileRouteArgs {
  const VendorProfileRouteArgs({
    this.key,
    this.slug,
  });

  final Key? key;

  final String? slug;

  @override
  String toString() {
    return 'VendorProfileRouteArgs{key: $key, slug: $slug}';
  }
}
