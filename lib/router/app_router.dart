import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/ui/screens/sign_in_screen.dart';
import '../features/auth/ui/screens/sign_up_screen.dart';
import '../features/home/ui/screens/home_screen.dart';
import '../features/home/ui/screens/explore_screen.dart';
import '../features/home/ui/screens/search_screen.dart';
import '../features/home/ui/screens/categories_screen.dart';
import '../features/cart/ui/screens/cart_screen.dart';
import '../features/account/ui/screens/account_screen.dart';
import '../features/account/ui/screens/settings_screen.dart';
import '../features/account/ui/screens/settings/profile_settings_screen.dart';
import '../features/account/ui/screens/settings/account_settings_screen.dart';
import '../features/account/ui/screens/settings/address_book_screen.dart';
import '../features/account/ui/screens/settings/refund_details_screen.dart';
import '../features/account/ui/screens/settings/privacy_settings_screen.dart';
import '../features/account/ui/screens/settings/notification_settings_screen.dart';
import '../features/account/ui/screens/settings/content_settings_screen.dart';
import '../features/account/ui/screens/settings/appearance_settings_screen.dart';
import '../features/account/ui/screens/settings/storage_settings_screen.dart';
import '../features/account/ui/screens/settings/app_info_settings_screen.dart';
import '../features/account/ui/screens/settings/support_settings_screen.dart';
import '../features/account/ui/screens/settings/vendor_settings_screen.dart';
import '../features/account/ui/screens/saved_items_screen.dart';
import '../features/account/ui/screens/disputes_screen.dart';
import '../features/account/ui/screens/digital_vault_screen.dart';
import '../features/product/ui/screens/product_screen.dart';
import '../features/social/community/ui/screens/community_screen.dart';
import '../features/social/community/ui/screens/community_explore_screen.dart';
import '../features/social/feed/ui/screens/feed_screen.dart';
import '../features/social/post/ui/screens/post_detail_screen.dart';
import '../features/social/post/ui/screens/create_post_screen.dart';
import '../features/social/data/models/social_models.dart';
import '../features/product/data/models/product_model.dart';
import '../features/account/ui/screens/user_profile_screen.dart';
import '../features/account/ui/screens/follow_list_screen.dart';
import '../features/vendor/ui/screens/vendor_profile_screen.dart';
import '../features/vendor/ui/screens/following_stores_screen.dart';
import '../features/vendor/ui/screens/vendor_dashboard_screen.dart';
import '../features/vendor/ui/screens/become_vendor_screen.dart';
import '../features/home/ui/screens/store_screen.dart';
import '../features/vendor/ui/screens/browse_stores_screen.dart';
import '../features/checkout/ui/screens/checkout_screen.dart';
import '../features/checkout/ui/screens/order_confirmation_screen.dart';
import '../features/messages/ui/screens/messages_screen.dart';
import '../features/messages/ui/screens/chat_screen.dart';
import '../features/account/ui/screens/orders_screen.dart';
import '../features/notifications/ui/screens/notifications_screen.dart';
import '../features/account/ui/screens/privacy_policy_screen.dart';
import '../features/account/ui/screens/terms_screen.dart';
import '../features/account/ui/screens/refund_policy_screen.dart';
import '../features/info/ui/screens/about_screen.dart';
import '../features/info/ui/screens/contact_screen.dart';
import '../features/info/ui/screens/feedback_screen.dart';
import '../features/vendor/ui/screens/vendor_import_screen.dart';
import '../shared/widgets/app_shell.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {

  @override
  List<AutoRoute> get routes => [
    // Auth
    AutoRoute(page: SignInRoute.page, path: '/sign-in'),
    AutoRoute(page: SignUpRoute.page, path: '/sign-up'),

    // Main shell with bottom nav
    AutoRoute(
      page: Shell.page,
      path: '/',
      children: [
        AutoRoute(page: HomeRoute.page, path: ''),
        AutoRoute(page: ExploreRoute.page, path: 'explore'),
        AutoRoute(page: MessagesRoute.page, path: 'messages'),
        AutoRoute(page: AccountRoute.page, path: 'account'),
      ],
    ),

    // Product & Search
    AutoRoute(page: SearchRoute.page, path: '/search'),
    AutoRoute(page: CategoriesRoute.page, path: '/categories'),
    AutoRoute(page: ProductRoute.page, path: '/products/:id'),

    // Community / Social
    AutoRoute(page: FeedRoute.page, path: '/feed'),
    AutoRoute(page: CommunityExploreRoute.page, path: '/communities/explore'),
    AutoRoute(page: CommunityRoute.page, path: '/r/:community'),
    AutoRoute(page: PostDetailRoute.page, path: '/r/:community/comments/:postId'),
    AutoRoute(page: CreatePostRoute.page, path: '/post/create'),

    // User profile
    AutoRoute(page: UserProfileRoute.page, path: '/u/:userId'),
    AutoRoute(page: FollowListRoute.page, path: '/u/:userId/connections'),

    // Vendor
    AutoRoute(page: VendorProfileRoute.page, path: '/vendors/:slug'),
    AutoRoute(page: FollowingStoresRoute.page, path: '/following-stores'),
    AutoRoute(page: BecomeVendorRoute.page, path: '/vendor/apply'),
    AutoRoute(page: StoreRoute.page, path: '/store'),
    AutoRoute(page: BrowseStoresRoute.page, path: '/vendors'),
    AutoRoute(page: VendorImportRoute.page, path: '/account/vendor/import'),

    // Checkout
    AutoRoute(page: CheckoutRoute.page, path: '/checkout'),
    AutoRoute(page: OrderConfirmationRoute.page, path: '/order/:orderId/confirmed'),

    // Messages
    AutoRoute(page: ChatRoute.page, path: '/chat/:cid'),

    // Account
    AutoRoute(page: AccountRoute.page, path: '/account'),
    AutoRoute(page: CartRoute.page, path: '/cart'),
    AutoRoute(page: MessagesRoute.page, path: '/account/messages'),
    AutoRoute(page: OrdersRoute.page, path: '/account/orders'),
    AutoRoute(page: DisputesRoute.page, path: '/account/disputes'),
    AutoRoute(page: DigitalVaultRoute.page, path: '/account/digital-vault'),
    AutoRoute(page: SettingsRoute.page, path: '/account/settings'),
    AutoRoute(page: ProfileSettingsRoute.page, path: '/settings/profile'),
    AutoRoute(page: AccountSettingsRoute.page, path: '/settings/account'),
    AutoRoute(page: AddressBookRoute.page, path: '/settings/addresses'),
    AutoRoute(page: RefundDetailsRoute.page, path: '/settings/refund'),
    AutoRoute(page: PrivacySettingsRoute.page, path: '/settings/privacy'),
    AutoRoute(page: NotificationSettingsRoute.page, path: '/settings/notifications'),
    AutoRoute(page: ContentSettingsRoute.page, path: '/settings/content'),
    AutoRoute(page: AppearanceSettingsRoute.page, path: '/settings/appearance'),
    AutoRoute(page: StorageSettingsRoute.page, path: '/settings/storage'),
    AutoRoute(page: AppInfoSettingsRoute.page, path: '/settings/app'),
    AutoRoute(page: SupportSettingsRoute.page, path: '/settings/support'),
    AutoRoute(page: VendorSettingsRoute.page, path: '/settings/vendor'),
    AutoRoute(page: VendorDashboardRoute.page, path: '/account/vendor'),
    AutoRoute(page: NotificationsRoute.page, path: '/notifications'),
    AutoRoute(page: SavedItemsRoute.page, path: '/account/saved'),

    // Info
    AutoRoute(page: AboutRoute.page, path: '/about'),
    AutoRoute(page: ContactRoute.page, path: '/contact'),
    AutoRoute(page: FeedbackRoute.page, path: '/feedback'),

    // Legal
    AutoRoute(page: PrivacyPolicyRoute.page, path: '/privacy'),
    AutoRoute(page: TermsRoute.page, path: '/terms'),
    AutoRoute(page: RefundPolicyRoute.page, path: '/refund-policy'),
  ];
}

final appRouterProvider = Provider<AppRouter>((ref) => AppRouter());
