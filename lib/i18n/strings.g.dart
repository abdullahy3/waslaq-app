/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 2
/// Strings: 3968 (1984 per locale)
///
/// Built on 2026-06-23 at 17:40 UTC

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.en;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale with BaseAppLocale<AppLocale, Translations> {
	en(languageCode: 'en', build: Translations.build),
	ar(languageCode: 'ar', build: StringsAr.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, Translations> build;

	/// Gets current instance managed by [LocaleSettings].
	Translations get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
Translations get t => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class TranslationProvider extends BaseTranslationProvider<AppLocale, Translations> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, Translations> of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	Translations get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, Translations> {
	LocaleSettings._() : super(utils: AppLocaleUtils.instance);

	static final instance = LocaleSettings._();

	// static aliases (checkout base methods for documentation)
	static AppLocale get currentLocale => instance.currentLocale;
	static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
	static AppLocale setLocale(AppLocale locale, {bool? listenToDeviceLocale = false}) => instance.setLocale(locale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale setLocaleRaw(String rawLocale, {bool? listenToDeviceLocale = false}) => instance.setLocaleRaw(rawLocale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale useDeviceLocale() => instance.useDeviceLocale();
	@Deprecated('Use [AppLocaleUtils.supportedLocales]') static List<Locale> get supportedLocales => instance.supportedLocales;
	@Deprecated('Use [AppLocaleUtils.supportedLocalesRaw]') static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) => instance.setPluralResolver(
		language: language,
		locale: locale,
		cardinalResolver: cardinalResolver,
		ordinalResolver: ordinalResolver,
	);
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, Translations> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// translations

// Path: <root>
typedef StringsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	// Translations
	late final StringsNavEn nav = StringsNavEn._(_root);
	late final StringsExploreEn explore = StringsExploreEn._(_root);
	late final StringsAuthEn auth = StringsAuthEn._(_root);
	late final StringsAccountEn account = StringsAccountEn._(_root);
	late final StringsProductEn product = StringsProductEn._(_root);
	late final StringsVendorEn vendor = StringsVendorEn._(_root);
	late final StringsCheckoutEn checkout = StringsCheckoutEn._(_root);
	late final StringsCategoryEn category = StringsCategoryEn._(_root);
	late final StringsCommunityEn community = StringsCommunityEn._(_root);
	late final StringsMessagesEn messages = StringsMessagesEn._(_root);
	late final StringsCommonEn common = StringsCommonEn._(_root);
	late final StringsHomeEn home = StringsHomeEn._(_root);
	late final StringsFooterEn footer = StringsFooterEn._(_root);
	late final StringsCommunitySettingsEn community_settings = StringsCommunitySettingsEn._(_root);
	late final StringsFeedbackEn feedback = StringsFeedbackEn._(_root);
	late final StringsContactEn contact = StringsContactEn._(_root);
	late final StringsAboutEn about = StringsAboutEn._(_root);
	late final StringsDisutesEn disutes = StringsDisutesEn._(_root);
	late final StringsUserProfileEn user_profile = StringsUserProfileEn._(_root);
	late final StringsAccountDropdownEn account_dropdown = StringsAccountDropdownEn._(_root);
	late final StringsVendorDashboardEn vendor_dashboard = StringsVendorDashboardEn._(_root);
	late final StringsNotificationsSettingsEn notifications_settings = StringsNotificationsSettingsEn._(_root);
	late final StringsSavedEn saved = StringsSavedEn._(_root);
	late final StringsSearchEn search = StringsSearchEn._(_root);
	late final StringsCartEn cart = StringsCartEn._(_root);
	late final StringsSettingsEn settings = StringsSettingsEn._(_root);
	late final StringsBecomeVendorEn become_vendor = StringsBecomeVendorEn._(_root);
	late final StringsPrivacyEn privacy = StringsPrivacyEn._(_root);
	late final StringsTermsEn terms = StringsTermsEn._(_root);
	late final StringsRefundEn refund = StringsRefundEn._(_root);
	late final StringsVendorFinancesEn vendor_finances = StringsVendorFinancesEn._(_root);
	late final StringsVendorSettingsEn vendor_settings = StringsVendorSettingsEn._(_root);
	late final StringsVendorPoliciesEn vendor_policies = StringsVendorPoliciesEn._(_root);
	late final StringsDigitalVaultEn digital_vault = StringsDigitalVaultEn._(_root);
	late final StringsVendorProductsEn vendor_products = StringsVendorProductsEn._(_root);
	late final StringsVendorOrdersEn vendor_orders = StringsVendorOrdersEn._(_root);
	late final StringsDisputeEn dispute = StringsDisputeEn._(_root);
	late final StringsStoresEn stores = StringsStoresEn._(_root);
	late final StringsSocialEn social = StringsSocialEn._(_root);
	late final StringsStoreEn store = StringsStoreEn._(_root);
	late final StringsVendorProfileEn vendor_profile = StringsVendorProfileEn._(_root);
	late final StringsDrawerEn drawer = StringsDrawerEn._(_root);
	late final StringsInfoEn info = StringsInfoEn._(_root);
	late final StringsOrdersEn orders = StringsOrdersEn._(_root);
	late final StringsNotificationsEn notifications = StringsNotificationsEn._(_root);
	late final StringsSavedItemsEn saved_items = StringsSavedItemsEn._(_root);
	late final StringsLegalEn legal = StringsLegalEn._(_root);
	late final StringsCreatePostEn create_post = StringsCreatePostEn._(_root);
	late final StringsErrorsEn errors = StringsErrorsEn._(_root);
	late final StringsConnectionsEn connections = StringsConnectionsEn._(_root);
	late final StringsVendorImportEn vendor_import = StringsVendorImportEn._(_root);
}

// Path: nav
class StringsNavEn {
	StringsNavEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get home => 'Home';
	String get category => 'Category';
	String get community => 'Community';
	String get messages => 'Messages';
	String get search_placeholder => 'Search items, stores or creators...';
	String get cart => 'Cart';
	String get saved => 'Saved';
	String get stores => 'Stores';
	String get browse_all_stores => 'Browse All Stores';
	String get my_store => 'My Store';
	String get account => 'Account';
	String get info => 'Info';
	String get about_waslaq => 'About Waslaq';
	String get contact_us => 'Contact Us';
	String get feedback => 'Feedback';
	String get create_community => 'Create Community';
	String get explore => 'Explore';
}

// Path: explore
class StringsExploreEn {
	StringsExploreEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get products => 'Products';
	String get communities => 'Communities';
	String get stores => 'Stores';
	String get browse_categories => 'Browse Categories';
	String get popular_searches => 'Popular Searches';
	String get all_communities => 'All Communities';
	String get select_community => 'Select Community';
	String get filter => 'Filter';
	String get category => 'Category';
	String get brand => 'Brand';
	String get color => 'Color';
	String get clear_filters => 'Clear Filters';
	String get apply => 'Apply';
	String get filter_by_community => 'By Community';
	String get search_communities => 'Search communities...';
	String get my_communities => 'My Communities';
	String get no_communities_joined => 'You haven\'t joined any communities yet';
	String get explore_communities => 'Explore Communities';
	String get select_community_to_filter => 'Select a community to filter posts';
	String get all_posts => 'All Posts';
	String get private_join_required => 'Join this private community to select it';
	String get public => 'Public';
}

// Path: auth
class StringsAuthEn {
	StringsAuthEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get sign_in => 'Sign In';
	String get sign_up => 'Create Account';
	String get sign_out => 'Sign Out';
	String get email => 'Email';
	String get password => 'Password';
	String get display_name => 'Display Name';
	String get username => 'Username';
	String get forgot_password => 'Forgot password?';
	String get no_account => 'Don\'t have an account?';
	String get have_account => 'Already have an account?';
	String get create_account => 'Create Account';
	String get continue_google => 'Continue with Google';
	String get continue_facebook => 'Continue with Facebook';
	String get become_vendor => 'Become a Vendor';
	String get want_to_sell => 'Want to sell?';
	String get signing_in => 'Signing in...';
	String get creating_account => 'Creating account...';
	String get username_available => 'Username available';
	String get checking => 'Checking...';
	String get or_continue_with => 'Or continue with';
	String get or_sign_up_email => 'Or sign up with email';
	String get login_title => 'Login';
	String get required_field => 'Required';
}

// Path: account
class StringsAccountEn {
	StringsAccountEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get my_orders => 'My Orders';
	String get orders => 'Orders';
	String get track_purchases => 'Track your purchases and order history.';
	String get addresses => 'Addresses';
	String get downloads => 'Downloads';
	String get notifications => 'Notifications';
	String get profile => 'Profile';
	String get saved_items => 'Saved Items';
	String get disputes => 'Disputes';
	String get vendor_dashboard => 'Vendor Dashboard';
	String get settings => 'Settings';
	String get no_orders => 'No orders yet';
	String get no_orders_desc => 'You haven\'t placed any orders yet. Start shopping and your orders will appear here.';
	String get start_shopping => 'Start Shopping';
	String get view_order => 'View Order';
	String get back_to_orders => 'Back to Orders';
	String get order_placed => 'Order Placed';
	String get processing => 'Processing';
	String get shipped => 'Shipped';
	String get delivered => 'Delivered';
	String get order_progress => 'Order Progress';
	String get items => 'Items';
	String get total => 'Total';
	String get shipping_address => 'Shipping Address';
	String get problem_order => 'Problem with your order?';
	String get dispute_window => 'You can open a dispute within 4 days of delivery.';
	String get open_dispute => 'Open a Dispute';
	String get cancel => 'Cancel';
	String get submit_dispute => 'Submit Dispute';
	String get what_issue => 'What is the issue?';
	String get non_delivery => 'Non-Delivery';
	String get non_delivery_desc => 'Item never arrived';
	String get damaged_wrong => 'Damaged / Wrong';
	String get damaged_wrong_desc => 'Not as described';
	String get describe_issue => 'Describe the issue';
	String get my_communities => 'My Communities';
	String get my_posts => 'My Posts & Comments';
	String get vendor_center => 'Vendor Dashboard';
	String get account_privacy => 'Account & Privacy';
	String get sign_out => 'Sign Out';
	String get edit_profile => 'Edit Profile';
	String get followers => 'Followers';
	String get following => 'Following';
	String get profile_settings => 'Profile Settings';
	String get privacy_settings => 'Privacy Settings';
	String get privacy => 'Privacy';
	String get private_account => 'Private Account';
	String get show_activity => 'Show Activity Status';
	String get follow_requests => 'Follow Requests';
	String get account_settings => 'Account Settings';
	String get connected_accounts => 'Connected Accounts';
	String get delete_account => 'Delete Account';
	String get change_password => 'Change Password';
	String get order_status_title => 'Order Status';
	String get order_label => 'Order';
	String get payment_label => 'Payment';
	String get fulfillment_label => 'Fulfillment';
	String get placed => 'Placed';
	String items_count({required Object count}) => 'Items (${count})';
	String qty_label({required Object count}) => 'Qty: ${count}';
	String order_number({required Object id}) => 'Order #${id}';
	String get failed_load_orders => 'Failed to load orders';
	String get title => 'Account';
	String get my_orders_label => 'My Orders';
	String get saved_items_label => 'Saved Items';
	String get messages_label => 'Messages';
	String get notifications_label => 'Notifications';
	String get settings_label => 'Settings';
	String get privacy_policy_label => 'Privacy Policy';
	String get terms_label => 'Terms of Service';
	String get sign_out_label => 'Sign Out';
	String get vendor_dashboard_label => 'Vendor Dashboard';
	String get become_vendor_label => 'Become a Vendor';
	String get sign_in_welcome => 'WaslaQ';
	String get sign_in_desc => 'Sign in to view your account,\norders, and messages.';
	String get sign_in_btn => 'Sign In';
	String get create_account_btn => 'Create Account';
	String get section_shopping => 'Shopping';
	String get section_community => 'Community';
	String get section_communities => 'My Communities';
	String get section_vendor => 'Vendor';
	String get section_settings => 'Settings';
	String get section_legal => 'Legal';
	String get following_stores_label => 'Following Stores';
}

// Path: product
class StringsProductEn {
	StringsProductEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get add_to_cart => 'Add to Cart';
	String sold({required Object count}) => '${count} sold';
	String get no_seller => 'Local Seller';
	String get buy_now => 'Buy Now';
	String get save => 'Save';
	String get saved => 'Saved';
	String get reviews => 'Reviews';
	String get questions => 'Questions & Answers';
	String get write_review => 'Write a Review';
	String get ask_question => 'Ask a Question';
	String get no_reviews => 'No reviews yet. Be the first to review this product.';
	String get no_questions => 'No questions yet. Be the first to ask!';
	String get verified => 'Verified';
	String get verified_purchase => 'Verified Purchase';
	String get vendor_answer => 'Vendor Answer';
	String get waiting_answer => 'Waiting for vendor to answer...';
	String get submit_review => 'Submit Review';
	String get submit_question => 'Submit Question';
	String get your_rating => 'Your Rating';
	String get your_review => 'Your Review';
	String get ask_anonymously => 'Ask anonymously';
	String get customer_reviews => 'Customer Reviews';
	String get qty => 'Qty';
	String get in_stock => 'In Stock';
	String get out_of_stock => 'Out of Stock';
	String get related_products => 'Related Products';
	String get from_store => 'From Store';
	String get visit_store => 'Visit Store';
	String get quantity => 'Quantity';
	String get review_submitted => 'Review submitted!';
	String get question_submitted => 'Question submitted! The vendor will answer soon.';
	String get write_your_review => 'Write your review...';
	String get type_your_question => 'Type your question about this product...';
	String get you_might_also_like => 'You Might Also Like';
	String get must_purchase => 'You can only review products you\'ve purchased';
	String get sign_in_to_review => 'Please sign in to leave a review';
	String get sign_in_to_ask => 'Please sign in to ask a question';
	String get product_not_found => 'Product not found';
	String get official_store => 'Official Store';
	String get delivery_hint_trust => 'Local delivery — ships from Palestine';
	String get buyer_protection_trust => 'Buyer protection — escrow until delivery';
	String get options => 'Options';
	String get default_variant => 'Default';
	String get product_info => 'Product Information';
	String customer_reviews_count({required Object count}) => 'Customer Reviews (${count})';
	String get verified_buyer => 'Verified Buyer';
	String questions_answers_count({required Object count}) => 'Questions & Answers (${count})';
	String get please_select_rating => 'Please select a rating';
	String get failed_submit_review => 'Failed to submit review';
	String get please_enter_question => 'Please enter your question';
	String get failed_submit_question => 'Failed to submit question';
	String get added_to_cart_success => 'Added to cart ✓';
	String get failed_add_to_cart => 'Failed to add to cart';
	String get reviews_label => 'Reviews';
	String get qa_label => 'Customer Questions & Answers';
	String get product_information => 'Product Information';
	String get verified_reviews => 'Verified Reviews';
	String get customer_qa => 'Customer Q&A';
	String get delivery_local => 'Local delivery is managed directly by the seller.';
	String get escrow_protected => 'Protected by Waslaq Escrow until delivery is confirmed.';
	String get material => 'Material';
	String get origin => 'Origin';
	String get no_description => 'No description provided.';
	String get price_on_request => 'Price on Request';
	String share_product({required Object title, required Object url}) => 'Check out this product on WaslaQ: ${title}\n${url}';
	String get community_discussions => 'Community Discussions';
}

// Path: vendor
class StringsVendorEn {
	StringsVendorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get store => 'Store';
	String get products => 'Products';
	String get follow => 'Follow';
	String get following => 'Following';
	String get followers => 'followers';
	String get reviews => 'Reviews';
	String get policy => 'Policies';
	String get verified => 'Verified';
	String get share => 'Share';
	String get no_products => 'No products available yet.';
	String get your_store_products => 'Your Store Products';
	String get create_product => 'Create New Product';
	String get product_title => 'Product Title';
	String get description => 'Description';
	String get product_type => 'Product Type';
	String get physical_item => 'Physical Item';
	String get virtual_digital => 'Virtual / Digital';
	String get requires_shipping => 'Requires shipping';
	String get software_keys => 'Software, PDFs, Media, Keys';
	String get category => 'Category';
	String get select_parent_category => 'Select Parent Category';
	String get select_subcategory => 'Select Subcategory (Optional)';
	String get product_images => 'Product Images';
	String get add_images => 'Add Images';
	String get launch_product => 'Launch Product';
	String get discard => 'Discard';
	String get cancel_creation => 'Cancel Creation';
	String get bulk_edit_stock => 'Bulk Edit Stock';
	String get save_changes => 'Save Changes';
	String get edit_product => 'Edit Product';
	String get price_ils => 'Price (₪ ILS)';
	String get delete_product_confirm => 'Are you sure you want to delete this product? This action cannot be undone.';
	String get official_store => 'Official Store';
	String get visit_store => 'Visit Store';
	String get qa_tab => 'Questions & Answers';
	String get all_products => 'All Products';
	String get no_reviews => 'No reviews yet';
	String get failed_load_store => 'Failed to load store';
	String get store_not_found => 'Store not found';
	String reviews_count({required Object count}) => '${count} reviews';
	String tab_products({required Object count}) => 'Products (${count})';
	String tab_qa({required Object count}) => 'Q&A (${count})';
	String tab_reviews({required Object count}) => 'Reviews (${count})';
	String get tab_policies => 'Policies';
	String get no_products_yet => 'No products yet';
	String get no_questions_yet => 'No questions yet';
	String get awaiting_response => 'Awaiting vendor response...';
	String get no_reviews_yet => 'No reviews yet';
	String get no_stores_yet => 'No stores yet';
	String rating_out_of_five({required Object rating}) => '${rating}/5';
	String get no_policies_yet => 'No policies published yet';
	String get shipping_policy => 'Shipping Policy';
	String get refund_policy => 'Return & Refund Policy';
	String get terms_of_use => 'Terms of Use';
	String get privacy_policy => 'Privacy Policy';
}

// Path: checkout
class StringsCheckoutEn {
	StringsCheckoutEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get checkout => 'Checkout';
	String get shipping => 'Shipping';
	String get payment => 'Payment';
	String get review => 'Review';
	String get place_order => 'Place Order';
	String get order_summary => 'Order Summary';
	String get subtotal => 'Subtotal';
	String get shipping_cost => 'Shipping';
	String get total => 'Total';
	String get first_name => 'First Name';
	String get last_name => 'Last Name';
	String get address => 'Address';
	String get city => 'City';
	String get country => 'Country';
	String get phone => 'Phone';
	String get email => 'Email';
	String get continue_action => 'Continue';
	String get back => 'Back';
	String get card_number => 'Card Number';
	String get pay_now => 'Pay Now';
	String get processing => 'Processing...';
	String get shipping_address => 'Shipping Address';
	String get billing_address => 'Billing Address';
	String get delivery => 'Delivery';
	String get review_order => 'Review and Place Order';
	String get shipping_to => 'Shipping to';
	String get payment_method => 'Payment Method';
	String get method => 'Method';
	String get details => 'Details';
	String get recipient => 'Recipient';
	String get contact => 'Contact';
	String get continue_delivery => 'Proceed to Delivery';
	String get continue_payment => 'Proceed to Payment';
	String get continue_review => 'Continue to Review';
	String get select_shipping => 'Choose your preferred shipping method';
	String get secure_processing => 'Secure payment processing';
	String get terms_notice => 'By clicking \'Place Order\', you confirm that you have read, understood, and agree to our Terms of Use, Terms of Sale, and Return Policy, and acknowledge that you have read the WaslaQ Privacy Policy.';
	String get billing_delivery_address => 'Billing / Delivery Address';
	String get discount => 'Discount';
	String get taxes => 'Taxes';
	String get postal_code => 'Postal Code';
	String get billing_same_as_shipping => 'Billing address is the same as shipping address';
	String get saved_address_prompt => 'Would you like to use a saved address?';
	String get mixed_cart_warning => 'Physical products are only available for delivery within Palestine. Digital products can be shipped worldwide.';
	String get your_phone_number => 'Your Phone Number';
	String get payment_failed => 'Payment failed. Please try again.';
	String get try_again => 'Try Again';
	String get address_line_1 => 'Address Line 1';
	String get province_optional => 'Province (Optional)';
	String get continue_shipping => 'Continue to Shipping';
	String get cart_empty => 'Cart empty';
	String qty({required Object count}) => 'Qty: ${count}';
	String get continue_shopping => 'Continue Shopping';
	String get customer_info_step => 'Info';
	String get delivery_step => 'Delivery';
	String get payment_step => 'Payment';
	String get customer_info_title => 'Customer Information';
	String get no_shipping_options => 'No shipping options available';
	String get agree_prefix => 'I agree to the ';
	String get terms_link => 'Terms of Use';
	String get and_text => ' and ';
	String get privacy_link => 'Privacy Policy';
}

// Path: category
class StringsCategoryEn {
	StringsCategoryEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get browse_categories => 'Browse Categories';
	String get subcategories => 'Subcategories';
	String get recommended => 'Recommended';
	String get for_you => 'For You';
	String get products_coming_soon => 'Products coming soon';
	String get no_subcategories => 'No subcategories yet.';
	String get select_category => 'Select a category';
}

// Path: community
class StringsCommunityEn {
	StringsCommunityEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get community => 'Community';
	String get join => 'Join';
	String get joined => 'Joined';
	String get leave => 'Leave';
	String get leave_title => 'Leave Community';
	String get leave_confirm => 'Are you sure you want to leave this community?';
	String get create_post => 'Create Post';
	String get post => 'Post';
	String get comment => 'Comment';
	String get comments => 'Comments';
	String get reply => 'Reply';
	String get share => 'Share';
	String get save => 'Save';
	String get report => 'Report';
	String get upvote => 'Upvote';
	String get members => 'Members';
	String get online => 'Online';
	String get rules => 'Rules';
	String get about => 'About';
	String get new_post => 'New Post';
	String get title => 'Title';
	String get content => 'Content';
	String get submit => 'Submit';
	String get cancel => 'Cancel';
	String get ask_anonymously => 'Ask anonymously';
	String get no_posts => 'No posts yet.';
	String get be_first => 'Be the first to post!';
	String get hot => 'Hot';
	String get new_label => 'New';
	String get top => 'Top';
	String get trending_communities => 'Trending Communities';
	String get see_all => 'See all';
	String get whats_on_your_mind => 'What\'s on your mind?';
	String get no_posts_subtitle => 'Be the first to share something!';
	String get select_community => 'Select a community';
	String get add_images => 'Add Images';
	String get add_more_images => 'Add More ({count}/5)';
	String get private_community => 'Private Community';
	String get created => 'Created Date';
	String get request_to_join => 'Request to join to see posts and content';
	String get welcome => 'Welcome to the community!';
	String members_count({required Object count}) => '${count} members';
	String get title_required => 'Title is required';
	String get select_community_required => 'Please select a community';
	String get post_created => 'Post created!';
	String get failed_create_post => 'Failed to create post. Please try again.';
	String get post_action => 'Post';
	String get write_post_hint => 'Write your post... (optional)';
	String add_more_images_param({required Object count}) => 'Add More (${count}/5)';
	String get failed_load_post => 'Failed to load post';
	String get error_loading_comments => 'Error loading comments';
	String get no_comments_yet => 'No comments yet. Be the first to share your thoughts!';
	String get view_more_replies => 'View more replies';
	String get add_comment => 'Add a comment...';
	String get login_to_comment => 'Login to comment';
	String members_label({required Object count}) => 'Members: ${count}';
	String get joined_checkmark => 'Joined ✓';
	String error_loading_posts({required Object error}) => 'Error loading posts: ${error}';
	String get explore_communities => 'Explore Communities';
	String get no_communities_found => 'No communities found';
	String get error_loading => 'Error loading';
}

// Path: messages
class StringsMessagesEn {
	StringsMessagesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get messages => 'Messages';
	String get no_messages => 'No messages yet';
	String get type_message => 'Type a message...';
	String get send => 'Send';
	String get online => 'Online';
	String get seen => 'Seen';
	String get title => 'Messages';
	String get load_more => 'Load More';
	String get start_conversation => 'Start Conversation';
	String get offline => 'Offline';
	String get last_seen => 'Last seen';
	String get deleted => 'This message was deleted...';
	String get input_placeholder => 'Type your message';
	String get yesterday_at => 'Yesterday at';
	String get no_contacts => 'No contacts yet.';
	String get follow_someone => 'Follow someone to start chatting!';
	String get select_conversation => 'Select a conversation or start a new one';
	String get online_now => 'Online now';
	String get seen_prefix => 'Seen by';
	String get unknown_user => 'Unknown User';
	String get sign_in_view => 'Sign in to view messages';
	String get connect_vendors_buyers => 'Connect with vendors and buyers';
	String get could_not_connect => 'Could not connect to messages';
	String get not_connected => 'Not connected';
	String get no_conversations => 'No conversations yet';
	String get tap_pencil_start => 'Tap the pencil icon to start\na new conversation';
	String could_not_open_chat({required Object error}) => 'Could not open chat: ${error}';
	String get new_message => 'New Message';
	String get search_hint => 'Search by name or username…';
	String get no_users_found => 'No users found';
}

// Path: common
class StringsCommonEn {
	StringsCommonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get unknown_user => 'Unknown';
	String get loading => 'Loading...';
	String get error => 'Something went wrong';
	String error_prefix({required Object error}) => 'Error: ${error}';
	String get retry => 'Retry';
	String get save => 'Save';
	String get cancel => 'Cancel';
	String get delete => 'Delete';
	String get edit => 'Edit';
	String get close => 'Close';
	String get search => 'Search';
	String get filter => 'Filter';
	String get sort => 'Sort';
	String get view_all => 'View All';
	String get show_more => 'Show More';
	String get show_less => 'Show Less';
	String get confirm => 'Confirm';
	String get back => 'Back';
	String get next => 'Next';
	String get submit => 'Submit';
	String get success => 'Success';
	String get currency => '₪';
	String get free => 'Free';
	String get required => 'Required';
	String get optional => 'Optional';
	String get cancel_label => 'Cancel';
	String get retry_label => 'Retry';
	String get digital => 'Digital';
	String get save_changes => 'Save Changes';
	String get sort_by => 'Sort By';
	String get no_products => 'No products';
	String get reset => 'Reset';
	String get filters => 'Filters';
	String get item_type => 'Product Type';
	String get price_range => 'Price Range';
	String get show_results => 'Show Results';
	String get physical => 'Physical';
	String get min => 'Min';
	String get max => 'Max';
	String get latest => 'Latest';
	String get price_asc => 'Price: Low to High';
	String get price_desc => 'Price: High to Low';
	String get approve => 'Approve';
	String get reject => 'Reject';
	String get legal => 'Legal';
	List<String> get months => [
		'Jan',
		'Feb',
		'Mar',
		'Apr',
		'May',
		'Jun',
		'Jul',
		'Aug',
		'Sep',
		'Oct',
		'Nov',
		'Dec',
	];
	String get categories => 'Categories';
	String get failed_load_categories => 'Failed to load categories';
	String get no_categories => 'No categories';
	String get no_subcategories => 'No subcategories';
}

// Path: home
class StringsHomeEn {
	StringsHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get hero_title => 'Discover. Connect. Shop.';
	String get hero_subtitle => 'Palestine\'s social marketplace';
	String get shop_now => 'Shop Now';
	String get featured_products => 'Featured Products';
	String get trending => 'Trending';
	String get new_arrivals => 'New Arrivals';
	String get top_stores => 'Top Stores';
	String get browse_categories => 'Browse Categories';
	String get failed_load_products => 'Failed to load products';
	String get no_products_yet => 'No products yet';
	String get secure_escrow => 'Secure Escrow';
	String get verified_sellers => 'Verified Sellers';
	String get local_support => 'Local Support';
	String get search_placeholder => 'Search products, stores...';
	String get drawer_sign_in_hint => 'Sign in to access your communities and stores';
	String get drawer_browse => 'BROWSE';
	String get drawer_popular => 'Popular';
	String get drawer_news => 'News';
	String get drawer_community => 'COMMUNITY';
	String get drawer_create_community => 'Create Community';
	String get drawer_no_communities => 'You haven\'t joined any communities yet';
	String get drawer_stores => 'STORES';
	String get drawer_browse_stores => 'Browse All Stores';
	String get drawer_my_store => 'My Store';
	String get drawer_become_vendor_hint => 'You\'re not a vendor yet — Become one →';
	String get drawer_account => 'ACCOUNT';
	String get drawer_info => 'INFO';
	String get drawer_about => 'About WaslaQ';
	String get drawer_contact => 'Contact Us';
	String get drawer_feedback => 'Feedback';
	String get drawer_legal => 'LEGAL';
	String get trending_discussions => 'Trending Discussions';
	String get more_products => 'More Products';
}

// Path: footer
class StringsFooterEn {
	StringsFooterEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get privacy_policy => 'Privacy Policy';
	String get terms_of_use => 'Terms of Use';
	String get refund_policy => 'Refund & Return Policy';
	String get customer_service => 'Customer Service';
	String get company => 'Company';
	String get feedback => 'Feedback';
	String get contact_us => 'Contact Us';
	String get about_us => 'About Us';
	String get get_the_app => 'Get the App';
	String get coming_soon => 'Coming soon on Android & iOS';
	String get made_in_palestine => 'Made in Palestine';
	String get all_rights => 'All rights reserved';
}

// Path: community_settings
class StringsCommunitySettingsEn {
	StringsCommunitySettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'إعدادات المجتمع';
	String get general_tab => 'عام';
	String get appearance_tab => 'المظهر';
	String get privacy_tab => 'الخصوصية';
	String get rules_tab => 'القواعد';
	String get community_title => 'عنوان المجتمع';
	String get description => 'الوصف / السيرة الذاتية';
	String get community_icon => 'رمز المجتمع';
	String get community_banner => 'لافتة المجتمع';
	String get upload_icon => 'رمز التحميل';
	String get upload_image => 'تحميل صورة';
	String get choose_color => 'اختر اللون';
	String get save_appearance => 'حفظ المظهر';
	String get save_general => 'حفظ الإعدادات العامة';
	String get save_privacy => 'حفظ إعدادات الخصوصية';
	String get save_rules => 'حفظ القواعد';
	String get private_community => 'مجتمع خاص';
	String get private_description => 'لا يمكن إلا للأعضاء المعتمدين عرض المحتوى ونشره';
	String get community_rules => 'قواعد المجتمع';
	String get rules_placeholder => 'قواعد منفصلة مع فواصل أسطر مزدوجة...';
	String get danger_zone => 'منطقة الخطر';
	String get danger_description => 'إجراءات لا رجعة فيها قريبًا';
	String get manage_community => 'إدارة المجتمع';
	String get members => 'الأعضاء';
	String get remove => 'إزالة';
	String get joined => 'انضم';
	String get back_to_community => 'العودة إلى r/';
}

// Path: feedback
class StringsFeedbackEn {
	StringsFeedbackEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'إرسال ملاحظات';
	String get subtitle => 'ساعدنا في تحسين WaslaQ';
	String get full_name => 'الاسم الكامل';
	String get email => 'عنوان البريد الإلكتروني';
	String get about => 'ما هو الموضوع؟';
	String get message => 'رسالة';
	String get submit => 'إرسال ملاحظات';
	String get submitting => 'جاري الإرسال...';
}

// Path: contact
class StringsContactEn {
	StringsContactEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'اتصل بنا';
	String get subtitle => 'سنقوم بالرد عليك في أقرب وقت ممكن';
	String get subject => 'الموضوع (اختياري)';
	String get submit => 'إرسال رسالة';
	String get submitting => 'جاري الإرسال...';
}

// Path: about
class StringsAboutEn {
	StringsAboutEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'نبذة عن WaslaQ';
	String get tagline => 'السوق الاجتماعي الفلسطيني';
	String get our_mission => 'مهمتنا';
	String get how_it_works => 'كيف يعمل';
	String get secure_escrow => 'حساب ضمان آمن';
	String get mission_body => '"WaslaQ" هي أول منصة تسويق اجتماعية مختلطة في فلسطين — تجمع بين قوة النقاش المجتمعي والتجارة الإلكترونية الموثوقة. نحن نربط بين المشترين والبائعين الفلسطينيين في بيئة آمنة ومحمية بنظام الضمان، حيث تكون كل معاملة آمنة ويتم الاستماع إلى كل صوت.';
	String get local_vendors_title => 'البائعون المحليون';
	String get local_vendors_desc => 'تسوق مباشرة من بائعين فلسطينيين معتمدين.';
	String get community_first_title => 'المجتمع أولاً';
	String get community_first_desc => 'ناقش، واطلع على التقييمات، وتواصل مع المشترين الآخرين.';
	String get escrow_desc => 'يتم الاحتفاظ بأموالك في أمان حتى تؤكد استلامها.';
	String get our_values => 'قيمنا';
	String get value_community => 'المجتمع';
	String get value_transparency => 'الشفافية';
	String get value_trust => 'الثقة';
	String get value_palestine => 'فلسطين أولاً';
}

// Path: disutes
class StringsDisutesEn {
	StringsDisutesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'نزاعاتي';
	String get cases_count => 'الحالات';
	String get no_disputes => 'لم يتم العثور على أي نزاعات';
	String get all_good => 'جميع طلباتك سارية المفعول';
}

// Path: user_profile
class StringsUserProfileEn {
	StringsUserProfileEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get followers => 'Followers';
	String get following => 'Following';
	String get visit_store => 'Visit Store';
	String get media_tab => 'Media';
	String get replies_tab => 'Replies';
	String get posts_tab => 'Posts';
	String get no_replies => 'No replies yet';
	String get edit_profile => 'Edit Profile';
	String get failed_load => 'Failed to load profile';
	String get view_store => 'View Store';
	String get no_posts_yet => 'No posts yet';
	String get coming_soon => 'Coming soon';
	String stats({required Object followers, required Object posts}) => '${followers} Followers  ·  ${posts} Posts';
}

// Path: account_dropdown
class StringsAccountDropdownEn {
	StringsAccountDropdownEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get signed_in_as => 'Signed in as';
	String get my_profile => 'My Profile';
	String get account_dashboard => 'Account Dashboard';
	String get vendor_dashboard => 'Vendor Dashboard';
	String get language => 'Language';
	String get log_out => 'Log Out';
	String get welcome => 'Welcome!';
	String get welcome_hint => 'Sign in to sync your saved items and track your orders.';
	String get login => 'Sign In';
	String get register => 'Register';
}

// Path: vendor_dashboard
class StringsVendorDashboardEn {
	StringsVendorDashboardEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Vendor Dashboard';
	String get products_tab => 'Products';
	String get orders_tab => 'Orders';
	String get overview_tab => 'Overview';
	String get live_badge => 'Live';
	String hours_ago({required Object count}) => '${count}h ago';
	String days_ago({required Object count}) => '${count}d ago';
	String order_number({required Object id}) => 'Order #${id}';
	String get performance_summary => 'Performance summary (last 7 days)';
	String get profit_7d => 'Profit (7d)';
	String get revenue_7d => 'Revenue (7d)';
	String get after_fees => 'After fees';
	String get orders_count => 'Orders';
	String get pending => 'Pending';
	String get available => 'Available';
	String get awaiting_release => 'Awaiting Release';
	String get withdraw_any => 'Withdraw';
	String get qa_inbox_tab => 'Q&A Inbox';
	String get finances_tab => 'Finances';
	String get policies_tab => 'Policies';
	String get settings_tab => 'Settings';
	String get disputes => 'Disputes';
	String get all_clear => 'All clear';
	String get live_listings => 'Live listings';
	String get pending_desc => 'Funds in escrow, awaiting inspection period before release.';
	String get available_desc => 'Funds released from escrow and ready to withdraw to your bank account.';
	String get qa_inbox_heading => 'Q&A Inbox';
	String get no_questions => 'No questions yet. They will appear here when customers ask.';
	String get orders_7d => 'Orders (7d)';
	String get open_disputes => 'Open Disputes';
	String in_escrow({required Object amount}) => '${amount} in escrow';
	String get recent_orders => 'Recent Orders';
	String get order_marked_shipped => 'Order marked as shipped ✅';
	String get marking => 'Marking...';
	String get mark_as_shipped => 'Mark as Shipped';
	String ship_to({required Object name}) => 'Ship to: ${name}';
	String qty_price({required Object qty, required Object price}) => 'Qty: ${qty} · ₪${price}';
	String get no_products_yet => 'No products yet.\nTap + to add your first product.';
	String get add_product => 'Add Product';
	String get edit_product => 'Edit Product';
	String get title_required => 'Title is required';
	String get virtual_require_file => 'Virtual products require a file or URL';
	String get title_label => 'Title *';
	String get price_ils_label => 'Price (ILS) *';
	String get type_label => 'Type:';
	String get digital_file_url => 'Digital File URL *';
	String get upload_file_instead => 'Upload File Instead';
	String file_selected({required Object filename}) => 'File selected: ${filename}';
	String get digital_hint => 'Paste a direct link or upload the digital file (PDF, ZIP, MP3, etc.)';
	String get select_category => 'Select category';
	String get sku_optional => 'SKU (Optional)';
	String get manage_inventory => 'Manage Inventory';
	String get inventory_quantity => 'Inventory Quantity';
	String get create_product => 'Create Product';
	String get price_ils => 'Price (ILS)';
	String get delete_product => 'Delete Product';
	String delete_confirm({required Object title}) => 'Delete "${title}"? This cannot be undone.';
	String get inventory_untracked => 'Inventory: untracked';
	String stock_count({required Object count}) => 'Stock: ${count}';
	String get add => 'Add';
	String get total_earned => 'Total Earned';
	String get paid_out => 'Paid Out';
	String payout_to({required Object account}) => 'Payout to: ${account}';
	String get request_withdrawal => 'Request Withdrawal';
	String get invalid_amount => 'Enter a valid amount';
	String amount_exceeds({required Object balance}) => 'Amount exceeds available balance (₪${balance})';
	String get payout_submitted => 'Payout request submitted! Admin will process it shortly.';
	String get amount_ils => 'Amount (ILS)';
	String get withdraw => 'Withdraw';
	String get payout_hint => 'Payout will be sent to your registered bank account.';
	String get payout_history => 'Payout History';
	String get transaction_ledger => 'Transaction Ledger';
	String re_product({required Object title}) => 'Re: ${title}';
	String get public => 'Public';
	String get private => 'Private';
	String get your_answer => 'Your Answer';
	String get edit_answer => 'Edit answer';
	String get type_answer_placeholder => 'Type your answer...';
	String get store_policies => 'Store Policies';
	String get policies_hint => 'Each save creates a new version. Previous versions are kept for audit.';
	String saved_version({required Object version}) => 'Saved as version v${version} ✅';
	String get shipping_policy => 'Shipping Policy';
	String get shipping_hint => 'How do you ship? Expected delivery times?';
	String get refund_policy => 'Refund Policy';
	String get refund_hint => 'What is your refund process?';
	String get return_policy => 'Return Policy';
	String get return_hint => 'What are your return conditions?';
	String get privacy_hint => 'How do you handle customer data?';
	String get terms_hint => 'Terms and conditions for buyers.';
	String get save_policies => 'Save Policies';
	String get store_settings => 'Store Settings';
	String get store_logo => 'Store Logo';
	String get change_logo => 'Change Logo';
	String get store_banner => 'Store Banner';
	String get add_store_banner => 'Add Store Banner';
	String get store_name_required => 'Store name is required';
	String get slug_label => 'Slug (URL)';
	String get contact_email => 'Contact Email';
	String get payout_iban => 'Payout IBAN / Account ID';
	String get settings_saved => 'Settings saved ✅';
	String get save_settings => 'Save Settings';
	String get resolved_refund => 'Resolved – Refunded';
	String get resolved_release => 'Resolved – Released';
	String get respond_to_dispute => 'Respond to Dispute';
	String get response_empty => 'Response cannot be empty';
	String get your_response => 'Your Response';
	String get explain_side_placeholder => 'Explain your side of the dispute...';
	String get submit_response => 'Submit Response';
	String resolved_date({required Object date}) => 'Resolved: ${date}';
	String opened_date({required Object date}) => 'Opened: ${date}';
	String get update_response => 'Update Response';
	String get respond => 'Respond';
	String get no_disputes_hint => 'No disputes.\nAll your orders are running smoothly! ✅';
}

// Path: notifications_settings
class StringsNotificationsSettingsEn {
	StringsNotificationsSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'الإشعارات';
	String get mark_all_read => 'وضع علامة "تمت قراءتها" على كل الرسائل';
	String get new_followers => 'متابعون جدد';
	String get comments => 'التعليقات على منشوراتك';
	String get upvotes => 'التصويتات الإيجابية على منشوراتك';
	String get mentions => 'الإشارات';
	String get follow_requests => 'طلبات المتابعة';
}

// Path: saved
class StringsSavedEn {
	StringsSavedEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'العناصر المحفوظة';
	String get subtitle => 'اعرض المنتجات والمنشورات والتعليقات التي قمت بحفظها في مكان واحد';
	String get comments_tab => 'التعليقات';
	String get posts_tab => 'المشاركات';
	String get products_tab => 'المنتجات';
	String get no_products => 'لم يتم حفظ أي منتجات حتى الآن';
	String get no_products_hint => 'انقر على أيقونة القلب الموجودة على أي منتج لإضافته إلى قائمة المفضلة';
}

// Path: search
class StringsSearchEn {
	StringsSearchEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get no_results => 'No results found';
	String get no_results_hint => 'Make sure the name is written correctly and try again';
	String get go_home => 'Go to Home';
	String get see_all_results => 'See all results for';
	String get placeholder => 'Search products, stores, communities...';
	String get initial_title => 'Search for products, stores,';
	String get initial_subtitle => 'communities and users';
	String no_results_query({required Object query}) => 'No results for "${query}"';
	String get try_different => 'Try a different search term';
	String get products => 'Products';
	String get vendor_stores => 'Vendor Stores';
	String get communities => 'Communities';
	String get users => 'Users';
	String get posts => 'Posts';
	String get type_product => 'Product';
	String get type_store => 'Store';
	String get type_community => 'Community';
	String get type_user => 'User';
	String get type_post => 'Post';
	String post_author_votes({required Object author, required Object score}) => 'by u/${author} · ${score} votes';
}

// Path: cart
class StringsCartEn {
	StringsCartEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Cart';
	String get empty_message => 'There are no products in your shopping cart.';
	String get explore_products => 'Explore Products';
	String get could_not_load => 'Could not load cart';
	String get empty_title => 'Your cart is empty';
	String get start_shopping => 'Start Shopping';
	String get subtotal => 'Subtotal';
	String get shipping => 'Shipping';
	String get discount => 'Discount';
	String get total => 'Total';
	String get proceed_to_checkout => 'Proceed to Checkout';
}

// Path: settings
class StringsSettingsEn {
	StringsSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get profile_tab => 'الملف الشخصي';
	String get account_tab => 'الحساب';
	String get privacy_tab => 'الخصوصية';
	String get notifications_tab => 'الإشعارات';
	String get banner => 'لافتة';
	String get avatar => 'أفاتار';
	String get bio => 'السيرة الذاتية';
	String get location => 'المدينة / البلد';
	String get website => 'الموقع الإلكتروني';
	String get gender => 'النوع الاجتماعي';
	String get hobbies => 'الهوايات';
	String get social_links => 'روابط مواقع التواصل الاجتماعي';
	String get avatar_gallery => 'اختر من معرض الصور الرمزية';
	String get upload_photo => 'تحميل صورة';
	String get change_color => 'تغيير اللون';
	String get upload_image => 'تحميل صورة';
	String get prefer_not_say => 'أفضل عدم الإفصاح';
	String get character_count => 'الشخصية:';
	String get current_username => 'الحالي:';
	String get username_once_per_year => 'لا يمكنك تغيير اسم المستخدم الخاص بك إلا مرة واحدة في السنة';
	String get send_reset_link => 'إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني';
	String get reset_link_button => 'إرسال رابط إعادة الضبط';
	String get connected => 'متصل';
	String get permanent_action => 'هذه العملية نهائية ولا يمكن التراجع عنها';
	String get delete_account => 'حذف حسابي';
	String get page_title => 'الإعدادات';
	String get nav_profile => 'الملف الشخصي';
	String get nav_account => 'الحساب';
	String get nav_privacy => 'الخصوصية';
	String get nav_notifications => 'الإشعارات';
	String get private_account_desc => 'لا يمكن إلا للمتابعين المعتمدين رؤية منشوراتك';
	String get activity_status_desc => 'اسمح للآخرين بمعرفة متى تكون متصلاً';
	String get notif_new_followers => 'متابعون جدد';
	String get notif_new_followers_desc => 'عندما يتابعك شخص ما';
	String get notif_comments => 'التعليقات على منشوراتك';
	String get notif_comments_desc => 'عندما يعلق أحدهم';
	String get notif_upvotes => 'التصويت الإيجابي على منشوراتك';
	String get notif_upvotes_desc => 'عندما يصوّت أحدهم بالموافقة';
	String get notif_mentions => 'الإشارات';
	String get notif_mentions_desc => 'عندما يذكرك أحدهم';
	String get notif_follow_requests => 'طلبات المتابعة';
	String get notif_follow_requests_desc => 'عندما يطلب شخص ما متابعتك';
	String get notif_note => 'ملاحظة: سيتم تفعيل خدمة إرسال الإشعارات بالكامل بمجرد توصيل نظام الإشعارات.';
	String get city_country => 'المدينة / البلد';
	String get city_placeholder => 'على سبيل المثال: رام الله، فلسطين';
	String get hobbies_hint => 'اضغط على مفتاح Enter لإضافة';
	String get hobbies_placeholder => 'على سبيل المثال: التصوير الفوتوغرافي، والألعاب';
	String get save_profile => 'حفظ الملف الشخصي';
	String get title => 'Settings';
	String get profile_section => 'Profile';
	String get notifications_section => 'Notifications';
	String get about_section => 'About';
	String get edit_display_name => 'Edit Display Name';
	String get not_set => 'Not set';
	String get edit_bio => 'Edit Bio';
	String get bio_subtitle => 'Tell others about yourself';
	String get username_label => 'Username';
	String get username_subtitle => 'Cannot be changed after signup';
	String get push_notifications => 'Push Notifications';
	String get push_notifications_subtitle => 'Enable all push notifications';
	String get order_updates => 'Order Updates';
	String get order_updates_subtitle => 'Shipping, delivery, and payout alerts';
	String get social_activity => 'Social Activity';
	String get social_activity_subtitle => 'Likes, comments, follows, replies';
	String get promotions => 'Promotions';
	String get promotions_subtitle => 'Deals and offers from vendors';
	String get app_version => 'App Version';
	String get terms_label => 'Terms of Service';
	String get privacy_label => 'Privacy Policy';
	String get contact_support => 'Contact Support';
	String get display_name_dialog => 'Display Name';
	String get bio_dialog => 'Bio';
	String get enter_display_name_hint => 'Enter your display name';
	String get bio_hint => 'Write a short bio...';
	String get cancel => 'Cancel';
	String get save => 'Save';
	String get saved_ok => 'Saved successfully';
	String save_failed({required Object error}) => 'Failed to save: ${error}';
	String get hub_profile => 'Profile';
	String get hub_profile_sub => 'Avatar, bio, social links';
	String get hub_account => 'Account & Security';
	String get hub_account_sub => 'Email, password, biometric lock';
	String get hub_address => 'Address Book';
	String get hub_address_sub => 'Palestine delivery addresses';
	String get hub_refund => 'Refund Details';
	String get hub_refund_sub => 'Bank details for dispute refunds';
	String get hub_privacy => 'Privacy & Safety';
	String get hub_privacy_sub => 'Visibility, blocked users, follow requests';
	String get hub_notifications => 'Notifications';
	String get hub_notifications_sub => 'Push, orders, social alerts';
	String get hub_content => 'Content & Feed';
	String get hub_content_sub => 'Language filter, muted words';
	String get hub_appearance => 'Appearance & Language';
	String get hub_appearance_sub => 'Theme, language, font, accessibility';
	String get hub_storage => 'Storage & Performance';
	String get hub_storage_sub => 'Cache, data usage';
	String get hub_vendor => 'Vendor Settings';
	String get hub_vendor_sub => 'Vacation mode, delivery zones';
	String get hub_app => 'App';
	String get hub_app_sub => 'Share, rate, permissions, version';
	String get hub_support => 'Support & Escrow';
	String get hub_support_sub => 'Help, disputes, legal';
	String get appearance_title => 'Appearance & Language';
	String get lang_section => 'Language';
	String get lang_app_label => 'App Language';
	String get theme_section => 'Theme';
	String get theme_light => 'Light Theme';
	String get theme_dark => 'Dark Theme';
	String get theme_system => 'Follow System';
	String get text_size_section => 'Text Size';
	String get text_adjust_label => 'Adjust Font Scale';
	String get text_preview_label => 'Live Preview:';
	String get text_small => 'Small';
	String get text_normal => 'Normal';
	String get text_large => 'Large';
	String get text_xlarge => 'Extra Large';
	String get arabic_font_section => 'Arabic Font';
	String get font_default => 'System Default';
	String get font_cairo => 'Cairo';
	String get font_tajawal => 'Tajawal';
	String get font_almarai => 'Almarai';
	String get accessibility_section => 'Accessibility';
	String get bold_text => 'Bold Text';
	String get reduce_anim => 'Reduce Animations';
	String get reduce_anim_sub => 'Recommended for older devices or motion sensitivity';
	String get notif_push_enabled => 'Alerts are configured on this device';
	String get notif_push_disabled => 'Alerts are disabled';
	String get notif_enabled_chip => 'Enabled';
	String get notif_disabled_chip => 'Disabled';
	String get notif_open_settings_btn => 'Open Settings';
	String get notif_social_section => 'Social Notifications';
	String get notif_commerce_section => 'Commerce Notifications';
	String get notif_community_label => 'Community Notifications';
	String get notif_all => 'All';
	String get notif_mentions_only => 'Mentions Only';
	String get notif_off => 'Off';
	String get notif_order_confirmed => 'Order Confirmed';
	String get notif_order_shipped => 'Order Shipped';
	String get notif_order_delivered => 'Order Delivered';
	String get notif_refund_processed => 'Refund Processed';
	String get notif_price_drop => 'Price Drop Alerts';
	String get notif_back_in_stock => 'Back in Stock Alerts';
	String get notif_vendor_section => 'Vendor Notifications';
	String get notif_order_sound => 'New Order Alert Sound';
	String get notif_order_sound_sub => 'Play a loud alert sound for every new order';
	String get notif_daily_summary => 'Daily Sales Summary';
	String get notif_daily_summary_sub => 'Get a morning summary of yesterday\'s sales';
	String get notif_general_section => 'General & System';
	String get notif_promotions_toggle => 'Promotions';
	String get notif_login_alerts => 'Login Alerts';
	String get notif_login_alerts_sub => 'Get notified when account signs in on new device';
	String get notif_manage_channels => 'Open Notification Settings';
	String get notif_manage_channels_sub => 'Manage notification channels for this app';
	String get account_screen_title => 'Account & Security';
	String get account_email_label => 'Email Address';
	String get account_password_label => 'Password';
	String get account_password_sub => 'Send a reset link to your email';
	String get account_connected_label => 'Connected Accounts';
	String get account_biometric => 'Biometric Lock';
	String get account_biometric_sub => 'Require fingerprint or Face ID to open WaslaQ';
	String get account_purchase_confirm => 'Purchase Confirmation';
	String get account_purchase_confirm_sub => 'Require biometric before completing any purchase';
	String get account_login_notif => 'Login Notifications';
	String get account_login_notif_sub => 'Get notified when your account signs in from a new device';
	String get privacy_screen_title => 'Privacy & Safety';
	String get privacy_account_section => 'Account Privacy';
	String get privacy_private_account => 'Private Account';
	String get privacy_private_account_sub => 'Only approved followers can see your posts';
	String get privacy_messaging_section => 'Messaging & Chat';
	String get privacy_read_receipts => 'Read Receipts';
	String get privacy_read_receipts_sub => 'Show read receipts (✓✓) in conversations';
	String get privacy_activity_status => 'Show Activity Status';
	String get privacy_blocked_section => 'Blocked Users';
	String get privacy_follow_req_section => 'Follow Requests';
	String get content_screen_title => 'Content & Feed';
	String get content_feed_lang_section => 'Feed Language';
	String get content_muted_section => 'Muted Keywords';
	String get content_posts_section => 'Posts';
	String get content_feed_section => 'Feed Behavior';
	String get content_default_visibility => 'Default Post Visibility';
	String get content_vendor_section => 'Vendor Settings';
	String get storage_screen_title => 'Storage & Performance';
	String get storage_image_section => 'Image Cache';
	String get storage_recent_section => 'Recently Viewed';
	String get storage_dev_section => 'Developer Settings';
	String get support_screen_title => 'Support & Escrow';
	String get support_help_section => 'Get Help';
	String get support_legal_section => 'Legal';
	String get support_escrow_section => 'Escrow & Disputes';
	String get support_contact => 'Contact Support';
	String get support_contact_sub => 'Talk to a WaslaQ support agent';
	String get support_report_bug => 'Report a Bug';
	String get support_report_sub => 'Help us improve the app by reporting issues';
	String get support_terms => 'Terms of Use';
	String get support_privacy_policy => 'Privacy Policy';
	String get app_screen_title => 'App Information';
	String get app_share_section => 'Share & Feedback';
	String get app_about_section => 'About';
	String get app_share_waslaq => 'Share WaslaQ';
	String get app_share_sub => 'Tell your friends about the Palestinian marketplace';
	String get app_rate => 'Rate WaslaQ';
	String get app_rate_sub => 'Leave a review on the store';
	String get app_permissions => 'App Permissions';
	String get app_permissions_sub => 'Manage storage, camera, and notification permissions';
	String get profile_screen_title => 'Profile Settings';
	String get address_screen_title => 'Address Book';
	String get refund_screen_title => 'Refund Details';
	String get vendor_screen_title => 'Vendor Settings';
	String get vendor_store_status_section => 'Store Status';
	String get vendor_delivery_section => 'Delivery Zones';
	String get vendor_notif_section => 'Notifications';
	String get hubProfile => 'Profile';
	String get hubProfileSub => 'Edit your profile information';
	String get hubAccount => 'Account & Security';
	String get hubAccountSub => 'Password, email and account settings';
	String get hubAddress => 'Addresses';
	String get hubAddressSub => 'Manage your delivery addresses';
	String get hubRefund => 'Refund Details';
	String get hubRefundSub => 'Bank account for refunds';
	String get hubPrivacy => 'Privacy';
	String get hubPrivacySub => 'Control who sees your content';
	String get hubNotifications => 'Notifications';
	String get hubNotificationsSub => 'Manage your notification preferences';
	String get hubContent => 'Content';
	String get hubContentSub => 'Language and content preferences';
	String get hubAppearance => 'Appearance';
	String get hubAppearanceSub => 'Theme and display settings';
	String get hubStorage => 'Storage';
	String get hubStorageSub => 'Cache and data management';
	String get hubVendor => 'Vendor Settings';
	String get hubVendorSub => 'Manage your store settings';
	String get hubApp => 'App Info';
	String get hubAppSub => 'Version and about';
	String get hubSupport => 'Support';
	String get hubSupportSub => 'Help and contact us';
	String get deleteAccount => 'Delete Account';
	String get permanentAction => 'This action is permanent and cannot be undone';
	String get accountScreenTitle => 'Account & Security';
	String get accountEmailLabel => 'Email Address';
	String get notSet => 'Not set';
	String get accountPasswordLabel => 'Password';
	String get accountPasswordSub => 'Change your password';
	String get resetLinkButton => 'Send Reset Link';
	String get accountConnectedLabel => 'Connected Account';
	String get accountBiometric => 'Biometric Login';
	String get accountBiometricSub => 'Use fingerprint or face to sign in';
	String get accountLoginNotif => 'Login Notifications';
	String get accountLoginNotifSub => 'Get notified of new sign-ins';
	String get accountPurchaseConfirm => 'Purchase Confirmation';
	String get accountPurchaseConfirmSub => 'Require confirmation before purchasing';
	String get addressScreenTitle => 'Addresses';
	String get refundScreenTitle => 'Refund Details';
	String get privacyScreenTitle => 'Privacy';
	String get privacyAccountSection => 'Account Privacy';
	String get privacyPrivateAccount => 'Private Account';
	String get privacyPrivateAccountSub => 'Only approved followers see your posts';
	String get privacyFollowReqSection => 'Follow Requests';
	String get privacyActivityStatus => 'Activity Status';
	String get privacyMessagingSection => 'Messaging';
	String get privacyReadReceipts => 'Read Receipts';
	String get privacyReadReceiptsSub => 'Let others know when you\'ve read their messages';
	String get privacyBlockedSection => 'Blocked Users';
	String get notifAll => 'All';
	String get notifMentionsOnly => 'Mentions Only';
	String get notifOff => 'Off';
	String get notifEnabledChip => 'Enabled';
	String get notifDisabledChip => 'Disabled';
	String get notifPushEnabled => 'Push notifications are enabled';
	String get notifPushDisabled => 'Push notifications are disabled';
	String get notifOpenSettingsBtn => 'Open Settings';
	String get notifGeneralSection => 'General';
	String get notifSocialSection => 'Social';
	String get notifCommerceSection => 'Shopping';
	String get notifVendorSection => 'Vendor';
	String get notifComments => 'Comments';
	String get notifUpvotes => 'Upvotes';
	String get notifMentions => 'Mentions';
	String get notifNewFollowers => 'New Followers';
	String get notifFollowRequests => 'Follow Requests';
	String get notifLoginAlerts => 'Login Alerts';
	String get notifLoginAlertsSub => 'Notify me of new sign-ins';
	String get notifDailySummary => 'Daily Summary';
	String get notifDailySummarySub => 'Get a daily digest of activity';
	String get notifOrderConfirmed => 'Order Confirmed';
	String get notifOrderShipped => 'Order Shipped';
	String get notifOrderDelivered => 'Order Delivered';
	String get notifRefundProcessed => 'Refund Processed';
	String get notifBackInStock => 'Back in Stock';
	String get notifPriceDrop => 'Price Drop';
	String get notifPromotionsToggle => 'Promotions';
	String get notifOrderSound => 'Order Sound';
	String get notifOrderSoundSub => 'Play a sound for new orders';
	String get notifManageChannels => 'Manage Channels';
	String get notifManageChannelsSub => 'Control notification channels';
	String get pushNotifications => 'Push Notifications';
	String get contentScreenTitle => 'Content';
	String get contentFeedSection => 'Feed';
	String get contentFeedLangSection => 'Feed Language';
	String get contentPostsSection => 'Posts';
	String get contentMutedSection => 'Muted';
	String get contentVendorSection => 'Vendors';
	String get langSection => 'Language';
	String get langAppLabel => 'App Language';
	String get appearanceTitle => 'Appearance';
	String get themeSection => 'Theme';
	String get themeLight => 'Light';
	String get themeDark => 'Dark';
	String get themeSystem => 'System Default';
	String get textSizeSection => 'Text Size';
	String get textAdjustLabel => 'Adjust Text Size';
	String get textPreviewLabel => 'Preview';
	String get textSmall => 'Small';
	String get textNormal => 'Normal';
	String get textLarge => 'Large';
	String get textXlarge => 'X-Large';
	String get boldText => 'Bold Text';
	String get reduceAnim => 'Reduce Animations';
	String get reduceAnimSub => 'Minimize motion effects';
	String get arabicFontSection => 'Arabic Font';
	String get fontDefault => 'Default';
	String get fontCairo => 'Cairo';
	String get fontAlmarai => 'Almarai';
	String get fontTajawal => 'Tajawal';
	String get accessibilitySection => 'Accessibility';
	String get storageScreenTitle => 'Storage';
	String get storageImageSection => 'Images';
	String get storageRecentSection => 'Recent';
	String get storageDevSection => 'Developer';
	String get vendorScreenTitle => 'Vendor Settings';
	String get vendorStoreStatusSection => 'Store Status';
	String get vendorDeliverySection => 'Delivery';
	String get vendorNotifSection => 'Notifications';
	String get appScreenTitle => 'App Info';
	String get appAboutSection => 'About';
	String get appShareSection => 'Share';
	String get supportScreenTitle => 'Support';
	String get supportHelpSection => 'Help';
	String get supportEscrowSection => 'Escrow & Payments';
	String get supportLegalSection => 'Legal';
	String get notifCommunityLabel => 'Community Notifications';
	String get currencySection => 'Currency';
	String get currencyLabel => 'Display currency';
	String get currencyIls => 'Shekel (₪ ILS)';
	String get currencyIlsSub => 'Show prices in Israeli new shekel';
	String get currencyUsd => 'Dollar (USD)';
	String get currencyUsdSub => 'Show converted prices in US dollar';
}

// Path: become_vendor
class StringsBecomeVendorEn {
	StringsBecomeVendorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Become a Vendor';
	String get subtitle => 'Join our platform and start selling your products.';
	String get benefit1 => 'Sell physical and digital products';
	String get benefit2 => 'Secure payment system via Escrow';
	String get benefit3 => 'Built-in dispute protection';
	String get benefit4 => 'Request to withdraw your funds at any time';
	String get agree_terms => 'I agree to the platform terms and seller policies';
	String get create_account => 'Create your account';
	String get continue_google => 'Continue with Google';
	String get signup_email => 'Sign up with Email';
	String get skip_auth => 'Already have an account? Skip this step';
	String get verify_email_title => 'Verify your email';
	String verify_email_desc({required Object email}) => 'We have sent a link to ${email}. Click on it, then return here.';
	String get verified_button => 'I have verified my email';
	String get setup_store => 'Create your store';
	String get store_name => 'Store Name';
	String get store_name_placeholder => 'My Awesome Store';
	String get store_description => 'Store Description';
	String get store_desc_placeholder => 'Tell customers what you sell...';
	String get store_location => 'Store Location';
	String get store_loc_placeholder => 'e.g., Gaza, Ramallah, Hebron...';
	String get delivery_zone => 'Delivery Zone';
	String get delivery_placeholder => 'Choose delivery zone...';
	String get zone_gaza => 'Gaza Strip only';
	String get zone_westbank => 'West Bank only';
	String get zone_both => 'Both (Gaza & West Bank)';
	String get delivery_hint => 'Physical products will only be delivered within the selected zone. Digital products have no restrictions.';
	String get what_do_you_sell => 'What do you sell?';
	String get skip_now => 'Skip this now';
	String get submit_app => 'Submit Application';
	String get success_title => 'Application Submitted!';
	String get success_desc => 'Your request to register as a vendor is under review. You will be notified as soon as it is approved.';
	String get go_account => 'Go to My Account';
	String get continue_shopping => 'Continue Shopping';
	String get screen_title => 'Become a Vendor';
	String get header_title => 'Open Your Store\non WaslaQ';
	String get header_subtitle => 'Sell to thousands of Palestinian buyers with full escrow protection.';
	String get why_sell => 'Why sell on WaslaQ?';
	String get escrow_title => 'Escrow Protection';
	String get escrow_desc => 'Every sale is held in escrow until the buyer confirms receipt.';
	String get community_title => 'Built-in Community';
	String get community_desc => 'Reach buyers through our social feed and community posts.';
	String get delivery_title => 'Local Delivery Zones';
	String get delivery_desc => 'Deliver within Gaza or the West Bank — we handle the zone logic.';
	String get dashboard_title => 'Vendor Dashboard';
	String get dashboard_desc => 'Track orders, earnings, and manage your products easily.';
	String get store_details => 'Store Details';
	String get store_name_label => 'Store Name';
	String get store_name_hint => 'e.g. Abu Ahmad Electronics';
	String get store_desc_label => 'Store Description';
	String get store_desc_hint => 'What do you sell?';
	String get phone_label => 'Phone Number';
	String get phone_hint => '+970 5X XXX XXXX';
	String get select_zone_hint => 'Select your delivery zone';
	String get submit_application => 'Submit Application';
	String get review_time => 'We review applications within 24–48 hours.';
	String get store_name_required => 'Store name is required';
	String get select_zone_required => 'Please select a delivery zone';
	String get already_applied => 'You already have a vendor application.';
	String get submission_failed => 'Submission failed. Please try again.';
	String get application_submitted => 'Application submitted! We\'ll review it within 48 hours.';
}

// Path: privacy
class StringsPrivacyEn {
	StringsPrivacyEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get page_title => 'سياسة الخصوصية';
	String get last_updated => 'تاريخ السريان: 1 مايو 2026 · آخر تحديث: 1 مايو 2026';
	String get intro => 'تلتزم "واسلق" ("نحن" أو "المنصة") بحماية خصوصية جميع المستخدمين وبياناتهم الشخصية. تصف سياسة الخصوصية هذه كيفية قيامنا بجمع معلوماتك ومعالجتها وتخزينها وحمايتها وفقًا لمبادئ حماية البيانات الفلسطينية المعمول بها وأفضل الممارسات الدولية، بما في ذلك معايير اللائحة العامة لحماية البيانات (GDPR). وبدخولك إلى "واسلق" أو استخدامها، فإنك تقر بأنك قد قرأت الممارسات الموضحة في هذه السياسة وتوافق عليها.';
	String get s1_title => 'من نحن';
	String get s1_body => '"واسلق" هي منصة سوق إلكترونية اجتماعية مستقلة تعمل تحت الإشراف الفلسطيني. نحن نربط البائعين المستقلين بالمشترين، ونسهل إجراء المعاملات الآمنة القائمة على نظام الضمان، ونوفر ميزات مجتمعية تشمل المنشورات والمجموعات والرسائل المباشرة وتقييمات المنتجات.';
	String get s2_title => 'المعلومات التي نجمعها';
	String get s2_1_title => '2.1 معلومات الحساب والتسجيل';
	String get s2_2_title => '2.2 معلومات خاصة بالمورد';
	String get s2_3_title => '2.3 بيانات المعاملات والطلبات';
	String get s2_4_title => '2.4 بيانات التحقق من الهوية (KYC)';
	String get s2_5_title => '2.5 المحتوى الذي ينشئه المستخدمون';
	String get s2_6_title => '2.6 البيانات الفنية وبيانات الاستخدام';
	String get s3_title => 'الأساس القانوني للمعالجة';
	String get s4_title => 'كيف نستخدم معلوماتك';
	String get s5_title => 'كيف نشارك معلوماتك';
	String get s6_title => 'أمن البيانات';
	String get s7_title => 'الاحتفاظ بالبيانات';
	String get s8_title => 'حقوقك';
	String get s9_title => 'خصوصية الأطفال';
	String get s10_title => 'التعديلات على هذه السياسة';
	String get cookie_policy_title => 'سياسة ملفات تعريف الارتباط';
	String get cookie_policy_intro => 'تنطبق سياسة ملفات تعريف الارتباط هذه على المستخدمين الذين يدخلون إلى موقع "Waslaq" من الاتحاد الأوروبي، والمنطقة الاقتصادية الأوروبية، والمملكة المتحدة، وغيرها من الولايات القضائية التي تسري فيها متطلبات الموافقة على ملفات تعريف الارتباط بموجب توجيه الخصوصية الإلكترونية (ePrivacy Directive) أو اللائحة العامة لحماية البيانات (GDPR) أو التشريعات المماثلة.';
	String get s1_body_2 => 'للاستفسارات المتعلقة بالخصوصية: privacy@waslaq.com · waslaq.com/contact';
	String get s2_1_item1 => 'الاسم الكامل';
	String get s2_1_item2 => 'عنوان البريد الإلكتروني (عبر مصادقة Google Firebase أو التسجيل المباشر)';
	String get s2_1_item3 => 'رقم الهاتف (اختياري ما لم يكن مطلوبًا لإتمام عملية تسجيل المورد)';
	String get s2_1_item4 => 'اسم العرض والصورة الرمزية في الملف الشخصي';
	String get s2_1_item5 => 'تاريخ إنشاء الحساب وطريقة المصادقة (Google أو Facebook أو البريد الإلكتروني/كلمة المرور)';
	String get s2_vendor_intro => 'يقدم البائعون الذين يقدمون طلبات التسجيل ما يلي:';
	String get s2_2_item1 => 'اسم المتجر، والوصف العام، والشعار، وصور البانر';
	String get s2_2_item2 => 'منطقة التسليم (غزة، الضفة الغربية، أو كلاهما) والموقع الفعلي';
	String get s2_2_item3 => 'تفاصيل حساب الدفع: رقم IBAN أو عنوان PayPal (يتم تخزينها بشكل آمن، ولا يتم الكشف عنها علنًا أبدًا)';
	String get s2_2_item4 => 'وثائق التحقق من الهوية (KYC) وفقًا لمتطلبات الامتثال';
	String get s2_3_item1 => 'رقم الطلب، رقم العرض، الطابع الزمني للإنشاء، والحالة';
	String get s2_3_item2 => 'تفاصيل المنتج: العنوان، النوع، الكمية، سعر الوحدة بالشيكل الإسرائيلي';
	String get s2_3_item3 => 'عنوان الشحن: اسم المستلم، الشارع، المدينة، الرمز البريدي';
	String get s2_3_item4 => 'حالة الدفع وأرقام تأكيد الدفع';
	String get s2_3_item5 => 'حالة الحساب المعلق والقيود الدفترية المرتبطة بالمعاملة';
	String get s2_3_item6 => 'سجل طلبات الدفع للموردين';
	String get s2_3_payment_card_data_title => 'بيانات بطاقة الدفع:';
	String get s2_3_payment_card_data_body => 'نحن لا نقوم بتخزين أرقام بطاقات الدفع الكاملة أو رموز CVV أو بيانات مصادقة حامل البطاقة، ولا نعالجها أو ننقلها. تتم معالجة جميع عمليات الدفع حصريًّا عبر بوابات دفع متوافقة مع معيار PCI-DSS من المستوى الأول. ولا نتلقى سوى أرقام مرجعية لتأكيد المعاملات ورموز الحالة.';
	String get s2_4_body => 'قد تشمل إجراءات "اعرف عميلك" (KYC) بطاقة هوية صادرة عن الحكومة ومزودة بصورة، وإثبات ملكية الحساب المصرفي، ووثائق تجارية. ويتم تخزين هذه البيانات في ظل ضوابط صارمة للوصول إليها، ولا تُستخدم إلا لأغراض الامتثال لقوانين مكافحة غسل الأموال ومنع الاحتيال، ولا يتم مشاركتها أبدًا مع مستخدمين آخرين.';
	String get s2_5_item1 => 'المنشورات على مواقع التواصل الاجتماعي، والتعليقات، والتصويتات، وحفظ المحتوى';
	String get s2_5_item2 => 'عضويات المجتمع وأدواره';
	String get s2_5_item3 => 'تقييمات المنتجات وتصنيفات النجوم';
	String get s2_5_item4 => 'أسئلة وأجوبة العملاء المرسلة إلى الموردين';
	String get s2_5_item5 => 'الرسائل المباشرة ومحادثات الطلبات عبر GetStream';
	String get s2_6_item1 => 'عنوان IP والموقع الجغرافي التقريبي (على مستوى المدينة/المنطقة)';
	String get s2_6_item2 => 'نوع الجهاز ونظام التشغيل وإصدار المتصفح';
	String get s2_6_item3 => 'الصفحات التي تمت زيارتها، والوقت الذي قضاه المستخدم، ومسار التنقل';
	String get s2_6_item4 => 'استعلامات البحث التي تم إدخالها على المنصة';
	String get s2_6_item5 => 'سجلات الأخطاء ومعلومات التشخيص';
	String get table_processing_activities => 'أنشطة المعالجة';
	String get table_legal_basis => 'الأساس القانوني';
	String get table_row1_activity => 'إدارة الحسابات، ومعالجة الطلبات، وعمليات الحساب المعلق، ودفع المستحقات للموردين، وتسوية النزاعات';
	String get table_row1_basis => 'الضرورة التعاقدية';
	String get table_row2_activity => 'الامتثال لقوانين "اعرف عميلك" (KYC) ومكافحة غسل الأموال (AML)، والسجلات الضريبية، والأوامر القضائية';
	String get table_row2_basis => 'الالتزام القانوني';
	String get table_row3_activity => 'منع الاحتيال، ومراقبة الأمن، وتحليلات المنصات، وكشف حالات إساءة الاستخدام';
	String get table_row3_basis => 'المصالح المشروعة';
	String get table_row4_activity => 'الإشعارات الفورية، والرسائل التسويقية الاختيارية، وملفات تعريف الارتباط غير الضرورية';
	String get table_row4_basis => 'الموافقة';
	String get s4_1_title => '4.1 عمليات المنصة';
	String get s4_2_title => '4.2 الأمن ومنع الاحتيال';
	String get s4_3_title => '4.3 التواصل';
	String get s5_sell_no => 'نحن لا نبيع بياناتك الشخصية أو نؤجرها أو نتاجر بها مع أطراف ثالثة لأغراض إعلانية أو تسويقية.';
	String get s5_1_title => '5.1 شركات معالجة الدفع';
	String get s5_1_body => 'يتم مشاركة بيانات المعاملات مع بنك فلسطين وبوابات الدفع المعتمدة حصريًّا لغرض تنفيذ الدفع ومنع الاحتيال.';
	String get s5_2_title => '5.2 الجهات الفرعية المعالجة للبيانات في مجال البنية التحتية';
	String get table_service => 'الخدمة';
	String get table_purpose => 'الغرض';
	String get table_data_processed => 'البيانات التي تمت معالجتها';
	String get s5_3_title => '5.3 بين المشترين والبائعين';
	String get s5_3_body => 'عند تقديم طلب شراء، يتم مشاركة اسم المشتري وعنوان التسليم وتفاصيل الطلب مع البائع المعني لغرض تنفيذ الطلب حصراً. ويُحظر على البائعين استخدام هذه المعلومات لأي غرض آخر.';
	String get s5_4_title => '5.4 الكشف القانوني والقضائي';
	String get s5_4_body => 'قد نكشف عن البيانات الشخصية للمحاكم الفلسطينية أو سلطات إنفاذ القانون أو الهيئات التنظيمية عندما يقتضي ذلك أمر قضائي رسمي قانوني. وحيثما يسمح القانون بذلك، سنقوم بإخطار المستخدم المعني قبل الكشف عن هذه البيانات.';
	String get s6_security_note => 'على الرغم من أننا نطبق إجراءات أمنية متوافقة مع معايير القطاع، إلا أنه لا يوجد نظام إلكتروني آمن بنسبة 100٪. تقع على عاتقك مسؤولية الحفاظ على سرية بيانات تسجيل الدخول الخاصة بك. يرجى الإبلاغ عن أي حالة يشتبه في أنها وصول غير مصرح به إلى';
	String get table_data_category => 'فئة البيانات';
	String get table_retention_period => 'فترة الاحتفاظ';
	String get s8_submit_note => 'يرجى إرسال الطلبات إلى ... وسنرد عليك في غضون 30 يومًا. قد يكون من الضروري التحقق من هويتك.';
	String get s9_minors_body => 'لا يُقصد بـ«واسلق» المستخدمون الذين تقل أعمارهم عن 18 عامًا. ونحن لا نجمع البيانات عن القاصرين عن قصد. وإذا علمنا بتسجيل قاصر، فسوف نقوم على الفور بتعليق الحساب وحذف البيانات المرتبطة به. يرجى الإبلاغ عن أي مخاوف إلى';
	String get s10_updates_body => 'قد نقوم بتحديث هذه السياسة في أي وقت. وسيتم الإبلاغ عن التغييرات الجوهرية عبر البريد الإلكتروني وإشعار على المنصة قبل 14 يومًا على الأقل من دخولها حيز التنفيذ. ويُعتبر الاستمرار في استخدام Waslaq بعد دخول التغييرات حيز التنفيذ قبولاً للسياسة المعدلة.';
	String get cookie_disclosure_label => 'إشعار بشأن ملفات تعريف الارتباط';
	String get what_are_cookies_title => 'ما هي ملفات تعريف الارتباط؟';
	String get what_are_cookies_body => 'ملفات تعريف الارتباط هي ملفات نصية صغيرة يضعها موقع الويب على جهازك. وهي تتيح للمواقع الإلكترونية العمل بشكل سليم، وتذكر تفضيلاتك، وتزود مالك الموقع بتحليلات. وقد تكون ملفات تعريف الارتباط مؤقتة (تُحذف عند إغلاق المتصفح) أو دائمة (تُخزّن على جهازك لفترة محددة).';
	String get cookies_we_use_title => 'ملفات تعريف الارتباط التي نستخدمها';
	String get strictly_necessary_title => 'ملفات تعريف الارتباط الضرورية للغاية — لا تتطلب موافقة';
	String get functional_cookies_title => 'ملفات تعريف الارتباط الوظيفية — يلزم الحصول على الموافقة';
	String get no_ads_cookies => 'لا توجد ملفات تعريف ارتباط إعلانية. لا يعرض موقع "Waslaq" أي إعلانات، ولا يستخدم وحدات بكسل إعادة الاستهداف أو ملفات تعريف الارتباط الخاصة بأطراف ثالثة أو تقنيات الإعلان السلوكي.';
	String get third_party_cookies_title => 'ملفات تعريف الارتباط الخاصة بأطراف ثالثة';
	String get table_privacy_policy => 'سياسة الخصوصية';
	String get your_cookie_choices_title => 'خيارات ملفات تعريف الارتباط الخاصة بك';
	String get your_cookie_choices_body => 'يمكنك ضبط متصفحك لرفض ملفات تعريف الارتباط أو حذفها:';
	String get disabling_cookies_note => 'سيؤدي تعطيل ملفات تعريف الارتباط الضرورية للغاية إلى منعك من تسجيل الدخول واستخدام الميزات الأساسية للمنصة.';
	String get legal_basis_cookies_title => 'الأساس القانوني لاستخدام ملفات تعريف الارتباط';
	String get table_category => 'الفئة';
	String get cookie_inquiries => 'الاستفسارات المتعلقة بملفات تعريف الارتباط:';
	String get footer_questions => 'هل لديك أسئلة حول هذه السياسة؟ اتصل بـ ... أو تفضل بزيارة موقعنا';
	String get footer_rights => '© 2026 واسلاق. السوق الاجتماعي الفلسطيني. جميع الحقوق محفوظة.';
	String get table_row1_purpose_infra => 'شبكة توزيع المحتوى (CDN)، الحماية من هجمات DDoS، SSL';
	String get table_row1_data_infra => 'عناوين IP، وبيانات تعريف الطلب';
	String get table_row2_purpose_infra => 'مصادقة المستخدم';
	String get table_row2_data_infra => 'البريد الإلكتروني، معرّف المستخدم الفريد (UID)، رموز المصادقة';
	String get table_row3_purpose_infra => 'المراسلة والموجزات في الوقت الفعلي';
	String get table_row3_data_infra => 'معرفات المستخدمين، محتوى الرسائل';
	String get table_row4_purpose_infra => 'تسليم رسائل البريد الإلكتروني المتعلقة بالمعاملات';
	String get table_row4_data_infra => 'عناوين البريد الإلكتروني، ومحتوى رسائل البريد الإلكتروني';
	String get table_row5_purpose_infra => 'وسائط التخزين';
	String get table_row5_data_infra => 'الملفات والصور التي تم تحميلها';
	String get table_retention_row1_cat => 'معلومات الحساب';
	String get table_retention_row1_period => 'مدة الحساب + سنتان بعد الحذف';
	String get table_retention_row2_cat => 'سجلات المعاملات وبيانات دفتر الأستاذ';
	String get table_retention_row2_period => '5 سنوات على الأقل (الامتثال المالي)';
	String get table_retention_row3_cat => 'التعرف على العميل / وثائق الهوية';
	String get table_retention_row3_period => 'مدة العلاقة مع المورد + 5 سنوات';
	String get table_retention_row4_cat => 'سجلات النزاعات والقرارات';
	String get table_retention_row4_period => '5 سنوات من تاريخ صدور القرار';
	String get table_retention_row5_cat => 'بيانات الطلب والشحن';
	String get table_retention_row5_period => '3 سنوات';
	String get table_retention_row6_cat => 'سجلات الاستخدام والسجلات الفنية';
	String get table_retention_row6_period => '90 يومًا';
	String get table_retention_row7_cat => 'تذاكر الدعم';
	String get table_retention_row7_period => '3 سنوات';
	String get table_retention_row8_cat => 'بيانات الحساب المحذوفة';
	String get table_retention_row8_period => 'يتم إخفاء الهوية أو حذفها في غضون 30 يومًا';
	String get s8_item1_title => 'حق الاطلاع';
	String get s8_item1_desc => 'اطلب نسخة من البيانات الشخصية التي نحتفظ بها عنك.';
	String get s8_item2_title => 'الحق في التصحيح';
	String get s8_item2_desc => 'اطلب تصحيح البيانات غير الدقيقة أو غير الكاملة.';
	String get s8_item3_title => 'الحق في حذف البيانات';
	String get s8_item3_desc => 'طلب حذف بياناتك (مع مراعاة متطلبات الاحتفاظ القانونية).';
	String get s8_item4_title => 'الحق في تقييد المعالجة';
	String get s8_item4_desc => 'طلب التوقف المؤقت عن المعالجة في ظروف معينة.';
	String get s8_item5_title => 'الحق في نقل البيانات';
	String get s8_item5_desc => 'اطلب تصدير بياناتك في صيغة منظمة وقابلة للقراءة آليًّا.';
	String get s8_item6_title => 'الحق في الاعتراض';
	String get s8_item6_desc => 'الاعتراض على المعالجة استنادًا إلى المصالح المشروعة.';
	String get s8_item7_title => 'الحق في سحب الموافقة';
	String get s8_item7_desc => 'يمكنك سحب موافقتك على المعالجة القائمة على الموافقة في أي وقت.';
	String get table_cookie1_purpose => 'رمز جلسة العمل المصادق عليه للخلفية التجارية';
	String get table_cookie1_duration => 'الجلسة';
	String get table_cookie2_purpose => 'جلسة مصادقة Firebase';
	String get table_cookie2_duration => 'الجلسة';
	String get table_cookie3_purpose => 'يمنع تزوير الطلبات عبر المواقع';
	String get table_cookie3_duration => 'الجلسة';
	String get table_cookie4_name => 'ملفات تعريف الارتباط الخاصة بالتفضيلات';
	String get table_cookie4_purpose => 'يحتفظ بتفضيلات العرض والإشعارات';
	String get table_cookie4_duration => 'سنة واحدة';
	String get table_cookie5_name => 'حفظ سلة التسوق';
	String get table_cookie5_purpose => 'يحتفظ بمحتويات سلة التسوق عبر الجلسات';
	String get table_cookie5_duration => '30 يومًا';
	String get your_cookie_choices_item1 => 'Chrome: الإعدادات → الخصوصية والأمان → ملفات تعريف الارتباط وبيانات المواقع الأخرى';
	String get your_cookie_choices_item2 => 'فايرفوكس: الخيارات → الخصوصية والأمان → ملفات تعريف الارتباط وبيانات المواقع';
	String get your_cookie_choices_item3 => 'Safari: التفضيلات → الخصوصية → إدارة بيانات المواقع الإلكترونية';
	String get your_cookie_choices_item4 => 'Edge: الإعدادات → الخصوصية والبحث والخدمات → ملفات تعريف الارتباط';
	String get table_cookie_legal_row1_cat => 'ضرورية للغاية';
	String get table_cookie_legal_row1_basis => 'المصلحة المشروعة / الضرورة التعاقدية — لا حاجة إلى موافقة';
	String get table_cookie_legal_row2_cat => 'وظيفي';
	String get table_cookie_legal_row2_basis => 'الموافقة';
	String get table_cookie_legal_row3_cat => 'التحليلات';
	String get table_cookie_legal_row3_basis => 'الموافقة (نستخدم ملفات تعريف الارتباط من جانب الخادم فقط، ولا نستخدم ملفات تعريف الارتباط الخاصة بالتتبع)';
	String get table_cookie_legal_row4_cat => 'الإعلان';
	String get table_cookie_legal_row4_basis => 'لا ينطبق — نحن لا نستخدم ملفات تعريف الارتباط الإعلانية';
	String get s4_1_item1 => 'لإنشاء حسابك وإدارته.';
	String get s4_1_item2 => 'لمعالجة طلباتك وتنفيذها.';
	String get s4_1_item3 => 'تقديم خدمات الضمان والدفع الآمنة.';
	String get s4_1_item4 => 'لتسهيل التواصل بين المشترين والبائعين.';
	String get s4_1_item5 => 'لإبلاغك بحالة الطلب وتحديثات المنصة.';
	String get s4_2_item1 => 'لمراقبة الأنشطة المشبوهة أو الاحتيالية.';
	String get s4_2_item2 => 'للتحقق من هويتك في إطار عملية تسجيل الموردين.';
	String get s4_2_item3 => 'لحماية سلامة نظام الحساب المعلق.';
	String get s4_2_item4 => 'لتسوية النزاعات والتوسط في المطالبات.';
	String get s4_2_item5 => 'الامتثال للالتزامات القانونية والتنظيمية.';
	String get s4_3_item1 => 'إشعارات فورية للرسائل والطلبات الجديدة.';
	String get s4_3_item2 => 'تحديثات عبر البريد الإلكتروني بشأن أمان الحساب وأنشطته.';
	String get s4_3_item3 => 'الاتصالات التسويقية الاختيارية (في حالة تقديم الموافقة).';
}

// Path: terms
class StringsTermsEn {
	StringsTermsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get page_title => 'شروط الاستخدام';
	String get last_updated => 'تاريخ السريان: 1 مايو 2026 · آخر تحديث: 1 مايو 2026';
	String get intro => 'تشكل شروط الاستخدام هذه ("الاتفاقية") عقدًا ملزمًا قانونًا بين Waslaq ("المنصة"، "نحن"، "لنا") وجميع المستخدمين، بما في ذلك المشترون والبائعون ("أنت"، "المستخدم"). من خلال الوصول إلى أي جزء من منصة Waslaq أو استخدامه — بما في ذلك التصفح أو التسجيل أو الشراء أو البيع — فإنك تقبل دون قيد أو شرط جميع الشروط المنصوص عليها في هذه الاتفاقية. إذا كنت لا توافق على أي جزء من هذه الاتفاقية، فيجب عليك التوقف فوراً عن استخدام المنصة بأي شكل من الأشكال.';
	String get s1_title => 'طبيعة المنصة';
	String get s2_title => 'تسجيل الحساب وشروط الأهلية';
	String get s3_title => 'نظام الضمان والدفع';
	String get s4_title => 'التزامات المورد وإجراءات "اعرف عميلك"';
	String get s5_title => 'التزامات المشتري';
	String get s6_title => 'المحتوى والأنشطة المحظورة';
	String get s7_title => 'الملكية الفكرية';
	String get s8_title => 'تسوية المنازعات';
	String get s9_title => 'عمليات رد المبالغ المدفوعة';
	String get s10_title => 'رسوم وعمولات المنصة';
	String get s11_title => 'حدود المسؤولية';
	String get s12_title => 'الإنهاء والتعليق';
	String get s13_title => 'القانون الواجب التطبيق والاختصاص القضائي';
	String get s14_title => 'التعديلات';
	String get quick_nav_title => 'التنقل السريع';
	String get quick_nav_item1 => 'طبيعة المنصة';
	String get quick_nav_item2 => 'تسجيل الحساب';
	String get quick_nav_item3 => 'الحساب المعلق والمدفوعات';
	String get quick_nav_item4 => 'التزامات الموردين وإجراءات "اعرف عميلك"';
	String get quick_nav_item5 => 'التزامات المشتري';
	String get quick_nav_item6 => 'المحتوى والأنشطة المحظورة';
	String get quick_nav_item7 => 'الملكية الفكرية';
	String get quick_nav_item8 => 'تسوية المنازعات';
	String get quick_nav_item9 => 'عمليات رد المبالغ المدفوعة';
	String get quick_nav_item10 => 'رسوم وعمولات المنصة';
	String get quick_nav_item11 => 'حدود المسؤولية';
	String get quick_nav_item12 => 'الإنهاء والتعليق';
	String get quick_nav_item13 => 'القانون الواجب التطبيق';
	String get quick_nav_item14 => 'التعديلات';
	String get s1_body1 => 'تعمل "واسلق" كوسيط إلكتروني وتقني ومالي مستقل يربط بين البائعين المستقلين والمشترين حصريًّا داخل السوق الفلسطينية. وتسهل المنصة إجراء المعاملات من خلال نظام ضمان آمن، كما توفر ميزات التجارة الاجتماعية، بما في ذلك المجموعات والمشاركات ومراجعات المنتجات والمراسلة المباشرة.';
	String get s1_body2 => 'لا تعتبر المنصة طرفًا مباشرًا في عقود البيع المبرمة بين المشترين والبائعين. ولا توجد أي علاقة وكالة أو شراكة أو توظيف أو امتياز أو مشروع مشترك بين «واسلق» وأي مستخدم. والبائعون هم بائعون مستقلون ويتحملون وحدهم المسؤولية عن منتجاتهم وإعلاناتهم والتزاماتهم المتعلقة بتنفيذ الطلبات.';
	String get s1_body3 => 'تحتفظ Waslaq بالحق في تعديل أو تعليق أو إيقاف أي ميزة أو قسم أو المنصة بأكملها بشكل دائم في أي وقت، سواء بإشعار مسبق أو بدونه، ولن تتحمل أي مسؤولية تجاه أي مستخدم أو طرف ثالث عن أي تعديل أو تعليق أو إيقاف من هذا القبيل.';
	String get s2_intro => 'للاستفادة من جميع ميزات المنصة، يجب عليك إنشاء حساب. وبتسجيلك، فإنك تقر وتضمن ما يلي:';
	String get s2_item1 => 'يجب أن يكون عمرك 18 عامًا على الأقل أو أن تكون قد بلغت سن الرشد القانوني في ولايتك القضائية.';
	String get s2_item2 => 'جميع المعلومات المقدمة أثناء التسجيل دقيقة وحديثة وكاملة.';
	String get s2_item3 => 'يجب عليك الحفاظ على دقة معلومات حسابك وتحديثها فور حدوث أي تغيير فيها.';
	String get s2_item4 => 'لا يجوز لك إنشاء حسابات متعددة للتحايل على القيود أو الإيقافات أو الحظر.';
	String get s2_item5 => 'أنت وحدك المسؤول عن جميع الأنشطة التي تتم من خلال حسابك وعن الحفاظ على سرية بيانات تسجيل الدخول الخاصة بك.';
	String get s2_body => 'تحتفظ Waslaq بالحق في رفض التسجيل، أو التحقق من الهوية، أو تعليق الوصول، أو حظر أي حساب بشكل دائم وفقًا لتقديرها الخاص، بما في ذلك على سبيل المثال لا الحصر، في حالات انتهاك هذه الاتفاقية، أو الاشتباه في حدوث احتيال، أو الإضرار بسمعة المنصة.';
	String get s3_2_item1 => 'المنتجات المادية: 48 ساعة من تاريخ تأكيد التسليم أو قيام البائع بوضع علامة "تم الشحن" على الطلب.';
	String get s3_2_item2 => 'المنتجات الرقمية: 24 ساعة من تاريخ تأكيد تسليم المفتاح الرقمي أو الملف أو بيانات تسجيل الدخول.';
	String get s3_3_item1 => 'تمديد فترة الاحتجاز إلى ما بعد "فترة الفحص" القياسية في حالات الاشتباه في حدوث احتيال أو في حالة وجود نزاعات لم يتم حلها.';
	String get s3_3_item2 => 'تجميد الأموال إلى أجل غير مسمى ريثما يتم الانتهاء من التحقيق في المخالفات المبلغ عنها أو الشكاوى المتعددة أو التحقيق التنظيمي.';
	String get s3_3_item3 => 'إعادة الأموال المحتجزة إلى المشترين أو تحويلها إليهم في حالة تسوية النزاع أو تأكيد مخالفة البائع.';
	String get s3_3_item4 => 'تعليق المدفوعات المعلقة للموردين الذين تخضع حساباتهم للتحقيق أو التعليق.';
	String get s4_1_item1 => 'بطاقة هوية صادرة عن الحكومة ومزودة بصورة (بطاقة الهوية الوطنية أو جواز السفر).';
	String get s4_1_item2 => 'إثبات ملكية الحساب المصرفي (كشف حساب أو خطاب تأكيد رقم IBAN).';
	String get s4_1_item3 => 'وثائق تسجيل الشركة، إن وجدت.';
	String get s4_3_item1 => 'هذا المنتج هو نسخة مقلدة / غير أصلية / مقلدة — ولا يرتبط بالعلامة التجارية الأصلية ولا يحظى بتأييدها.';
	String get s4_3_item2 => 'استخدام مصطلحات مثل "نسخة" أو "مزيفة" أو "مقلدة" أو "مستنسخة" أو "ليست أصلية" بشكل واضح في العنوان نفسه.';
	String get s5_item1 => 'يرجى تقديم عناوين الشحن ومعلومات الاتصال الصحيحة عند إتمام عملية الدفع. لا تتحمل "واسلق" والموردون أي مسؤولية عن أي إخفاق في التسليم ناجم عن تقديم عناوين غير صحيحة من قِبل المشتري.';
	String get s5_item2 => 'يرجى مراجعة الطلبات خلال فترة المراجعة وفتح نزاع فوراً في حال اكتشاف أي مشاكل. ويُعتبر عدم فتح نزاع قبل انتهاء فترة المراجعة بمثابة قبول قانوني للطلب.';
	String get s5_item3 => 'لا تقدم أدلة مزورة أو مزيفة في النزاعات. فذلك يشكل احتيالاً وسيؤدي إلى إغلاق الحساب نهائياً واتخاذ إجراءات قانونية محتملة.';
	String get s5_item4 => 'لا يجوز الشروع في إجراءات استرداد المبالغ من البنك دون استنفاد إجراءات تسوية المنازعات الداخلية الخاصة بالمنصة أولاً.';
	String get s5_item5 => 'يرجى الالتزام بجميع القوانين الفلسطينية السارية عند شراء المنتجات عبر المنصة.';
	String get s6_1_item1 => 'عرض منتجات مقلدة أو مستنسخة أو غير أصلية دون الإفصاح عن ذلك بوضوح وصراحة في عنوان المنتج ووصفه.';
	String get s6_1_item2 => 'عرض أو بيع أو تيسير منتجات أو خدمات تنتهك القانون الفلسطيني المعمول به، أو المبادئ المالية الإسلامية حيثما كان ذلك مطلوبًا، أو العقوبات الدولية.';
	String get s6_1_item3 => 'أي مخطط يهدف إلى التحايل على نظام الحساب المعلق، بما في ذلك محاولة إتمام المعاملات خارج المنصة.';
	String get s6_1_item4 => 'استخدام المنصة في غسل الأموال أو تمويل الإرهاب أو أي نشاط ينتهك لوائح مكافحة غسل الأموال (AML).';
	String get s6_2_item1 => 'نشر أو تحميل أو مشاركة أو وضع روابط لأي محتوى جنسي صريح أو إباحي أو مخصص للبالغين فقط بأي شكل من الأشكال — بما في ذلك الصور أو مقاطع الفيديو أو النصوص أو الروابط أو قوائم المنتجات — تحت أي ظرف من الظروف ودون استثناء.';
	String get s6_2_item2 => 'نشر أي محتوى يُجسد القاصرين في صورة جنسية أو يستغلهم أو يعرضهم للخطر بأي شكل من الأشكال. ويُعد هذا جريمة جنائية وسيتم الإبلاغ عنه على الفور إلى السلطات الفلسطينية المختصة والمنظمات الدولية المعنية بحماية الطفل.';
	String get s6_2_item3 => 'مشاركة صور عارية أو شبه عارية أو ذات إيحاءات جنسية في أي قسم من أقسام المنصة، بما في ذلك المنشورات والمجموعات وصور المنتجات ولافتات المتاجر وصور الملف الشخصي أو الرسائل المباشرة.';
	String get s6_2_item4 => 'عرض أو بيع أي منتجات أو خدمات أو مواد للبالغين، بغض النظر عن وضعها القانوني في الولاية القضائية للمستخدم.';
	String get s6_2_item5 => 'محاولة التحايل على آليات مراقبة المحتوى باستخدام لغة مشفرة أو رموز تعبيرية أو روابط لمواقع خارجية أو إشارات غير مباشرة بهدف توجيه المستخدمين إلى محتوى محظور.';
	String get s6_3_item1 => 'التحرش أو التنمر أو التهديد أو التخويف أو الإساءة الموجهة إلى أي مستخدم أو بائع أو عضو في المجتمع أو موظف في المنصة في أي قسم من أقسام المنصة.';
	String get s6_3_item2 => 'خطاب الكراهية، أو التمييز، أو المحتوى الذي يحط من قدر الأفراد أو الجماعات على أساس الدين، أو العرق، أو الجنسية، أو الجنس، أو الانتماء السياسي، أو أي سمة أخرى محمية.';
	String get s6_3_item3 => 'نشر مشاهد عنف صادمة، أو مشاهد دموية، أو صور مزعجة، أو محتوى يهدف إلى إثارة صدمة أو إزعاج المستخدمين الآخرين.';
	String get s6_3_item4 => 'نشر معلومات خاطئة متعمدة أو معلومات مضللة أو محتوى ملفق بهدف خداع المستخدمين الآخرين أو الإضرار بسمعتهم.';
	String get s6_3_item5 => 'إغراق المجتمعات أو موجزات المنشورات أو الرسائل المباشرة بمحتوى ترويجي غير مرغوب فيه، أو منشورات متكررة، أو أنشطة الروبوتات الآلية.';
	String get s6_3_item6 => '"الدوكسينغ" — نشر معلومات شخصية خاصة عن أي فرد (الاسم، العنوان، رقم الهاتف، التفاصيل المالية) دون موافقته الصريحة.';
	String get s6_3_item7 => 'انتحال صفة مستخدم آخر أو بائع أو مشرف مجتمع أو أحد موظفي Waslaq في أي سياق على المنصة.';
	String get s6_4_item1 => 'الجمع غير المصرح به للبيانات الشخصية للمستخدمين الآخرين أو محتوى المنصة، أو استخراجها، أو استخدامها لأغراض تجارية.';
	String get s6_4_item2 => 'تحميل برامج ضارة، أو شن هجمات لإعاقة الخدمة، أو محاولة اختراق أنظمة أمان المنصة.';
	String get s6_4_item3 => 'إنشاء حسابات متعددة للتحايل على الحظر أو التعليق أو تقييد الحساب.';
	String get s6_4_item4 => 'التلاعب بتعليقات المنتجات أو تصويتات المجتمع أو التقييمات من خلال حسابات مزيفة أو تعليقات مدفوعة الأجر أو سلوك غير حقيقي يتم تنسيقه.';
	String get s6_5_item1 => 'إزالة منشورات أو إعلانات أو صور أو تعليقات محددة.';
	String get s6_5_item2 => 'التعليق المؤقت لحق النشر في مجتمعات معينة أو على مستوى المنصة بأكملها.';
	String get s6_5_item3 => 'الحظر الدائم من جميع ميزات المنصة، بما في ذلك الشراء والبيع والمشاركة الاجتماعية.';
	String get s6_5_item4 => 'مصادرة الأرصدة المعلقة في حالات الاحتيال أو الانتهاكات الجسيمة.';
	String get s6_5_item5 => 'الإحالة إلى أجهزة إنفاذ القانون الفلسطينية أو السلطات المختصة في حالة ارتكاب مخالفات جنائية.';
	String get s9_item1 => 'تقديم شكوى عبر نظام تسوية المنازعات الخاص بالمنصة.';
	String get s9_item2 => 'منح شركة «واسلق» مهلة معقولة لا تقل عن 7 أيام عمل للتحقيق في الأمر والرد عليه.';
	String get s9_item3 => 'استرداد كامل مبلغ المعاملة المتنازع عليها من حساب المستخدم أو من أي أموال محتجزة.';
	String get s9_item4 => 'تحميل جميع الرسوم المصرفية وتكاليف المعالجة والمصروفات الإدارية ذات الصلة على عاتق المستخدم المخالف.';
	String get s9_item5 => 'حظر المستخدم بشكل دائم من المنصة.';
	String get s9_item6 => 'اتخاذ إجراءات قانونية مدنية لاسترداد جميع الخسائر والتكاليف والأضرار، بما في ذلك أتعاب المحاماة.';
	String get s11_item1 => 'أي أضرار غير مباشرة أو عرضية أو خاصة أو تبعية أو تعويضية أو عقابية.';
	String get s11_item2 => 'خسارة الأرباح أو الإيرادات أو البيانات أو الفرص التجارية أو السمعة التجارية.';
	String get s11_item3 => 'الأضرار الناجمة عن سلوك البائعين أو المشترين أو منتجاتهم أو خدماتهم.';
	String get s11_item4 => 'انقطاعات الخدمة الناجمة عن ظروف خارجة عن سيطرة «واسلق» المعقولة، بما في ذلك انقطاع خدمة الإنترنت، أو أعطال خدمات الجهات الخارجية، أو الكوارث الطبيعية، أو الاضطرابات المدنية، أو حالات القوة القاهرة.';
	String get s11_item5 => 'الوصول غير المصرح به إلى بياناتك أو تغييرها نتيجة لأفعال أطراف ثالثة خارجة عن سيطرتنا المعقولة.';
	String get s14_item1 => 'سيتم تحديث تاريخ "آخر تحديث" في أعلى هذه الصفحة.';
	String get s14_item2 => 'سيتم إخطار المستخدمين المسجلين عبر البريد الإلكتروني قبل 14 يومًا على الأقل من دخول التغييرات حيز التنفيذ.';
	String get s14_item3 => 'سيتم عرض إشعار بارز على المنصة.';
	String get s3_1_title => '3.1 معالجة المدفوعات';
	String get s3_1_body => 'تتم معالجة جميع المعاملات على منصة "Waslaq" حصريًّا عبر بوابات الدفع المعتمدة، بما في ذلك بنك فلسطين ومزودي خدمات الدفع المرخصين الآخرين. وتُحدد جميع المبالغ بالشيكل الإسرائيلي الجديد (ILS). وبإجراء طلب الشراء، فإنك تفوض المنصة بتحصيل المبلغ الكامل للطلب، بما في ذلك أي رسوم منصة سارية، من وسيلة الدفع التي اخترتها.';
	String get s3_2_title => '3.2 الحجز في حساب الضمان';
	String get s3_2_body => 'بعد إتمام الدفع بنجاح، تحتفظ المنصة بمبلغ الطلب بالكامل في حساب ضمان. ولا يتم تحويل الأموال إلى البائع إلا بعد انقضاء فترة الفحص الإلزامية دون رفع أي نزاع. وتكون فترة الفحص كما يلي:';
	String get s3_3_title => '3.3 حقوق البائع في الأموال';
	String get s3_3_intro => 'لا يكتسب البائعون أي حق قانوني مكتسب في الأموال المحتجزة حتى تنتهي فترة المراجعة دون حدوث أي نزاع. وتحتفظ شركة «واسلاق» بسلطة تقديرية مطلقة وأحادية الجانب تسمح لها بما يلي:';
	String get s3_4_title => '3.4 العملة والأسعار';
	String get s3_4_body => 'جميع الأسعار والرسوم والمبالغ المدفوعة على المنصة مقومة بالشيكل الإسرائيلي الجديد (ILS). ولا تضمن «واسلق» أسعار الصرف، كما أنها غير مسؤولة عن خسائر تحويل العملات التي يتكبدها المستخدمون الذين يجرون معاملاتهم من خارج فلسطين.';
	String get s4_1_title => '4.1 التسجيل والتحقق';
	String get s4_1_body => 'يجب على جميع البائعين إتمام عملية تسجيل البائعين في منصة "واسلق"، بما في ذلك تقديم معلومات دقيقة عن المتجر، وتحديد مناطق التوصيل، وتفاصيل حساب السحب. ويجب على البائعين إتمام عملية التحقق من الهوية (KYC) قبل التمكن من استخدام وظيفة السحب. وقد تتطلب عملية KYC تقديم ما يلي:';
	String get s4_1_kyc_failure => 'قد يؤدي عدم إتمام إجراءات "اعرف عميلك" (KYC) خلال فترة معقولة إلى تعليق الحساب وحجب الأموال المتراكمة إلى حين إتمام الإجراءات.';
	String get s4_2_title => '4.2 دقة بيانات المنتج';
	String get s4_2_body => 'يتحمل البائعون المسؤولية الكاملة والحصرية عن دقة واكتمال وقانونية وأصالة جميع قوائم المنتجات، بما في ذلك العناوين والأوصاف والصور والأسعار والمواصفات. ويجب أن تعكس قوائم المنتجات بدقة المنتج الفعلي الذي سيتسلمه المشتري.';
	String get s4_3_title => '4.3 المنتجات المقلدة وغير الأصلية';
	String get s4_3_body => 'لا يجوز للبائعين عرض منتجات مقلدة أو نسخ مقلدة أو غير أصلية إلا إذا قاموا بالإفصاح عن ذلك صراحةً وبشكل لا لبس فيه في كل من عنوان المنتج ووصفه، بطريقة لا تترك أي شك معقول في ذهن المشتري. وتشمل الصيغ المقبولة للإفصاح ما يلي:';
	String get s4_3_prohibited_title => 'ممنوع منعاً باتاً:';
	String get s4_3_prohibited_body => 'عرض أي منتج مقلد أو غير أصلي على أنه "أصلي" أو "أصلي" أو "أصيل" أو "جديد تمامًا" دون الإفصاح عن ذلك بوضوح. ويشكل هذا احتيالًا تجاريًا وانتهاكًا جوهريًا لهذه الاتفاقية، مما يمنح Waslaq الحق في إزالة جميع العروض على الفور، وتجميد رصيد البائع، وتقديم تعويضات كاملة للمشترين المتضررين، وإغلاق الحساب بشكل دائم، واللجوء إلى سبل الانتصاف القانونية المدنية والجنائية، بما في ذلك المطالبة بالتعويض عن الأضرار.';
	String get s4_4_title => '4.4 التنفيذ والتسليم';
	String get s4_4_body => 'يتحمل البائعون وحدهم مسؤولية تلبية الطلبات في غضون فترة زمنية معقولة ومحددة مسبقًا. بالنسبة للمنتجات المادية، يتحمل البائعون مسؤولية التغليف والشحن والتسليم إلى العنوان الذي يحدده المشتري. أما بالنسبة للمنتجات الرقمية، فيجب أن يتم التسليم تلقائيًا وفورًا بعد تأكيد الدفع. وقد يؤدي تكرار الإخفاق في تلبية الطلبات إلى تعليق الحساب.';
	String get s4_5_title => '4.5 التواصل مع المشترين';
	String get s4_5_body => 'يجب على البائعين الرد على استفسارات المشترين عبر نظام المراسلة الخاص بالمنصة في غضون فترة زمنية معقولة. ويجب على البائعين الامتناع عن التواصل مع المشترين عبر قنوات خارجية بهدف التحايل على أنظمة الضمان أو تسوية النزاعات الخاصة بالمنصة.';
	String get s6_intro => 'يُحظر تمامًا القيام بما يلي على منصة Waslaq. وقد تؤدي المخالفات إلى تعليق الحساب فورًا، والحظر الدائم، ومصادرة الأموال، و/أو اتخاذ إجراءات قانونية:';
	String get s6_1_title => '6.1 انتهاكات القواعد التجارية';
	String get s6_2_title => '6.2 المحتوى المخصص للبالغين والمحتوى غير الآمن للعمل — عدم التسامح مطلقًا';
	String get s6_2_zero_tolerance_title => '⚠️ سياسة عدم التسامح مطلقًا';
	String get s6_2_zero_tolerance_body => 'تُعد «واسلق» منصة تجارية صديقة للأسرة وموجهة نحو المجتمع، تخدم السوق الفلسطيني. وسيؤدي أي انتهاك لهذا البند إلى إنهاء الحساب فوراً وبشكل نهائي دون حق في الاستئناف، بغض النظر عن سجل المستخدم أو مكانته على المنصة.';
	String get s6_3_title => '6.3 الطبقة الاجتماعية ومعايير المجتمع';
	String get s6_3_intro => 'تخضع الميزات الاجتماعية في Waslaq — بما في ذلك المجموعات والمشاركات والتعليقات والرسائل المباشرة — لمعايير المجتمع التالية، بالإضافة إلى جميع المحظورات الأخرى الواردة في هذه الاتفاقية:';
	String get s6_4_title => '6.4 المخالفات الفنية والأمنية';
	String get s6_5_title => '6.5 الإنفاذ والإشراف';
	String get s6_5_body => 'تحتفظ Waslaq بالسلطة الكاملة والأحادية وغير القابلة للمراجعة في تحديد ما يشكل انتهاكًا لهذه المعايير واتخاذ الإجراءات المناسبة، سواء بإشعار مسبق أو بدونه. وتشمل إجراءات الإنفاذ، على سبيل المثال لا الحصر، ما يلي:';
	String get s6_5_report => 'يمكن للمستخدمين الإبلاغ عن المخالفات باستخدام نظام الإبلاغ المدمج في المنصة والمتاح في جميع المنشورات والملفات الشخصية والإعلانات. ويتم مراجعة جميع البلاغات من قِبل فريق الإشراف في Waslaq.';
	String get s7_1_title => '7.1 محتوى المنصة';
	String get s7_1_body => 'جميع محتويات المنصة، بما في ذلك اسم "Waslaq" وشعارها وتصميم واجهتها ورمزها المصدري ومحتواها المكتوب وميزاتها الحصرية، هي ملكية فكرية حصرية لشركة "Waslaq" وتخضع لحماية قوانين حقوق النشر والعلامات التجارية والملكية الفكرية المعمول بها. ولا يجوز لأي مستخدم إعادة إنتاج محتويات المنصة أو توزيعها أو استغلالها تجاريًا دون الحصول على موافقة خطية مسبقة.';
	String get s7_2_title => '7.2 ترخيص محتوى المستخدم';
	String get s7_2_body => 'من خلال نشر المحتوى على Waslaq (بما في ذلك قوائم المنتجات والصور والمنشورات والتعليقات ومحتوى المجتمع)، فإنك تمنح Waslaq ترخيصًا غير حصري وخاليًا من الرسوم وعالمي النطاق وقابل للترخيص من الباطن لاستخدام هذا المحتوى وعرضه وإعادة إنتاجه وتوزيعه لغرض تشغيل المنصة والترويج لها. وينتهي هذا الترخيص عند حذف المحتوى أو إغلاق حسابك، مع مراعاة متطلبات الاحتفاظ بالبيانات.';
	String get s7_3_title => '7.3 حقوق الملكية الفكرية لأطراف ثالثة';
	String get s7_3_body => 'يتحمل البائعون وحدهم المسؤولية الكاملة عن ضمان عدم انتهاك قوائم منتجاتهم وصورها وأوصافها والإشارات إلى العلامات التجارية لأي حقوق ملكية فكرية لأطراف ثالثة، بما في ذلك العلامات التجارية وحقوق النشر وبراءات الاختراع أو المظهر التجاري. ستستجيب "واسلق" لإشعارات انتهاك حقوق الملكية الفكرية الصحيحة وستقوم بإزالة المحتوى المخالف. وسيؤدي تكرار الانتهاك إلى إغلاق الحساب بشكل نهائي.';
	String get s8_1_title => '8.1 فتح نزاع';
	String get s8_1_body => 'يجب فتح النزاعات حصريًّا من خلال نظام النزاعات المدمج في المنصة، والذي يمكن الوصول إليه من صفحة تفاصيل الطلب تحت "الحساب" → "الطلبات". ويجب تقديم النزاعات قبل انتهاء "فترة الفحص" المعمول بها. وأي مطالبة يتم تقديمها بعد تحويل الأموال إلى البائع تُعتبر قانونياً بمثابة تنازل عنها ولن يتم النظر فيها.';
	String get s8_2_title => '8.2 الأدلة والإجراءات';
	String get s8_2_body => 'يقع عبء الإثبات على عاتق المشتري. ويجوز تقديم أدلة داعمة مثل الصور الفوتوغرافية ومقاطع الفيديو ولقطات الشاشة والأوصاف المكتوبة. ويجوز لـ«واسلق» أن تطلب وثائق إضافية من أي من الطرفين. وسيتم إخطار البائع ومنحه فرصة معقولة للرد خلال فترة النزاع.';
	String get s8_3_title => '8.3 قرار المنصة';
	String get s8_3_body => 'بعد مراجعة جميع الأدلة المقدمة، ستصدر «واسلق» قرارًا نهائيًا وملزمًا وغير قابل للاستئناف. وفي الحالات التي يثبت فيها خطأ البائع، يجوز لـ«واسلق» رد المبلغ إلى المشتري مباشرةً من الرصيد المتاح لدى البائع أو المودع في حساب الضمان، دون الحاجة إلى موافقة البائع. ويُعتبر قرار «واسلق» نهائيًا ويشكل تسوية كاملة ونهائية للنزاع.';
	String get s8_4_title => '8.4 إساءة استخدام نظام تسوية المنازعات';
	String get s8_4_body => 'يُعد تقديم أدلة مزورة أو ملفقة أو تم التلاعب بها في أي نزاع بمثابة احتيال. وتحتفظ "واسلاق" بالحق في إنهاء حساب المستخدم المخالف على الفور، ومصادرة أي أموال معلقة، واللجوء إلى سبل الانتصاف القانونية المدنية والجنائية.';
	String get s9_intro => 'باستخدامك لـ Waslaq، فإنك توافق صراحةً على عدم الشروع في إجراءات استرداد المبلغ من خلال البنك الذي تتعامل معه أو الجهة المصدرة لبطاقتك أو مزود خدمة الدفع دون القيام أولاً بما يلي:';
	String get s9_breach_intro => 'يُعد إجراء عملية استرداد غير مبررة أو سابقة لأوانها خرقًا جوهريًا لهذه الاتفاقية. وفي مثل هذه الحالات، تحتفظ Waslaq بالحق في:';
	String get s10_intro => 'تفرض "واسلق" الرسوم التالية، والتي تخضع للتغيير بعد إخطار مسبق مدته 30 يومًا:';
	String get table_fee_type => 'نوع الرسوم';
	String get table_amount => 'المبلغ';
	String get table_applied_to => 'يُطبق على';
	String get s10_note => 'جميع الرسوم غير قابلة للاسترداد ما لم تقرر المنصة خلاف ذلك وفقًا لتقديرها الخاص. تحتفظ Waslaq بالحق في فرض رسوم أو تعديلها أو إلغائها في أي وقت، شريطة إخطار المستخدمين المعنيين مسبقًا بفترة معقولة.';
	String get s11_body => 'تقدم "واسلق" خدماتها "كما هي" و"حسب توفرها" دون أي ضمانات من أي نوع، سواء كانت صريحة أو ضمنية، بما في ذلك على سبيل المثال لا الحصر الضمانات الضمنية المتعلقة بقابلية التسويق، أو الملاءمة لغرض معين، أو عدم الانتهاك، أو التوفر المستمر.';
	String get s11_liable_for => 'إلى أقصى حد يسمح به القانون المعمول به، لا تتحمل شركة «واسلق» أي مسؤولية عن:';
	String get s11_cap_title => 'الحد الأقصى للمسؤولية:';
	String get s11_cap_body => 'في جميع الأحوال، لا يجوز أن يتجاوز إجمالي الالتزام المالي الأقصى لشركة «واسلق» تجاه أي مستخدم فيما يتعلق بأي معاملة أو مطالبة فردية القيمة الإجمالية لتلك المعاملة المحددة كما هي مسجلة على المنصة.';
	String get s12_1_title => '12.1 بواسطة Waslaq';
	String get s12_1_body => 'تحتفظ Waslaq بالحق في تعليق أو إنهاء أي حساب بشكل دائم، سواء بإشعار مسبق أو بدونه، في حالة انتهاك هذه الاتفاقية، أو الاشتباه في حدوث احتيال، أو الإضرار بسمعة المنصة، أو لأي سبب آخر وفقًا لتقديرها الخاص. وعند الإنهاء، سيتم إلغاء حق الوصول إلى المنصة على الفور.';
	String get s12_2_title => '12.2 التأثير على الصناديق';
	String get s12_2_body => 'في حالة إنهاء الحساب لسبب وجيه (بما في ذلك الاحتيال أو الإخلال الجسيم بالشروط)، تحتفظ Waslaq بالحق في حجز أي رصيد معلّق كضمان للمطالبات أو عمليات رد المبالغ المدفوعة أو الإجراءات القانونية. وسيتم تحويل الأموال غير الخاضعة لأي مطالبة إلى حساب الدفع المسجل الخاص بالمورد في غضون 30 يومًا من تاريخ إغلاق الحساب، شريطة استكمال إجراءات "اعرف عميلك" (KYC) والتحقق من الهوية.';
	String get s12_3_title => '12.3 من جانب المستخدم';
	String get s12_3_body => 'يمكن للمستخدمين إغلاق حساباتهم في أي وقت من خلال إعدادات الحساب. وقبل الإغلاق، يجب تنفيذ أو تسوية جميع الطلبات المعلقة، كما يجب تسوية أي أموال متنازع عليها. وستحتفظ Waslaq بسجلات المعاملات وفقًا لما يقتضيه القانون المعمول به.';
	String get s13_body => 'تخضع هذه الاتفاقية لقوانين دولة فلسطين وتُفسَّر وتُنفَّذ وفقًا لها. ويخضع أي نزاع أو خلاف أو مطالبة تنشأ عن هذه الاتفاقية أو تتعلق بها، بما في ذلك إبرامها أو صلاحيتها أو خرقها أو إنهاؤها، للاختصاص القضائي الحصري للمحاكم الفلسطينية المختصة. ويخضع المستخدمون بشكل نهائي للاختصاص القضائي الشخصي لهذه المحاكم ويتنازلون عن أي اعتراض على الإجراءات أمامها بحجة المكان أو عدم ملاءمة المحكمة.';
	String get s14_intro => 'تحتفظ Waslaq بالحق في تعديل شروط الاستخدام هذه أو تحديثها أو استبدالها في أي وقت. وعند إجراء تغييرات جوهرية:';
	String get s14_acceptance => 'إن استمرار استخدام المنصة بعد تاريخ سريان أي تعديل يُعتبر موافقة كاملة وغير مشروطة من جانبك على الشروط المعدلة. إذا لم توافق على الشروط المعدلة، فيجب عليك التوقف عن استخدام المنصة ويحق لك طلب حذف حسابك.';
	String get footer_questions_title => 'هل لديك أسئلة حول هذه الشروط؟';
	String get footer_contact_text => 'اتصل بفريقنا القانوني على ... أو تفضل بزيارة موقعنا';
	String get table_fee_row1_type => 'رسوم منصة الطلبات المادية';
	String get table_fee_row1_amount => '2 شيكل ثابت لكل طلب';
	String get table_fee_row1_applied => 'يتم تضمينها في المبلغ الإجمالي كرسوم توصيل/خدمة';
	String get table_fee_row2_type => 'رسوم منصة المنتجات الرقمية';
	String get table_fee_row2_amount => 'شيكل واحد لكل قطعة';
	String get table_fee_row2_applied => 'يُخصم من المبلغ الإجمالي عند تقديم الطلب';
	String get table_fee_row3_type => 'عمولة الدفع للبائع';
	String get table_fee_row3_amount => '5% من مبلغ الدفع';
	String get table_fee_row3_applied => 'يُخصم عند تنفيذ عملية الدفع';
	String get table_fee_row4_type => 'رسوم التحويل المصرفي';
	String get table_fee_row4_amount => '8 شواقل ثابتة لكل عملية تحويل';
	String get table_fee_row4_applied => 'تم استيعابها من قبل المنصة — لم يتم تحميلها على المورد';
}

// Path: refund
class StringsRefundEn {
	StringsRefundEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get page_title => 'سياسة الاسترداد والإرجاع';
	String get last_updated => 'تاريخ السريان: 1 مايو 2026 · آخر تحديث: 1 مايو 2026';
	String get intro => 'تلتزم "واسلق" بتوفير تجربة تسوق عادلة وشفافة وآمنة. تحدد سياسة الاسترداد والإرجاع هذه الشروط التي يحق للمشترين بموجبها استرداد أموالهم، وإجراءات تسوية النزاعات، والتزامات البائعين فيما يتعلق بالإرجاع، والحقوق والقيود السارية على جميع الأطراف.';
	String get s1_title => 'نافذة الفحص';
	String get s2_title => 'شروط استحقاق استرداد المبلغ';
	String get s3_title => 'الحالات غير المؤهلة';
	String get s4_title => 'كيفية فتح نزاع';
	String get s5_title => 'عبء الإثبات';
	String get s6_title => 'معالجة عمليات استرداد الأموال';
	String get s7_title => 'سياسات إرجاع البائعين';
	String get s8_title => 'المنتجات الرقمية — أحكام خاصة';
	String get s9_title => 'التزامات البائع فيما يتعلق برد الأموال';
	String get s10_title => 'الاتصال والدعم';
	String get buyer_protection_title => 'حماية المشتري من Waslaq';
	String get buyer_protection_desc => 'يتم حماية كل طلب يتم تقديمه على منصة "واسلق" من خلال نظام الضمان الخاص بنا. حيث تحتفظ المنصة بأموالك في حساب آمن، ولا يتم تحويلها إلى البائع إلا بعد انتهاء فترة الفحص الإلزامية — مما يمنحك الوقت الكافي للتأكد من وصول طلبك بشكل صحيح ومطابق للوصف. ولا يُطلب منك أبدًا قبول أي طلب معيب أو غير صحيح أو مزيف.';
	String get s1_body1 => 'تُعد «فترة المراجعة» فترة تعليق إلزامية تبدأ عند تسليم الطلب أو تأكيد الشحن من البائع. خلال هذه الفترة، تظل الأموال مودعة في حساب الضمان ولا يتم تحويلها إلى البائع. يجب عليك فتح أي نزاع قبل انتهاء هذه الفترة.';
	String get physical_products_label => 'المنتجات المادية';
	String get physical_products_body => '48 ساعة من لحظة قيام البائع بوضع علامة "تم الشحن" على الطلب أو تأكيد التسليم.';
	String get digital_products_label => 'المنتجات الرقمية';
	String get digital_products_body => '24 ساعة من وقت تسليم المفتاح الرقمي أو الملف أو بيانات اعتماد الوصول إلى المشتري.';
	String get s1_important => 'بمجرد انتهاء فترة المراجعة وتحويل الأموال إلى البائع، تعتبر المعاملة نهائية ومُسوَّاة من الناحية القانونية. ولن يتم قبول أي مطالبات باسترداد الأموال بعد هذه المرحلة تحت أي ظرف من الظروف، باستثناء حالات الاحتيال المؤكدة وفقًا لتقدير المنصة وحدها.';
	String get s2_intro => 'تغطي خدمة حماية المشتري من Waslaq الحالات التالية. وفي كل حالة، يجب فتح نزاع قبل انتهاء فترة الفحص، ويجب أن يتضمن أدلة داعمة:';
	String get s2_item1_title => 'لم يتم استلام المنتج';
	String get s2_item1_body => 'لم يقم البائع بشحن الطلب في غضون فترة زمنية معقولة، ولم يقدم أي تحديث صالح لتتبع الشحنة أو تأكيدًا بالتسليم. ولم يستلم المشتري السلعة، ولا يوجد أي دليل على محاولة التسليم.';
	String get s2_item2_title => 'يختلف بشكل كبير عما هو موصوف';
	String get s2_item2_body => 'يختلف المنتج المستلم اختلافًا جوهريًا وجوهريًا عما ورد في الإعلان — على سبيل المثال، منتج خاطئ تمامًا، أو لون أو مقاس خاطئ لم يتم الإفصاح عنه، أو مكونات مفقودة كانت جزءًا من المنتج المُعلن عنه، أو حالة (مثل: مستعمل مقابل جديد) تتعارض مع ما ورد في الإعلان.';
	String get s2_item3_title => 'وصلت السلعة تالفة';
	String get s2_item3_body => 'وصل المنتج في حالة تجعله غير صالح للاستخدام أو مكسورًا أو غير قابل للاستخدام فعليًّا، حيث وقع التلف قبل استلامه من قِبل المشتري. يجب على المشتري تقديم دليل مصور أو مسجل بالفيديو يثبت التلف الذي حدث عند فتح العبوة أو عند الاستخدام الأول.';
	String get s2_item4_title => 'منتج مقلد دون الإفصاح عن ذلك';
	String get s2_item4_body => 'تم عرض منتج وبيعه على أنه أصلي أو حقيقي أو يحمل علامة تجارية معروفة، لكن المنتج الذي تم استلامه مزيف بشكل واضح أو غير أصلي دون الإفصاح عن ذلك مسبقًا في الإعلان. ملاحظة: إذا كان الإعلان قد أشار إلى أن المنتج نسخة مقلدة أو غير أصلي، فلا ينطبق هذا الشرط.';
	String get s2_item5_title => 'منتج رقمي غير وظيفي';
	String get s2_item5_body => 'المفتاح الرقمي أو رمز التفعيل أو الملف القابل للتنزيل غير صالح أو منتهي الصلاحية أو تم استخدامه بالفعل من قبل مستخدم سابق أو تالف أو غير صالح للاستخدام لأي سبب آخر وقت التسليم. يجب على المشتري تقديم دليل على الخلل (مثل لقطة شاشة لرسالة الخطأ الصادرة عن المنصة أو الناشر).';
	String get s2_item6_title => 'تكرار الرسوم';
	String get s2_item6_body => 'تم تحصيل المبلغ من المشتري أكثر من مرة عن نفس الطلب بسبب خطأ في معالجة الدفع. ويجب أن تتضمن الأدلة سجلات تأكيد الدفع.';
	String get s3_intro => 'لا تشمل خدمة «حماية المشتري من واسلق» الحالات التالية بشكل صريح:';
	String get s3_item1_title => 'تغيير الرأي';
	String get s3_item1_body => 'تلقى المشتري المنتج الصحيح الذي لم يتعرض لأي تلف والذي تمت وصفه بدقة، ولكنه ببساطة لم يعد يرغب فيه. في هذه الحالة، تُطبق سياسة الإرجاع الخاصة بالبائع حصريًّا. ولا تتدخل Waslaq في عمليات الإرجاع الناجمة عن تغيير الرأي.';
	String get s3_item2_title => 'فترة تقديم المطالبات بعد الفحص';
	String get s3_item2_body => 'أي نزاع أو طلب استرداد يُقدم بعد انتهاء فترة الفحص وتسديد المبلغ إلى البائع. تُعتبر هذه المطالبات قد تم التنازل عنها قانونًا ولن يتم النظر فيها.';
	String get s3_item3_title => 'الأضرار التي يتسبب فيها المشتري';
	String get s3_item3_body => 'السلع التي كانت في حالة جيدة عند التسليم، لكنها تعرضت للتلف لاحقًا بسبب سوء الاستخدام أو التعامل غير السليم أو التعديل أو التلف العرضي من جانب المشتري.';
	String get s3_item4_title => 'المنتجات المعلن عنها على أنها غير أصلية أو مقلدة';
	String get s3_item4_body => 'المنتجات التي تم وصفها بوضوح وصراحة في عنوان الإعلان ووصفه على أنها مزيفة أو نسخة طبق الأصل أو مقلدة أو غير أصلية. وبشراء هذه المنتجات، يكون المشتري قد وافق عن علم على طبيعة المنتج.';
	String get s3_item5_title => 'المنتجات الرقمية التي تم استرداد قيمتها';
	String get s3_item5_body => 'المفاتيح الرقمية أو الرموز أو القسائم التي تم استرداد قيمتها أو تفعيلها أو استخدامها بالفعل من قِبل المشتري أو أي طرف شاركه المشتري الرمز، بغض النظر عما إذا كان المنتج قد حقق التوقعات بعد ذلك أم لا.';
	String get s3_item6_title => 'مشاكل عدم التوافق المعروفة وقت الشراء';
	String get s3_item6_body => 'المنتجات التي تعمل بالشكل الموصوف، ولكنها غير متوافقة مع الجهاز أو المنطقة أو الحساب أو المنصة الخاصة بالمشتري، شريطة أن تكون متطلبات التوافق هذه قد تم الإفصاح عنها أو كان من الممكن اكتشافها بشكل معقول في وصف المنتج.';
	String get s3_item7_title => 'اختلافات طفيفة في المظهر';
	String get s3_item7_body => 'اختلافات طفيفة في اللون، أو اختلافات في التغليف، أو عيوب شكلية بسيطة لا تؤثر بشكل جوهري على وظيفة المنتج أو قابليته للاستخدام، وتقع ضمن حدود التفاوت الطبيعية للمنتج.';
	String get s4_intro => 'لطلب استرداد المبلغ أو الإبلاغ عن مشكلة تتعلق بطلبك، اتبع الخطوات التالية:';
	String get s4_step1 => 'انتقل إلى "الحساب" → "الطلبات" وابحث عن الطلب المطلوب باستخدام رقم الطلب أو التاريخ.';
	String get s4_step2 => 'انقر على "فتح نزاع" في صفحة تفاصيل الطلب. هذا الخيار متاح فقط خلال فترة الفحص السارية.';
	String get s4_step3 => 'اختر سبب النزاع الأكثر دقة من بين الفئات المتاحة.';
	String get s4_step4 => 'يرجى تقديم وصف مكتوب مفصل للمشكلة، بما في ذلك التواريخ ذات الصلة، وما استلمته، وكيف يختلف عما كان مذكورًا.';
	String get s4_step5 => 'قم بتحميل الأدلة الداعمة: الصور الفوتوغرافية، ومقاطع الفيديو، ولقطات الشاشة، والإيصالات، أو أي وثائق تدعم مطالبتك. فكلما كانت أدلتك أقوى، زادت سرعة حل المشكلة.';
	String get s4_step6 => 'أرسل النزاع. ستتلقى إشعارًا بالتأكيد. سيتم إخطار البائع ومنحه مهلة للرد.';
	String get s4_step7 => 'تابع حالة النزاع من حسابك. قد تتصل بك "واسلق" لطلب معلومات إضافية. يرجى الرد بسرعة لتجنب أي تأخير.';
	String get s4_step8 => 'ستقوم "واسلق" بمراجعة جميع الأدلة وإصدار قرار نهائي ملزم. سيتم إخطارك بالنتيجة عبر البريد الإلكتروني وإشعار داخل التطبيق.';
	String get s4_tip => 'نصيحة: للحصول على حل أسرع، قم بفتح شكواك في أقرب وقت ممكن خلال فترة الفحص، وقدم أدلة شاملة في شكل صور أو مقاطع فيديو فور اكتشاف المشكلة.';
	String get s5_body => 'يقع عبء الإثبات على عاتق المشتري. ولا تقبل "واسلاق" إصدار حكم لصالح المشتري إلا بعد تقديم أدلة قاطعة. وتشمل الأدلة المقبولة ما يلي:';
	String get s5_item1 => 'صور فوتوغرافية أو مقاطع فيديو واضحة للسلعة المستلمة تُظهر بوضوح العيب أو التلف أو التباين.';
	String get s5_item2 => 'مقارنة جنبًا إلى جنب بين الصور والوصف الوارد في الإعلان والمنتج المستلم.';
	String get s5_item3 => 'لقطات شاشة لرسائل الخطأ الخاصة بالمنتجات الرقمية المعطلة، بما في ذلك ردود المنصة أو الناشر على هذه الأخطاء.';
	String get s5_item4 => 'صور التغليف التي توضح حالة المنتج عند وصوله (مفيدة في حالات المطالبة بالتعويض عن الأضرار).';
	String get s5_item5 => 'التواصل الكتابي مع البائع عبر نظام المراسلة الخاص بالمنصة.';
	String get s5_warning => 'تحذير بشأن الاحتيال: يُعد تقديم أدلة مزورة أو ملفقة أو مزيفة أو تم التلاعب بها في أي نزاع بمثابة احتيال وانتهاك خطير لشروط استخدام «واسلق». وسيتم إغلاق حسابات المخالفين فوراً وبشكل نهائي، ومصادرة جميع الأرصدة المعلقة، وقد يتم الإبلاغ عنهم إلى السلطات الفلسطينية المختصة لاتخاذ الإجراءات القانونية اللازمة.';
	String get s6_1_title => 'عندما يُحسم النزاع لصالح المشتري';
	String get s6_1_item1 => 'الأموال التي لا تزال مودعة في حساب الضمان: يتم إلغاء عملية دفع الأموال المودعة في حساب الضمان على الفور وإعادتها إلى وسيلة الدفع الأصلية للمشتري. ولا يتعين على البائع اتخاذ أي إجراء.';
	String get s6_1_item2 => 'الأموال التي تم تحويلها بالفعل إلى المورد: يتم خصم مبلغ الاسترداد مباشرةً من الرصيد المتاح للمورد. وإذا كان رصيد المورد غير كافٍ، فستقوم المنصة باحتجاز الأرباح المستقبلية حتى يتم سداد الدين بالكامل.';
	String get s6_1_item3 => 'استرداد كامل المبلغ: يتم إعادة المبلغ الكامل للطلب إلى المشتري، بما في ذلك أي رسوم خدمة للمنصة، إن وجدت.';
	String get s6_1_item4 => 'استرداد جزئي (حل جزئي): في الحالات التي يثبت فيها وجود خطأ جزئي من كلا الطرفين، يجوز لشركة «واسلق» إصدار استرداد جزئي وفقًا لتقديرها الخاص والنهائي.';
	String get s6_2_title => 'الجدول الزمني لاسترداد الأموال';
	String get s6_2_body => 'تختلف مدة معالجة عمليات استرداد الأموال باختلاف مزود خدمة الدفع الذي تستخدمه:';
	String get s6_2_item1 => 'بنك فلسطين والبوابات المحلية: من 3 إلى 7 أيام عمل من تاريخ اتخاذ القرار.';
	String get s6_2_item2 => 'طرق الدفع الأخرى: قد يستغرق الأمر ما يصل إلى 14 يوم عمل، حسب المزود.';
	String get s6_2_note => 'لا تتحمل "واسلق" المسؤولية عن أي تأخير ناجم عن المدة التي يستغرقها البنك الذي تتعامل معه أو مزود خدمة الدفع في معالجة المعاملة.';
	String get s7_body1 => 'بالإضافة إلى الحماية التي توفرها منصة Waslaq، يجوز للبائعين نشر سياساتهم الخاصة بالإرجاع والاستبدال وخدمات ما بعد البيع على صفحة متجرهم العامة. وتسري هذه السياسات الخاصة بالبائعين حصريًّا على الحالات التي لا تشملها "حماية المشتري من Waslaq" — وأكثرها شيوعًا هي حالات الإرجاع بسبب تغيير الرأي في الطلبات التي تم تنفيذها بشكل صحيح.';
	String get s7_body2 => 'لا تفرض "واسلق" سياسات الإرجاع الخاصة بالبائعين ولا تضمنها. وعلى المشترين الراغبين في إرجاع المنتجات أو استبدالها بموجب سياسة البائع الخاصة بالتنسيق مباشرةً مع البائع عبر نظام المراسلة الخاص بالمنصة.';
	String get s7_tip => 'قبل الشراء، نوصي بالاطلاع على سياسة الإرجاع التي ينشرها البائع على صفحة متجره، لا سيما بالنسبة للسلع عالية القيمة أو المنتجات التي تعتمد على التفضيل الشخصي.';
	String get s8_body => 'تخضع المنتجات الرقمية، بما في ذلك مفاتيح الألعاب وتراخيص البرامج والقسائم والملفات القابلة للتنزيل ورموز التنشيط، للأحكام الإضافية التالية:';
	String get s8_item1 => 'التسليم الفوري: يتم تسليم المنتجات الرقمية تلقائيًا فور تأكيد الدفع. ويُعتبر التسليم قد اكتمل عندما يصبح الرمز أو الملف متاحًا في حساب المشتري أو يتم إرساله عبر البريد الإلكتروني.';
	String get s8_item2 => 'فترة فحص مدتها 24 ساعة: يتاح للمشترين 24 ساعة من تاريخ الاستلام لاختبار المنتج والإبلاغ عن أي مشاكل. بعد انقضاء هذه الفترة، تصبح عملية البيع نهائية.';
	String get s8_item3 => 'المفاتيح غير الصالحة: إذا كان المفتاح غير صالح أو تم استخدامه بالفعل عند التسليم، يجب على المشتري تقديم لقطة شاشة لرسالة الخطأ الصادرة عن الناشر. يتم رد قيمة المطالبات الصحيحة بالكامل.';
	String get s8_item4 => 'لا يُسمح باسترداد المبلغ بعد الاستخدام: بمجرد استرداد المفتاح الرقمي أو الرمز أو الترخيص، أو تفعيله، أو استخدامه — حتى لو كان ذلك جزئيًا — يُعتبر قد تم استهلاكه بالكامل، ولن يتم استرداد المبلغ بأي حال من الأحوال، بغض النظر عن مدى الرضا.';
	String get s8_item5 => 'مشاكل تقييد المنطقة: يتحمل المشتري مسؤولية التحقق من التوافق الإقليمي قبل الشراء. لا يُسمح برد الأموال في حالة المنتجات المقيدة إقليمياً إذا كان التقييد الإقليمي قد تم الإفصاح عنه أو كان من الممكن تحديده بشكل معقول من خلال وصف المنتج.';
	String get s9_role_title => 'توضيح دور المنصة';
	String get s9_role_body1 => 'تعمل "واسلق" حصريًّا كوسيط تقني ومالي — أي كطرف محايد بين المشترين والبائعين. ولا تتحمل المنصة أي مسؤولية عن التسليم المادي أو التغليف أو الشحن أو الخدمات اللوجستية لأي طلب. وتقع جميع التزامات التسليم بالكامل على عاتق البائع. ولا تقوم "واسلق" بتخزين البضائع المادية أو شحنها أو مناولتها أو فحصها في أي مرحلة من المراحل.';
	String get s9_role_body2 => 'بالإضافة إلى ذلك، بمجرد انتهاء فترة الفحص وإطلاق الأموال، لا تتحمل المنصة أي مسؤولية مالية عن أي طلبات استرداد أو إرجاع لاحقة. وتصبح هذه الطلبات مسألة تخص المشتري والبائع حصريًّا، وتخضع لسياسة الإرجاع التي ينشرها البائع. ولن تتدخل "واسلق" أو تتوسط أو تمول عمليات الإرجاع خارج فترة الفحص السارية تحت أي ظرف من الظروف.';
	String get s9_vendor_intro => 'يلتزم البائعون على منصة "واسلق" بالالتزامات التالية المتعلقة برد الأموال وإرجاع المنتجات:';
	String get s9_vendor_item1 => 'يجب على البائعين التأكد من أن جميع المنتجات المشحونة تتطابق تمامًا مع الوصف والحالة والمواصفات الواردة في الإعلان.';
	String get s9_vendor_item2 => 'يجب على البائعين الرد على إخطارات النزاع خلال المدة الزمنية التي تحددها المنصة. ويُعتبر عدم الرد اعترافًا ضمنيًا وقد يؤدي إلى رد المبلغ تلقائيًا إلى المشتري.';
	String get s9_vendor_item3 => 'يجب على البائعين الامتناع عن الاتصال بالمشترين خارج نظام المراسلة الخاص بالمنصة، وذلك بهدف ثنيهم عن رفع النزاعات أو عرض ترتيبات تعويض غير مصرح بها.';
	String get s9_vendor_item4 => 'في الحالات التي يتم فيها إصدار رد أموال من رصيد البائع، يوافق البائع بشكل نهائي على هذا الخصم كشرط للمشاركة في المنصة.';
	String get s9_vendor_item5 => 'قد تؤدي النزاعات المتكررة بشأن استرداد الأموال التي يتم الفصل فيها ضد البائع إلى مراجعة الحساب، أو إطالة فترات الاحتجاز في حساب الضمان، أو تعليق الحساب.';
	String get s10_intro => 'للاستفسار عن هذه السياسة، أو للحصول على المساعدة في رفع نزاع، أو للحصول على الدعم بشأن طلب معين:';
	String get s10_item1 => 'استخدم نظام النزاعات مباشرةً من صفحة طلبك: الحساب → الطلبات → [الطلب] → فتح نزاع';
	String get s10_item2 => 'يرجى الاتصال بفريق الدعم لدينا على العنوان support@waslaq.com';
	String get s10_item3 => 'أرسل طلب دعم عبر صفحة الاتصال الخاصة بنا';
	String get s10_note => 'الدعم متاح باللغتين العربية والإنجليزية. ونسعى للرد على جميع الاستفسارات في غضون يوم إلى يومين عمل.';
	String get s3_body => 'لا تشمل خدمة «حماية المشتري من واسلق» الحالات التالية بشكل صريح:';
	String get s4_body => 'لطلب استرداد المبلغ أو الإبلاغ عن مشكلة تتعلق بطلبك، اتبع الخطوات التالية:';
	String get s10_body => 'للاستفسار عن هذه السياسة، أو للحصول على المساعدة في رفع نزاع، أو للحصول على الدعم بخصوص طلب معين:';
	String get footer_related_policies => 'السياسات ذات الصلة';
	String get cookie_policy_link => 'سياسة ملفات تعريف الارتباط';
	String get contact_support_link => 'اتصل بالدعم الفني';
}

// Path: vendor_finances
class StringsVendorFinancesEn {
	StringsVendorFinancesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get ready_to_withdraw => 'جاهز للسحب';
	String get pending_escrow => 'قيد الانتظار (حساب الضمان)';
	String get awaiting_release => 'في انتظار إصدار الإذن بالتنفيذ';
	String get total_paid_out => 'إجمالي المبالغ المدفوعة';
	String get lifetime_withdrawals => 'عمليات السحب على مدى العمر';
	String get request_withdrawal => 'طلب السحب';
	String get amount_ils => 'المبلغ (شيكل إسرائيلي)';
	String get request_payout => 'طلب سحب الأموال';
	String get payout_note => 'يتم معالجة عمليات الدفع يدويًّا من قِبل مسؤول المنصة في غضون 2 إلى 5 أيام عمل.';
	String get transaction_ledger => 'دفتر الأستاذ';
	String get no_transactions => 'لا توجد معاملات حتى الآن.';
}

// Path: vendor_settings
class StringsVendorSettingsEn {
	StringsVendorSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get store_logo => 'شعار المتجر';
	String get tap_to_change => 'انقر لتغيير';
	String get store_info => 'معلومات عامة';
	String get store_name => 'اسم المتجر';
	String get store_description => 'وصف المتجر';
	String get contact => 'الاتصال';
	String get phone => 'الهاتف';
	String get delivery => 'التسليم';
	String get store_location => 'موقع المتجر (المدينة)';
	String get location_placeholder => 'على سبيل المثال: غزة، رام الله';
	String get delivery_zone => 'منطقة التوصيل';
	String get select_zone => 'اختر المنطقة...';
	String get zone_note => 'لن يتم توصيل المنتجات المادية إلا داخل المنطقة التي اخترتها.';
	String get payout => 'المبلغ المدفوع';
	String get payout_account => 'حساب التحويل (IBAN أو PayPal)';
	String get payout_placeholder => 'أدخل رقم IBAN أو عنوان بريدك الإلكتروني على PayPal';
	String get payout_hint => 'سيتم إرسال مدفوعاتك إلى هذا العنوان. تأكد من صحته.';
	String get save_settings => 'حفظ الإعدادات';
}

// Path: vendor_policies
class StringsVendorPoliciesEn {
	StringsVendorPoliciesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'سياسات المتجر';
	String get audit_note => 'يؤدي تحديث سياساتك إلى إنشاء نسخة جديدة دائمة وقابلة للتدقيق القانوني. ويتم الاحتفاظ بالإصدارات السابقة.';
	String get shipping_policy => 'سياسة الشحن';
	String get shipping_placeholder => 'أدخل سياسة الشحن الخاصة بك...';
	String get refund_policy => 'سياسة الإرجاع والاسترداد';
	String get refund_placeholder => 'أدخل سياسة الإرجاع والاسترداد الخاصة بك...';
	String get save => 'حفظ السياسات';
}

// Path: digital_vault
class StringsDigitalVaultEn {
	StringsDigitalVaultEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'الخزينة الرقمية';
	String get subtitle => 'المنتجات الرقمية التي اشتريتها. يُسمح بتنزيل كل منتج مرة واحدة خلال 24 ساعة من الشراء.';
	String get expired => 'منتهية الصلاحية';
	String get digital_product => 'المنتج الرقمي';
	String get downloads => 'التنزيلات';
	String get order => 'طلب';
	String get expired_on => 'انتهت صلاحيتها في';
	String get limit_reached => 'تم الوصول إلى الحد الأقصى';
}

// Path: vendor_products
class StringsVendorProductsEn {
	StringsVendorProductsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'منتجات متجرك';
	String get subtitle => 'قم بإدارة عناصر الكتالوج المادية والرقمية.';
	String get cancel_creation => 'إلغاء الإنشاء';
	String get bulk_edit_stock => 'التعديل الجماعي للمخزون';
	String get create_new_product => 'إنشاء منتج جديد';
	String get product_details => 'تفاصيل المنتج';
	String get product_details_subtitle => 'معلومات أساسية عن المنتج الذي تبيعه.';
	String get product_title => 'اسم المنتج';
	String get product_title_placeholder => 'مثل: وعاء خزفي مصنوع يدويًا';
	String get description => 'الوصف';
	String get description_placeholder => 'أخبر المشترين عن منتجك وميزاته والمواد المصنوع منها أو تعليمات الاستخدام...';
	String get product_type => 'نوع المنتج';
	String get virtual_digital => 'افتراضي / رقمي';
	String get physical_item => 'المنتج المادي';
	String get virtual_desc => 'البرامج، ملفات PDF، الوسائط، مفاتيح التفعيل';
	String get physical_desc => 'يتطلب الشحن';
	String get category => 'الفئة';
	String get select_parent_category => 'اختر الفئة الرئيسية';
	String get select_subcategory => 'اختر فئة فرعية (اختياري)';
	String get category_hint => 'يساعد اختيار فئة فرعية محددة العملاء على العثور على منتجك بسهولة أكبر.';
	String get product_images => 'صور المنتج';
	String get add_images => 'إضافة صور';
	String get digital_asset_label => 'الأصل الرقمي / رابط الاسترداد';
	String get upload_file_label => 'الخيار 1: تحميل ملف (بحد أقصى 128 ميغابايت)';
	String get choose_file => 'اختر ملفًا لتحميله...';
	String get or => 'أو';
	String get external_link_label => 'الخيار 2: توفير رابط خارجي';
	String get external_link_placeholder => 'https://g2a.com/... أو رابط Google Drive';
	String get digital_delivery_note => 'سيتلقى العملاء هذا الملف أو الرابط تلقائيًا عبر بريدهم الإلكتروني فور إتمام عملية الدفع بنجاح.';
	String get inventory_notice => 'إشعار بشأن المخزون';
	String get inventory_note => 'تتطلب المنتجات المادية تتبعًا. يمنع نظام المخزون الذكي لدينا البيع الزائد ويوقف عملية الدفع في حالة نفاد المنتج أثناء عملية الشراء. سيتم إرسال بريد إلكتروني إليك فورًا عندما يصل مخزون المنتج إلى 0.';
	String get discard => 'تجاهل';
	String get launch_product => 'إطلاق المنتج';
	String get no_products => 'لا توجد منتجات حتى الآن';
	String get no_products_desc => 'ابدأ بإدراج أول منتج مادي أو رقمي لديك للوصول إلى العملاء في جميع أنحاء العالم.';
	String get list_first_item => 'أدرج العنصر الأول';
	String get edit_product => 'تعديل المنتج';
	String get price_ils => 'السعر (شواقل إسرائيلية)';
	String get save_changes => 'حفظ التغييرات';
	String get bulk_inventory_title => 'تحرير المخزون بالجملة';
	String get bulk_inventory_subtitle => 'اضغط على رقم لتعديله';
	String get units => 'الوحدات';
	String get default_label => 'الافتراضي';
	String get cancel => 'إلغاء';
	String get save_all_changes => 'حفظ جميع التغييرات';
	String get no_managed_inventory => 'لم يتم العثور على أي منتجات ذات مخزون مُدار.';
	String get delete_confirm => 'هل أنت متأكد من رغبتك في حذف هذا المنتج؟ لا يمكن التراجع عن هذا الإجراء.';
	String get price_placeholder => 'على سبيل المثال: 99.99';
	String get file_size_error => 'حجم الملف يتجاوز الحد الأقصى البالغ 128 ميغابايت.';
	String get upload_url_error => 'فشل الحصول على رابط التحميل';
	String get upload_failed_error => 'فشل تحميل الملف إلى R2';
	String get create_failed_error => 'فشل إنشاء المنتج';
	String get unexpected_upload_error => 'حدث خطأ غير متوقع أثناء التحميل.';
	String get delete_failed_error => 'فشل حذف المنتج';
	String get delete_error => 'حدث خطأ أثناء حذف المنتج.';
	String get update_failed_error => 'فشل تحديث المنتج';
	String get generic_error => 'حدث خطأ';
	String get invalid_qty => 'غير صالح';
	String get bulk_update_failed => 'فشلت بعض عمليات التحديث. يرجى المحاولة مرة أخرى.';
	String get options_title => 'خيارات المنتج (اللون، الحجم، المادة)';
	String get add_option => 'إضافة + خيار';
	String get no_options_note => 'لم يتم تكوين أي خيارات. سيتم إنشاء هذا كنسخة افتراضية واحدة.';
	String get variant_matrix => 'مصفوفة المتغيرات';
	String get track_stock => 'مخزون القضبان';
	String get price_column => 'السعر (شواقل إسرائيلية)';
	String get sku => 'رقم المنتج';
	String get variant_column => 'صيغة';
	String get default_config => 'الإعدادات الافتراضية';
	String get type_physical => 'البدني';
	String get type_digital => 'رقمي';
	String get option_name => 'اسم الخيار';
	String get comma_separated_values => 'قيم مفصولة بفواصل';
	String get option_name_placeholder => 'على سبيل المثال، اللون';
	String get values_placeholder => 'على سبيل المثال: الأحمر، الأزرق، الأخضر';
	String get stock_qty => 'كمية المخزون';
	String get dimensions => 'الأبعاد (العرض/الطول/الارتفاع)';
	String get sku_placeholder => 'SKU-123';
	String get weight_placeholder => 'مثل: 0.5';
	String get height_placeholder => 'ح';
	String get inventory_label => 'المخزون';
	String get unlimited => 'بلا حدود';
	String get out_of_stock => 'غير متوفر';
}

// Path: vendor_orders
class StringsVendorOrdersEn {
	StringsVendorOrdersEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'طلباتي';
	String get ship_to => 'الشحن إلى:';
	String get status_shipped => 'تم الشحن';
	String get status_pending => 'قيد الانتظار';
	String get status_processing => 'المعالجة';
	String get status_delivered => 'تم التسليم';
	String get status_cancelled => 'تم إلغاؤه';
	String get status_awaiting_pickup => 'في انتظار الاستلام';
	String get no_orders => 'لا توجد طلبات حتى الآن';
	String get no_orders_desc => 'عندما يشتري العملاء منتجاتك، ستظهر الطلبات هنا.';
	String get mark_shipped => 'وضع علامة "تم الشحن"';
	String get shipping_loading => 'الشحن…';
	String get order_number => 'رقم الطلب';
	String get status_completed => 'تم الانتهاء';
}

// Path: dispute
class StringsDisputeEn {
	StringsDisputeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get back => 'العودة';
	String get case_resolved_vendor => 'تمت تسوية القضية: تم تحويل الأموال إلى المورد';
	String get case_resolved_buyer => 'تمت تسوية القضية: تم رد المبلغ إلى المشتري';
	String get case_resolved_full_refund => '✅ تم حل القضية: تم إصدار استرداد كامل للمبلغ';
	String get dispute_opened => 'تم فتح النزاع';
	String get under_review => 'قيد المراجعة';
	String get image_attachment => 'صورة مرفقة';
	String get admin_badge => 'المسؤول';
	String get loading_chat => 'جاري تحميل الدردشة...';
	String get not_found => 'لم يتم العثور على النزاع.';
	String get no_messages => 'لا توجد رسائل حتى الآن. أرسل رسالة لبدء المحادثة.';
	String get input_placeholder => 'اشرح مشكلتك للمورد والمسؤول...';
	String get attachment_label => '📎 المرفق';
	String get status_open => 'فتح';
	String get status_resolved_refund => 'تم حل المشكلة (استرداد المبلغ)';
	String get status_resolved_release => 'تم حله (تم إصداره)';
	String get status_resolved_split => 'تم حله (مقسم)';
	String get status_under_review => 'قيد المراجعة';
}

// Path: stores
class StringsStoresEn {
	StringsStoresEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'تصفح المتاجر';
	String get subtitle => 'اكتشف البائعين الفلسطينيين المفضلين لديك وتابعهم.';
	String get no_stores => 'لا توجد متاجر حتى الآن.';
	String get retry => 'Retry';
	String get no_stores_yet => 'No stores yet';
}

// Path: social
class StringsSocialEn {
	StringsSocialEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get message_button => 'Message';
	String get follow_button => 'Follow';
	String get visit_store_button => 'Visit My Store';
	String get share_button => 'Share';
	String get comments_heading => 'Comments';
	String get comment_placeholder => 'What\'s on your mind?';
	String get comment_button => 'Comment';
	String get no_comments => 'No comments yet';
	String get pending_button => 'Pending';
	String get following_button => 'Following';
	String get replying_to => 'Replying to';
	String get protected_posts_title => 'These posts are protected';
	String get protected_posts_desc => 'Only approved followers can view posts.';
	String get no_posts => 'No posts yet.';
	String get no_replies => 'No replies yet.';
	String get no_media => 'No media yet.';
	String years_ago({required Object n}) => '${n}y ago';
	String months_ago({required Object n}) => '${n}mo ago';
	String days_ago({required Object n}) => '${n}d ago';
	String hours_ago({required Object n}) => '${n}h ago';
	String minutes_ago({required Object n}) => '${n}m ago';
	String get just_now => 'just now';
	String years_short({required Object n}) => '${n}y';
	String months_short({required Object n}) => '${n}mo';
	String days_short({required Object n}) => '${n}d';
	String hours_short({required Object n}) => '${n}h';
	String minutes_short({required Object n}) => '${n}m';
	String get now_short => 'now';
	String share_post({required Object title, required Object url}) => 'Check out this post on WaslaQ: ${title}\n${url}';
}

// Path: store
class StringsStoreEn {
	StringsStoreEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Store';
	String get all_categories => 'All';
	String products_count({required Object count}) => '${count} products';
	String get latest_arrivals => 'Latest Arrivals';
	String get price_low_high => 'Price: Low → High';
	String get price_high_low => 'Price: High → Low';
	String get no_products_found => 'No products found';
}

// Path: vendor_profile
class StringsVendorProfileEn {
	StringsVendorProfileEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get products_tab => 'Products ({count})';
	String get qa_tab => 'Q&A ({count})';
	String get reviews_tab => 'Reviews ({count})';
	String get policies_tab => 'Policies';
	String get store_not_found => 'Store not found';
	String get no_products => 'No products yet';
	String get no_questions => 'No questions yet';
	String get no_reviews => 'No reviews yet';
	String get no_policies => 'No policies published yet';
	String get vendor_answer => 'VENDOR ANSWER';
	String get awaiting_response => 'Awaiting vendor response...';
	String get verified_badge => '✓ Verified';
	String get shipping_policy => 'Shipping Policy';
	String get return_refund_policy => 'Return & Refund Policy';
}

// Path: drawer
class StringsDrawerEn {
	StringsDrawerEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get browse => 'BROWSE';
	String get community_section => 'COMMUNITY';
	String get stores_section => 'STORES';
	String get account_section => 'ACCOUNT';
	String get info_section => 'INFO';
	String get legal_section => 'LEGAL';
	String get sign_in_prompt => 'Sign in to access your communities and stores';
	String get popular => 'Popular';
	String get news => 'News';
	String get saved => 'Saved';
	String get create_community => 'Create Community';
	String get no_communities_joined => 'You haven\'t joined any communities yet';
	String get browse_all_stores => 'Browse All Stores';
	String get my_store => 'My Store';
	String get not_vendor_yet => 'You\'re not a vendor yet — Become one →';
	String get about_waslaq => 'About WaslaQ';
	String get contact_us => 'Contact Us';
	String get feedback => 'Feedback';
}

// Path: info
class StringsInfoEn {
	StringsInfoEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get about_title => 'About WaslaQ';
	String get contact_title => 'Contact Us';
	String get feedback_title => 'Feedback';
	String get our_mission => 'Our Mission';
	String get what_we_offer => 'What We Offer';
	String get trust_safety => 'Trust & Safety';
	String get get_in_touch => 'Get in Touch';
	String get send_message => 'Send Message';
	String get help_us_improve => 'Help us improve';
	String get submit_feedback => 'Submit Feedback';
	String get message_sent => 'Message sent! We\'ll get back to you soon.';
	String get thank_you_feedback => 'Thank you for your feedback!';
	String get write_feedback_required => 'Please write your feedback';
	String get failed_submit_feedback => 'Failed to submit. Please try again.';
	String get feedback_desc => 'Your feedback helps us build a better platform.';
	String get category => 'Category';
	String get rating => 'Rating';
	String get your_feedback => 'Your Feedback';
	String get feedback_hint => 'Tell us what you think...';
	String get type_general => 'General';
	String get type_bug => 'Bug';
	String get type_feature => 'Feature';
	String get type_design => 'Design';
	String get about_subtitle => 'Your Palestinian Marketplace';
	String get our_mission_body => 'WaslaQ is a hybrid social marketplace built for Palestine. We combine the best of community-driven content with a trusted e-commerce platform, connecting local vendors with buyers through a secure escrow system.';
	String get what_we_offer_body => '• Verified local vendors with escrow protection\n• Community-driven content and discussions\n• Digital and physical products\n• Secure payments via Stripe\n• Gaza and West Bank delivery zones';
	String get trust_safety_body => 'Every transaction is protected by our escrow system. Funds are held safely until the buyer confirms receipt. Vendors are verified and rated by the community.';
	String version({required Object version}) => 'Version ${version}';
	String get fill_all_fields => 'Please fill in all fields';
	String get failed_send_message => 'Failed to send. Please try again.';
	String get contact_desc => 'Have a question or need help? Send us a message.';
	String get name_label => 'Name';
	String get message_label => 'Message';
}

// Path: orders
class StringsOrdersEn {
	StringsOrdersEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'My Orders';
	String get failed_load => 'Failed to load orders';
	String get retry => 'Retry';
	String get no_orders => 'No orders yet';
	String get today => 'Today';
	String get yesterday => 'Yesterday';
	String days_ago({required Object n}) => '${n} days ago';
	String weeks_ago({required Object n}) => '${n}w ago';
	String months_ago({required Object n}) => '${n}mo ago';
}

// Path: notifications
class StringsNotificationsEn {
	StringsNotificationsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Notifications';
	String get failed_load => 'Failed to load notifications';
	String get retry => 'Retry';
	String get no_notifications => 'No notifications yet';
}

// Path: saved_items
class StringsSavedItemsEn {
	StringsSavedItemsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Saved Items';
	String get failed_load => 'Failed to load saved items';
	String get retry => 'Retry';
	String get products_tab => 'Products';
	String get posts_tab => 'Posts';
	String get no_products => 'No saved products yet';
	String get no_products_sub => 'Tap ♡ on any product to save it here.';
	String get no_posts => 'No saved posts yet';
	String get no_posts_sub => 'Save posts from the community feed.';
	String get could_not_load => 'Could not load products';
}

// Path: legal
class StringsLegalEn {
	StringsLegalEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get privacy_policy_title => 'Privacy Policy';
	String get terms_title => 'Terms of Service';
}

// Path: create_post
class StringsCreatePostEn {
	StringsCreatePostEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get sheet_title => 'What do you want to post?';
	String get general_post => 'General Post';
	String get community_post => 'Post in a Community';
	String community_post_in({required Object slug}) => 'Post in r/${slug}';
	String get share_product => 'Share a Product';
	String share_product_named({required Object title}) => 'Share: ${title}';
	String get ask_product => 'Ask About a Product';
	String get select_community_title => 'Select Community';
	String get search_communities => 'Search communities...';
	String get show_more_communities => 'Show More Communities';
	String get no_communities_found => 'No communities found';
	String get private_community_locked => 'Private - Join to select';
	String get create_community => 'Create a Community';
	String get ai_assistant => 'AI Assistant';
}

// Path: errors
class StringsErrorsEn {
	StringsErrorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get network => 'No internet connection — check your network and try again';
	String get timeout => 'The connection is taking too long — please try again';
	String get server => 'Something went wrong on our side — please try again shortly';
	String get unauthorized => 'Your session has expired — please sign in again';
	String get not_found => 'We couldn\'t find what you\'re looking for';
	String get rate_limited => 'Too many attempts — wait a moment and try again';
	String get validation => 'Some information looks incorrect — please review and try again';
	String get unknown => 'Something went wrong — please try again';
	String get offline_banner => 'No internet connection';
	String get back_online => 'Back online';
	String get crash_title => 'Oops, something broke';
	String get crash_message => 'An unexpected error occurred. Please go back and try again.';
}

// Path: connections
class StringsConnectionsEn {
	StringsConnectionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Connections';
	String get followers => 'Followers';
	String get following => 'Following';
	String get no_followers => 'No followers yet';
	String get no_following => 'Not following anyone yet';
	String get remove_follower => 'Remove follower';
	String get remove => 'Remove';
	String remove_follower_confirm({required Object name}) => 'Remove ${name} from your followers? They won\'t be told.';
	String get removed => 'Follower removed';
	String get block => 'Block';
	String block_confirm({required Object name}) => 'Block ${name}? They won\'t be able to follow or message you.';
	String get blocked => 'User blocked';
}

// Path: vendor_import
class StringsVendorImportEn {
	StringsVendorImportEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Import / Export';
	String get step1_title => 'Export Your Products';
	String get step1_desc => 'Download your existing products as an Excel file. Edit it, add new rows, then re-import. New vendors get a sample row.';
	String get step1_btn => 'Export Products (.xlsx)';
	String get step2_title => 'Import Products';
	String get step2_desc => 'Upload your completed .xlsx or .csv file. Maximum 100 products per import.';
	String get tap_to_select => 'Tap to select file';
	String get file_too_large => 'File exceeds 5MB limit.';
	String get import_completed => 'Import completed!';
	String import_failed({required Object error}) => 'Import failed: ${error}';
	String export_failed({required Object error}) => 'Export failed: ${error}';
	String get export_share_text => 'WaslaQ Products Export';
	String get start_import => 'Start Import';
	String get results_title => 'Import Results';
	String products_created({required Object count}) => '${count} Products Created';
	String rows_failed({required Object count}) => '${count} Rows Failed';
	String get import_another => 'Import Another';
	String get done => 'Done';
}

// Path: <root>
class StringsAr extends Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	StringsAr.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.ar,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ar>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	@override late final StringsAr _root = this; // ignore: unused_field

	// Translations
	@override late final StringsNavAr nav = StringsNavAr._(_root);
	@override late final StringsExploreAr explore = StringsExploreAr._(_root);
	@override late final StringsAuthAr auth = StringsAuthAr._(_root);
	@override late final StringsAccountAr account = StringsAccountAr._(_root);
	@override late final StringsProductAr product = StringsProductAr._(_root);
	@override late final StringsVendorAr vendor = StringsVendorAr._(_root);
	@override late final StringsCheckoutAr checkout = StringsCheckoutAr._(_root);
	@override late final StringsCategoryAr category = StringsCategoryAr._(_root);
	@override late final StringsCommunityAr community = StringsCommunityAr._(_root);
	@override late final StringsMessagesAr messages = StringsMessagesAr._(_root);
	@override late final StringsCommonAr common = StringsCommonAr._(_root);
	@override late final StringsHomeAr home = StringsHomeAr._(_root);
	@override late final StringsFooterAr footer = StringsFooterAr._(_root);
	@override late final StringsCommunitySettingsAr community_settings = StringsCommunitySettingsAr._(_root);
	@override late final StringsFeedbackAr feedback = StringsFeedbackAr._(_root);
	@override late final StringsContactAr contact = StringsContactAr._(_root);
	@override late final StringsAboutAr about = StringsAboutAr._(_root);
	@override late final StringsDisutesAr disutes = StringsDisutesAr._(_root);
	@override late final StringsUserProfileAr user_profile = StringsUserProfileAr._(_root);
	@override late final StringsAccountDropdownAr account_dropdown = StringsAccountDropdownAr._(_root);
	@override late final StringsVendorDashboardAr vendor_dashboard = StringsVendorDashboardAr._(_root);
	@override late final StringsNotificationsSettingsAr notifications_settings = StringsNotificationsSettingsAr._(_root);
	@override late final StringsSavedAr saved = StringsSavedAr._(_root);
	@override late final StringsSearchAr search = StringsSearchAr._(_root);
	@override late final StringsCartAr cart = StringsCartAr._(_root);
	@override late final StringsSettingsAr settings = StringsSettingsAr._(_root);
	@override late final StringsBecomeVendorAr become_vendor = StringsBecomeVendorAr._(_root);
	@override late final StringsPrivacyAr privacy = StringsPrivacyAr._(_root);
	@override late final StringsTermsAr terms = StringsTermsAr._(_root);
	@override late final StringsRefundAr refund = StringsRefundAr._(_root);
	@override late final StringsVendorFinancesAr vendor_finances = StringsVendorFinancesAr._(_root);
	@override late final StringsVendorSettingsAr vendor_settings = StringsVendorSettingsAr._(_root);
	@override late final StringsVendorPoliciesAr vendor_policies = StringsVendorPoliciesAr._(_root);
	@override late final StringsDigitalVaultAr digital_vault = StringsDigitalVaultAr._(_root);
	@override late final StringsVendorProductsAr vendor_products = StringsVendorProductsAr._(_root);
	@override late final StringsVendorOrdersAr vendor_orders = StringsVendorOrdersAr._(_root);
	@override late final StringsDisputeAr dispute = StringsDisputeAr._(_root);
	@override late final StringsStoresAr stores = StringsStoresAr._(_root);
	@override late final StringsSocialAr social = StringsSocialAr._(_root);
	@override late final StringsStoreAr store = StringsStoreAr._(_root);
	@override late final StringsVendorProfileAr vendor_profile = StringsVendorProfileAr._(_root);
	@override late final StringsDrawerAr drawer = StringsDrawerAr._(_root);
	@override late final StringsInfoAr info = StringsInfoAr._(_root);
	@override late final StringsOrdersAr orders = StringsOrdersAr._(_root);
	@override late final StringsNotificationsAr notifications = StringsNotificationsAr._(_root);
	@override late final StringsSavedItemsAr saved_items = StringsSavedItemsAr._(_root);
	@override late final StringsLegalAr legal = StringsLegalAr._(_root);
	@override late final StringsCreatePostAr create_post = StringsCreatePostAr._(_root);
	@override late final StringsErrorsAr errors = StringsErrorsAr._(_root);
	@override late final StringsConnectionsAr connections = StringsConnectionsAr._(_root);
	@override late final StringsVendorImportAr vendor_import = StringsVendorImportAr._(_root);
}

// Path: nav
class StringsNavAr extends StringsNavEn {
	StringsNavAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get home => 'الرئيسية';
	@override String get category => 'الفئة';
	@override String get community => 'المجتمع';
	@override String get messages => 'الرسائل';
	@override String get search_placeholder => 'ابحث عن المنتجات أو المتاجر أو المبدعين...';
	@override String get cart => 'عربة التسوق';
	@override String get saved => 'تم الحفظ';
	@override String get stores => 'المتاجر';
	@override String get browse_all_stores => 'تصفح جميع المتاجر';
	@override String get my_store => 'متجري';
	@override String get account => 'حسابي';
	@override String get info => 'المعلومات';
	@override String get about_waslaq => 'عن واصلك';
	@override String get contact_us => 'اتصل بنا';
	@override String get feedback => 'ملاحظات';
	@override String get create_community => 'إنشاء مجتمع';
	@override String get explore => 'اكتشف';
}

// Path: explore
class StringsExploreAr extends StringsExploreEn {
	StringsExploreAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get products => 'المنتجات';
	@override String get communities => 'المجتمعات';
	@override String get stores => 'المتاجر';
	@override String get browse_categories => 'تصفح الفئات';
	@override String get popular_searches => 'عمليات البحث الشائعة';
	@override String get all_communities => 'كل المجتمعات';
	@override String get select_community => 'اختر مجتمع';
	@override String get filter => 'تصفية';
	@override String get category => 'الفئة';
	@override String get brand => 'العلامة التجارية';
	@override String get color => 'اللون';
	@override String get clear_filters => 'مسح التصفية';
	@override String get apply => 'تطبيق';
	@override String get filter_by_community => 'حسب المجتمع';
	@override String get search_communities => 'ابحث عن مجتمعات...';
	@override String get my_communities => 'مجتمعاتي';
	@override String get no_communities_joined => 'لم تنضم إلى أي مجتمع بعد';
	@override String get explore_communities => 'استكشف المجتمعات';
	@override String get select_community_to_filter => 'اختر مجتمعاً لتصفية المنشورات';
	@override String get all_posts => 'كل المنشورات';
	@override String get private_join_required => 'انضم لهذا المجتمع الخاص لاختياره';
	@override String get public => 'عام';
}

// Path: auth
class StringsAuthAr extends StringsAuthEn {
	StringsAuthAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get sign_in => 'تسجيل الدخول';
	@override String get sign_up => 'إنشاء حساب';
	@override String get sign_out => 'تسجيل الخروج';
	@override String get email => 'البريد الإلكتروني';
	@override String get password => 'كلمة المرور';
	@override String get display_name => 'الاسم المعروض';
	@override String get username => 'اسم المستخدم';
	@override String get forgot_password => 'هل نسيت كلمة المرور؟';
	@override String get no_account => 'ليس لديك حساب؟';
	@override String get have_account => 'هل لديك حساب بالفعل؟';
	@override String get create_account => 'إنشاء حساب';
	@override String get continue_google => 'متابعة باستخدام Google';
	@override String get continue_facebook => 'متابعة عبر فيسبوك';
	@override String get become_vendor => 'انضم إلى قائمة الموردين';
	@override String get want_to_sell => 'هل تريد البيع؟';
	@override String get signing_in => 'جاري تسجيل الدخول...';
	@override String get creating_account => 'جاري إنشاء الحساب...';
	@override String get username_available => 'اسم المستخدم متاح';
	@override String get checking => 'جاري التحقق...';
	@override String get or_continue_with => 'أو تابع';
	@override String get or_sign_up_email => 'أو قم بالتسجيل باستخدام بريدك الإلكتروني';
	@override String get login_title => 'تسجيل الدخول';
	@override String get required_field => 'مطلوب';
}

// Path: account
class StringsAccountAr extends StringsAccountEn {
	StringsAccountAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get my_orders => 'طلباتي';
	@override String get orders => 'الطلبات';
	@override String get track_purchases => 'تتبع مشترياتك وسجل طلباتك.';
	@override String get addresses => 'العناوين';
	@override String get downloads => 'التنزيلات';
	@override String get notifications => 'الإشعارات';
	@override String get profile => 'الملف الشخصي';
	@override String get saved_items => 'العناصر المحفوظة';
	@override String get disputes => 'النزاعات';
	@override String get vendor_dashboard => 'لوحة تحكم الموردين';
	@override String get settings => 'الإعدادات';
	@override String get no_orders => 'لا توجد طلبات حتى الآن';
	@override String get no_orders_desc => 'لم تقم بتقديم أي طلبات حتى الآن. ابدأ التسوق وستظهر طلباتك هنا.';
	@override String get start_shopping => 'ابدأ التسوق';
	@override String get view_order => 'عرض الطلب';
	@override String get back_to_orders => 'العودة إلى الطلبات';
	@override String get order_placed => 'تم تقديم الطلب';
	@override String get processing => 'المعالجة';
	@override String get shipped => 'تم الشحن';
	@override String get delivered => 'تم التسليم';
	@override String get order_progress => 'تقدم الطلب';
	@override String get items => 'العناصر';
	@override String get total => 'المجموع';
	@override String get shipping_address => 'عنوان الشحن';
	@override String get problem_order => 'هل تواجه مشكلة في طلبك؟';
	@override String get dispute_window => 'يمكنك رفع نزاع في غضون 4 أيام من تاريخ التسليم.';
	@override String get open_dispute => 'فتح نزاع';
	@override String get cancel => 'إلغاء';
	@override String get submit_dispute => 'تقديم شكوى';
	@override String get what_issue => 'ما هي المشكلة؟';
	@override String get non_delivery => 'عدم التسليم';
	@override String get non_delivery_desc => 'لم تصل السلعة أبدًا';
	@override String get damaged_wrong => 'تالف / خاطئ';
	@override String get damaged_wrong_desc => 'لا يتطابق مع الوصف';
	@override String get describe_issue => 'صف المشكلة';
	@override String get my_communities => 'مجتمعاتي';
	@override String get my_posts => 'منشوراتي وتعليقاتي';
	@override String get vendor_center => 'مركز تحكم البائع';
	@override String get account_privacy => 'الحساب والخصوصية';
	@override String get sign_out => 'تسجيل الخروج';
	@override String get edit_profile => 'تعديل الملف الشخصي';
	@override String get followers => 'المتابعون';
	@override String get following => 'يتابع';
	@override String get profile_settings => 'إعدادات الملف الشخصي';
	@override String get privacy_settings => 'إعدادات الخصوصية';
	@override String get privacy => 'الخصوصية';
	@override String get private_account => 'حساب خاص';
	@override String get show_activity => 'إظهار حالة النشاط';
	@override String get follow_requests => 'طلبات المتابعة';
	@override String get account_settings => 'إعدادات الحساب';
	@override String get connected_accounts => 'الحسابات المرتبطة';
	@override String get delete_account => 'حذف الحساب';
	@override String get change_password => 'تغيير كلمة المرور';
	@override String get order_status_title => 'حالة الطلب';
	@override String get order_label => 'الطلب';
	@override String get payment_label => 'الدفع';
	@override String get fulfillment_label => 'التنفيذ';
	@override String get placed => 'تاريخ الطلب';
	@override String items_count({required Object count}) => 'المنتجات (${count})';
	@override String qty_label({required Object count}) => 'الكمية: ${count}';
	@override String order_number({required Object id}) => 'طلب رقم #${id}';
	@override String get title => 'الحساب';
	@override String get my_orders_label => 'طلباتي';
	@override String get saved_items_label => 'العناصر المحفوظة';
	@override String get messages_label => 'الرسائل';
	@override String get notifications_label => 'الإشعارات';
	@override String get settings_label => 'الإعدادات';
	@override String get privacy_policy_label => 'سياسة الخصوصية';
	@override String get terms_label => 'شروط الخدمة';
	@override String get sign_out_label => 'تسجيل الخروج';
	@override String get vendor_dashboard_label => 'لوحة تحكم البائع';
	@override String get become_vendor_label => 'كن بائعاً';
	@override String get sign_in_welcome => 'WaslaQ';
	@override String get sign_in_desc => 'سجّل الدخول للاطلاع على حسابك\nوطلباتك ورسائلك.';
	@override String get sign_in_btn => 'تسجيل الدخول';
	@override String get create_account_btn => 'إنشاء حساب';
	@override String get failed_load_orders => 'فشل تحميل الطلبات';
	@override String get section_shopping => 'التسوق';
	@override String get section_community => 'المجتمع';
	@override String get section_communities => 'مجتمعاتي';
	@override String get section_vendor => 'البائع';
	@override String get section_settings => 'الإعدادات';
	@override String get section_legal => 'قانوني';
	@override String get following_stores_label => 'المتاجر المتابعة';
}

// Path: product
class StringsProductAr extends StringsProductEn {
	StringsProductAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get add_to_cart => 'أضف إلى سلة التسوق';
	@override String sold({required Object count}) => 'تم بيع ${count}';
	@override String get no_seller => 'بائع محلي';
	@override String get buy_now => 'اشترِ الآن';
	@override String get save => 'حفظ';
	@override String get saved => 'تم الحفظ';
	@override String get reviews => 'التعليقات';
	@override String get questions => 'أسئلة وأجوبة';
	@override String get write_review => 'اكتب تقييماً';
	@override String get ask_question => 'اطرح سؤالاً';
	@override String get no_reviews => 'لا توجد تعليقات حتى الآن. كن أول من يكتب تعليقًا على هذا المنتج.';
	@override String get no_questions => 'لا توجد أسئلة حتى الآن. كن أول من يسأل!';
	@override String get verified => 'تم التحقق منه';
	@override String get verified_purchase => 'شراء تم التحقق منه';
	@override String get vendor_answer => 'إجابة البائع';
	@override String get waiting_answer => 'في انتظار رد البائع...';
	@override String get submit_review => 'إرسال تقييم';
	@override String get submit_question => 'إرسال سؤال';
	@override String get your_rating => 'تقييمك';
	@override String get your_review => 'تقييمك';
	@override String get ask_anonymously => 'اطرح سؤالك دون الكشف عن هويتك';
	@override String get customer_reviews => 'آراء العملاء';
	@override String get qty => 'الكمية';
	@override String get in_stock => 'متوفر';
	@override String get out_of_stock => 'غير متوفر';
	@override String get related_products => 'المنتجات ذات الصلة';
	@override String get from_store => 'من المتجر';
	@override String get visit_store => 'زيارة المتجر';
	@override String get quantity => 'الكمية';
	@override String get reviews_label => 'التعليقات';
	@override String get qa_label => 'أسئلة وأجوبة العملاء';
	@override String get official_store => 'المتجر الرسمي';
	@override String get product_information => 'معلومات عن المنتج';
	@override String get verified_reviews => 'تقييمات تم التحقق منها';
	@override String get customer_qa => 'أسئلة وأجوبة العملاء';
	@override String get delivery_local => 'يتولى البائع إدارة التوصيل المحلي بشكل مباشر.';
	@override String get escrow_protected => 'محمية بواسطة خدمة Waslaq Escrow حتى يتم تأكيد التسليم.';
	@override String get material => 'المواد';
	@override String get origin => 'الأصل';
	@override String get no_description => 'لم يتم توفير وصف.';
	@override String get price_on_request => 'السعر عند الطلب';
	@override String get review_submitted => 'تم إرسال التقييم بنجاح!';
	@override String get question_submitted => 'تم إرسال السؤال! سيقوم البائع بالرد قريباً.';
	@override String get write_your_review => 'اكتب تقييمك هنا...';
	@override String get type_your_question => 'اكتب سؤالك حول هذا المنتج...';
	@override String get you_might_also_like => 'قد يعجبك أيضاً';
	@override String get must_purchase => 'يمكنك تقييم المنتجات التي قمت بشرائها فقط';
	@override String get sign_in_to_review => 'يرجى تسجيل الدخول لترك تقييم';
	@override String get sign_in_to_ask => 'يرجى تسجيل الدخول لطرح سؤال';
	@override String get product_not_found => 'المنتج غير موجود';
	@override String get delivery_hint_trust => 'توصيل محلي — يشحن من فلسطين';
	@override String get buyer_protection_trust => 'حماية المشتري — الضمان حتى الاستلام';
	@override String get options => 'الخيارات';
	@override String get default_variant => 'الافتراضي';
	@override String get product_info => 'معلومات المنتج';
	@override String customer_reviews_count({required Object count}) => 'آراء العملاء (${count})';
	@override String get verified_buyer => 'مشتري مؤكد';
	@override String questions_answers_count({required Object count}) => 'الأسئلة والأجوبة (${count})';
	@override String get please_select_rating => 'يرجى تحديد التقييم';
	@override String get failed_submit_review => 'فشل تقديم التقييم';
	@override String get please_enter_question => 'يرجى كتابة سؤالك';
	@override String get failed_submit_question => 'فشل تقديم السؤال';
	@override String get added_to_cart_success => 'تمت الإضافة إلى العربة ✓';
	@override String get failed_add_to_cart => 'فشل الإضافة إلى العربة';
	@override String share_product({required Object title, required Object url}) => 'شاهد هذا المنتج على واصلك: ${title}\n${url}';
	@override String get community_discussions => 'مناقشات المجتمع';
}

// Path: vendor
class StringsVendorAr extends StringsVendorEn {
	StringsVendorAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get store => 'متجر';
	@override String get products => 'المنتجات';
	@override String get follow => 'تابع';
	@override String get following => 'يتابع';
	@override String get followers => 'المتابعون';
	@override String get reviews => 'التعليقات';
	@override String get policy => 'السياسات';
	@override String get verified => 'تم التحقق منه';
	@override String get share => 'مشاركة';
	@override String get no_products => 'لا توجد منتجات متوفرة حتى الآن.';
	@override String get your_store_products => 'منتجات متجرك';
	@override String get create_product => 'إنشاء منتج جديد';
	@override String get product_title => 'اسم المنتج';
	@override String get description => 'الوصف';
	@override String get product_type => 'نوع المنتج';
	@override String get physical_item => 'المنتج المادي';
	@override String get virtual_digital => 'افتراضي / رقمي';
	@override String get requires_shipping => 'يتطلب الشحن';
	@override String get software_keys => 'البرامج، ملفات PDF، الوسائط، مفاتيح التفعيل';
	@override String get category => 'الفئة';
	@override String get select_parent_category => 'اختر الفئة الرئيسية';
	@override String get select_subcategory => 'اختر فئة فرعية (اختياري)';
	@override String get product_images => 'صور المنتج';
	@override String get add_images => 'إضافة صور';
	@override String get launch_product => 'إطلاق المنتج';
	@override String get discard => 'تجاهل';
	@override String get cancel_creation => 'إلغاء الإنشاء';
	@override String get bulk_edit_stock => 'التعديل الجماعي للمخزون';
	@override String get save_changes => 'حفظ التغييرات';
	@override String get edit_product => 'تحرير المنتج';
	@override String get price_ils => 'السعر (شواقل إسرائيلية)';
	@override String get delete_product_confirm => 'هل أنت متأكد من رغبتك في حذف هذا المنتج؟ لا يمكن التراجع عن هذا الإجراء.';
	@override String get official_store => 'متجر رسمي';
	@override String get visit_store => 'زيارة المتجر';
	@override String get qa_tab => 'أسئلة وأجوبة';
	@override String get all_products => 'جميع المنتجات';
	@override String get no_reviews => 'لا توجد تقييمات بعد';
	@override String get failed_load_store => 'فشل تحميل المتجر';
	@override String get store_not_found => 'المتجر غير موجود';
	@override String reviews_count({required Object count}) => '${count} تقييمات';
	@override String tab_products({required Object count}) => 'المنتجات (${count})';
	@override String tab_qa({required Object count}) => 'الأسئلة والأجوبة (${count})';
	@override String tab_reviews({required Object count}) => 'التقييمات (${count})';
	@override String get tab_policies => 'السياسات';
	@override String get no_products_yet => 'لا توجد منتجات بعد';
	@override String get no_questions_yet => 'لا توجد أسئلة بعد';
	@override String get awaiting_response => 'في انتظار رد البائع...';
	@override String get no_reviews_yet => 'لا توجد تقييمات بعد';
	@override String get no_stores_yet => 'لا توجد متاجر بعد';
	@override String rating_out_of_five({required Object rating}) => '${rating}/5';
	@override String get no_policies_yet => 'لم يتم نشر أي سياسات بعد';
	@override String get shipping_policy => 'سياسة الشحن';
	@override String get refund_policy => 'سياسة الإرجاع والاسترداد';
	@override String get terms_of_use => 'شروط الاستخدام';
	@override String get privacy_policy => 'سياسة الخصوصية';
}

// Path: checkout
class StringsCheckoutAr extends StringsCheckoutEn {
	StringsCheckoutAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get checkout => 'الخروج';
	@override String get shipping => 'الشحن';
	@override String get payment => 'الدفع';
	@override String get review => 'مراجعة';
	@override String get place_order => 'تقديم الطلب';
	@override String get order_summary => 'ملخص الطلب';
	@override String get subtotal => 'المجموع الفرعي';
	@override String get shipping_cost => 'الشحن';
	@override String get total => 'المجموع';
	@override String get first_name => 'الاسم الأول';
	@override String get last_name => 'اللقب';
	@override String get address => 'العنوان';
	@override String get city => 'المدينة';
	@override String get country => 'البلد';
	@override String get phone => 'الهاتف';
	@override String get email => 'البريد الإلكتروني';
	@override String get continue_action => 'تابع';
	@override String get back => 'العودة';
	@override String get card_number => 'رقم البطاقة';
	@override String get pay_now => 'ادفع الآن';
	@override String get processing => 'جاري المعالجة...';
	@override String get shipping_address => 'عنوان الشحن';
	@override String get billing_address => 'عنوان الفواتير';
	@override String get delivery => 'التسليم';
	@override String get review_order => 'مراجعة الطلب وتقديمه';
	@override String get shipping_to => 'الشحن إلى';
	@override String get payment_method => 'طريقة الدفع';
	@override String get method => 'الطريقة';
	@override String get details => 'التفاصيل';
	@override String get recipient => 'المستلم';
	@override String get contact => 'الاتصال';
	@override String get continue_delivery => 'المضي قدماً إلى التسليم';
	@override String get continue_payment => 'المضي قدماً إلى الدفع';
	@override String get continue_review => 'تابع المراجعة';
	@override String get select_shipping => 'اختر طريقة الشحن التي تفضلها';
	@override String get secure_processing => 'معالجة آمنة للمدفوعات';
	@override String get terms_notice => 'بالنقر على زر "تقديم الطلب"، فإنك تؤكد أنك قد قرأت وفهمت ووافقت على "شروط الاستخدام" و"شروط البيع" و"سياسة الإرجاع" الخاصة بنا، وتقر بأنك قد قرأت "سياسة الخصوصية" الخاصة بـ WaslaQ.';
	@override String get billing_delivery_address => 'عنوان الفواتير / التسليم';
	@override String get discount => 'خصم';
	@override String get taxes => 'الضرائب';
	@override String get postal_code => 'الرمز البريدي';
	@override String get billing_same_as_shipping => 'عنوان الفواتير هو نفسه عنوان الشحن';
	@override String get saved_address_prompt => 'هل ترغب في استخدام عنوان محفوظ؟';
	@override String get mixed_cart_warning => 'المنتجات المادية متاحة للتسليم داخل فلسطين فقط. أما المنتجات الرقمية فيمكن شحنها إلى جميع أنحاء العالم.';
	@override String get your_phone_number => 'رقم هاتفك';
	@override String get payment_failed => 'فشلت عملية الدفع. يرجى المحاولة مرة أخرى.';
	@override String get try_again => 'حاول مرة أخرى';
	@override String get address_line_1 => 'العنوان - السطر 1';
	@override String get province_optional => 'المحافظة / الولاية (اختياري)';
	@override String get continue_shipping => 'متابعة الشحن';
	@override String get cart_empty => 'عربة التسوق فارغة';
	@override String qty({required Object count}) => 'الكمية: ${count}';
	@override String get continue_shopping => 'متابعة التسوق';
	@override String get customer_info_step => 'المعلومات';
	@override String get delivery_step => 'التوصيل';
	@override String get payment_step => 'الدفع';
	@override String get customer_info_title => 'معلومات العميل';
	@override String get no_shipping_options => 'لا توجد خيارات شحن متاحة';
	@override String get agree_prefix => 'أوافق على ';
	@override String get terms_link => 'شروط الاستخدام';
	@override String get and_text => ' و';
	@override String get privacy_link => 'سياسة الخصوصية';
}

// Path: category
class StringsCategoryAr extends StringsCategoryEn {
	StringsCategoryAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get browse_categories => 'تصفح الفئات';
	@override String get subcategories => 'الفئات الفرعية';
	@override String get recommended => 'موصى به';
	@override String get for_you => 'من أجلك';
	@override String get products_coming_soon => 'المنتجات قريبًا';
	@override String get no_subcategories => 'لا توجد فئات فرعية حتى الآن.';
	@override String get select_category => 'اختر فئة';
}

// Path: community
class StringsCommunityAr extends StringsCommunityEn {
	StringsCommunityAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get community => 'المجتمع';
	@override String get join => 'انضم';
	@override String get joined => 'انضم';
	@override String get leave => 'مغادرة';
	@override String get leave_title => 'مغادرة المجتمع';
	@override String get leave_confirm => 'هل أنت متأكد من مغادرة هذا المجتمع؟';
	@override String get create_post => 'إنشاء منشور';
	@override String get post => 'منشور';
	@override String get comment => 'تعليق';
	@override String get comments => 'التعليقات';
	@override String get reply => 'الرد';
	@override String get share => 'مشاركة';
	@override String get save => 'حفظ';
	@override String get report => 'تقرير';
	@override String get upvote => 'صوّت بالموافقة';
	@override String get members => 'الأعضاء';
	@override String get online => 'عبر الإنترنت';
	@override String get rules => 'القواعد';
	@override String get about => 'نبذة عن';
	@override String get new_post => 'منشور جديد';
	@override String get title => 'العنوان';
	@override String get content => 'المحتوى';
	@override String get submit => 'إرسال';
	@override String get cancel => 'إلغاء';
	@override String get ask_anonymously => 'اطرح سؤالك دون الكشف عن هويتك';
	@override String get no_posts => 'لا توجد مشاركات حتى الآن.';
	@override String get be_first => 'كن أول من يعلق!';
	@override String get hot => 'ساخن';
	@override String get new_label => 'جديد';
	@override String get top => 'أعلى';
	@override String get private_community => 'مجتمع خاص';
	@override String get created => 'تاريخ الإنشاء';
	@override String get request_to_join => 'اطلب الانضمام لرؤية المنشورات والمحتوى';
	@override String get welcome => 'أهلاً بك في المجتمع!';
	@override String get trending_communities => 'المجتمعات الشائعة';
	@override String get see_all => 'عرض الكل';
	@override String get whats_on_your_mind => 'ما الذي يدور في ذهنك؟';
	@override String get no_posts_subtitle => 'كن أول من يشارك شيئاً!';
	@override String get select_community => 'اختر مجتمعاً';
	@override String get add_images => 'إضافة صور';
	@override String get add_more_images => 'إضافة المزيد ({count}/5)';
	@override String members_count({required Object count}) => '${count} أعضاء';
	@override String get title_required => 'العنوان مطلوب';
	@override String get select_community_required => 'يرجى اختيار مجتمع';
	@override String get post_created => 'تم إنشاء المنشور!';
	@override String get failed_create_post => 'فشل إنشاء المنشور. يرجى المحاولة مرة أخرى.';
	@override String get post_action => 'نشر';
	@override String get write_post_hint => 'اكتب منشورك... (اختياري)';
	@override String add_more_images_param({required Object count}) => 'إضافة المزيد (${count}/5)';
	@override String get failed_load_post => 'فشل تحميل المنشور';
	@override String get error_loading_comments => 'خطأ في تحميل التعليقات';
	@override String get no_comments_yet => 'لا توجد تعليقات حتى الآن. كن أول من يشارك أفكاره!';
	@override String get view_more_replies => 'عرض المزيد من الردود';
	@override String get add_comment => 'أضف تعليقاً...';
	@override String get login_to_comment => 'سجل الدخول للتعليق';
	@override String members_label({required Object count}) => 'الأعضاء: ${count}';
	@override String get joined_checkmark => 'تم الانضمام ✓';
	@override String error_loading_posts({required Object error}) => 'خطأ في تحميل المنشورات: ${error}';
	@override String get explore_communities => 'استكشف المجتمعات';
	@override String get no_communities_found => 'لم يتم العثور على مجتمعات';
	@override String get error_loading => 'خطأ في التحميل';
}

// Path: messages
class StringsMessagesAr extends StringsMessagesEn {
	StringsMessagesAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get messages => 'الرسائل';
	@override String get no_messages => 'لا توجد رسائل حتى الآن';
	@override String get type_message => 'اكتب رسالة...';
	@override String get send => 'إرسال';
	@override String get online => 'عبر الإنترنت';
	@override String get seen => 'تمت القراءة';
	@override String get title => 'الرسائل';
	@override String get load_more => 'تحميل المزيد';
	@override String get start_conversation => 'ابدأ محادثة';
	@override String get offline => 'غير متصل';
	@override String get last_seen => 'شوهد آخر مرة';
	@override String get deleted => 'تم حذف هذه الرسالة...';
	@override String get input_placeholder => 'اكتب رسالتك';
	@override String get yesterday_at => 'بالأمس في';
	@override String get no_contacts => 'لا توجد جهات اتصال حتى الآن.';
	@override String get follow_someone => 'تابع شخصًا ما لبدء الدردشة!';
	@override String get select_conversation => 'اختر محادثة أو ابدأ محادثة جديدة';
	@override String get online_now => 'متصل الآن';
	@override String get seen_prefix => 'شوهد بواسطة';
	@override String get unknown_user => 'مستخدم مجهول';
	@override String get sign_in_view => 'سجل الدخول لعرض الرسائل';
	@override String get connect_vendors_buyers => 'تواصل مع البائعين والمشترين';
	@override String get could_not_connect => 'تعذر الاتصال بالرسائل';
	@override String get not_connected => 'غير متصل';
	@override String get no_conversations => 'لا توجد محادثات بعد';
	@override String get tap_pencil_start => 'انقر على أيقونة القلم لبدء\nمحادثة جديدة';
	@override String could_not_open_chat({required Object error}) => 'تعذر فتح المحادثة: ${error}';
	@override String get new_message => 'رسالة جديدة';
	@override String get search_hint => 'البحث بالاسم أو اسم المستخدم...';
	@override String get no_users_found => 'لم يتم العثور على مستخدمين';
}

// Path: common
class StringsCommonAr extends StringsCommonEn {
	StringsCommonAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get unknown_user => 'غير معروف';
	@override String get loading => 'جاري التحميل...';
	@override String get error => 'حدث خطأ ما';
	@override String error_prefix({required Object error}) => 'خطأ: ${error}';
	@override String get retry => 'أعد المحاولة';
	@override String get save => 'حفظ';
	@override String get cancel => 'إلغاء';
	@override String get delete => 'حذف';
	@override String get edit => 'تحرير';
	@override String get close => 'إغلاق';
	@override String get search => 'بحث';
	@override String get filter => 'فلتر';
	@override String get sort => 'ترتيب';
	@override String get view_all => 'عرض الكل';
	@override String get show_more => 'عرض المزيد';
	@override String get show_less => 'إخفاء المزيد';
	@override String get confirm => 'تأكيد';
	@override String get back => 'العودة';
	@override String get next => 'التالي';
	@override String get submit => 'إرسال';
	@override String get success => 'النجاح';
	@override String get currency => '₪';
	@override String get free => 'مجانًا';
	@override String get required => 'مطلوب';
	@override String get optional => 'اختياري';
	@override String get save_changes => 'احفظ التغييرات';
	@override String get sort_by => 'ترتيب حسب';
	@override String get no_products => 'لا توجد منتجات';
	@override String get reset => 'إعادة تعيين';
	@override String get filters => 'الفلاتر';
	@override String get item_type => 'نوع المنتج';
	@override String get price_range => 'نطاق السعر';
	@override String get show_results => 'إظهار النتائج';
	@override String get digital => 'رقمي';
	@override String get physical => 'مادي';
	@override String get min => 'الأقل';
	@override String get max => 'الأعلى';
	@override String get latest => 'الأحدث';
	@override String get price_asc => 'السعر: من الأقل للأعلى';
	@override String get price_desc => 'السعر: من الأعلى للأقل';
	@override String get approve => 'موافقة';
	@override String get reject => 'رفض';
	@override String get legal => 'القانوني';
	@override String get cancel_label => 'إلغاء';
	@override String get retry_label => 'إعادة المحاولة';
	@override List<String> get months => [
		'يناير',
		'فبراير',
		'مارس',
		'أبريل',
		'مايو',
		'يونيو',
		'يوليو',
		'أغسطس',
		'سبتمبر',
		'أكتوبر',
		'نوفمبر',
		'ديسمبر',
	];
	@override String get categories => 'الفئات';
	@override String get failed_load_categories => 'فشل تحميل الفئات';
	@override String get no_categories => 'لا توجد فئات';
	@override String get no_subcategories => 'لا توجد فئات فرعية';
}

// Path: home
class StringsHomeAr extends StringsHomeEn {
	StringsHomeAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get hero_title => 'اكتشف. تواصل. تسوق.';
	@override String get hero_subtitle => 'السوق الاجتماعي الفلسطيني';
	@override String get shop_now => 'تسوق الآن';
	@override String get featured_products => 'المنتجات المميزة';
	@override String get trending => 'الأكثر تداولاً';
	@override String get new_arrivals => 'أحدث المنتجات';
	@override String get top_stores => 'أفضل المتاجر';
	@override String get browse_categories => 'تصفح الفئات';
	@override String get failed_load_products => 'فشل تحميل المنتجات';
	@override String get no_products_yet => 'لا توجد منتجات بعد';
	@override String get secure_escrow => 'حساب ضمان آمن';
	@override String get verified_sellers => 'بائعون موثوقون';
	@override String get local_support => 'دعم محلي';
	@override String get search_placeholder => 'بحث عن المنتجات، المتاجر...';
	@override String get drawer_sign_in_hint => 'سجل الدخول للوصول إلى مجتمعاتك ومتاجرك';
	@override String get drawer_browse => 'تصفح';
	@override String get drawer_popular => 'شائع';
	@override String get drawer_news => 'الأخبار';
	@override String get drawer_community => 'المجتمع';
	@override String get drawer_create_community => 'إنشاء مجتمع';
	@override String get drawer_no_communities => 'لم تنضم إلى أي مجتمعات بعد';
	@override String get drawer_stores => 'المتاجر';
	@override String get drawer_browse_stores => 'تصفح جميع المتاجر';
	@override String get drawer_my_store => 'متجري';
	@override String get drawer_become_vendor_hint => 'لست بائعاً بعد — كن بائعاً الآن ←';
	@override String get drawer_account => 'الحساب';
	@override String get drawer_info => 'معلومات';
	@override String get drawer_about => 'حول WaslaQ';
	@override String get drawer_contact => 'اتصل بنا';
	@override String get drawer_feedback => 'ملاحظات';
	@override String get drawer_legal => 'قانوني';
	@override String get trending_discussions => 'نقاشات رائجة';
	@override String get more_products => 'المزيد من المنتجات';
}

// Path: footer
class StringsFooterAr extends StringsFooterEn {
	StringsFooterAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get privacy_policy => 'سياسة الخصوصية';
	@override String get terms_of_use => 'شروط الاستخدام';
	@override String get refund_policy => 'سياسة الاسترداد والإرجاع';
	@override String get customer_service => 'خدمة العملاء';
	@override String get company => 'الشركة';
	@override String get feedback => 'ملاحظات';
	@override String get contact_us => 'اتصل بنا';
	@override String get about_us => 'من نحن';
	@override String get get_the_app => 'احصل على التطبيق';
	@override String get coming_soon => 'قريباً على Android و iOS';
	@override String get made_in_palestine => 'صُنع في فلسطين';
	@override String get all_rights => 'جميع الحقوق محفوظة';
}

// Path: community_settings
class StringsCommunitySettingsAr extends StringsCommunitySettingsEn {
	StringsCommunitySettingsAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'إعدادات المجتمع';
	@override String get general_tab => 'عام';
	@override String get appearance_tab => 'المظهر';
	@override String get privacy_tab => 'الخصوصية';
	@override String get rules_tab => 'القواعد';
	@override String get community_title => 'عنوان المجتمع';
	@override String get description => 'الوصف / السيرة الذاتية';
	@override String get community_icon => 'رمز المجتمع';
	@override String get community_banner => 'لافتة المجتمع';
	@override String get upload_icon => 'رمز التحميل';
	@override String get upload_image => 'تحميل صورة';
	@override String get choose_color => 'اختر اللون';
	@override String get save_appearance => 'حفظ المظهر';
	@override String get save_general => 'حفظ الإعدادات العامة';
	@override String get save_privacy => 'حفظ إعدادات الخصوصية';
	@override String get save_rules => 'حفظ القواعد';
	@override String get private_community => 'مجتمع خاص';
	@override String get private_description => 'لا يمكن إلا للأعضاء المعتمدين عرض المحتوى ونشره';
	@override String get community_rules => 'قواعد المجتمع';
	@override String get rules_placeholder => 'قواعد منفصلة مع فواصل أسطر مزدوجة...';
	@override String get danger_zone => 'منطقة الخطر';
	@override String get danger_description => 'إجراءات لا رجعة فيها قريبًا';
	@override String get manage_community => 'إدارة المجتمع';
	@override String get members => 'الأعضاء';
	@override String get remove => 'إزالة';
	@override String get joined => 'انضم';
	@override String get back_to_community => 'العودة إلى r/';
}

// Path: feedback
class StringsFeedbackAr extends StringsFeedbackEn {
	StringsFeedbackAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'إرسال ملاحظات';
	@override String get subtitle => 'ساعدنا في تحسين WaslaQ';
	@override String get full_name => 'الاسم الكامل';
	@override String get email => 'عنوان البريد الإلكتروني';
	@override String get about => 'ما هو الموضوع؟';
	@override String get message => 'رسالة';
	@override String get submit => 'إرسال ملاحظات';
	@override String get submitting => 'جاري الإرسال...';
}

// Path: contact
class StringsContactAr extends StringsContactEn {
	StringsContactAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'اتصل بنا';
	@override String get subtitle => 'سنقوم بالرد عليك في أقرب وقت ممكن';
	@override String get subject => 'الموضوع (اختياري)';
	@override String get submit => 'إرسال رسالة';
	@override String get submitting => 'جاري الإرسال...';
}

// Path: about
class StringsAboutAr extends StringsAboutEn {
	StringsAboutAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'نبذة عن WaslaQ';
	@override String get tagline => 'السوق الاجتماعي الفلسطيني';
	@override String get our_mission => 'مهمتنا';
	@override String get how_it_works => 'كيف يعمل';
	@override String get secure_escrow => 'حساب ضمان آمن';
	@override String get mission_body => '"WaslaQ" هي أول منصة تسويق اجتماعية مختلطة في فلسطين — تجمع بين قوة النقاش المجتمعي والتجارة الإلكترونية الموثوقة. نحن نربط بين المشترين والبائعين الفلسطينيين في بيئة آمنة ومحمية بنظام الضمان، حيث تكون كل معاملة آمنة ويتم الاستماع إلى كل صوت.';
	@override String get local_vendors_title => 'البائعون المحليون';
	@override String get local_vendors_desc => 'تسوق مباشرة من بائعين فلسطينيين معتمدين.';
	@override String get community_first_title => 'المجتمع أولاً';
	@override String get community_first_desc => 'ناقش، واطلع على التقييمات، وتواصل مع المشترين الآخرين.';
	@override String get escrow_desc => 'يتم الاحتفاظ بأموالك في أمان حتى تؤكد استلامها.';
	@override String get our_values => 'قيمنا';
	@override String get value_community => 'المجتمع';
	@override String get value_transparency => 'الشفافية';
	@override String get value_trust => 'الثقة';
	@override String get value_palestine => 'فلسطين أولاً';
}

// Path: disutes
class StringsDisutesAr extends StringsDisutesEn {
	StringsDisutesAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'نزاعاتي';
	@override String get cases_count => 'الحالات';
	@override String get no_disputes => 'لم يتم العثور على أي نزاعات';
	@override String get all_good => 'جميع طلباتك سارية المفعول';
}

// Path: user_profile
class StringsUserProfileAr extends StringsUserProfileEn {
	StringsUserProfileAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get followers => 'المتابعون';
	@override String get following => 'يتابع';
	@override String get visit_store => 'تفضل بزيارة متجري';
	@override String get media_tab => 'وسائل الإعلام';
	@override String get replies_tab => 'الردود';
	@override String get posts_tab => 'المشاركات';
	@override String get no_replies => 'لا توجد ردود حتى الآن';
	@override String get edit_profile => 'تحرير الملف الشخصي';
	@override String get failed_load => 'فشل تحميل الملف الشخصي';
	@override String get view_store => 'عرض المتجر';
	@override String get no_posts_yet => 'لا توجد منشورات بعد';
	@override String get coming_soon => 'قريباً';
	@override String stats({required Object followers, required Object posts}) => '${followers} من المتابعين  ·  ${posts} منشورات';
}

// Path: account_dropdown
class StringsAccountDropdownAr extends StringsAccountDropdownEn {
	StringsAccountDropdownAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get signed_in_as => 'تم تسجيل الدخول باسم';
	@override String get my_profile => 'ملفي الشخصي';
	@override String get account_dashboard => 'لوحة معلومات الحساب';
	@override String get vendor_dashboard => 'لوحة تحكم الموردين';
	@override String get language => 'اللغة';
	@override String get log_out => 'تسجيل الخروج';
	@override String get welcome => 'أهلاً بك!';
	@override String get welcome_hint => 'سجل الدخول لمزامنة عناصرك المحفوظة وتتبع طلباتك.';
	@override String get login => 'تسجيل الدخول';
	@override String get register => 'إنشاء حساب';
}

// Path: vendor_dashboard
class StringsVendorDashboardAr extends StringsVendorDashboardEn {
	StringsVendorDashboardAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'لوحة تحكم الموردين';
	@override String get products_tab => 'المنتجات';
	@override String get orders_tab => 'الطلبات';
	@override String get overview_tab => 'نظرة عامة';
	@override String get live_badge => 'بث مباشر';
	@override String hours_ago({required Object count}) => 'قبل ${count} ساعة';
	@override String days_ago({required Object count}) => 'قبل ${count} يوم';
	@override String order_number({required Object id}) => 'طلب رقم ${id}';
	@override String get performance_summary => 'ملخص الأداء خلال الأيام السبعة الماضية';
	@override String get profit_7d => 'الربح (7 أيام)';
	@override String get revenue_7d => 'الإيرادات (7 أيام)';
	@override String get after_fees => 'بعد خصم الرسوم';
	@override String get orders_count => 'الطلبات';
	@override String get pending => 'قيد الانتظار';
	@override String get available => 'متوفر';
	@override String get awaiting_release => 'في انتظار الإصدار';
	@override String get withdraw_any => 'سحب أي';
	@override String get qa_inbox_tab => 'صندوق الأسئلة والأجوبة';
	@override String get finances_tab => 'المالية';
	@override String get policies_tab => 'السياسات';
	@override String get settings_tab => 'الإعدادات';
	@override String get disputes => 'النزاعات';
	@override String get all_clear => 'كل شيء على ما يرام';
	@override String get live_listings => 'قائمة العروض الحية';
	@override String get pending_desc => 'الأموال المودعة في حساب ضمان، في انتظار انتهاء فترة الفحص قبل الإفراج عنها.';
	@override String get available_desc => 'تم تحرير الأموال من حساب الضمان وهي جاهزة للسحب إلى حسابك المصرفي.';
	@override String get qa_inbox_heading => 'صندوق الأسئلة والأجوبة';
	@override String get no_questions => 'لا توجد أسئلة حتى الآن. ستظهر هنا عندما يطرحها العملاء.';
	@override String get orders_7d => 'الطلبات (7 أيام)';
	@override String get open_disputes => 'النزاعات المفتوحة';
	@override String in_escrow({required Object amount}) => '${amount} في الضمان';
	@override String get recent_orders => 'الطلبـات الأخيرة';
	@override String get order_marked_shipped => 'تم تحديد الطلب كـ مشحون ✅';
	@override String get marking => 'جاري التحديد...';
	@override String get mark_as_shipped => 'تحديد كـ مشحون';
	@override String ship_to({required Object name}) => 'الشحن إلى: ${name}';
	@override String qty_price({required Object qty, required Object price}) => 'الكمية: ${qty} · ₪${price}';
	@override String get no_products_yet => 'لا توجد منتجات بعد.\nاضغط على + لإضافة منتجك الأول.';
	@override String get add_product => 'إضافة منتج';
	@override String get edit_product => 'تعديل المنتج';
	@override String get title_required => 'العنوان مطلوب';
	@override String get virtual_require_file => 'المنتجات الافتراضية تتطلب ملفًا أو رابطًا';
	@override String get title_label => 'العنوان *';
	@override String get price_ils_label => 'السعر (شيكل) *';
	@override String get type_label => 'النوع:';
	@override String get digital_file_url => 'رابط الملف الرقمي *';
	@override String get upload_file_instead => 'تحميل ملف بدلاً من ذلك';
	@override String file_selected({required Object filename}) => 'الملف المحدد: ${filename}';
	@override String get digital_hint => 'الصق رابطًا مباشرًا أو قم بتحميل الملف الرقمي (PDF, ZIP, MP3، إلخ)';
	@override String get select_category => 'اختر الفئة';
	@override String get sku_optional => 'رمز SKU (اختياري)';
	@override String get manage_inventory => 'إدارة المخزون';
	@override String get inventory_quantity => 'كمية المخزون';
	@override String get create_product => 'إنشاء المنتج';
	@override String get price_ils => 'السعر (شيكل)';
	@override String get delete_product => 'حذف المنتج';
	@override String delete_confirm({required Object title}) => 'حذف "${title}"؟ لا يمكن التراجع عن هذا الإجراء.';
	@override String get inventory_untracked => 'المخزون: غير متتبع';
	@override String stock_count({required Object count}) => 'المخزون: ${count}';
	@override String get add => 'إضافة';
	@override String get total_earned => 'إجمالي الأرباح';
	@override String get paid_out => 'المدفوعات';
	@override String payout_to({required Object account}) => 'التحويل إلى: ${account}';
	@override String get request_withdrawal => 'طلب سحب';
	@override String get invalid_amount => 'أدخل مبلغاً صالحاً';
	@override String amount_exceeds({required Object balance}) => 'المبلغ يتجاوز الرصيد المتاح (₪${balance})';
	@override String get payout_submitted => 'تم تقديم طلب السحب! سيقوم المسؤول بمعالجته قريباً.';
	@override String get amount_ils => 'المبلغ (شيكل)';
	@override String get withdraw => 'سحب';
	@override String get payout_hint => 'سيتم إرسال المدفوعات إلى حسابك المصرفي المسجل.';
	@override String get payout_history => 'سجل المدفوعات';
	@override String get transaction_ledger => 'دفتر المعاملات';
	@override String re_product({required Object title}) => 'بخصوص: ${title}';
	@override String get public => 'عام';
	@override String get private => 'خاص';
	@override String get your_answer => 'إجابتك';
	@override String get edit_answer => 'تعديل الإجابة';
	@override String get type_answer_placeholder => 'اكتب إجابتك...';
	@override String get store_policies => 'سياسات المتجر';
	@override String get policies_hint => 'كل حفظ يقوم بإنشاء نسخة جديدة. يتم الاحتفاظ بالنسخ السابقة للتدقيق.';
	@override String saved_version({required Object version}) => 'تم الحفظ كإصدار v${version} ✅';
	@override String get shipping_policy => 'سياسة الشحن';
	@override String get shipping_hint => 'كيف تقوم بالشحن؟ أوقات التسليم المتوقعة؟';
	@override String get refund_policy => 'سياسة الاسترداد';
	@override String get refund_hint => 'ما هي عملية الاسترداد الخاصة بك؟';
	@override String get return_policy => 'سياسة الإرجاع';
	@override String get return_hint => 'ما هي شروط الإرجاع الخاصة بك؟';
	@override String get privacy_hint => 'كيف تتعامل مع بيانات العملاء؟';
	@override String get terms_hint => 'الشروط والأحكام للمشترين.';
	@override String get save_policies => 'حفظ السياسات';
	@override String get store_settings => 'إعدادات المتجر';
	@override String get store_logo => 'شعار المتجر';
	@override String get change_logo => 'تغيير الشعار';
	@override String get store_banner => 'لافتة المتجر';
	@override String get add_store_banner => 'إضافة لافتة المتجر';
	@override String get store_name_required => 'اسم المتجر مطلوب';
	@override String get slug_label => 'الرابط البديل (URL)';
	@override String get contact_email => 'البريد الإلكتروني للتواصل';
	@override String get payout_iban => 'رقم الحساب المصرفي (IBAN) / معرف الحساب';
	@override String get settings_saved => 'تم حفظ الإعدادات ✅';
	@override String get save_settings => 'حفظ الإعدادات';
	@override String get resolved_refund => 'تم الحل – مسترد';
	@override String get resolved_release => 'تم الحل – مفرج عنه';
	@override String get respond_to_dispute => 'الرد على النزاع';
	@override String get response_empty => 'لا يمكن أن يكون الرد فارغاً';
	@override String get your_response => 'ردك';
	@override String get explain_side_placeholder => 'اشرح وجهة نظرك في النزاع...';
	@override String get submit_response => 'تقديم الرد';
	@override String resolved_date({required Object date}) => 'تم الحل في: ${date}';
	@override String opened_date({required Object date}) => 'تم الفتح في: ${date}';
	@override String get update_response => 'تعديل الرد';
	@override String get respond => 'الرد';
	@override String get no_disputes_hint => 'لا توجد نزاعات.\nجميع طلباتك تسير بسلاسة! ✅';
}

// Path: notifications_settings
class StringsNotificationsSettingsAr extends StringsNotificationsSettingsEn {
	StringsNotificationsSettingsAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'الإشعارات';
	@override String get mark_all_read => 'وضع علامة "تمت قراءتها" على كل الرسائل';
	@override String get new_followers => 'متابعون جدد';
	@override String get comments => 'التعليقات على منشوراتك';
	@override String get upvotes => 'التصويتات الإيجابية على منشوراتك';
	@override String get mentions => 'الإشارات';
	@override String get follow_requests => 'طلبات المتابعة';
}

// Path: saved
class StringsSavedAr extends StringsSavedEn {
	StringsSavedAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'العناصر المحفوظة';
	@override String get subtitle => 'اعرض المنتجات والمنشورات والتعليقات التي قمت بحفظها في مكان واحد';
	@override String get comments_tab => 'التعليقات';
	@override String get posts_tab => 'المشاركات';
	@override String get products_tab => 'المنتجات';
	@override String get no_products => 'لم يتم حفظ أي منتجات حتى الآن';
	@override String get no_products_hint => 'انقر على أيقونة القلب الموجودة على أي منتج لإضافته إلى قائمة المفضلة';
}

// Path: search
class StringsSearchAr extends StringsSearchEn {
	StringsSearchAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get no_results => 'لم يتم العثور على أي نتائج';
	@override String get no_results_hint => 'تأكد من كتابة الاسم بشكل صحيح وحاول مرة أخرى';
	@override String get go_home => 'الذهاب إلى الصفحة الرئيسية';
	@override String get see_all_results => 'عرض جميع النتائج لـ';
	@override String get placeholder => 'البحث عن المنتجات، المتاجر، المجتمعات...';
	@override String get initial_title => 'البحث عن المنتجات، المتاجر،';
	@override String get initial_subtitle => 'المجتمعات والمستخدمين';
	@override String no_results_query({required Object query}) => 'لا توجد نتائج لـ "${query}"';
	@override String get try_different => 'جرب كلمة بحث أخرى';
	@override String get products => 'المنتجات';
	@override String get vendor_stores => 'متاجر البائعين';
	@override String get communities => 'المجتمعات';
	@override String get users => 'المستخدمين';
	@override String get posts => 'المنشورات';
	@override String get type_product => 'منتج';
	@override String get type_store => 'متجر';
	@override String get type_community => 'مجتمع';
	@override String get type_user => 'مستخدم';
	@override String get type_post => 'منشور';
	@override String post_author_votes({required Object author, required Object score}) => 'بواسطة u/${author} · ${score} أصوات';
}

// Path: cart
class StringsCartAr extends StringsCartEn {
	StringsCartAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'عربة التسوق';
	@override String get empty_message => 'لا يوجد أي منتجات في سلة التسوق الخاصة بك. دعنا نغير ذلك، استخدم الرابط أدناه لبدء تصفح منتجاتنا.';
	@override String get explore_products => 'اكتشف المنتجات';
	@override String get could_not_load => 'تعذر تحميل عربة التسوق';
	@override String get empty_title => 'عربة التسوق الخاصة بك فارغة';
	@override String get start_shopping => 'ابدأ التسوق';
	@override String get subtotal => 'المجموع الفرعي';
	@override String get shipping => 'الشحن';
	@override String get discount => 'الخصم';
	@override String get total => 'الإجمالي';
	@override String get proceed_to_checkout => 'المتابعة إلى الدفع';
}

// Path: settings
class StringsSettingsAr extends StringsSettingsEn {
	StringsSettingsAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get profile_tab => 'الملف الشخصي';
	@override String get account_tab => 'الحساب';
	@override String get privacy_tab => 'الخصوصية';
	@override String get notifications_tab => 'الإشعارات';
	@override String get banner => 'لافتة';
	@override String get avatar => 'أفاتار';
	@override String get bio => 'السيرة الذاتية';
	@override String get location => 'المدينة / البلد';
	@override String get website => 'الموقع الإلكتروني';
	@override String get gender => 'النوع الاجتماعي';
	@override String get hobbies => 'الهوايات';
	@override String get social_links => 'روابط مواقع التواصل الاجتماعي';
	@override String get avatar_gallery => 'اختر من معرض الصور الرمزية';
	@override String get upload_photo => 'تحميل صورة';
	@override String get change_color => 'تغيير اللون';
	@override String get upload_image => 'تحميل صورة';
	@override String get prefer_not_say => 'أفضل عدم الإفصاح';
	@override String get character_count => 'الشخصية:';
	@override String get current_username => 'الحالي:';
	@override String get username_once_per_year => 'لا يمكنك تغيير اسم المستخدم الخاص بك إلا مرة واحدة في السنة';
	@override String get send_reset_link => 'إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني';
	@override String get reset_link_button => 'إرسال رابط إعادة الضبط';
	@override String get connected => 'متصل';
	@override String get permanent_action => 'هذه العملية نهائية ولا يمكن التراجع عنها';
	@override String get delete_account => 'حذف حسابي';
	@override String get page_title => 'الإعدادات';
	@override String get nav_profile => 'الملف الشخصي';
	@override String get nav_account => 'الحساب';
	@override String get nav_privacy => 'الخصوصية';
	@override String get nav_notifications => 'الإشعارات';
	@override String get private_account_desc => 'لا يمكن إلا للمتابعين المعتمدين رؤية منشوراتك';
	@override String get activity_status_desc => 'اسمح للآخرين بمعرفة متى تكون متصلاً';
	@override String get notif_new_followers => 'متابعون جدد';
	@override String get notif_new_followers_desc => 'عندما يتابعك شخص ما';
	@override String get notif_comments => 'التعليقات على منشوراتك';
	@override String get notif_comments_desc => 'عندما يعلق أحدهم';
	@override String get notif_upvotes => 'التصويت الإيجابي على منشوراتك';
	@override String get notif_upvotes_desc => 'عندما يصوّت أحدهم بالموافقة';
	@override String get notif_mentions => 'الإشارات';
	@override String get notif_mentions_desc => 'عندما يذكرك أحدهم';
	@override String get notif_follow_requests => 'طلبات المتابعة';
	@override String get notif_follow_requests_desc => 'عندما يطلب شخص ما متابعتك';
	@override String get notif_note => 'ملاحظة: سيتم تفعيل خدمة إرسال الإشعارات بالكامل بمجرد توصيل نظام الإشعارات.';
	@override String get city_country => 'المدينة / البلد';
	@override String get city_placeholder => 'على سبيل المثال: رام الله، فلسطين';
	@override String get hobbies_hint => 'اضغط على مفتاح Enter لإضافة';
	@override String get hobbies_placeholder => 'على سبيل المثال: التصوير الفوتوغرافي، والألعاب';
	@override String get save_profile => 'حفظ الملف الشخصي';
	@override String get title => 'الإعدادات';
	@override String get profile_section => 'الملف الشخصي';
	@override String get notifications_section => 'الإشعارات';
	@override String get about_section => 'حول';
	@override String get edit_display_name => 'تعديل اسم العرض';
	@override String get not_set => 'غير محدد';
	@override String get edit_bio => 'تعديل النبذة';
	@override String get bio_subtitle => 'أخبر الآخرين عن نفسك';
	@override String get username_label => 'اسم المستخدم';
	@override String get username_subtitle => 'لا يمكن تغييره بعد التسجيل';
	@override String get push_notifications => 'إشعارات الدفع';
	@override String get push_notifications_subtitle => 'تفعيل جميع إشعارات الدفع';
	@override String get order_updates => 'تحديثات الطلبات';
	@override String get order_updates_subtitle => 'تنبيهات الشحن والتسليم والمدفوعات';
	@override String get social_activity => 'النشاط الاجتماعي';
	@override String get social_activity_subtitle => 'الإعجابات والتعليقات والمتابعات والردود';
	@override String get promotions => 'العروض الترويجية';
	@override String get promotions_subtitle => 'صفقات وعروض من البائعين';
	@override String get app_version => 'إصدار التطبيق';
	@override String get terms_label => 'شروط الخدمة';
	@override String get privacy_label => 'سياسة الخصوصية';
	@override String get contact_support => 'التواصل مع الدعم';
	@override String get display_name_dialog => 'اسم العرض';
	@override String get bio_dialog => 'النبذة الشخصية';
	@override String get enter_display_name_hint => 'أدخل اسم العرض';
	@override String get bio_hint => 'اكتب نبذة قصيرة...';
	@override String get cancel => 'إلغاء';
	@override String get save => 'حفظ';
	@override String get saved_ok => 'تم الحفظ بنجاح';
	@override String save_failed({required Object error}) => 'فشل الحفظ: ${error}';
	@override String get hub_profile => 'الملف الشخصي';
	@override String get hub_profile_sub => 'الصورة الشخصية، نبذة، روابط التواصل';
	@override String get hub_account => 'الحساب والأمان';
	@override String get hub_account_sub => 'البريد الإلكتروني، كلمة المرور، القفل البيومتري';
	@override String get hub_address => 'دفتر العناوين';
	@override String get hub_address_sub => 'عناوين التوصيل في فلسطين';
	@override String get hub_refund => 'تفاصيل الاسترداد';
	@override String get hub_refund_sub => 'البيانات البنكية لاسترداد النزاعات';
	@override String get hub_privacy => 'الخصوصية والسلامة';
	@override String get hub_privacy_sub => 'الظهور، المحظورون، طلبات المتابعة';
	@override String get hub_notifications => 'الإشعارات';
	@override String get hub_notifications_sub => 'الدفع، الطلبات، التنبيهات الاجتماعية';
	@override String get hub_content => 'المحتوى والخلاصة';
	@override String get hub_content_sub => 'فلتر اللغة، الكلمات المكتومة';
	@override String get hub_appearance => 'المظهر واللغة';
	@override String get hub_appearance_sub => 'السمة، اللغة، الخط، إمكانية الوصول';
	@override String get hub_storage => 'التخزين والأداء';
	@override String get hub_storage_sub => 'الذاكرة المؤقتة، استخدام البيانات';
	@override String get hub_vendor => 'إعدادات البائع';
	@override String get hub_vendor_sub => 'وضع الإجازة، مناطق التوصيل';
	@override String get hub_app => 'التطبيق';
	@override String get hub_app_sub => 'مشاركة، تقييم، الصلاحيات، الإصدار';
	@override String get hub_support => 'الدعم والضمان';
	@override String get hub_support_sub => 'المساعدة، النزاعات، القانونية';
	@override String get appearance_title => 'المظهر واللغة';
	@override String get lang_section => 'اللغة';
	@override String get lang_app_label => 'لغة التطبيق';
	@override String get theme_section => 'السمة';
	@override String get theme_light => 'السمة الفاتحة';
	@override String get theme_dark => 'السمة الداكنة';
	@override String get theme_system => 'اتباع النظام';
	@override String get text_size_section => 'حجم النص';
	@override String get text_adjust_label => 'ضبط حجم الخط';
	@override String get text_preview_label => 'معاينة مباشرة:';
	@override String get text_small => 'صغير';
	@override String get text_normal => 'عادي';
	@override String get text_large => 'كبير';
	@override String get text_xlarge => 'كبير جداً';
	@override String get arabic_font_section => 'الخط العربي';
	@override String get font_default => 'الافتراضي';
	@override String get font_cairo => 'Cairo';
	@override String get font_tajawal => 'Tajawal';
	@override String get font_almarai => 'Almarai';
	@override String get accessibility_section => 'إمكانية الوصول';
	@override String get bold_text => 'نص عريض';
	@override String get reduce_anim => 'تقليل الحركات';
	@override String get reduce_anim_sub => 'موصى به للأجهزة القديمة أو الحساسية للحركة';
	@override String get notif_push_enabled => 'تم تكوين التنبيهات على هذا الجهاز';
	@override String get notif_push_disabled => 'التنبيهات معطلة';
	@override String get notif_enabled_chip => 'مفعّل';
	@override String get notif_disabled_chip => 'معطّل';
	@override String get notif_open_settings_btn => 'فتح الإعدادات';
	@override String get notif_social_section => 'الإشعارات الاجتماعية';
	@override String get notif_commerce_section => 'إشعارات التسوق';
	@override String get notif_community_label => 'إشعارات المجتمع';
	@override String get notif_all => 'الكل';
	@override String get notif_mentions_only => 'الإشارات فقط';
	@override String get notif_off => 'إيقاف';
	@override String get notif_order_confirmed => 'تأكيد الطلب';
	@override String get notif_order_shipped => 'شحن الطلب';
	@override String get notif_order_delivered => 'تسليم الطلب';
	@override String get notif_refund_processed => 'معالجة الاسترداد';
	@override String get notif_price_drop => 'تنبيهات انخفاض السعر';
	@override String get notif_back_in_stock => 'تنبيهات العودة للمخزون';
	@override String get notif_vendor_section => 'إشعارات البائع';
	@override String get notif_order_sound => 'صوت تنبيه الطلب الجديد';
	@override String get notif_order_sound_sub => 'تشغيل صوت تنبيه عالٍ لكل طلب جديد';
	@override String get notif_daily_summary => 'ملخص المبيعات اليومي';
	@override String get notif_daily_summary_sub => 'احصل على ملخص صباحي لمبيعات أمس';
	@override String get notif_general_section => 'عام والنظام';
	@override String get notif_promotions_toggle => 'العروض الترويجية';
	@override String get notif_login_alerts => 'تنبيهات تسجيل الدخول';
	@override String get notif_login_alerts_sub => 'يُعلمك عند تسجيل الدخول من جهاز جديد';
	@override String get notif_manage_channels => 'فتح إعدادات الإشعارات';
	@override String get notif_manage_channels_sub => 'إدارة قنوات الإشعارات لهذا التطبيق';
	@override String get account_screen_title => 'الحساب والأمان';
	@override String get account_email_label => 'عنوان البريد الإلكتروني';
	@override String get account_password_label => 'كلمة المرور';
	@override String get account_password_sub => 'إرسال رابط إعادة تعيين إلى بريدك الإلكتروني';
	@override String get account_connected_label => 'الحسابات المرتبطة';
	@override String get account_biometric => 'القفل البيومتري';
	@override String get account_biometric_sub => 'يتطلب بصمة الإصبع أو Face ID لفتح واصلك';
	@override String get account_purchase_confirm => 'تأكيد الشراء';
	@override String get account_purchase_confirm_sub => 'يتطلب بيانات بيومترية قبل إتمام أي عملية شراء';
	@override String get account_login_notif => 'إشعارات تسجيل الدخول';
	@override String get account_login_notif_sub => 'يُعلمك عند تسجيل الدخول من جهاز جديد';
	@override String get privacy_screen_title => 'الخصوصية والسلامة';
	@override String get privacy_account_section => 'خصوصية الحساب';
	@override String get privacy_private_account => 'حساب خاص';
	@override String get privacy_private_account_sub => 'يمكن فقط للمتابعين المعتمدين رؤية منشوراتك';
	@override String get privacy_messaging_section => 'المراسلة والدردشة';
	@override String get privacy_read_receipts => 'إيصالات القراءة';
	@override String get privacy_read_receipts_sub => 'إظهار إيصالات القراءة (✓✓) في المحادثات';
	@override String get privacy_activity_status => 'إظهار حالة النشاط';
	@override String get privacy_blocked_section => 'المستخدمون المحظورون';
	@override String get privacy_follow_req_section => 'طلبات المتابعة';
	@override String get content_screen_title => 'المحتوى والخلاصة';
	@override String get content_feed_lang_section => 'لغة الخلاصة';
	@override String get content_muted_section => 'الكلمات المكتومة';
	@override String get content_posts_section => 'المنشورات';
	@override String get content_feed_section => 'سلوك الخلاصة';
	@override String get content_default_visibility => 'ظهور المنشور الافتراضي';
	@override String get content_vendor_section => 'إعدادات البائع';
	@override String get storage_screen_title => 'التخزين والأداء';
	@override String get storage_image_section => 'ذاكرة تخزين الصور';
	@override String get storage_recent_section => 'المشاهدة مؤخراً';
	@override String get storage_dev_section => 'إعدادات المطور';
	@override String get support_screen_title => 'الدعم والضمان';
	@override String get support_help_section => 'الحصول على المساعدة';
	@override String get support_legal_section => 'القانونية';
	@override String get support_escrow_section => 'الضمان والنزاعات';
	@override String get support_contact => 'تواصل مع الدعم';
	@override String get support_contact_sub => 'تحدث مع وكيل دعم واصلك';
	@override String get support_report_bug => 'الإبلاغ عن خطأ';
	@override String get support_report_sub => 'ساعدنا في تحسين التطبيق بالإبلاغ عن المشاكل';
	@override String get support_terms => 'شروط الاستخدام';
	@override String get support_privacy_policy => 'سياسة الخصوصية';
	@override String get app_screen_title => 'معلومات التطبيق';
	@override String get app_share_section => 'مشاركة وتقييم';
	@override String get app_about_section => 'حول';
	@override String get app_share_waslaq => 'شارك واصلك';
	@override String get app_share_sub => 'أخبر أصدقاءك عن السوق الفلسطيني';
	@override String get app_rate => 'قيّم واصلك';
	@override String get app_rate_sub => 'اترك تقييماً في المتجر';
	@override String get app_permissions => 'صلاحيات التطبيق';
	@override String get app_permissions_sub => 'إدارة صلاحيات التخزين والكاميرا والإشعارات';
	@override String get profile_screen_title => 'إعدادات الملف الشخصي';
	@override String get address_screen_title => 'دفتر العناوين';
	@override String get refund_screen_title => 'تفاصيل الاسترداد';
	@override String get vendor_screen_title => 'إعدادات البائع';
	@override String get vendor_store_status_section => 'حالة المتجر';
	@override String get vendor_delivery_section => 'مناطق التوصيل';
	@override String get vendor_notif_section => 'الإشعارات';
	@override String get hubProfile => 'الملف الشخصي';
	@override String get hubProfileSub => 'تعديل معلومات ملفك الشخصي';
	@override String get hubAccount => 'الحساب والأمان';
	@override String get hubAccountSub => 'كلمة المرور والبريد الإلكتروني وإعدادات الحساب';
	@override String get hubAddress => 'العناوين';
	@override String get hubAddressSub => 'إدارة عناوين التوصيل';
	@override String get hubRefund => 'تفاصيل الاسترداد';
	@override String get hubRefundSub => 'الحساب البنكي للمبالغ المستردة';
	@override String get hubPrivacy => 'الخصوصية';
	@override String get hubPrivacySub => 'تحكم بمن يرى محتواك';
	@override String get hubNotifications => 'الإشعارات';
	@override String get hubNotificationsSub => 'إدارة تفضيلات الإشعارات';
	@override String get hubContent => 'المحتوى';
	@override String get hubContentSub => 'اللغة وتفضيلات المحتوى';
	@override String get hubAppearance => 'المظهر';
	@override String get hubAppearanceSub => 'إعدادات السمة والعرض';
	@override String get hubStorage => 'التخزين';
	@override String get hubStorageSub => 'إدارة ذاكرة التخزين المؤقت والبيانات';
	@override String get hubVendor => 'إعدادات المتجر';
	@override String get hubVendorSub => 'إدارة إعدادات متجرك';
	@override String get hubApp => 'معلومات التطبيق';
	@override String get hubAppSub => 'الإصدار وحول التطبيق';
	@override String get hubSupport => 'الدعم';
	@override String get hubSupportSub => 'المساعدة والتواصل معنا';
	@override String get deleteAccount => 'حذف الحساب';
	@override String get permanentAction => 'هذه العملية نهائية ولا يمكن التراجع عنها';
	@override String get accountScreenTitle => 'الحساب والأمان';
	@override String get accountEmailLabel => 'البريد الإلكتروني';
	@override String get notSet => 'غير محدد';
	@override String get accountPasswordLabel => 'كلمة المرور';
	@override String get accountPasswordSub => 'تغيير كلمة المرور';
	@override String get resetLinkButton => 'إرسال رابط إعادة الضبط';
	@override String get accountConnectedLabel => 'الحساب المرتبط';
	@override String get accountBiometric => 'تسجيل الدخول البيومتري';
	@override String get accountBiometricSub => 'استخدم بصمة الإصبع أو الوجه لتسجيل الدخول';
	@override String get accountLoginNotif => 'إشعارات تسجيل الدخول';
	@override String get accountLoginNotifSub => 'إشعاري بتسجيلات الدخول الجديدة';
	@override String get accountPurchaseConfirm => 'تأكيد الشراء';
	@override String get accountPurchaseConfirmSub => 'طلب تأكيد قبل الشراء';
	@override String get addressScreenTitle => 'العناوين';
	@override String get refundScreenTitle => 'تفاصيل الاسترداد';
	@override String get privacyScreenTitle => 'الخصوصية';
	@override String get privacyAccountSection => 'خصوصية الحساب';
	@override String get privacyPrivateAccount => 'حساب خاص';
	@override String get privacyPrivateAccountSub => 'فقط المتابعون المعتمدون يرون منشوراتك';
	@override String get privacyFollowReqSection => 'طلبات المتابعة';
	@override String get privacyActivityStatus => 'حالة النشاط';
	@override String get privacyMessagingSection => 'المراسلة';
	@override String get privacyReadReceipts => 'إيصالات القراءة';
	@override String get privacyReadReceiptsSub => 'اسمح للآخرين بمعرفة متى قرأت رسائلهم';
	@override String get privacyBlockedSection => 'المستخدمون المحظورون';
	@override String get notifAll => 'الكل';
	@override String get notifMentionsOnly => 'الإشارات فقط';
	@override String get notifOff => 'إيقاف';
	@override String get notifEnabledChip => 'مفعّل';
	@override String get notifDisabledChip => 'معطّل';
	@override String get notifPushEnabled => 'الإشعارات الفورية مفعّلة';
	@override String get notifPushDisabled => 'الإشعارات الفورية معطّلة';
	@override String get notifOpenSettingsBtn => 'فتح الإعدادات';
	@override String get notifGeneralSection => 'عام';
	@override String get notifSocialSection => 'اجتماعي';
	@override String get notifCommerceSection => 'التسوق';
	@override String get notifVendorSection => 'المتجر';
	@override String get notifComments => 'التعليقات';
	@override String get notifUpvotes => 'التصويتات';
	@override String get notifMentions => 'الإشارات';
	@override String get notifNewFollowers => 'متابعون جدد';
	@override String get notifFollowRequests => 'طلبات المتابعة';
	@override String get notifLoginAlerts => 'تنبيهات تسجيل الدخول';
	@override String get notifLoginAlertsSub => 'إشعاري بتسجيلات الدخول الجديدة';
	@override String get notifDailySummary => 'الملخص اليومي';
	@override String get notifDailySummarySub => 'احصل على ملخص يومي للنشاط';
	@override String get notifOrderConfirmed => 'تأكيد الطلب';
	@override String get notifOrderShipped => 'شحن الطلب';
	@override String get notifOrderDelivered => 'تسليم الطلب';
	@override String get notifRefundProcessed => 'معالجة الاسترداد';
	@override String get notifBackInStock => 'عودة للمخزون';
	@override String get notifPriceDrop => 'انخفاض السعر';
	@override String get notifPromotionsToggle => 'العروض الترويجية';
	@override String get notifOrderSound => 'صوت الطلب';
	@override String get notifOrderSoundSub => 'تشغيل صوت للطلبات الجديدة';
	@override String get notifManageChannels => 'إدارة القنوات';
	@override String get notifManageChannelsSub => 'التحكم في قنوات الإشعارات';
	@override String get pushNotifications => 'الإشعارات الفورية';
	@override String get contentScreenTitle => 'المحتوى';
	@override String get contentFeedSection => 'الخلاصة';
	@override String get contentFeedLangSection => 'لغة الخلاصة';
	@override String get contentPostsSection => 'المنشورات';
	@override String get contentMutedSection => 'المكتوم';
	@override String get contentVendorSection => 'البائعون';
	@override String get langSection => 'اللغة';
	@override String get langAppLabel => 'لغة التطبيق';
	@override String get appearanceTitle => 'المظهر';
	@override String get themeSection => 'السمة';
	@override String get themeLight => 'فاتح';
	@override String get themeDark => 'داكن';
	@override String get themeSystem => 'افتراضي النظام';
	@override String get textSizeSection => 'حجم النص';
	@override String get textAdjustLabel => 'ضبط حجم النص';
	@override String get textPreviewLabel => 'معاينة';
	@override String get textSmall => 'صغير';
	@override String get textNormal => 'عادي';
	@override String get textLarge => 'كبير';
	@override String get textXlarge => 'كبير جداً';
	@override String get boldText => 'نص عريض';
	@override String get reduceAnim => 'تقليل الحركات';
	@override String get reduceAnimSub => 'تقليل تأثيرات الحركة';
	@override String get arabicFontSection => 'الخط العربي';
	@override String get fontDefault => 'افتراضي';
	@override String get fontCairo => 'القاهرة';
	@override String get fontAlmarai => 'المراعي';
	@override String get fontTajawal => 'تجوال';
	@override String get accessibilitySection => 'إمكانية الوصول';
	@override String get storageScreenTitle => 'التخزين';
	@override String get storageImageSection => 'الصور';
	@override String get storageRecentSection => 'الأخيرة';
	@override String get storageDevSection => 'المطوّر';
	@override String get vendorScreenTitle => 'إعدادات المتجر';
	@override String get vendorStoreStatusSection => 'حالة المتجر';
	@override String get vendorDeliverySection => 'التوصيل';
	@override String get vendorNotifSection => 'الإشعارات';
	@override String get appScreenTitle => 'معلومات التطبيق';
	@override String get appAboutSection => 'حول';
	@override String get appShareSection => 'مشاركة';
	@override String get supportScreenTitle => 'الدعم';
	@override String get supportHelpSection => 'المساعدة';
	@override String get supportEscrowSection => 'الضمان والمدفوعات';
	@override String get supportLegalSection => 'قانوني';
	@override String get notifCommunityLabel => 'إشعارات المجتمع';
	@override String get currencySection => 'العملة';
	@override String get currencyLabel => 'عملة العرض';
	@override String get currencyIls => 'شيكل (₪)';
	@override String get currencyIlsSub => 'عرض الأسعار بالشيكل الإسرائيلي الجديد';
	@override String get currencyUsd => 'دولار (USD)';
	@override String get currencyUsdSub => 'عرض الأسعار محوّلة إلى الدولار الأمريكي';
}

// Path: become_vendor
class StringsBecomeVendorAr extends StringsBecomeVendorEn {
	StringsBecomeVendorAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'انضم إلى قائمة الموردين';
	@override String get subtitle => 'انضم إلى منصتنا وابدأ في بيع منتجاتك.';
	@override String get benefit1 => 'بيع المنتجات المادية والرقمية';
	@override String get benefit2 => 'نظام دفع آمن عبر حساب الضمان';
	@override String get benefit3 => 'حماية مدمجة من النزاعات';
	@override String get benefit4 => 'اطلب سحب أموالك في أي وقت';
	@override String get agree_terms => 'أوافق على شروط المنصة وسياسات البائعين';
	@override String get create_account => 'أنشئ حسابك';
	@override String get continue_google => 'متابعة باستخدام Google';
	@override String get signup_email => 'التسجيل عبر البريد الإلكتروني';
	@override String get skip_auth => 'هل لديك حساب بالفعل؟ تخطي هذه الخطوة';
	@override String get verify_email_title => 'تحقق من بريدك الإلكتروني';
	@override String verify_email_desc({required Object email}) => 'لقد أرسلنا رابطًا إلى ${email}. انقر عليه، ثم عد إلى هنا.';
	@override String get verified_button => 'لقد قمت بالتحقق من بريدي الإلكتروني';
	@override String get setup_store => 'أنشئ متجرك';
	@override String get store_name => 'اسم المتجر';
	@override String get store_name_placeholder => 'متجري الرائع';
	@override String get store_description => 'وصف المتجر';
	@override String get store_desc_placeholder => 'أخبر العملاء بما تبيعه...';
	@override String get store_location => 'موقع المتجر';
	@override String get store_loc_placeholder => 'مثل: غزة، رام الله، الخليل...';
	@override String get delivery_zone => 'منطقة التوصيل';
	@override String get delivery_placeholder => 'اختر منطقة التوصيل...';
	@override String get zone_gaza => 'قطاع غزة فقط';
	@override String get zone_westbank => 'الضفة الغربية فقط';
	@override String get zone_both => 'كلاهما (غزة والضفة الغربية)';
	@override String get delivery_hint => 'لن يتم توصيل المنتجات المادية إلا داخل المنطقة التي اخترتها. أما المنتجات الرقمية فلا توجد عليها أي قيود.';
	@override String get what_do_you_sell => 'ماذا تبيعون؟';
	@override String get skip_now => 'تخطي هذا الآن';
	@override String get submit_app => 'تقديم الطلب';
	@override String get success_title => 'تم إرسال الطلب!';
	@override String get success_desc => 'طلبك للتسجيل كمورد قيد المراجعة. سيتم إخطارك فور الموافقة عليه.';
	@override String get go_account => 'انتقل إلى "حسابي"';
	@override String get continue_shopping => 'متابعة التسوق';
	@override String get screen_title => 'كن بائعاً';
	@override String get header_title => 'افتح متجرك\nعلى واصلك';
	@override String get header_subtitle => 'بع لآلاف المشترين الفلسطينيين مع حماية كاملة لحساب الضمان.';
	@override String get why_sell => 'لماذا تبيع على واصلك؟';
	@override String get escrow_title => 'حماية الضمان';
	@override String get escrow_desc => 'يتم الاحتفاظ بكل عملية بيع في الضمان حتى يؤكد المشتري الاستلام.';
	@override String get community_title => 'مجتمع مدمج';
	@override String get community_desc => 'الوصول إلى المشترين من خلال صفحتنا الاجتماعية ومنشورات المجتمع.';
	@override String get delivery_title => 'مناطق التوصيل المحلية';
	@override String get delivery_desc => 'التوصيل داخل غزة أو الضفة الغربية - نحن نتولى منطق المناطق.';
	@override String get dashboard_title => 'لوحة تحكم البائع';
	@override String get dashboard_desc => 'تتبع الطلبات والأرباح وإدارة منتجاتك بسهولة.';
	@override String get store_details => 'تفاصيل المتجر';
	@override String get store_name_label => 'اسم المتجر';
	@override String get store_name_hint => 'مثال: أبو أحمد للإلكترونيات';
	@override String get store_desc_label => 'وصف المتجر';
	@override String get store_desc_hint => 'ماذا تبيع؟';
	@override String get phone_label => 'رقم الهاتف';
	@override String get phone_hint => '+970 5X XXX XXXX';
	@override String get select_zone_hint => 'اختر منطقة التوصيل الخاصة بك';
	@override String get submit_application => 'تقديم الطلب';
	@override String get review_time => 'نحن نراجع الطلبات في غضون 24-48 ساعة.';
	@override String get store_name_required => 'اسم المتجر مطلوب';
	@override String get select_zone_required => 'يرجى تحديد منطقة التوصيل';
	@override String get already_applied => 'لديك بالفعل طلب بائع سابق.';
	@override String get submission_failed => 'فشل تقديم الطلب. يرجى المحاولة مرة أخرى.';
	@override String get application_submitted => 'تم تقديم الطلب! سنقوم بمراجعته في غضون 48 ساعة.';
}

// Path: privacy
class StringsPrivacyAr extends StringsPrivacyEn {
	StringsPrivacyAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get page_title => 'سياسة الخصوصية';
	@override String get last_updated => 'تاريخ السريان: 1 مايو 2026 · آخر تحديث: 1 مايو 2026';
	@override String get intro => 'تلتزم "واسلق" ("نحن" أو "المنصة") بحماية خصوصية جميع المستخدمين وبياناتهم الشخصية. تصف سياسة الخصوصية هذه كيفية قيامنا بجمع معلوماتك ومعالجتها وتخزينها وحمايتها وفقًا لمبادئ حماية البيانات الفلسطينية المعمول بها وأفضل الممارسات الدولية، بما في ذلك معايير اللائحة العامة لحماية البيانات (GDPR). وبدخولك إلى "واسلق" أو استخدامها، فإنك تقر بأنك قد قرأت الممارسات الموضحة في هذه السياسة وتوافق عليها.';
	@override String get s1_title => 'من نحن';
	@override String get s1_body => '"واسلق" هي منصة سوق إلكترونية اجتماعية مستقلة تعمل تحت الإشراف الفلسطيني. نحن نربط البائعين المستقلين بالمشترين، ونسهل إجراء المعاملات الآمنة القائمة على نظام الضمان، ونوفر ميزات مجتمعية تشمل المنشورات والمجموعات والرسائل المباشرة وتقييمات المنتجات.';
	@override String get s2_title => 'المعلومات التي نجمعها';
	@override String get s2_1_title => '2.1 معلومات الحساب والتسجيل';
	@override String get s2_2_title => '2.2 معلومات خاصة بالمورد';
	@override String get s2_3_title => '2.3 بيانات المعاملات والطلبات';
	@override String get s2_4_title => '2.4 بيانات التحقق من الهوية (KYC)';
	@override String get s2_5_title => '2.5 المحتوى الذي ينشئه المستخدمون';
	@override String get s2_6_title => '2.6 البيانات الفنية وبيانات الاستخدام';
	@override String get s3_title => 'الأساس القانوني للمعالجة';
	@override String get s4_title => 'كيف نستخدم معلوماتك';
	@override String get s5_title => 'كيف نشارك معلوماتك';
	@override String get s6_title => 'أمن البيانات';
	@override String get s7_title => 'الاحتفاظ بالبيانات';
	@override String get s8_title => 'حقوقك';
	@override String get s9_title => 'خصوصية الأطفال';
	@override String get s10_title => 'التعديلات على هذه السياسة';
	@override String get cookie_policy_title => 'سياسة ملفات تعريف الارتباط';
	@override String get cookie_policy_intro => 'تنطبق سياسة ملفات تعريف الارتباط هذه على المستخدمين الذين يدخلون إلى موقع "Waslaq" من الاتحاد الأوروبي، والمنطقة الاقتصادية الأوروبية، والمملكة المتحدة، وغيرها من الولايات القضائية التي تسري فيها متطلبات الموافقة على ملفات تعريف الارتباط بموجب توجيه الخصوصية الإلكترونية (ePrivacy Directive) أو اللائحة العامة لحماية البيانات (GDPR) أو التشريعات المماثلة.';
	@override String get s1_body_2 => 'للاستفسارات المتعلقة بالخصوصية: privacy@waslaq.com · waslaq.com/contact';
	@override String get s2_1_item1 => 'الاسم الكامل';
	@override String get s2_1_item2 => 'عنوان البريد الإلكتروني (عبر مصادقة Google Firebase أو التسجيل المباشر)';
	@override String get s2_1_item3 => 'رقم الهاتف (اختياري ما لم يكن مطلوبًا لإتمام عملية تسجيل المورد)';
	@override String get s2_1_item4 => 'اسم العرض والصورة الرمزية في الملف الشخصي';
	@override String get s2_1_item5 => 'تاريخ إنشاء الحساب وطريقة المصادقة (Google أو Facebook أو البريد الإلكتروني/كلمة المرور)';
	@override String get s2_vendor_intro => 'يقدم البائعون الذين يقدمون طلبات التسجيل ما يلي:';
	@override String get s2_2_item1 => 'اسم المتجر، والوصف العام، والشعار، وصور البانر';
	@override String get s2_2_item2 => 'منطقة التسليم (غزة، الضفة الغربية، أو كلاهما) والموقع الفعلي';
	@override String get s2_2_item3 => 'تفاصيل حساب الدفع: رقم IBAN أو عنوان PayPal (يتم تخزينها بشكل آمن، ولا يتم الكشف عنها علنًا أبدًا)';
	@override String get s2_2_item4 => 'وثائق التحقق من الهوية (KYC) وفقًا لمتطلبات الامتثال';
	@override String get s2_3_item1 => 'رقم الطلب، رقم العرض، الطابع الزمني للإنشاء، والحالة';
	@override String get s2_3_item2 => 'تفاصيل المنتج: العنوان، النوع، الكمية، سعر الوحدة بالشيكل الإسرائيلي';
	@override String get s2_3_item3 => 'عنوان الشحن: اسم المستلم، الشارع، المدينة، الرمز البريدي';
	@override String get s2_3_item4 => 'حالة الدفع وأرقام تأكيد الدفع';
	@override String get s2_3_item5 => 'حالة الحساب المعلق والقيود الدفترية المرتبطة بالمعاملة';
	@override String get s2_3_item6 => 'سجل طلبات الدفع للموردين';
	@override String get s2_3_payment_card_data_title => 'بيانات بطاقة الدفع:';
	@override String get s2_3_payment_card_data_body => 'نحن لا نقوم بتخزين أرقام بطاقات الدفع الكاملة أو رموز CVV أو بيانات مصادقة حامل البطاقة، ولا نعالجها أو ننقلها. تتم معالجة جميع عمليات الدفع حصريًّا عبر بوابات دفع متوافقة مع معيار PCI-DSS من المستوى الأول. ولا نتلقى سوى أرقام مرجعية لتأكيد المعاملات ورموز الحالة.';
	@override String get s2_4_body => 'قد تشمل إجراءات "اعرف عميلك" (KYC) بطاقة هوية صادرة عن الحكومة ومزودة بصورة، وإثبات ملكية الحساب المصرفي، ووثائق تجارية. ويتم تخزين هذه البيانات في ظل ضوابط صارمة للوصول إليها، ولا تُستخدم إلا لأغراض الامتثال لقوانين مكافحة غسل الأموال ومنع الاحتيال، ولا يتم مشاركتها أبدًا مع مستخدمين آخرين.';
	@override String get s2_5_item1 => 'المنشورات على مواقع التواصل الاجتماعي، والتعليقات، والتصويتات، وحفظ المحتوى';
	@override String get s2_5_item2 => 'عضويات المجتمع وأدواره';
	@override String get s2_5_item3 => 'تقييمات المنتجات وتصنيفات النجوم';
	@override String get s2_5_item4 => 'أسئلة وأجوبة العملاء المرسلة إلى الموردين';
	@override String get s2_5_item5 => 'الرسائل المباشرة ومحادثات الطلبات عبر GetStream';
	@override String get s2_6_item1 => 'عنوان IP والموقع الجغرافي التقريبي (على مستوى المدينة/المنطقة)';
	@override String get s2_6_item2 => 'نوع الجهاز ونظام التشغيل وإصدار المتصفح';
	@override String get s2_6_item3 => 'الصفحات التي تمت زيارتها، والوقت الذي قضاه المستخدم، ومسار التنقل';
	@override String get s2_6_item4 => 'استعلامات البحث التي تم إدخالها على المنصة';
	@override String get s2_6_item5 => 'سجلات الأخطاء ومعلومات التشخيص';
	@override String get table_processing_activities => 'أنشطة المعالجة';
	@override String get table_legal_basis => 'الأساس القانوني';
	@override String get table_row1_activity => 'إدارة الحسابات، ومعالجة الطلبات، وعمليات الحساب المعلق، ودفع المستحقات للموردين، وتسوية النزاعات';
	@override String get table_row1_basis => 'الضرورة التعاقدية';
	@override String get table_row2_activity => 'الامتثال لقوانين "اعرف عميلك" (KYC) ومكافحة غسل الأموال (AML)، والسجلات الضريبية، والأوامر القضائية';
	@override String get table_row2_basis => 'الالتزام القانوني';
	@override String get table_row3_activity => 'منع الاحتيال، ومراقبة الأمن، وتحليلات المنصات، وكشف حالات إساءة الاستخدام';
	@override String get table_row3_basis => 'المصالح المشروعة';
	@override String get table_row4_activity => 'الإشعارات الفورية، والرسائل التسويقية الاختيارية، وملفات تعريف الارتباط غير الضرورية';
	@override String get table_row4_basis => 'الموافقة';
	@override String get s4_1_title => '4.1 عمليات المنصة';
	@override String get s4_2_title => '4.2 الأمن ومنع الاحتيال';
	@override String get s4_3_title => '4.3 التواصل';
	@override String get s5_sell_no => 'نحن لا نبيع بياناتك الشخصية أو نؤجرها أو نتاجر بها مع أطراف ثالثة لأغراض إعلانية أو تسويقية.';
	@override String get s5_1_title => '5.1 شركات معالجة الدفع';
	@override String get s5_1_body => 'يتم مشاركة بيانات المعاملات مع بنك فلسطين وبوابات الدفع المعتمدة حصريًّا لغرض تنفيذ الدفع ومنع الاحتيال.';
	@override String get s5_2_title => '5.2 الجهات الفرعية المعالجة للبيانات في مجال البنية التحتية';
	@override String get table_service => 'الخدمة';
	@override String get table_purpose => 'الغرض';
	@override String get table_data_processed => 'البيانات التي تمت معالجتها';
	@override String get s5_3_title => '5.3 بين المشترين والبائعين';
	@override String get s5_3_body => 'عند تقديم طلب شراء، يتم مشاركة اسم المشتري وعنوان التسليم وتفاصيل الطلب مع البائع المعني لغرض تنفيذ الطلب حصراً. ويُحظر على البائعين استخدام هذه المعلومات لأي غرض آخر.';
	@override String get s5_4_title => '5.4 الكشف القانوني والقضائي';
	@override String get s5_4_body => 'قد نكشف عن البيانات الشخصية للمحاكم الفلسطينية أو سلطات إنفاذ القانون أو الهيئات التنظيمية عندما يقتضي ذلك أمر قضائي رسمي قانوني. وحيثما يسمح القانون بذلك، سنقوم بإخطار المستخدم المعني قبل الكشف عن هذه البيانات.';
	@override String get s6_security_note => 'على الرغم من أننا نطبق إجراءات أمنية متوافقة مع معايير القطاع، إلا أنه لا يوجد نظام إلكتروني آمن بنسبة 100٪. تقع على عاتقك مسؤولية الحفاظ على سرية بيانات تسجيل الدخول الخاصة بك. يرجى الإبلاغ عن أي حالة يشتبه في أنها وصول غير مصرح به إلى';
	@override String get table_data_category => 'فئة البيانات';
	@override String get table_retention_period => 'فترة الاحتفاظ';
	@override String get s8_submit_note => 'يرجى إرسال الطلبات إلى ... وسنرد عليك في غضون 30 يومًا. قد يكون من الضروري التحقق من هويتك.';
	@override String get s9_minors_body => 'لا يُقصد بـ«واسلق» المستخدمون الذين تقل أعمارهم عن 18 عامًا. ونحن لا نجمع البيانات عن القاصرين عن قصد. وإذا علمنا بتسجيل قاصر، فسوف نقوم على الفور بتعليق الحساب وحذف البيانات المرتبطة به. يرجى الإبلاغ عن أي مخاوف إلى';
	@override String get s10_updates_body => 'قد نقوم بتحديث هذه السياسة في أي وقت. وسيتم الإبلاغ عن التغييرات الجوهرية عبر البريد الإلكتروني وإشعار على المنصة قبل 14 يومًا على الأقل من دخولها حيز التنفيذ. ويُعتبر الاستمرار في استخدام Waslaq بعد دخول التغييرات حيز التنفيذ قبولاً للسياسة المعدلة.';
	@override String get cookie_disclosure_label => 'إشعار بشأن ملفات تعريف الارتباط';
	@override String get what_are_cookies_title => 'ما هي ملفات تعريف الارتباط؟';
	@override String get what_are_cookies_body => 'ملفات تعريف الارتباط هي ملفات نصية صغيرة يضعها موقع الويب على جهازك. وهي تتيح للمواقع الإلكترونية العمل بشكل سليم، وتذكر تفضيلاتك، وتزود مالك الموقع بتحليلات. وقد تكون ملفات تعريف الارتباط مؤقتة (تُحذف عند إغلاق المتصفح) أو دائمة (تُخزّن على جهازك لفترة محددة).';
	@override String get cookies_we_use_title => 'ملفات تعريف الارتباط التي نستخدمها';
	@override String get strictly_necessary_title => 'ملفات تعريف الارتباط الضرورية للغاية — لا تتطلب موافقة';
	@override String get functional_cookies_title => 'ملفات تعريف الارتباط الوظيفية — يلزم الحصول على الموافقة';
	@override String get no_ads_cookies => 'لا توجد ملفات تعريف ارتباط إعلانية. لا يعرض موقع "Waslaq" أي إعلانات، ولا يستخدم وحدات بكسل إعادة الاستهداف أو ملفات تعريف الارتباط الخاصة بأطراف ثالثة أو تقنيات الإعلان السلوكي.';
	@override String get third_party_cookies_title => 'ملفات تعريف الارتباط الخاصة بأطراف ثالثة';
	@override String get table_privacy_policy => 'سياسة الخصوصية';
	@override String get your_cookie_choices_title => 'خيارات ملفات تعريف الارتباط الخاصة بك';
	@override String get your_cookie_choices_body => 'يمكنك ضبط متصفحك لرفض ملفات تعريف الارتباط أو حذفها:';
	@override String get disabling_cookies_note => 'سيؤدي تعطيل ملفات تعريف الارتباط الضرورية للغاية إلى منعك من تسجيل الدخول واستخدام الميزات الأساسية للمنصة.';
	@override String get legal_basis_cookies_title => 'الأساس القانوني لاستخدام ملفات تعريف الارتباط';
	@override String get table_category => 'الفئة';
	@override String get cookie_inquiries => 'الاستفسارات المتعلقة بملفات تعريف الارتباط:';
	@override String get footer_questions => 'هل لديك أسئلة حول هذه السياسة؟ اتصل بـ ... أو تفضل بزيارة موقعنا';
	@override String get footer_rights => '© 2026 واسلاق. السوق الاجتماعي الفلسطيني. جميع الحقوق محفوظة.';
	@override String get table_row1_purpose_infra => 'شبكة توزيع المحتوى (CDN)، الحماية من هجمات DDoS، SSL';
	@override String get table_row1_data_infra => 'عناوين IP، وبيانات تعريف الطلب';
	@override String get table_row2_purpose_infra => 'مصادقة المستخدم';
	@override String get table_row2_data_infra => 'البريد الإلكتروني، معرّف المستخدم الفريد (UID)، رموز المصادقة';
	@override String get table_row3_purpose_infra => 'المراسلة والموجزات في الوقت الفعلي';
	@override String get table_row3_data_infra => 'معرفات المستخدمين، محتوى الرسائل';
	@override String get table_row4_purpose_infra => 'تسليم رسائل البريد الإلكتروني المتعلقة بالمعاملات';
	@override String get table_row4_data_infra => 'عناوين البريد الإلكتروني، ومحتوى رسائل البريد الإلكتروني';
	@override String get table_row5_purpose_infra => 'وسائط التخزين';
	@override String get table_row5_data_infra => 'الملفات والصور التي تم تحميلها';
	@override String get table_retention_row1_cat => 'معلومات الحساب';
	@override String get table_retention_row1_period => 'مدة الحساب + سنتان بعد الحذف';
	@override String get table_retention_row2_cat => 'سجلات المعاملات وبيانات دفتر الأستاذ';
	@override String get table_retention_row2_period => '5 سنوات على الأقل (الامتثال المالي)';
	@override String get table_retention_row3_cat => 'التعرف على العميل / وثائق الهوية';
	@override String get table_retention_row3_period => 'مدة العلاقة مع المورد + 5 سنوات';
	@override String get table_retention_row4_cat => 'سجلات النزاعات والقرارات';
	@override String get table_retention_row4_period => '5 سنوات من تاريخ صدور القرار';
	@override String get table_retention_row5_cat => 'بيانات الطلب والشحن';
	@override String get table_retention_row5_period => '3 سنوات';
	@override String get table_retention_row6_cat => 'سجلات الاستخدام والسجلات الفنية';
	@override String get table_retention_row6_period => '90 يومًا';
	@override String get table_retention_row7_cat => 'تذاكر الدعم';
	@override String get table_retention_row7_period => '3 سنوات';
	@override String get table_retention_row8_cat => 'بيانات الحساب المحذوفة';
	@override String get table_retention_row8_period => 'يتم إخفاء الهوية أو حذفها في غضون 30 يومًا';
	@override String get s8_item1_title => 'حق الاطلاع';
	@override String get s8_item1_desc => 'اطلب نسخة من البيانات الشخصية التي نحتفظ بها عنك.';
	@override String get s8_item2_title => 'الحق في التصحيح';
	@override String get s8_item2_desc => 'اطلب تصحيح البيانات غير الدقيقة أو غير الكاملة.';
	@override String get s8_item3_title => 'الحق في حذف البيانات';
	@override String get s8_item3_desc => 'طلب حذف بياناتك (مع مراعاة متطلبات الاحتفاظ القانونية).';
	@override String get s8_item4_title => 'الحق في تقييد المعالجة';
	@override String get s8_item4_desc => 'طلب التوقف المؤقت عن المعالجة في ظروف معينة.';
	@override String get s8_item5_title => 'الحق في نقل البيانات';
	@override String get s8_item5_desc => 'اطلب تصدير بياناتك في صيغة منظمة وقابلة للقراءة آليًّا.';
	@override String get s8_item6_title => 'الحق في الاعتراض';
	@override String get s8_item6_desc => 'الاعتراض على المعالجة استنادًا إلى المصالح المشروعة.';
	@override String get s8_item7_title => 'الحق في سحب الموافقة';
	@override String get s8_item7_desc => 'يمكنك سحب موافقتك على المعالجة القائمة على الموافقة في أي وقت.';
	@override String get table_cookie1_purpose => 'رمز جلسة العمل المصادق عليه للخلفية التجارية';
	@override String get table_cookie1_duration => 'الجلسة';
	@override String get table_cookie2_purpose => 'جلسة مصادقة Firebase';
	@override String get table_cookie2_duration => 'الجلسة';
	@override String get table_cookie3_purpose => 'يمنع تزوير الطلبات عبر المواقع';
	@override String get table_cookie3_duration => 'الجلسة';
	@override String get table_cookie4_name => 'ملفات تعريف الارتباط الخاصة بالتفضيلات';
	@override String get table_cookie4_purpose => 'يحتفظ بتفضيلات العرض والإشعارات';
	@override String get table_cookie4_duration => 'سنة واحدة';
	@override String get table_cookie5_name => 'حفظ سلة التسوق';
	@override String get table_cookie5_purpose => 'يحتفظ بمحتويات سلة التسوق عبر الجلسات';
	@override String get table_cookie5_duration => '30 يومًا';
	@override String get your_cookie_choices_item1 => 'Chrome: الإعدادات → الخصوصية والأمان → ملفات تعريف الارتباط وبيانات المواقع الأخرى';
	@override String get your_cookie_choices_item2 => 'فايرفوكس: الخيارات → الخصوصية والأمان → ملفات تعريف الارتباط وبيانات المواقع';
	@override String get your_cookie_choices_item3 => 'Safari: التفضيلات → الخصوصية → إدارة بيانات المواقع الإلكترونية';
	@override String get your_cookie_choices_item4 => 'Edge: الإعدادات → الخصوصية والبحث والخدمات → ملفات تعريف الارتباط';
	@override String get table_cookie_legal_row1_cat => 'ضرورية للغاية';
	@override String get table_cookie_legal_row1_basis => 'المصلحة المشروعة / الضرورة التعاقدية — لا حاجة إلى موافقة';
	@override String get table_cookie_legal_row2_cat => 'وظيفي';
	@override String get table_cookie_legal_row2_basis => 'الموافقة';
	@override String get table_cookie_legal_row3_cat => 'التحليلات';
	@override String get table_cookie_legal_row3_basis => 'الموافقة (نستخدم ملفات تعريف الارتباط من جانب الخادم فقط، ولا نستخدم ملفات تعريف الارتباط الخاصة بالتتبع)';
	@override String get table_cookie_legal_row4_cat => 'الإعلان';
	@override String get table_cookie_legal_row4_basis => 'لا ينطبق — نحن لا نستخدم ملفات تعريف الارتباط الإعلانية';
	@override String get s4_1_item1 => 'لإنشاء حسابك وإدارته.';
	@override String get s4_1_item2 => 'لمعالجة طلباتك وتنفيذها.';
	@override String get s4_1_item3 => 'تقديم خدمات الضمان والدفع الآمنة.';
	@override String get s4_1_item4 => 'لتسهيل التواصل بين المشترين والبائعين.';
	@override String get s4_1_item5 => 'لإبلاغك بحالة الطلب وتحديثات المنصة.';
	@override String get s4_2_item1 => 'لمراقبة الأنشطة المشبوهة أو الاحتيالية.';
	@override String get s4_2_item2 => 'للتحقق من هويتك في إطار عملية تسجيل الموردين.';
	@override String get s4_2_item3 => 'لحماية سلامة نظام الحساب المعلق.';
	@override String get s4_2_item4 => 'لتسوية النزاعات والتوسط في المطالبات.';
	@override String get s4_2_item5 => 'الامتثال للالتزامات القانونية والتنظيمية.';
	@override String get s4_3_item1 => 'إشعارات فورية للرسائل والطلبات الجديدة.';
	@override String get s4_3_item2 => 'تحديثات عبر البريد الإلكتروني بشأن أمان الحساب وأنشطته.';
	@override String get s4_3_item3 => 'الاتصالات التسويقية الاختيارية (في حالة تقديم الموافقة).';
}

// Path: terms
class StringsTermsAr extends StringsTermsEn {
	StringsTermsAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get page_title => 'شروط الاستخدام';
	@override String get last_updated => 'تاريخ السريان: 1 مايو 2026 · آخر تحديث: 1 مايو 2026';
	@override String get intro => 'تشكل شروط الاستخدام هذه ("الاتفاقية") عقدًا ملزمًا قانونًا بين Waslaq ("المنصة"، "نحن"، "لنا") وجميع المستخدمين، بما في ذلك المشترون والبائعون ("أنت"، "المستخدم"). من خلال الوصول إلى أي جزء من منصة Waslaq أو استخدامه — بما في ذلك التصفح أو التسجيل أو الشراء أو البيع — فإنك تقبل دون قيد أو شرط جميع الشروط المنصوص عليها في هذه الاتفاقية. إذا كنت لا توافق على أي جزء من هذه الاتفاقية، فيجب عليك التوقف فوراً عن استخدام المنصة بأي شكل من الأشكال.';
	@override String get s1_title => 'طبيعة المنصة';
	@override String get s2_title => 'تسجيل الحساب وشروط الأهلية';
	@override String get s3_title => 'نظام الضمان والدفع';
	@override String get s4_title => 'التزامات المورد وإجراءات "اعرف عميلك"';
	@override String get s5_title => 'التزامات المشتري';
	@override String get s6_title => 'المحتوى والأنشطة المحظورة';
	@override String get s7_title => 'الملكية الفكرية';
	@override String get s8_title => 'تسوية المنازعات';
	@override String get s9_title => 'عمليات رد المبالغ المدفوعة';
	@override String get s10_title => 'رسوم وعمولات المنصة';
	@override String get s11_title => 'حدود المسؤولية';
	@override String get s12_title => 'الإنهاء والتعليق';
	@override String get s13_title => 'القانون الواجب التطبيق والاختصاص القضائي';
	@override String get s14_title => 'التعديلات';
	@override String get quick_nav_title => 'التنقل السريع';
	@override String get quick_nav_item1 => 'طبيعة المنصة';
	@override String get quick_nav_item2 => 'تسجيل الحساب';
	@override String get quick_nav_item3 => 'الحساب المعلق والمدفوعات';
	@override String get quick_nav_item4 => 'التزامات الموردين وإجراءات "اعرف عميلك"';
	@override String get quick_nav_item5 => 'التزامات المشتري';
	@override String get quick_nav_item6 => 'المحتوى والأنشطة المحظورة';
	@override String get quick_nav_item7 => 'الملكية الفكرية';
	@override String get quick_nav_item8 => 'تسوية المنازعات';
	@override String get quick_nav_item9 => 'عمليات رد المبالغ المدفوعة';
	@override String get quick_nav_item10 => 'رسوم وعمولات المنصة';
	@override String get quick_nav_item11 => 'حدود المسؤولية';
	@override String get quick_nav_item12 => 'الإنهاء والتعليق';
	@override String get quick_nav_item13 => 'القانون الواجب التطبيق';
	@override String get quick_nav_item14 => 'التعديلات';
	@override String get s1_body1 => 'تعمل "واسلق" كوسيط إلكتروني وتقني ومالي مستقل يربط بين البائعين المستقلين والمشترين حصريًّا داخل السوق الفلسطينية. وتسهل المنصة إجراء المعاملات من خلال نظام ضمان آمن، كما توفر ميزات التجارة الاجتماعية، بما في ذلك المجموعات والمشاركات ومراجعات المنتجات والمراسلة المباشرة.';
	@override String get s1_body2 => 'لا تعتبر المنصة طرفًا مباشرًا في عقود البيع المبرمة بين المشترين والبائعين. ولا توجد أي علاقة وكالة أو شراكة أو توظيف أو امتياز أو مشروع مشترك بين «واسلق» وأي مستخدم. والبائعون هم بائعون مستقلون ويتحملون وحدهم المسؤولية عن منتجاتهم وإعلاناتهم والتزاماتهم المتعلقة بتنفيذ الطلبات.';
	@override String get s1_body3 => 'تحتفظ Waslaq بالحق في تعديل أو تعليق أو إيقاف أي ميزة أو قسم أو المنصة بأكملها بشكل دائم في أي وقت، سواء بإشعار مسبق أو بدونه، ولن تتحمل أي مسؤولية تجاه أي مستخدم أو طرف ثالث عن أي تعديل أو تعليق أو إيقاف من هذا القبيل.';
	@override String get s2_intro => 'للاستفادة من جميع ميزات المنصة، يجب عليك إنشاء حساب. وبتسجيلك، فإنك تقر وتضمن ما يلي:';
	@override String get s2_item1 => 'يجب أن يكون عمرك 18 عامًا على الأقل أو أن تكون قد بلغت سن الرشد القانوني في ولايتك القضائية.';
	@override String get s2_item2 => 'جميع المعلومات المقدمة أثناء التسجيل دقيقة وحديثة وكاملة.';
	@override String get s2_item3 => 'يجب عليك الحفاظ على دقة معلومات حسابك وتحديثها فور حدوث أي تغيير فيها.';
	@override String get s2_item4 => 'لا يجوز لك إنشاء حسابات متعددة للتحايل على القيود أو الإيقافات أو الحظر.';
	@override String get s2_item5 => 'أنت وحدك المسؤول عن جميع الأنشطة التي تتم من خلال حسابك وعن الحفاظ على سرية بيانات تسجيل الدخول الخاصة بك.';
	@override String get s2_body => 'تحتفظ Waslaq بالحق في رفض التسجيل، أو التحقق من الهوية، أو تعليق الوصول، أو حظر أي حساب بشكل دائم وفقًا لتقديرها الخاص، بما في ذلك على سبيل المثال لا الحصر، في حالات انتهاك هذه الاتفاقية، أو الاشتباه في حدوث احتيال، أو الإضرار بسمعة المنصة.';
	@override String get s3_2_item1 => 'المنتجات المادية: 48 ساعة من تاريخ تأكيد التسليم أو قيام البائع بوضع علامة "تم الشحن" على الطلب.';
	@override String get s3_2_item2 => 'المنتجات الرقمية: 24 ساعة من تاريخ تأكيد تسليم المفتاح الرقمي أو الملف أو بيانات تسجيل الدخول.';
	@override String get s3_3_item1 => 'تمديد فترة الاحتجاز إلى ما بعد "فترة الفحص" القياسية في حالات الاشتباه في حدوث احتيال أو في حالة وجود نزاعات لم يتم حلها.';
	@override String get s3_3_item2 => 'تجميد الأموال إلى أجل غير مسمى ريثما يتم الانتهاء من التحقيق في المخالفات المبلغ عنها أو الشكاوى المتعددة أو التحقيق التنظيمي.';
	@override String get s3_3_item3 => 'إعادة الأموال المحتجزة إلى المشترين أو تحويلها إليهم في حالة تسوية النزاع أو تأكيد مخالفة البائع.';
	@override String get s3_3_item4 => 'تعليق المدفوعات المعلقة للموردين الذين تخضع حساباتهم للتحقيق أو التعليق.';
	@override String get s4_1_item1 => 'بطاقة هوية صادرة عن الحكومة ومزودة بصورة (بطاقة الهوية الوطنية أو جواز السفر).';
	@override String get s4_1_item2 => 'إثبات ملكية الحساب المصرفي (كشف حساب أو خطاب تأكيد رقم IBAN).';
	@override String get s4_1_item3 => 'وثائق تسجيل الشركة، إن وجدت.';
	@override String get s4_3_item1 => 'هذا المنتج هو نسخة مقلدة / غير أصلية / مقلدة — ولا يرتبط بالعلامة التجارية الأصلية ولا يحظى بتأييدها.';
	@override String get s4_3_item2 => 'استخدام مصطلحات مثل "نسخة" أو "مزيفة" أو "مقلدة" أو "مستنسخة" أو "ليست أصلية" بشكل واضح في العنوان نفسه.';
	@override String get s5_item1 => 'يرجى تقديم عناوين الشحن ومعلومات الاتصال الصحيحة عند إتمام عملية الدفع. لا تتحمل "واسلق" والموردون أي مسؤولية عن أي إخفاق في التسليم ناجم عن تقديم عناوين غير صحيحة من قِبل المشتري.';
	@override String get s5_item2 => 'يرجى مراجعة الطلبات خلال فترة المراجعة وفتح نزاع فوراً في حال اكتشاف أي مشاكل. ويُعتبر عدم فتح نزاع قبل انتهاء فترة المراجعة بمثابة قبول قانوني للطلب.';
	@override String get s5_item3 => 'لا تقدم أدلة مزورة أو مزيفة في النزاعات. فذلك يشكل احتيالاً وسيؤدي إلى إغلاق الحساب نهائياً واتخاذ إجراءات قانونية محتملة.';
	@override String get s5_item4 => 'لا يجوز الشروع في إجراءات استرداد المبالغ من البنك دون استنفاد إجراءات تسوية المنازعات الداخلية الخاصة بالمنصة أولاً.';
	@override String get s5_item5 => 'يرجى الالتزام بجميع القوانين الفلسطينية السارية عند شراء المنتجات عبر المنصة.';
	@override String get s6_1_item1 => 'عرض منتجات مقلدة أو مستنسخة أو غير أصلية دون الإفصاح عن ذلك بوضوح وصراحة في عنوان المنتج ووصفه.';
	@override String get s6_1_item2 => 'عرض أو بيع أو تيسير منتجات أو خدمات تنتهك القانون الفلسطيني المعمول به، أو المبادئ المالية الإسلامية حيثما كان ذلك مطلوبًا، أو العقوبات الدولية.';
	@override String get s6_1_item3 => 'أي مخطط يهدف إلى التحايل على نظام الحساب المعلق، بما في ذلك محاولة إتمام المعاملات خارج المنصة.';
	@override String get s6_1_item4 => 'استخدام المنصة في غسل الأموال أو تمويل الإرهاب أو أي نشاط ينتهك لوائح مكافحة غسل الأموال (AML).';
	@override String get s6_2_item1 => 'نشر أو تحميل أو مشاركة أو وضع روابط لأي محتوى جنسي صريح أو إباحي أو مخصص للبالغين فقط بأي شكل من الأشكال — بما في ذلك الصور أو مقاطع الفيديو أو النصوص أو الروابط أو قوائم المنتجات — تحت أي ظرف من الظروف ودون استثناء.';
	@override String get s6_2_item2 => 'نشر أي محتوى يُجسد القاصرين في صورة جنسية أو يستغلهم أو يعرضهم للخطر بأي شكل من الأشكال. ويُعد هذا جريمة جنائية وسيتم الإبلاغ عنه على الفور إلى السلطات الفلسطينية المختصة والمنظمات الدولية المعنية بحماية الطفل.';
	@override String get s6_2_item3 => 'مشاركة صور عارية أو شبه عارية أو ذات إيحاءات جنسية في أي قسم من أقسام المنصة، بما في ذلك المنشورات والمجموعات وصور المنتجات ولافتات المتاجر وصور الملف الشخصي أو الرسائل المباشرة.';
	@override String get s6_2_item4 => 'عرض أو بيع أي منتجات أو خدمات أو مواد للبالغين، بغض النظر عن وضعها القانوني في الولاية القضائية للمستخدم.';
	@override String get s6_2_item5 => 'محاولة التحايل على آليات مراقبة المحتوى باستخدام لغة مشفرة أو رموز تعبيرية أو روابط لمواقع خارجية أو إشارات غير مباشرة بهدف توجيه المستخدمين إلى محتوى محظور.';
	@override String get s6_3_item1 => 'التحرش أو التنمر أو التهديد أو التخويف أو الإساءة الموجهة إلى أي مستخدم أو بائع أو عضو في المجتمع أو موظف في المنصة في أي قسم من أقسام المنصة.';
	@override String get s6_3_item2 => 'خطاب الكراهية، أو التمييز، أو المحتوى الذي يحط من قدر الأفراد أو الجماعات على أساس الدين، أو العرق، أو الجنسية، أو الجنس، أو الانتماء السياسي، أو أي سمة أخرى محمية.';
	@override String get s6_3_item3 => 'نشر مشاهد عنف صادمة، أو مشاهد دموية، أو صور مزعجة، أو محتوى يهدف إلى إثارة صدمة أو إزعاج المستخدمين الآخرين.';
	@override String get s6_3_item4 => 'نشر معلومات خاطئة متعمدة أو معلومات مضللة أو محتوى ملفق بهدف خداع المستخدمين الآخرين أو الإضرار بسمعتهم.';
	@override String get s6_3_item5 => 'إغراق المجتمعات أو موجزات المنشورات أو الرسائل المباشرة بمحتوى ترويجي غير مرغوب فيه، أو منشورات متكررة، أو أنشطة الروبوتات الآلية.';
	@override String get s6_3_item6 => '"الدوكسينغ" — نشر معلومات شخصية خاصة عن أي فرد (الاسم، العنوان، رقم الهاتف، التفاصيل المالية) دون موافقته الصريحة.';
	@override String get s6_3_item7 => 'انتحال صفة مستخدم آخر أو بائع أو مشرف مجتمع أو أحد موظفي Waslaq في أي سياق على المنصة.';
	@override String get s6_4_item1 => 'الجمع غير المصرح به للبيانات الشخصية للمستخدمين الآخرين أو محتوى المنصة، أو استخراجها، أو استخدامها لأغراض تجارية.';
	@override String get s6_4_item2 => 'تحميل برامج ضارة، أو شن هجمات لإعاقة الخدمة، أو محاولة اختراق أنظمة أمان المنصة.';
	@override String get s6_4_item3 => 'إنشاء حسابات متعددة للتحايل على الحظر أو التعليق أو تقييد الحساب.';
	@override String get s6_4_item4 => 'التلاعب بتعليقات المنتجات أو تصويتات المجتمع أو التقييمات من خلال حسابات مزيفة أو تعليقات مدفوعة الأجر أو سلوك غير حقيقي يتم تنسيقه.';
	@override String get s6_5_item1 => 'إزالة منشورات أو إعلانات أو صور أو تعليقات محددة.';
	@override String get s6_5_item2 => 'التعليق المؤقت لحق النشر في مجتمعات معينة أو على مستوى المنصة بأكملها.';
	@override String get s6_5_item3 => 'الحظر الدائم من جميع ميزات المنصة، بما في ذلك الشراء والبيع والمشاركة الاجتماعية.';
	@override String get s6_5_item4 => 'مصادرة الأرصدة المعلقة في حالات الاحتيال أو الانتهاكات الجسيمة.';
	@override String get s6_5_item5 => 'الإحالة إلى أجهزة إنفاذ القانون الفلسطينية أو السلطات المختصة في حالة ارتكاب مخالفات جنائية.';
	@override String get s9_item1 => 'تقديم شكوى عبر نظام تسوية المنازعات الخاص بالمنصة.';
	@override String get s9_item2 => 'منح شركة «واسلق» مهلة معقولة لا تقل عن 7 أيام عمل للتحقيق في الأمر والرد عليه.';
	@override String get s9_item3 => 'استرداد كامل مبلغ المعاملة المتنازع عليها من حساب المستخدم أو من أي أموال محتجزة.';
	@override String get s9_item4 => 'تحميل جميع الرسوم المصرفية وتكاليف المعالجة والمصروفات الإدارية ذات الصلة على عاتق المستخدم المخالف.';
	@override String get s9_item5 => 'حظر المستخدم بشكل دائم من المنصة.';
	@override String get s9_item6 => 'اتخاذ إجراءات قانونية مدنية لاسترداد جميع الخسائر والتكاليف والأضرار، بما في ذلك أتعاب المحاماة.';
	@override String get s11_item1 => 'أي أضرار غير مباشرة أو عرضية أو خاصة أو تبعية أو تعويضية أو عقابية.';
	@override String get s11_item2 => 'خسارة الأرباح أو الإيرادات أو البيانات أو الفرص التجارية أو السمعة التجارية.';
	@override String get s11_item3 => 'الأضرار الناجمة عن سلوك البائعين أو المشترين أو منتجاتهم أو خدماتهم.';
	@override String get s11_item4 => 'انقطاعات الخدمة الناجمة عن ظروف خارجة عن سيطرة «واسلق» المعقولة، بما في ذلك انقطاع خدمة الإنترنت، أو أعطال خدمات الجهات الخارجية، أو الكوارث الطبيعية، أو الاضطرابات المدنية، أو حالات القوة القاهرة.';
	@override String get s11_item5 => 'الوصول غير المصرح به إلى بياناتك أو تغييرها نتيجة لأفعال أطراف ثالثة خارجة عن سيطرتنا المعقولة.';
	@override String get s14_item1 => 'سيتم تحديث تاريخ "آخر تحديث" في أعلى هذه الصفحة.';
	@override String get s14_item2 => 'سيتم إخطار المستخدمين المسجلين عبر البريد الإلكتروني قبل 14 يومًا على الأقل من دخول التغييرات حيز التنفيذ.';
	@override String get s14_item3 => 'سيتم عرض إشعار بارز على المنصة.';
	@override String get s3_1_title => '3.1 معالجة المدفوعات';
	@override String get s3_1_body => 'تتم معالجة جميع المعاملات على منصة "Waslaq" حصريًّا عبر بوابات الدفع المعتمدة، بما في ذلك بنك فلسطين ومزودي خدمات الدفع المرخصين الآخرين. وتُحدد جميع المبالغ بالشيكل الإسرائيلي الجديد (ILS). وبإجراء طلب الشراء، فإنك تفوض المنصة بتحصيل المبلغ الكامل للطلب، بما في ذلك أي رسوم منصة سارية، من وسيلة الدفع التي اخترتها.';
	@override String get s3_2_title => '3.2 الحجز في حساب الضمان';
	@override String get s3_2_body => 'بعد إتمام الدفع بنجاح، تحتفظ المنصة بمبلغ الطلب بالكامل في حساب ضمان. ولا يتم تحويل الأموال إلى البائع إلا بعد انقضاء فترة الفحص الإلزامية دون رفع أي نزاع. وتكون فترة الفحص كما يلي:';
	@override String get s3_3_title => '3.3 حقوق البائع في الأموال';
	@override String get s3_3_intro => 'لا يكتسب البائعون أي حق قانوني مكتسب في الأموال المحتجزة حتى تنتهي فترة المراجعة دون حدوث أي نزاع. وتحتفظ شركة «واسلاق» بسلطة تقديرية مطلقة وأحادية الجانب تسمح لها بما يلي:';
	@override String get s3_4_title => '3.4 العملة والأسعار';
	@override String get s3_4_body => 'جميع الأسعار والرسوم والمبالغ المدفوعة على المنصة مقومة بالشيكل الإسرائيلي الجديد (ILS). ولا تضمن «واسلق» أسعار الصرف، كما أنها غير مسؤولة عن خسائر تحويل العملات التي يتكبدها المستخدمون الذين يجرون معاملاتهم من خارج فلسطين.';
	@override String get s4_1_title => '4.1 التسجيل والتحقق';
	@override String get s4_1_body => 'يجب على جميع البائعين إتمام عملية تسجيل البائعين في منصة "واسلق"، بما في ذلك تقديم معلومات دقيقة عن المتجر، وتحديد مناطق التوصيل، وتفاصيل حساب السحب. ويجب على البائعين إتمام عملية التحقق من الهوية (KYC) قبل التمكن من استخدام وظيفة السحب. وقد تتطلب عملية KYC تقديم ما يلي:';
	@override String get s4_1_kyc_failure => 'قد يؤدي عدم إتمام إجراءات "اعرف عميلك" (KYC) خلال فترة معقولة إلى تعليق الحساب وحجب الأموال المتراكمة إلى حين إتمام الإجراءات.';
	@override String get s4_2_title => '4.2 دقة بيانات المنتج';
	@override String get s4_2_body => 'يتحمل البائعون المسؤولية الكاملة والحصرية عن دقة واكتمال وقانونية وأصالة جميع قوائم المنتجات، بما في ذلك العناوين والأوصاف والصور والأسعار والمواصفات. ويجب أن تعكس قوائم المنتجات بدقة المنتج الفعلي الذي سيتسلمه المشتري.';
	@override String get s4_3_title => '4.3 المنتجات المقلدة وغير الأصلية';
	@override String get s4_3_body => 'لا يجوز للبائعين عرض منتجات مقلدة أو نسخ مقلدة أو غير أصلية إلا إذا قاموا بالإفصاح عن ذلك صراحةً وبشكل لا لبس فيه في كل من عنوان المنتج ووصفه، بطريقة لا تترك أي شك معقول في ذهن المشتري. وتشمل الصيغ المقبولة للإفصاح ما يلي:';
	@override String get s4_3_prohibited_title => 'ممنوع منعاً باتاً:';
	@override String get s4_3_prohibited_body => 'عرض أي منتج مقلد أو غير أصلي على أنه "أصلي" أو "أصلي" أو "أصيل" أو "جديد تمامًا" دون الإفصاح عن ذلك بوضوح. ويشكل هذا احتيالًا تجاريًا وانتهاكًا جوهريًا لهذه الاتفاقية، مما يمنح Waslaq الحق في إزالة جميع العروض على الفور، وتجميد رصيد البائع، وتقديم تعويضات كاملة للمشترين المتضررين، وإغلاق الحساب بشكل دائم، واللجوء إلى سبل الانتصاف القانونية المدنية والجنائية، بما في ذلك المطالبة بالتعويض عن الأضرار.';
	@override String get s4_4_title => '4.4 التنفيذ والتسليم';
	@override String get s4_4_body => 'يتحمل البائعون وحدهم مسؤولية تلبية الطلبات في غضون فترة زمنية معقولة ومحددة مسبقًا. بالنسبة للمنتجات المادية، يتحمل البائعون مسؤولية التغليف والشحن والتسليم إلى العنوان الذي يحدده المشتري. أما بالنسبة للمنتجات الرقمية، فيجب أن يتم التسليم تلقائيًا وفورًا بعد تأكيد الدفع. وقد يؤدي تكرار الإخفاق في تلبية الطلبات إلى تعليق الحساب.';
	@override String get s4_5_title => '4.5 التواصل مع المشترين';
	@override String get s4_5_body => 'يجب على البائعين الرد على استفسارات المشترين عبر نظام المراسلة الخاص بالمنصة في غضون فترة زمنية معقولة. ويجب على البائعين الامتناع عن التواصل مع المشترين عبر قنوات خارجية بهدف التحايل على أنظمة الضمان أو تسوية النزاعات الخاصة بالمنصة.';
	@override String get s6_intro => 'يُحظر تمامًا القيام بما يلي على منصة Waslaq. وقد تؤدي المخالفات إلى تعليق الحساب فورًا، والحظر الدائم، ومصادرة الأموال، و/أو اتخاذ إجراءات قانونية:';
	@override String get s6_1_title => '6.1 انتهاكات القواعد التجارية';
	@override String get s6_2_title => '6.2 المحتوى المخصص للبالغين والمحتوى غير الآمن للعمل — عدم التسامح مطلقًا';
	@override String get s6_2_zero_tolerance_title => '⚠️ سياسة عدم التسامح مطلقًا';
	@override String get s6_2_zero_tolerance_body => 'تُعد «واسلق» منصة تجارية صديقة للأسرة وموجهة نحو المجتمع، تخدم السوق الفلسطيني. وسيؤدي أي انتهاك لهذا البند إلى إنهاء الحساب فوراً وبشكل نهائي دون حق في الاستئناف، بغض النظر عن سجل المستخدم أو مكانته على المنصة.';
	@override String get s6_3_title => '6.3 الطبقة الاجتماعية ومعايير المجتمع';
	@override String get s6_3_intro => 'تخضع الميزات الاجتماعية في Waslaq — بما في ذلك المجموعات والمشاركات والتعليقات والرسائل المباشرة — لمعايير المجتمع التالية، بالإضافة إلى جميع المحظورات الأخرى الواردة في هذه الاتفاقية:';
	@override String get s6_4_title => '6.4 المخالفات الفنية والأمنية';
	@override String get s6_5_title => '6.5 الإنفاذ والإشراف';
	@override String get s6_5_body => 'تحتفظ Waslaq بالسلطة الكاملة والأحادية وغير القابلة للمراجعة في تحديد ما يشكل انتهاكًا لهذه المعايير واتخاذ الإجراءات المناسبة، سواء بإشعار مسبق أو بدونه. وتشمل إجراءات الإنفاذ، على سبيل المثال لا الحصر، ما يلي:';
	@override String get s6_5_report => 'يمكن للمستخدمين الإبلاغ عن المخالفات باستخدام نظام الإبلاغ المدمج في المنصة والمتاح في جميع المنشورات والملفات الشخصية والإعلانات. ويتم مراجعة جميع البلاغات من قِبل فريق الإشراف في Waslaq.';
	@override String get s7_1_title => '7.1 محتوى المنصة';
	@override String get s7_1_body => 'جميع محتويات المنصة، بما في ذلك اسم "Waslaq" وشعارها وتصميم واجهتها ورمزها المصدري ومحتواها المكتوب وميزاتها الحصرية، هي ملكية فكرية حصرية لشركة "Waslaq" وتخضع لحماية قوانين حقوق النشر والعلامات التجارية والملكية الفكرية المعمول بها. ولا يجوز لأي مستخدم إعادة إنتاج محتويات المنصة أو توزيعها أو استغلالها تجاريًا دون الحصول على موافقة خطية مسبقة.';
	@override String get s7_2_title => '7.2 ترخيص محتوى المستخدم';
	@override String get s7_2_body => 'من خلال نشر المحتوى على Waslaq (بما في ذلك قوائم المنتجات والصور والمنشورات والتعليقات ومحتوى المجتمع)، فإنك تمنح Waslaq ترخيصًا غير حصري وخاليًا من الرسوم وعالمي النطاق وقابل للترخيص من الباطن لاستخدام هذا المحتوى وعرضه وإعادة إنتاجه وتوزيعه لغرض تشغيل المنصة والترويج لها. وينتهي هذا الترخيص عند حذف المحتوى أو إغلاق حسابك، مع مراعاة متطلبات الاحتفاظ بالبيانات.';
	@override String get s7_3_title => '7.3 حقوق الملكية الفكرية لأطراف ثالثة';
	@override String get s7_3_body => 'يتحمل البائعون وحدهم المسؤولية الكاملة عن ضمان عدم انتهاك قوائم منتجاتهم وصورها وأوصافها والإشارات إلى العلامات التجارية لأي حقوق ملكية فكرية لأطراف ثالثة، بما في ذلك العلامات التجارية وحقوق النشر وبراءات الاختراع أو المظهر التجاري. ستستجيب "واسلق" لإشعارات انتهاك حقوق الملكية الفكرية الصحيحة وستقوم بإزالة المحتوى المخالف. وسيؤدي تكرار الانتهاك إلى إغلاق الحساب بشكل نهائي.';
	@override String get s8_1_title => '8.1 فتح نزاع';
	@override String get s8_1_body => 'يجب فتح النزاعات حصريًّا من خلال نظام النزاعات المدمج في المنصة، والذي يمكن الوصول إليه من صفحة تفاصيل الطلب تحت "الحساب" → "الطلبات". ويجب تقديم النزاعات قبل انتهاء "فترة الفحص" المعمول بها. وأي مطالبة يتم تقديمها بعد تحويل الأموال إلى البائع تُعتبر قانونياً بمثابة تنازل عنها ولن يتم النظر فيها.';
	@override String get s8_2_title => '8.2 الأدلة والإجراءات';
	@override String get s8_2_body => 'يقع عبء الإثبات على عاتق المشتري. ويجوز تقديم أدلة داعمة مثل الصور الفوتوغرافية ومقاطع الفيديو ولقطات الشاشة والأوصاف المكتوبة. ويجوز لـ«واسلق» أن تطلب وثائق إضافية من أي من الطرفين. وسيتم إخطار البائع ومنحه فرصة معقولة للرد خلال فترة النزاع.';
	@override String get s8_3_title => '8.3 قرار المنصة';
	@override String get s8_3_body => 'بعد مراجعة جميع الأدلة المقدمة، ستصدر «واسلق» قرارًا نهائيًا وملزمًا وغير قابل للاستئناف. وفي الحالات التي يثبت فيها خطأ البائع، يجوز لـ«واسلق» رد المبلغ إلى المشتري مباشرةً من الرصيد المتاح لدى البائع أو المودع في حساب الضمان، دون الحاجة إلى موافقة البائع. ويُعتبر قرار «واسلق» نهائيًا ويشكل تسوية كاملة ونهائية للنزاع.';
	@override String get s8_4_title => '8.4 إساءة استخدام نظام تسوية المنازعات';
	@override String get s8_4_body => 'يُعد تقديم أدلة مزورة أو ملفقة أو تم التلاعب بها في أي نزاع بمثابة احتيال. وتحتفظ "واسلاق" بالحق في إنهاء حساب المستخدم المخالف على الفور، ومصادرة أي أموال معلقة، واللجوء إلى سبل الانتصاف القانونية المدنية والجنائية.';
	@override String get s9_intro => 'باستخدامك لـ Waslaq، فإنك توافق صراحةً على عدم الشروع في إجراءات استرداد المبلغ من خلال البنك الذي تتعامل معه أو الجهة المصدرة لبطاقتك أو مزود خدمة الدفع دون القيام أولاً بما يلي:';
	@override String get s9_breach_intro => 'يُعد إجراء عملية استرداد غير مبررة أو سابقة لأوانها خرقًا جوهريًا لهذه الاتفاقية. وفي مثل هذه الحالات، تحتفظ Waslaq بالحق في:';
	@override String get s10_intro => 'تفرض "واسلق" الرسوم التالية، والتي تخضع للتغيير بعد إخطار مسبق مدته 30 يومًا:';
	@override String get table_fee_type => 'نوع الرسوم';
	@override String get table_amount => 'المبلغ';
	@override String get table_applied_to => 'يُطبق على';
	@override String get s10_note => 'جميع الرسوم غير قابلة للاسترداد ما لم تقرر المنصة خلاف ذلك وفقًا لتقديرها الخاص. تحتفظ Waslaq بالحق في فرض رسوم أو تعديلها أو إلغائها في أي وقت، شريطة إخطار المستخدمين المعنيين مسبقًا بفترة معقولة.';
	@override String get s11_body => 'تقدم "واسلق" خدماتها "كما هي" و"حسب توفرها" دون أي ضمانات من أي نوع، سواء كانت صريحة أو ضمنية، بما في ذلك على سبيل المثال لا الحصر الضمانات الضمنية المتعلقة بقابلية التسويق، أو الملاءمة لغرض معين، أو عدم الانتهاك، أو التوفر المستمر.';
	@override String get s11_liable_for => 'إلى أقصى حد يسمح به القانون المعمول به، لا تتحمل شركة «واسلق» أي مسؤولية عن:';
	@override String get s11_cap_title => 'الحد الأقصى للمسؤولية:';
	@override String get s11_cap_body => 'في جميع الأحوال، لا يجوز أن يتجاوز إجمالي الالتزام المالي الأقصى لشركة «واسلق» تجاه أي مستخدم فيما يتعلق بأي معاملة أو مطالبة فردية القيمة الإجمالية لتلك المعاملة المحددة كما هي مسجلة على المنصة.';
	@override String get s12_1_title => '12.1 بواسطة Waslaq';
	@override String get s12_1_body => 'تحتفظ Waslaq بالحق في تعليق أو إنهاء أي حساب بشكل دائم، سواء بإشعار مسبق أو بدونه، في حالة انتهاك هذه الاتفاقية، أو الاشتباه في حدوث احتيال، أو الإضرار بسمعة المنصة، أو لأي سبب آخر وفقًا لتقديرها الخاص. وعند الإنهاء، سيتم إلغاء حق الوصول إلى المنصة على الفور.';
	@override String get s12_2_title => '12.2 التأثير على الصناديق';
	@override String get s12_2_body => 'في حالة إنهاء الحساب لسبب وجيه (بما في ذلك الاحتيال أو الإخلال الجسيم بالشروط)، تحتفظ Waslaq بالحق في حجز أي رصيد معلّق كضمان للمطالبات أو عمليات رد المبالغ المدفوعة أو الإجراءات القانونية. وسيتم تحويل الأموال غير الخاضعة لأي مطالبة إلى حساب الدفع المسجل الخاص بالمورد في غضون 30 يومًا من تاريخ إغلاق الحساب، شريطة استكمال إجراءات "اعرف عميلك" (KYC) والتحقق من الهوية.';
	@override String get s12_3_title => '12.3 من جانب المستخدم';
	@override String get s12_3_body => 'يمكن للمستخدمين إغلاق حساباتهم في أي وقت من خلال إعدادات الحساب. وقبل الإغلاق، يجب تنفيذ أو تسوية جميع الطلبات المعلقة، كما يجب تسوية أي أموال متنازع عليها. وستحتفظ Waslaq بسجلات المعاملات وفقًا لما يقتضيه القانون المعمول به.';
	@override String get s13_body => 'تخضع هذه الاتفاقية لقوانين دولة فلسطين وتُفسَّر وتُنفَّذ وفقًا لها. ويخضع أي نزاع أو خلاف أو مطالبة تنشأ عن هذه الاتفاقية أو تتعلق بها، بما في ذلك إبرامها أو صلاحيتها أو خرقها أو إنهاؤها، للاختصاص القضائي الحصري للمحاكم الفلسطينية المختصة. ويخضع المستخدمون بشكل نهائي للاختصاص القضائي الشخصي لهذه المحاكم ويتنازلون عن أي اعتراض على الإجراءات أمامها بحجة المكان أو عدم ملاءمة المحكمة.';
	@override String get s14_intro => 'تحتفظ Waslaq بالحق في تعديل شروط الاستخدام هذه أو تحديثها أو استبدالها في أي وقت. وعند إجراء تغييرات جوهرية:';
	@override String get s14_acceptance => 'إن استمرار استخدام المنصة بعد تاريخ سريان أي تعديل يُعتبر موافقة كاملة وغير مشروطة من جانبك على الشروط المعدلة. إذا لم توافق على الشروط المعدلة، فيجب عليك التوقف عن استخدام المنصة ويحق لك طلب حذف حسابك.';
	@override String get footer_questions_title => 'هل لديك أسئلة حول هذه الشروط؟';
	@override String get footer_contact_text => 'اتصل بفريقنا القانوني على ... أو تفضل بزيارة موقعنا';
	@override String get table_fee_row1_type => 'رسوم منصة الطلبات المادية';
	@override String get table_fee_row1_amount => '2 شيكل ثابت لكل طلب';
	@override String get table_fee_row1_applied => 'يتم تضمينها في المبلغ الإجمالي كرسوم توصيل/خدمة';
	@override String get table_fee_row2_type => 'رسوم منصة المنتجات الرقمية';
	@override String get table_fee_row2_amount => 'شيكل واحد لكل قطعة';
	@override String get table_fee_row2_applied => 'يُخصم من المبلغ الإجمالي عند تقديم الطلب';
	@override String get table_fee_row3_type => 'عمولة الدفع للبائع';
	@override String get table_fee_row3_amount => '5% من مبلغ الدفع';
	@override String get table_fee_row3_applied => 'يُخصم عند تنفيذ عملية الدفع';
	@override String get table_fee_row4_type => 'رسوم التحويل المصرفي';
	@override String get table_fee_row4_amount => '8 شواقل ثابتة لكل عملية تحويل';
	@override String get table_fee_row4_applied => 'تم استيعابها من قبل المنصة — لم يتم تحميلها على المورد';
}

// Path: refund
class StringsRefundAr extends StringsRefundEn {
	StringsRefundAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get page_title => 'سياسة الاسترداد والإرجاع';
	@override String get last_updated => 'تاريخ السريان: 1 مايو 2026 · آخر تحديث: 1 مايو 2026';
	@override String get intro => 'تلتزم "واسلق" بتوفير تجربة تسوق عادلة وشفافة وآمنة. تحدد سياسة الاسترداد والإرجاع هذه الشروط التي يحق للمشترين بموجبها استرداد أموالهم، وإجراءات تسوية النزاعات، والتزامات البائعين فيما يتعلق بالإرجاع، والحقوق والقيود السارية على جميع الأطراف.';
	@override String get s1_title => 'نافذة الفحص';
	@override String get s2_title => 'شروط استحقاق استرداد المبلغ';
	@override String get s3_title => 'الحالات غير المؤهلة';
	@override String get s4_title => 'كيفية فتح نزاع';
	@override String get s5_title => 'عبء الإثبات';
	@override String get s6_title => 'معالجة عمليات استرداد الأموال';
	@override String get s7_title => 'سياسات إرجاع البائعين';
	@override String get s8_title => 'المنتجات الرقمية — أحكام خاصة';
	@override String get s9_title => 'التزامات البائع فيما يتعلق برد الأموال';
	@override String get s10_title => 'الاتصال والدعم';
	@override String get buyer_protection_title => 'حماية المشتري من Waslaq';
	@override String get buyer_protection_desc => 'يتم حماية كل طلب يتم تقديمه على منصة "واسلق" من خلال نظام الضمان الخاص بنا. حيث تحتفظ المنصة بأموالك في حساب آمن، ولا يتم تحويلها إلى البائع إلا بعد انتهاء فترة الفحص الإلزامية — مما يمنحك الوقت الكافي للتأكد من وصول طلبك بشكل صحيح ومطابق للوصف. ولا يُطلب منك أبدًا قبول أي طلب معيب أو غير صحيح أو مزيف.';
	@override String get s1_body1 => 'تُعد «فترة المراجعة» فترة تعليق إلزامية تبدأ عند تسليم الطلب أو تأكيد الشحن من البائع. خلال هذه الفترة، تظل الأموال مودعة في حساب الضمان ولا يتم تحويلها إلى البائع. يجب عليك فتح أي نزاع قبل انتهاء هذه الفترة.';
	@override String get physical_products_label => 'المنتجات المادية';
	@override String get physical_products_body => '48 ساعة من لحظة قيام البائع بوضع علامة "تم الشحن" على الطلب أو تأكيد التسليم.';
	@override String get digital_products_label => 'المنتجات الرقمية';
	@override String get digital_products_body => '24 ساعة من وقت تسليم المفتاح الرقمي أو الملف أو بيانات اعتماد الوصول إلى المشتري.';
	@override String get s1_important => 'بمجرد انتهاء فترة المراجعة وتحويل الأموال إلى البائع، تعتبر المعاملة نهائية ومُسوَّاة من الناحية القانونية. ولن يتم قبول أي مطالبات باسترداد الأموال بعد هذه المرحلة تحت أي ظرف من الظروف، باستثناء حالات الاحتيال المؤكدة وفقًا لتقدير المنصة وحدها.';
	@override String get s2_intro => 'تغطي خدمة حماية المشتري من Waslaq الحالات التالية. وفي كل حالة، يجب فتح نزاع قبل انتهاء فترة الفحص، ويجب أن يتضمن أدلة داعمة:';
	@override String get s2_item1_title => 'لم يتم استلام المنتج';
	@override String get s2_item1_body => 'لم يقم البائع بشحن الطلب في غضون فترة زمنية معقولة، ولم يقدم أي تحديث صالح لتتبع الشحنة أو تأكيدًا بالتسليم. ولم يستلم المشتري السلعة، ولا يوجد أي دليل على محاولة التسليم.';
	@override String get s2_item2_title => 'يختلف بشكل كبير عما هو موصوف';
	@override String get s2_item2_body => 'يختلف المنتج المستلم اختلافًا جوهريًا وجوهريًا عما ورد في الإعلان — على سبيل المثال، منتج خاطئ تمامًا، أو لون أو مقاس خاطئ لم يتم الإفصاح عنه، أو مكونات مفقودة كانت جزءًا من المنتج المُعلن عنه، أو حالة (مثل: مستعمل مقابل جديد) تتعارض مع ما ورد في الإعلان.';
	@override String get s2_item3_title => 'وصلت السلعة تالفة';
	@override String get s2_item3_body => 'وصل المنتج في حالة تجعله غير صالح للاستخدام أو مكسورًا أو غير قابل للاستخدام فعليًّا، حيث وقع التلف قبل استلامه من قِبل المشتري. يجب على المشتري تقديم دليل مصور أو مسجل بالفيديو يثبت التلف الذي حدث عند فتح العبوة أو عند الاستخدام الأول.';
	@override String get s2_item4_title => 'منتج مقلد دون الإفصاح عن ذلك';
	@override String get s2_item4_body => 'تم عرض منتج وبيعه على أنه أصلي أو حقيقي أو يحمل علامة تجارية معروفة، لكن المنتج الذي تم استلامه مزيف بشكل واضح أو غير أصلي دون الإفصاح عن ذلك مسبقًا في الإعلان. ملاحظة: إذا كان الإعلان قد أشار إلى أن المنتج نسخة مقلدة أو غير أصلي، فلا ينطبق هذا الشرط.';
	@override String get s2_item5_title => 'منتج رقمي غير وظيفي';
	@override String get s2_item5_body => 'المفتاح الرقمي أو رمز التفعيل أو الملف القابل للتنزيل غير صالح أو منتهي الصلاحية أو تم استخدامه بالفعل من قبل مستخدم سابق أو تالف أو غير صالح للاستخدام لأي سبب آخر وقت التسليم. يجب على المشتري تقديم دليل على الخلل (مثل لقطة شاشة لرسالة الخطأ الصادرة عن المنصة أو الناشر).';
	@override String get s2_item6_title => 'تكرار الرسوم';
	@override String get s2_item6_body => 'تم تحصيل المبلغ من المشتري أكثر من مرة عن نفس الطلب بسبب خطأ في معالجة الدفع. ويجب أن تتضمن الأدلة سجلات تأكيد الدفع.';
	@override String get s3_intro => 'لا تشمل خدمة «حماية المشتري من واسلق» الحالات التالية بشكل صريح:';
	@override String get s3_item1_title => 'تغيير الرأي';
	@override String get s3_item1_body => 'تلقى المشتري المنتج الصحيح الذي لم يتعرض لأي تلف والذي تمت وصفه بدقة، ولكنه ببساطة لم يعد يرغب فيه. في هذه الحالة، تُطبق سياسة الإرجاع الخاصة بالبائع حصريًّا. ولا تتدخل Waslaq في عمليات الإرجاع الناجمة عن تغيير الرأي.';
	@override String get s3_item2_title => 'فترة تقديم المطالبات بعد الفحص';
	@override String get s3_item2_body => 'أي نزاع أو طلب استرداد يُقدم بعد انتهاء فترة الفحص وتسديد المبلغ إلى البائع. تُعتبر هذه المطالبات قد تم التنازل عنها قانونًا ولن يتم النظر فيها.';
	@override String get s3_item3_title => 'الأضرار التي يتسبب فيها المشتري';
	@override String get s3_item3_body => 'السلع التي كانت في حالة جيدة عند التسليم، لكنها تعرضت للتلف لاحقًا بسبب سوء الاستخدام أو التعامل غير السليم أو التعديل أو التلف العرضي من جانب المشتري.';
	@override String get s3_item4_title => 'المنتجات المعلن عنها على أنها غير أصلية أو مقلدة';
	@override String get s3_item4_body => 'المنتجات التي تم وصفها بوضوح وصراحة في عنوان الإعلان ووصفه على أنها مزيفة أو نسخة طبق الأصل أو مقلدة أو غير أصلية. وبشراء هذه المنتجات، يكون المشتري قد وافق عن علم على طبيعة المنتج.';
	@override String get s3_item5_title => 'المنتجات الرقمية التي تم استرداد قيمتها';
	@override String get s3_item5_body => 'المفاتيح الرقمية أو الرموز أو القسائم التي تم استرداد قيمتها أو تفعيلها أو استخدامها بالفعل من قِبل المشتري أو أي طرف شاركه المشتري الرمز، بغض النظر عما إذا كان المنتج قد حقق التوقعات بعد ذلك أم لا.';
	@override String get s3_item6_title => 'مشاكل عدم التوافق المعروفة وقت الشراء';
	@override String get s3_item6_body => 'المنتجات التي تعمل بالشكل الموصوف، ولكنها غير متوافقة مع الجهاز أو المنطقة أو الحساب أو المنصة الخاصة بالمشتري، شريطة أن تكون متطلبات التوافق هذه قد تم الإفصاح عنها أو كان من الممكن اكتشافها بشكل معقول في وصف المنتج.';
	@override String get s3_item7_title => 'اختلافات طفيفة في المظهر';
	@override String get s3_item7_body => 'اختلافات طفيفة في اللون، أو اختلافات في التغليف، أو عيوب شكلية بسيطة لا تؤثر بشكل جوهري على وظيفة المنتج أو قابليته للاستخدام، وتقع ضمن حدود التفاوت الطبيعية للمنتج.';
	@override String get s4_intro => 'لطلب استرداد المبلغ أو الإبلاغ عن مشكلة تتعلق بطلبك، اتبع الخطوات التالية:';
	@override String get s4_step1 => 'انتقل إلى "الحساب" → "الطلبات" وابحث عن الطلب المطلوب باستخدام رقم الطلب أو التاريخ.';
	@override String get s4_step2 => 'انقر على "فتح نزاع" في صفحة تفاصيل الطلب. هذا الخيار متاح فقط خلال فترة الفحص السارية.';
	@override String get s4_step3 => 'اختر سبب النزاع الأكثر دقة من بين الفئات المتاحة.';
	@override String get s4_step4 => 'يرجى تقديم وصف مكتوب مفصل للمشكلة، بما في ذلك التواريخ ذات الصلة، وما استلمته، وكيف يختلف عما كان مذكورًا.';
	@override String get s4_step5 => 'قم بتحميل الأدلة الداعمة: الصور الفوتوغرافية، ومقاطع الفيديو، ولقطات الشاشة، والإيصالات، أو أي وثائق تدعم مطالبتك. فكلما كانت أدلتك أقوى، زادت سرعة حل المشكلة.';
	@override String get s4_step6 => 'أرسل النزاع. ستتلقى إشعارًا بالتأكيد. سيتم إخطار البائع ومنحه مهلة للرد.';
	@override String get s4_step7 => 'تابع حالة النزاع من حسابك. قد تتصل بك "واسلق" لطلب معلومات إضافية. يرجى الرد بسرعة لتجنب أي تأخير.';
	@override String get s4_step8 => 'ستقوم "واسلق" بمراجعة جميع الأدلة وإصدار قرار نهائي ملزم. سيتم إخطارك بالنتيجة عبر البريد الإلكتروني وإشعار داخل التطبيق.';
	@override String get s4_tip => 'نصيحة: للحصول على حل أسرع، قم بفتح شكواك في أقرب وقت ممكن خلال فترة الفحص، وقدم أدلة شاملة في شكل صور أو مقاطع فيديو فور اكتشاف المشكلة.';
	@override String get s5_body => 'يقع عبء الإثبات على عاتق المشتري. ولا تقبل "واسلاق" إصدار حكم لصالح المشتري إلا بعد تقديم أدلة قاطعة. وتشمل الأدلة المقبولة ما يلي:';
	@override String get s5_item1 => 'صور فوتوغرافية أو مقاطع فيديو واضحة للسلعة المستلمة تُظهر بوضوح العيب أو التلف أو التباين.';
	@override String get s5_item2 => 'مقارنة جنبًا إلى جنب بين الصور والوصف الوارد في الإعلان والمنتج المستلم.';
	@override String get s5_item3 => 'لقطات شاشة لرسائل الخطأ الخاصة بالمنتجات الرقمية المعطلة، بما في ذلك ردود المنصة أو الناشر على هذه الأخطاء.';
	@override String get s5_item4 => 'صور التغليف التي توضح حالة المنتج عند وصوله (مفيدة في حالات المطالبة بالتعويض عن الأضرار).';
	@override String get s5_item5 => 'التواصل الكتابي مع البائع عبر نظام المراسلة الخاص بالمنصة.';
	@override String get s5_warning => 'تحذير بشأن الاحتيال: يُعد تقديم أدلة مزورة أو ملفقة أو مزيفة أو تم التلاعب بها في أي نزاع بمثابة احتيال وانتهاك خطير لشروط استخدام «واسلق». وسيتم إغلاق حسابات المخالفين فوراً وبشكل نهائي، ومصادرة جميع الأرصدة المعلقة، وقد يتم الإبلاغ عنهم إلى السلطات الفلسطينية المختصة لاتخاذ الإجراءات القانونية اللازمة.';
	@override String get s6_1_title => 'عندما يُحسم النزاع لصالح المشتري';
	@override String get s6_1_item1 => 'الأموال التي لا تزال مودعة في حساب الضمان: يتم إلغاء عملية دفع الأموال المودعة في حساب الضمان على الفور وإعادتها إلى وسيلة الدفع الأصلية للمشتري. ولا يتعين على البائع اتخاذ أي إجراء.';
	@override String get s6_1_item2 => 'الأموال التي تم تحويلها بالفعل إلى المورد: يتم خصم مبلغ الاسترداد مباشرةً من الرصيد المتاح للمورد. وإذا كان رصيد المورد غير كافٍ، فستقوم المنصة باحتجاز الأرباح المستقبلية حتى يتم سداد الدين بالكامل.';
	@override String get s6_1_item3 => 'استرداد كامل المبلغ: يتم إعادة المبلغ الكامل للطلب إلى المشتري، بما في ذلك أي رسوم خدمة للمنصة، إن وجدت.';
	@override String get s6_1_item4 => 'استرداد جزئي (حل جزئي): في الحالات التي يثبت فيها وجود خطأ جزئي من كلا الطرفين، يجوز لشركة «واسلق» إصدار استرداد جزئي وفقًا لتقديرها الخاص والنهائي.';
	@override String get s6_2_title => 'الجدول الزمني لاسترداد الأموال';
	@override String get s6_2_body => 'تختلف مدة معالجة عمليات استرداد الأموال باختلاف مزود خدمة الدفع الذي تستخدمه:';
	@override String get s6_2_item1 => 'بنك فلسطين والبوابات المحلية: من 3 إلى 7 أيام عمل من تاريخ اتخاذ القرار.';
	@override String get s6_2_item2 => 'طرق الدفع الأخرى: قد يستغرق الأمر ما يصل إلى 14 يوم عمل، حسب المزود.';
	@override String get s6_2_note => 'لا تتحمل "واسلق" المسؤولية عن أي تأخير ناجم عن المدة التي يستغرقها البنك الذي تتعامل معه أو مزود خدمة الدفع في معالجة المعاملة.';
	@override String get s7_body1 => 'بالإضافة إلى الحماية التي توفرها منصة Waslaq، يجوز للبائعين نشر سياساتهم الخاصة بالإرجاع والاستبدال وخدمات ما بعد البيع على صفحة متجرهم العامة. وتسري هذه السياسات الخاصة بالبائعين حصريًّا على الحالات التي لا تشملها "حماية المشتري من Waslaq" — وأكثرها شيوعًا هي حالات الإرجاع بسبب تغيير الرأي في الطلبات التي تم تنفيذها بشكل صحيح.';
	@override String get s7_body2 => 'لا تفرض "واسلق" سياسات الإرجاع الخاصة بالبائعين ولا تضمنها. وعلى المشترين الراغبين في إرجاع المنتجات أو استبدالها بموجب سياسة البائع الخاصة بالتنسيق مباشرةً مع البائع عبر نظام المراسلة الخاص بالمنصة.';
	@override String get s7_tip => 'قبل الشراء، نوصي بالاطلاع على سياسة الإرجاع التي ينشرها البائع على صفحة متجره، لا سيما بالنسبة للسلع عالية القيمة أو المنتجات التي تعتمد على التفضيل الشخصي.';
	@override String get s8_body => 'تخضع المنتجات الرقمية، بما في ذلك مفاتيح الألعاب وتراخيص البرامج والقسائم والملفات القابلة للتنزيل ورموز التنشيط، للأحكام الإضافية التالية:';
	@override String get s8_item1 => 'التسليم الفوري: يتم تسليم المنتجات الرقمية تلقائيًا فور تأكيد الدفع. ويُعتبر التسليم قد اكتمل عندما يصبح الرمز أو الملف متاحًا في حساب المشتري أو يتم إرساله عبر البريد الإلكتروني.';
	@override String get s8_item2 => 'فترة فحص مدتها 24 ساعة: يتاح للمشترين 24 ساعة من تاريخ الاستلام لاختبار المنتج والإبلاغ عن أي مشاكل. بعد انقضاء هذه الفترة، تصبح عملية البيع نهائية.';
	@override String get s8_item3 => 'المفاتيح غير الصالحة: إذا كان المفتاح غير صالح أو تم استخدامه بالفعل عند التسليم، يجب على المشتري تقديم لقطة شاشة لرسالة الخطأ الصادرة عن الناشر. يتم رد قيمة المطالبات الصحيحة بالكامل.';
	@override String get s8_item4 => 'لا يُسمح باسترداد المبلغ بعد الاستخدام: بمجرد استرداد المفتاح الرقمي أو الرمز أو الترخيص، أو تفعيله، أو استخدامه — حتى لو كان ذلك جزئيًا — يُعتبر قد تم استهلاكه بالكامل، ولن يتم استرداد المبلغ بأي حال من الأحوال، بغض النظر عن مدى الرضا.';
	@override String get s8_item5 => 'مشاكل تقييد المنطقة: يتحمل المشتري مسؤولية التحقق من التوافق الإقليمي قبل الشراء. لا يُسمح برد الأموال في حالة المنتجات المقيدة إقليمياً إذا كان التقييد الإقليمي قد تم الإفصاح عنه أو كان من الممكن تحديده بشكل معقول من خلال وصف المنتج.';
	@override String get s9_role_title => 'توضيح دور المنصة';
	@override String get s9_role_body1 => 'تعمل "واسلق" حصريًّا كوسيط تقني ومالي — أي كطرف محايد بين المشترين والبائعين. ولا تتحمل المنصة أي مسؤولية عن التسليم المادي أو التغليف أو الشحن أو الخدمات اللوجستية لأي طلب. وتقع جميع التزامات التسليم بالكامل على عاتق البائع. ولا تقوم "واسلق" بتخزين البضائع المادية أو شحنها أو مناولتها أو فحصها في أي مرحلة من المراحل.';
	@override String get s9_role_body2 => 'بالإضافة إلى ذلك، بمجرد انتهاء فترة الفحص وإطلاق الأموال، لا تتحمل المنصة أي مسؤولية مالية عن أي طلبات استرداد أو إرجاع لاحقة. وتصبح هذه الطلبات مسألة تخص المشتري والبائع حصريًّا، وتخضع لسياسة الإرجاع التي ينشرها البائع. ولن تتدخل "واسلق" أو تتوسط أو تمول عمليات الإرجاع خارج فترة الفحص السارية تحت أي ظرف من الظروف.';
	@override String get s9_vendor_intro => 'يلتزم البائعون على منصة "واسلق" بالالتزامات التالية المتعلقة برد الأموال وإرجاع المنتجات:';
	@override String get s9_vendor_item1 => 'يجب على البائعين التأكد من أن جميع المنتجات المشحونة تتطابق تمامًا مع الوصف والحالة والمواصفات الواردة في الإعلان.';
	@override String get s9_vendor_item2 => 'يجب على البائعين الرد على إخطارات النزاع خلال المدة الزمنية التي تحددها المنصة. ويُعتبر عدم الرد اعترافًا ضمنيًا وقد يؤدي إلى رد المبلغ تلقائيًا إلى المشتري.';
	@override String get s9_vendor_item3 => 'يجب على البائعين الامتناع عن الاتصال بالمشترين خارج نظام المراسلة الخاص بالمنصة، وذلك بهدف ثنيهم عن رفع النزاعات أو عرض ترتيبات تعويض غير مصرح بها.';
	@override String get s9_vendor_item4 => 'في الحالات التي يتم فيها إصدار رد أموال من رصيد البائع، يوافق البائع بشكل نهائي على هذا الخصم كشرط للمشاركة في المنصة.';
	@override String get s9_vendor_item5 => 'قد تؤدي النزاعات المتكررة بشأن استرداد الأموال التي يتم الفصل فيها ضد البائع إلى مراجعة الحساب، أو إطالة فترات الاحتجاز في حساب الضمان، أو تعليق الحساب.';
	@override String get s10_intro => 'للاستفسار عن هذه السياسة، أو للحصول على المساعدة في رفع نزاع، أو للحصول على الدعم بشأن طلب معين:';
	@override String get s10_item1 => 'استخدم نظام النزاعات مباشرةً من صفحة طلبك: الحساب → الطلبات → [الطلب] → فتح نزاع';
	@override String get s10_item2 => 'يرجى الاتصال بفريق الدعم لدينا على العنوان support@waslaq.com';
	@override String get s10_item3 => 'أرسل طلب دعم عبر صفحة الاتصال الخاصة بنا';
	@override String get s10_note => 'الدعم متاح باللغتين العربية والإنجليزية. ونسعى للرد على جميع الاستفسارات في غضون يوم إلى يومين عمل.';
	@override String get s3_body => 'لا تشمل خدمة «حماية المشتري من واسلق» الحالات التالية بشكل صريح:';
	@override String get s4_body => 'لطلب استرداد المبلغ أو الإبلاغ عن مشكلة تتعلق بطلبك، اتبع الخطوات التالية:';
	@override String get s10_body => 'للاستفسار عن هذه السياسة، أو للحصول على المساعدة في رفع نزاع، أو للحصول على الدعم بخصوص طلب معين:';
	@override String get footer_related_policies => 'السياسات ذات الصلة';
	@override String get cookie_policy_link => 'سياسة ملفات تعريف الارتباط';
	@override String get contact_support_link => 'اتصل بالدعم الفني';
}

// Path: vendor_finances
class StringsVendorFinancesAr extends StringsVendorFinancesEn {
	StringsVendorFinancesAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get ready_to_withdraw => 'جاهز للسحب';
	@override String get pending_escrow => 'قيد الانتظار (حساب الضمان)';
	@override String get awaiting_release => 'في انتظار إصدار الإذن بالتنفيذ';
	@override String get total_paid_out => 'إجمالي المبالغ المدفوعة';
	@override String get lifetime_withdrawals => 'عمليات السحب على مدى العمر';
	@override String get request_withdrawal => 'طلب السحب';
	@override String get amount_ils => 'المبلغ (شيكل إسرائيلي)';
	@override String get request_payout => 'طلب سحب الأموال';
	@override String get payout_note => 'يتم معالجة عمليات الدفع يدويًّا من قِبل مسؤول المنصة في غضون 2 إلى 5 أيام عمل.';
	@override String get transaction_ledger => 'دفتر الأستاذ';
	@override String get no_transactions => 'لا توجد معاملات حتى الآن.';
}

// Path: vendor_settings
class StringsVendorSettingsAr extends StringsVendorSettingsEn {
	StringsVendorSettingsAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get store_logo => 'شعار المتجر';
	@override String get tap_to_change => 'انقر لتغيير';
	@override String get store_info => 'معلومات عامة';
	@override String get store_name => 'اسم المتجر';
	@override String get store_description => 'وصف المتجر';
	@override String get contact => 'الاتصال';
	@override String get phone => 'الهاتف';
	@override String get delivery => 'التسليم';
	@override String get store_location => 'موقع المتجر (المدينة)';
	@override String get location_placeholder => 'على سبيل المثال: غزة، رام الله';
	@override String get delivery_zone => 'منطقة التوصيل';
	@override String get select_zone => 'اختر المنطقة...';
	@override String get zone_note => 'لن يتم توصيل المنتجات المادية إلا داخل المنطقة التي اخترتها.';
	@override String get payout => 'المبلغ المدفوع';
	@override String get payout_account => 'حساب التحويل (IBAN أو PayPal)';
	@override String get payout_placeholder => 'أدخل رقم IBAN أو عنوان بريدك الإلكتروني على PayPal';
	@override String get payout_hint => 'سيتم إرسال مدفوعاتك إلى هذا العنوان. تأكد من صحته.';
	@override String get save_settings => 'حفظ الإعدادات';
}

// Path: vendor_policies
class StringsVendorPoliciesAr extends StringsVendorPoliciesEn {
	StringsVendorPoliciesAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'سياسات المتجر';
	@override String get audit_note => 'يؤدي تحديث سياساتك إلى إنشاء نسخة جديدة دائمة وقابلة للتدقيق القانوني. ويتم الاحتفاظ بالإصدارات السابقة.';
	@override String get shipping_policy => 'سياسة الشحن';
	@override String get shipping_placeholder => 'أدخل سياسة الشحن الخاصة بك...';
	@override String get refund_policy => 'سياسة الإرجاع والاسترداد';
	@override String get refund_placeholder => 'أدخل سياسة الإرجاع والاسترداد الخاصة بك...';
	@override String get save => 'حفظ السياسات';
}

// Path: digital_vault
class StringsDigitalVaultAr extends StringsDigitalVaultEn {
	StringsDigitalVaultAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'الخزينة الرقمية';
	@override String get subtitle => 'المنتجات الرقمية التي اشتريتها. يُسمح بتنزيل كل منتج مرة واحدة خلال 24 ساعة من الشراء.';
	@override String get expired => 'منتهية الصلاحية';
	@override String get digital_product => 'المنتج الرقمي';
	@override String get downloads => 'التنزيلات';
	@override String get order => 'طلب';
	@override String get expired_on => 'انتهت صلاحيتها في';
	@override String get limit_reached => 'تم الوصول إلى الحد الأقصى';
}

// Path: vendor_products
class StringsVendorProductsAr extends StringsVendorProductsEn {
	StringsVendorProductsAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'منتجات متجرك';
	@override String get subtitle => 'قم بإدارة عناصر الكتالوج المادية والرقمية.';
	@override String get cancel_creation => 'إلغاء الإنشاء';
	@override String get bulk_edit_stock => 'التعديل الجماعي للمخزون';
	@override String get create_new_product => 'إنشاء منتج جديد';
	@override String get product_details => 'تفاصيل المنتج';
	@override String get product_details_subtitle => 'معلومات أساسية عن المنتج الذي تبيعه.';
	@override String get product_title => 'اسم المنتج';
	@override String get product_title_placeholder => 'مثل: وعاء خزفي مصنوع يدويًا';
	@override String get description => 'الوصف';
	@override String get description_placeholder => 'أخبر المشترين عن منتجك وميزاته والمواد المصنوع منها أو تعليمات الاستخدام...';
	@override String get product_type => 'نوع المنتج';
	@override String get virtual_digital => 'افتراضي / رقمي';
	@override String get physical_item => 'المنتج المادي';
	@override String get virtual_desc => 'البرامج، ملفات PDF، الوسائط، مفاتيح التفعيل';
	@override String get physical_desc => 'يتطلب الشحن';
	@override String get category => 'الفئة';
	@override String get select_parent_category => 'اختر الفئة الرئيسية';
	@override String get select_subcategory => 'اختر فئة فرعية (اختياري)';
	@override String get category_hint => 'يساعد اختيار فئة فرعية محددة العملاء على العثور على منتجك بسهولة أكبر.';
	@override String get product_images => 'صور المنتج';
	@override String get add_images => 'إضافة صور';
	@override String get digital_asset_label => 'الأصل الرقمي / رابط الاسترداد';
	@override String get upload_file_label => 'الخيار 1: تحميل ملف (بحد أقصى 128 ميغابايت)';
	@override String get choose_file => 'اختر ملفًا لتحميله...';
	@override String get or => 'أو';
	@override String get external_link_label => 'الخيار 2: توفير رابط خارجي';
	@override String get external_link_placeholder => 'https://g2a.com/... أو رابط Google Drive';
	@override String get digital_delivery_note => 'سيتلقى العملاء هذا الملف أو الرابط تلقائيًا عبر بريدهم الإلكتروني فور إتمام عملية الدفع بنجاح.';
	@override String get inventory_notice => 'إشعار بشأن المخزون';
	@override String get inventory_note => 'تتطلب المنتجات المادية تتبعًا. يمنع نظام المخزون الذكي لدينا البيع الزائد ويوقف عملية الدفع في حالة نفاد المنتج أثناء عملية الشراء. سيتم إرسال بريد إلكتروني إليك فورًا عندما يصل مخزون المنتج إلى 0.';
	@override String get discard => 'تجاهل';
	@override String get launch_product => 'إطلاق المنتج';
	@override String get no_products => 'لا توجد منتجات حتى الآن';
	@override String get no_products_desc => 'ابدأ بإدراج أول منتج مادي أو رقمي لديك للوصول إلى العملاء في جميع أنحاء العالم.';
	@override String get list_first_item => 'أدرج العنصر الأول';
	@override String get edit_product => 'تعديل المنتج';
	@override String get price_ils => 'السعر (شواقل إسرائيلية)';
	@override String get save_changes => 'حفظ التغييرات';
	@override String get bulk_inventory_title => 'تحرير المخزون بالجملة';
	@override String get bulk_inventory_subtitle => 'اضغط على رقم لتعديله';
	@override String get units => 'الوحدات';
	@override String get default_label => 'الافتراضي';
	@override String get cancel => 'إلغاء';
	@override String get save_all_changes => 'حفظ جميع التغييرات';
	@override String get no_managed_inventory => 'لم يتم العثور على أي منتجات ذات مخزون مُدار.';
	@override String get delete_confirm => 'هل أنت متأكد من رغبتك في حذف هذا المنتج؟ لا يمكن التراجع عن هذا الإجراء.';
	@override String get price_placeholder => 'على سبيل المثال: 99.99';
	@override String get file_size_error => 'حجم الملف يتجاوز الحد الأقصى البالغ 128 ميغابايت.';
	@override String get upload_url_error => 'فشل الحصول على رابط التحميل';
	@override String get upload_failed_error => 'فشل تحميل الملف إلى R2';
	@override String get create_failed_error => 'فشل إنشاء المنتج';
	@override String get unexpected_upload_error => 'حدث خطأ غير متوقع أثناء التحميل.';
	@override String get delete_failed_error => 'فشل حذف المنتج';
	@override String get delete_error => 'حدث خطأ أثناء حذف المنتج.';
	@override String get update_failed_error => 'فشل تحديث المنتج';
	@override String get generic_error => 'حدث خطأ';
	@override String get invalid_qty => 'غير صالح';
	@override String get bulk_update_failed => 'فشلت بعض عمليات التحديث. يرجى المحاولة مرة أخرى.';
	@override String get options_title => 'خيارات المنتج (اللون، الحجم، المادة)';
	@override String get add_option => 'إضافة + خيار';
	@override String get no_options_note => 'لم يتم تكوين أي خيارات. سيتم إنشاء هذا كنسخة افتراضية واحدة.';
	@override String get variant_matrix => 'مصفوفة المتغيرات';
	@override String get track_stock => 'مخزون القضبان';
	@override String get price_column => 'السعر (شواقل إسرائيلية)';
	@override String get sku => 'رقم المنتج';
	@override String get variant_column => 'صيغة';
	@override String get default_config => 'الإعدادات الافتراضية';
	@override String get type_physical => 'البدني';
	@override String get type_digital => 'رقمي';
	@override String get option_name => 'اسم الخيار';
	@override String get comma_separated_values => 'قيم مفصولة بفواصل';
	@override String get option_name_placeholder => 'على سبيل المثال، اللون';
	@override String get values_placeholder => 'على سبيل المثال: الأحمر، الأزرق، الأخضر';
	@override String get stock_qty => 'كمية المخزون';
	@override String get dimensions => 'الأبعاد (العرض/الطول/الارتفاع)';
	@override String get sku_placeholder => 'SKU-123';
	@override String get weight_placeholder => 'مثل: 0.5';
	@override String get height_placeholder => 'ح';
	@override String get inventory_label => 'المخزون';
	@override String get unlimited => 'بلا حدود';
	@override String get out_of_stock => 'غير متوفر';
}

// Path: vendor_orders
class StringsVendorOrdersAr extends StringsVendorOrdersEn {
	StringsVendorOrdersAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'طلباتي';
	@override String get ship_to => 'الشحن إلى:';
	@override String get status_shipped => 'تم الشحن';
	@override String get status_pending => 'قيد الانتظار';
	@override String get status_processing => 'المعالجة';
	@override String get status_delivered => 'تم التسليم';
	@override String get status_cancelled => 'تم إلغاؤه';
	@override String get status_awaiting_pickup => 'في انتظار الاستلام';
	@override String get no_orders => 'لا توجد طلبات حتى الآن';
	@override String get no_orders_desc => 'عندما يشتري العملاء منتجاتك، ستظهر الطلبات هنا.';
	@override String get mark_shipped => 'وضع علامة "تم الشحن"';
	@override String get shipping_loading => 'الشحن…';
	@override String get order_number => 'رقم الطلب';
	@override String get status_completed => 'تم الانتهاء';
}

// Path: dispute
class StringsDisputeAr extends StringsDisputeEn {
	StringsDisputeAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get back => 'العودة';
	@override String get case_resolved_vendor => 'تمت تسوية القضية: تم تحويل الأموال إلى المورد';
	@override String get case_resolved_buyer => 'تمت تسوية القضية: تم رد المبلغ إلى المشتري';
	@override String get case_resolved_full_refund => '✅ تم حل القضية: تم إصدار استرداد كامل للمبلغ';
	@override String get dispute_opened => 'تم فتح النزاع';
	@override String get under_review => 'قيد المراجعة';
	@override String get image_attachment => 'صورة مرفقة';
	@override String get admin_badge => 'المسؤول';
	@override String get loading_chat => 'جاري تحميل الدردشة...';
	@override String get not_found => 'لم يتم العثور على النزاع.';
	@override String get no_messages => 'لا توجد رسائل حتى الآن. أرسل رسالة لبدء المحادثة.';
	@override String get input_placeholder => 'اشرح مشكلتك للمورد والمسؤول...';
	@override String get attachment_label => '📎 المرفق';
	@override String get status_open => 'فتح';
	@override String get status_resolved_refund => 'تم حل المشكلة (استرداد المبلغ)';
	@override String get status_resolved_release => 'تم حله (تم إصداره)';
	@override String get status_resolved_split => 'تم حله (مقسم)';
	@override String get status_under_review => 'قيد المراجعة';
}

// Path: stores
class StringsStoresAr extends StringsStoresEn {
	StringsStoresAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'تصفح المتاجر';
	@override String get subtitle => 'اكتشف البائعين الفلسطينيين المفضلين لديك وتابعهم.';
	@override String get no_stores => 'لا توجد متاجر حتى الآن.';
	@override String get retry => 'إعادة المحاولة';
	@override String get no_stores_yet => 'لا توجد متاجر بعد';
}

// Path: social
class StringsSocialAr extends StringsSocialEn {
	StringsSocialAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get message_button => 'رسالة';
	@override String get follow_button => 'تابع';
	@override String get visit_store_button => 'تفضل بزيارة متجري';
	@override String get share_button => 'مشاركة';
	@override String get comments_heading => 'التعليقات';
	@override String get comment_placeholder => 'ما رأيك؟';
	@override String get comment_button => 'تعليق';
	@override String get no_comments => 'لا توجد تعليقات حتى الآن';
	@override String get pending_button => 'قيد الانتظار';
	@override String get following_button => 'فيما يلي';
	@override String get replying_to => 'رداً على';
	@override String get protected_posts_title => 'هذه المنشورات محمية';
	@override String get protected_posts_desc => 'لا يمكن إلا للمتابعين المعتمدين مشاهدة المنشورات.';
	@override String get no_posts => 'لا توجد مشاركات حتى الآن.';
	@override String get no_replies => 'لا توجد ردود حتى الآن.';
	@override String get no_media => 'لا توجد وسائط حتى الآن.';
	@override String years_ago({required Object n}) => 'قبل ${n} سنة';
	@override String months_ago({required Object n}) => 'قبل ${n} شهر';
	@override String days_ago({required Object n}) => 'قبل ${n} يوم';
	@override String hours_ago({required Object n}) => 'قبل ${n} ساعة';
	@override String minutes_ago({required Object n}) => 'قبل ${n} دقيقة';
	@override String get just_now => 'قبل قليل';
	@override String years_short({required Object n}) => '${n}سنة';
	@override String months_short({required Object n}) => '${n}شهر';
	@override String days_short({required Object n}) => '${n}ي';
	@override String hours_short({required Object n}) => '${n}س';
	@override String minutes_short({required Object n}) => '${n}د';
	@override String get now_short => 'الآن';
	@override String share_post({required Object title, required Object url}) => 'شاهد هذا المنشور على واصلك: ${title}\n${url}';
}

// Path: store
class StringsStoreAr extends StringsStoreEn {
	StringsStoreAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'المتجر';
	@override String get all_categories => 'الكل';
	@override String products_count({required Object count}) => '${count} منتج';
	@override String get latest_arrivals => 'أحدث المنتجات';
	@override String get price_low_high => 'السعر: من الأقل للأعلى';
	@override String get price_high_low => 'السعر: من الأعلى للأقل';
	@override String get no_products_found => 'لم يتم العثور على منتجات';
}

// Path: vendor_profile
class StringsVendorProfileAr extends StringsVendorProfileEn {
	StringsVendorProfileAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get products_tab => 'المنتجات ({count})';
	@override String get qa_tab => 'الأسئلة والأجوبة ({count})';
	@override String get reviews_tab => 'التقييمات ({count})';
	@override String get policies_tab => 'السياسات';
	@override String get store_not_found => 'المتجر غير موجود';
	@override String get no_products => 'لا توجد منتجات بعد';
	@override String get no_questions => 'لا توجد أسئلة بعد';
	@override String get no_reviews => 'لا توجد تقييمات بعد';
	@override String get no_policies => 'لم يتم نشر أي سياسات بعد';
	@override String get vendor_answer => 'إجابة البائع';
	@override String get awaiting_response => 'في انتظار رد البائع...';
	@override String get verified_badge => '✓ موثق';
	@override String get shipping_policy => 'سياسة الشحن';
	@override String get return_refund_policy => 'سياسة الإرجاع والاسترداد';
}

// Path: drawer
class StringsDrawerAr extends StringsDrawerEn {
	StringsDrawerAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get browse => 'تصفح';
	@override String get community_section => 'المجتمع';
	@override String get stores_section => 'المتاجر';
	@override String get account_section => 'الحساب';
	@override String get info_section => 'المعلومات';
	@override String get legal_section => 'قانوني';
	@override String get sign_in_prompt => 'قم بتسجيل الدخول للوصول إلى مجتمعاتك ومتاجرك';
	@override String get popular => 'شائع';
	@override String get news => 'الأخبار';
	@override String get saved => 'المحفوظات';
	@override String get create_community => 'إنشاء مجتمع';
	@override String get no_communities_joined => 'لم تنضم إلى أي مجتمع بعد';
	@override String get browse_all_stores => 'تصفح جميع المتاجر';
	@override String get my_store => 'متجري';
	@override String get not_vendor_yet => 'لست بائعاً بعد — كن بائعاً الآن ←';
	@override String get about_waslaq => 'عن واصلك';
	@override String get contact_us => 'اتصل بنا';
	@override String get feedback => 'الملاحظات';
}

// Path: info
class StringsInfoAr extends StringsInfoEn {
	StringsInfoAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get about_title => 'عن واصلك';
	@override String get contact_title => 'اتصل بنا';
	@override String get feedback_title => 'الملاحظات';
	@override String get our_mission => 'مهمتنا';
	@override String get what_we_offer => 'ماذا نقدم';
	@override String get trust_safety => 'الثقة والأمان';
	@override String get get_in_touch => 'تواصل معنا';
	@override String get send_message => 'إرسال الرسالة';
	@override String get help_us_improve => 'ساعدنا في التحسين';
	@override String get submit_feedback => 'إرسال الملاحظات';
	@override String get message_sent => 'تم إرسال الرسالة! سنقوم بالرد عليك قريباً.';
	@override String get thank_you_feedback => 'شكراً لملاحظاتك!';
	@override String get write_feedback_required => 'يرجى كتابة ملاحظاتك';
	@override String get failed_submit_feedback => 'فشل الإرسال. يرجى المحاولة مرة أخرى.';
	@override String get feedback_desc => 'تساعدنا ملاحظاتك في بناء منصة أفضل.';
	@override String get category => 'الفئة';
	@override String get rating => 'التقييم';
	@override String get your_feedback => 'ملاحظاتك';
	@override String get feedback_hint => 'أخبرنا برأيك...';
	@override String get type_general => 'عام';
	@override String get type_bug => 'خطأ برمجي';
	@override String get type_feature => 'ميزة جديدة';
	@override String get type_design => 'التصميم';
	@override String get about_subtitle => 'سوقك الفلسطيني الأول';
	@override String get our_mission_body => 'واصلك هو سوق اجتماعي هجين مبني لفلسطين. نحن نجمع بين أفضل محتوى يقوده المجتمع ومنصة تجارة إلكترونية موثوقة، ونربط البائعين المحليين بالمشترين من خلال نظام ضمان آمن.';
	@override String get what_we_offer_body => '• بائعون محليون موثوقون مع حماية الضمان\n• محتوى ونقاشات يقودها المجتمع\n• منتجات رقمية ومادية\n• مدفوعات آمنة عبر Stripe\n• مناطق توصيل في غزة والضفة الغربية';
	@override String get trust_safety_body => 'كل معاملة معاملة محمية بنظام الضمان الخاص بنا. يتم الاحتفاظ بالأموال بأمان حتى يؤكد المشتري الاستلام. يتم التحقق من البائعين وتقييمهم من قبل المجتمع.';
	@override String version({required Object version}) => 'الإصدار ${version}';
	@override String get fill_all_fields => 'يرجى ملء جميع الحقول';
	@override String get failed_send_message => 'فشل الإرسال. يرجى المحاولة مرة أخرى.';
	@override String get contact_desc => 'لديك سؤال أو بحاجة إلى مساعدة؟ أرسل لنا رسالة.';
	@override String get name_label => 'الاسم';
	@override String get message_label => 'الرسالة';
}

// Path: orders
class StringsOrdersAr extends StringsOrdersEn {
	StringsOrdersAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'طلباتي';
	@override String get failed_load => 'فشل تحميل الطلبات';
	@override String get retry => 'إعادة المحاولة';
	@override String get no_orders => 'لا توجد طلبات حتى الآن';
	@override String get today => 'اليوم';
	@override String get yesterday => 'أمس';
	@override String days_ago({required Object n}) => 'منذ ${n} أيام';
	@override String weeks_ago({required Object n}) => 'منذ ${n} أسبوع';
	@override String months_ago({required Object n}) => 'منذ ${n} أشهر';
}

// Path: notifications
class StringsNotificationsAr extends StringsNotificationsEn {
	StringsNotificationsAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'الإشعارات';
	@override String get failed_load => 'فشل تحميل الإشعارات';
	@override String get retry => 'إعادة المحاولة';
	@override String get no_notifications => 'لا توجد إشعارات حتى الآن';
}

// Path: saved_items
class StringsSavedItemsAr extends StringsSavedItemsEn {
	StringsSavedItemsAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'العناصر المحفوظة';
	@override String get failed_load => 'فشل تحميل العناصر المحفوظة';
	@override String get retry => 'إعادة المحاولة';
	@override String get products_tab => 'المنتجات';
	@override String get posts_tab => 'المنشورات';
	@override String get no_products => 'لا توجد منتجات محفوظة بعد';
	@override String get no_products_sub => 'اضغط ♡ على أي منتج لحفظه هنا.';
	@override String get no_posts => 'لا توجد منشورات محفوظة بعد';
	@override String get no_posts_sub => 'احفظ المنشورات من موجز المجتمع.';
	@override String get could_not_load => 'تعذّر تحميل المنتجات';
}

// Path: legal
class StringsLegalAr extends StringsLegalEn {
	StringsLegalAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get privacy_policy_title => 'سياسة الخصوصية';
	@override String get terms_title => 'شروط الخدمة';
}

// Path: create_post
class StringsCreatePostAr extends StringsCreatePostEn {
	StringsCreatePostAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get sheet_title => 'ماذا تريد أن تنشر؟';
	@override String get general_post => 'منشور عام';
	@override String get community_post => 'نشر داخل مجتمع';
	@override String community_post_in({required Object slug}) => 'نشر في r/${slug}';
	@override String get share_product => 'مشاركة منتج';
	@override String share_product_named({required Object title}) => 'مشاركة: ${title}';
	@override String get ask_product => 'سؤال عن منتج';
	@override String get select_community_title => 'اختر مجتمعاً';
	@override String get search_communities => 'ابحث عن مجتمعات...';
	@override String get show_more_communities => 'عرض المزيد من المجتمعات';
	@override String get no_communities_found => 'لم يتم العثور على مجتمعات';
	@override String get private_community_locked => 'خاص - انضم للاختيار';
	@override String get create_community => 'إنشاء مجتمع';
	@override String get ai_assistant => 'المساعد الذكي (AI)';
}

// Path: errors
class StringsErrorsAr extends StringsErrorsEn {
	StringsErrorsAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get network => 'لا يوجد اتصال بالإنترنت — تحقق من الشبكة وحاول مجدداً';
	@override String get timeout => 'الاتصال يستغرق وقتاً طويلاً — حاول مرة أخرى';
	@override String get server => 'حدث خطأ من طرفنا — حاول مجدداً بعد قليل';
	@override String get unauthorized => 'انتهت صلاحية الجلسة — سجّل الدخول من جديد';
	@override String get not_found => 'لم نعثر على ما تبحث عنه';
	@override String get rate_limited => 'محاولات كثيرة — انتظر لحظة وحاول مجدداً';
	@override String get validation => 'بعض المعلومات غير صحيحة — راجعها وحاول مجدداً';
	@override String get unknown => 'حدث خطأ ما — حاول مرة أخرى';
	@override String get offline_banner => 'لا يوجد اتصال بالإنترنت';
	@override String get back_online => 'عاد الاتصال';
	@override String get crash_title => 'عذراً، حدث خلل';
	@override String get crash_message => 'حدث خطأ غير متوقع. ارجع للخلف وحاول مجدداً.';
}

// Path: connections
class StringsConnectionsAr extends StringsConnectionsEn {
	StringsConnectionsAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'التواصل';
	@override String get followers => 'المتابِعون';
	@override String get following => 'يتابِع';
	@override String get no_followers => 'لا يوجد متابِعون بعد';
	@override String get no_following => 'لا يتابع أحداً بعد';
	@override String get remove_follower => 'إزالة المتابِع';
	@override String get remove => 'إزالة';
	@override String remove_follower_confirm({required Object name}) => 'إزالة ${name} من متابِعيك؟ لن يتم إخباره بذلك.';
	@override String get removed => 'تمت إزالة المتابِع';
	@override String get block => 'حظر';
	@override String block_confirm({required Object name}) => 'حظر ${name}؟ لن يتمكن من متابعتك أو مراسلتك.';
	@override String get blocked => 'تم حظر المستخدم';
}

// Path: vendor_import
class StringsVendorImportAr extends StringsVendorImportEn {
	StringsVendorImportAr._(StringsAr root) : this._root = root, super._(root);

	@override final StringsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'استيراد / تصدير';
	@override String get step1_title => 'تصدير منتجاتك';
	@override String get step1_desc => 'نزّل منتجاتك الحالية كملف Excel، عدّل أو أضف صفوفاً جديدة، ثم أعد رفعه. البائعون الجدد يحصلون على صف نموذجي.';
	@override String get step1_btn => 'تصدير المنتجات (.xlsx)';
	@override String get step2_title => 'استيراد المنتجات';
	@override String get step2_desc => 'ارفع ملف .xlsx أو .csv المعبّأ. الحد الأقصى 100 منتج لكل عملية.';
	@override String get tap_to_select => 'اضغط لاختيار ملف';
	@override String get file_too_large => 'الملف يتجاوز حد 5 ميغابايت.';
	@override String get import_completed => 'اكتمل الاستيراد!';
	@override String import_failed({required Object error}) => 'فشل الاستيراد: ${error}';
	@override String export_failed({required Object error}) => 'فشل التصدير: ${error}';
	@override String get export_share_text => 'تصدير منتجات واصلك';
	@override String get start_import => 'بدء الاستيراد';
	@override String get results_title => 'نتائج الاستيراد';
	@override String products_created({required Object count}) => 'تم إنشاء ${count} منتجات';
	@override String rows_failed({required Object count}) => 'فشل ${count} صفوف';
	@override String get import_another => 'استيراد آخر';
	@override String get done => 'تم';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'nav.home': return 'Home';
			case 'nav.category': return 'Category';
			case 'nav.community': return 'Community';
			case 'nav.messages': return 'Messages';
			case 'nav.search_placeholder': return 'Search items, stores or creators...';
			case 'nav.cart': return 'Cart';
			case 'nav.saved': return 'Saved';
			case 'nav.stores': return 'Stores';
			case 'nav.browse_all_stores': return 'Browse All Stores';
			case 'nav.my_store': return 'My Store';
			case 'nav.account': return 'Account';
			case 'nav.info': return 'Info';
			case 'nav.about_waslaq': return 'About Waslaq';
			case 'nav.contact_us': return 'Contact Us';
			case 'nav.feedback': return 'Feedback';
			case 'nav.create_community': return 'Create Community';
			case 'nav.explore': return 'Explore';
			case 'explore.products': return 'Products';
			case 'explore.communities': return 'Communities';
			case 'explore.stores': return 'Stores';
			case 'explore.browse_categories': return 'Browse Categories';
			case 'explore.popular_searches': return 'Popular Searches';
			case 'explore.all_communities': return 'All Communities';
			case 'explore.select_community': return 'Select Community';
			case 'explore.filter': return 'Filter';
			case 'explore.category': return 'Category';
			case 'explore.brand': return 'Brand';
			case 'explore.color': return 'Color';
			case 'explore.clear_filters': return 'Clear Filters';
			case 'explore.apply': return 'Apply';
			case 'explore.filter_by_community': return 'By Community';
			case 'explore.search_communities': return 'Search communities...';
			case 'explore.my_communities': return 'My Communities';
			case 'explore.no_communities_joined': return 'You haven\'t joined any communities yet';
			case 'explore.explore_communities': return 'Explore Communities';
			case 'explore.select_community_to_filter': return 'Select a community to filter posts';
			case 'explore.all_posts': return 'All Posts';
			case 'explore.private_join_required': return 'Join this private community to select it';
			case 'explore.public': return 'Public';
			case 'auth.sign_in': return 'Sign In';
			case 'auth.sign_up': return 'Create Account';
			case 'auth.sign_out': return 'Sign Out';
			case 'auth.email': return 'Email';
			case 'auth.password': return 'Password';
			case 'auth.display_name': return 'Display Name';
			case 'auth.username': return 'Username';
			case 'auth.forgot_password': return 'Forgot password?';
			case 'auth.no_account': return 'Don\'t have an account?';
			case 'auth.have_account': return 'Already have an account?';
			case 'auth.create_account': return 'Create Account';
			case 'auth.continue_google': return 'Continue with Google';
			case 'auth.continue_facebook': return 'Continue with Facebook';
			case 'auth.become_vendor': return 'Become a Vendor';
			case 'auth.want_to_sell': return 'Want to sell?';
			case 'auth.signing_in': return 'Signing in...';
			case 'auth.creating_account': return 'Creating account...';
			case 'auth.username_available': return 'Username available';
			case 'auth.checking': return 'Checking...';
			case 'auth.or_continue_with': return 'Or continue with';
			case 'auth.or_sign_up_email': return 'Or sign up with email';
			case 'auth.login_title': return 'Login';
			case 'auth.required_field': return 'Required';
			case 'account.my_orders': return 'My Orders';
			case 'account.orders': return 'Orders';
			case 'account.track_purchases': return 'Track your purchases and order history.';
			case 'account.addresses': return 'Addresses';
			case 'account.downloads': return 'Downloads';
			case 'account.notifications': return 'Notifications';
			case 'account.profile': return 'Profile';
			case 'account.saved_items': return 'Saved Items';
			case 'account.disputes': return 'Disputes';
			case 'account.vendor_dashboard': return 'Vendor Dashboard';
			case 'account.settings': return 'Settings';
			case 'account.no_orders': return 'No orders yet';
			case 'account.no_orders_desc': return 'You haven\'t placed any orders yet. Start shopping and your orders will appear here.';
			case 'account.start_shopping': return 'Start Shopping';
			case 'account.view_order': return 'View Order';
			case 'account.back_to_orders': return 'Back to Orders';
			case 'account.order_placed': return 'Order Placed';
			case 'account.processing': return 'Processing';
			case 'account.shipped': return 'Shipped';
			case 'account.delivered': return 'Delivered';
			case 'account.order_progress': return 'Order Progress';
			case 'account.items': return 'Items';
			case 'account.total': return 'Total';
			case 'account.shipping_address': return 'Shipping Address';
			case 'account.problem_order': return 'Problem with your order?';
			case 'account.dispute_window': return 'You can open a dispute within 4 days of delivery.';
			case 'account.open_dispute': return 'Open a Dispute';
			case 'account.cancel': return 'Cancel';
			case 'account.submit_dispute': return 'Submit Dispute';
			case 'account.what_issue': return 'What is the issue?';
			case 'account.non_delivery': return 'Non-Delivery';
			case 'account.non_delivery_desc': return 'Item never arrived';
			case 'account.damaged_wrong': return 'Damaged / Wrong';
			case 'account.damaged_wrong_desc': return 'Not as described';
			case 'account.describe_issue': return 'Describe the issue';
			case 'account.my_communities': return 'My Communities';
			case 'account.my_posts': return 'My Posts & Comments';
			case 'account.vendor_center': return 'Vendor Dashboard';
			case 'account.account_privacy': return 'Account & Privacy';
			case 'account.sign_out': return 'Sign Out';
			case 'account.edit_profile': return 'Edit Profile';
			case 'account.followers': return 'Followers';
			case 'account.following': return 'Following';
			case 'account.profile_settings': return 'Profile Settings';
			case 'account.privacy_settings': return 'Privacy Settings';
			case 'account.privacy': return 'Privacy';
			case 'account.private_account': return 'Private Account';
			case 'account.show_activity': return 'Show Activity Status';
			case 'account.follow_requests': return 'Follow Requests';
			case 'account.account_settings': return 'Account Settings';
			case 'account.connected_accounts': return 'Connected Accounts';
			case 'account.delete_account': return 'Delete Account';
			case 'account.change_password': return 'Change Password';
			case 'account.order_status_title': return 'Order Status';
			case 'account.order_label': return 'Order';
			case 'account.payment_label': return 'Payment';
			case 'account.fulfillment_label': return 'Fulfillment';
			case 'account.placed': return 'Placed';
			case 'account.items_count': return ({required Object count}) => 'Items (${count})';
			case 'account.qty_label': return ({required Object count}) => 'Qty: ${count}';
			case 'account.order_number': return ({required Object id}) => 'Order #${id}';
			case 'account.failed_load_orders': return 'Failed to load orders';
			case 'account.title': return 'Account';
			case 'account.my_orders_label': return 'My Orders';
			case 'account.saved_items_label': return 'Saved Items';
			case 'account.messages_label': return 'Messages';
			case 'account.notifications_label': return 'Notifications';
			case 'account.settings_label': return 'Settings';
			case 'account.privacy_policy_label': return 'Privacy Policy';
			case 'account.terms_label': return 'Terms of Service';
			case 'account.sign_out_label': return 'Sign Out';
			case 'account.vendor_dashboard_label': return 'Vendor Dashboard';
			case 'account.become_vendor_label': return 'Become a Vendor';
			case 'account.sign_in_welcome': return 'WaslaQ';
			case 'account.sign_in_desc': return 'Sign in to view your account,\norders, and messages.';
			case 'account.sign_in_btn': return 'Sign In';
			case 'account.create_account_btn': return 'Create Account';
			case 'account.section_shopping': return 'Shopping';
			case 'account.section_community': return 'Community';
			case 'account.section_communities': return 'My Communities';
			case 'account.section_vendor': return 'Vendor';
			case 'account.section_settings': return 'Settings';
			case 'account.section_legal': return 'Legal';
			case 'account.following_stores_label': return 'Following Stores';
			case 'product.add_to_cart': return 'Add to Cart';
			case 'product.sold': return ({required Object count}) => '${count} sold';
			case 'product.no_seller': return 'Local Seller';
			case 'product.buy_now': return 'Buy Now';
			case 'product.save': return 'Save';
			case 'product.saved': return 'Saved';
			case 'product.reviews': return 'Reviews';
			case 'product.questions': return 'Questions & Answers';
			case 'product.write_review': return 'Write a Review';
			case 'product.ask_question': return 'Ask a Question';
			case 'product.no_reviews': return 'No reviews yet. Be the first to review this product.';
			case 'product.no_questions': return 'No questions yet. Be the first to ask!';
			case 'product.verified': return 'Verified';
			case 'product.verified_purchase': return 'Verified Purchase';
			case 'product.vendor_answer': return 'Vendor Answer';
			case 'product.waiting_answer': return 'Waiting for vendor to answer...';
			case 'product.submit_review': return 'Submit Review';
			case 'product.submit_question': return 'Submit Question';
			case 'product.your_rating': return 'Your Rating';
			case 'product.your_review': return 'Your Review';
			case 'product.ask_anonymously': return 'Ask anonymously';
			case 'product.customer_reviews': return 'Customer Reviews';
			case 'product.qty': return 'Qty';
			case 'product.in_stock': return 'In Stock';
			case 'product.out_of_stock': return 'Out of Stock';
			case 'product.related_products': return 'Related Products';
			case 'product.from_store': return 'From Store';
			case 'product.visit_store': return 'Visit Store';
			case 'product.quantity': return 'Quantity';
			case 'product.review_submitted': return 'Review submitted!';
			case 'product.question_submitted': return 'Question submitted! The vendor will answer soon.';
			case 'product.write_your_review': return 'Write your review...';
			case 'product.type_your_question': return 'Type your question about this product...';
			case 'product.you_might_also_like': return 'You Might Also Like';
			case 'product.must_purchase': return 'You can only review products you\'ve purchased';
			case 'product.sign_in_to_review': return 'Please sign in to leave a review';
			case 'product.sign_in_to_ask': return 'Please sign in to ask a question';
			case 'product.product_not_found': return 'Product not found';
			case 'product.official_store': return 'Official Store';
			case 'product.delivery_hint_trust': return 'Local delivery — ships from Palestine';
			case 'product.buyer_protection_trust': return 'Buyer protection — escrow until delivery';
			case 'product.options': return 'Options';
			case 'product.default_variant': return 'Default';
			case 'product.product_info': return 'Product Information';
			case 'product.customer_reviews_count': return ({required Object count}) => 'Customer Reviews (${count})';
			case 'product.verified_buyer': return 'Verified Buyer';
			case 'product.questions_answers_count': return ({required Object count}) => 'Questions & Answers (${count})';
			case 'product.please_select_rating': return 'Please select a rating';
			case 'product.failed_submit_review': return 'Failed to submit review';
			case 'product.please_enter_question': return 'Please enter your question';
			case 'product.failed_submit_question': return 'Failed to submit question';
			case 'product.added_to_cart_success': return 'Added to cart ✓';
			case 'product.failed_add_to_cart': return 'Failed to add to cart';
			case 'product.reviews_label': return 'Reviews';
			case 'product.qa_label': return 'Customer Questions & Answers';
			case 'product.product_information': return 'Product Information';
			case 'product.verified_reviews': return 'Verified Reviews';
			case 'product.customer_qa': return 'Customer Q&A';
			case 'product.delivery_local': return 'Local delivery is managed directly by the seller.';
			case 'product.escrow_protected': return 'Protected by Waslaq Escrow until delivery is confirmed.';
			case 'product.material': return 'Material';
			case 'product.origin': return 'Origin';
			case 'product.no_description': return 'No description provided.';
			case 'product.price_on_request': return 'Price on Request';
			case 'product.share_product': return ({required Object title, required Object url}) => 'Check out this product on WaslaQ: ${title}\n${url}';
			case 'product.community_discussions': return 'Community Discussions';
			case 'vendor.store': return 'Store';
			case 'vendor.products': return 'Products';
			case 'vendor.follow': return 'Follow';
			case 'vendor.following': return 'Following';
			case 'vendor.followers': return 'followers';
			case 'vendor.reviews': return 'Reviews';
			case 'vendor.policy': return 'Policies';
			case 'vendor.verified': return 'Verified';
			case 'vendor.share': return 'Share';
			case 'vendor.no_products': return 'No products available yet.';
			case 'vendor.your_store_products': return 'Your Store Products';
			case 'vendor.create_product': return 'Create New Product';
			case 'vendor.product_title': return 'Product Title';
			case 'vendor.description': return 'Description';
			case 'vendor.product_type': return 'Product Type';
			case 'vendor.physical_item': return 'Physical Item';
			case 'vendor.virtual_digital': return 'Virtual / Digital';
			case 'vendor.requires_shipping': return 'Requires shipping';
			case 'vendor.software_keys': return 'Software, PDFs, Media, Keys';
			case 'vendor.category': return 'Category';
			case 'vendor.select_parent_category': return 'Select Parent Category';
			case 'vendor.select_subcategory': return 'Select Subcategory (Optional)';
			case 'vendor.product_images': return 'Product Images';
			case 'vendor.add_images': return 'Add Images';
			case 'vendor.launch_product': return 'Launch Product';
			case 'vendor.discard': return 'Discard';
			case 'vendor.cancel_creation': return 'Cancel Creation';
			case 'vendor.bulk_edit_stock': return 'Bulk Edit Stock';
			case 'vendor.save_changes': return 'Save Changes';
			case 'vendor.edit_product': return 'Edit Product';
			case 'vendor.price_ils': return 'Price (₪ ILS)';
			case 'vendor.delete_product_confirm': return 'Are you sure you want to delete this product? This action cannot be undone.';
			case 'vendor.official_store': return 'Official Store';
			case 'vendor.visit_store': return 'Visit Store';
			case 'vendor.qa_tab': return 'Questions & Answers';
			case 'vendor.all_products': return 'All Products';
			case 'vendor.no_reviews': return 'No reviews yet';
			case 'vendor.failed_load_store': return 'Failed to load store';
			case 'vendor.store_not_found': return 'Store not found';
			case 'vendor.reviews_count': return ({required Object count}) => '${count} reviews';
			case 'vendor.tab_products': return ({required Object count}) => 'Products (${count})';
			case 'vendor.tab_qa': return ({required Object count}) => 'Q&A (${count})';
			case 'vendor.tab_reviews': return ({required Object count}) => 'Reviews (${count})';
			case 'vendor.tab_policies': return 'Policies';
			case 'vendor.no_products_yet': return 'No products yet';
			case 'vendor.no_questions_yet': return 'No questions yet';
			case 'vendor.awaiting_response': return 'Awaiting vendor response...';
			case 'vendor.no_reviews_yet': return 'No reviews yet';
			case 'vendor.no_stores_yet': return 'No stores yet';
			case 'vendor.rating_out_of_five': return ({required Object rating}) => '${rating}/5';
			case 'vendor.no_policies_yet': return 'No policies published yet';
			case 'vendor.shipping_policy': return 'Shipping Policy';
			case 'vendor.refund_policy': return 'Return & Refund Policy';
			case 'vendor.terms_of_use': return 'Terms of Use';
			case 'vendor.privacy_policy': return 'Privacy Policy';
			case 'checkout.checkout': return 'Checkout';
			case 'checkout.shipping': return 'Shipping';
			case 'checkout.payment': return 'Payment';
			case 'checkout.review': return 'Review';
			case 'checkout.place_order': return 'Place Order';
			case 'checkout.order_summary': return 'Order Summary';
			case 'checkout.subtotal': return 'Subtotal';
			case 'checkout.shipping_cost': return 'Shipping';
			case 'checkout.total': return 'Total';
			case 'checkout.first_name': return 'First Name';
			case 'checkout.last_name': return 'Last Name';
			case 'checkout.address': return 'Address';
			case 'checkout.city': return 'City';
			case 'checkout.country': return 'Country';
			case 'checkout.phone': return 'Phone';
			case 'checkout.email': return 'Email';
			case 'checkout.continue_action': return 'Continue';
			case 'checkout.back': return 'Back';
			case 'checkout.card_number': return 'Card Number';
			case 'checkout.pay_now': return 'Pay Now';
			case 'checkout.processing': return 'Processing...';
			case 'checkout.shipping_address': return 'Shipping Address';
			case 'checkout.billing_address': return 'Billing Address';
			case 'checkout.delivery': return 'Delivery';
			case 'checkout.review_order': return 'Review and Place Order';
			case 'checkout.shipping_to': return 'Shipping to';
			case 'checkout.payment_method': return 'Payment Method';
			case 'checkout.method': return 'Method';
			case 'checkout.details': return 'Details';
			case 'checkout.recipient': return 'Recipient';
			case 'checkout.contact': return 'Contact';
			case 'checkout.continue_delivery': return 'Proceed to Delivery';
			case 'checkout.continue_payment': return 'Proceed to Payment';
			case 'checkout.continue_review': return 'Continue to Review';
			case 'checkout.select_shipping': return 'Choose your preferred shipping method';
			case 'checkout.secure_processing': return 'Secure payment processing';
			case 'checkout.terms_notice': return 'By clicking \'Place Order\', you confirm that you have read, understood, and agree to our Terms of Use, Terms of Sale, and Return Policy, and acknowledge that you have read the WaslaQ Privacy Policy.';
			case 'checkout.billing_delivery_address': return 'Billing / Delivery Address';
			case 'checkout.discount': return 'Discount';
			case 'checkout.taxes': return 'Taxes';
			case 'checkout.postal_code': return 'Postal Code';
			case 'checkout.billing_same_as_shipping': return 'Billing address is the same as shipping address';
			case 'checkout.saved_address_prompt': return 'Would you like to use a saved address?';
			case 'checkout.mixed_cart_warning': return 'Physical products are only available for delivery within Palestine. Digital products can be shipped worldwide.';
			case 'checkout.your_phone_number': return 'Your Phone Number';
			case 'checkout.payment_failed': return 'Payment failed. Please try again.';
			case 'checkout.try_again': return 'Try Again';
			case 'checkout.address_line_1': return 'Address Line 1';
			case 'checkout.province_optional': return 'Province (Optional)';
			case 'checkout.continue_shipping': return 'Continue to Shipping';
			case 'checkout.cart_empty': return 'Cart empty';
			case 'checkout.qty': return ({required Object count}) => 'Qty: ${count}';
			case 'checkout.continue_shopping': return 'Continue Shopping';
			case 'checkout.customer_info_step': return 'Info';
			case 'checkout.delivery_step': return 'Delivery';
			case 'checkout.payment_step': return 'Payment';
			case 'checkout.customer_info_title': return 'Customer Information';
			case 'checkout.no_shipping_options': return 'No shipping options available';
			case 'checkout.agree_prefix': return 'I agree to the ';
			case 'checkout.terms_link': return 'Terms of Use';
			case 'checkout.and_text': return ' and ';
			case 'checkout.privacy_link': return 'Privacy Policy';
			case 'category.browse_categories': return 'Browse Categories';
			case 'category.subcategories': return 'Subcategories';
			case 'category.recommended': return 'Recommended';
			case 'category.for_you': return 'For You';
			case 'category.products_coming_soon': return 'Products coming soon';
			case 'category.no_subcategories': return 'No subcategories yet.';
			case 'category.select_category': return 'Select a category';
			case 'community.community': return 'Community';
			case 'community.join': return 'Join';
			case 'community.joined': return 'Joined';
			case 'community.leave': return 'Leave';
			case 'community.leave_title': return 'Leave Community';
			case 'community.leave_confirm': return 'Are you sure you want to leave this community?';
			case 'community.create_post': return 'Create Post';
			case 'community.post': return 'Post';
			case 'community.comment': return 'Comment';
			case 'community.comments': return 'Comments';
			case 'community.reply': return 'Reply';
			case 'community.share': return 'Share';
			case 'community.save': return 'Save';
			case 'community.report': return 'Report';
			case 'community.upvote': return 'Upvote';
			case 'community.members': return 'Members';
			case 'community.online': return 'Online';
			case 'community.rules': return 'Rules';
			case 'community.about': return 'About';
			case 'community.new_post': return 'New Post';
			case 'community.title': return 'Title';
			case 'community.content': return 'Content';
			case 'community.submit': return 'Submit';
			case 'community.cancel': return 'Cancel';
			case 'community.ask_anonymously': return 'Ask anonymously';
			case 'community.no_posts': return 'No posts yet.';
			case 'community.be_first': return 'Be the first to post!';
			case 'community.hot': return 'Hot';
			case 'community.new_label': return 'New';
			case 'community.top': return 'Top';
			case 'community.trending_communities': return 'Trending Communities';
			case 'community.see_all': return 'See all';
			case 'community.whats_on_your_mind': return 'What\'s on your mind?';
			case 'community.no_posts_subtitle': return 'Be the first to share something!';
			case 'community.select_community': return 'Select a community';
			case 'community.add_images': return 'Add Images';
			case 'community.add_more_images': return 'Add More ({count}/5)';
			case 'community.private_community': return 'Private Community';
			case 'community.created': return 'Created Date';
			case 'community.request_to_join': return 'Request to join to see posts and content';
			case 'community.welcome': return 'Welcome to the community!';
			case 'community.members_count': return ({required Object count}) => '${count} members';
			case 'community.title_required': return 'Title is required';
			case 'community.select_community_required': return 'Please select a community';
			case 'community.post_created': return 'Post created!';
			case 'community.failed_create_post': return 'Failed to create post. Please try again.';
			case 'community.post_action': return 'Post';
			case 'community.write_post_hint': return 'Write your post... (optional)';
			case 'community.add_more_images_param': return ({required Object count}) => 'Add More (${count}/5)';
			case 'community.failed_load_post': return 'Failed to load post';
			case 'community.error_loading_comments': return 'Error loading comments';
			case 'community.no_comments_yet': return 'No comments yet. Be the first to share your thoughts!';
			case 'community.view_more_replies': return 'View more replies';
			case 'community.add_comment': return 'Add a comment...';
			case 'community.login_to_comment': return 'Login to comment';
			case 'community.members_label': return ({required Object count}) => 'Members: ${count}';
			case 'community.joined_checkmark': return 'Joined ✓';
			case 'community.error_loading_posts': return ({required Object error}) => 'Error loading posts: ${error}';
			case 'community.explore_communities': return 'Explore Communities';
			case 'community.no_communities_found': return 'No communities found';
			case 'community.error_loading': return 'Error loading';
			case 'messages.messages': return 'Messages';
			case 'messages.no_messages': return 'No messages yet';
			case 'messages.type_message': return 'Type a message...';
			case 'messages.send': return 'Send';
			case 'messages.online': return 'Online';
			case 'messages.seen': return 'Seen';
			case 'messages.title': return 'Messages';
			case 'messages.load_more': return 'Load More';
			case 'messages.start_conversation': return 'Start Conversation';
			case 'messages.offline': return 'Offline';
			case 'messages.last_seen': return 'Last seen';
			case 'messages.deleted': return 'This message was deleted...';
			case 'messages.input_placeholder': return 'Type your message';
			case 'messages.yesterday_at': return 'Yesterday at';
			case 'messages.no_contacts': return 'No contacts yet.';
			case 'messages.follow_someone': return 'Follow someone to start chatting!';
			case 'messages.select_conversation': return 'Select a conversation or start a new one';
			case 'messages.online_now': return 'Online now';
			case 'messages.seen_prefix': return 'Seen by';
			case 'messages.unknown_user': return 'Unknown User';
			case 'messages.sign_in_view': return 'Sign in to view messages';
			case 'messages.connect_vendors_buyers': return 'Connect with vendors and buyers';
			case 'messages.could_not_connect': return 'Could not connect to messages';
			case 'messages.not_connected': return 'Not connected';
			case 'messages.no_conversations': return 'No conversations yet';
			case 'messages.tap_pencil_start': return 'Tap the pencil icon to start\na new conversation';
			case 'messages.could_not_open_chat': return ({required Object error}) => 'Could not open chat: ${error}';
			case 'messages.new_message': return 'New Message';
			case 'messages.search_hint': return 'Search by name or username…';
			case 'messages.no_users_found': return 'No users found';
			case 'common.unknown_user': return 'Unknown';
			case 'common.loading': return 'Loading...';
			case 'common.error': return 'Something went wrong';
			case 'common.error_prefix': return ({required Object error}) => 'Error: ${error}';
			case 'common.retry': return 'Retry';
			case 'common.save': return 'Save';
			case 'common.cancel': return 'Cancel';
			case 'common.delete': return 'Delete';
			case 'common.edit': return 'Edit';
			case 'common.close': return 'Close';
			case 'common.search': return 'Search';
			case 'common.filter': return 'Filter';
			case 'common.sort': return 'Sort';
			case 'common.view_all': return 'View All';
			case 'common.show_more': return 'Show More';
			case 'common.show_less': return 'Show Less';
			case 'common.confirm': return 'Confirm';
			case 'common.back': return 'Back';
			case 'common.next': return 'Next';
			case 'common.submit': return 'Submit';
			case 'common.success': return 'Success';
			case 'common.currency': return '₪';
			case 'common.free': return 'Free';
			case 'common.required': return 'Required';
			case 'common.optional': return 'Optional';
			case 'common.cancel_label': return 'Cancel';
			case 'common.retry_label': return 'Retry';
			case 'common.digital': return 'Digital';
			case 'common.save_changes': return 'Save Changes';
			case 'common.sort_by': return 'Sort By';
			case 'common.no_products': return 'No products';
			case 'common.reset': return 'Reset';
			case 'common.filters': return 'Filters';
			case 'common.item_type': return 'Product Type';
			case 'common.price_range': return 'Price Range';
			case 'common.show_results': return 'Show Results';
			case 'common.physical': return 'Physical';
			case 'common.min': return 'Min';
			case 'common.max': return 'Max';
			case 'common.latest': return 'Latest';
			case 'common.price_asc': return 'Price: Low to High';
			case 'common.price_desc': return 'Price: High to Low';
			case 'common.approve': return 'Approve';
			case 'common.reject': return 'Reject';
			case 'common.legal': return 'Legal';
			case 'common.months.0': return 'Jan';
			case 'common.months.1': return 'Feb';
			case 'common.months.2': return 'Mar';
			case 'common.months.3': return 'Apr';
			case 'common.months.4': return 'May';
			case 'common.months.5': return 'Jun';
			case 'common.months.6': return 'Jul';
			case 'common.months.7': return 'Aug';
			case 'common.months.8': return 'Sep';
			case 'common.months.9': return 'Oct';
			case 'common.months.10': return 'Nov';
			case 'common.months.11': return 'Dec';
			case 'common.categories': return 'Categories';
			case 'common.failed_load_categories': return 'Failed to load categories';
			case 'common.no_categories': return 'No categories';
			case 'common.no_subcategories': return 'No subcategories';
			case 'home.hero_title': return 'Discover. Connect. Shop.';
			case 'home.hero_subtitle': return 'Palestine\'s social marketplace';
			case 'home.shop_now': return 'Shop Now';
			case 'home.featured_products': return 'Featured Products';
			case 'home.trending': return 'Trending';
			case 'home.new_arrivals': return 'New Arrivals';
			case 'home.top_stores': return 'Top Stores';
			case 'home.browse_categories': return 'Browse Categories';
			case 'home.failed_load_products': return 'Failed to load products';
			case 'home.no_products_yet': return 'No products yet';
			case 'home.secure_escrow': return 'Secure Escrow';
			case 'home.verified_sellers': return 'Verified Sellers';
			case 'home.local_support': return 'Local Support';
			case 'home.search_placeholder': return 'Search products, stores...';
			case 'home.drawer_sign_in_hint': return 'Sign in to access your communities and stores';
			case 'home.drawer_browse': return 'BROWSE';
			case 'home.drawer_popular': return 'Popular';
			case 'home.drawer_news': return 'News';
			case 'home.drawer_community': return 'COMMUNITY';
			case 'home.drawer_create_community': return 'Create Community';
			case 'home.drawer_no_communities': return 'You haven\'t joined any communities yet';
			case 'home.drawer_stores': return 'STORES';
			case 'home.drawer_browse_stores': return 'Browse All Stores';
			case 'home.drawer_my_store': return 'My Store';
			case 'home.drawer_become_vendor_hint': return 'You\'re not a vendor yet — Become one →';
			case 'home.drawer_account': return 'ACCOUNT';
			case 'home.drawer_info': return 'INFO';
			case 'home.drawer_about': return 'About WaslaQ';
			case 'home.drawer_contact': return 'Contact Us';
			case 'home.drawer_feedback': return 'Feedback';
			case 'home.drawer_legal': return 'LEGAL';
			case 'home.trending_discussions': return 'Trending Discussions';
			case 'home.more_products': return 'More Products';
			case 'footer.privacy_policy': return 'Privacy Policy';
			case 'footer.terms_of_use': return 'Terms of Use';
			case 'footer.refund_policy': return 'Refund & Return Policy';
			case 'footer.customer_service': return 'Customer Service';
			case 'footer.company': return 'Company';
			case 'footer.feedback': return 'Feedback';
			case 'footer.contact_us': return 'Contact Us';
			case 'footer.about_us': return 'About Us';
			case 'footer.get_the_app': return 'Get the App';
			case 'footer.coming_soon': return 'Coming soon on Android & iOS';
			case 'footer.made_in_palestine': return 'Made in Palestine';
			case 'footer.all_rights': return 'All rights reserved';
			case 'community_settings.title': return 'إعدادات المجتمع';
			case 'community_settings.general_tab': return 'عام';
			case 'community_settings.appearance_tab': return 'المظهر';
			case 'community_settings.privacy_tab': return 'الخصوصية';
			case 'community_settings.rules_tab': return 'القواعد';
			case 'community_settings.community_title': return 'عنوان المجتمع';
			case 'community_settings.description': return 'الوصف / السيرة الذاتية';
			case 'community_settings.community_icon': return 'رمز المجتمع';
			case 'community_settings.community_banner': return 'لافتة المجتمع';
			case 'community_settings.upload_icon': return 'رمز التحميل';
			case 'community_settings.upload_image': return 'تحميل صورة';
			case 'community_settings.choose_color': return 'اختر اللون';
			case 'community_settings.save_appearance': return 'حفظ المظهر';
			case 'community_settings.save_general': return 'حفظ الإعدادات العامة';
			case 'community_settings.save_privacy': return 'حفظ إعدادات الخصوصية';
			case 'community_settings.save_rules': return 'حفظ القواعد';
			case 'community_settings.private_community': return 'مجتمع خاص';
			case 'community_settings.private_description': return 'لا يمكن إلا للأعضاء المعتمدين عرض المحتوى ونشره';
			case 'community_settings.community_rules': return 'قواعد المجتمع';
			case 'community_settings.rules_placeholder': return 'قواعد منفصلة مع فواصل أسطر مزدوجة...';
			case 'community_settings.danger_zone': return 'منطقة الخطر';
			case 'community_settings.danger_description': return 'إجراءات لا رجعة فيها قريبًا';
			case 'community_settings.manage_community': return 'إدارة المجتمع';
			case 'community_settings.members': return 'الأعضاء';
			case 'community_settings.remove': return 'إزالة';
			case 'community_settings.joined': return 'انضم';
			case 'community_settings.back_to_community': return 'العودة إلى r/';
			case 'feedback.title': return 'إرسال ملاحظات';
			case 'feedback.subtitle': return 'ساعدنا في تحسين WaslaQ';
			case 'feedback.full_name': return 'الاسم الكامل';
			case 'feedback.email': return 'عنوان البريد الإلكتروني';
			case 'feedback.about': return 'ما هو الموضوع؟';
			case 'feedback.message': return 'رسالة';
			case 'feedback.submit': return 'إرسال ملاحظات';
			case 'feedback.submitting': return 'جاري الإرسال...';
			case 'contact.title': return 'اتصل بنا';
			case 'contact.subtitle': return 'سنقوم بالرد عليك في أقرب وقت ممكن';
			case 'contact.subject': return 'الموضوع (اختياري)';
			case 'contact.submit': return 'إرسال رسالة';
			case 'contact.submitting': return 'جاري الإرسال...';
			case 'about.title': return 'نبذة عن WaslaQ';
			case 'about.tagline': return 'السوق الاجتماعي الفلسطيني';
			case 'about.our_mission': return 'مهمتنا';
			case 'about.how_it_works': return 'كيف يعمل';
			case 'about.secure_escrow': return 'حساب ضمان آمن';
			case 'about.mission_body': return '"WaslaQ" هي أول منصة تسويق اجتماعية مختلطة في فلسطين — تجمع بين قوة النقاش المجتمعي والتجارة الإلكترونية الموثوقة. نحن نربط بين المشترين والبائعين الفلسطينيين في بيئة آمنة ومحمية بنظام الضمان، حيث تكون كل معاملة آمنة ويتم الاستماع إلى كل صوت.';
			case 'about.local_vendors_title': return 'البائعون المحليون';
			case 'about.local_vendors_desc': return 'تسوق مباشرة من بائعين فلسطينيين معتمدين.';
			case 'about.community_first_title': return 'المجتمع أولاً';
			case 'about.community_first_desc': return 'ناقش، واطلع على التقييمات، وتواصل مع المشترين الآخرين.';
			case 'about.escrow_desc': return 'يتم الاحتفاظ بأموالك في أمان حتى تؤكد استلامها.';
			case 'about.our_values': return 'قيمنا';
			case 'about.value_community': return 'المجتمع';
			case 'about.value_transparency': return 'الشفافية';
			case 'about.value_trust': return 'الثقة';
			case 'about.value_palestine': return 'فلسطين أولاً';
			case 'disutes.title': return 'نزاعاتي';
			case 'disutes.cases_count': return 'الحالات';
			case 'disutes.no_disputes': return 'لم يتم العثور على أي نزاعات';
			case 'disutes.all_good': return 'جميع طلباتك سارية المفعول';
			case 'user_profile.followers': return 'Followers';
			case 'user_profile.following': return 'Following';
			case 'user_profile.visit_store': return 'Visit Store';
			case 'user_profile.media_tab': return 'Media';
			case 'user_profile.replies_tab': return 'Replies';
			case 'user_profile.posts_tab': return 'Posts';
			case 'user_profile.no_replies': return 'No replies yet';
			case 'user_profile.edit_profile': return 'Edit Profile';
			case 'user_profile.failed_load': return 'Failed to load profile';
			case 'user_profile.view_store': return 'View Store';
			case 'user_profile.no_posts_yet': return 'No posts yet';
			case 'user_profile.coming_soon': return 'Coming soon';
			case 'user_profile.stats': return ({required Object followers, required Object posts}) => '${followers} Followers  ·  ${posts} Posts';
			case 'account_dropdown.signed_in_as': return 'Signed in as';
			case 'account_dropdown.my_profile': return 'My Profile';
			case 'account_dropdown.account_dashboard': return 'Account Dashboard';
			case 'account_dropdown.vendor_dashboard': return 'Vendor Dashboard';
			case 'account_dropdown.language': return 'Language';
			case 'account_dropdown.log_out': return 'Log Out';
			case 'account_dropdown.welcome': return 'Welcome!';
			case 'account_dropdown.welcome_hint': return 'Sign in to sync your saved items and track your orders.';
			case 'account_dropdown.login': return 'Sign In';
			case 'account_dropdown.register': return 'Register';
			case 'vendor_dashboard.title': return 'Vendor Dashboard';
			case 'vendor_dashboard.products_tab': return 'Products';
			case 'vendor_dashboard.orders_tab': return 'Orders';
			case 'vendor_dashboard.overview_tab': return 'Overview';
			case 'vendor_dashboard.live_badge': return 'Live';
			case 'vendor_dashboard.hours_ago': return ({required Object count}) => '${count}h ago';
			case 'vendor_dashboard.days_ago': return ({required Object count}) => '${count}d ago';
			case 'vendor_dashboard.order_number': return ({required Object id}) => 'Order #${id}';
			case 'vendor_dashboard.performance_summary': return 'Performance summary (last 7 days)';
			case 'vendor_dashboard.profit_7d': return 'Profit (7d)';
			case 'vendor_dashboard.revenue_7d': return 'Revenue (7d)';
			case 'vendor_dashboard.after_fees': return 'After fees';
			case 'vendor_dashboard.orders_count': return 'Orders';
			case 'vendor_dashboard.pending': return 'Pending';
			case 'vendor_dashboard.available': return 'Available';
			case 'vendor_dashboard.awaiting_release': return 'Awaiting Release';
			case 'vendor_dashboard.withdraw_any': return 'Withdraw';
			case 'vendor_dashboard.qa_inbox_tab': return 'Q&A Inbox';
			case 'vendor_dashboard.finances_tab': return 'Finances';
			case 'vendor_dashboard.policies_tab': return 'Policies';
			case 'vendor_dashboard.settings_tab': return 'Settings';
			case 'vendor_dashboard.disputes': return 'Disputes';
			case 'vendor_dashboard.all_clear': return 'All clear';
			case 'vendor_dashboard.live_listings': return 'Live listings';
			case 'vendor_dashboard.pending_desc': return 'Funds in escrow, awaiting inspection period before release.';
			case 'vendor_dashboard.available_desc': return 'Funds released from escrow and ready to withdraw to your bank account.';
			case 'vendor_dashboard.qa_inbox_heading': return 'Q&A Inbox';
			case 'vendor_dashboard.no_questions': return 'No questions yet. They will appear here when customers ask.';
			case 'vendor_dashboard.orders_7d': return 'Orders (7d)';
			case 'vendor_dashboard.open_disputes': return 'Open Disputes';
			case 'vendor_dashboard.in_escrow': return ({required Object amount}) => '${amount} in escrow';
			case 'vendor_dashboard.recent_orders': return 'Recent Orders';
			case 'vendor_dashboard.order_marked_shipped': return 'Order marked as shipped ✅';
			case 'vendor_dashboard.marking': return 'Marking...';
			case 'vendor_dashboard.mark_as_shipped': return 'Mark as Shipped';
			case 'vendor_dashboard.ship_to': return ({required Object name}) => 'Ship to: ${name}';
			case 'vendor_dashboard.qty_price': return ({required Object qty, required Object price}) => 'Qty: ${qty} · ₪${price}';
			case 'vendor_dashboard.no_products_yet': return 'No products yet.\nTap + to add your first product.';
			case 'vendor_dashboard.add_product': return 'Add Product';
			case 'vendor_dashboard.edit_product': return 'Edit Product';
			case 'vendor_dashboard.title_required': return 'Title is required';
			case 'vendor_dashboard.virtual_require_file': return 'Virtual products require a file or URL';
			case 'vendor_dashboard.title_label': return 'Title *';
			case 'vendor_dashboard.price_ils_label': return 'Price (ILS) *';
			case 'vendor_dashboard.type_label': return 'Type:';
			case 'vendor_dashboard.digital_file_url': return 'Digital File URL *';
			case 'vendor_dashboard.upload_file_instead': return 'Upload File Instead';
			case 'vendor_dashboard.file_selected': return ({required Object filename}) => 'File selected: ${filename}';
			case 'vendor_dashboard.digital_hint': return 'Paste a direct link or upload the digital file (PDF, ZIP, MP3, etc.)';
			case 'vendor_dashboard.select_category': return 'Select category';
			case 'vendor_dashboard.sku_optional': return 'SKU (Optional)';
			case 'vendor_dashboard.manage_inventory': return 'Manage Inventory';
			case 'vendor_dashboard.inventory_quantity': return 'Inventory Quantity';
			case 'vendor_dashboard.create_product': return 'Create Product';
			case 'vendor_dashboard.price_ils': return 'Price (ILS)';
			case 'vendor_dashboard.delete_product': return 'Delete Product';
			case 'vendor_dashboard.delete_confirm': return ({required Object title}) => 'Delete "${title}"? This cannot be undone.';
			case 'vendor_dashboard.inventory_untracked': return 'Inventory: untracked';
			case 'vendor_dashboard.stock_count': return ({required Object count}) => 'Stock: ${count}';
			case 'vendor_dashboard.add': return 'Add';
			case 'vendor_dashboard.total_earned': return 'Total Earned';
			case 'vendor_dashboard.paid_out': return 'Paid Out';
			case 'vendor_dashboard.payout_to': return ({required Object account}) => 'Payout to: ${account}';
			case 'vendor_dashboard.request_withdrawal': return 'Request Withdrawal';
			case 'vendor_dashboard.invalid_amount': return 'Enter a valid amount';
			case 'vendor_dashboard.amount_exceeds': return ({required Object balance}) => 'Amount exceeds available balance (₪${balance})';
			case 'vendor_dashboard.payout_submitted': return 'Payout request submitted! Admin will process it shortly.';
			case 'vendor_dashboard.amount_ils': return 'Amount (ILS)';
			case 'vendor_dashboard.withdraw': return 'Withdraw';
			case 'vendor_dashboard.payout_hint': return 'Payout will be sent to your registered bank account.';
			case 'vendor_dashboard.payout_history': return 'Payout History';
			case 'vendor_dashboard.transaction_ledger': return 'Transaction Ledger';
			case 'vendor_dashboard.re_product': return ({required Object title}) => 'Re: ${title}';
			case 'vendor_dashboard.public': return 'Public';
			case 'vendor_dashboard.private': return 'Private';
			case 'vendor_dashboard.your_answer': return 'Your Answer';
			case 'vendor_dashboard.edit_answer': return 'Edit answer';
			case 'vendor_dashboard.type_answer_placeholder': return 'Type your answer...';
			case 'vendor_dashboard.store_policies': return 'Store Policies';
			case 'vendor_dashboard.policies_hint': return 'Each save creates a new version. Previous versions are kept for audit.';
			case 'vendor_dashboard.saved_version': return ({required Object version}) => 'Saved as version v${version} ✅';
			case 'vendor_dashboard.shipping_policy': return 'Shipping Policy';
			case 'vendor_dashboard.shipping_hint': return 'How do you ship? Expected delivery times?';
			case 'vendor_dashboard.refund_policy': return 'Refund Policy';
			case 'vendor_dashboard.refund_hint': return 'What is your refund process?';
			case 'vendor_dashboard.return_policy': return 'Return Policy';
			case 'vendor_dashboard.return_hint': return 'What are your return conditions?';
			case 'vendor_dashboard.privacy_hint': return 'How do you handle customer data?';
			case 'vendor_dashboard.terms_hint': return 'Terms and conditions for buyers.';
			case 'vendor_dashboard.save_policies': return 'Save Policies';
			case 'vendor_dashboard.store_settings': return 'Store Settings';
			case 'vendor_dashboard.store_logo': return 'Store Logo';
			case 'vendor_dashboard.change_logo': return 'Change Logo';
			case 'vendor_dashboard.store_banner': return 'Store Banner';
			case 'vendor_dashboard.add_store_banner': return 'Add Store Banner';
			case 'vendor_dashboard.store_name_required': return 'Store name is required';
			case 'vendor_dashboard.slug_label': return 'Slug (URL)';
			case 'vendor_dashboard.contact_email': return 'Contact Email';
			case 'vendor_dashboard.payout_iban': return 'Payout IBAN / Account ID';
			case 'vendor_dashboard.settings_saved': return 'Settings saved ✅';
			case 'vendor_dashboard.save_settings': return 'Save Settings';
			case 'vendor_dashboard.resolved_refund': return 'Resolved – Refunded';
			case 'vendor_dashboard.resolved_release': return 'Resolved – Released';
			case 'vendor_dashboard.respond_to_dispute': return 'Respond to Dispute';
			case 'vendor_dashboard.response_empty': return 'Response cannot be empty';
			case 'vendor_dashboard.your_response': return 'Your Response';
			case 'vendor_dashboard.explain_side_placeholder': return 'Explain your side of the dispute...';
			case 'vendor_dashboard.submit_response': return 'Submit Response';
			case 'vendor_dashboard.resolved_date': return ({required Object date}) => 'Resolved: ${date}';
			case 'vendor_dashboard.opened_date': return ({required Object date}) => 'Opened: ${date}';
			case 'vendor_dashboard.update_response': return 'Update Response';
			case 'vendor_dashboard.respond': return 'Respond';
			case 'vendor_dashboard.no_disputes_hint': return 'No disputes.\nAll your orders are running smoothly! ✅';
			case 'notifications_settings.title': return 'الإشعارات';
			case 'notifications_settings.mark_all_read': return 'وضع علامة "تمت قراءتها" على كل الرسائل';
			case 'notifications_settings.new_followers': return 'متابعون جدد';
			case 'notifications_settings.comments': return 'التعليقات على منشوراتك';
			case 'notifications_settings.upvotes': return 'التصويتات الإيجابية على منشوراتك';
			case 'notifications_settings.mentions': return 'الإشارات';
			case 'notifications_settings.follow_requests': return 'طلبات المتابعة';
			case 'saved.title': return 'العناصر المحفوظة';
			case 'saved.subtitle': return 'اعرض المنتجات والمنشورات والتعليقات التي قمت بحفظها في مكان واحد';
			case 'saved.comments_tab': return 'التعليقات';
			case 'saved.posts_tab': return 'المشاركات';
			case 'saved.products_tab': return 'المنتجات';
			case 'saved.no_products': return 'لم يتم حفظ أي منتجات حتى الآن';
			case 'saved.no_products_hint': return 'انقر على أيقونة القلب الموجودة على أي منتج لإضافته إلى قائمة المفضلة';
			case 'search.no_results': return 'No results found';
			case 'search.no_results_hint': return 'Make sure the name is written correctly and try again';
			case 'search.go_home': return 'Go to Home';
			case 'search.see_all_results': return 'See all results for';
			case 'search.placeholder': return 'Search products, stores, communities...';
			case 'search.initial_title': return 'Search for products, stores,';
			case 'search.initial_subtitle': return 'communities and users';
			case 'search.no_results_query': return ({required Object query}) => 'No results for "${query}"';
			case 'search.try_different': return 'Try a different search term';
			case 'search.products': return 'Products';
			case 'search.vendor_stores': return 'Vendor Stores';
			case 'search.communities': return 'Communities';
			case 'search.users': return 'Users';
			case 'search.posts': return 'Posts';
			case 'search.type_product': return 'Product';
			case 'search.type_store': return 'Store';
			case 'search.type_community': return 'Community';
			case 'search.type_user': return 'User';
			case 'search.type_post': return 'Post';
			case 'search.post_author_votes': return ({required Object author, required Object score}) => 'by u/${author} · ${score} votes';
			case 'cart.title': return 'Cart';
			case 'cart.empty_message': return 'There are no products in your shopping cart.';
			case 'cart.explore_products': return 'Explore Products';
			case 'cart.could_not_load': return 'Could not load cart';
			case 'cart.empty_title': return 'Your cart is empty';
			case 'cart.start_shopping': return 'Start Shopping';
			case 'cart.subtotal': return 'Subtotal';
			case 'cart.shipping': return 'Shipping';
			case 'cart.discount': return 'Discount';
			case 'cart.total': return 'Total';
			case 'cart.proceed_to_checkout': return 'Proceed to Checkout';
			case 'settings.profile_tab': return 'الملف الشخصي';
			case 'settings.account_tab': return 'الحساب';
			case 'settings.privacy_tab': return 'الخصوصية';
			case 'settings.notifications_tab': return 'الإشعارات';
			case 'settings.banner': return 'لافتة';
			case 'settings.avatar': return 'أفاتار';
			case 'settings.bio': return 'السيرة الذاتية';
			case 'settings.location': return 'المدينة / البلد';
			case 'settings.website': return 'الموقع الإلكتروني';
			case 'settings.gender': return 'النوع الاجتماعي';
			case 'settings.hobbies': return 'الهوايات';
			case 'settings.social_links': return 'روابط مواقع التواصل الاجتماعي';
			case 'settings.avatar_gallery': return 'اختر من معرض الصور الرمزية';
			case 'settings.upload_photo': return 'تحميل صورة';
			case 'settings.change_color': return 'تغيير اللون';
			case 'settings.upload_image': return 'تحميل صورة';
			case 'settings.prefer_not_say': return 'أفضل عدم الإفصاح';
			case 'settings.character_count': return 'الشخصية:';
			case 'settings.current_username': return 'الحالي:';
			case 'settings.username_once_per_year': return 'لا يمكنك تغيير اسم المستخدم الخاص بك إلا مرة واحدة في السنة';
			case 'settings.send_reset_link': return 'إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني';
			case 'settings.reset_link_button': return 'إرسال رابط إعادة الضبط';
			case 'settings.connected': return 'متصل';
			case 'settings.permanent_action': return 'هذه العملية نهائية ولا يمكن التراجع عنها';
			case 'settings.delete_account': return 'حذف حسابي';
			case 'settings.page_title': return 'الإعدادات';
			case 'settings.nav_profile': return 'الملف الشخصي';
			case 'settings.nav_account': return 'الحساب';
			case 'settings.nav_privacy': return 'الخصوصية';
			case 'settings.nav_notifications': return 'الإشعارات';
			case 'settings.private_account_desc': return 'لا يمكن إلا للمتابعين المعتمدين رؤية منشوراتك';
			case 'settings.activity_status_desc': return 'اسمح للآخرين بمعرفة متى تكون متصلاً';
			case 'settings.notif_new_followers': return 'متابعون جدد';
			case 'settings.notif_new_followers_desc': return 'عندما يتابعك شخص ما';
			case 'settings.notif_comments': return 'التعليقات على منشوراتك';
			case 'settings.notif_comments_desc': return 'عندما يعلق أحدهم';
			case 'settings.notif_upvotes': return 'التصويت الإيجابي على منشوراتك';
			case 'settings.notif_upvotes_desc': return 'عندما يصوّت أحدهم بالموافقة';
			case 'settings.notif_mentions': return 'الإشارات';
			case 'settings.notif_mentions_desc': return 'عندما يذكرك أحدهم';
			case 'settings.notif_follow_requests': return 'طلبات المتابعة';
			case 'settings.notif_follow_requests_desc': return 'عندما يطلب شخص ما متابعتك';
			case 'settings.notif_note': return 'ملاحظة: سيتم تفعيل خدمة إرسال الإشعارات بالكامل بمجرد توصيل نظام الإشعارات.';
			case 'settings.city_country': return 'المدينة / البلد';
			case 'settings.city_placeholder': return 'على سبيل المثال: رام الله، فلسطين';
			case 'settings.hobbies_hint': return 'اضغط على مفتاح Enter لإضافة';
			case 'settings.hobbies_placeholder': return 'على سبيل المثال: التصوير الفوتوغرافي، والألعاب';
			case 'settings.save_profile': return 'حفظ الملف الشخصي';
			case 'settings.title': return 'Settings';
			case 'settings.profile_section': return 'Profile';
			case 'settings.notifications_section': return 'Notifications';
			case 'settings.about_section': return 'About';
			case 'settings.edit_display_name': return 'Edit Display Name';
			case 'settings.not_set': return 'Not set';
			case 'settings.edit_bio': return 'Edit Bio';
			case 'settings.bio_subtitle': return 'Tell others about yourself';
			case 'settings.username_label': return 'Username';
			case 'settings.username_subtitle': return 'Cannot be changed after signup';
			case 'settings.push_notifications': return 'Push Notifications';
			case 'settings.push_notifications_subtitle': return 'Enable all push notifications';
			case 'settings.order_updates': return 'Order Updates';
			case 'settings.order_updates_subtitle': return 'Shipping, delivery, and payout alerts';
			case 'settings.social_activity': return 'Social Activity';
			case 'settings.social_activity_subtitle': return 'Likes, comments, follows, replies';
			case 'settings.promotions': return 'Promotions';
			case 'settings.promotions_subtitle': return 'Deals and offers from vendors';
			case 'settings.app_version': return 'App Version';
			case 'settings.terms_label': return 'Terms of Service';
			case 'settings.privacy_label': return 'Privacy Policy';
			case 'settings.contact_support': return 'Contact Support';
			case 'settings.display_name_dialog': return 'Display Name';
			case 'settings.bio_dialog': return 'Bio';
			case 'settings.enter_display_name_hint': return 'Enter your display name';
			case 'settings.bio_hint': return 'Write a short bio...';
			case 'settings.cancel': return 'Cancel';
			case 'settings.save': return 'Save';
			case 'settings.saved_ok': return 'Saved successfully';
			case 'settings.save_failed': return ({required Object error}) => 'Failed to save: ${error}';
			case 'settings.hub_profile': return 'Profile';
			case 'settings.hub_profile_sub': return 'Avatar, bio, social links';
			case 'settings.hub_account': return 'Account & Security';
			case 'settings.hub_account_sub': return 'Email, password, biometric lock';
			case 'settings.hub_address': return 'Address Book';
			case 'settings.hub_address_sub': return 'Palestine delivery addresses';
			case 'settings.hub_refund': return 'Refund Details';
			case 'settings.hub_refund_sub': return 'Bank details for dispute refunds';
			case 'settings.hub_privacy': return 'Privacy & Safety';
			case 'settings.hub_privacy_sub': return 'Visibility, blocked users, follow requests';
			case 'settings.hub_notifications': return 'Notifications';
			case 'settings.hub_notifications_sub': return 'Push, orders, social alerts';
			case 'settings.hub_content': return 'Content & Feed';
			case 'settings.hub_content_sub': return 'Language filter, muted words';
			case 'settings.hub_appearance': return 'Appearance & Language';
			case 'settings.hub_appearance_sub': return 'Theme, language, font, accessibility';
			case 'settings.hub_storage': return 'Storage & Performance';
			case 'settings.hub_storage_sub': return 'Cache, data usage';
			case 'settings.hub_vendor': return 'Vendor Settings';
			case 'settings.hub_vendor_sub': return 'Vacation mode, delivery zones';
			case 'settings.hub_app': return 'App';
			case 'settings.hub_app_sub': return 'Share, rate, permissions, version';
			case 'settings.hub_support': return 'Support & Escrow';
			case 'settings.hub_support_sub': return 'Help, disputes, legal';
			case 'settings.appearance_title': return 'Appearance & Language';
			case 'settings.lang_section': return 'Language';
			case 'settings.lang_app_label': return 'App Language';
			case 'settings.theme_section': return 'Theme';
			case 'settings.theme_light': return 'Light Theme';
			case 'settings.theme_dark': return 'Dark Theme';
			case 'settings.theme_system': return 'Follow System';
			case 'settings.text_size_section': return 'Text Size';
			case 'settings.text_adjust_label': return 'Adjust Font Scale';
			case 'settings.text_preview_label': return 'Live Preview:';
			case 'settings.text_small': return 'Small';
			case 'settings.text_normal': return 'Normal';
			case 'settings.text_large': return 'Large';
			case 'settings.text_xlarge': return 'Extra Large';
			case 'settings.arabic_font_section': return 'Arabic Font';
			case 'settings.font_default': return 'System Default';
			case 'settings.font_cairo': return 'Cairo';
			case 'settings.font_tajawal': return 'Tajawal';
			case 'settings.font_almarai': return 'Almarai';
			case 'settings.accessibility_section': return 'Accessibility';
			case 'settings.bold_text': return 'Bold Text';
			case 'settings.reduce_anim': return 'Reduce Animations';
			case 'settings.reduce_anim_sub': return 'Recommended for older devices or motion sensitivity';
			case 'settings.notif_push_enabled': return 'Alerts are configured on this device';
			case 'settings.notif_push_disabled': return 'Alerts are disabled';
			case 'settings.notif_enabled_chip': return 'Enabled';
			case 'settings.notif_disabled_chip': return 'Disabled';
			case 'settings.notif_open_settings_btn': return 'Open Settings';
			case 'settings.notif_social_section': return 'Social Notifications';
			case 'settings.notif_commerce_section': return 'Commerce Notifications';
			case 'settings.notif_community_label': return 'Community Notifications';
			case 'settings.notif_all': return 'All';
			case 'settings.notif_mentions_only': return 'Mentions Only';
			case 'settings.notif_off': return 'Off';
			case 'settings.notif_order_confirmed': return 'Order Confirmed';
			case 'settings.notif_order_shipped': return 'Order Shipped';
			case 'settings.notif_order_delivered': return 'Order Delivered';
			case 'settings.notif_refund_processed': return 'Refund Processed';
			case 'settings.notif_price_drop': return 'Price Drop Alerts';
			case 'settings.notif_back_in_stock': return 'Back in Stock Alerts';
			case 'settings.notif_vendor_section': return 'Vendor Notifications';
			case 'settings.notif_order_sound': return 'New Order Alert Sound';
			case 'settings.notif_order_sound_sub': return 'Play a loud alert sound for every new order';
			case 'settings.notif_daily_summary': return 'Daily Sales Summary';
			case 'settings.notif_daily_summary_sub': return 'Get a morning summary of yesterday\'s sales';
			case 'settings.notif_general_section': return 'General & System';
			case 'settings.notif_promotions_toggle': return 'Promotions';
			case 'settings.notif_login_alerts': return 'Login Alerts';
			case 'settings.notif_login_alerts_sub': return 'Get notified when account signs in on new device';
			case 'settings.notif_manage_channels': return 'Open Notification Settings';
			case 'settings.notif_manage_channels_sub': return 'Manage notification channels for this app';
			case 'settings.account_screen_title': return 'Account & Security';
			case 'settings.account_email_label': return 'Email Address';
			case 'settings.account_password_label': return 'Password';
			case 'settings.account_password_sub': return 'Send a reset link to your email';
			case 'settings.account_connected_label': return 'Connected Accounts';
			case 'settings.account_biometric': return 'Biometric Lock';
			case 'settings.account_biometric_sub': return 'Require fingerprint or Face ID to open WaslaQ';
			case 'settings.account_purchase_confirm': return 'Purchase Confirmation';
			case 'settings.account_purchase_confirm_sub': return 'Require biometric before completing any purchase';
			case 'settings.account_login_notif': return 'Login Notifications';
			case 'settings.account_login_notif_sub': return 'Get notified when your account signs in from a new device';
			case 'settings.privacy_screen_title': return 'Privacy & Safety';
			case 'settings.privacy_account_section': return 'Account Privacy';
			case 'settings.privacy_private_account': return 'Private Account';
			case 'settings.privacy_private_account_sub': return 'Only approved followers can see your posts';
			case 'settings.privacy_messaging_section': return 'Messaging & Chat';
			case 'settings.privacy_read_receipts': return 'Read Receipts';
			case 'settings.privacy_read_receipts_sub': return 'Show read receipts (✓✓) in conversations';
			case 'settings.privacy_activity_status': return 'Show Activity Status';
			case 'settings.privacy_blocked_section': return 'Blocked Users';
			case 'settings.privacy_follow_req_section': return 'Follow Requests';
			case 'settings.content_screen_title': return 'Content & Feed';
			case 'settings.content_feed_lang_section': return 'Feed Language';
			case 'settings.content_muted_section': return 'Muted Keywords';
			case 'settings.content_posts_section': return 'Posts';
			case 'settings.content_feed_section': return 'Feed Behavior';
			case 'settings.content_default_visibility': return 'Default Post Visibility';
			case 'settings.content_vendor_section': return 'Vendor Settings';
			case 'settings.storage_screen_title': return 'Storage & Performance';
			case 'settings.storage_image_section': return 'Image Cache';
			case 'settings.storage_recent_section': return 'Recently Viewed';
			case 'settings.storage_dev_section': return 'Developer Settings';
			case 'settings.support_screen_title': return 'Support & Escrow';
			case 'settings.support_help_section': return 'Get Help';
			case 'settings.support_legal_section': return 'Legal';
			case 'settings.support_escrow_section': return 'Escrow & Disputes';
			case 'settings.support_contact': return 'Contact Support';
			case 'settings.support_contact_sub': return 'Talk to a WaslaQ support agent';
			case 'settings.support_report_bug': return 'Report a Bug';
			case 'settings.support_report_sub': return 'Help us improve the app by reporting issues';
			case 'settings.support_terms': return 'Terms of Use';
			case 'settings.support_privacy_policy': return 'Privacy Policy';
			case 'settings.app_screen_title': return 'App Information';
			case 'settings.app_share_section': return 'Share & Feedback';
			case 'settings.app_about_section': return 'About';
			case 'settings.app_share_waslaq': return 'Share WaslaQ';
			case 'settings.app_share_sub': return 'Tell your friends about the Palestinian marketplace';
			case 'settings.app_rate': return 'Rate WaslaQ';
			case 'settings.app_rate_sub': return 'Leave a review on the store';
			case 'settings.app_permissions': return 'App Permissions';
			case 'settings.app_permissions_sub': return 'Manage storage, camera, and notification permissions';
			case 'settings.profile_screen_title': return 'Profile Settings';
			case 'settings.address_screen_title': return 'Address Book';
			case 'settings.refund_screen_title': return 'Refund Details';
			case 'settings.vendor_screen_title': return 'Vendor Settings';
			case 'settings.vendor_store_status_section': return 'Store Status';
			case 'settings.vendor_delivery_section': return 'Delivery Zones';
			case 'settings.vendor_notif_section': return 'Notifications';
			case 'settings.hubProfile': return 'Profile';
			case 'settings.hubProfileSub': return 'Edit your profile information';
			case 'settings.hubAccount': return 'Account & Security';
			case 'settings.hubAccountSub': return 'Password, email and account settings';
			case 'settings.hubAddress': return 'Addresses';
			case 'settings.hubAddressSub': return 'Manage your delivery addresses';
			case 'settings.hubRefund': return 'Refund Details';
			case 'settings.hubRefundSub': return 'Bank account for refunds';
			case 'settings.hubPrivacy': return 'Privacy';
			case 'settings.hubPrivacySub': return 'Control who sees your content';
			case 'settings.hubNotifications': return 'Notifications';
			case 'settings.hubNotificationsSub': return 'Manage your notification preferences';
			case 'settings.hubContent': return 'Content';
			case 'settings.hubContentSub': return 'Language and content preferences';
			case 'settings.hubAppearance': return 'Appearance';
			case 'settings.hubAppearanceSub': return 'Theme and display settings';
			case 'settings.hubStorage': return 'Storage';
			case 'settings.hubStorageSub': return 'Cache and data management';
			case 'settings.hubVendor': return 'Vendor Settings';
			case 'settings.hubVendorSub': return 'Manage your store settings';
			case 'settings.hubApp': return 'App Info';
			case 'settings.hubAppSub': return 'Version and about';
			case 'settings.hubSupport': return 'Support';
			case 'settings.hubSupportSub': return 'Help and contact us';
			case 'settings.deleteAccount': return 'Delete Account';
			case 'settings.permanentAction': return 'This action is permanent and cannot be undone';
			case 'settings.accountScreenTitle': return 'Account & Security';
			case 'settings.accountEmailLabel': return 'Email Address';
			case 'settings.notSet': return 'Not set';
			case 'settings.accountPasswordLabel': return 'Password';
			case 'settings.accountPasswordSub': return 'Change your password';
			case 'settings.resetLinkButton': return 'Send Reset Link';
			case 'settings.accountConnectedLabel': return 'Connected Account';
			case 'settings.accountBiometric': return 'Biometric Login';
			case 'settings.accountBiometricSub': return 'Use fingerprint or face to sign in';
			case 'settings.accountLoginNotif': return 'Login Notifications';
			case 'settings.accountLoginNotifSub': return 'Get notified of new sign-ins';
			case 'settings.accountPurchaseConfirm': return 'Purchase Confirmation';
			case 'settings.accountPurchaseConfirmSub': return 'Require confirmation before purchasing';
			case 'settings.addressScreenTitle': return 'Addresses';
			case 'settings.refundScreenTitle': return 'Refund Details';
			case 'settings.privacyScreenTitle': return 'Privacy';
			case 'settings.privacyAccountSection': return 'Account Privacy';
			case 'settings.privacyPrivateAccount': return 'Private Account';
			case 'settings.privacyPrivateAccountSub': return 'Only approved followers see your posts';
			case 'settings.privacyFollowReqSection': return 'Follow Requests';
			case 'settings.privacyActivityStatus': return 'Activity Status';
			case 'settings.privacyMessagingSection': return 'Messaging';
			case 'settings.privacyReadReceipts': return 'Read Receipts';
			case 'settings.privacyReadReceiptsSub': return 'Let others know when you\'ve read their messages';
			case 'settings.privacyBlockedSection': return 'Blocked Users';
			case 'settings.notifAll': return 'All';
			case 'settings.notifMentionsOnly': return 'Mentions Only';
			case 'settings.notifOff': return 'Off';
			case 'settings.notifEnabledChip': return 'Enabled';
			case 'settings.notifDisabledChip': return 'Disabled';
			case 'settings.notifPushEnabled': return 'Push notifications are enabled';
			case 'settings.notifPushDisabled': return 'Push notifications are disabled';
			case 'settings.notifOpenSettingsBtn': return 'Open Settings';
			case 'settings.notifGeneralSection': return 'General';
			case 'settings.notifSocialSection': return 'Social';
			case 'settings.notifCommerceSection': return 'Shopping';
			case 'settings.notifVendorSection': return 'Vendor';
			case 'settings.notifComments': return 'Comments';
			case 'settings.notifUpvotes': return 'Upvotes';
			case 'settings.notifMentions': return 'Mentions';
			case 'settings.notifNewFollowers': return 'New Followers';
			case 'settings.notifFollowRequests': return 'Follow Requests';
			case 'settings.notifLoginAlerts': return 'Login Alerts';
			case 'settings.notifLoginAlertsSub': return 'Notify me of new sign-ins';
			case 'settings.notifDailySummary': return 'Daily Summary';
			case 'settings.notifDailySummarySub': return 'Get a daily digest of activity';
			case 'settings.notifOrderConfirmed': return 'Order Confirmed';
			case 'settings.notifOrderShipped': return 'Order Shipped';
			case 'settings.notifOrderDelivered': return 'Order Delivered';
			case 'settings.notifRefundProcessed': return 'Refund Processed';
			case 'settings.notifBackInStock': return 'Back in Stock';
			case 'settings.notifPriceDrop': return 'Price Drop';
			case 'settings.notifPromotionsToggle': return 'Promotions';
			case 'settings.notifOrderSound': return 'Order Sound';
			case 'settings.notifOrderSoundSub': return 'Play a sound for new orders';
			case 'settings.notifManageChannels': return 'Manage Channels';
			case 'settings.notifManageChannelsSub': return 'Control notification channels';
			case 'settings.pushNotifications': return 'Push Notifications';
			case 'settings.contentScreenTitle': return 'Content';
			case 'settings.contentFeedSection': return 'Feed';
			case 'settings.contentFeedLangSection': return 'Feed Language';
			case 'settings.contentPostsSection': return 'Posts';
			case 'settings.contentMutedSection': return 'Muted';
			case 'settings.contentVendorSection': return 'Vendors';
			case 'settings.langSection': return 'Language';
			case 'settings.langAppLabel': return 'App Language';
			case 'settings.appearanceTitle': return 'Appearance';
			case 'settings.themeSection': return 'Theme';
			case 'settings.themeLight': return 'Light';
			case 'settings.themeDark': return 'Dark';
			case 'settings.themeSystem': return 'System Default';
			case 'settings.textSizeSection': return 'Text Size';
			case 'settings.textAdjustLabel': return 'Adjust Text Size';
			case 'settings.textPreviewLabel': return 'Preview';
			case 'settings.textSmall': return 'Small';
			case 'settings.textNormal': return 'Normal';
			case 'settings.textLarge': return 'Large';
			case 'settings.textXlarge': return 'X-Large';
			case 'settings.boldText': return 'Bold Text';
			case 'settings.reduceAnim': return 'Reduce Animations';
			case 'settings.reduceAnimSub': return 'Minimize motion effects';
			case 'settings.arabicFontSection': return 'Arabic Font';
			case 'settings.fontDefault': return 'Default';
			case 'settings.fontCairo': return 'Cairo';
			case 'settings.fontAlmarai': return 'Almarai';
			case 'settings.fontTajawal': return 'Tajawal';
			case 'settings.accessibilitySection': return 'Accessibility';
			case 'settings.storageScreenTitle': return 'Storage';
			case 'settings.storageImageSection': return 'Images';
			case 'settings.storageRecentSection': return 'Recent';
			case 'settings.storageDevSection': return 'Developer';
			case 'settings.vendorScreenTitle': return 'Vendor Settings';
			case 'settings.vendorStoreStatusSection': return 'Store Status';
			case 'settings.vendorDeliverySection': return 'Delivery';
			case 'settings.vendorNotifSection': return 'Notifications';
			case 'settings.appScreenTitle': return 'App Info';
			case 'settings.appAboutSection': return 'About';
			case 'settings.appShareSection': return 'Share';
			case 'settings.supportScreenTitle': return 'Support';
			case 'settings.supportHelpSection': return 'Help';
			case 'settings.supportEscrowSection': return 'Escrow & Payments';
			case 'settings.supportLegalSection': return 'Legal';
			case 'settings.notifCommunityLabel': return 'Community Notifications';
			case 'settings.currencySection': return 'Currency';
			case 'settings.currencyLabel': return 'Display currency';
			case 'settings.currencyIls': return 'Shekel (₪ ILS)';
			case 'settings.currencyIlsSub': return 'Show prices in Israeli new shekel';
			case 'settings.currencyUsd': return 'Dollar (USD)';
			case 'settings.currencyUsdSub': return 'Show converted prices in US dollar';
			case 'become_vendor.title': return 'Become a Vendor';
			case 'become_vendor.subtitle': return 'Join our platform and start selling your products.';
			case 'become_vendor.benefit1': return 'Sell physical and digital products';
			case 'become_vendor.benefit2': return 'Secure payment system via Escrow';
			case 'become_vendor.benefit3': return 'Built-in dispute protection';
			case 'become_vendor.benefit4': return 'Request to withdraw your funds at any time';
			case 'become_vendor.agree_terms': return 'I agree to the platform terms and seller policies';
			case 'become_vendor.create_account': return 'Create your account';
			case 'become_vendor.continue_google': return 'Continue with Google';
			case 'become_vendor.signup_email': return 'Sign up with Email';
			case 'become_vendor.skip_auth': return 'Already have an account? Skip this step';
			case 'become_vendor.verify_email_title': return 'Verify your email';
			case 'become_vendor.verify_email_desc': return ({required Object email}) => 'We have sent a link to ${email}. Click on it, then return here.';
			case 'become_vendor.verified_button': return 'I have verified my email';
			case 'become_vendor.setup_store': return 'Create your store';
			case 'become_vendor.store_name': return 'Store Name';
			case 'become_vendor.store_name_placeholder': return 'My Awesome Store';
			case 'become_vendor.store_description': return 'Store Description';
			case 'become_vendor.store_desc_placeholder': return 'Tell customers what you sell...';
			case 'become_vendor.store_location': return 'Store Location';
			case 'become_vendor.store_loc_placeholder': return 'e.g., Gaza, Ramallah, Hebron...';
			case 'become_vendor.delivery_zone': return 'Delivery Zone';
			case 'become_vendor.delivery_placeholder': return 'Choose delivery zone...';
			case 'become_vendor.zone_gaza': return 'Gaza Strip only';
			case 'become_vendor.zone_westbank': return 'West Bank only';
			case 'become_vendor.zone_both': return 'Both (Gaza & West Bank)';
			case 'become_vendor.delivery_hint': return 'Physical products will only be delivered within the selected zone. Digital products have no restrictions.';
			case 'become_vendor.what_do_you_sell': return 'What do you sell?';
			case 'become_vendor.skip_now': return 'Skip this now';
			case 'become_vendor.submit_app': return 'Submit Application';
			case 'become_vendor.success_title': return 'Application Submitted!';
			case 'become_vendor.success_desc': return 'Your request to register as a vendor is under review. You will be notified as soon as it is approved.';
			case 'become_vendor.go_account': return 'Go to My Account';
			case 'become_vendor.continue_shopping': return 'Continue Shopping';
			case 'become_vendor.screen_title': return 'Become a Vendor';
			case 'become_vendor.header_title': return 'Open Your Store\non WaslaQ';
			case 'become_vendor.header_subtitle': return 'Sell to thousands of Palestinian buyers with full escrow protection.';
			case 'become_vendor.why_sell': return 'Why sell on WaslaQ?';
			case 'become_vendor.escrow_title': return 'Escrow Protection';
			case 'become_vendor.escrow_desc': return 'Every sale is held in escrow until the buyer confirms receipt.';
			case 'become_vendor.community_title': return 'Built-in Community';
			case 'become_vendor.community_desc': return 'Reach buyers through our social feed and community posts.';
			case 'become_vendor.delivery_title': return 'Local Delivery Zones';
			case 'become_vendor.delivery_desc': return 'Deliver within Gaza or the West Bank — we handle the zone logic.';
			case 'become_vendor.dashboard_title': return 'Vendor Dashboard';
			case 'become_vendor.dashboard_desc': return 'Track orders, earnings, and manage your products easily.';
			case 'become_vendor.store_details': return 'Store Details';
			case 'become_vendor.store_name_label': return 'Store Name';
			case 'become_vendor.store_name_hint': return 'e.g. Abu Ahmad Electronics';
			case 'become_vendor.store_desc_label': return 'Store Description';
			case 'become_vendor.store_desc_hint': return 'What do you sell?';
			case 'become_vendor.phone_label': return 'Phone Number';
			case 'become_vendor.phone_hint': return '+970 5X XXX XXXX';
			case 'become_vendor.select_zone_hint': return 'Select your delivery zone';
			case 'become_vendor.submit_application': return 'Submit Application';
			case 'become_vendor.review_time': return 'We review applications within 24–48 hours.';
			case 'become_vendor.store_name_required': return 'Store name is required';
			case 'become_vendor.select_zone_required': return 'Please select a delivery zone';
			case 'become_vendor.already_applied': return 'You already have a vendor application.';
			case 'become_vendor.submission_failed': return 'Submission failed. Please try again.';
			case 'become_vendor.application_submitted': return 'Application submitted! We\'ll review it within 48 hours.';
			case 'privacy.page_title': return 'سياسة الخصوصية';
			case 'privacy.last_updated': return 'تاريخ السريان: 1 مايو 2026 · آخر تحديث: 1 مايو 2026';
			case 'privacy.intro': return 'تلتزم "واسلق" ("نحن" أو "المنصة") بحماية خصوصية جميع المستخدمين وبياناتهم الشخصية. تصف سياسة الخصوصية هذه كيفية قيامنا بجمع معلوماتك ومعالجتها وتخزينها وحمايتها وفقًا لمبادئ حماية البيانات الفلسطينية المعمول بها وأفضل الممارسات الدولية، بما في ذلك معايير اللائحة العامة لحماية البيانات (GDPR). وبدخولك إلى "واسلق" أو استخدامها، فإنك تقر بأنك قد قرأت الممارسات الموضحة في هذه السياسة وتوافق عليها.';
			case 'privacy.s1_title': return 'من نحن';
			case 'privacy.s1_body': return '"واسلق" هي منصة سوق إلكترونية اجتماعية مستقلة تعمل تحت الإشراف الفلسطيني. نحن نربط البائعين المستقلين بالمشترين، ونسهل إجراء المعاملات الآمنة القائمة على نظام الضمان، ونوفر ميزات مجتمعية تشمل المنشورات والمجموعات والرسائل المباشرة وتقييمات المنتجات.';
			case 'privacy.s2_title': return 'المعلومات التي نجمعها';
			case 'privacy.s2_1_title': return '2.1 معلومات الحساب والتسجيل';
			case 'privacy.s2_2_title': return '2.2 معلومات خاصة بالمورد';
			case 'privacy.s2_3_title': return '2.3 بيانات المعاملات والطلبات';
			case 'privacy.s2_4_title': return '2.4 بيانات التحقق من الهوية (KYC)';
			case 'privacy.s2_5_title': return '2.5 المحتوى الذي ينشئه المستخدمون';
			case 'privacy.s2_6_title': return '2.6 البيانات الفنية وبيانات الاستخدام';
			case 'privacy.s3_title': return 'الأساس القانوني للمعالجة';
			case 'privacy.s4_title': return 'كيف نستخدم معلوماتك';
			case 'privacy.s5_title': return 'كيف نشارك معلوماتك';
			case 'privacy.s6_title': return 'أمن البيانات';
			case 'privacy.s7_title': return 'الاحتفاظ بالبيانات';
			case 'privacy.s8_title': return 'حقوقك';
			case 'privacy.s9_title': return 'خصوصية الأطفال';
			case 'privacy.s10_title': return 'التعديلات على هذه السياسة';
			case 'privacy.cookie_policy_title': return 'سياسة ملفات تعريف الارتباط';
			case 'privacy.cookie_policy_intro': return 'تنطبق سياسة ملفات تعريف الارتباط هذه على المستخدمين الذين يدخلون إلى موقع "Waslaq" من الاتحاد الأوروبي، والمنطقة الاقتصادية الأوروبية، والمملكة المتحدة، وغيرها من الولايات القضائية التي تسري فيها متطلبات الموافقة على ملفات تعريف الارتباط بموجب توجيه الخصوصية الإلكترونية (ePrivacy Directive) أو اللائحة العامة لحماية البيانات (GDPR) أو التشريعات المماثلة.';
			case 'privacy.s1_body_2': return 'للاستفسارات المتعلقة بالخصوصية: privacy@waslaq.com · waslaq.com/contact';
			case 'privacy.s2_1_item1': return 'الاسم الكامل';
			case 'privacy.s2_1_item2': return 'عنوان البريد الإلكتروني (عبر مصادقة Google Firebase أو التسجيل المباشر)';
			case 'privacy.s2_1_item3': return 'رقم الهاتف (اختياري ما لم يكن مطلوبًا لإتمام عملية تسجيل المورد)';
			case 'privacy.s2_1_item4': return 'اسم العرض والصورة الرمزية في الملف الشخصي';
			case 'privacy.s2_1_item5': return 'تاريخ إنشاء الحساب وطريقة المصادقة (Google أو Facebook أو البريد الإلكتروني/كلمة المرور)';
			case 'privacy.s2_vendor_intro': return 'يقدم البائعون الذين يقدمون طلبات التسجيل ما يلي:';
			case 'privacy.s2_2_item1': return 'اسم المتجر، والوصف العام، والشعار، وصور البانر';
			case 'privacy.s2_2_item2': return 'منطقة التسليم (غزة، الضفة الغربية، أو كلاهما) والموقع الفعلي';
			case 'privacy.s2_2_item3': return 'تفاصيل حساب الدفع: رقم IBAN أو عنوان PayPal (يتم تخزينها بشكل آمن، ولا يتم الكشف عنها علنًا أبدًا)';
			case 'privacy.s2_2_item4': return 'وثائق التحقق من الهوية (KYC) وفقًا لمتطلبات الامتثال';
			case 'privacy.s2_3_item1': return 'رقم الطلب، رقم العرض، الطابع الزمني للإنشاء، والحالة';
			case 'privacy.s2_3_item2': return 'تفاصيل المنتج: العنوان، النوع، الكمية، سعر الوحدة بالشيكل الإسرائيلي';
			case 'privacy.s2_3_item3': return 'عنوان الشحن: اسم المستلم، الشارع، المدينة، الرمز البريدي';
			case 'privacy.s2_3_item4': return 'حالة الدفع وأرقام تأكيد الدفع';
			case 'privacy.s2_3_item5': return 'حالة الحساب المعلق والقيود الدفترية المرتبطة بالمعاملة';
			case 'privacy.s2_3_item6': return 'سجل طلبات الدفع للموردين';
			case 'privacy.s2_3_payment_card_data_title': return 'بيانات بطاقة الدفع:';
			case 'privacy.s2_3_payment_card_data_body': return 'نحن لا نقوم بتخزين أرقام بطاقات الدفع الكاملة أو رموز CVV أو بيانات مصادقة حامل البطاقة، ولا نعالجها أو ننقلها. تتم معالجة جميع عمليات الدفع حصريًّا عبر بوابات دفع متوافقة مع معيار PCI-DSS من المستوى الأول. ولا نتلقى سوى أرقام مرجعية لتأكيد المعاملات ورموز الحالة.';
			case 'privacy.s2_4_body': return 'قد تشمل إجراءات "اعرف عميلك" (KYC) بطاقة هوية صادرة عن الحكومة ومزودة بصورة، وإثبات ملكية الحساب المصرفي، ووثائق تجارية. ويتم تخزين هذه البيانات في ظل ضوابط صارمة للوصول إليها، ولا تُستخدم إلا لأغراض الامتثال لقوانين مكافحة غسل الأموال ومنع الاحتيال، ولا يتم مشاركتها أبدًا مع مستخدمين آخرين.';
			case 'privacy.s2_5_item1': return 'المنشورات على مواقع التواصل الاجتماعي، والتعليقات، والتصويتات، وحفظ المحتوى';
			case 'privacy.s2_5_item2': return 'عضويات المجتمع وأدواره';
			case 'privacy.s2_5_item3': return 'تقييمات المنتجات وتصنيفات النجوم';
			case 'privacy.s2_5_item4': return 'أسئلة وأجوبة العملاء المرسلة إلى الموردين';
			case 'privacy.s2_5_item5': return 'الرسائل المباشرة ومحادثات الطلبات عبر GetStream';
			case 'privacy.s2_6_item1': return 'عنوان IP والموقع الجغرافي التقريبي (على مستوى المدينة/المنطقة)';
			case 'privacy.s2_6_item2': return 'نوع الجهاز ونظام التشغيل وإصدار المتصفح';
			case 'privacy.s2_6_item3': return 'الصفحات التي تمت زيارتها، والوقت الذي قضاه المستخدم، ومسار التنقل';
			case 'privacy.s2_6_item4': return 'استعلامات البحث التي تم إدخالها على المنصة';
			case 'privacy.s2_6_item5': return 'سجلات الأخطاء ومعلومات التشخيص';
			case 'privacy.table_processing_activities': return 'أنشطة المعالجة';
			case 'privacy.table_legal_basis': return 'الأساس القانوني';
			case 'privacy.table_row1_activity': return 'إدارة الحسابات، ومعالجة الطلبات، وعمليات الحساب المعلق، ودفع المستحقات للموردين، وتسوية النزاعات';
			case 'privacy.table_row1_basis': return 'الضرورة التعاقدية';
			case 'privacy.table_row2_activity': return 'الامتثال لقوانين "اعرف عميلك" (KYC) ومكافحة غسل الأموال (AML)، والسجلات الضريبية، والأوامر القضائية';
			case 'privacy.table_row2_basis': return 'الالتزام القانوني';
			case 'privacy.table_row3_activity': return 'منع الاحتيال، ومراقبة الأمن، وتحليلات المنصات، وكشف حالات إساءة الاستخدام';
			case 'privacy.table_row3_basis': return 'المصالح المشروعة';
			case 'privacy.table_row4_activity': return 'الإشعارات الفورية، والرسائل التسويقية الاختيارية، وملفات تعريف الارتباط غير الضرورية';
			case 'privacy.table_row4_basis': return 'الموافقة';
			case 'privacy.s4_1_title': return '4.1 عمليات المنصة';
			case 'privacy.s4_2_title': return '4.2 الأمن ومنع الاحتيال';
			case 'privacy.s4_3_title': return '4.3 التواصل';
			case 'privacy.s5_sell_no': return 'نحن لا نبيع بياناتك الشخصية أو نؤجرها أو نتاجر بها مع أطراف ثالثة لأغراض إعلانية أو تسويقية.';
			case 'privacy.s5_1_title': return '5.1 شركات معالجة الدفع';
			case 'privacy.s5_1_body': return 'يتم مشاركة بيانات المعاملات مع بنك فلسطين وبوابات الدفع المعتمدة حصريًّا لغرض تنفيذ الدفع ومنع الاحتيال.';
			case 'privacy.s5_2_title': return '5.2 الجهات الفرعية المعالجة للبيانات في مجال البنية التحتية';
			case 'privacy.table_service': return 'الخدمة';
			case 'privacy.table_purpose': return 'الغرض';
			case 'privacy.table_data_processed': return 'البيانات التي تمت معالجتها';
			case 'privacy.s5_3_title': return '5.3 بين المشترين والبائعين';
			case 'privacy.s5_3_body': return 'عند تقديم طلب شراء، يتم مشاركة اسم المشتري وعنوان التسليم وتفاصيل الطلب مع البائع المعني لغرض تنفيذ الطلب حصراً. ويُحظر على البائعين استخدام هذه المعلومات لأي غرض آخر.';
			case 'privacy.s5_4_title': return '5.4 الكشف القانوني والقضائي';
			case 'privacy.s5_4_body': return 'قد نكشف عن البيانات الشخصية للمحاكم الفلسطينية أو سلطات إنفاذ القانون أو الهيئات التنظيمية عندما يقتضي ذلك أمر قضائي رسمي قانوني. وحيثما يسمح القانون بذلك، سنقوم بإخطار المستخدم المعني قبل الكشف عن هذه البيانات.';
			case 'privacy.s6_security_note': return 'على الرغم من أننا نطبق إجراءات أمنية متوافقة مع معايير القطاع، إلا أنه لا يوجد نظام إلكتروني آمن بنسبة 100٪. تقع على عاتقك مسؤولية الحفاظ على سرية بيانات تسجيل الدخول الخاصة بك. يرجى الإبلاغ عن أي حالة يشتبه في أنها وصول غير مصرح به إلى';
			case 'privacy.table_data_category': return 'فئة البيانات';
			case 'privacy.table_retention_period': return 'فترة الاحتفاظ';
			case 'privacy.s8_submit_note': return 'يرجى إرسال الطلبات إلى ... وسنرد عليك في غضون 30 يومًا. قد يكون من الضروري التحقق من هويتك.';
			case 'privacy.s9_minors_body': return 'لا يُقصد بـ«واسلق» المستخدمون الذين تقل أعمارهم عن 18 عامًا. ونحن لا نجمع البيانات عن القاصرين عن قصد. وإذا علمنا بتسجيل قاصر، فسوف نقوم على الفور بتعليق الحساب وحذف البيانات المرتبطة به. يرجى الإبلاغ عن أي مخاوف إلى';
			case 'privacy.s10_updates_body': return 'قد نقوم بتحديث هذه السياسة في أي وقت. وسيتم الإبلاغ عن التغييرات الجوهرية عبر البريد الإلكتروني وإشعار على المنصة قبل 14 يومًا على الأقل من دخولها حيز التنفيذ. ويُعتبر الاستمرار في استخدام Waslaq بعد دخول التغييرات حيز التنفيذ قبولاً للسياسة المعدلة.';
			case 'privacy.cookie_disclosure_label': return 'إشعار بشأن ملفات تعريف الارتباط';
			case 'privacy.what_are_cookies_title': return 'ما هي ملفات تعريف الارتباط؟';
			case 'privacy.what_are_cookies_body': return 'ملفات تعريف الارتباط هي ملفات نصية صغيرة يضعها موقع الويب على جهازك. وهي تتيح للمواقع الإلكترونية العمل بشكل سليم، وتذكر تفضيلاتك، وتزود مالك الموقع بتحليلات. وقد تكون ملفات تعريف الارتباط مؤقتة (تُحذف عند إغلاق المتصفح) أو دائمة (تُخزّن على جهازك لفترة محددة).';
			case 'privacy.cookies_we_use_title': return 'ملفات تعريف الارتباط التي نستخدمها';
			case 'privacy.strictly_necessary_title': return 'ملفات تعريف الارتباط الضرورية للغاية — لا تتطلب موافقة';
			case 'privacy.functional_cookies_title': return 'ملفات تعريف الارتباط الوظيفية — يلزم الحصول على الموافقة';
			case 'privacy.no_ads_cookies': return 'لا توجد ملفات تعريف ارتباط إعلانية. لا يعرض موقع "Waslaq" أي إعلانات، ولا يستخدم وحدات بكسل إعادة الاستهداف أو ملفات تعريف الارتباط الخاصة بأطراف ثالثة أو تقنيات الإعلان السلوكي.';
			case 'privacy.third_party_cookies_title': return 'ملفات تعريف الارتباط الخاصة بأطراف ثالثة';
			case 'privacy.table_privacy_policy': return 'سياسة الخصوصية';
			case 'privacy.your_cookie_choices_title': return 'خيارات ملفات تعريف الارتباط الخاصة بك';
			case 'privacy.your_cookie_choices_body': return 'يمكنك ضبط متصفحك لرفض ملفات تعريف الارتباط أو حذفها:';
			case 'privacy.disabling_cookies_note': return 'سيؤدي تعطيل ملفات تعريف الارتباط الضرورية للغاية إلى منعك من تسجيل الدخول واستخدام الميزات الأساسية للمنصة.';
			case 'privacy.legal_basis_cookies_title': return 'الأساس القانوني لاستخدام ملفات تعريف الارتباط';
			case 'privacy.table_category': return 'الفئة';
			case 'privacy.cookie_inquiries': return 'الاستفسارات المتعلقة بملفات تعريف الارتباط:';
			case 'privacy.footer_questions': return 'هل لديك أسئلة حول هذه السياسة؟ اتصل بـ ... أو تفضل بزيارة موقعنا';
			case 'privacy.footer_rights': return '© 2026 واسلاق. السوق الاجتماعي الفلسطيني. جميع الحقوق محفوظة.';
			case 'privacy.table_row1_purpose_infra': return 'شبكة توزيع المحتوى (CDN)، الحماية من هجمات DDoS، SSL';
			case 'privacy.table_row1_data_infra': return 'عناوين IP، وبيانات تعريف الطلب';
			case 'privacy.table_row2_purpose_infra': return 'مصادقة المستخدم';
			case 'privacy.table_row2_data_infra': return 'البريد الإلكتروني، معرّف المستخدم الفريد (UID)، رموز المصادقة';
			case 'privacy.table_row3_purpose_infra': return 'المراسلة والموجزات في الوقت الفعلي';
			case 'privacy.table_row3_data_infra': return 'معرفات المستخدمين، محتوى الرسائل';
			case 'privacy.table_row4_purpose_infra': return 'تسليم رسائل البريد الإلكتروني المتعلقة بالمعاملات';
			case 'privacy.table_row4_data_infra': return 'عناوين البريد الإلكتروني، ومحتوى رسائل البريد الإلكتروني';
			case 'privacy.table_row5_purpose_infra': return 'وسائط التخزين';
			case 'privacy.table_row5_data_infra': return 'الملفات والصور التي تم تحميلها';
			case 'privacy.table_retention_row1_cat': return 'معلومات الحساب';
			case 'privacy.table_retention_row1_period': return 'مدة الحساب + سنتان بعد الحذف';
			case 'privacy.table_retention_row2_cat': return 'سجلات المعاملات وبيانات دفتر الأستاذ';
			case 'privacy.table_retention_row2_period': return '5 سنوات على الأقل (الامتثال المالي)';
			case 'privacy.table_retention_row3_cat': return 'التعرف على العميل / وثائق الهوية';
			case 'privacy.table_retention_row3_period': return 'مدة العلاقة مع المورد + 5 سنوات';
			case 'privacy.table_retention_row4_cat': return 'سجلات النزاعات والقرارات';
			case 'privacy.table_retention_row4_period': return '5 سنوات من تاريخ صدور القرار';
			case 'privacy.table_retention_row5_cat': return 'بيانات الطلب والشحن';
			case 'privacy.table_retention_row5_period': return '3 سنوات';
			case 'privacy.table_retention_row6_cat': return 'سجلات الاستخدام والسجلات الفنية';
			case 'privacy.table_retention_row6_period': return '90 يومًا';
			case 'privacy.table_retention_row7_cat': return 'تذاكر الدعم';
			case 'privacy.table_retention_row7_period': return '3 سنوات';
			case 'privacy.table_retention_row8_cat': return 'بيانات الحساب المحذوفة';
			case 'privacy.table_retention_row8_period': return 'يتم إخفاء الهوية أو حذفها في غضون 30 يومًا';
			case 'privacy.s8_item1_title': return 'حق الاطلاع';
			case 'privacy.s8_item1_desc': return 'اطلب نسخة من البيانات الشخصية التي نحتفظ بها عنك.';
			case 'privacy.s8_item2_title': return 'الحق في التصحيح';
			case 'privacy.s8_item2_desc': return 'اطلب تصحيح البيانات غير الدقيقة أو غير الكاملة.';
			case 'privacy.s8_item3_title': return 'الحق في حذف البيانات';
			case 'privacy.s8_item3_desc': return 'طلب حذف بياناتك (مع مراعاة متطلبات الاحتفاظ القانونية).';
			case 'privacy.s8_item4_title': return 'الحق في تقييد المعالجة';
			case 'privacy.s8_item4_desc': return 'طلب التوقف المؤقت عن المعالجة في ظروف معينة.';
			case 'privacy.s8_item5_title': return 'الحق في نقل البيانات';
			case 'privacy.s8_item5_desc': return 'اطلب تصدير بياناتك في صيغة منظمة وقابلة للقراءة آليًّا.';
			case 'privacy.s8_item6_title': return 'الحق في الاعتراض';
			case 'privacy.s8_item6_desc': return 'الاعتراض على المعالجة استنادًا إلى المصالح المشروعة.';
			case 'privacy.s8_item7_title': return 'الحق في سحب الموافقة';
			case 'privacy.s8_item7_desc': return 'يمكنك سحب موافقتك على المعالجة القائمة على الموافقة في أي وقت.';
			case 'privacy.table_cookie1_purpose': return 'رمز جلسة العمل المصادق عليه للخلفية التجارية';
			case 'privacy.table_cookie1_duration': return 'الجلسة';
			case 'privacy.table_cookie2_purpose': return 'جلسة مصادقة Firebase';
			case 'privacy.table_cookie2_duration': return 'الجلسة';
			case 'privacy.table_cookie3_purpose': return 'يمنع تزوير الطلبات عبر المواقع';
			case 'privacy.table_cookie3_duration': return 'الجلسة';
			case 'privacy.table_cookie4_name': return 'ملفات تعريف الارتباط الخاصة بالتفضيلات';
			case 'privacy.table_cookie4_purpose': return 'يحتفظ بتفضيلات العرض والإشعارات';
			case 'privacy.table_cookie4_duration': return 'سنة واحدة';
			case 'privacy.table_cookie5_name': return 'حفظ سلة التسوق';
			case 'privacy.table_cookie5_purpose': return 'يحتفظ بمحتويات سلة التسوق عبر الجلسات';
			case 'privacy.table_cookie5_duration': return '30 يومًا';
			case 'privacy.your_cookie_choices_item1': return 'Chrome: الإعدادات → الخصوصية والأمان → ملفات تعريف الارتباط وبيانات المواقع الأخرى';
			case 'privacy.your_cookie_choices_item2': return 'فايرفوكس: الخيارات → الخصوصية والأمان → ملفات تعريف الارتباط وبيانات المواقع';
			case 'privacy.your_cookie_choices_item3': return 'Safari: التفضيلات → الخصوصية → إدارة بيانات المواقع الإلكترونية';
			case 'privacy.your_cookie_choices_item4': return 'Edge: الإعدادات → الخصوصية والبحث والخدمات → ملفات تعريف الارتباط';
			case 'privacy.table_cookie_legal_row1_cat': return 'ضرورية للغاية';
			case 'privacy.table_cookie_legal_row1_basis': return 'المصلحة المشروعة / الضرورة التعاقدية — لا حاجة إلى موافقة';
			case 'privacy.table_cookie_legal_row2_cat': return 'وظيفي';
			case 'privacy.table_cookie_legal_row2_basis': return 'الموافقة';
			case 'privacy.table_cookie_legal_row3_cat': return 'التحليلات';
			case 'privacy.table_cookie_legal_row3_basis': return 'الموافقة (نستخدم ملفات تعريف الارتباط من جانب الخادم فقط، ولا نستخدم ملفات تعريف الارتباط الخاصة بالتتبع)';
			case 'privacy.table_cookie_legal_row4_cat': return 'الإعلان';
			case 'privacy.table_cookie_legal_row4_basis': return 'لا ينطبق — نحن لا نستخدم ملفات تعريف الارتباط الإعلانية';
			case 'privacy.s4_1_item1': return 'لإنشاء حسابك وإدارته.';
			case 'privacy.s4_1_item2': return 'لمعالجة طلباتك وتنفيذها.';
			case 'privacy.s4_1_item3': return 'تقديم خدمات الضمان والدفع الآمنة.';
			case 'privacy.s4_1_item4': return 'لتسهيل التواصل بين المشترين والبائعين.';
			case 'privacy.s4_1_item5': return 'لإبلاغك بحالة الطلب وتحديثات المنصة.';
			case 'privacy.s4_2_item1': return 'لمراقبة الأنشطة المشبوهة أو الاحتيالية.';
			case 'privacy.s4_2_item2': return 'للتحقق من هويتك في إطار عملية تسجيل الموردين.';
			case 'privacy.s4_2_item3': return 'لحماية سلامة نظام الحساب المعلق.';
			case 'privacy.s4_2_item4': return 'لتسوية النزاعات والتوسط في المطالبات.';
			case 'privacy.s4_2_item5': return 'الامتثال للالتزامات القانونية والتنظيمية.';
			case 'privacy.s4_3_item1': return 'إشعارات فورية للرسائل والطلبات الجديدة.';
			case 'privacy.s4_3_item2': return 'تحديثات عبر البريد الإلكتروني بشأن أمان الحساب وأنشطته.';
			case 'privacy.s4_3_item3': return 'الاتصالات التسويقية الاختيارية (في حالة تقديم الموافقة).';
			case 'terms.page_title': return 'شروط الاستخدام';
			case 'terms.last_updated': return 'تاريخ السريان: 1 مايو 2026 · آخر تحديث: 1 مايو 2026';
			case 'terms.intro': return 'تشكل شروط الاستخدام هذه ("الاتفاقية") عقدًا ملزمًا قانونًا بين Waslaq ("المنصة"، "نحن"، "لنا") وجميع المستخدمين، بما في ذلك المشترون والبائعون ("أنت"، "المستخدم"). من خلال الوصول إلى أي جزء من منصة Waslaq أو استخدامه — بما في ذلك التصفح أو التسجيل أو الشراء أو البيع — فإنك تقبل دون قيد أو شرط جميع الشروط المنصوص عليها في هذه الاتفاقية. إذا كنت لا توافق على أي جزء من هذه الاتفاقية، فيجب عليك التوقف فوراً عن استخدام المنصة بأي شكل من الأشكال.';
			case 'terms.s1_title': return 'طبيعة المنصة';
			case 'terms.s2_title': return 'تسجيل الحساب وشروط الأهلية';
			case 'terms.s3_title': return 'نظام الضمان والدفع';
			case 'terms.s4_title': return 'التزامات المورد وإجراءات "اعرف عميلك"';
			case 'terms.s5_title': return 'التزامات المشتري';
			case 'terms.s6_title': return 'المحتوى والأنشطة المحظورة';
			case 'terms.s7_title': return 'الملكية الفكرية';
			case 'terms.s8_title': return 'تسوية المنازعات';
			case 'terms.s9_title': return 'عمليات رد المبالغ المدفوعة';
			case 'terms.s10_title': return 'رسوم وعمولات المنصة';
			case 'terms.s11_title': return 'حدود المسؤولية';
			case 'terms.s12_title': return 'الإنهاء والتعليق';
			case 'terms.s13_title': return 'القانون الواجب التطبيق والاختصاص القضائي';
			case 'terms.s14_title': return 'التعديلات';
			case 'terms.quick_nav_title': return 'التنقل السريع';
			case 'terms.quick_nav_item1': return 'طبيعة المنصة';
			case 'terms.quick_nav_item2': return 'تسجيل الحساب';
			case 'terms.quick_nav_item3': return 'الحساب المعلق والمدفوعات';
			case 'terms.quick_nav_item4': return 'التزامات الموردين وإجراءات "اعرف عميلك"';
			case 'terms.quick_nav_item5': return 'التزامات المشتري';
			case 'terms.quick_nav_item6': return 'المحتوى والأنشطة المحظورة';
			case 'terms.quick_nav_item7': return 'الملكية الفكرية';
			case 'terms.quick_nav_item8': return 'تسوية المنازعات';
			case 'terms.quick_nav_item9': return 'عمليات رد المبالغ المدفوعة';
			case 'terms.quick_nav_item10': return 'رسوم وعمولات المنصة';
			case 'terms.quick_nav_item11': return 'حدود المسؤولية';
			case 'terms.quick_nav_item12': return 'الإنهاء والتعليق';
			case 'terms.quick_nav_item13': return 'القانون الواجب التطبيق';
			case 'terms.quick_nav_item14': return 'التعديلات';
			case 'terms.s1_body1': return 'تعمل "واسلق" كوسيط إلكتروني وتقني ومالي مستقل يربط بين البائعين المستقلين والمشترين حصريًّا داخل السوق الفلسطينية. وتسهل المنصة إجراء المعاملات من خلال نظام ضمان آمن، كما توفر ميزات التجارة الاجتماعية، بما في ذلك المجموعات والمشاركات ومراجعات المنتجات والمراسلة المباشرة.';
			case 'terms.s1_body2': return 'لا تعتبر المنصة طرفًا مباشرًا في عقود البيع المبرمة بين المشترين والبائعين. ولا توجد أي علاقة وكالة أو شراكة أو توظيف أو امتياز أو مشروع مشترك بين «واسلق» وأي مستخدم. والبائعون هم بائعون مستقلون ويتحملون وحدهم المسؤولية عن منتجاتهم وإعلاناتهم والتزاماتهم المتعلقة بتنفيذ الطلبات.';
			case 'terms.s1_body3': return 'تحتفظ Waslaq بالحق في تعديل أو تعليق أو إيقاف أي ميزة أو قسم أو المنصة بأكملها بشكل دائم في أي وقت، سواء بإشعار مسبق أو بدونه، ولن تتحمل أي مسؤولية تجاه أي مستخدم أو طرف ثالث عن أي تعديل أو تعليق أو إيقاف من هذا القبيل.';
			case 'terms.s2_intro': return 'للاستفادة من جميع ميزات المنصة، يجب عليك إنشاء حساب. وبتسجيلك، فإنك تقر وتضمن ما يلي:';
			case 'terms.s2_item1': return 'يجب أن يكون عمرك 18 عامًا على الأقل أو أن تكون قد بلغت سن الرشد القانوني في ولايتك القضائية.';
			case 'terms.s2_item2': return 'جميع المعلومات المقدمة أثناء التسجيل دقيقة وحديثة وكاملة.';
			case 'terms.s2_item3': return 'يجب عليك الحفاظ على دقة معلومات حسابك وتحديثها فور حدوث أي تغيير فيها.';
			case 'terms.s2_item4': return 'لا يجوز لك إنشاء حسابات متعددة للتحايل على القيود أو الإيقافات أو الحظر.';
			case 'terms.s2_item5': return 'أنت وحدك المسؤول عن جميع الأنشطة التي تتم من خلال حسابك وعن الحفاظ على سرية بيانات تسجيل الدخول الخاصة بك.';
			case 'terms.s2_body': return 'تحتفظ Waslaq بالحق في رفض التسجيل، أو التحقق من الهوية، أو تعليق الوصول، أو حظر أي حساب بشكل دائم وفقًا لتقديرها الخاص، بما في ذلك على سبيل المثال لا الحصر، في حالات انتهاك هذه الاتفاقية، أو الاشتباه في حدوث احتيال، أو الإضرار بسمعة المنصة.';
			case 'terms.s3_2_item1': return 'المنتجات المادية: 48 ساعة من تاريخ تأكيد التسليم أو قيام البائع بوضع علامة "تم الشحن" على الطلب.';
			case 'terms.s3_2_item2': return 'المنتجات الرقمية: 24 ساعة من تاريخ تأكيد تسليم المفتاح الرقمي أو الملف أو بيانات تسجيل الدخول.';
			case 'terms.s3_3_item1': return 'تمديد فترة الاحتجاز إلى ما بعد "فترة الفحص" القياسية في حالات الاشتباه في حدوث احتيال أو في حالة وجود نزاعات لم يتم حلها.';
			case 'terms.s3_3_item2': return 'تجميد الأموال إلى أجل غير مسمى ريثما يتم الانتهاء من التحقيق في المخالفات المبلغ عنها أو الشكاوى المتعددة أو التحقيق التنظيمي.';
			case 'terms.s3_3_item3': return 'إعادة الأموال المحتجزة إلى المشترين أو تحويلها إليهم في حالة تسوية النزاع أو تأكيد مخالفة البائع.';
			case 'terms.s3_3_item4': return 'تعليق المدفوعات المعلقة للموردين الذين تخضع حساباتهم للتحقيق أو التعليق.';
			case 'terms.s4_1_item1': return 'بطاقة هوية صادرة عن الحكومة ومزودة بصورة (بطاقة الهوية الوطنية أو جواز السفر).';
			case 'terms.s4_1_item2': return 'إثبات ملكية الحساب المصرفي (كشف حساب أو خطاب تأكيد رقم IBAN).';
			case 'terms.s4_1_item3': return 'وثائق تسجيل الشركة، إن وجدت.';
			case 'terms.s4_3_item1': return 'هذا المنتج هو نسخة مقلدة / غير أصلية / مقلدة — ولا يرتبط بالعلامة التجارية الأصلية ولا يحظى بتأييدها.';
			case 'terms.s4_3_item2': return 'استخدام مصطلحات مثل "نسخة" أو "مزيفة" أو "مقلدة" أو "مستنسخة" أو "ليست أصلية" بشكل واضح في العنوان نفسه.';
			case 'terms.s5_item1': return 'يرجى تقديم عناوين الشحن ومعلومات الاتصال الصحيحة عند إتمام عملية الدفع. لا تتحمل "واسلق" والموردون أي مسؤولية عن أي إخفاق في التسليم ناجم عن تقديم عناوين غير صحيحة من قِبل المشتري.';
			case 'terms.s5_item2': return 'يرجى مراجعة الطلبات خلال فترة المراجعة وفتح نزاع فوراً في حال اكتشاف أي مشاكل. ويُعتبر عدم فتح نزاع قبل انتهاء فترة المراجعة بمثابة قبول قانوني للطلب.';
			case 'terms.s5_item3': return 'لا تقدم أدلة مزورة أو مزيفة في النزاعات. فذلك يشكل احتيالاً وسيؤدي إلى إغلاق الحساب نهائياً واتخاذ إجراءات قانونية محتملة.';
			case 'terms.s5_item4': return 'لا يجوز الشروع في إجراءات استرداد المبالغ من البنك دون استنفاد إجراءات تسوية المنازعات الداخلية الخاصة بالمنصة أولاً.';
			case 'terms.s5_item5': return 'يرجى الالتزام بجميع القوانين الفلسطينية السارية عند شراء المنتجات عبر المنصة.';
			case 'terms.s6_1_item1': return 'عرض منتجات مقلدة أو مستنسخة أو غير أصلية دون الإفصاح عن ذلك بوضوح وصراحة في عنوان المنتج ووصفه.';
			case 'terms.s6_1_item2': return 'عرض أو بيع أو تيسير منتجات أو خدمات تنتهك القانون الفلسطيني المعمول به، أو المبادئ المالية الإسلامية حيثما كان ذلك مطلوبًا، أو العقوبات الدولية.';
			case 'terms.s6_1_item3': return 'أي مخطط يهدف إلى التحايل على نظام الحساب المعلق، بما في ذلك محاولة إتمام المعاملات خارج المنصة.';
			case 'terms.s6_1_item4': return 'استخدام المنصة في غسل الأموال أو تمويل الإرهاب أو أي نشاط ينتهك لوائح مكافحة غسل الأموال (AML).';
			case 'terms.s6_2_item1': return 'نشر أو تحميل أو مشاركة أو وضع روابط لأي محتوى جنسي صريح أو إباحي أو مخصص للبالغين فقط بأي شكل من الأشكال — بما في ذلك الصور أو مقاطع الفيديو أو النصوص أو الروابط أو قوائم المنتجات — تحت أي ظرف من الظروف ودون استثناء.';
			case 'terms.s6_2_item2': return 'نشر أي محتوى يُجسد القاصرين في صورة جنسية أو يستغلهم أو يعرضهم للخطر بأي شكل من الأشكال. ويُعد هذا جريمة جنائية وسيتم الإبلاغ عنه على الفور إلى السلطات الفلسطينية المختصة والمنظمات الدولية المعنية بحماية الطفل.';
			case 'terms.s6_2_item3': return 'مشاركة صور عارية أو شبه عارية أو ذات إيحاءات جنسية في أي قسم من أقسام المنصة، بما في ذلك المنشورات والمجموعات وصور المنتجات ولافتات المتاجر وصور الملف الشخصي أو الرسائل المباشرة.';
			case 'terms.s6_2_item4': return 'عرض أو بيع أي منتجات أو خدمات أو مواد للبالغين، بغض النظر عن وضعها القانوني في الولاية القضائية للمستخدم.';
			case 'terms.s6_2_item5': return 'محاولة التحايل على آليات مراقبة المحتوى باستخدام لغة مشفرة أو رموز تعبيرية أو روابط لمواقع خارجية أو إشارات غير مباشرة بهدف توجيه المستخدمين إلى محتوى محظور.';
			case 'terms.s6_3_item1': return 'التحرش أو التنمر أو التهديد أو التخويف أو الإساءة الموجهة إلى أي مستخدم أو بائع أو عضو في المجتمع أو موظف في المنصة في أي قسم من أقسام المنصة.';
			case 'terms.s6_3_item2': return 'خطاب الكراهية، أو التمييز، أو المحتوى الذي يحط من قدر الأفراد أو الجماعات على أساس الدين، أو العرق، أو الجنسية، أو الجنس، أو الانتماء السياسي، أو أي سمة أخرى محمية.';
			case 'terms.s6_3_item3': return 'نشر مشاهد عنف صادمة، أو مشاهد دموية، أو صور مزعجة، أو محتوى يهدف إلى إثارة صدمة أو إزعاج المستخدمين الآخرين.';
			case 'terms.s6_3_item4': return 'نشر معلومات خاطئة متعمدة أو معلومات مضللة أو محتوى ملفق بهدف خداع المستخدمين الآخرين أو الإضرار بسمعتهم.';
			case 'terms.s6_3_item5': return 'إغراق المجتمعات أو موجزات المنشورات أو الرسائل المباشرة بمحتوى ترويجي غير مرغوب فيه، أو منشورات متكررة، أو أنشطة الروبوتات الآلية.';
			case 'terms.s6_3_item6': return '"الدوكسينغ" — نشر معلومات شخصية خاصة عن أي فرد (الاسم، العنوان، رقم الهاتف، التفاصيل المالية) دون موافقته الصريحة.';
			case 'terms.s6_3_item7': return 'انتحال صفة مستخدم آخر أو بائع أو مشرف مجتمع أو أحد موظفي Waslaq في أي سياق على المنصة.';
			case 'terms.s6_4_item1': return 'الجمع غير المصرح به للبيانات الشخصية للمستخدمين الآخرين أو محتوى المنصة، أو استخراجها، أو استخدامها لأغراض تجارية.';
			case 'terms.s6_4_item2': return 'تحميل برامج ضارة، أو شن هجمات لإعاقة الخدمة، أو محاولة اختراق أنظمة أمان المنصة.';
			case 'terms.s6_4_item3': return 'إنشاء حسابات متعددة للتحايل على الحظر أو التعليق أو تقييد الحساب.';
			case 'terms.s6_4_item4': return 'التلاعب بتعليقات المنتجات أو تصويتات المجتمع أو التقييمات من خلال حسابات مزيفة أو تعليقات مدفوعة الأجر أو سلوك غير حقيقي يتم تنسيقه.';
			case 'terms.s6_5_item1': return 'إزالة منشورات أو إعلانات أو صور أو تعليقات محددة.';
			case 'terms.s6_5_item2': return 'التعليق المؤقت لحق النشر في مجتمعات معينة أو على مستوى المنصة بأكملها.';
			case 'terms.s6_5_item3': return 'الحظر الدائم من جميع ميزات المنصة، بما في ذلك الشراء والبيع والمشاركة الاجتماعية.';
			case 'terms.s6_5_item4': return 'مصادرة الأرصدة المعلقة في حالات الاحتيال أو الانتهاكات الجسيمة.';
			case 'terms.s6_5_item5': return 'الإحالة إلى أجهزة إنفاذ القانون الفلسطينية أو السلطات المختصة في حالة ارتكاب مخالفات جنائية.';
			case 'terms.s9_item1': return 'تقديم شكوى عبر نظام تسوية المنازعات الخاص بالمنصة.';
			case 'terms.s9_item2': return 'منح شركة «واسلق» مهلة معقولة لا تقل عن 7 أيام عمل للتحقيق في الأمر والرد عليه.';
			case 'terms.s9_item3': return 'استرداد كامل مبلغ المعاملة المتنازع عليها من حساب المستخدم أو من أي أموال محتجزة.';
			case 'terms.s9_item4': return 'تحميل جميع الرسوم المصرفية وتكاليف المعالجة والمصروفات الإدارية ذات الصلة على عاتق المستخدم المخالف.';
			case 'terms.s9_item5': return 'حظر المستخدم بشكل دائم من المنصة.';
			case 'terms.s9_item6': return 'اتخاذ إجراءات قانونية مدنية لاسترداد جميع الخسائر والتكاليف والأضرار، بما في ذلك أتعاب المحاماة.';
			case 'terms.s11_item1': return 'أي أضرار غير مباشرة أو عرضية أو خاصة أو تبعية أو تعويضية أو عقابية.';
			case 'terms.s11_item2': return 'خسارة الأرباح أو الإيرادات أو البيانات أو الفرص التجارية أو السمعة التجارية.';
			case 'terms.s11_item3': return 'الأضرار الناجمة عن سلوك البائعين أو المشترين أو منتجاتهم أو خدماتهم.';
			case 'terms.s11_item4': return 'انقطاعات الخدمة الناجمة عن ظروف خارجة عن سيطرة «واسلق» المعقولة، بما في ذلك انقطاع خدمة الإنترنت، أو أعطال خدمات الجهات الخارجية، أو الكوارث الطبيعية، أو الاضطرابات المدنية، أو حالات القوة القاهرة.';
			case 'terms.s11_item5': return 'الوصول غير المصرح به إلى بياناتك أو تغييرها نتيجة لأفعال أطراف ثالثة خارجة عن سيطرتنا المعقولة.';
			case 'terms.s14_item1': return 'سيتم تحديث تاريخ "آخر تحديث" في أعلى هذه الصفحة.';
			case 'terms.s14_item2': return 'سيتم إخطار المستخدمين المسجلين عبر البريد الإلكتروني قبل 14 يومًا على الأقل من دخول التغييرات حيز التنفيذ.';
			case 'terms.s14_item3': return 'سيتم عرض إشعار بارز على المنصة.';
			case 'terms.s3_1_title': return '3.1 معالجة المدفوعات';
			case 'terms.s3_1_body': return 'تتم معالجة جميع المعاملات على منصة "Waslaq" حصريًّا عبر بوابات الدفع المعتمدة، بما في ذلك بنك فلسطين ومزودي خدمات الدفع المرخصين الآخرين. وتُحدد جميع المبالغ بالشيكل الإسرائيلي الجديد (ILS). وبإجراء طلب الشراء، فإنك تفوض المنصة بتحصيل المبلغ الكامل للطلب، بما في ذلك أي رسوم منصة سارية، من وسيلة الدفع التي اخترتها.';
			case 'terms.s3_2_title': return '3.2 الحجز في حساب الضمان';
			case 'terms.s3_2_body': return 'بعد إتمام الدفع بنجاح، تحتفظ المنصة بمبلغ الطلب بالكامل في حساب ضمان. ولا يتم تحويل الأموال إلى البائع إلا بعد انقضاء فترة الفحص الإلزامية دون رفع أي نزاع. وتكون فترة الفحص كما يلي:';
			case 'terms.s3_3_title': return '3.3 حقوق البائع في الأموال';
			case 'terms.s3_3_intro': return 'لا يكتسب البائعون أي حق قانوني مكتسب في الأموال المحتجزة حتى تنتهي فترة المراجعة دون حدوث أي نزاع. وتحتفظ شركة «واسلاق» بسلطة تقديرية مطلقة وأحادية الجانب تسمح لها بما يلي:';
			case 'terms.s3_4_title': return '3.4 العملة والأسعار';
			case 'terms.s3_4_body': return 'جميع الأسعار والرسوم والمبالغ المدفوعة على المنصة مقومة بالشيكل الإسرائيلي الجديد (ILS). ولا تضمن «واسلق» أسعار الصرف، كما أنها غير مسؤولة عن خسائر تحويل العملات التي يتكبدها المستخدمون الذين يجرون معاملاتهم من خارج فلسطين.';
			case 'terms.s4_1_title': return '4.1 التسجيل والتحقق';
			case 'terms.s4_1_body': return 'يجب على جميع البائعين إتمام عملية تسجيل البائعين في منصة "واسلق"، بما في ذلك تقديم معلومات دقيقة عن المتجر، وتحديد مناطق التوصيل، وتفاصيل حساب السحب. ويجب على البائعين إتمام عملية التحقق من الهوية (KYC) قبل التمكن من استخدام وظيفة السحب. وقد تتطلب عملية KYC تقديم ما يلي:';
			case 'terms.s4_1_kyc_failure': return 'قد يؤدي عدم إتمام إجراءات "اعرف عميلك" (KYC) خلال فترة معقولة إلى تعليق الحساب وحجب الأموال المتراكمة إلى حين إتمام الإجراءات.';
			case 'terms.s4_2_title': return '4.2 دقة بيانات المنتج';
			case 'terms.s4_2_body': return 'يتحمل البائعون المسؤولية الكاملة والحصرية عن دقة واكتمال وقانونية وأصالة جميع قوائم المنتجات، بما في ذلك العناوين والأوصاف والصور والأسعار والمواصفات. ويجب أن تعكس قوائم المنتجات بدقة المنتج الفعلي الذي سيتسلمه المشتري.';
			case 'terms.s4_3_title': return '4.3 المنتجات المقلدة وغير الأصلية';
			case 'terms.s4_3_body': return 'لا يجوز للبائعين عرض منتجات مقلدة أو نسخ مقلدة أو غير أصلية إلا إذا قاموا بالإفصاح عن ذلك صراحةً وبشكل لا لبس فيه في كل من عنوان المنتج ووصفه، بطريقة لا تترك أي شك معقول في ذهن المشتري. وتشمل الصيغ المقبولة للإفصاح ما يلي:';
			case 'terms.s4_3_prohibited_title': return 'ممنوع منعاً باتاً:';
			case 'terms.s4_3_prohibited_body': return 'عرض أي منتج مقلد أو غير أصلي على أنه "أصلي" أو "أصلي" أو "أصيل" أو "جديد تمامًا" دون الإفصاح عن ذلك بوضوح. ويشكل هذا احتيالًا تجاريًا وانتهاكًا جوهريًا لهذه الاتفاقية، مما يمنح Waslaq الحق في إزالة جميع العروض على الفور، وتجميد رصيد البائع، وتقديم تعويضات كاملة للمشترين المتضررين، وإغلاق الحساب بشكل دائم، واللجوء إلى سبل الانتصاف القانونية المدنية والجنائية، بما في ذلك المطالبة بالتعويض عن الأضرار.';
			case 'terms.s4_4_title': return '4.4 التنفيذ والتسليم';
			case 'terms.s4_4_body': return 'يتحمل البائعون وحدهم مسؤولية تلبية الطلبات في غضون فترة زمنية معقولة ومحددة مسبقًا. بالنسبة للمنتجات المادية، يتحمل البائعون مسؤولية التغليف والشحن والتسليم إلى العنوان الذي يحدده المشتري. أما بالنسبة للمنتجات الرقمية، فيجب أن يتم التسليم تلقائيًا وفورًا بعد تأكيد الدفع. وقد يؤدي تكرار الإخفاق في تلبية الطلبات إلى تعليق الحساب.';
			case 'terms.s4_5_title': return '4.5 التواصل مع المشترين';
			case 'terms.s4_5_body': return 'يجب على البائعين الرد على استفسارات المشترين عبر نظام المراسلة الخاص بالمنصة في غضون فترة زمنية معقولة. ويجب على البائعين الامتناع عن التواصل مع المشترين عبر قنوات خارجية بهدف التحايل على أنظمة الضمان أو تسوية النزاعات الخاصة بالمنصة.';
			case 'terms.s6_intro': return 'يُحظر تمامًا القيام بما يلي على منصة Waslaq. وقد تؤدي المخالفات إلى تعليق الحساب فورًا، والحظر الدائم، ومصادرة الأموال، و/أو اتخاذ إجراءات قانونية:';
			case 'terms.s6_1_title': return '6.1 انتهاكات القواعد التجارية';
			case 'terms.s6_2_title': return '6.2 المحتوى المخصص للبالغين والمحتوى غير الآمن للعمل — عدم التسامح مطلقًا';
			case 'terms.s6_2_zero_tolerance_title': return '⚠️ سياسة عدم التسامح مطلقًا';
			case 'terms.s6_2_zero_tolerance_body': return 'تُعد «واسلق» منصة تجارية صديقة للأسرة وموجهة نحو المجتمع، تخدم السوق الفلسطيني. وسيؤدي أي انتهاك لهذا البند إلى إنهاء الحساب فوراً وبشكل نهائي دون حق في الاستئناف، بغض النظر عن سجل المستخدم أو مكانته على المنصة.';
			case 'terms.s6_3_title': return '6.3 الطبقة الاجتماعية ومعايير المجتمع';
			case 'terms.s6_3_intro': return 'تخضع الميزات الاجتماعية في Waslaq — بما في ذلك المجموعات والمشاركات والتعليقات والرسائل المباشرة — لمعايير المجتمع التالية، بالإضافة إلى جميع المحظورات الأخرى الواردة في هذه الاتفاقية:';
			case 'terms.s6_4_title': return '6.4 المخالفات الفنية والأمنية';
			case 'terms.s6_5_title': return '6.5 الإنفاذ والإشراف';
			case 'terms.s6_5_body': return 'تحتفظ Waslaq بالسلطة الكاملة والأحادية وغير القابلة للمراجعة في تحديد ما يشكل انتهاكًا لهذه المعايير واتخاذ الإجراءات المناسبة، سواء بإشعار مسبق أو بدونه. وتشمل إجراءات الإنفاذ، على سبيل المثال لا الحصر، ما يلي:';
			case 'terms.s6_5_report': return 'يمكن للمستخدمين الإبلاغ عن المخالفات باستخدام نظام الإبلاغ المدمج في المنصة والمتاح في جميع المنشورات والملفات الشخصية والإعلانات. ويتم مراجعة جميع البلاغات من قِبل فريق الإشراف في Waslaq.';
			case 'terms.s7_1_title': return '7.1 محتوى المنصة';
			case 'terms.s7_1_body': return 'جميع محتويات المنصة، بما في ذلك اسم "Waslaq" وشعارها وتصميم واجهتها ورمزها المصدري ومحتواها المكتوب وميزاتها الحصرية، هي ملكية فكرية حصرية لشركة "Waslaq" وتخضع لحماية قوانين حقوق النشر والعلامات التجارية والملكية الفكرية المعمول بها. ولا يجوز لأي مستخدم إعادة إنتاج محتويات المنصة أو توزيعها أو استغلالها تجاريًا دون الحصول على موافقة خطية مسبقة.';
			case 'terms.s7_2_title': return '7.2 ترخيص محتوى المستخدم';
			case 'terms.s7_2_body': return 'من خلال نشر المحتوى على Waslaq (بما في ذلك قوائم المنتجات والصور والمنشورات والتعليقات ومحتوى المجتمع)، فإنك تمنح Waslaq ترخيصًا غير حصري وخاليًا من الرسوم وعالمي النطاق وقابل للترخيص من الباطن لاستخدام هذا المحتوى وعرضه وإعادة إنتاجه وتوزيعه لغرض تشغيل المنصة والترويج لها. وينتهي هذا الترخيص عند حذف المحتوى أو إغلاق حسابك، مع مراعاة متطلبات الاحتفاظ بالبيانات.';
			case 'terms.s7_3_title': return '7.3 حقوق الملكية الفكرية لأطراف ثالثة';
			case 'terms.s7_3_body': return 'يتحمل البائعون وحدهم المسؤولية الكاملة عن ضمان عدم انتهاك قوائم منتجاتهم وصورها وأوصافها والإشارات إلى العلامات التجارية لأي حقوق ملكية فكرية لأطراف ثالثة، بما في ذلك العلامات التجارية وحقوق النشر وبراءات الاختراع أو المظهر التجاري. ستستجيب "واسلق" لإشعارات انتهاك حقوق الملكية الفكرية الصحيحة وستقوم بإزالة المحتوى المخالف. وسيؤدي تكرار الانتهاك إلى إغلاق الحساب بشكل نهائي.';
			case 'terms.s8_1_title': return '8.1 فتح نزاع';
			case 'terms.s8_1_body': return 'يجب فتح النزاعات حصريًّا من خلال نظام النزاعات المدمج في المنصة، والذي يمكن الوصول إليه من صفحة تفاصيل الطلب تحت "الحساب" → "الطلبات". ويجب تقديم النزاعات قبل انتهاء "فترة الفحص" المعمول بها. وأي مطالبة يتم تقديمها بعد تحويل الأموال إلى البائع تُعتبر قانونياً بمثابة تنازل عنها ولن يتم النظر فيها.';
			case 'terms.s8_2_title': return '8.2 الأدلة والإجراءات';
			case 'terms.s8_2_body': return 'يقع عبء الإثبات على عاتق المشتري. ويجوز تقديم أدلة داعمة مثل الصور الفوتوغرافية ومقاطع الفيديو ولقطات الشاشة والأوصاف المكتوبة. ويجوز لـ«واسلق» أن تطلب وثائق إضافية من أي من الطرفين. وسيتم إخطار البائع ومنحه فرصة معقولة للرد خلال فترة النزاع.';
			case 'terms.s8_3_title': return '8.3 قرار المنصة';
			case 'terms.s8_3_body': return 'بعد مراجعة جميع الأدلة المقدمة، ستصدر «واسلق» قرارًا نهائيًا وملزمًا وغير قابل للاستئناف. وفي الحالات التي يثبت فيها خطأ البائع، يجوز لـ«واسلق» رد المبلغ إلى المشتري مباشرةً من الرصيد المتاح لدى البائع أو المودع في حساب الضمان، دون الحاجة إلى موافقة البائع. ويُعتبر قرار «واسلق» نهائيًا ويشكل تسوية كاملة ونهائية للنزاع.';
			case 'terms.s8_4_title': return '8.4 إساءة استخدام نظام تسوية المنازعات';
			case 'terms.s8_4_body': return 'يُعد تقديم أدلة مزورة أو ملفقة أو تم التلاعب بها في أي نزاع بمثابة احتيال. وتحتفظ "واسلاق" بالحق في إنهاء حساب المستخدم المخالف على الفور، ومصادرة أي أموال معلقة، واللجوء إلى سبل الانتصاف القانونية المدنية والجنائية.';
			case 'terms.s9_intro': return 'باستخدامك لـ Waslaq، فإنك توافق صراحةً على عدم الشروع في إجراءات استرداد المبلغ من خلال البنك الذي تتعامل معه أو الجهة المصدرة لبطاقتك أو مزود خدمة الدفع دون القيام أولاً بما يلي:';
			case 'terms.s9_breach_intro': return 'يُعد إجراء عملية استرداد غير مبررة أو سابقة لأوانها خرقًا جوهريًا لهذه الاتفاقية. وفي مثل هذه الحالات، تحتفظ Waslaq بالحق في:';
			case 'terms.s10_intro': return 'تفرض "واسلق" الرسوم التالية، والتي تخضع للتغيير بعد إخطار مسبق مدته 30 يومًا:';
			case 'terms.table_fee_type': return 'نوع الرسوم';
			case 'terms.table_amount': return 'المبلغ';
			case 'terms.table_applied_to': return 'يُطبق على';
			case 'terms.s10_note': return 'جميع الرسوم غير قابلة للاسترداد ما لم تقرر المنصة خلاف ذلك وفقًا لتقديرها الخاص. تحتفظ Waslaq بالحق في فرض رسوم أو تعديلها أو إلغائها في أي وقت، شريطة إخطار المستخدمين المعنيين مسبقًا بفترة معقولة.';
			case 'terms.s11_body': return 'تقدم "واسلق" خدماتها "كما هي" و"حسب توفرها" دون أي ضمانات من أي نوع، سواء كانت صريحة أو ضمنية، بما في ذلك على سبيل المثال لا الحصر الضمانات الضمنية المتعلقة بقابلية التسويق، أو الملاءمة لغرض معين، أو عدم الانتهاك، أو التوفر المستمر.';
			case 'terms.s11_liable_for': return 'إلى أقصى حد يسمح به القانون المعمول به، لا تتحمل شركة «واسلق» أي مسؤولية عن:';
			case 'terms.s11_cap_title': return 'الحد الأقصى للمسؤولية:';
			case 'terms.s11_cap_body': return 'في جميع الأحوال، لا يجوز أن يتجاوز إجمالي الالتزام المالي الأقصى لشركة «واسلق» تجاه أي مستخدم فيما يتعلق بأي معاملة أو مطالبة فردية القيمة الإجمالية لتلك المعاملة المحددة كما هي مسجلة على المنصة.';
			case 'terms.s12_1_title': return '12.1 بواسطة Waslaq';
			case 'terms.s12_1_body': return 'تحتفظ Waslaq بالحق في تعليق أو إنهاء أي حساب بشكل دائم، سواء بإشعار مسبق أو بدونه، في حالة انتهاك هذه الاتفاقية، أو الاشتباه في حدوث احتيال، أو الإضرار بسمعة المنصة، أو لأي سبب آخر وفقًا لتقديرها الخاص. وعند الإنهاء، سيتم إلغاء حق الوصول إلى المنصة على الفور.';
			case 'terms.s12_2_title': return '12.2 التأثير على الصناديق';
			case 'terms.s12_2_body': return 'في حالة إنهاء الحساب لسبب وجيه (بما في ذلك الاحتيال أو الإخلال الجسيم بالشروط)، تحتفظ Waslaq بالحق في حجز أي رصيد معلّق كضمان للمطالبات أو عمليات رد المبالغ المدفوعة أو الإجراءات القانونية. وسيتم تحويل الأموال غير الخاضعة لأي مطالبة إلى حساب الدفع المسجل الخاص بالمورد في غضون 30 يومًا من تاريخ إغلاق الحساب، شريطة استكمال إجراءات "اعرف عميلك" (KYC) والتحقق من الهوية.';
			case 'terms.s12_3_title': return '12.3 من جانب المستخدم';
			case 'terms.s12_3_body': return 'يمكن للمستخدمين إغلاق حساباتهم في أي وقت من خلال إعدادات الحساب. وقبل الإغلاق، يجب تنفيذ أو تسوية جميع الطلبات المعلقة، كما يجب تسوية أي أموال متنازع عليها. وستحتفظ Waslaq بسجلات المعاملات وفقًا لما يقتضيه القانون المعمول به.';
			case 'terms.s13_body': return 'تخضع هذه الاتفاقية لقوانين دولة فلسطين وتُفسَّر وتُنفَّذ وفقًا لها. ويخضع أي نزاع أو خلاف أو مطالبة تنشأ عن هذه الاتفاقية أو تتعلق بها، بما في ذلك إبرامها أو صلاحيتها أو خرقها أو إنهاؤها، للاختصاص القضائي الحصري للمحاكم الفلسطينية المختصة. ويخضع المستخدمون بشكل نهائي للاختصاص القضائي الشخصي لهذه المحاكم ويتنازلون عن أي اعتراض على الإجراءات أمامها بحجة المكان أو عدم ملاءمة المحكمة.';
			case 'terms.s14_intro': return 'تحتفظ Waslaq بالحق في تعديل شروط الاستخدام هذه أو تحديثها أو استبدالها في أي وقت. وعند إجراء تغييرات جوهرية:';
			case 'terms.s14_acceptance': return 'إن استمرار استخدام المنصة بعد تاريخ سريان أي تعديل يُعتبر موافقة كاملة وغير مشروطة من جانبك على الشروط المعدلة. إذا لم توافق على الشروط المعدلة، فيجب عليك التوقف عن استخدام المنصة ويحق لك طلب حذف حسابك.';
			case 'terms.footer_questions_title': return 'هل لديك أسئلة حول هذه الشروط؟';
			case 'terms.footer_contact_text': return 'اتصل بفريقنا القانوني على ... أو تفضل بزيارة موقعنا';
			case 'terms.table_fee_row1_type': return 'رسوم منصة الطلبات المادية';
			case 'terms.table_fee_row1_amount': return '2 شيكل ثابت لكل طلب';
			case 'terms.table_fee_row1_applied': return 'يتم تضمينها في المبلغ الإجمالي كرسوم توصيل/خدمة';
			case 'terms.table_fee_row2_type': return 'رسوم منصة المنتجات الرقمية';
			case 'terms.table_fee_row2_amount': return 'شيكل واحد لكل قطعة';
			case 'terms.table_fee_row2_applied': return 'يُخصم من المبلغ الإجمالي عند تقديم الطلب';
			case 'terms.table_fee_row3_type': return 'عمولة الدفع للبائع';
			case 'terms.table_fee_row3_amount': return '5% من مبلغ الدفع';
			case 'terms.table_fee_row3_applied': return 'يُخصم عند تنفيذ عملية الدفع';
			case 'terms.table_fee_row4_type': return 'رسوم التحويل المصرفي';
			case 'terms.table_fee_row4_amount': return '8 شواقل ثابتة لكل عملية تحويل';
			case 'terms.table_fee_row4_applied': return 'تم استيعابها من قبل المنصة — لم يتم تحميلها على المورد';
			case 'refund.page_title': return 'سياسة الاسترداد والإرجاع';
			case 'refund.last_updated': return 'تاريخ السريان: 1 مايو 2026 · آخر تحديث: 1 مايو 2026';
			case 'refund.intro': return 'تلتزم "واسلق" بتوفير تجربة تسوق عادلة وشفافة وآمنة. تحدد سياسة الاسترداد والإرجاع هذه الشروط التي يحق للمشترين بموجبها استرداد أموالهم، وإجراءات تسوية النزاعات، والتزامات البائعين فيما يتعلق بالإرجاع، والحقوق والقيود السارية على جميع الأطراف.';
			case 'refund.s1_title': return 'نافذة الفحص';
			case 'refund.s2_title': return 'شروط استحقاق استرداد المبلغ';
			case 'refund.s3_title': return 'الحالات غير المؤهلة';
			case 'refund.s4_title': return 'كيفية فتح نزاع';
			case 'refund.s5_title': return 'عبء الإثبات';
			case 'refund.s6_title': return 'معالجة عمليات استرداد الأموال';
			case 'refund.s7_title': return 'سياسات إرجاع البائعين';
			case 'refund.s8_title': return 'المنتجات الرقمية — أحكام خاصة';
			case 'refund.s9_title': return 'التزامات البائع فيما يتعلق برد الأموال';
			case 'refund.s10_title': return 'الاتصال والدعم';
			case 'refund.buyer_protection_title': return 'حماية المشتري من Waslaq';
			case 'refund.buyer_protection_desc': return 'يتم حماية كل طلب يتم تقديمه على منصة "واسلق" من خلال نظام الضمان الخاص بنا. حيث تحتفظ المنصة بأموالك في حساب آمن، ولا يتم تحويلها إلى البائع إلا بعد انتهاء فترة الفحص الإلزامية — مما يمنحك الوقت الكافي للتأكد من وصول طلبك بشكل صحيح ومطابق للوصف. ولا يُطلب منك أبدًا قبول أي طلب معيب أو غير صحيح أو مزيف.';
			case 'refund.s1_body1': return 'تُعد «فترة المراجعة» فترة تعليق إلزامية تبدأ عند تسليم الطلب أو تأكيد الشحن من البائع. خلال هذه الفترة، تظل الأموال مودعة في حساب الضمان ولا يتم تحويلها إلى البائع. يجب عليك فتح أي نزاع قبل انتهاء هذه الفترة.';
			case 'refund.physical_products_label': return 'المنتجات المادية';
			case 'refund.physical_products_body': return '48 ساعة من لحظة قيام البائع بوضع علامة "تم الشحن" على الطلب أو تأكيد التسليم.';
			case 'refund.digital_products_label': return 'المنتجات الرقمية';
			case 'refund.digital_products_body': return '24 ساعة من وقت تسليم المفتاح الرقمي أو الملف أو بيانات اعتماد الوصول إلى المشتري.';
			case 'refund.s1_important': return 'بمجرد انتهاء فترة المراجعة وتحويل الأموال إلى البائع، تعتبر المعاملة نهائية ومُسوَّاة من الناحية القانونية. ولن يتم قبول أي مطالبات باسترداد الأموال بعد هذه المرحلة تحت أي ظرف من الظروف، باستثناء حالات الاحتيال المؤكدة وفقًا لتقدير المنصة وحدها.';
			case 'refund.s2_intro': return 'تغطي خدمة حماية المشتري من Waslaq الحالات التالية. وفي كل حالة، يجب فتح نزاع قبل انتهاء فترة الفحص، ويجب أن يتضمن أدلة داعمة:';
			case 'refund.s2_item1_title': return 'لم يتم استلام المنتج';
			case 'refund.s2_item1_body': return 'لم يقم البائع بشحن الطلب في غضون فترة زمنية معقولة، ولم يقدم أي تحديث صالح لتتبع الشحنة أو تأكيدًا بالتسليم. ولم يستلم المشتري السلعة، ولا يوجد أي دليل على محاولة التسليم.';
			case 'refund.s2_item2_title': return 'يختلف بشكل كبير عما هو موصوف';
			case 'refund.s2_item2_body': return 'يختلف المنتج المستلم اختلافًا جوهريًا وجوهريًا عما ورد في الإعلان — على سبيل المثال، منتج خاطئ تمامًا، أو لون أو مقاس خاطئ لم يتم الإفصاح عنه، أو مكونات مفقودة كانت جزءًا من المنتج المُعلن عنه، أو حالة (مثل: مستعمل مقابل جديد) تتعارض مع ما ورد في الإعلان.';
			case 'refund.s2_item3_title': return 'وصلت السلعة تالفة';
			case 'refund.s2_item3_body': return 'وصل المنتج في حالة تجعله غير صالح للاستخدام أو مكسورًا أو غير قابل للاستخدام فعليًّا، حيث وقع التلف قبل استلامه من قِبل المشتري. يجب على المشتري تقديم دليل مصور أو مسجل بالفيديو يثبت التلف الذي حدث عند فتح العبوة أو عند الاستخدام الأول.';
			case 'refund.s2_item4_title': return 'منتج مقلد دون الإفصاح عن ذلك';
			case 'refund.s2_item4_body': return 'تم عرض منتج وبيعه على أنه أصلي أو حقيقي أو يحمل علامة تجارية معروفة، لكن المنتج الذي تم استلامه مزيف بشكل واضح أو غير أصلي دون الإفصاح عن ذلك مسبقًا في الإعلان. ملاحظة: إذا كان الإعلان قد أشار إلى أن المنتج نسخة مقلدة أو غير أصلي، فلا ينطبق هذا الشرط.';
			case 'refund.s2_item5_title': return 'منتج رقمي غير وظيفي';
			case 'refund.s2_item5_body': return 'المفتاح الرقمي أو رمز التفعيل أو الملف القابل للتنزيل غير صالح أو منتهي الصلاحية أو تم استخدامه بالفعل من قبل مستخدم سابق أو تالف أو غير صالح للاستخدام لأي سبب آخر وقت التسليم. يجب على المشتري تقديم دليل على الخلل (مثل لقطة شاشة لرسالة الخطأ الصادرة عن المنصة أو الناشر).';
			case 'refund.s2_item6_title': return 'تكرار الرسوم';
			case 'refund.s2_item6_body': return 'تم تحصيل المبلغ من المشتري أكثر من مرة عن نفس الطلب بسبب خطأ في معالجة الدفع. ويجب أن تتضمن الأدلة سجلات تأكيد الدفع.';
			case 'refund.s3_intro': return 'لا تشمل خدمة «حماية المشتري من واسلق» الحالات التالية بشكل صريح:';
			case 'refund.s3_item1_title': return 'تغيير الرأي';
			case 'refund.s3_item1_body': return 'تلقى المشتري المنتج الصحيح الذي لم يتعرض لأي تلف والذي تمت وصفه بدقة، ولكنه ببساطة لم يعد يرغب فيه. في هذه الحالة، تُطبق سياسة الإرجاع الخاصة بالبائع حصريًّا. ولا تتدخل Waslaq في عمليات الإرجاع الناجمة عن تغيير الرأي.';
			case 'refund.s3_item2_title': return 'فترة تقديم المطالبات بعد الفحص';
			case 'refund.s3_item2_body': return 'أي نزاع أو طلب استرداد يُقدم بعد انتهاء فترة الفحص وتسديد المبلغ إلى البائع. تُعتبر هذه المطالبات قد تم التنازل عنها قانونًا ولن يتم النظر فيها.';
			case 'refund.s3_item3_title': return 'الأضرار التي يتسبب فيها المشتري';
			case 'refund.s3_item3_body': return 'السلع التي كانت في حالة جيدة عند التسليم، لكنها تعرضت للتلف لاحقًا بسبب سوء الاستخدام أو التعامل غير السليم أو التعديل أو التلف العرضي من جانب المشتري.';
			case 'refund.s3_item4_title': return 'المنتجات المعلن عنها على أنها غير أصلية أو مقلدة';
			case 'refund.s3_item4_body': return 'المنتجات التي تم وصفها بوضوح وصراحة في عنوان الإعلان ووصفه على أنها مزيفة أو نسخة طبق الأصل أو مقلدة أو غير أصلية. وبشراء هذه المنتجات، يكون المشتري قد وافق عن علم على طبيعة المنتج.';
			case 'refund.s3_item5_title': return 'المنتجات الرقمية التي تم استرداد قيمتها';
			case 'refund.s3_item5_body': return 'المفاتيح الرقمية أو الرموز أو القسائم التي تم استرداد قيمتها أو تفعيلها أو استخدامها بالفعل من قِبل المشتري أو أي طرف شاركه المشتري الرمز، بغض النظر عما إذا كان المنتج قد حقق التوقعات بعد ذلك أم لا.';
			case 'refund.s3_item6_title': return 'مشاكل عدم التوافق المعروفة وقت الشراء';
			case 'refund.s3_item6_body': return 'المنتجات التي تعمل بالشكل الموصوف، ولكنها غير متوافقة مع الجهاز أو المنطقة أو الحساب أو المنصة الخاصة بالمشتري، شريطة أن تكون متطلبات التوافق هذه قد تم الإفصاح عنها أو كان من الممكن اكتشافها بشكل معقول في وصف المنتج.';
			case 'refund.s3_item7_title': return 'اختلافات طفيفة في المظهر';
			case 'refund.s3_item7_body': return 'اختلافات طفيفة في اللون، أو اختلافات في التغليف، أو عيوب شكلية بسيطة لا تؤثر بشكل جوهري على وظيفة المنتج أو قابليته للاستخدام، وتقع ضمن حدود التفاوت الطبيعية للمنتج.';
			case 'refund.s4_intro': return 'لطلب استرداد المبلغ أو الإبلاغ عن مشكلة تتعلق بطلبك، اتبع الخطوات التالية:';
			case 'refund.s4_step1': return 'انتقل إلى "الحساب" → "الطلبات" وابحث عن الطلب المطلوب باستخدام رقم الطلب أو التاريخ.';
			case 'refund.s4_step2': return 'انقر على "فتح نزاع" في صفحة تفاصيل الطلب. هذا الخيار متاح فقط خلال فترة الفحص السارية.';
			case 'refund.s4_step3': return 'اختر سبب النزاع الأكثر دقة من بين الفئات المتاحة.';
			case 'refund.s4_step4': return 'يرجى تقديم وصف مكتوب مفصل للمشكلة، بما في ذلك التواريخ ذات الصلة، وما استلمته، وكيف يختلف عما كان مذكورًا.';
			case 'refund.s4_step5': return 'قم بتحميل الأدلة الداعمة: الصور الفوتوغرافية، ومقاطع الفيديو، ولقطات الشاشة، والإيصالات، أو أي وثائق تدعم مطالبتك. فكلما كانت أدلتك أقوى، زادت سرعة حل المشكلة.';
			case 'refund.s4_step6': return 'أرسل النزاع. ستتلقى إشعارًا بالتأكيد. سيتم إخطار البائع ومنحه مهلة للرد.';
			case 'refund.s4_step7': return 'تابع حالة النزاع من حسابك. قد تتصل بك "واسلق" لطلب معلومات إضافية. يرجى الرد بسرعة لتجنب أي تأخير.';
			case 'refund.s4_step8': return 'ستقوم "واسلق" بمراجعة جميع الأدلة وإصدار قرار نهائي ملزم. سيتم إخطارك بالنتيجة عبر البريد الإلكتروني وإشعار داخل التطبيق.';
			case 'refund.s4_tip': return 'نصيحة: للحصول على حل أسرع، قم بفتح شكواك في أقرب وقت ممكن خلال فترة الفحص، وقدم أدلة شاملة في شكل صور أو مقاطع فيديو فور اكتشاف المشكلة.';
			case 'refund.s5_body': return 'يقع عبء الإثبات على عاتق المشتري. ولا تقبل "واسلاق" إصدار حكم لصالح المشتري إلا بعد تقديم أدلة قاطعة. وتشمل الأدلة المقبولة ما يلي:';
			case 'refund.s5_item1': return 'صور فوتوغرافية أو مقاطع فيديو واضحة للسلعة المستلمة تُظهر بوضوح العيب أو التلف أو التباين.';
			case 'refund.s5_item2': return 'مقارنة جنبًا إلى جنب بين الصور والوصف الوارد في الإعلان والمنتج المستلم.';
			case 'refund.s5_item3': return 'لقطات شاشة لرسائل الخطأ الخاصة بالمنتجات الرقمية المعطلة، بما في ذلك ردود المنصة أو الناشر على هذه الأخطاء.';
			case 'refund.s5_item4': return 'صور التغليف التي توضح حالة المنتج عند وصوله (مفيدة في حالات المطالبة بالتعويض عن الأضرار).';
			case 'refund.s5_item5': return 'التواصل الكتابي مع البائع عبر نظام المراسلة الخاص بالمنصة.';
			case 'refund.s5_warning': return 'تحذير بشأن الاحتيال: يُعد تقديم أدلة مزورة أو ملفقة أو مزيفة أو تم التلاعب بها في أي نزاع بمثابة احتيال وانتهاك خطير لشروط استخدام «واسلق». وسيتم إغلاق حسابات المخالفين فوراً وبشكل نهائي، ومصادرة جميع الأرصدة المعلقة، وقد يتم الإبلاغ عنهم إلى السلطات الفلسطينية المختصة لاتخاذ الإجراءات القانونية اللازمة.';
			case 'refund.s6_1_title': return 'عندما يُحسم النزاع لصالح المشتري';
			case 'refund.s6_1_item1': return 'الأموال التي لا تزال مودعة في حساب الضمان: يتم إلغاء عملية دفع الأموال المودعة في حساب الضمان على الفور وإعادتها إلى وسيلة الدفع الأصلية للمشتري. ولا يتعين على البائع اتخاذ أي إجراء.';
			case 'refund.s6_1_item2': return 'الأموال التي تم تحويلها بالفعل إلى المورد: يتم خصم مبلغ الاسترداد مباشرةً من الرصيد المتاح للمورد. وإذا كان رصيد المورد غير كافٍ، فستقوم المنصة باحتجاز الأرباح المستقبلية حتى يتم سداد الدين بالكامل.';
			case 'refund.s6_1_item3': return 'استرداد كامل المبلغ: يتم إعادة المبلغ الكامل للطلب إلى المشتري، بما في ذلك أي رسوم خدمة للمنصة، إن وجدت.';
			case 'refund.s6_1_item4': return 'استرداد جزئي (حل جزئي): في الحالات التي يثبت فيها وجود خطأ جزئي من كلا الطرفين، يجوز لشركة «واسلق» إصدار استرداد جزئي وفقًا لتقديرها الخاص والنهائي.';
			case 'refund.s6_2_title': return 'الجدول الزمني لاسترداد الأموال';
			case 'refund.s6_2_body': return 'تختلف مدة معالجة عمليات استرداد الأموال باختلاف مزود خدمة الدفع الذي تستخدمه:';
			case 'refund.s6_2_item1': return 'بنك فلسطين والبوابات المحلية: من 3 إلى 7 أيام عمل من تاريخ اتخاذ القرار.';
			case 'refund.s6_2_item2': return 'طرق الدفع الأخرى: قد يستغرق الأمر ما يصل إلى 14 يوم عمل، حسب المزود.';
			case 'refund.s6_2_note': return 'لا تتحمل "واسلق" المسؤولية عن أي تأخير ناجم عن المدة التي يستغرقها البنك الذي تتعامل معه أو مزود خدمة الدفع في معالجة المعاملة.';
			case 'refund.s7_body1': return 'بالإضافة إلى الحماية التي توفرها منصة Waslaq، يجوز للبائعين نشر سياساتهم الخاصة بالإرجاع والاستبدال وخدمات ما بعد البيع على صفحة متجرهم العامة. وتسري هذه السياسات الخاصة بالبائعين حصريًّا على الحالات التي لا تشملها "حماية المشتري من Waslaq" — وأكثرها شيوعًا هي حالات الإرجاع بسبب تغيير الرأي في الطلبات التي تم تنفيذها بشكل صحيح.';
			case 'refund.s7_body2': return 'لا تفرض "واسلق" سياسات الإرجاع الخاصة بالبائعين ولا تضمنها. وعلى المشترين الراغبين في إرجاع المنتجات أو استبدالها بموجب سياسة البائع الخاصة بالتنسيق مباشرةً مع البائع عبر نظام المراسلة الخاص بالمنصة.';
			case 'refund.s7_tip': return 'قبل الشراء، نوصي بالاطلاع على سياسة الإرجاع التي ينشرها البائع على صفحة متجره، لا سيما بالنسبة للسلع عالية القيمة أو المنتجات التي تعتمد على التفضيل الشخصي.';
			case 'refund.s8_body': return 'تخضع المنتجات الرقمية، بما في ذلك مفاتيح الألعاب وتراخيص البرامج والقسائم والملفات القابلة للتنزيل ورموز التنشيط، للأحكام الإضافية التالية:';
			case 'refund.s8_item1': return 'التسليم الفوري: يتم تسليم المنتجات الرقمية تلقائيًا فور تأكيد الدفع. ويُعتبر التسليم قد اكتمل عندما يصبح الرمز أو الملف متاحًا في حساب المشتري أو يتم إرساله عبر البريد الإلكتروني.';
			case 'refund.s8_item2': return 'فترة فحص مدتها 24 ساعة: يتاح للمشترين 24 ساعة من تاريخ الاستلام لاختبار المنتج والإبلاغ عن أي مشاكل. بعد انقضاء هذه الفترة، تصبح عملية البيع نهائية.';
			case 'refund.s8_item3': return 'المفاتيح غير الصالحة: إذا كان المفتاح غير صالح أو تم استخدامه بالفعل عند التسليم، يجب على المشتري تقديم لقطة شاشة لرسالة الخطأ الصادرة عن الناشر. يتم رد قيمة المطالبات الصحيحة بالكامل.';
			case 'refund.s8_item4': return 'لا يُسمح باسترداد المبلغ بعد الاستخدام: بمجرد استرداد المفتاح الرقمي أو الرمز أو الترخيص، أو تفعيله، أو استخدامه — حتى لو كان ذلك جزئيًا — يُعتبر قد تم استهلاكه بالكامل، ولن يتم استرداد المبلغ بأي حال من الأحوال، بغض النظر عن مدى الرضا.';
			case 'refund.s8_item5': return 'مشاكل تقييد المنطقة: يتحمل المشتري مسؤولية التحقق من التوافق الإقليمي قبل الشراء. لا يُسمح برد الأموال في حالة المنتجات المقيدة إقليمياً إذا كان التقييد الإقليمي قد تم الإفصاح عنه أو كان من الممكن تحديده بشكل معقول من خلال وصف المنتج.';
			case 'refund.s9_role_title': return 'توضيح دور المنصة';
			case 'refund.s9_role_body1': return 'تعمل "واسلق" حصريًّا كوسيط تقني ومالي — أي كطرف محايد بين المشترين والبائعين. ولا تتحمل المنصة أي مسؤولية عن التسليم المادي أو التغليف أو الشحن أو الخدمات اللوجستية لأي طلب. وتقع جميع التزامات التسليم بالكامل على عاتق البائع. ولا تقوم "واسلق" بتخزين البضائع المادية أو شحنها أو مناولتها أو فحصها في أي مرحلة من المراحل.';
			case 'refund.s9_role_body2': return 'بالإضافة إلى ذلك، بمجرد انتهاء فترة الفحص وإطلاق الأموال، لا تتحمل المنصة أي مسؤولية مالية عن أي طلبات استرداد أو إرجاع لاحقة. وتصبح هذه الطلبات مسألة تخص المشتري والبائع حصريًّا، وتخضع لسياسة الإرجاع التي ينشرها البائع. ولن تتدخل "واسلق" أو تتوسط أو تمول عمليات الإرجاع خارج فترة الفحص السارية تحت أي ظرف من الظروف.';
			case 'refund.s9_vendor_intro': return 'يلتزم البائعون على منصة "واسلق" بالالتزامات التالية المتعلقة برد الأموال وإرجاع المنتجات:';
			case 'refund.s9_vendor_item1': return 'يجب على البائعين التأكد من أن جميع المنتجات المشحونة تتطابق تمامًا مع الوصف والحالة والمواصفات الواردة في الإعلان.';
			case 'refund.s9_vendor_item2': return 'يجب على البائعين الرد على إخطارات النزاع خلال المدة الزمنية التي تحددها المنصة. ويُعتبر عدم الرد اعترافًا ضمنيًا وقد يؤدي إلى رد المبلغ تلقائيًا إلى المشتري.';
			case 'refund.s9_vendor_item3': return 'يجب على البائعين الامتناع عن الاتصال بالمشترين خارج نظام المراسلة الخاص بالمنصة، وذلك بهدف ثنيهم عن رفع النزاعات أو عرض ترتيبات تعويض غير مصرح بها.';
			case 'refund.s9_vendor_item4': return 'في الحالات التي يتم فيها إصدار رد أموال من رصيد البائع، يوافق البائع بشكل نهائي على هذا الخصم كشرط للمشاركة في المنصة.';
			case 'refund.s9_vendor_item5': return 'قد تؤدي النزاعات المتكررة بشأن استرداد الأموال التي يتم الفصل فيها ضد البائع إلى مراجعة الحساب، أو إطالة فترات الاحتجاز في حساب الضمان، أو تعليق الحساب.';
			case 'refund.s10_intro': return 'للاستفسار عن هذه السياسة، أو للحصول على المساعدة في رفع نزاع، أو للحصول على الدعم بشأن طلب معين:';
			case 'refund.s10_item1': return 'استخدم نظام النزاعات مباشرةً من صفحة طلبك: الحساب → الطلبات → [الطلب] → فتح نزاع';
			case 'refund.s10_item2': return 'يرجى الاتصال بفريق الدعم لدينا على العنوان support@waslaq.com';
			case 'refund.s10_item3': return 'أرسل طلب دعم عبر صفحة الاتصال الخاصة بنا';
			case 'refund.s10_note': return 'الدعم متاح باللغتين العربية والإنجليزية. ونسعى للرد على جميع الاستفسارات في غضون يوم إلى يومين عمل.';
			case 'refund.s3_body': return 'لا تشمل خدمة «حماية المشتري من واسلق» الحالات التالية بشكل صريح:';
			case 'refund.s4_body': return 'لطلب استرداد المبلغ أو الإبلاغ عن مشكلة تتعلق بطلبك، اتبع الخطوات التالية:';
			case 'refund.s10_body': return 'للاستفسار عن هذه السياسة، أو للحصول على المساعدة في رفع نزاع، أو للحصول على الدعم بخصوص طلب معين:';
			case 'refund.footer_related_policies': return 'السياسات ذات الصلة';
			case 'refund.cookie_policy_link': return 'سياسة ملفات تعريف الارتباط';
			case 'refund.contact_support_link': return 'اتصل بالدعم الفني';
			case 'vendor_finances.ready_to_withdraw': return 'جاهز للسحب';
			case 'vendor_finances.pending_escrow': return 'قيد الانتظار (حساب الضمان)';
			case 'vendor_finances.awaiting_release': return 'في انتظار إصدار الإذن بالتنفيذ';
			case 'vendor_finances.total_paid_out': return 'إجمالي المبالغ المدفوعة';
			case 'vendor_finances.lifetime_withdrawals': return 'عمليات السحب على مدى العمر';
			case 'vendor_finances.request_withdrawal': return 'طلب السحب';
			case 'vendor_finances.amount_ils': return 'المبلغ (شيكل إسرائيلي)';
			case 'vendor_finances.request_payout': return 'طلب سحب الأموال';
			case 'vendor_finances.payout_note': return 'يتم معالجة عمليات الدفع يدويًّا من قِبل مسؤول المنصة في غضون 2 إلى 5 أيام عمل.';
			case 'vendor_finances.transaction_ledger': return 'دفتر الأستاذ';
			case 'vendor_finances.no_transactions': return 'لا توجد معاملات حتى الآن.';
			case 'vendor_settings.store_logo': return 'شعار المتجر';
			case 'vendor_settings.tap_to_change': return 'انقر لتغيير';
			case 'vendor_settings.store_info': return 'معلومات عامة';
			case 'vendor_settings.store_name': return 'اسم المتجر';
			case 'vendor_settings.store_description': return 'وصف المتجر';
			case 'vendor_settings.contact': return 'الاتصال';
			case 'vendor_settings.phone': return 'الهاتف';
			case 'vendor_settings.delivery': return 'التسليم';
			case 'vendor_settings.store_location': return 'موقع المتجر (المدينة)';
			case 'vendor_settings.location_placeholder': return 'على سبيل المثال: غزة، رام الله';
			case 'vendor_settings.delivery_zone': return 'منطقة التوصيل';
			case 'vendor_settings.select_zone': return 'اختر المنطقة...';
			case 'vendor_settings.zone_note': return 'لن يتم توصيل المنتجات المادية إلا داخل المنطقة التي اخترتها.';
			case 'vendor_settings.payout': return 'المبلغ المدفوع';
			case 'vendor_settings.payout_account': return 'حساب التحويل (IBAN أو PayPal)';
			case 'vendor_settings.payout_placeholder': return 'أدخل رقم IBAN أو عنوان بريدك الإلكتروني على PayPal';
			case 'vendor_settings.payout_hint': return 'سيتم إرسال مدفوعاتك إلى هذا العنوان. تأكد من صحته.';
			case 'vendor_settings.save_settings': return 'حفظ الإعدادات';
			case 'vendor_policies.title': return 'سياسات المتجر';
			case 'vendor_policies.audit_note': return 'يؤدي تحديث سياساتك إلى إنشاء نسخة جديدة دائمة وقابلة للتدقيق القانوني. ويتم الاحتفاظ بالإصدارات السابقة.';
			case 'vendor_policies.shipping_policy': return 'سياسة الشحن';
			case 'vendor_policies.shipping_placeholder': return 'أدخل سياسة الشحن الخاصة بك...';
			case 'vendor_policies.refund_policy': return 'سياسة الإرجاع والاسترداد';
			case 'vendor_policies.refund_placeholder': return 'أدخل سياسة الإرجاع والاسترداد الخاصة بك...';
			case 'vendor_policies.save': return 'حفظ السياسات';
			case 'digital_vault.title': return 'الخزينة الرقمية';
			case 'digital_vault.subtitle': return 'المنتجات الرقمية التي اشتريتها. يُسمح بتنزيل كل منتج مرة واحدة خلال 24 ساعة من الشراء.';
			case 'digital_vault.expired': return 'منتهية الصلاحية';
			case 'digital_vault.digital_product': return 'المنتج الرقمي';
			case 'digital_vault.downloads': return 'التنزيلات';
			case 'digital_vault.order': return 'طلب';
			case 'digital_vault.expired_on': return 'انتهت صلاحيتها في';
			case 'digital_vault.limit_reached': return 'تم الوصول إلى الحد الأقصى';
			case 'vendor_products.title': return 'منتجات متجرك';
			case 'vendor_products.subtitle': return 'قم بإدارة عناصر الكتالوج المادية والرقمية.';
			case 'vendor_products.cancel_creation': return 'إلغاء الإنشاء';
			case 'vendor_products.bulk_edit_stock': return 'التعديل الجماعي للمخزون';
			case 'vendor_products.create_new_product': return 'إنشاء منتج جديد';
			case 'vendor_products.product_details': return 'تفاصيل المنتج';
			case 'vendor_products.product_details_subtitle': return 'معلومات أساسية عن المنتج الذي تبيعه.';
			case 'vendor_products.product_title': return 'اسم المنتج';
			case 'vendor_products.product_title_placeholder': return 'مثل: وعاء خزفي مصنوع يدويًا';
			case 'vendor_products.description': return 'الوصف';
			case 'vendor_products.description_placeholder': return 'أخبر المشترين عن منتجك وميزاته والمواد المصنوع منها أو تعليمات الاستخدام...';
			case 'vendor_products.product_type': return 'نوع المنتج';
			case 'vendor_products.virtual_digital': return 'افتراضي / رقمي';
			case 'vendor_products.physical_item': return 'المنتج المادي';
			case 'vendor_products.virtual_desc': return 'البرامج، ملفات PDF، الوسائط، مفاتيح التفعيل';
			case 'vendor_products.physical_desc': return 'يتطلب الشحن';
			case 'vendor_products.category': return 'الفئة';
			case 'vendor_products.select_parent_category': return 'اختر الفئة الرئيسية';
			case 'vendor_products.select_subcategory': return 'اختر فئة فرعية (اختياري)';
			case 'vendor_products.category_hint': return 'يساعد اختيار فئة فرعية محددة العملاء على العثور على منتجك بسهولة أكبر.';
			case 'vendor_products.product_images': return 'صور المنتج';
			case 'vendor_products.add_images': return 'إضافة صور';
			case 'vendor_products.digital_asset_label': return 'الأصل الرقمي / رابط الاسترداد';
			case 'vendor_products.upload_file_label': return 'الخيار 1: تحميل ملف (بحد أقصى 128 ميغابايت)';
			case 'vendor_products.choose_file': return 'اختر ملفًا لتحميله...';
			case 'vendor_products.or': return 'أو';
			case 'vendor_products.external_link_label': return 'الخيار 2: توفير رابط خارجي';
			case 'vendor_products.external_link_placeholder': return 'https://g2a.com/... أو رابط Google Drive';
			case 'vendor_products.digital_delivery_note': return 'سيتلقى العملاء هذا الملف أو الرابط تلقائيًا عبر بريدهم الإلكتروني فور إتمام عملية الدفع بنجاح.';
			case 'vendor_products.inventory_notice': return 'إشعار بشأن المخزون';
			case 'vendor_products.inventory_note': return 'تتطلب المنتجات المادية تتبعًا. يمنع نظام المخزون الذكي لدينا البيع الزائد ويوقف عملية الدفع في حالة نفاد المنتج أثناء عملية الشراء. سيتم إرسال بريد إلكتروني إليك فورًا عندما يصل مخزون المنتج إلى 0.';
			case 'vendor_products.discard': return 'تجاهل';
			case 'vendor_products.launch_product': return 'إطلاق المنتج';
			case 'vendor_products.no_products': return 'لا توجد منتجات حتى الآن';
			case 'vendor_products.no_products_desc': return 'ابدأ بإدراج أول منتج مادي أو رقمي لديك للوصول إلى العملاء في جميع أنحاء العالم.';
			case 'vendor_products.list_first_item': return 'أدرج العنصر الأول';
			case 'vendor_products.edit_product': return 'تعديل المنتج';
			case 'vendor_products.price_ils': return 'السعر (شواقل إسرائيلية)';
			case 'vendor_products.save_changes': return 'حفظ التغييرات';
			case 'vendor_products.bulk_inventory_title': return 'تحرير المخزون بالجملة';
			case 'vendor_products.bulk_inventory_subtitle': return 'اضغط على رقم لتعديله';
			case 'vendor_products.units': return 'الوحدات';
			case 'vendor_products.default_label': return 'الافتراضي';
			case 'vendor_products.cancel': return 'إلغاء';
			case 'vendor_products.save_all_changes': return 'حفظ جميع التغييرات';
			case 'vendor_products.no_managed_inventory': return 'لم يتم العثور على أي منتجات ذات مخزون مُدار.';
			case 'vendor_products.delete_confirm': return 'هل أنت متأكد من رغبتك في حذف هذا المنتج؟ لا يمكن التراجع عن هذا الإجراء.';
			case 'vendor_products.price_placeholder': return 'على سبيل المثال: 99.99';
			case 'vendor_products.file_size_error': return 'حجم الملف يتجاوز الحد الأقصى البالغ 128 ميغابايت.';
			case 'vendor_products.upload_url_error': return 'فشل الحصول على رابط التحميل';
			case 'vendor_products.upload_failed_error': return 'فشل تحميل الملف إلى R2';
			case 'vendor_products.create_failed_error': return 'فشل إنشاء المنتج';
			case 'vendor_products.unexpected_upload_error': return 'حدث خطأ غير متوقع أثناء التحميل.';
			case 'vendor_products.delete_failed_error': return 'فشل حذف المنتج';
			case 'vendor_products.delete_error': return 'حدث خطأ أثناء حذف المنتج.';
			case 'vendor_products.update_failed_error': return 'فشل تحديث المنتج';
			case 'vendor_products.generic_error': return 'حدث خطأ';
			case 'vendor_products.invalid_qty': return 'غير صالح';
			case 'vendor_products.bulk_update_failed': return 'فشلت بعض عمليات التحديث. يرجى المحاولة مرة أخرى.';
			case 'vendor_products.options_title': return 'خيارات المنتج (اللون، الحجم، المادة)';
			case 'vendor_products.add_option': return 'إضافة + خيار';
			case 'vendor_products.no_options_note': return 'لم يتم تكوين أي خيارات. سيتم إنشاء هذا كنسخة افتراضية واحدة.';
			case 'vendor_products.variant_matrix': return 'مصفوفة المتغيرات';
			case 'vendor_products.track_stock': return 'مخزون القضبان';
			case 'vendor_products.price_column': return 'السعر (شواقل إسرائيلية)';
			case 'vendor_products.sku': return 'رقم المنتج';
			case 'vendor_products.variant_column': return 'صيغة';
			case 'vendor_products.default_config': return 'الإعدادات الافتراضية';
			case 'vendor_products.type_physical': return 'البدني';
			case 'vendor_products.type_digital': return 'رقمي';
			case 'vendor_products.option_name': return 'اسم الخيار';
			case 'vendor_products.comma_separated_values': return 'قيم مفصولة بفواصل';
			case 'vendor_products.option_name_placeholder': return 'على سبيل المثال، اللون';
			case 'vendor_products.values_placeholder': return 'على سبيل المثال: الأحمر، الأزرق، الأخضر';
			case 'vendor_products.stock_qty': return 'كمية المخزون';
			case 'vendor_products.dimensions': return 'الأبعاد (العرض/الطول/الارتفاع)';
			case 'vendor_products.sku_placeholder': return 'SKU-123';
			case 'vendor_products.weight_placeholder': return 'مثل: 0.5';
			case 'vendor_products.height_placeholder': return 'ح';
			case 'vendor_products.inventory_label': return 'المخزون';
			case 'vendor_products.unlimited': return 'بلا حدود';
			case 'vendor_products.out_of_stock': return 'غير متوفر';
			case 'vendor_orders.title': return 'طلباتي';
			case 'vendor_orders.ship_to': return 'الشحن إلى:';
			case 'vendor_orders.status_shipped': return 'تم الشحن';
			case 'vendor_orders.status_pending': return 'قيد الانتظار';
			case 'vendor_orders.status_processing': return 'المعالجة';
			case 'vendor_orders.status_delivered': return 'تم التسليم';
			case 'vendor_orders.status_cancelled': return 'تم إلغاؤه';
			case 'vendor_orders.status_awaiting_pickup': return 'في انتظار الاستلام';
			case 'vendor_orders.no_orders': return 'لا توجد طلبات حتى الآن';
			case 'vendor_orders.no_orders_desc': return 'عندما يشتري العملاء منتجاتك، ستظهر الطلبات هنا.';
			case 'vendor_orders.mark_shipped': return 'وضع علامة "تم الشحن"';
			case 'vendor_orders.shipping_loading': return 'الشحن…';
			case 'vendor_orders.order_number': return 'رقم الطلب';
			case 'vendor_orders.status_completed': return 'تم الانتهاء';
			case 'dispute.back': return 'العودة';
			case 'dispute.case_resolved_vendor': return 'تمت تسوية القضية: تم تحويل الأموال إلى المورد';
			case 'dispute.case_resolved_buyer': return 'تمت تسوية القضية: تم رد المبلغ إلى المشتري';
			case 'dispute.case_resolved_full_refund': return '✅ تم حل القضية: تم إصدار استرداد كامل للمبلغ';
			case 'dispute.dispute_opened': return 'تم فتح النزاع';
			case 'dispute.under_review': return 'قيد المراجعة';
			case 'dispute.image_attachment': return 'صورة مرفقة';
			case 'dispute.admin_badge': return 'المسؤول';
			case 'dispute.loading_chat': return 'جاري تحميل الدردشة...';
			case 'dispute.not_found': return 'لم يتم العثور على النزاع.';
			case 'dispute.no_messages': return 'لا توجد رسائل حتى الآن. أرسل رسالة لبدء المحادثة.';
			case 'dispute.input_placeholder': return 'اشرح مشكلتك للمورد والمسؤول...';
			case 'dispute.attachment_label': return '📎 المرفق';
			case 'dispute.status_open': return 'فتح';
			case 'dispute.status_resolved_refund': return 'تم حل المشكلة (استرداد المبلغ)';
			case 'dispute.status_resolved_release': return 'تم حله (تم إصداره)';
			case 'dispute.status_resolved_split': return 'تم حله (مقسم)';
			case 'dispute.status_under_review': return 'قيد المراجعة';
			case 'stores.title': return 'تصفح المتاجر';
			case 'stores.subtitle': return 'اكتشف البائعين الفلسطينيين المفضلين لديك وتابعهم.';
			case 'stores.no_stores': return 'لا توجد متاجر حتى الآن.';
			case 'stores.retry': return 'Retry';
			case 'stores.no_stores_yet': return 'No stores yet';
			case 'social.message_button': return 'Message';
			case 'social.follow_button': return 'Follow';
			case 'social.visit_store_button': return 'Visit My Store';
			case 'social.share_button': return 'Share';
			case 'social.comments_heading': return 'Comments';
			case 'social.comment_placeholder': return 'What\'s on your mind?';
			case 'social.comment_button': return 'Comment';
			case 'social.no_comments': return 'No comments yet';
			case 'social.pending_button': return 'Pending';
			case 'social.following_button': return 'Following';
			case 'social.replying_to': return 'Replying to';
			case 'social.protected_posts_title': return 'These posts are protected';
			case 'social.protected_posts_desc': return 'Only approved followers can view posts.';
			case 'social.no_posts': return 'No posts yet.';
			case 'social.no_replies': return 'No replies yet.';
			case 'social.no_media': return 'No media yet.';
			case 'social.years_ago': return ({required Object n}) => '${n}y ago';
			case 'social.months_ago': return ({required Object n}) => '${n}mo ago';
			case 'social.days_ago': return ({required Object n}) => '${n}d ago';
			case 'social.hours_ago': return ({required Object n}) => '${n}h ago';
			case 'social.minutes_ago': return ({required Object n}) => '${n}m ago';
			case 'social.just_now': return 'just now';
			case 'social.years_short': return ({required Object n}) => '${n}y';
			case 'social.months_short': return ({required Object n}) => '${n}mo';
			case 'social.days_short': return ({required Object n}) => '${n}d';
			case 'social.hours_short': return ({required Object n}) => '${n}h';
			case 'social.minutes_short': return ({required Object n}) => '${n}m';
			case 'social.now_short': return 'now';
			case 'social.share_post': return ({required Object title, required Object url}) => 'Check out this post on WaslaQ: ${title}\n${url}';
			case 'store.title': return 'Store';
			case 'store.all_categories': return 'All';
			case 'store.products_count': return ({required Object count}) => '${count} products';
			case 'store.latest_arrivals': return 'Latest Arrivals';
			case 'store.price_low_high': return 'Price: Low → High';
			case 'store.price_high_low': return 'Price: High → Low';
			case 'store.no_products_found': return 'No products found';
			case 'vendor_profile.products_tab': return 'Products ({count})';
			case 'vendor_profile.qa_tab': return 'Q&A ({count})';
			case 'vendor_profile.reviews_tab': return 'Reviews ({count})';
			case 'vendor_profile.policies_tab': return 'Policies';
			case 'vendor_profile.store_not_found': return 'Store not found';
			case 'vendor_profile.no_products': return 'No products yet';
			case 'vendor_profile.no_questions': return 'No questions yet';
			case 'vendor_profile.no_reviews': return 'No reviews yet';
			case 'vendor_profile.no_policies': return 'No policies published yet';
			case 'vendor_profile.vendor_answer': return 'VENDOR ANSWER';
			case 'vendor_profile.awaiting_response': return 'Awaiting vendor response...';
			case 'vendor_profile.verified_badge': return '✓ Verified';
			case 'vendor_profile.shipping_policy': return 'Shipping Policy';
			case 'vendor_profile.return_refund_policy': return 'Return & Refund Policy';
			case 'drawer.browse': return 'BROWSE';
			case 'drawer.community_section': return 'COMMUNITY';
			case 'drawer.stores_section': return 'STORES';
			case 'drawer.account_section': return 'ACCOUNT';
			case 'drawer.info_section': return 'INFO';
			case 'drawer.legal_section': return 'LEGAL';
			case 'drawer.sign_in_prompt': return 'Sign in to access your communities and stores';
			case 'drawer.popular': return 'Popular';
			case 'drawer.news': return 'News';
			case 'drawer.saved': return 'Saved';
			case 'drawer.create_community': return 'Create Community';
			case 'drawer.no_communities_joined': return 'You haven\'t joined any communities yet';
			case 'drawer.browse_all_stores': return 'Browse All Stores';
			case 'drawer.my_store': return 'My Store';
			case 'drawer.not_vendor_yet': return 'You\'re not a vendor yet — Become one →';
			case 'drawer.about_waslaq': return 'About WaslaQ';
			case 'drawer.contact_us': return 'Contact Us';
			case 'drawer.feedback': return 'Feedback';
			case 'info.about_title': return 'About WaslaQ';
			case 'info.contact_title': return 'Contact Us';
			case 'info.feedback_title': return 'Feedback';
			case 'info.our_mission': return 'Our Mission';
			case 'info.what_we_offer': return 'What We Offer';
			case 'info.trust_safety': return 'Trust & Safety';
			case 'info.get_in_touch': return 'Get in Touch';
			case 'info.send_message': return 'Send Message';
			case 'info.help_us_improve': return 'Help us improve';
			case 'info.submit_feedback': return 'Submit Feedback';
			case 'info.message_sent': return 'Message sent! We\'ll get back to you soon.';
			case 'info.thank_you_feedback': return 'Thank you for your feedback!';
			case 'info.write_feedback_required': return 'Please write your feedback';
			case 'info.failed_submit_feedback': return 'Failed to submit. Please try again.';
			case 'info.feedback_desc': return 'Your feedback helps us build a better platform.';
			case 'info.category': return 'Category';
			case 'info.rating': return 'Rating';
			case 'info.your_feedback': return 'Your Feedback';
			case 'info.feedback_hint': return 'Tell us what you think...';
			case 'info.type_general': return 'General';
			case 'info.type_bug': return 'Bug';
			case 'info.type_feature': return 'Feature';
			case 'info.type_design': return 'Design';
			case 'info.about_subtitle': return 'Your Palestinian Marketplace';
			case 'info.our_mission_body': return 'WaslaQ is a hybrid social marketplace built for Palestine. We combine the best of community-driven content with a trusted e-commerce platform, connecting local vendors with buyers through a secure escrow system.';
			case 'info.what_we_offer_body': return '• Verified local vendors with escrow protection\n• Community-driven content and discussions\n• Digital and physical products\n• Secure payments via Stripe\n• Gaza and West Bank delivery zones';
			case 'info.trust_safety_body': return 'Every transaction is protected by our escrow system. Funds are held safely until the buyer confirms receipt. Vendors are verified and rated by the community.';
			case 'info.version': return ({required Object version}) => 'Version ${version}';
			case 'info.fill_all_fields': return 'Please fill in all fields';
			case 'info.failed_send_message': return 'Failed to send. Please try again.';
			case 'info.contact_desc': return 'Have a question or need help? Send us a message.';
			case 'info.name_label': return 'Name';
			case 'info.message_label': return 'Message';
			case 'orders.title': return 'My Orders';
			case 'orders.failed_load': return 'Failed to load orders';
			case 'orders.retry': return 'Retry';
			case 'orders.no_orders': return 'No orders yet';
			case 'orders.today': return 'Today';
			case 'orders.yesterday': return 'Yesterday';
			case 'orders.days_ago': return ({required Object n}) => '${n} days ago';
			case 'orders.weeks_ago': return ({required Object n}) => '${n}w ago';
			case 'orders.months_ago': return ({required Object n}) => '${n}mo ago';
			case 'notifications.title': return 'Notifications';
			case 'notifications.failed_load': return 'Failed to load notifications';
			case 'notifications.retry': return 'Retry';
			case 'notifications.no_notifications': return 'No notifications yet';
			case 'saved_items.title': return 'Saved Items';
			case 'saved_items.failed_load': return 'Failed to load saved items';
			case 'saved_items.retry': return 'Retry';
			case 'saved_items.products_tab': return 'Products';
			case 'saved_items.posts_tab': return 'Posts';
			case 'saved_items.no_products': return 'No saved products yet';
			case 'saved_items.no_products_sub': return 'Tap ♡ on any product to save it here.';
			case 'saved_items.no_posts': return 'No saved posts yet';
			case 'saved_items.no_posts_sub': return 'Save posts from the community feed.';
			case 'saved_items.could_not_load': return 'Could not load products';
			case 'legal.privacy_policy_title': return 'Privacy Policy';
			case 'legal.terms_title': return 'Terms of Service';
			case 'create_post.sheet_title': return 'What do you want to post?';
			case 'create_post.general_post': return 'General Post';
			case 'create_post.community_post': return 'Post in a Community';
			case 'create_post.community_post_in': return ({required Object slug}) => 'Post in r/${slug}';
			case 'create_post.share_product': return 'Share a Product';
			case 'create_post.share_product_named': return ({required Object title}) => 'Share: ${title}';
			case 'create_post.ask_product': return 'Ask About a Product';
			case 'create_post.select_community_title': return 'Select Community';
			case 'create_post.search_communities': return 'Search communities...';
			case 'create_post.show_more_communities': return 'Show More Communities';
			case 'create_post.no_communities_found': return 'No communities found';
			case 'create_post.private_community_locked': return 'Private - Join to select';
			case 'create_post.create_community': return 'Create a Community';
			case 'create_post.ai_assistant': return 'AI Assistant';
			case 'errors.network': return 'No internet connection — check your network and try again';
			case 'errors.timeout': return 'The connection is taking too long — please try again';
			case 'errors.server': return 'Something went wrong on our side — please try again shortly';
			case 'errors.unauthorized': return 'Your session has expired — please sign in again';
			case 'errors.not_found': return 'We couldn\'t find what you\'re looking for';
			case 'errors.rate_limited': return 'Too many attempts — wait a moment and try again';
			case 'errors.validation': return 'Some information looks incorrect — please review and try again';
			case 'errors.unknown': return 'Something went wrong — please try again';
			case 'errors.offline_banner': return 'No internet connection';
			case 'errors.back_online': return 'Back online';
			case 'errors.crash_title': return 'Oops, something broke';
			case 'errors.crash_message': return 'An unexpected error occurred. Please go back and try again.';
			case 'connections.title': return 'Connections';
			case 'connections.followers': return 'Followers';
			case 'connections.following': return 'Following';
			case 'connections.no_followers': return 'No followers yet';
			case 'connections.no_following': return 'Not following anyone yet';
			case 'connections.remove_follower': return 'Remove follower';
			case 'connections.remove': return 'Remove';
			case 'connections.remove_follower_confirm': return ({required Object name}) => 'Remove ${name} from your followers? They won\'t be told.';
			case 'connections.removed': return 'Follower removed';
			case 'connections.block': return 'Block';
			case 'connections.block_confirm': return ({required Object name}) => 'Block ${name}? They won\'t be able to follow or message you.';
			case 'connections.blocked': return 'User blocked';
			case 'vendor_import.title': return 'Import / Export';
			case 'vendor_import.step1_title': return 'Export Your Products';
			case 'vendor_import.step1_desc': return 'Download your existing products as an Excel file. Edit it, add new rows, then re-import. New vendors get a sample row.';
			case 'vendor_import.step1_btn': return 'Export Products (.xlsx)';
			case 'vendor_import.step2_title': return 'Import Products';
			case 'vendor_import.step2_desc': return 'Upload your completed .xlsx or .csv file. Maximum 100 products per import.';
			case 'vendor_import.tap_to_select': return 'Tap to select file';
			case 'vendor_import.file_too_large': return 'File exceeds 5MB limit.';
			case 'vendor_import.import_completed': return 'Import completed!';
			case 'vendor_import.import_failed': return ({required Object error}) => 'Import failed: ${error}';
			case 'vendor_import.export_failed': return ({required Object error}) => 'Export failed: ${error}';
			case 'vendor_import.export_share_text': return 'WaslaQ Products Export';
			case 'vendor_import.start_import': return 'Start Import';
			case 'vendor_import.results_title': return 'Import Results';
			case 'vendor_import.products_created': return ({required Object count}) => '${count} Products Created';
			case 'vendor_import.rows_failed': return ({required Object count}) => '${count} Rows Failed';
			case 'vendor_import.import_another': return 'Import Another';
			case 'vendor_import.done': return 'Done';
			default: return null;
		}
	}
}

extension on StringsAr {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'nav.home': return 'الرئيسية';
			case 'nav.category': return 'الفئة';
			case 'nav.community': return 'المجتمع';
			case 'nav.messages': return 'الرسائل';
			case 'nav.search_placeholder': return 'ابحث عن المنتجات أو المتاجر أو المبدعين...';
			case 'nav.cart': return 'عربة التسوق';
			case 'nav.saved': return 'تم الحفظ';
			case 'nav.stores': return 'المتاجر';
			case 'nav.browse_all_stores': return 'تصفح جميع المتاجر';
			case 'nav.my_store': return 'متجري';
			case 'nav.account': return 'حسابي';
			case 'nav.info': return 'المعلومات';
			case 'nav.about_waslaq': return 'عن واصلك';
			case 'nav.contact_us': return 'اتصل بنا';
			case 'nav.feedback': return 'ملاحظات';
			case 'nav.create_community': return 'إنشاء مجتمع';
			case 'nav.explore': return 'اكتشف';
			case 'explore.products': return 'المنتجات';
			case 'explore.communities': return 'المجتمعات';
			case 'explore.stores': return 'المتاجر';
			case 'explore.browse_categories': return 'تصفح الفئات';
			case 'explore.popular_searches': return 'عمليات البحث الشائعة';
			case 'explore.all_communities': return 'كل المجتمعات';
			case 'explore.select_community': return 'اختر مجتمع';
			case 'explore.filter': return 'تصفية';
			case 'explore.category': return 'الفئة';
			case 'explore.brand': return 'العلامة التجارية';
			case 'explore.color': return 'اللون';
			case 'explore.clear_filters': return 'مسح التصفية';
			case 'explore.apply': return 'تطبيق';
			case 'explore.filter_by_community': return 'حسب المجتمع';
			case 'explore.search_communities': return 'ابحث عن مجتمعات...';
			case 'explore.my_communities': return 'مجتمعاتي';
			case 'explore.no_communities_joined': return 'لم تنضم إلى أي مجتمع بعد';
			case 'explore.explore_communities': return 'استكشف المجتمعات';
			case 'explore.select_community_to_filter': return 'اختر مجتمعاً لتصفية المنشورات';
			case 'explore.all_posts': return 'كل المنشورات';
			case 'explore.private_join_required': return 'انضم لهذا المجتمع الخاص لاختياره';
			case 'explore.public': return 'عام';
			case 'auth.sign_in': return 'تسجيل الدخول';
			case 'auth.sign_up': return 'إنشاء حساب';
			case 'auth.sign_out': return 'تسجيل الخروج';
			case 'auth.email': return 'البريد الإلكتروني';
			case 'auth.password': return 'كلمة المرور';
			case 'auth.display_name': return 'الاسم المعروض';
			case 'auth.username': return 'اسم المستخدم';
			case 'auth.forgot_password': return 'هل نسيت كلمة المرور؟';
			case 'auth.no_account': return 'ليس لديك حساب؟';
			case 'auth.have_account': return 'هل لديك حساب بالفعل؟';
			case 'auth.create_account': return 'إنشاء حساب';
			case 'auth.continue_google': return 'متابعة باستخدام Google';
			case 'auth.continue_facebook': return 'متابعة عبر فيسبوك';
			case 'auth.become_vendor': return 'انضم إلى قائمة الموردين';
			case 'auth.want_to_sell': return 'هل تريد البيع؟';
			case 'auth.signing_in': return 'جاري تسجيل الدخول...';
			case 'auth.creating_account': return 'جاري إنشاء الحساب...';
			case 'auth.username_available': return 'اسم المستخدم متاح';
			case 'auth.checking': return 'جاري التحقق...';
			case 'auth.or_continue_with': return 'أو تابع';
			case 'auth.or_sign_up_email': return 'أو قم بالتسجيل باستخدام بريدك الإلكتروني';
			case 'auth.login_title': return 'تسجيل الدخول';
			case 'auth.required_field': return 'مطلوب';
			case 'account.my_orders': return 'طلباتي';
			case 'account.orders': return 'الطلبات';
			case 'account.track_purchases': return 'تتبع مشترياتك وسجل طلباتك.';
			case 'account.addresses': return 'العناوين';
			case 'account.downloads': return 'التنزيلات';
			case 'account.notifications': return 'الإشعارات';
			case 'account.profile': return 'الملف الشخصي';
			case 'account.saved_items': return 'العناصر المحفوظة';
			case 'account.disputes': return 'النزاعات';
			case 'account.vendor_dashboard': return 'لوحة تحكم الموردين';
			case 'account.settings': return 'الإعدادات';
			case 'account.no_orders': return 'لا توجد طلبات حتى الآن';
			case 'account.no_orders_desc': return 'لم تقم بتقديم أي طلبات حتى الآن. ابدأ التسوق وستظهر طلباتك هنا.';
			case 'account.start_shopping': return 'ابدأ التسوق';
			case 'account.view_order': return 'عرض الطلب';
			case 'account.back_to_orders': return 'العودة إلى الطلبات';
			case 'account.order_placed': return 'تم تقديم الطلب';
			case 'account.processing': return 'المعالجة';
			case 'account.shipped': return 'تم الشحن';
			case 'account.delivered': return 'تم التسليم';
			case 'account.order_progress': return 'تقدم الطلب';
			case 'account.items': return 'العناصر';
			case 'account.total': return 'المجموع';
			case 'account.shipping_address': return 'عنوان الشحن';
			case 'account.problem_order': return 'هل تواجه مشكلة في طلبك؟';
			case 'account.dispute_window': return 'يمكنك رفع نزاع في غضون 4 أيام من تاريخ التسليم.';
			case 'account.open_dispute': return 'فتح نزاع';
			case 'account.cancel': return 'إلغاء';
			case 'account.submit_dispute': return 'تقديم شكوى';
			case 'account.what_issue': return 'ما هي المشكلة؟';
			case 'account.non_delivery': return 'عدم التسليم';
			case 'account.non_delivery_desc': return 'لم تصل السلعة أبدًا';
			case 'account.damaged_wrong': return 'تالف / خاطئ';
			case 'account.damaged_wrong_desc': return 'لا يتطابق مع الوصف';
			case 'account.describe_issue': return 'صف المشكلة';
			case 'account.my_communities': return 'مجتمعاتي';
			case 'account.my_posts': return 'منشوراتي وتعليقاتي';
			case 'account.vendor_center': return 'مركز تحكم البائع';
			case 'account.account_privacy': return 'الحساب والخصوصية';
			case 'account.sign_out': return 'تسجيل الخروج';
			case 'account.edit_profile': return 'تعديل الملف الشخصي';
			case 'account.followers': return 'المتابعون';
			case 'account.following': return 'يتابع';
			case 'account.profile_settings': return 'إعدادات الملف الشخصي';
			case 'account.privacy_settings': return 'إعدادات الخصوصية';
			case 'account.privacy': return 'الخصوصية';
			case 'account.private_account': return 'حساب خاص';
			case 'account.show_activity': return 'إظهار حالة النشاط';
			case 'account.follow_requests': return 'طلبات المتابعة';
			case 'account.account_settings': return 'إعدادات الحساب';
			case 'account.connected_accounts': return 'الحسابات المرتبطة';
			case 'account.delete_account': return 'حذف الحساب';
			case 'account.change_password': return 'تغيير كلمة المرور';
			case 'account.order_status_title': return 'حالة الطلب';
			case 'account.order_label': return 'الطلب';
			case 'account.payment_label': return 'الدفع';
			case 'account.fulfillment_label': return 'التنفيذ';
			case 'account.placed': return 'تاريخ الطلب';
			case 'account.items_count': return ({required Object count}) => 'المنتجات (${count})';
			case 'account.qty_label': return ({required Object count}) => 'الكمية: ${count}';
			case 'account.order_number': return ({required Object id}) => 'طلب رقم #${id}';
			case 'account.title': return 'الحساب';
			case 'account.my_orders_label': return 'طلباتي';
			case 'account.saved_items_label': return 'العناصر المحفوظة';
			case 'account.messages_label': return 'الرسائل';
			case 'account.notifications_label': return 'الإشعارات';
			case 'account.settings_label': return 'الإعدادات';
			case 'account.privacy_policy_label': return 'سياسة الخصوصية';
			case 'account.terms_label': return 'شروط الخدمة';
			case 'account.sign_out_label': return 'تسجيل الخروج';
			case 'account.vendor_dashboard_label': return 'لوحة تحكم البائع';
			case 'account.become_vendor_label': return 'كن بائعاً';
			case 'account.sign_in_welcome': return 'WaslaQ';
			case 'account.sign_in_desc': return 'سجّل الدخول للاطلاع على حسابك\nوطلباتك ورسائلك.';
			case 'account.sign_in_btn': return 'تسجيل الدخول';
			case 'account.create_account_btn': return 'إنشاء حساب';
			case 'account.failed_load_orders': return 'فشل تحميل الطلبات';
			case 'account.section_shopping': return 'التسوق';
			case 'account.section_community': return 'المجتمع';
			case 'account.section_communities': return 'مجتمعاتي';
			case 'account.section_vendor': return 'البائع';
			case 'account.section_settings': return 'الإعدادات';
			case 'account.section_legal': return 'قانوني';
			case 'account.following_stores_label': return 'المتاجر المتابعة';
			case 'product.add_to_cart': return 'أضف إلى سلة التسوق';
			case 'product.sold': return ({required Object count}) => 'تم بيع ${count}';
			case 'product.no_seller': return 'بائع محلي';
			case 'product.buy_now': return 'اشترِ الآن';
			case 'product.save': return 'حفظ';
			case 'product.saved': return 'تم الحفظ';
			case 'product.reviews': return 'التعليقات';
			case 'product.questions': return 'أسئلة وأجوبة';
			case 'product.write_review': return 'اكتب تقييماً';
			case 'product.ask_question': return 'اطرح سؤالاً';
			case 'product.no_reviews': return 'لا توجد تعليقات حتى الآن. كن أول من يكتب تعليقًا على هذا المنتج.';
			case 'product.no_questions': return 'لا توجد أسئلة حتى الآن. كن أول من يسأل!';
			case 'product.verified': return 'تم التحقق منه';
			case 'product.verified_purchase': return 'شراء تم التحقق منه';
			case 'product.vendor_answer': return 'إجابة البائع';
			case 'product.waiting_answer': return 'في انتظار رد البائع...';
			case 'product.submit_review': return 'إرسال تقييم';
			case 'product.submit_question': return 'إرسال سؤال';
			case 'product.your_rating': return 'تقييمك';
			case 'product.your_review': return 'تقييمك';
			case 'product.ask_anonymously': return 'اطرح سؤالك دون الكشف عن هويتك';
			case 'product.customer_reviews': return 'آراء العملاء';
			case 'product.qty': return 'الكمية';
			case 'product.in_stock': return 'متوفر';
			case 'product.out_of_stock': return 'غير متوفر';
			case 'product.related_products': return 'المنتجات ذات الصلة';
			case 'product.from_store': return 'من المتجر';
			case 'product.visit_store': return 'زيارة المتجر';
			case 'product.quantity': return 'الكمية';
			case 'product.reviews_label': return 'التعليقات';
			case 'product.qa_label': return 'أسئلة وأجوبة العملاء';
			case 'product.official_store': return 'المتجر الرسمي';
			case 'product.product_information': return 'معلومات عن المنتج';
			case 'product.verified_reviews': return 'تقييمات تم التحقق منها';
			case 'product.customer_qa': return 'أسئلة وأجوبة العملاء';
			case 'product.delivery_local': return 'يتولى البائع إدارة التوصيل المحلي بشكل مباشر.';
			case 'product.escrow_protected': return 'محمية بواسطة خدمة Waslaq Escrow حتى يتم تأكيد التسليم.';
			case 'product.material': return 'المواد';
			case 'product.origin': return 'الأصل';
			case 'product.no_description': return 'لم يتم توفير وصف.';
			case 'product.price_on_request': return 'السعر عند الطلب';
			case 'product.review_submitted': return 'تم إرسال التقييم بنجاح!';
			case 'product.question_submitted': return 'تم إرسال السؤال! سيقوم البائع بالرد قريباً.';
			case 'product.write_your_review': return 'اكتب تقييمك هنا...';
			case 'product.type_your_question': return 'اكتب سؤالك حول هذا المنتج...';
			case 'product.you_might_also_like': return 'قد يعجبك أيضاً';
			case 'product.must_purchase': return 'يمكنك تقييم المنتجات التي قمت بشرائها فقط';
			case 'product.sign_in_to_review': return 'يرجى تسجيل الدخول لترك تقييم';
			case 'product.sign_in_to_ask': return 'يرجى تسجيل الدخول لطرح سؤال';
			case 'product.product_not_found': return 'المنتج غير موجود';
			case 'product.delivery_hint_trust': return 'توصيل محلي — يشحن من فلسطين';
			case 'product.buyer_protection_trust': return 'حماية المشتري — الضمان حتى الاستلام';
			case 'product.options': return 'الخيارات';
			case 'product.default_variant': return 'الافتراضي';
			case 'product.product_info': return 'معلومات المنتج';
			case 'product.customer_reviews_count': return ({required Object count}) => 'آراء العملاء (${count})';
			case 'product.verified_buyer': return 'مشتري مؤكد';
			case 'product.questions_answers_count': return ({required Object count}) => 'الأسئلة والأجوبة (${count})';
			case 'product.please_select_rating': return 'يرجى تحديد التقييم';
			case 'product.failed_submit_review': return 'فشل تقديم التقييم';
			case 'product.please_enter_question': return 'يرجى كتابة سؤالك';
			case 'product.failed_submit_question': return 'فشل تقديم السؤال';
			case 'product.added_to_cart_success': return 'تمت الإضافة إلى العربة ✓';
			case 'product.failed_add_to_cart': return 'فشل الإضافة إلى العربة';
			case 'product.share_product': return ({required Object title, required Object url}) => 'شاهد هذا المنتج على واصلك: ${title}\n${url}';
			case 'product.community_discussions': return 'مناقشات المجتمع';
			case 'vendor.store': return 'متجر';
			case 'vendor.products': return 'المنتجات';
			case 'vendor.follow': return 'تابع';
			case 'vendor.following': return 'يتابع';
			case 'vendor.followers': return 'المتابعون';
			case 'vendor.reviews': return 'التعليقات';
			case 'vendor.policy': return 'السياسات';
			case 'vendor.verified': return 'تم التحقق منه';
			case 'vendor.share': return 'مشاركة';
			case 'vendor.no_products': return 'لا توجد منتجات متوفرة حتى الآن.';
			case 'vendor.your_store_products': return 'منتجات متجرك';
			case 'vendor.create_product': return 'إنشاء منتج جديد';
			case 'vendor.product_title': return 'اسم المنتج';
			case 'vendor.description': return 'الوصف';
			case 'vendor.product_type': return 'نوع المنتج';
			case 'vendor.physical_item': return 'المنتج المادي';
			case 'vendor.virtual_digital': return 'افتراضي / رقمي';
			case 'vendor.requires_shipping': return 'يتطلب الشحن';
			case 'vendor.software_keys': return 'البرامج، ملفات PDF، الوسائط، مفاتيح التفعيل';
			case 'vendor.category': return 'الفئة';
			case 'vendor.select_parent_category': return 'اختر الفئة الرئيسية';
			case 'vendor.select_subcategory': return 'اختر فئة فرعية (اختياري)';
			case 'vendor.product_images': return 'صور المنتج';
			case 'vendor.add_images': return 'إضافة صور';
			case 'vendor.launch_product': return 'إطلاق المنتج';
			case 'vendor.discard': return 'تجاهل';
			case 'vendor.cancel_creation': return 'إلغاء الإنشاء';
			case 'vendor.bulk_edit_stock': return 'التعديل الجماعي للمخزون';
			case 'vendor.save_changes': return 'حفظ التغييرات';
			case 'vendor.edit_product': return 'تحرير المنتج';
			case 'vendor.price_ils': return 'السعر (شواقل إسرائيلية)';
			case 'vendor.delete_product_confirm': return 'هل أنت متأكد من رغبتك في حذف هذا المنتج؟ لا يمكن التراجع عن هذا الإجراء.';
			case 'vendor.official_store': return 'متجر رسمي';
			case 'vendor.visit_store': return 'زيارة المتجر';
			case 'vendor.qa_tab': return 'أسئلة وأجوبة';
			case 'vendor.all_products': return 'جميع المنتجات';
			case 'vendor.no_reviews': return 'لا توجد تقييمات بعد';
			case 'vendor.failed_load_store': return 'فشل تحميل المتجر';
			case 'vendor.store_not_found': return 'المتجر غير موجود';
			case 'vendor.reviews_count': return ({required Object count}) => '${count} تقييمات';
			case 'vendor.tab_products': return ({required Object count}) => 'المنتجات (${count})';
			case 'vendor.tab_qa': return ({required Object count}) => 'الأسئلة والأجوبة (${count})';
			case 'vendor.tab_reviews': return ({required Object count}) => 'التقييمات (${count})';
			case 'vendor.tab_policies': return 'السياسات';
			case 'vendor.no_products_yet': return 'لا توجد منتجات بعد';
			case 'vendor.no_questions_yet': return 'لا توجد أسئلة بعد';
			case 'vendor.awaiting_response': return 'في انتظار رد البائع...';
			case 'vendor.no_reviews_yet': return 'لا توجد تقييمات بعد';
			case 'vendor.no_stores_yet': return 'لا توجد متاجر بعد';
			case 'vendor.rating_out_of_five': return ({required Object rating}) => '${rating}/5';
			case 'vendor.no_policies_yet': return 'لم يتم نشر أي سياسات بعد';
			case 'vendor.shipping_policy': return 'سياسة الشحن';
			case 'vendor.refund_policy': return 'سياسة الإرجاع والاسترداد';
			case 'vendor.terms_of_use': return 'شروط الاستخدام';
			case 'vendor.privacy_policy': return 'سياسة الخصوصية';
			case 'checkout.checkout': return 'الخروج';
			case 'checkout.shipping': return 'الشحن';
			case 'checkout.payment': return 'الدفع';
			case 'checkout.review': return 'مراجعة';
			case 'checkout.place_order': return 'تقديم الطلب';
			case 'checkout.order_summary': return 'ملخص الطلب';
			case 'checkout.subtotal': return 'المجموع الفرعي';
			case 'checkout.shipping_cost': return 'الشحن';
			case 'checkout.total': return 'المجموع';
			case 'checkout.first_name': return 'الاسم الأول';
			case 'checkout.last_name': return 'اللقب';
			case 'checkout.address': return 'العنوان';
			case 'checkout.city': return 'المدينة';
			case 'checkout.country': return 'البلد';
			case 'checkout.phone': return 'الهاتف';
			case 'checkout.email': return 'البريد الإلكتروني';
			case 'checkout.continue_action': return 'تابع';
			case 'checkout.back': return 'العودة';
			case 'checkout.card_number': return 'رقم البطاقة';
			case 'checkout.pay_now': return 'ادفع الآن';
			case 'checkout.processing': return 'جاري المعالجة...';
			case 'checkout.shipping_address': return 'عنوان الشحن';
			case 'checkout.billing_address': return 'عنوان الفواتير';
			case 'checkout.delivery': return 'التسليم';
			case 'checkout.review_order': return 'مراجعة الطلب وتقديمه';
			case 'checkout.shipping_to': return 'الشحن إلى';
			case 'checkout.payment_method': return 'طريقة الدفع';
			case 'checkout.method': return 'الطريقة';
			case 'checkout.details': return 'التفاصيل';
			case 'checkout.recipient': return 'المستلم';
			case 'checkout.contact': return 'الاتصال';
			case 'checkout.continue_delivery': return 'المضي قدماً إلى التسليم';
			case 'checkout.continue_payment': return 'المضي قدماً إلى الدفع';
			case 'checkout.continue_review': return 'تابع المراجعة';
			case 'checkout.select_shipping': return 'اختر طريقة الشحن التي تفضلها';
			case 'checkout.secure_processing': return 'معالجة آمنة للمدفوعات';
			case 'checkout.terms_notice': return 'بالنقر على زر "تقديم الطلب"، فإنك تؤكد أنك قد قرأت وفهمت ووافقت على "شروط الاستخدام" و"شروط البيع" و"سياسة الإرجاع" الخاصة بنا، وتقر بأنك قد قرأت "سياسة الخصوصية" الخاصة بـ WaslaQ.';
			case 'checkout.billing_delivery_address': return 'عنوان الفواتير / التسليم';
			case 'checkout.discount': return 'خصم';
			case 'checkout.taxes': return 'الضرائب';
			case 'checkout.postal_code': return 'الرمز البريدي';
			case 'checkout.billing_same_as_shipping': return 'عنوان الفواتير هو نفسه عنوان الشحن';
			case 'checkout.saved_address_prompt': return 'هل ترغب في استخدام عنوان محفوظ؟';
			case 'checkout.mixed_cart_warning': return 'المنتجات المادية متاحة للتسليم داخل فلسطين فقط. أما المنتجات الرقمية فيمكن شحنها إلى جميع أنحاء العالم.';
			case 'checkout.your_phone_number': return 'رقم هاتفك';
			case 'checkout.payment_failed': return 'فشلت عملية الدفع. يرجى المحاولة مرة أخرى.';
			case 'checkout.try_again': return 'حاول مرة أخرى';
			case 'checkout.address_line_1': return 'العنوان - السطر 1';
			case 'checkout.province_optional': return 'المحافظة / الولاية (اختياري)';
			case 'checkout.continue_shipping': return 'متابعة الشحن';
			case 'checkout.cart_empty': return 'عربة التسوق فارغة';
			case 'checkout.qty': return ({required Object count}) => 'الكمية: ${count}';
			case 'checkout.continue_shopping': return 'متابعة التسوق';
			case 'checkout.customer_info_step': return 'المعلومات';
			case 'checkout.delivery_step': return 'التوصيل';
			case 'checkout.payment_step': return 'الدفع';
			case 'checkout.customer_info_title': return 'معلومات العميل';
			case 'checkout.no_shipping_options': return 'لا توجد خيارات شحن متاحة';
			case 'checkout.agree_prefix': return 'أوافق على ';
			case 'checkout.terms_link': return 'شروط الاستخدام';
			case 'checkout.and_text': return ' و';
			case 'checkout.privacy_link': return 'سياسة الخصوصية';
			case 'category.browse_categories': return 'تصفح الفئات';
			case 'category.subcategories': return 'الفئات الفرعية';
			case 'category.recommended': return 'موصى به';
			case 'category.for_you': return 'من أجلك';
			case 'category.products_coming_soon': return 'المنتجات قريبًا';
			case 'category.no_subcategories': return 'لا توجد فئات فرعية حتى الآن.';
			case 'category.select_category': return 'اختر فئة';
			case 'community.community': return 'المجتمع';
			case 'community.join': return 'انضم';
			case 'community.joined': return 'انضم';
			case 'community.leave': return 'مغادرة';
			case 'community.leave_title': return 'مغادرة المجتمع';
			case 'community.leave_confirm': return 'هل أنت متأكد من مغادرة هذا المجتمع؟';
			case 'community.create_post': return 'إنشاء منشور';
			case 'community.post': return 'منشور';
			case 'community.comment': return 'تعليق';
			case 'community.comments': return 'التعليقات';
			case 'community.reply': return 'الرد';
			case 'community.share': return 'مشاركة';
			case 'community.save': return 'حفظ';
			case 'community.report': return 'تقرير';
			case 'community.upvote': return 'صوّت بالموافقة';
			case 'community.members': return 'الأعضاء';
			case 'community.online': return 'عبر الإنترنت';
			case 'community.rules': return 'القواعد';
			case 'community.about': return 'نبذة عن';
			case 'community.new_post': return 'منشور جديد';
			case 'community.title': return 'العنوان';
			case 'community.content': return 'المحتوى';
			case 'community.submit': return 'إرسال';
			case 'community.cancel': return 'إلغاء';
			case 'community.ask_anonymously': return 'اطرح سؤالك دون الكشف عن هويتك';
			case 'community.no_posts': return 'لا توجد مشاركات حتى الآن.';
			case 'community.be_first': return 'كن أول من يعلق!';
			case 'community.hot': return 'ساخن';
			case 'community.new_label': return 'جديد';
			case 'community.top': return 'أعلى';
			case 'community.private_community': return 'مجتمع خاص';
			case 'community.created': return 'تاريخ الإنشاء';
			case 'community.request_to_join': return 'اطلب الانضمام لرؤية المنشورات والمحتوى';
			case 'community.welcome': return 'أهلاً بك في المجتمع!';
			case 'community.trending_communities': return 'المجتمعات الشائعة';
			case 'community.see_all': return 'عرض الكل';
			case 'community.whats_on_your_mind': return 'ما الذي يدور في ذهنك؟';
			case 'community.no_posts_subtitle': return 'كن أول من يشارك شيئاً!';
			case 'community.select_community': return 'اختر مجتمعاً';
			case 'community.add_images': return 'إضافة صور';
			case 'community.add_more_images': return 'إضافة المزيد ({count}/5)';
			case 'community.members_count': return ({required Object count}) => '${count} أعضاء';
			case 'community.title_required': return 'العنوان مطلوب';
			case 'community.select_community_required': return 'يرجى اختيار مجتمع';
			case 'community.post_created': return 'تم إنشاء المنشور!';
			case 'community.failed_create_post': return 'فشل إنشاء المنشور. يرجى المحاولة مرة أخرى.';
			case 'community.post_action': return 'نشر';
			case 'community.write_post_hint': return 'اكتب منشورك... (اختياري)';
			case 'community.add_more_images_param': return ({required Object count}) => 'إضافة المزيد (${count}/5)';
			case 'community.failed_load_post': return 'فشل تحميل المنشور';
			case 'community.error_loading_comments': return 'خطأ في تحميل التعليقات';
			case 'community.no_comments_yet': return 'لا توجد تعليقات حتى الآن. كن أول من يشارك أفكاره!';
			case 'community.view_more_replies': return 'عرض المزيد من الردود';
			case 'community.add_comment': return 'أضف تعليقاً...';
			case 'community.login_to_comment': return 'سجل الدخول للتعليق';
			case 'community.members_label': return ({required Object count}) => 'الأعضاء: ${count}';
			case 'community.joined_checkmark': return 'تم الانضمام ✓';
			case 'community.error_loading_posts': return ({required Object error}) => 'خطأ في تحميل المنشورات: ${error}';
			case 'community.explore_communities': return 'استكشف المجتمعات';
			case 'community.no_communities_found': return 'لم يتم العثور على مجتمعات';
			case 'community.error_loading': return 'خطأ في التحميل';
			case 'messages.messages': return 'الرسائل';
			case 'messages.no_messages': return 'لا توجد رسائل حتى الآن';
			case 'messages.type_message': return 'اكتب رسالة...';
			case 'messages.send': return 'إرسال';
			case 'messages.online': return 'عبر الإنترنت';
			case 'messages.seen': return 'تمت القراءة';
			case 'messages.title': return 'الرسائل';
			case 'messages.load_more': return 'تحميل المزيد';
			case 'messages.start_conversation': return 'ابدأ محادثة';
			case 'messages.offline': return 'غير متصل';
			case 'messages.last_seen': return 'شوهد آخر مرة';
			case 'messages.deleted': return 'تم حذف هذه الرسالة...';
			case 'messages.input_placeholder': return 'اكتب رسالتك';
			case 'messages.yesterday_at': return 'بالأمس في';
			case 'messages.no_contacts': return 'لا توجد جهات اتصال حتى الآن.';
			case 'messages.follow_someone': return 'تابع شخصًا ما لبدء الدردشة!';
			case 'messages.select_conversation': return 'اختر محادثة أو ابدأ محادثة جديدة';
			case 'messages.online_now': return 'متصل الآن';
			case 'messages.seen_prefix': return 'شوهد بواسطة';
			case 'messages.unknown_user': return 'مستخدم مجهول';
			case 'messages.sign_in_view': return 'سجل الدخول لعرض الرسائل';
			case 'messages.connect_vendors_buyers': return 'تواصل مع البائعين والمشترين';
			case 'messages.could_not_connect': return 'تعذر الاتصال بالرسائل';
			case 'messages.not_connected': return 'غير متصل';
			case 'messages.no_conversations': return 'لا توجد محادثات بعد';
			case 'messages.tap_pencil_start': return 'انقر على أيقونة القلم لبدء\nمحادثة جديدة';
			case 'messages.could_not_open_chat': return ({required Object error}) => 'تعذر فتح المحادثة: ${error}';
			case 'messages.new_message': return 'رسالة جديدة';
			case 'messages.search_hint': return 'البحث بالاسم أو اسم المستخدم...';
			case 'messages.no_users_found': return 'لم يتم العثور على مستخدمين';
			case 'common.unknown_user': return 'غير معروف';
			case 'common.loading': return 'جاري التحميل...';
			case 'common.error': return 'حدث خطأ ما';
			case 'common.error_prefix': return ({required Object error}) => 'خطأ: ${error}';
			case 'common.retry': return 'أعد المحاولة';
			case 'common.save': return 'حفظ';
			case 'common.cancel': return 'إلغاء';
			case 'common.delete': return 'حذف';
			case 'common.edit': return 'تحرير';
			case 'common.close': return 'إغلاق';
			case 'common.search': return 'بحث';
			case 'common.filter': return 'فلتر';
			case 'common.sort': return 'ترتيب';
			case 'common.view_all': return 'عرض الكل';
			case 'common.show_more': return 'عرض المزيد';
			case 'common.show_less': return 'إخفاء المزيد';
			case 'common.confirm': return 'تأكيد';
			case 'common.back': return 'العودة';
			case 'common.next': return 'التالي';
			case 'common.submit': return 'إرسال';
			case 'common.success': return 'النجاح';
			case 'common.currency': return '₪';
			case 'common.free': return 'مجانًا';
			case 'common.required': return 'مطلوب';
			case 'common.optional': return 'اختياري';
			case 'common.save_changes': return 'احفظ التغييرات';
			case 'common.sort_by': return 'ترتيب حسب';
			case 'common.no_products': return 'لا توجد منتجات';
			case 'common.reset': return 'إعادة تعيين';
			case 'common.filters': return 'الفلاتر';
			case 'common.item_type': return 'نوع المنتج';
			case 'common.price_range': return 'نطاق السعر';
			case 'common.show_results': return 'إظهار النتائج';
			case 'common.digital': return 'رقمي';
			case 'common.physical': return 'مادي';
			case 'common.min': return 'الأقل';
			case 'common.max': return 'الأعلى';
			case 'common.latest': return 'الأحدث';
			case 'common.price_asc': return 'السعر: من الأقل للأعلى';
			case 'common.price_desc': return 'السعر: من الأعلى للأقل';
			case 'common.approve': return 'موافقة';
			case 'common.reject': return 'رفض';
			case 'common.legal': return 'القانوني';
			case 'common.cancel_label': return 'إلغاء';
			case 'common.retry_label': return 'إعادة المحاولة';
			case 'common.months.0': return 'يناير';
			case 'common.months.1': return 'فبراير';
			case 'common.months.2': return 'مارس';
			case 'common.months.3': return 'أبريل';
			case 'common.months.4': return 'مايو';
			case 'common.months.5': return 'يونيو';
			case 'common.months.6': return 'يوليو';
			case 'common.months.7': return 'أغسطس';
			case 'common.months.8': return 'سبتمبر';
			case 'common.months.9': return 'أكتوبر';
			case 'common.months.10': return 'نوفمبر';
			case 'common.months.11': return 'ديسمبر';
			case 'common.categories': return 'الفئات';
			case 'common.failed_load_categories': return 'فشل تحميل الفئات';
			case 'common.no_categories': return 'لا توجد فئات';
			case 'common.no_subcategories': return 'لا توجد فئات فرعية';
			case 'home.hero_title': return 'اكتشف. تواصل. تسوق.';
			case 'home.hero_subtitle': return 'السوق الاجتماعي الفلسطيني';
			case 'home.shop_now': return 'تسوق الآن';
			case 'home.featured_products': return 'المنتجات المميزة';
			case 'home.trending': return 'الأكثر تداولاً';
			case 'home.new_arrivals': return 'أحدث المنتجات';
			case 'home.top_stores': return 'أفضل المتاجر';
			case 'home.browse_categories': return 'تصفح الفئات';
			case 'home.failed_load_products': return 'فشل تحميل المنتجات';
			case 'home.no_products_yet': return 'لا توجد منتجات بعد';
			case 'home.secure_escrow': return 'حساب ضمان آمن';
			case 'home.verified_sellers': return 'بائعون موثوقون';
			case 'home.local_support': return 'دعم محلي';
			case 'home.search_placeholder': return 'بحث عن المنتجات، المتاجر...';
			case 'home.drawer_sign_in_hint': return 'سجل الدخول للوصول إلى مجتمعاتك ومتاجرك';
			case 'home.drawer_browse': return 'تصفح';
			case 'home.drawer_popular': return 'شائع';
			case 'home.drawer_news': return 'الأخبار';
			case 'home.drawer_community': return 'المجتمع';
			case 'home.drawer_create_community': return 'إنشاء مجتمع';
			case 'home.drawer_no_communities': return 'لم تنضم إلى أي مجتمعات بعد';
			case 'home.drawer_stores': return 'المتاجر';
			case 'home.drawer_browse_stores': return 'تصفح جميع المتاجر';
			case 'home.drawer_my_store': return 'متجري';
			case 'home.drawer_become_vendor_hint': return 'لست بائعاً بعد — كن بائعاً الآن ←';
			case 'home.drawer_account': return 'الحساب';
			case 'home.drawer_info': return 'معلومات';
			case 'home.drawer_about': return 'حول WaslaQ';
			case 'home.drawer_contact': return 'اتصل بنا';
			case 'home.drawer_feedback': return 'ملاحظات';
			case 'home.drawer_legal': return 'قانوني';
			case 'home.trending_discussions': return 'نقاشات رائجة';
			case 'home.more_products': return 'المزيد من المنتجات';
			case 'footer.privacy_policy': return 'سياسة الخصوصية';
			case 'footer.terms_of_use': return 'شروط الاستخدام';
			case 'footer.refund_policy': return 'سياسة الاسترداد والإرجاع';
			case 'footer.customer_service': return 'خدمة العملاء';
			case 'footer.company': return 'الشركة';
			case 'footer.feedback': return 'ملاحظات';
			case 'footer.contact_us': return 'اتصل بنا';
			case 'footer.about_us': return 'من نحن';
			case 'footer.get_the_app': return 'احصل على التطبيق';
			case 'footer.coming_soon': return 'قريباً على Android و iOS';
			case 'footer.made_in_palestine': return 'صُنع في فلسطين';
			case 'footer.all_rights': return 'جميع الحقوق محفوظة';
			case 'community_settings.title': return 'إعدادات المجتمع';
			case 'community_settings.general_tab': return 'عام';
			case 'community_settings.appearance_tab': return 'المظهر';
			case 'community_settings.privacy_tab': return 'الخصوصية';
			case 'community_settings.rules_tab': return 'القواعد';
			case 'community_settings.community_title': return 'عنوان المجتمع';
			case 'community_settings.description': return 'الوصف / السيرة الذاتية';
			case 'community_settings.community_icon': return 'رمز المجتمع';
			case 'community_settings.community_banner': return 'لافتة المجتمع';
			case 'community_settings.upload_icon': return 'رمز التحميل';
			case 'community_settings.upload_image': return 'تحميل صورة';
			case 'community_settings.choose_color': return 'اختر اللون';
			case 'community_settings.save_appearance': return 'حفظ المظهر';
			case 'community_settings.save_general': return 'حفظ الإعدادات العامة';
			case 'community_settings.save_privacy': return 'حفظ إعدادات الخصوصية';
			case 'community_settings.save_rules': return 'حفظ القواعد';
			case 'community_settings.private_community': return 'مجتمع خاص';
			case 'community_settings.private_description': return 'لا يمكن إلا للأعضاء المعتمدين عرض المحتوى ونشره';
			case 'community_settings.community_rules': return 'قواعد المجتمع';
			case 'community_settings.rules_placeholder': return 'قواعد منفصلة مع فواصل أسطر مزدوجة...';
			case 'community_settings.danger_zone': return 'منطقة الخطر';
			case 'community_settings.danger_description': return 'إجراءات لا رجعة فيها قريبًا';
			case 'community_settings.manage_community': return 'إدارة المجتمع';
			case 'community_settings.members': return 'الأعضاء';
			case 'community_settings.remove': return 'إزالة';
			case 'community_settings.joined': return 'انضم';
			case 'community_settings.back_to_community': return 'العودة إلى r/';
			case 'feedback.title': return 'إرسال ملاحظات';
			case 'feedback.subtitle': return 'ساعدنا في تحسين WaslaQ';
			case 'feedback.full_name': return 'الاسم الكامل';
			case 'feedback.email': return 'عنوان البريد الإلكتروني';
			case 'feedback.about': return 'ما هو الموضوع؟';
			case 'feedback.message': return 'رسالة';
			case 'feedback.submit': return 'إرسال ملاحظات';
			case 'feedback.submitting': return 'جاري الإرسال...';
			case 'contact.title': return 'اتصل بنا';
			case 'contact.subtitle': return 'سنقوم بالرد عليك في أقرب وقت ممكن';
			case 'contact.subject': return 'الموضوع (اختياري)';
			case 'contact.submit': return 'إرسال رسالة';
			case 'contact.submitting': return 'جاري الإرسال...';
			case 'about.title': return 'نبذة عن WaslaQ';
			case 'about.tagline': return 'السوق الاجتماعي الفلسطيني';
			case 'about.our_mission': return 'مهمتنا';
			case 'about.how_it_works': return 'كيف يعمل';
			case 'about.secure_escrow': return 'حساب ضمان آمن';
			case 'about.mission_body': return '"WaslaQ" هي أول منصة تسويق اجتماعية مختلطة في فلسطين — تجمع بين قوة النقاش المجتمعي والتجارة الإلكترونية الموثوقة. نحن نربط بين المشترين والبائعين الفلسطينيين في بيئة آمنة ومحمية بنظام الضمان، حيث تكون كل معاملة آمنة ويتم الاستماع إلى كل صوت.';
			case 'about.local_vendors_title': return 'البائعون المحليون';
			case 'about.local_vendors_desc': return 'تسوق مباشرة من بائعين فلسطينيين معتمدين.';
			case 'about.community_first_title': return 'المجتمع أولاً';
			case 'about.community_first_desc': return 'ناقش، واطلع على التقييمات، وتواصل مع المشترين الآخرين.';
			case 'about.escrow_desc': return 'يتم الاحتفاظ بأموالك في أمان حتى تؤكد استلامها.';
			case 'about.our_values': return 'قيمنا';
			case 'about.value_community': return 'المجتمع';
			case 'about.value_transparency': return 'الشفافية';
			case 'about.value_trust': return 'الثقة';
			case 'about.value_palestine': return 'فلسطين أولاً';
			case 'disutes.title': return 'نزاعاتي';
			case 'disutes.cases_count': return 'الحالات';
			case 'disutes.no_disputes': return 'لم يتم العثور على أي نزاعات';
			case 'disutes.all_good': return 'جميع طلباتك سارية المفعول';
			case 'user_profile.followers': return 'المتابعون';
			case 'user_profile.following': return 'يتابع';
			case 'user_profile.visit_store': return 'تفضل بزيارة متجري';
			case 'user_profile.media_tab': return 'وسائل الإعلام';
			case 'user_profile.replies_tab': return 'الردود';
			case 'user_profile.posts_tab': return 'المشاركات';
			case 'user_profile.no_replies': return 'لا توجد ردود حتى الآن';
			case 'user_profile.edit_profile': return 'تحرير الملف الشخصي';
			case 'user_profile.failed_load': return 'فشل تحميل الملف الشخصي';
			case 'user_profile.view_store': return 'عرض المتجر';
			case 'user_profile.no_posts_yet': return 'لا توجد منشورات بعد';
			case 'user_profile.coming_soon': return 'قريباً';
			case 'user_profile.stats': return ({required Object followers, required Object posts}) => '${followers} من المتابعين  ·  ${posts} منشورات';
			case 'account_dropdown.signed_in_as': return 'تم تسجيل الدخول باسم';
			case 'account_dropdown.my_profile': return 'ملفي الشخصي';
			case 'account_dropdown.account_dashboard': return 'لوحة معلومات الحساب';
			case 'account_dropdown.vendor_dashboard': return 'لوحة تحكم الموردين';
			case 'account_dropdown.language': return 'اللغة';
			case 'account_dropdown.log_out': return 'تسجيل الخروج';
			case 'account_dropdown.welcome': return 'أهلاً بك!';
			case 'account_dropdown.welcome_hint': return 'سجل الدخول لمزامنة عناصرك المحفوظة وتتبع طلباتك.';
			case 'account_dropdown.login': return 'تسجيل الدخول';
			case 'account_dropdown.register': return 'إنشاء حساب';
			case 'vendor_dashboard.title': return 'لوحة تحكم الموردين';
			case 'vendor_dashboard.products_tab': return 'المنتجات';
			case 'vendor_dashboard.orders_tab': return 'الطلبات';
			case 'vendor_dashboard.overview_tab': return 'نظرة عامة';
			case 'vendor_dashboard.live_badge': return 'بث مباشر';
			case 'vendor_dashboard.hours_ago': return ({required Object count}) => 'قبل ${count} ساعة';
			case 'vendor_dashboard.days_ago': return ({required Object count}) => 'قبل ${count} يوم';
			case 'vendor_dashboard.order_number': return ({required Object id}) => 'طلب رقم ${id}';
			case 'vendor_dashboard.performance_summary': return 'ملخص الأداء خلال الأيام السبعة الماضية';
			case 'vendor_dashboard.profit_7d': return 'الربح (7 أيام)';
			case 'vendor_dashboard.revenue_7d': return 'الإيرادات (7 أيام)';
			case 'vendor_dashboard.after_fees': return 'بعد خصم الرسوم';
			case 'vendor_dashboard.orders_count': return 'الطلبات';
			case 'vendor_dashboard.pending': return 'قيد الانتظار';
			case 'vendor_dashboard.available': return 'متوفر';
			case 'vendor_dashboard.awaiting_release': return 'في انتظار الإصدار';
			case 'vendor_dashboard.withdraw_any': return 'سحب أي';
			case 'vendor_dashboard.qa_inbox_tab': return 'صندوق الأسئلة والأجوبة';
			case 'vendor_dashboard.finances_tab': return 'المالية';
			case 'vendor_dashboard.policies_tab': return 'السياسات';
			case 'vendor_dashboard.settings_tab': return 'الإعدادات';
			case 'vendor_dashboard.disputes': return 'النزاعات';
			case 'vendor_dashboard.all_clear': return 'كل شيء على ما يرام';
			case 'vendor_dashboard.live_listings': return 'قائمة العروض الحية';
			case 'vendor_dashboard.pending_desc': return 'الأموال المودعة في حساب ضمان، في انتظار انتهاء فترة الفحص قبل الإفراج عنها.';
			case 'vendor_dashboard.available_desc': return 'تم تحرير الأموال من حساب الضمان وهي جاهزة للسحب إلى حسابك المصرفي.';
			case 'vendor_dashboard.qa_inbox_heading': return 'صندوق الأسئلة والأجوبة';
			case 'vendor_dashboard.no_questions': return 'لا توجد أسئلة حتى الآن. ستظهر هنا عندما يطرحها العملاء.';
			case 'vendor_dashboard.orders_7d': return 'الطلبات (7 أيام)';
			case 'vendor_dashboard.open_disputes': return 'النزاعات المفتوحة';
			case 'vendor_dashboard.in_escrow': return ({required Object amount}) => '${amount} في الضمان';
			case 'vendor_dashboard.recent_orders': return 'الطلبـات الأخيرة';
			case 'vendor_dashboard.order_marked_shipped': return 'تم تحديد الطلب كـ مشحون ✅';
			case 'vendor_dashboard.marking': return 'جاري التحديد...';
			case 'vendor_dashboard.mark_as_shipped': return 'تحديد كـ مشحون';
			case 'vendor_dashboard.ship_to': return ({required Object name}) => 'الشحن إلى: ${name}';
			case 'vendor_dashboard.qty_price': return ({required Object qty, required Object price}) => 'الكمية: ${qty} · ₪${price}';
			case 'vendor_dashboard.no_products_yet': return 'لا توجد منتجات بعد.\nاضغط على + لإضافة منتجك الأول.';
			case 'vendor_dashboard.add_product': return 'إضافة منتج';
			case 'vendor_dashboard.edit_product': return 'تعديل المنتج';
			case 'vendor_dashboard.title_required': return 'العنوان مطلوب';
			case 'vendor_dashboard.virtual_require_file': return 'المنتجات الافتراضية تتطلب ملفًا أو رابطًا';
			case 'vendor_dashboard.title_label': return 'العنوان *';
			case 'vendor_dashboard.price_ils_label': return 'السعر (شيكل) *';
			case 'vendor_dashboard.type_label': return 'النوع:';
			case 'vendor_dashboard.digital_file_url': return 'رابط الملف الرقمي *';
			case 'vendor_dashboard.upload_file_instead': return 'تحميل ملف بدلاً من ذلك';
			case 'vendor_dashboard.file_selected': return ({required Object filename}) => 'الملف المحدد: ${filename}';
			case 'vendor_dashboard.digital_hint': return 'الصق رابطًا مباشرًا أو قم بتحميل الملف الرقمي (PDF, ZIP, MP3، إلخ)';
			case 'vendor_dashboard.select_category': return 'اختر الفئة';
			case 'vendor_dashboard.sku_optional': return 'رمز SKU (اختياري)';
			case 'vendor_dashboard.manage_inventory': return 'إدارة المخزون';
			case 'vendor_dashboard.inventory_quantity': return 'كمية المخزون';
			case 'vendor_dashboard.create_product': return 'إنشاء المنتج';
			case 'vendor_dashboard.price_ils': return 'السعر (شيكل)';
			case 'vendor_dashboard.delete_product': return 'حذف المنتج';
			case 'vendor_dashboard.delete_confirm': return ({required Object title}) => 'حذف "${title}"؟ لا يمكن التراجع عن هذا الإجراء.';
			case 'vendor_dashboard.inventory_untracked': return 'المخزون: غير متتبع';
			case 'vendor_dashboard.stock_count': return ({required Object count}) => 'المخزون: ${count}';
			case 'vendor_dashboard.add': return 'إضافة';
			case 'vendor_dashboard.total_earned': return 'إجمالي الأرباح';
			case 'vendor_dashboard.paid_out': return 'المدفوعات';
			case 'vendor_dashboard.payout_to': return ({required Object account}) => 'التحويل إلى: ${account}';
			case 'vendor_dashboard.request_withdrawal': return 'طلب سحب';
			case 'vendor_dashboard.invalid_amount': return 'أدخل مبلغاً صالحاً';
			case 'vendor_dashboard.amount_exceeds': return ({required Object balance}) => 'المبلغ يتجاوز الرصيد المتاح (₪${balance})';
			case 'vendor_dashboard.payout_submitted': return 'تم تقديم طلب السحب! سيقوم المسؤول بمعالجته قريباً.';
			case 'vendor_dashboard.amount_ils': return 'المبلغ (شيكل)';
			case 'vendor_dashboard.withdraw': return 'سحب';
			case 'vendor_dashboard.payout_hint': return 'سيتم إرسال المدفوعات إلى حسابك المصرفي المسجل.';
			case 'vendor_dashboard.payout_history': return 'سجل المدفوعات';
			case 'vendor_dashboard.transaction_ledger': return 'دفتر المعاملات';
			case 'vendor_dashboard.re_product': return ({required Object title}) => 'بخصوص: ${title}';
			case 'vendor_dashboard.public': return 'عام';
			case 'vendor_dashboard.private': return 'خاص';
			case 'vendor_dashboard.your_answer': return 'إجابتك';
			case 'vendor_dashboard.edit_answer': return 'تعديل الإجابة';
			case 'vendor_dashboard.type_answer_placeholder': return 'اكتب إجابتك...';
			case 'vendor_dashboard.store_policies': return 'سياسات المتجر';
			case 'vendor_dashboard.policies_hint': return 'كل حفظ يقوم بإنشاء نسخة جديدة. يتم الاحتفاظ بالنسخ السابقة للتدقيق.';
			case 'vendor_dashboard.saved_version': return ({required Object version}) => 'تم الحفظ كإصدار v${version} ✅';
			case 'vendor_dashboard.shipping_policy': return 'سياسة الشحن';
			case 'vendor_dashboard.shipping_hint': return 'كيف تقوم بالشحن؟ أوقات التسليم المتوقعة؟';
			case 'vendor_dashboard.refund_policy': return 'سياسة الاسترداد';
			case 'vendor_dashboard.refund_hint': return 'ما هي عملية الاسترداد الخاصة بك؟';
			case 'vendor_dashboard.return_policy': return 'سياسة الإرجاع';
			case 'vendor_dashboard.return_hint': return 'ما هي شروط الإرجاع الخاصة بك؟';
			case 'vendor_dashboard.privacy_hint': return 'كيف تتعامل مع بيانات العملاء؟';
			case 'vendor_dashboard.terms_hint': return 'الشروط والأحكام للمشترين.';
			case 'vendor_dashboard.save_policies': return 'حفظ السياسات';
			case 'vendor_dashboard.store_settings': return 'إعدادات المتجر';
			case 'vendor_dashboard.store_logo': return 'شعار المتجر';
			case 'vendor_dashboard.change_logo': return 'تغيير الشعار';
			case 'vendor_dashboard.store_banner': return 'لافتة المتجر';
			case 'vendor_dashboard.add_store_banner': return 'إضافة لافتة المتجر';
			case 'vendor_dashboard.store_name_required': return 'اسم المتجر مطلوب';
			case 'vendor_dashboard.slug_label': return 'الرابط البديل (URL)';
			case 'vendor_dashboard.contact_email': return 'البريد الإلكتروني للتواصل';
			case 'vendor_dashboard.payout_iban': return 'رقم الحساب المصرفي (IBAN) / معرف الحساب';
			case 'vendor_dashboard.settings_saved': return 'تم حفظ الإعدادات ✅';
			case 'vendor_dashboard.save_settings': return 'حفظ الإعدادات';
			case 'vendor_dashboard.resolved_refund': return 'تم الحل – مسترد';
			case 'vendor_dashboard.resolved_release': return 'تم الحل – مفرج عنه';
			case 'vendor_dashboard.respond_to_dispute': return 'الرد على النزاع';
			case 'vendor_dashboard.response_empty': return 'لا يمكن أن يكون الرد فارغاً';
			case 'vendor_dashboard.your_response': return 'ردك';
			case 'vendor_dashboard.explain_side_placeholder': return 'اشرح وجهة نظرك في النزاع...';
			case 'vendor_dashboard.submit_response': return 'تقديم الرد';
			case 'vendor_dashboard.resolved_date': return ({required Object date}) => 'تم الحل في: ${date}';
			case 'vendor_dashboard.opened_date': return ({required Object date}) => 'تم الفتح في: ${date}';
			case 'vendor_dashboard.update_response': return 'تعديل الرد';
			case 'vendor_dashboard.respond': return 'الرد';
			case 'vendor_dashboard.no_disputes_hint': return 'لا توجد نزاعات.\nجميع طلباتك تسير بسلاسة! ✅';
			case 'notifications_settings.title': return 'الإشعارات';
			case 'notifications_settings.mark_all_read': return 'وضع علامة "تمت قراءتها" على كل الرسائل';
			case 'notifications_settings.new_followers': return 'متابعون جدد';
			case 'notifications_settings.comments': return 'التعليقات على منشوراتك';
			case 'notifications_settings.upvotes': return 'التصويتات الإيجابية على منشوراتك';
			case 'notifications_settings.mentions': return 'الإشارات';
			case 'notifications_settings.follow_requests': return 'طلبات المتابعة';
			case 'saved.title': return 'العناصر المحفوظة';
			case 'saved.subtitle': return 'اعرض المنتجات والمنشورات والتعليقات التي قمت بحفظها في مكان واحد';
			case 'saved.comments_tab': return 'التعليقات';
			case 'saved.posts_tab': return 'المشاركات';
			case 'saved.products_tab': return 'المنتجات';
			case 'saved.no_products': return 'لم يتم حفظ أي منتجات حتى الآن';
			case 'saved.no_products_hint': return 'انقر على أيقونة القلب الموجودة على أي منتج لإضافته إلى قائمة المفضلة';
			case 'search.no_results': return 'لم يتم العثور على أي نتائج';
			case 'search.no_results_hint': return 'تأكد من كتابة الاسم بشكل صحيح وحاول مرة أخرى';
			case 'search.go_home': return 'الذهاب إلى الصفحة الرئيسية';
			case 'search.see_all_results': return 'عرض جميع النتائج لـ';
			case 'search.placeholder': return 'البحث عن المنتجات، المتاجر، المجتمعات...';
			case 'search.initial_title': return 'البحث عن المنتجات، المتاجر،';
			case 'search.initial_subtitle': return 'المجتمعات والمستخدمين';
			case 'search.no_results_query': return ({required Object query}) => 'لا توجد نتائج لـ "${query}"';
			case 'search.try_different': return 'جرب كلمة بحث أخرى';
			case 'search.products': return 'المنتجات';
			case 'search.vendor_stores': return 'متاجر البائعين';
			case 'search.communities': return 'المجتمعات';
			case 'search.users': return 'المستخدمين';
			case 'search.posts': return 'المنشورات';
			case 'search.type_product': return 'منتج';
			case 'search.type_store': return 'متجر';
			case 'search.type_community': return 'مجتمع';
			case 'search.type_user': return 'مستخدم';
			case 'search.type_post': return 'منشور';
			case 'search.post_author_votes': return ({required Object author, required Object score}) => 'بواسطة u/${author} · ${score} أصوات';
			case 'cart.title': return 'عربة التسوق';
			case 'cart.empty_message': return 'لا يوجد أي منتجات في سلة التسوق الخاصة بك. دعنا نغير ذلك، استخدم الرابط أدناه لبدء تصفح منتجاتنا.';
			case 'cart.explore_products': return 'اكتشف المنتجات';
			case 'cart.could_not_load': return 'تعذر تحميل عربة التسوق';
			case 'cart.empty_title': return 'عربة التسوق الخاصة بك فارغة';
			case 'cart.start_shopping': return 'ابدأ التسوق';
			case 'cart.subtotal': return 'المجموع الفرعي';
			case 'cart.shipping': return 'الشحن';
			case 'cart.discount': return 'الخصم';
			case 'cart.total': return 'الإجمالي';
			case 'cart.proceed_to_checkout': return 'المتابعة إلى الدفع';
			case 'settings.profile_tab': return 'الملف الشخصي';
			case 'settings.account_tab': return 'الحساب';
			case 'settings.privacy_tab': return 'الخصوصية';
			case 'settings.notifications_tab': return 'الإشعارات';
			case 'settings.banner': return 'لافتة';
			case 'settings.avatar': return 'أفاتار';
			case 'settings.bio': return 'السيرة الذاتية';
			case 'settings.location': return 'المدينة / البلد';
			case 'settings.website': return 'الموقع الإلكتروني';
			case 'settings.gender': return 'النوع الاجتماعي';
			case 'settings.hobbies': return 'الهوايات';
			case 'settings.social_links': return 'روابط مواقع التواصل الاجتماعي';
			case 'settings.avatar_gallery': return 'اختر من معرض الصور الرمزية';
			case 'settings.upload_photo': return 'تحميل صورة';
			case 'settings.change_color': return 'تغيير اللون';
			case 'settings.upload_image': return 'تحميل صورة';
			case 'settings.prefer_not_say': return 'أفضل عدم الإفصاح';
			case 'settings.character_count': return 'الشخصية:';
			case 'settings.current_username': return 'الحالي:';
			case 'settings.username_once_per_year': return 'لا يمكنك تغيير اسم المستخدم الخاص بك إلا مرة واحدة في السنة';
			case 'settings.send_reset_link': return 'إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني';
			case 'settings.reset_link_button': return 'إرسال رابط إعادة الضبط';
			case 'settings.connected': return 'متصل';
			case 'settings.permanent_action': return 'هذه العملية نهائية ولا يمكن التراجع عنها';
			case 'settings.delete_account': return 'حذف حسابي';
			case 'settings.page_title': return 'الإعدادات';
			case 'settings.nav_profile': return 'الملف الشخصي';
			case 'settings.nav_account': return 'الحساب';
			case 'settings.nav_privacy': return 'الخصوصية';
			case 'settings.nav_notifications': return 'الإشعارات';
			case 'settings.private_account_desc': return 'لا يمكن إلا للمتابعين المعتمدين رؤية منشوراتك';
			case 'settings.activity_status_desc': return 'اسمح للآخرين بمعرفة متى تكون متصلاً';
			case 'settings.notif_new_followers': return 'متابعون جدد';
			case 'settings.notif_new_followers_desc': return 'عندما يتابعك شخص ما';
			case 'settings.notif_comments': return 'التعليقات على منشوراتك';
			case 'settings.notif_comments_desc': return 'عندما يعلق أحدهم';
			case 'settings.notif_upvotes': return 'التصويت الإيجابي على منشوراتك';
			case 'settings.notif_upvotes_desc': return 'عندما يصوّت أحدهم بالموافقة';
			case 'settings.notif_mentions': return 'الإشارات';
			case 'settings.notif_mentions_desc': return 'عندما يذكرك أحدهم';
			case 'settings.notif_follow_requests': return 'طلبات المتابعة';
			case 'settings.notif_follow_requests_desc': return 'عندما يطلب شخص ما متابعتك';
			case 'settings.notif_note': return 'ملاحظة: سيتم تفعيل خدمة إرسال الإشعارات بالكامل بمجرد توصيل نظام الإشعارات.';
			case 'settings.city_country': return 'المدينة / البلد';
			case 'settings.city_placeholder': return 'على سبيل المثال: رام الله، فلسطين';
			case 'settings.hobbies_hint': return 'اضغط على مفتاح Enter لإضافة';
			case 'settings.hobbies_placeholder': return 'على سبيل المثال: التصوير الفوتوغرافي، والألعاب';
			case 'settings.save_profile': return 'حفظ الملف الشخصي';
			case 'settings.title': return 'الإعدادات';
			case 'settings.profile_section': return 'الملف الشخصي';
			case 'settings.notifications_section': return 'الإشعارات';
			case 'settings.about_section': return 'حول';
			case 'settings.edit_display_name': return 'تعديل اسم العرض';
			case 'settings.not_set': return 'غير محدد';
			case 'settings.edit_bio': return 'تعديل النبذة';
			case 'settings.bio_subtitle': return 'أخبر الآخرين عن نفسك';
			case 'settings.username_label': return 'اسم المستخدم';
			case 'settings.username_subtitle': return 'لا يمكن تغييره بعد التسجيل';
			case 'settings.push_notifications': return 'إشعارات الدفع';
			case 'settings.push_notifications_subtitle': return 'تفعيل جميع إشعارات الدفع';
			case 'settings.order_updates': return 'تحديثات الطلبات';
			case 'settings.order_updates_subtitle': return 'تنبيهات الشحن والتسليم والمدفوعات';
			case 'settings.social_activity': return 'النشاط الاجتماعي';
			case 'settings.social_activity_subtitle': return 'الإعجابات والتعليقات والمتابعات والردود';
			case 'settings.promotions': return 'العروض الترويجية';
			case 'settings.promotions_subtitle': return 'صفقات وعروض من البائعين';
			case 'settings.app_version': return 'إصدار التطبيق';
			case 'settings.terms_label': return 'شروط الخدمة';
			case 'settings.privacy_label': return 'سياسة الخصوصية';
			case 'settings.contact_support': return 'التواصل مع الدعم';
			case 'settings.display_name_dialog': return 'اسم العرض';
			case 'settings.bio_dialog': return 'النبذة الشخصية';
			case 'settings.enter_display_name_hint': return 'أدخل اسم العرض';
			case 'settings.bio_hint': return 'اكتب نبذة قصيرة...';
			case 'settings.cancel': return 'إلغاء';
			case 'settings.save': return 'حفظ';
			case 'settings.saved_ok': return 'تم الحفظ بنجاح';
			case 'settings.save_failed': return ({required Object error}) => 'فشل الحفظ: ${error}';
			case 'settings.hub_profile': return 'الملف الشخصي';
			case 'settings.hub_profile_sub': return 'الصورة الشخصية، نبذة، روابط التواصل';
			case 'settings.hub_account': return 'الحساب والأمان';
			case 'settings.hub_account_sub': return 'البريد الإلكتروني، كلمة المرور، القفل البيومتري';
			case 'settings.hub_address': return 'دفتر العناوين';
			case 'settings.hub_address_sub': return 'عناوين التوصيل في فلسطين';
			case 'settings.hub_refund': return 'تفاصيل الاسترداد';
			case 'settings.hub_refund_sub': return 'البيانات البنكية لاسترداد النزاعات';
			case 'settings.hub_privacy': return 'الخصوصية والسلامة';
			case 'settings.hub_privacy_sub': return 'الظهور، المحظورون، طلبات المتابعة';
			case 'settings.hub_notifications': return 'الإشعارات';
			case 'settings.hub_notifications_sub': return 'الدفع، الطلبات، التنبيهات الاجتماعية';
			case 'settings.hub_content': return 'المحتوى والخلاصة';
			case 'settings.hub_content_sub': return 'فلتر اللغة، الكلمات المكتومة';
			case 'settings.hub_appearance': return 'المظهر واللغة';
			case 'settings.hub_appearance_sub': return 'السمة، اللغة، الخط، إمكانية الوصول';
			case 'settings.hub_storage': return 'التخزين والأداء';
			case 'settings.hub_storage_sub': return 'الذاكرة المؤقتة، استخدام البيانات';
			case 'settings.hub_vendor': return 'إعدادات البائع';
			case 'settings.hub_vendor_sub': return 'وضع الإجازة، مناطق التوصيل';
			case 'settings.hub_app': return 'التطبيق';
			case 'settings.hub_app_sub': return 'مشاركة، تقييم، الصلاحيات، الإصدار';
			case 'settings.hub_support': return 'الدعم والضمان';
			case 'settings.hub_support_sub': return 'المساعدة، النزاعات، القانونية';
			case 'settings.appearance_title': return 'المظهر واللغة';
			case 'settings.lang_section': return 'اللغة';
			case 'settings.lang_app_label': return 'لغة التطبيق';
			case 'settings.theme_section': return 'السمة';
			case 'settings.theme_light': return 'السمة الفاتحة';
			case 'settings.theme_dark': return 'السمة الداكنة';
			case 'settings.theme_system': return 'اتباع النظام';
			case 'settings.text_size_section': return 'حجم النص';
			case 'settings.text_adjust_label': return 'ضبط حجم الخط';
			case 'settings.text_preview_label': return 'معاينة مباشرة:';
			case 'settings.text_small': return 'صغير';
			case 'settings.text_normal': return 'عادي';
			case 'settings.text_large': return 'كبير';
			case 'settings.text_xlarge': return 'كبير جداً';
			case 'settings.arabic_font_section': return 'الخط العربي';
			case 'settings.font_default': return 'الافتراضي';
			case 'settings.font_cairo': return 'Cairo';
			case 'settings.font_tajawal': return 'Tajawal';
			case 'settings.font_almarai': return 'Almarai';
			case 'settings.accessibility_section': return 'إمكانية الوصول';
			case 'settings.bold_text': return 'نص عريض';
			case 'settings.reduce_anim': return 'تقليل الحركات';
			case 'settings.reduce_anim_sub': return 'موصى به للأجهزة القديمة أو الحساسية للحركة';
			case 'settings.notif_push_enabled': return 'تم تكوين التنبيهات على هذا الجهاز';
			case 'settings.notif_push_disabled': return 'التنبيهات معطلة';
			case 'settings.notif_enabled_chip': return 'مفعّل';
			case 'settings.notif_disabled_chip': return 'معطّل';
			case 'settings.notif_open_settings_btn': return 'فتح الإعدادات';
			case 'settings.notif_social_section': return 'الإشعارات الاجتماعية';
			case 'settings.notif_commerce_section': return 'إشعارات التسوق';
			case 'settings.notif_community_label': return 'إشعارات المجتمع';
			case 'settings.notif_all': return 'الكل';
			case 'settings.notif_mentions_only': return 'الإشارات فقط';
			case 'settings.notif_off': return 'إيقاف';
			case 'settings.notif_order_confirmed': return 'تأكيد الطلب';
			case 'settings.notif_order_shipped': return 'شحن الطلب';
			case 'settings.notif_order_delivered': return 'تسليم الطلب';
			case 'settings.notif_refund_processed': return 'معالجة الاسترداد';
			case 'settings.notif_price_drop': return 'تنبيهات انخفاض السعر';
			case 'settings.notif_back_in_stock': return 'تنبيهات العودة للمخزون';
			case 'settings.notif_vendor_section': return 'إشعارات البائع';
			case 'settings.notif_order_sound': return 'صوت تنبيه الطلب الجديد';
			case 'settings.notif_order_sound_sub': return 'تشغيل صوت تنبيه عالٍ لكل طلب جديد';
			case 'settings.notif_daily_summary': return 'ملخص المبيعات اليومي';
			case 'settings.notif_daily_summary_sub': return 'احصل على ملخص صباحي لمبيعات أمس';
			case 'settings.notif_general_section': return 'عام والنظام';
			case 'settings.notif_promotions_toggle': return 'العروض الترويجية';
			case 'settings.notif_login_alerts': return 'تنبيهات تسجيل الدخول';
			case 'settings.notif_login_alerts_sub': return 'يُعلمك عند تسجيل الدخول من جهاز جديد';
			case 'settings.notif_manage_channels': return 'فتح إعدادات الإشعارات';
			case 'settings.notif_manage_channels_sub': return 'إدارة قنوات الإشعارات لهذا التطبيق';
			case 'settings.account_screen_title': return 'الحساب والأمان';
			case 'settings.account_email_label': return 'عنوان البريد الإلكتروني';
			case 'settings.account_password_label': return 'كلمة المرور';
			case 'settings.account_password_sub': return 'إرسال رابط إعادة تعيين إلى بريدك الإلكتروني';
			case 'settings.account_connected_label': return 'الحسابات المرتبطة';
			case 'settings.account_biometric': return 'القفل البيومتري';
			case 'settings.account_biometric_sub': return 'يتطلب بصمة الإصبع أو Face ID لفتح واصلك';
			case 'settings.account_purchase_confirm': return 'تأكيد الشراء';
			case 'settings.account_purchase_confirm_sub': return 'يتطلب بيانات بيومترية قبل إتمام أي عملية شراء';
			case 'settings.account_login_notif': return 'إشعارات تسجيل الدخول';
			case 'settings.account_login_notif_sub': return 'يُعلمك عند تسجيل الدخول من جهاز جديد';
			case 'settings.privacy_screen_title': return 'الخصوصية والسلامة';
			case 'settings.privacy_account_section': return 'خصوصية الحساب';
			case 'settings.privacy_private_account': return 'حساب خاص';
			case 'settings.privacy_private_account_sub': return 'يمكن فقط للمتابعين المعتمدين رؤية منشوراتك';
			case 'settings.privacy_messaging_section': return 'المراسلة والدردشة';
			case 'settings.privacy_read_receipts': return 'إيصالات القراءة';
			case 'settings.privacy_read_receipts_sub': return 'إظهار إيصالات القراءة (✓✓) في المحادثات';
			case 'settings.privacy_activity_status': return 'إظهار حالة النشاط';
			case 'settings.privacy_blocked_section': return 'المستخدمون المحظورون';
			case 'settings.privacy_follow_req_section': return 'طلبات المتابعة';
			case 'settings.content_screen_title': return 'المحتوى والخلاصة';
			case 'settings.content_feed_lang_section': return 'لغة الخلاصة';
			case 'settings.content_muted_section': return 'الكلمات المكتومة';
			case 'settings.content_posts_section': return 'المنشورات';
			case 'settings.content_feed_section': return 'سلوك الخلاصة';
			case 'settings.content_default_visibility': return 'ظهور المنشور الافتراضي';
			case 'settings.content_vendor_section': return 'إعدادات البائع';
			case 'settings.storage_screen_title': return 'التخزين والأداء';
			case 'settings.storage_image_section': return 'ذاكرة تخزين الصور';
			case 'settings.storage_recent_section': return 'المشاهدة مؤخراً';
			case 'settings.storage_dev_section': return 'إعدادات المطور';
			case 'settings.support_screen_title': return 'الدعم والضمان';
			case 'settings.support_help_section': return 'الحصول على المساعدة';
			case 'settings.support_legal_section': return 'القانونية';
			case 'settings.support_escrow_section': return 'الضمان والنزاعات';
			case 'settings.support_contact': return 'تواصل مع الدعم';
			case 'settings.support_contact_sub': return 'تحدث مع وكيل دعم واصلك';
			case 'settings.support_report_bug': return 'الإبلاغ عن خطأ';
			case 'settings.support_report_sub': return 'ساعدنا في تحسين التطبيق بالإبلاغ عن المشاكل';
			case 'settings.support_terms': return 'شروط الاستخدام';
			case 'settings.support_privacy_policy': return 'سياسة الخصوصية';
			case 'settings.app_screen_title': return 'معلومات التطبيق';
			case 'settings.app_share_section': return 'مشاركة وتقييم';
			case 'settings.app_about_section': return 'حول';
			case 'settings.app_share_waslaq': return 'شارك واصلك';
			case 'settings.app_share_sub': return 'أخبر أصدقاءك عن السوق الفلسطيني';
			case 'settings.app_rate': return 'قيّم واصلك';
			case 'settings.app_rate_sub': return 'اترك تقييماً في المتجر';
			case 'settings.app_permissions': return 'صلاحيات التطبيق';
			case 'settings.app_permissions_sub': return 'إدارة صلاحيات التخزين والكاميرا والإشعارات';
			case 'settings.profile_screen_title': return 'إعدادات الملف الشخصي';
			case 'settings.address_screen_title': return 'دفتر العناوين';
			case 'settings.refund_screen_title': return 'تفاصيل الاسترداد';
			case 'settings.vendor_screen_title': return 'إعدادات البائع';
			case 'settings.vendor_store_status_section': return 'حالة المتجر';
			case 'settings.vendor_delivery_section': return 'مناطق التوصيل';
			case 'settings.vendor_notif_section': return 'الإشعارات';
			case 'settings.hubProfile': return 'الملف الشخصي';
			case 'settings.hubProfileSub': return 'تعديل معلومات ملفك الشخصي';
			case 'settings.hubAccount': return 'الحساب والأمان';
			case 'settings.hubAccountSub': return 'كلمة المرور والبريد الإلكتروني وإعدادات الحساب';
			case 'settings.hubAddress': return 'العناوين';
			case 'settings.hubAddressSub': return 'إدارة عناوين التوصيل';
			case 'settings.hubRefund': return 'تفاصيل الاسترداد';
			case 'settings.hubRefundSub': return 'الحساب البنكي للمبالغ المستردة';
			case 'settings.hubPrivacy': return 'الخصوصية';
			case 'settings.hubPrivacySub': return 'تحكم بمن يرى محتواك';
			case 'settings.hubNotifications': return 'الإشعارات';
			case 'settings.hubNotificationsSub': return 'إدارة تفضيلات الإشعارات';
			case 'settings.hubContent': return 'المحتوى';
			case 'settings.hubContentSub': return 'اللغة وتفضيلات المحتوى';
			case 'settings.hubAppearance': return 'المظهر';
			case 'settings.hubAppearanceSub': return 'إعدادات السمة والعرض';
			case 'settings.hubStorage': return 'التخزين';
			case 'settings.hubStorageSub': return 'إدارة ذاكرة التخزين المؤقت والبيانات';
			case 'settings.hubVendor': return 'إعدادات المتجر';
			case 'settings.hubVendorSub': return 'إدارة إعدادات متجرك';
			case 'settings.hubApp': return 'معلومات التطبيق';
			case 'settings.hubAppSub': return 'الإصدار وحول التطبيق';
			case 'settings.hubSupport': return 'الدعم';
			case 'settings.hubSupportSub': return 'المساعدة والتواصل معنا';
			case 'settings.deleteAccount': return 'حذف الحساب';
			case 'settings.permanentAction': return 'هذه العملية نهائية ولا يمكن التراجع عنها';
			case 'settings.accountScreenTitle': return 'الحساب والأمان';
			case 'settings.accountEmailLabel': return 'البريد الإلكتروني';
			case 'settings.notSet': return 'غير محدد';
			case 'settings.accountPasswordLabel': return 'كلمة المرور';
			case 'settings.accountPasswordSub': return 'تغيير كلمة المرور';
			case 'settings.resetLinkButton': return 'إرسال رابط إعادة الضبط';
			case 'settings.accountConnectedLabel': return 'الحساب المرتبط';
			case 'settings.accountBiometric': return 'تسجيل الدخول البيومتري';
			case 'settings.accountBiometricSub': return 'استخدم بصمة الإصبع أو الوجه لتسجيل الدخول';
			case 'settings.accountLoginNotif': return 'إشعارات تسجيل الدخول';
			case 'settings.accountLoginNotifSub': return 'إشعاري بتسجيلات الدخول الجديدة';
			case 'settings.accountPurchaseConfirm': return 'تأكيد الشراء';
			case 'settings.accountPurchaseConfirmSub': return 'طلب تأكيد قبل الشراء';
			case 'settings.addressScreenTitle': return 'العناوين';
			case 'settings.refundScreenTitle': return 'تفاصيل الاسترداد';
			case 'settings.privacyScreenTitle': return 'الخصوصية';
			case 'settings.privacyAccountSection': return 'خصوصية الحساب';
			case 'settings.privacyPrivateAccount': return 'حساب خاص';
			case 'settings.privacyPrivateAccountSub': return 'فقط المتابعون المعتمدون يرون منشوراتك';
			case 'settings.privacyFollowReqSection': return 'طلبات المتابعة';
			case 'settings.privacyActivityStatus': return 'حالة النشاط';
			case 'settings.privacyMessagingSection': return 'المراسلة';
			case 'settings.privacyReadReceipts': return 'إيصالات القراءة';
			case 'settings.privacyReadReceiptsSub': return 'اسمح للآخرين بمعرفة متى قرأت رسائلهم';
			case 'settings.privacyBlockedSection': return 'المستخدمون المحظورون';
			case 'settings.notifAll': return 'الكل';
			case 'settings.notifMentionsOnly': return 'الإشارات فقط';
			case 'settings.notifOff': return 'إيقاف';
			case 'settings.notifEnabledChip': return 'مفعّل';
			case 'settings.notifDisabledChip': return 'معطّل';
			case 'settings.notifPushEnabled': return 'الإشعارات الفورية مفعّلة';
			case 'settings.notifPushDisabled': return 'الإشعارات الفورية معطّلة';
			case 'settings.notifOpenSettingsBtn': return 'فتح الإعدادات';
			case 'settings.notifGeneralSection': return 'عام';
			case 'settings.notifSocialSection': return 'اجتماعي';
			case 'settings.notifCommerceSection': return 'التسوق';
			case 'settings.notifVendorSection': return 'المتجر';
			case 'settings.notifComments': return 'التعليقات';
			case 'settings.notifUpvotes': return 'التصويتات';
			case 'settings.notifMentions': return 'الإشارات';
			case 'settings.notifNewFollowers': return 'متابعون جدد';
			case 'settings.notifFollowRequests': return 'طلبات المتابعة';
			case 'settings.notifLoginAlerts': return 'تنبيهات تسجيل الدخول';
			case 'settings.notifLoginAlertsSub': return 'إشعاري بتسجيلات الدخول الجديدة';
			case 'settings.notifDailySummary': return 'الملخص اليومي';
			case 'settings.notifDailySummarySub': return 'احصل على ملخص يومي للنشاط';
			case 'settings.notifOrderConfirmed': return 'تأكيد الطلب';
			case 'settings.notifOrderShipped': return 'شحن الطلب';
			case 'settings.notifOrderDelivered': return 'تسليم الطلب';
			case 'settings.notifRefundProcessed': return 'معالجة الاسترداد';
			case 'settings.notifBackInStock': return 'عودة للمخزون';
			case 'settings.notifPriceDrop': return 'انخفاض السعر';
			case 'settings.notifPromotionsToggle': return 'العروض الترويجية';
			case 'settings.notifOrderSound': return 'صوت الطلب';
			case 'settings.notifOrderSoundSub': return 'تشغيل صوت للطلبات الجديدة';
			case 'settings.notifManageChannels': return 'إدارة القنوات';
			case 'settings.notifManageChannelsSub': return 'التحكم في قنوات الإشعارات';
			case 'settings.pushNotifications': return 'الإشعارات الفورية';
			case 'settings.contentScreenTitle': return 'المحتوى';
			case 'settings.contentFeedSection': return 'الخلاصة';
			case 'settings.contentFeedLangSection': return 'لغة الخلاصة';
			case 'settings.contentPostsSection': return 'المنشورات';
			case 'settings.contentMutedSection': return 'المكتوم';
			case 'settings.contentVendorSection': return 'البائعون';
			case 'settings.langSection': return 'اللغة';
			case 'settings.langAppLabel': return 'لغة التطبيق';
			case 'settings.appearanceTitle': return 'المظهر';
			case 'settings.themeSection': return 'السمة';
			case 'settings.themeLight': return 'فاتح';
			case 'settings.themeDark': return 'داكن';
			case 'settings.themeSystem': return 'افتراضي النظام';
			case 'settings.textSizeSection': return 'حجم النص';
			case 'settings.textAdjustLabel': return 'ضبط حجم النص';
			case 'settings.textPreviewLabel': return 'معاينة';
			case 'settings.textSmall': return 'صغير';
			case 'settings.textNormal': return 'عادي';
			case 'settings.textLarge': return 'كبير';
			case 'settings.textXlarge': return 'كبير جداً';
			case 'settings.boldText': return 'نص عريض';
			case 'settings.reduceAnim': return 'تقليل الحركات';
			case 'settings.reduceAnimSub': return 'تقليل تأثيرات الحركة';
			case 'settings.arabicFontSection': return 'الخط العربي';
			case 'settings.fontDefault': return 'افتراضي';
			case 'settings.fontCairo': return 'القاهرة';
			case 'settings.fontAlmarai': return 'المراعي';
			case 'settings.fontTajawal': return 'تجوال';
			case 'settings.accessibilitySection': return 'إمكانية الوصول';
			case 'settings.storageScreenTitle': return 'التخزين';
			case 'settings.storageImageSection': return 'الصور';
			case 'settings.storageRecentSection': return 'الأخيرة';
			case 'settings.storageDevSection': return 'المطوّر';
			case 'settings.vendorScreenTitle': return 'إعدادات المتجر';
			case 'settings.vendorStoreStatusSection': return 'حالة المتجر';
			case 'settings.vendorDeliverySection': return 'التوصيل';
			case 'settings.vendorNotifSection': return 'الإشعارات';
			case 'settings.appScreenTitle': return 'معلومات التطبيق';
			case 'settings.appAboutSection': return 'حول';
			case 'settings.appShareSection': return 'مشاركة';
			case 'settings.supportScreenTitle': return 'الدعم';
			case 'settings.supportHelpSection': return 'المساعدة';
			case 'settings.supportEscrowSection': return 'الضمان والمدفوعات';
			case 'settings.supportLegalSection': return 'قانوني';
			case 'settings.notifCommunityLabel': return 'إشعارات المجتمع';
			case 'settings.currencySection': return 'العملة';
			case 'settings.currencyLabel': return 'عملة العرض';
			case 'settings.currencyIls': return 'شيكل (₪)';
			case 'settings.currencyIlsSub': return 'عرض الأسعار بالشيكل الإسرائيلي الجديد';
			case 'settings.currencyUsd': return 'دولار (USD)';
			case 'settings.currencyUsdSub': return 'عرض الأسعار محوّلة إلى الدولار الأمريكي';
			case 'become_vendor.title': return 'انضم إلى قائمة الموردين';
			case 'become_vendor.subtitle': return 'انضم إلى منصتنا وابدأ في بيع منتجاتك.';
			case 'become_vendor.benefit1': return 'بيع المنتجات المادية والرقمية';
			case 'become_vendor.benefit2': return 'نظام دفع آمن عبر حساب الضمان';
			case 'become_vendor.benefit3': return 'حماية مدمجة من النزاعات';
			case 'become_vendor.benefit4': return 'اطلب سحب أموالك في أي وقت';
			case 'become_vendor.agree_terms': return 'أوافق على شروط المنصة وسياسات البائعين';
			case 'become_vendor.create_account': return 'أنشئ حسابك';
			case 'become_vendor.continue_google': return 'متابعة باستخدام Google';
			case 'become_vendor.signup_email': return 'التسجيل عبر البريد الإلكتروني';
			case 'become_vendor.skip_auth': return 'هل لديك حساب بالفعل؟ تخطي هذه الخطوة';
			case 'become_vendor.verify_email_title': return 'تحقق من بريدك الإلكتروني';
			case 'become_vendor.verify_email_desc': return ({required Object email}) => 'لقد أرسلنا رابطًا إلى ${email}. انقر عليه، ثم عد إلى هنا.';
			case 'become_vendor.verified_button': return 'لقد قمت بالتحقق من بريدي الإلكتروني';
			case 'become_vendor.setup_store': return 'أنشئ متجرك';
			case 'become_vendor.store_name': return 'اسم المتجر';
			case 'become_vendor.store_name_placeholder': return 'متجري الرائع';
			case 'become_vendor.store_description': return 'وصف المتجر';
			case 'become_vendor.store_desc_placeholder': return 'أخبر العملاء بما تبيعه...';
			case 'become_vendor.store_location': return 'موقع المتجر';
			case 'become_vendor.store_loc_placeholder': return 'مثل: غزة، رام الله، الخليل...';
			case 'become_vendor.delivery_zone': return 'منطقة التوصيل';
			case 'become_vendor.delivery_placeholder': return 'اختر منطقة التوصيل...';
			case 'become_vendor.zone_gaza': return 'قطاع غزة فقط';
			case 'become_vendor.zone_westbank': return 'الضفة الغربية فقط';
			case 'become_vendor.zone_both': return 'كلاهما (غزة والضفة الغربية)';
			case 'become_vendor.delivery_hint': return 'لن يتم توصيل المنتجات المادية إلا داخل المنطقة التي اخترتها. أما المنتجات الرقمية فلا توجد عليها أي قيود.';
			case 'become_vendor.what_do_you_sell': return 'ماذا تبيعون؟';
			case 'become_vendor.skip_now': return 'تخطي هذا الآن';
			case 'become_vendor.submit_app': return 'تقديم الطلب';
			case 'become_vendor.success_title': return 'تم إرسال الطلب!';
			case 'become_vendor.success_desc': return 'طلبك للتسجيل كمورد قيد المراجعة. سيتم إخطارك فور الموافقة عليه.';
			case 'become_vendor.go_account': return 'انتقل إلى "حسابي"';
			case 'become_vendor.continue_shopping': return 'متابعة التسوق';
			case 'become_vendor.screen_title': return 'كن بائعاً';
			case 'become_vendor.header_title': return 'افتح متجرك\nعلى واصلك';
			case 'become_vendor.header_subtitle': return 'بع لآلاف المشترين الفلسطينيين مع حماية كاملة لحساب الضمان.';
			case 'become_vendor.why_sell': return 'لماذا تبيع على واصلك؟';
			case 'become_vendor.escrow_title': return 'حماية الضمان';
			case 'become_vendor.escrow_desc': return 'يتم الاحتفاظ بكل عملية بيع في الضمان حتى يؤكد المشتري الاستلام.';
			case 'become_vendor.community_title': return 'مجتمع مدمج';
			case 'become_vendor.community_desc': return 'الوصول إلى المشترين من خلال صفحتنا الاجتماعية ومنشورات المجتمع.';
			case 'become_vendor.delivery_title': return 'مناطق التوصيل المحلية';
			case 'become_vendor.delivery_desc': return 'التوصيل داخل غزة أو الضفة الغربية - نحن نتولى منطق المناطق.';
			case 'become_vendor.dashboard_title': return 'لوحة تحكم البائع';
			case 'become_vendor.dashboard_desc': return 'تتبع الطلبات والأرباح وإدارة منتجاتك بسهولة.';
			case 'become_vendor.store_details': return 'تفاصيل المتجر';
			case 'become_vendor.store_name_label': return 'اسم المتجر';
			case 'become_vendor.store_name_hint': return 'مثال: أبو أحمد للإلكترونيات';
			case 'become_vendor.store_desc_label': return 'وصف المتجر';
			case 'become_vendor.store_desc_hint': return 'ماذا تبيع؟';
			case 'become_vendor.phone_label': return 'رقم الهاتف';
			case 'become_vendor.phone_hint': return '+970 5X XXX XXXX';
			case 'become_vendor.select_zone_hint': return 'اختر منطقة التوصيل الخاصة بك';
			case 'become_vendor.submit_application': return 'تقديم الطلب';
			case 'become_vendor.review_time': return 'نحن نراجع الطلبات في غضون 24-48 ساعة.';
			case 'become_vendor.store_name_required': return 'اسم المتجر مطلوب';
			case 'become_vendor.select_zone_required': return 'يرجى تحديد منطقة التوصيل';
			case 'become_vendor.already_applied': return 'لديك بالفعل طلب بائع سابق.';
			case 'become_vendor.submission_failed': return 'فشل تقديم الطلب. يرجى المحاولة مرة أخرى.';
			case 'become_vendor.application_submitted': return 'تم تقديم الطلب! سنقوم بمراجعته في غضون 48 ساعة.';
			case 'privacy.page_title': return 'سياسة الخصوصية';
			case 'privacy.last_updated': return 'تاريخ السريان: 1 مايو 2026 · آخر تحديث: 1 مايو 2026';
			case 'privacy.intro': return 'تلتزم "واسلق" ("نحن" أو "المنصة") بحماية خصوصية جميع المستخدمين وبياناتهم الشخصية. تصف سياسة الخصوصية هذه كيفية قيامنا بجمع معلوماتك ومعالجتها وتخزينها وحمايتها وفقًا لمبادئ حماية البيانات الفلسطينية المعمول بها وأفضل الممارسات الدولية، بما في ذلك معايير اللائحة العامة لحماية البيانات (GDPR). وبدخولك إلى "واسلق" أو استخدامها، فإنك تقر بأنك قد قرأت الممارسات الموضحة في هذه السياسة وتوافق عليها.';
			case 'privacy.s1_title': return 'من نحن';
			case 'privacy.s1_body': return '"واسلق" هي منصة سوق إلكترونية اجتماعية مستقلة تعمل تحت الإشراف الفلسطيني. نحن نربط البائعين المستقلين بالمشترين، ونسهل إجراء المعاملات الآمنة القائمة على نظام الضمان، ونوفر ميزات مجتمعية تشمل المنشورات والمجموعات والرسائل المباشرة وتقييمات المنتجات.';
			case 'privacy.s2_title': return 'المعلومات التي نجمعها';
			case 'privacy.s2_1_title': return '2.1 معلومات الحساب والتسجيل';
			case 'privacy.s2_2_title': return '2.2 معلومات خاصة بالمورد';
			case 'privacy.s2_3_title': return '2.3 بيانات المعاملات والطلبات';
			case 'privacy.s2_4_title': return '2.4 بيانات التحقق من الهوية (KYC)';
			case 'privacy.s2_5_title': return '2.5 المحتوى الذي ينشئه المستخدمون';
			case 'privacy.s2_6_title': return '2.6 البيانات الفنية وبيانات الاستخدام';
			case 'privacy.s3_title': return 'الأساس القانوني للمعالجة';
			case 'privacy.s4_title': return 'كيف نستخدم معلوماتك';
			case 'privacy.s5_title': return 'كيف نشارك معلوماتك';
			case 'privacy.s6_title': return 'أمن البيانات';
			case 'privacy.s7_title': return 'الاحتفاظ بالبيانات';
			case 'privacy.s8_title': return 'حقوقك';
			case 'privacy.s9_title': return 'خصوصية الأطفال';
			case 'privacy.s10_title': return 'التعديلات على هذه السياسة';
			case 'privacy.cookie_policy_title': return 'سياسة ملفات تعريف الارتباط';
			case 'privacy.cookie_policy_intro': return 'تنطبق سياسة ملفات تعريف الارتباط هذه على المستخدمين الذين يدخلون إلى موقع "Waslaq" من الاتحاد الأوروبي، والمنطقة الاقتصادية الأوروبية، والمملكة المتحدة، وغيرها من الولايات القضائية التي تسري فيها متطلبات الموافقة على ملفات تعريف الارتباط بموجب توجيه الخصوصية الإلكترونية (ePrivacy Directive) أو اللائحة العامة لحماية البيانات (GDPR) أو التشريعات المماثلة.';
			case 'privacy.s1_body_2': return 'للاستفسارات المتعلقة بالخصوصية: privacy@waslaq.com · waslaq.com/contact';
			case 'privacy.s2_1_item1': return 'الاسم الكامل';
			case 'privacy.s2_1_item2': return 'عنوان البريد الإلكتروني (عبر مصادقة Google Firebase أو التسجيل المباشر)';
			case 'privacy.s2_1_item3': return 'رقم الهاتف (اختياري ما لم يكن مطلوبًا لإتمام عملية تسجيل المورد)';
			case 'privacy.s2_1_item4': return 'اسم العرض والصورة الرمزية في الملف الشخصي';
			case 'privacy.s2_1_item5': return 'تاريخ إنشاء الحساب وطريقة المصادقة (Google أو Facebook أو البريد الإلكتروني/كلمة المرور)';
			case 'privacy.s2_vendor_intro': return 'يقدم البائعون الذين يقدمون طلبات التسجيل ما يلي:';
			case 'privacy.s2_2_item1': return 'اسم المتجر، والوصف العام، والشعار، وصور البانر';
			case 'privacy.s2_2_item2': return 'منطقة التسليم (غزة، الضفة الغربية، أو كلاهما) والموقع الفعلي';
			case 'privacy.s2_2_item3': return 'تفاصيل حساب الدفع: رقم IBAN أو عنوان PayPal (يتم تخزينها بشكل آمن، ولا يتم الكشف عنها علنًا أبدًا)';
			case 'privacy.s2_2_item4': return 'وثائق التحقق من الهوية (KYC) وفقًا لمتطلبات الامتثال';
			case 'privacy.s2_3_item1': return 'رقم الطلب، رقم العرض، الطابع الزمني للإنشاء، والحالة';
			case 'privacy.s2_3_item2': return 'تفاصيل المنتج: العنوان، النوع، الكمية، سعر الوحدة بالشيكل الإسرائيلي';
			case 'privacy.s2_3_item3': return 'عنوان الشحن: اسم المستلم، الشارع، المدينة، الرمز البريدي';
			case 'privacy.s2_3_item4': return 'حالة الدفع وأرقام تأكيد الدفع';
			case 'privacy.s2_3_item5': return 'حالة الحساب المعلق والقيود الدفترية المرتبطة بالمعاملة';
			case 'privacy.s2_3_item6': return 'سجل طلبات الدفع للموردين';
			case 'privacy.s2_3_payment_card_data_title': return 'بيانات بطاقة الدفع:';
			case 'privacy.s2_3_payment_card_data_body': return 'نحن لا نقوم بتخزين أرقام بطاقات الدفع الكاملة أو رموز CVV أو بيانات مصادقة حامل البطاقة، ولا نعالجها أو ننقلها. تتم معالجة جميع عمليات الدفع حصريًّا عبر بوابات دفع متوافقة مع معيار PCI-DSS من المستوى الأول. ولا نتلقى سوى أرقام مرجعية لتأكيد المعاملات ورموز الحالة.';
			case 'privacy.s2_4_body': return 'قد تشمل إجراءات "اعرف عميلك" (KYC) بطاقة هوية صادرة عن الحكومة ومزودة بصورة، وإثبات ملكية الحساب المصرفي، ووثائق تجارية. ويتم تخزين هذه البيانات في ظل ضوابط صارمة للوصول إليها، ولا تُستخدم إلا لأغراض الامتثال لقوانين مكافحة غسل الأموال ومنع الاحتيال، ولا يتم مشاركتها أبدًا مع مستخدمين آخرين.';
			case 'privacy.s2_5_item1': return 'المنشورات على مواقع التواصل الاجتماعي، والتعليقات، والتصويتات، وحفظ المحتوى';
			case 'privacy.s2_5_item2': return 'عضويات المجتمع وأدواره';
			case 'privacy.s2_5_item3': return 'تقييمات المنتجات وتصنيفات النجوم';
			case 'privacy.s2_5_item4': return 'أسئلة وأجوبة العملاء المرسلة إلى الموردين';
			case 'privacy.s2_5_item5': return 'الرسائل المباشرة ومحادثات الطلبات عبر GetStream';
			case 'privacy.s2_6_item1': return 'عنوان IP والموقع الجغرافي التقريبي (على مستوى المدينة/المنطقة)';
			case 'privacy.s2_6_item2': return 'نوع الجهاز ونظام التشغيل وإصدار المتصفح';
			case 'privacy.s2_6_item3': return 'الصفحات التي تمت زيارتها، والوقت الذي قضاه المستخدم، ومسار التنقل';
			case 'privacy.s2_6_item4': return 'استعلامات البحث التي تم إدخالها على المنصة';
			case 'privacy.s2_6_item5': return 'سجلات الأخطاء ومعلومات التشخيص';
			case 'privacy.table_processing_activities': return 'أنشطة المعالجة';
			case 'privacy.table_legal_basis': return 'الأساس القانوني';
			case 'privacy.table_row1_activity': return 'إدارة الحسابات، ومعالجة الطلبات، وعمليات الحساب المعلق، ودفع المستحقات للموردين، وتسوية النزاعات';
			case 'privacy.table_row1_basis': return 'الضرورة التعاقدية';
			case 'privacy.table_row2_activity': return 'الامتثال لقوانين "اعرف عميلك" (KYC) ومكافحة غسل الأموال (AML)، والسجلات الضريبية، والأوامر القضائية';
			case 'privacy.table_row2_basis': return 'الالتزام القانوني';
			case 'privacy.table_row3_activity': return 'منع الاحتيال، ومراقبة الأمن، وتحليلات المنصات، وكشف حالات إساءة الاستخدام';
			case 'privacy.table_row3_basis': return 'المصالح المشروعة';
			case 'privacy.table_row4_activity': return 'الإشعارات الفورية، والرسائل التسويقية الاختيارية، وملفات تعريف الارتباط غير الضرورية';
			case 'privacy.table_row4_basis': return 'الموافقة';
			case 'privacy.s4_1_title': return '4.1 عمليات المنصة';
			case 'privacy.s4_2_title': return '4.2 الأمن ومنع الاحتيال';
			case 'privacy.s4_3_title': return '4.3 التواصل';
			case 'privacy.s5_sell_no': return 'نحن لا نبيع بياناتك الشخصية أو نؤجرها أو نتاجر بها مع أطراف ثالثة لأغراض إعلانية أو تسويقية.';
			case 'privacy.s5_1_title': return '5.1 شركات معالجة الدفع';
			case 'privacy.s5_1_body': return 'يتم مشاركة بيانات المعاملات مع بنك فلسطين وبوابات الدفع المعتمدة حصريًّا لغرض تنفيذ الدفع ومنع الاحتيال.';
			case 'privacy.s5_2_title': return '5.2 الجهات الفرعية المعالجة للبيانات في مجال البنية التحتية';
			case 'privacy.table_service': return 'الخدمة';
			case 'privacy.table_purpose': return 'الغرض';
			case 'privacy.table_data_processed': return 'البيانات التي تمت معالجتها';
			case 'privacy.s5_3_title': return '5.3 بين المشترين والبائعين';
			case 'privacy.s5_3_body': return 'عند تقديم طلب شراء، يتم مشاركة اسم المشتري وعنوان التسليم وتفاصيل الطلب مع البائع المعني لغرض تنفيذ الطلب حصراً. ويُحظر على البائعين استخدام هذه المعلومات لأي غرض آخر.';
			case 'privacy.s5_4_title': return '5.4 الكشف القانوني والقضائي';
			case 'privacy.s5_4_body': return 'قد نكشف عن البيانات الشخصية للمحاكم الفلسطينية أو سلطات إنفاذ القانون أو الهيئات التنظيمية عندما يقتضي ذلك أمر قضائي رسمي قانوني. وحيثما يسمح القانون بذلك، سنقوم بإخطار المستخدم المعني قبل الكشف عن هذه البيانات.';
			case 'privacy.s6_security_note': return 'على الرغم من أننا نطبق إجراءات أمنية متوافقة مع معايير القطاع، إلا أنه لا يوجد نظام إلكتروني آمن بنسبة 100٪. تقع على عاتقك مسؤولية الحفاظ على سرية بيانات تسجيل الدخول الخاصة بك. يرجى الإبلاغ عن أي حالة يشتبه في أنها وصول غير مصرح به إلى';
			case 'privacy.table_data_category': return 'فئة البيانات';
			case 'privacy.table_retention_period': return 'فترة الاحتفاظ';
			case 'privacy.s8_submit_note': return 'يرجى إرسال الطلبات إلى ... وسنرد عليك في غضون 30 يومًا. قد يكون من الضروري التحقق من هويتك.';
			case 'privacy.s9_minors_body': return 'لا يُقصد بـ«واسلق» المستخدمون الذين تقل أعمارهم عن 18 عامًا. ونحن لا نجمع البيانات عن القاصرين عن قصد. وإذا علمنا بتسجيل قاصر، فسوف نقوم على الفور بتعليق الحساب وحذف البيانات المرتبطة به. يرجى الإبلاغ عن أي مخاوف إلى';
			case 'privacy.s10_updates_body': return 'قد نقوم بتحديث هذه السياسة في أي وقت. وسيتم الإبلاغ عن التغييرات الجوهرية عبر البريد الإلكتروني وإشعار على المنصة قبل 14 يومًا على الأقل من دخولها حيز التنفيذ. ويُعتبر الاستمرار في استخدام Waslaq بعد دخول التغييرات حيز التنفيذ قبولاً للسياسة المعدلة.';
			case 'privacy.cookie_disclosure_label': return 'إشعار بشأن ملفات تعريف الارتباط';
			case 'privacy.what_are_cookies_title': return 'ما هي ملفات تعريف الارتباط؟';
			case 'privacy.what_are_cookies_body': return 'ملفات تعريف الارتباط هي ملفات نصية صغيرة يضعها موقع الويب على جهازك. وهي تتيح للمواقع الإلكترونية العمل بشكل سليم، وتذكر تفضيلاتك، وتزود مالك الموقع بتحليلات. وقد تكون ملفات تعريف الارتباط مؤقتة (تُحذف عند إغلاق المتصفح) أو دائمة (تُخزّن على جهازك لفترة محددة).';
			case 'privacy.cookies_we_use_title': return 'ملفات تعريف الارتباط التي نستخدمها';
			case 'privacy.strictly_necessary_title': return 'ملفات تعريف الارتباط الضرورية للغاية — لا تتطلب موافقة';
			case 'privacy.functional_cookies_title': return 'ملفات تعريف الارتباط الوظيفية — يلزم الحصول على الموافقة';
			case 'privacy.no_ads_cookies': return 'لا توجد ملفات تعريف ارتباط إعلانية. لا يعرض موقع "Waslaq" أي إعلانات، ولا يستخدم وحدات بكسل إعادة الاستهداف أو ملفات تعريف الارتباط الخاصة بأطراف ثالثة أو تقنيات الإعلان السلوكي.';
			case 'privacy.third_party_cookies_title': return 'ملفات تعريف الارتباط الخاصة بأطراف ثالثة';
			case 'privacy.table_privacy_policy': return 'سياسة الخصوصية';
			case 'privacy.your_cookie_choices_title': return 'خيارات ملفات تعريف الارتباط الخاصة بك';
			case 'privacy.your_cookie_choices_body': return 'يمكنك ضبط متصفحك لرفض ملفات تعريف الارتباط أو حذفها:';
			case 'privacy.disabling_cookies_note': return 'سيؤدي تعطيل ملفات تعريف الارتباط الضرورية للغاية إلى منعك من تسجيل الدخول واستخدام الميزات الأساسية للمنصة.';
			case 'privacy.legal_basis_cookies_title': return 'الأساس القانوني لاستخدام ملفات تعريف الارتباط';
			case 'privacy.table_category': return 'الفئة';
			case 'privacy.cookie_inquiries': return 'الاستفسارات المتعلقة بملفات تعريف الارتباط:';
			case 'privacy.footer_questions': return 'هل لديك أسئلة حول هذه السياسة؟ اتصل بـ ... أو تفضل بزيارة موقعنا';
			case 'privacy.footer_rights': return '© 2026 واسلاق. السوق الاجتماعي الفلسطيني. جميع الحقوق محفوظة.';
			case 'privacy.table_row1_purpose_infra': return 'شبكة توزيع المحتوى (CDN)، الحماية من هجمات DDoS، SSL';
			case 'privacy.table_row1_data_infra': return 'عناوين IP، وبيانات تعريف الطلب';
			case 'privacy.table_row2_purpose_infra': return 'مصادقة المستخدم';
			case 'privacy.table_row2_data_infra': return 'البريد الإلكتروني، معرّف المستخدم الفريد (UID)، رموز المصادقة';
			case 'privacy.table_row3_purpose_infra': return 'المراسلة والموجزات في الوقت الفعلي';
			case 'privacy.table_row3_data_infra': return 'معرفات المستخدمين، محتوى الرسائل';
			case 'privacy.table_row4_purpose_infra': return 'تسليم رسائل البريد الإلكتروني المتعلقة بالمعاملات';
			case 'privacy.table_row4_data_infra': return 'عناوين البريد الإلكتروني، ومحتوى رسائل البريد الإلكتروني';
			case 'privacy.table_row5_purpose_infra': return 'وسائط التخزين';
			case 'privacy.table_row5_data_infra': return 'الملفات والصور التي تم تحميلها';
			case 'privacy.table_retention_row1_cat': return 'معلومات الحساب';
			case 'privacy.table_retention_row1_period': return 'مدة الحساب + سنتان بعد الحذف';
			case 'privacy.table_retention_row2_cat': return 'سجلات المعاملات وبيانات دفتر الأستاذ';
			case 'privacy.table_retention_row2_period': return '5 سنوات على الأقل (الامتثال المالي)';
			case 'privacy.table_retention_row3_cat': return 'التعرف على العميل / وثائق الهوية';
			case 'privacy.table_retention_row3_period': return 'مدة العلاقة مع المورد + 5 سنوات';
			case 'privacy.table_retention_row4_cat': return 'سجلات النزاعات والقرارات';
			case 'privacy.table_retention_row4_period': return '5 سنوات من تاريخ صدور القرار';
			case 'privacy.table_retention_row5_cat': return 'بيانات الطلب والشحن';
			case 'privacy.table_retention_row5_period': return '3 سنوات';
			case 'privacy.table_retention_row6_cat': return 'سجلات الاستخدام والسجلات الفنية';
			case 'privacy.table_retention_row6_period': return '90 يومًا';
			case 'privacy.table_retention_row7_cat': return 'تذاكر الدعم';
			case 'privacy.table_retention_row7_period': return '3 سنوات';
			case 'privacy.table_retention_row8_cat': return 'بيانات الحساب المحذوفة';
			case 'privacy.table_retention_row8_period': return 'يتم إخفاء الهوية أو حذفها في غضون 30 يومًا';
			case 'privacy.s8_item1_title': return 'حق الاطلاع';
			case 'privacy.s8_item1_desc': return 'اطلب نسخة من البيانات الشخصية التي نحتفظ بها عنك.';
			case 'privacy.s8_item2_title': return 'الحق في التصحيح';
			case 'privacy.s8_item2_desc': return 'اطلب تصحيح البيانات غير الدقيقة أو غير الكاملة.';
			case 'privacy.s8_item3_title': return 'الحق في حذف البيانات';
			case 'privacy.s8_item3_desc': return 'طلب حذف بياناتك (مع مراعاة متطلبات الاحتفاظ القانونية).';
			case 'privacy.s8_item4_title': return 'الحق في تقييد المعالجة';
			case 'privacy.s8_item4_desc': return 'طلب التوقف المؤقت عن المعالجة في ظروف معينة.';
			case 'privacy.s8_item5_title': return 'الحق في نقل البيانات';
			case 'privacy.s8_item5_desc': return 'اطلب تصدير بياناتك في صيغة منظمة وقابلة للقراءة آليًّا.';
			case 'privacy.s8_item6_title': return 'الحق في الاعتراض';
			case 'privacy.s8_item6_desc': return 'الاعتراض على المعالجة استنادًا إلى المصالح المشروعة.';
			case 'privacy.s8_item7_title': return 'الحق في سحب الموافقة';
			case 'privacy.s8_item7_desc': return 'يمكنك سحب موافقتك على المعالجة القائمة على الموافقة في أي وقت.';
			case 'privacy.table_cookie1_purpose': return 'رمز جلسة العمل المصادق عليه للخلفية التجارية';
			case 'privacy.table_cookie1_duration': return 'الجلسة';
			case 'privacy.table_cookie2_purpose': return 'جلسة مصادقة Firebase';
			case 'privacy.table_cookie2_duration': return 'الجلسة';
			case 'privacy.table_cookie3_purpose': return 'يمنع تزوير الطلبات عبر المواقع';
			case 'privacy.table_cookie3_duration': return 'الجلسة';
			case 'privacy.table_cookie4_name': return 'ملفات تعريف الارتباط الخاصة بالتفضيلات';
			case 'privacy.table_cookie4_purpose': return 'يحتفظ بتفضيلات العرض والإشعارات';
			case 'privacy.table_cookie4_duration': return 'سنة واحدة';
			case 'privacy.table_cookie5_name': return 'حفظ سلة التسوق';
			case 'privacy.table_cookie5_purpose': return 'يحتفظ بمحتويات سلة التسوق عبر الجلسات';
			case 'privacy.table_cookie5_duration': return '30 يومًا';
			case 'privacy.your_cookie_choices_item1': return 'Chrome: الإعدادات → الخصوصية والأمان → ملفات تعريف الارتباط وبيانات المواقع الأخرى';
			case 'privacy.your_cookie_choices_item2': return 'فايرفوكس: الخيارات → الخصوصية والأمان → ملفات تعريف الارتباط وبيانات المواقع';
			case 'privacy.your_cookie_choices_item3': return 'Safari: التفضيلات → الخصوصية → إدارة بيانات المواقع الإلكترونية';
			case 'privacy.your_cookie_choices_item4': return 'Edge: الإعدادات → الخصوصية والبحث والخدمات → ملفات تعريف الارتباط';
			case 'privacy.table_cookie_legal_row1_cat': return 'ضرورية للغاية';
			case 'privacy.table_cookie_legal_row1_basis': return 'المصلحة المشروعة / الضرورة التعاقدية — لا حاجة إلى موافقة';
			case 'privacy.table_cookie_legal_row2_cat': return 'وظيفي';
			case 'privacy.table_cookie_legal_row2_basis': return 'الموافقة';
			case 'privacy.table_cookie_legal_row3_cat': return 'التحليلات';
			case 'privacy.table_cookie_legal_row3_basis': return 'الموافقة (نستخدم ملفات تعريف الارتباط من جانب الخادم فقط، ولا نستخدم ملفات تعريف الارتباط الخاصة بالتتبع)';
			case 'privacy.table_cookie_legal_row4_cat': return 'الإعلان';
			case 'privacy.table_cookie_legal_row4_basis': return 'لا ينطبق — نحن لا نستخدم ملفات تعريف الارتباط الإعلانية';
			case 'privacy.s4_1_item1': return 'لإنشاء حسابك وإدارته.';
			case 'privacy.s4_1_item2': return 'لمعالجة طلباتك وتنفيذها.';
			case 'privacy.s4_1_item3': return 'تقديم خدمات الضمان والدفع الآمنة.';
			case 'privacy.s4_1_item4': return 'لتسهيل التواصل بين المشترين والبائعين.';
			case 'privacy.s4_1_item5': return 'لإبلاغك بحالة الطلب وتحديثات المنصة.';
			case 'privacy.s4_2_item1': return 'لمراقبة الأنشطة المشبوهة أو الاحتيالية.';
			case 'privacy.s4_2_item2': return 'للتحقق من هويتك في إطار عملية تسجيل الموردين.';
			case 'privacy.s4_2_item3': return 'لحماية سلامة نظام الحساب المعلق.';
			case 'privacy.s4_2_item4': return 'لتسوية النزاعات والتوسط في المطالبات.';
			case 'privacy.s4_2_item5': return 'الامتثال للالتزامات القانونية والتنظيمية.';
			case 'privacy.s4_3_item1': return 'إشعارات فورية للرسائل والطلبات الجديدة.';
			case 'privacy.s4_3_item2': return 'تحديثات عبر البريد الإلكتروني بشأن أمان الحساب وأنشطته.';
			case 'privacy.s4_3_item3': return 'الاتصالات التسويقية الاختيارية (في حالة تقديم الموافقة).';
			case 'terms.page_title': return 'شروط الاستخدام';
			case 'terms.last_updated': return 'تاريخ السريان: 1 مايو 2026 · آخر تحديث: 1 مايو 2026';
			case 'terms.intro': return 'تشكل شروط الاستخدام هذه ("الاتفاقية") عقدًا ملزمًا قانونًا بين Waslaq ("المنصة"، "نحن"، "لنا") وجميع المستخدمين، بما في ذلك المشترون والبائعون ("أنت"، "المستخدم"). من خلال الوصول إلى أي جزء من منصة Waslaq أو استخدامه — بما في ذلك التصفح أو التسجيل أو الشراء أو البيع — فإنك تقبل دون قيد أو شرط جميع الشروط المنصوص عليها في هذه الاتفاقية. إذا كنت لا توافق على أي جزء من هذه الاتفاقية، فيجب عليك التوقف فوراً عن استخدام المنصة بأي شكل من الأشكال.';
			case 'terms.s1_title': return 'طبيعة المنصة';
			case 'terms.s2_title': return 'تسجيل الحساب وشروط الأهلية';
			case 'terms.s3_title': return 'نظام الضمان والدفع';
			case 'terms.s4_title': return 'التزامات المورد وإجراءات "اعرف عميلك"';
			case 'terms.s5_title': return 'التزامات المشتري';
			case 'terms.s6_title': return 'المحتوى والأنشطة المحظورة';
			case 'terms.s7_title': return 'الملكية الفكرية';
			case 'terms.s8_title': return 'تسوية المنازعات';
			case 'terms.s9_title': return 'عمليات رد المبالغ المدفوعة';
			case 'terms.s10_title': return 'رسوم وعمولات المنصة';
			case 'terms.s11_title': return 'حدود المسؤولية';
			case 'terms.s12_title': return 'الإنهاء والتعليق';
			case 'terms.s13_title': return 'القانون الواجب التطبيق والاختصاص القضائي';
			case 'terms.s14_title': return 'التعديلات';
			case 'terms.quick_nav_title': return 'التنقل السريع';
			case 'terms.quick_nav_item1': return 'طبيعة المنصة';
			case 'terms.quick_nav_item2': return 'تسجيل الحساب';
			case 'terms.quick_nav_item3': return 'الحساب المعلق والمدفوعات';
			case 'terms.quick_nav_item4': return 'التزامات الموردين وإجراءات "اعرف عميلك"';
			case 'terms.quick_nav_item5': return 'التزامات المشتري';
			case 'terms.quick_nav_item6': return 'المحتوى والأنشطة المحظورة';
			case 'terms.quick_nav_item7': return 'الملكية الفكرية';
			case 'terms.quick_nav_item8': return 'تسوية المنازعات';
			case 'terms.quick_nav_item9': return 'عمليات رد المبالغ المدفوعة';
			case 'terms.quick_nav_item10': return 'رسوم وعمولات المنصة';
			case 'terms.quick_nav_item11': return 'حدود المسؤولية';
			case 'terms.quick_nav_item12': return 'الإنهاء والتعليق';
			case 'terms.quick_nav_item13': return 'القانون الواجب التطبيق';
			case 'terms.quick_nav_item14': return 'التعديلات';
			case 'terms.s1_body1': return 'تعمل "واسلق" كوسيط إلكتروني وتقني ومالي مستقل يربط بين البائعين المستقلين والمشترين حصريًّا داخل السوق الفلسطينية. وتسهل المنصة إجراء المعاملات من خلال نظام ضمان آمن، كما توفر ميزات التجارة الاجتماعية، بما في ذلك المجموعات والمشاركات ومراجعات المنتجات والمراسلة المباشرة.';
			case 'terms.s1_body2': return 'لا تعتبر المنصة طرفًا مباشرًا في عقود البيع المبرمة بين المشترين والبائعين. ولا توجد أي علاقة وكالة أو شراكة أو توظيف أو امتياز أو مشروع مشترك بين «واسلق» وأي مستخدم. والبائعون هم بائعون مستقلون ويتحملون وحدهم المسؤولية عن منتجاتهم وإعلاناتهم والتزاماتهم المتعلقة بتنفيذ الطلبات.';
			case 'terms.s1_body3': return 'تحتفظ Waslaq بالحق في تعديل أو تعليق أو إيقاف أي ميزة أو قسم أو المنصة بأكملها بشكل دائم في أي وقت، سواء بإشعار مسبق أو بدونه، ولن تتحمل أي مسؤولية تجاه أي مستخدم أو طرف ثالث عن أي تعديل أو تعليق أو إيقاف من هذا القبيل.';
			case 'terms.s2_intro': return 'للاستفادة من جميع ميزات المنصة، يجب عليك إنشاء حساب. وبتسجيلك، فإنك تقر وتضمن ما يلي:';
			case 'terms.s2_item1': return 'يجب أن يكون عمرك 18 عامًا على الأقل أو أن تكون قد بلغت سن الرشد القانوني في ولايتك القضائية.';
			case 'terms.s2_item2': return 'جميع المعلومات المقدمة أثناء التسجيل دقيقة وحديثة وكاملة.';
			case 'terms.s2_item3': return 'يجب عليك الحفاظ على دقة معلومات حسابك وتحديثها فور حدوث أي تغيير فيها.';
			case 'terms.s2_item4': return 'لا يجوز لك إنشاء حسابات متعددة للتحايل على القيود أو الإيقافات أو الحظر.';
			case 'terms.s2_item5': return 'أنت وحدك المسؤول عن جميع الأنشطة التي تتم من خلال حسابك وعن الحفاظ على سرية بيانات تسجيل الدخول الخاصة بك.';
			case 'terms.s2_body': return 'تحتفظ Waslaq بالحق في رفض التسجيل، أو التحقق من الهوية، أو تعليق الوصول، أو حظر أي حساب بشكل دائم وفقًا لتقديرها الخاص، بما في ذلك على سبيل المثال لا الحصر، في حالات انتهاك هذه الاتفاقية، أو الاشتباه في حدوث احتيال، أو الإضرار بسمعة المنصة.';
			case 'terms.s3_2_item1': return 'المنتجات المادية: 48 ساعة من تاريخ تأكيد التسليم أو قيام البائع بوضع علامة "تم الشحن" على الطلب.';
			case 'terms.s3_2_item2': return 'المنتجات الرقمية: 24 ساعة من تاريخ تأكيد تسليم المفتاح الرقمي أو الملف أو بيانات تسجيل الدخول.';
			case 'terms.s3_3_item1': return 'تمديد فترة الاحتجاز إلى ما بعد "فترة الفحص" القياسية في حالات الاشتباه في حدوث احتيال أو في حالة وجود نزاعات لم يتم حلها.';
			case 'terms.s3_3_item2': return 'تجميد الأموال إلى أجل غير مسمى ريثما يتم الانتهاء من التحقيق في المخالفات المبلغ عنها أو الشكاوى المتعددة أو التحقيق التنظيمي.';
			case 'terms.s3_3_item3': return 'إعادة الأموال المحتجزة إلى المشترين أو تحويلها إليهم في حالة تسوية النزاع أو تأكيد مخالفة البائع.';
			case 'terms.s3_3_item4': return 'تعليق المدفوعات المعلقة للموردين الذين تخضع حساباتهم للتحقيق أو التعليق.';
			case 'terms.s4_1_item1': return 'بطاقة هوية صادرة عن الحكومة ومزودة بصورة (بطاقة الهوية الوطنية أو جواز السفر).';
			case 'terms.s4_1_item2': return 'إثبات ملكية الحساب المصرفي (كشف حساب أو خطاب تأكيد رقم IBAN).';
			case 'terms.s4_1_item3': return 'وثائق تسجيل الشركة، إن وجدت.';
			case 'terms.s4_3_item1': return 'هذا المنتج هو نسخة مقلدة / غير أصلية / مقلدة — ولا يرتبط بالعلامة التجارية الأصلية ولا يحظى بتأييدها.';
			case 'terms.s4_3_item2': return 'استخدام مصطلحات مثل "نسخة" أو "مزيفة" أو "مقلدة" أو "مستنسخة" أو "ليست أصلية" بشكل واضح في العنوان نفسه.';
			case 'terms.s5_item1': return 'يرجى تقديم عناوين الشحن ومعلومات الاتصال الصحيحة عند إتمام عملية الدفع. لا تتحمل "واسلق" والموردون أي مسؤولية عن أي إخفاق في التسليم ناجم عن تقديم عناوين غير صحيحة من قِبل المشتري.';
			case 'terms.s5_item2': return 'يرجى مراجعة الطلبات خلال فترة المراجعة وفتح نزاع فوراً في حال اكتشاف أي مشاكل. ويُعتبر عدم فتح نزاع قبل انتهاء فترة المراجعة بمثابة قبول قانوني للطلب.';
			case 'terms.s5_item3': return 'لا تقدم أدلة مزورة أو مزيفة في النزاعات. فذلك يشكل احتيالاً وسيؤدي إلى إغلاق الحساب نهائياً واتخاذ إجراءات قانونية محتملة.';
			case 'terms.s5_item4': return 'لا يجوز الشروع في إجراءات استرداد المبالغ من البنك دون استنفاد إجراءات تسوية المنازعات الداخلية الخاصة بالمنصة أولاً.';
			case 'terms.s5_item5': return 'يرجى الالتزام بجميع القوانين الفلسطينية السارية عند شراء المنتجات عبر المنصة.';
			case 'terms.s6_1_item1': return 'عرض منتجات مقلدة أو مستنسخة أو غير أصلية دون الإفصاح عن ذلك بوضوح وصراحة في عنوان المنتج ووصفه.';
			case 'terms.s6_1_item2': return 'عرض أو بيع أو تيسير منتجات أو خدمات تنتهك القانون الفلسطيني المعمول به، أو المبادئ المالية الإسلامية حيثما كان ذلك مطلوبًا، أو العقوبات الدولية.';
			case 'terms.s6_1_item3': return 'أي مخطط يهدف إلى التحايل على نظام الحساب المعلق، بما في ذلك محاولة إتمام المعاملات خارج المنصة.';
			case 'terms.s6_1_item4': return 'استخدام المنصة في غسل الأموال أو تمويل الإرهاب أو أي نشاط ينتهك لوائح مكافحة غسل الأموال (AML).';
			case 'terms.s6_2_item1': return 'نشر أو تحميل أو مشاركة أو وضع روابط لأي محتوى جنسي صريح أو إباحي أو مخصص للبالغين فقط بأي شكل من الأشكال — بما في ذلك الصور أو مقاطع الفيديو أو النصوص أو الروابط أو قوائم المنتجات — تحت أي ظرف من الظروف ودون استثناء.';
			case 'terms.s6_2_item2': return 'نشر أي محتوى يُجسد القاصرين في صورة جنسية أو يستغلهم أو يعرضهم للخطر بأي شكل من الأشكال. ويُعد هذا جريمة جنائية وسيتم الإبلاغ عنه على الفور إلى السلطات الفلسطينية المختصة والمنظمات الدولية المعنية بحماية الطفل.';
			case 'terms.s6_2_item3': return 'مشاركة صور عارية أو شبه عارية أو ذات إيحاءات جنسية في أي قسم من أقسام المنصة، بما في ذلك المنشورات والمجموعات وصور المنتجات ولافتات المتاجر وصور الملف الشخصي أو الرسائل المباشرة.';
			case 'terms.s6_2_item4': return 'عرض أو بيع أي منتجات أو خدمات أو مواد للبالغين، بغض النظر عن وضعها القانوني في الولاية القضائية للمستخدم.';
			case 'terms.s6_2_item5': return 'محاولة التحايل على آليات مراقبة المحتوى باستخدام لغة مشفرة أو رموز تعبيرية أو روابط لمواقع خارجية أو إشارات غير مباشرة بهدف توجيه المستخدمين إلى محتوى محظور.';
			case 'terms.s6_3_item1': return 'التحرش أو التنمر أو التهديد أو التخويف أو الإساءة الموجهة إلى أي مستخدم أو بائع أو عضو في المجتمع أو موظف في المنصة في أي قسم من أقسام المنصة.';
			case 'terms.s6_3_item2': return 'خطاب الكراهية، أو التمييز، أو المحتوى الذي يحط من قدر الأفراد أو الجماعات على أساس الدين، أو العرق، أو الجنسية، أو الجنس، أو الانتماء السياسي، أو أي سمة أخرى محمية.';
			case 'terms.s6_3_item3': return 'نشر مشاهد عنف صادمة، أو مشاهد دموية، أو صور مزعجة، أو محتوى يهدف إلى إثارة صدمة أو إزعاج المستخدمين الآخرين.';
			case 'terms.s6_3_item4': return 'نشر معلومات خاطئة متعمدة أو معلومات مضللة أو محتوى ملفق بهدف خداع المستخدمين الآخرين أو الإضرار بسمعتهم.';
			case 'terms.s6_3_item5': return 'إغراق المجتمعات أو موجزات المنشورات أو الرسائل المباشرة بمحتوى ترويجي غير مرغوب فيه، أو منشورات متكررة، أو أنشطة الروبوتات الآلية.';
			case 'terms.s6_3_item6': return '"الدوكسينغ" — نشر معلومات شخصية خاصة عن أي فرد (الاسم، العنوان، رقم الهاتف، التفاصيل المالية) دون موافقته الصريحة.';
			case 'terms.s6_3_item7': return 'انتحال صفة مستخدم آخر أو بائع أو مشرف مجتمع أو أحد موظفي Waslaq في أي سياق على المنصة.';
			case 'terms.s6_4_item1': return 'الجمع غير المصرح به للبيانات الشخصية للمستخدمين الآخرين أو محتوى المنصة، أو استخراجها، أو استخدامها لأغراض تجارية.';
			case 'terms.s6_4_item2': return 'تحميل برامج ضارة، أو شن هجمات لإعاقة الخدمة، أو محاولة اختراق أنظمة أمان المنصة.';
			case 'terms.s6_4_item3': return 'إنشاء حسابات متعددة للتحايل على الحظر أو التعليق أو تقييد الحساب.';
			case 'terms.s6_4_item4': return 'التلاعب بتعليقات المنتجات أو تصويتات المجتمع أو التقييمات من خلال حسابات مزيفة أو تعليقات مدفوعة الأجر أو سلوك غير حقيقي يتم تنسيقه.';
			case 'terms.s6_5_item1': return 'إزالة منشورات أو إعلانات أو صور أو تعليقات محددة.';
			case 'terms.s6_5_item2': return 'التعليق المؤقت لحق النشر في مجتمعات معينة أو على مستوى المنصة بأكملها.';
			case 'terms.s6_5_item3': return 'الحظر الدائم من جميع ميزات المنصة، بما في ذلك الشراء والبيع والمشاركة الاجتماعية.';
			case 'terms.s6_5_item4': return 'مصادرة الأرصدة المعلقة في حالات الاحتيال أو الانتهاكات الجسيمة.';
			case 'terms.s6_5_item5': return 'الإحالة إلى أجهزة إنفاذ القانون الفلسطينية أو السلطات المختصة في حالة ارتكاب مخالفات جنائية.';
			case 'terms.s9_item1': return 'تقديم شكوى عبر نظام تسوية المنازعات الخاص بالمنصة.';
			case 'terms.s9_item2': return 'منح شركة «واسلق» مهلة معقولة لا تقل عن 7 أيام عمل للتحقيق في الأمر والرد عليه.';
			case 'terms.s9_item3': return 'استرداد كامل مبلغ المعاملة المتنازع عليها من حساب المستخدم أو من أي أموال محتجزة.';
			case 'terms.s9_item4': return 'تحميل جميع الرسوم المصرفية وتكاليف المعالجة والمصروفات الإدارية ذات الصلة على عاتق المستخدم المخالف.';
			case 'terms.s9_item5': return 'حظر المستخدم بشكل دائم من المنصة.';
			case 'terms.s9_item6': return 'اتخاذ إجراءات قانونية مدنية لاسترداد جميع الخسائر والتكاليف والأضرار، بما في ذلك أتعاب المحاماة.';
			case 'terms.s11_item1': return 'أي أضرار غير مباشرة أو عرضية أو خاصة أو تبعية أو تعويضية أو عقابية.';
			case 'terms.s11_item2': return 'خسارة الأرباح أو الإيرادات أو البيانات أو الفرص التجارية أو السمعة التجارية.';
			case 'terms.s11_item3': return 'الأضرار الناجمة عن سلوك البائعين أو المشترين أو منتجاتهم أو خدماتهم.';
			case 'terms.s11_item4': return 'انقطاعات الخدمة الناجمة عن ظروف خارجة عن سيطرة «واسلق» المعقولة، بما في ذلك انقطاع خدمة الإنترنت، أو أعطال خدمات الجهات الخارجية، أو الكوارث الطبيعية، أو الاضطرابات المدنية، أو حالات القوة القاهرة.';
			case 'terms.s11_item5': return 'الوصول غير المصرح به إلى بياناتك أو تغييرها نتيجة لأفعال أطراف ثالثة خارجة عن سيطرتنا المعقولة.';
			case 'terms.s14_item1': return 'سيتم تحديث تاريخ "آخر تحديث" في أعلى هذه الصفحة.';
			case 'terms.s14_item2': return 'سيتم إخطار المستخدمين المسجلين عبر البريد الإلكتروني قبل 14 يومًا على الأقل من دخول التغييرات حيز التنفيذ.';
			case 'terms.s14_item3': return 'سيتم عرض إشعار بارز على المنصة.';
			case 'terms.s3_1_title': return '3.1 معالجة المدفوعات';
			case 'terms.s3_1_body': return 'تتم معالجة جميع المعاملات على منصة "Waslaq" حصريًّا عبر بوابات الدفع المعتمدة، بما في ذلك بنك فلسطين ومزودي خدمات الدفع المرخصين الآخرين. وتُحدد جميع المبالغ بالشيكل الإسرائيلي الجديد (ILS). وبإجراء طلب الشراء، فإنك تفوض المنصة بتحصيل المبلغ الكامل للطلب، بما في ذلك أي رسوم منصة سارية، من وسيلة الدفع التي اخترتها.';
			case 'terms.s3_2_title': return '3.2 الحجز في حساب الضمان';
			case 'terms.s3_2_body': return 'بعد إتمام الدفع بنجاح، تحتفظ المنصة بمبلغ الطلب بالكامل في حساب ضمان. ولا يتم تحويل الأموال إلى البائع إلا بعد انقضاء فترة الفحص الإلزامية دون رفع أي نزاع. وتكون فترة الفحص كما يلي:';
			case 'terms.s3_3_title': return '3.3 حقوق البائع في الأموال';
			case 'terms.s3_3_intro': return 'لا يكتسب البائعون أي حق قانوني مكتسب في الأموال المحتجزة حتى تنتهي فترة المراجعة دون حدوث أي نزاع. وتحتفظ شركة «واسلاق» بسلطة تقديرية مطلقة وأحادية الجانب تسمح لها بما يلي:';
			case 'terms.s3_4_title': return '3.4 العملة والأسعار';
			case 'terms.s3_4_body': return 'جميع الأسعار والرسوم والمبالغ المدفوعة على المنصة مقومة بالشيكل الإسرائيلي الجديد (ILS). ولا تضمن «واسلق» أسعار الصرف، كما أنها غير مسؤولة عن خسائر تحويل العملات التي يتكبدها المستخدمون الذين يجرون معاملاتهم من خارج فلسطين.';
			case 'terms.s4_1_title': return '4.1 التسجيل والتحقق';
			case 'terms.s4_1_body': return 'يجب على جميع البائعين إتمام عملية تسجيل البائعين في منصة "واسلق"، بما في ذلك تقديم معلومات دقيقة عن المتجر، وتحديد مناطق التوصيل، وتفاصيل حساب السحب. ويجب على البائعين إتمام عملية التحقق من الهوية (KYC) قبل التمكن من استخدام وظيفة السحب. وقد تتطلب عملية KYC تقديم ما يلي:';
			case 'terms.s4_1_kyc_failure': return 'قد يؤدي عدم إتمام إجراءات "اعرف عميلك" (KYC) خلال فترة معقولة إلى تعليق الحساب وحجب الأموال المتراكمة إلى حين إتمام الإجراءات.';
			case 'terms.s4_2_title': return '4.2 دقة بيانات المنتج';
			case 'terms.s4_2_body': return 'يتحمل البائعون المسؤولية الكاملة والحصرية عن دقة واكتمال وقانونية وأصالة جميع قوائم المنتجات، بما في ذلك العناوين والأوصاف والصور والأسعار والمواصفات. ويجب أن تعكس قوائم المنتجات بدقة المنتج الفعلي الذي سيتسلمه المشتري.';
			case 'terms.s4_3_title': return '4.3 المنتجات المقلدة وغير الأصلية';
			case 'terms.s4_3_body': return 'لا يجوز للبائعين عرض منتجات مقلدة أو نسخ مقلدة أو غير أصلية إلا إذا قاموا بالإفصاح عن ذلك صراحةً وبشكل لا لبس فيه في كل من عنوان المنتج ووصفه، بطريقة لا تترك أي شك معقول في ذهن المشتري. وتشمل الصيغ المقبولة للإفصاح ما يلي:';
			case 'terms.s4_3_prohibited_title': return 'ممنوع منعاً باتاً:';
			case 'terms.s4_3_prohibited_body': return 'عرض أي منتج مقلد أو غير أصلي على أنه "أصلي" أو "أصلي" أو "أصيل" أو "جديد تمامًا" دون الإفصاح عن ذلك بوضوح. ويشكل هذا احتيالًا تجاريًا وانتهاكًا جوهريًا لهذه الاتفاقية، مما يمنح Waslaq الحق في إزالة جميع العروض على الفور، وتجميد رصيد البائع، وتقديم تعويضات كاملة للمشترين المتضررين، وإغلاق الحساب بشكل دائم، واللجوء إلى سبل الانتصاف القانونية المدنية والجنائية، بما في ذلك المطالبة بالتعويض عن الأضرار.';
			case 'terms.s4_4_title': return '4.4 التنفيذ والتسليم';
			case 'terms.s4_4_body': return 'يتحمل البائعون وحدهم مسؤولية تلبية الطلبات في غضون فترة زمنية معقولة ومحددة مسبقًا. بالنسبة للمنتجات المادية، يتحمل البائعون مسؤولية التغليف والشحن والتسليم إلى العنوان الذي يحدده المشتري. أما بالنسبة للمنتجات الرقمية، فيجب أن يتم التسليم تلقائيًا وفورًا بعد تأكيد الدفع. وقد يؤدي تكرار الإخفاق في تلبية الطلبات إلى تعليق الحساب.';
			case 'terms.s4_5_title': return '4.5 التواصل مع المشترين';
			case 'terms.s4_5_body': return 'يجب على البائعين الرد على استفسارات المشترين عبر نظام المراسلة الخاص بالمنصة في غضون فترة زمنية معقولة. ويجب على البائعين الامتناع عن التواصل مع المشترين عبر قنوات خارجية بهدف التحايل على أنظمة الضمان أو تسوية النزاعات الخاصة بالمنصة.';
			case 'terms.s6_intro': return 'يُحظر تمامًا القيام بما يلي على منصة Waslaq. وقد تؤدي المخالفات إلى تعليق الحساب فورًا، والحظر الدائم، ومصادرة الأموال، و/أو اتخاذ إجراءات قانونية:';
			case 'terms.s6_1_title': return '6.1 انتهاكات القواعد التجارية';
			case 'terms.s6_2_title': return '6.2 المحتوى المخصص للبالغين والمحتوى غير الآمن للعمل — عدم التسامح مطلقًا';
			case 'terms.s6_2_zero_tolerance_title': return '⚠️ سياسة عدم التسامح مطلقًا';
			case 'terms.s6_2_zero_tolerance_body': return 'تُعد «واسلق» منصة تجارية صديقة للأسرة وموجهة نحو المجتمع، تخدم السوق الفلسطيني. وسيؤدي أي انتهاك لهذا البند إلى إنهاء الحساب فوراً وبشكل نهائي دون حق في الاستئناف، بغض النظر عن سجل المستخدم أو مكانته على المنصة.';
			case 'terms.s6_3_title': return '6.3 الطبقة الاجتماعية ومعايير المجتمع';
			case 'terms.s6_3_intro': return 'تخضع الميزات الاجتماعية في Waslaq — بما في ذلك المجموعات والمشاركات والتعليقات والرسائل المباشرة — لمعايير المجتمع التالية، بالإضافة إلى جميع المحظورات الأخرى الواردة في هذه الاتفاقية:';
			case 'terms.s6_4_title': return '6.4 المخالفات الفنية والأمنية';
			case 'terms.s6_5_title': return '6.5 الإنفاذ والإشراف';
			case 'terms.s6_5_body': return 'تحتفظ Waslaq بالسلطة الكاملة والأحادية وغير القابلة للمراجعة في تحديد ما يشكل انتهاكًا لهذه المعايير واتخاذ الإجراءات المناسبة، سواء بإشعار مسبق أو بدونه. وتشمل إجراءات الإنفاذ، على سبيل المثال لا الحصر، ما يلي:';
			case 'terms.s6_5_report': return 'يمكن للمستخدمين الإبلاغ عن المخالفات باستخدام نظام الإبلاغ المدمج في المنصة والمتاح في جميع المنشورات والملفات الشخصية والإعلانات. ويتم مراجعة جميع البلاغات من قِبل فريق الإشراف في Waslaq.';
			case 'terms.s7_1_title': return '7.1 محتوى المنصة';
			case 'terms.s7_1_body': return 'جميع محتويات المنصة، بما في ذلك اسم "Waslaq" وشعارها وتصميم واجهتها ورمزها المصدري ومحتواها المكتوب وميزاتها الحصرية، هي ملكية فكرية حصرية لشركة "Waslaq" وتخضع لحماية قوانين حقوق النشر والعلامات التجارية والملكية الفكرية المعمول بها. ولا يجوز لأي مستخدم إعادة إنتاج محتويات المنصة أو توزيعها أو استغلالها تجاريًا دون الحصول على موافقة خطية مسبقة.';
			case 'terms.s7_2_title': return '7.2 ترخيص محتوى المستخدم';
			case 'terms.s7_2_body': return 'من خلال نشر المحتوى على Waslaq (بما في ذلك قوائم المنتجات والصور والمنشورات والتعليقات ومحتوى المجتمع)، فإنك تمنح Waslaq ترخيصًا غير حصري وخاليًا من الرسوم وعالمي النطاق وقابل للترخيص من الباطن لاستخدام هذا المحتوى وعرضه وإعادة إنتاجه وتوزيعه لغرض تشغيل المنصة والترويج لها. وينتهي هذا الترخيص عند حذف المحتوى أو إغلاق حسابك، مع مراعاة متطلبات الاحتفاظ بالبيانات.';
			case 'terms.s7_3_title': return '7.3 حقوق الملكية الفكرية لأطراف ثالثة';
			case 'terms.s7_3_body': return 'يتحمل البائعون وحدهم المسؤولية الكاملة عن ضمان عدم انتهاك قوائم منتجاتهم وصورها وأوصافها والإشارات إلى العلامات التجارية لأي حقوق ملكية فكرية لأطراف ثالثة، بما في ذلك العلامات التجارية وحقوق النشر وبراءات الاختراع أو المظهر التجاري. ستستجيب "واسلق" لإشعارات انتهاك حقوق الملكية الفكرية الصحيحة وستقوم بإزالة المحتوى المخالف. وسيؤدي تكرار الانتهاك إلى إغلاق الحساب بشكل نهائي.';
			case 'terms.s8_1_title': return '8.1 فتح نزاع';
			case 'terms.s8_1_body': return 'يجب فتح النزاعات حصريًّا من خلال نظام النزاعات المدمج في المنصة، والذي يمكن الوصول إليه من صفحة تفاصيل الطلب تحت "الحساب" → "الطلبات". ويجب تقديم النزاعات قبل انتهاء "فترة الفحص" المعمول بها. وأي مطالبة يتم تقديمها بعد تحويل الأموال إلى البائع تُعتبر قانونياً بمثابة تنازل عنها ولن يتم النظر فيها.';
			case 'terms.s8_2_title': return '8.2 الأدلة والإجراءات';
			case 'terms.s8_2_body': return 'يقع عبء الإثبات على عاتق المشتري. ويجوز تقديم أدلة داعمة مثل الصور الفوتوغرافية ومقاطع الفيديو ولقطات الشاشة والأوصاف المكتوبة. ويجوز لـ«واسلق» أن تطلب وثائق إضافية من أي من الطرفين. وسيتم إخطار البائع ومنحه فرصة معقولة للرد خلال فترة النزاع.';
			case 'terms.s8_3_title': return '8.3 قرار المنصة';
			case 'terms.s8_3_body': return 'بعد مراجعة جميع الأدلة المقدمة، ستصدر «واسلق» قرارًا نهائيًا وملزمًا وغير قابل للاستئناف. وفي الحالات التي يثبت فيها خطأ البائع، يجوز لـ«واسلق» رد المبلغ إلى المشتري مباشرةً من الرصيد المتاح لدى البائع أو المودع في حساب الضمان، دون الحاجة إلى موافقة البائع. ويُعتبر قرار «واسلق» نهائيًا ويشكل تسوية كاملة ونهائية للنزاع.';
			case 'terms.s8_4_title': return '8.4 إساءة استخدام نظام تسوية المنازعات';
			case 'terms.s8_4_body': return 'يُعد تقديم أدلة مزورة أو ملفقة أو تم التلاعب بها في أي نزاع بمثابة احتيال. وتحتفظ "واسلاق" بالحق في إنهاء حساب المستخدم المخالف على الفور، ومصادرة أي أموال معلقة، واللجوء إلى سبل الانتصاف القانونية المدنية والجنائية.';
			case 'terms.s9_intro': return 'باستخدامك لـ Waslaq، فإنك توافق صراحةً على عدم الشروع في إجراءات استرداد المبلغ من خلال البنك الذي تتعامل معه أو الجهة المصدرة لبطاقتك أو مزود خدمة الدفع دون القيام أولاً بما يلي:';
			case 'terms.s9_breach_intro': return 'يُعد إجراء عملية استرداد غير مبررة أو سابقة لأوانها خرقًا جوهريًا لهذه الاتفاقية. وفي مثل هذه الحالات، تحتفظ Waslaq بالحق في:';
			case 'terms.s10_intro': return 'تفرض "واسلق" الرسوم التالية، والتي تخضع للتغيير بعد إخطار مسبق مدته 30 يومًا:';
			case 'terms.table_fee_type': return 'نوع الرسوم';
			case 'terms.table_amount': return 'المبلغ';
			case 'terms.table_applied_to': return 'يُطبق على';
			case 'terms.s10_note': return 'جميع الرسوم غير قابلة للاسترداد ما لم تقرر المنصة خلاف ذلك وفقًا لتقديرها الخاص. تحتفظ Waslaq بالحق في فرض رسوم أو تعديلها أو إلغائها في أي وقت، شريطة إخطار المستخدمين المعنيين مسبقًا بفترة معقولة.';
			case 'terms.s11_body': return 'تقدم "واسلق" خدماتها "كما هي" و"حسب توفرها" دون أي ضمانات من أي نوع، سواء كانت صريحة أو ضمنية، بما في ذلك على سبيل المثال لا الحصر الضمانات الضمنية المتعلقة بقابلية التسويق، أو الملاءمة لغرض معين، أو عدم الانتهاك، أو التوفر المستمر.';
			case 'terms.s11_liable_for': return 'إلى أقصى حد يسمح به القانون المعمول به، لا تتحمل شركة «واسلق» أي مسؤولية عن:';
			case 'terms.s11_cap_title': return 'الحد الأقصى للمسؤولية:';
			case 'terms.s11_cap_body': return 'في جميع الأحوال، لا يجوز أن يتجاوز إجمالي الالتزام المالي الأقصى لشركة «واسلق» تجاه أي مستخدم فيما يتعلق بأي معاملة أو مطالبة فردية القيمة الإجمالية لتلك المعاملة المحددة كما هي مسجلة على المنصة.';
			case 'terms.s12_1_title': return '12.1 بواسطة Waslaq';
			case 'terms.s12_1_body': return 'تحتفظ Waslaq بالحق في تعليق أو إنهاء أي حساب بشكل دائم، سواء بإشعار مسبق أو بدونه، في حالة انتهاك هذه الاتفاقية، أو الاشتباه في حدوث احتيال، أو الإضرار بسمعة المنصة، أو لأي سبب آخر وفقًا لتقديرها الخاص. وعند الإنهاء، سيتم إلغاء حق الوصول إلى المنصة على الفور.';
			case 'terms.s12_2_title': return '12.2 التأثير على الصناديق';
			case 'terms.s12_2_body': return 'في حالة إنهاء الحساب لسبب وجيه (بما في ذلك الاحتيال أو الإخلال الجسيم بالشروط)، تحتفظ Waslaq بالحق في حجز أي رصيد معلّق كضمان للمطالبات أو عمليات رد المبالغ المدفوعة أو الإجراءات القانونية. وسيتم تحويل الأموال غير الخاضعة لأي مطالبة إلى حساب الدفع المسجل الخاص بالمورد في غضون 30 يومًا من تاريخ إغلاق الحساب، شريطة استكمال إجراءات "اعرف عميلك" (KYC) والتحقق من الهوية.';
			case 'terms.s12_3_title': return '12.3 من جانب المستخدم';
			case 'terms.s12_3_body': return 'يمكن للمستخدمين إغلاق حساباتهم في أي وقت من خلال إعدادات الحساب. وقبل الإغلاق، يجب تنفيذ أو تسوية جميع الطلبات المعلقة، كما يجب تسوية أي أموال متنازع عليها. وستحتفظ Waslaq بسجلات المعاملات وفقًا لما يقتضيه القانون المعمول به.';
			case 'terms.s13_body': return 'تخضع هذه الاتفاقية لقوانين دولة فلسطين وتُفسَّر وتُنفَّذ وفقًا لها. ويخضع أي نزاع أو خلاف أو مطالبة تنشأ عن هذه الاتفاقية أو تتعلق بها، بما في ذلك إبرامها أو صلاحيتها أو خرقها أو إنهاؤها، للاختصاص القضائي الحصري للمحاكم الفلسطينية المختصة. ويخضع المستخدمون بشكل نهائي للاختصاص القضائي الشخصي لهذه المحاكم ويتنازلون عن أي اعتراض على الإجراءات أمامها بحجة المكان أو عدم ملاءمة المحكمة.';
			case 'terms.s14_intro': return 'تحتفظ Waslaq بالحق في تعديل شروط الاستخدام هذه أو تحديثها أو استبدالها في أي وقت. وعند إجراء تغييرات جوهرية:';
			case 'terms.s14_acceptance': return 'إن استمرار استخدام المنصة بعد تاريخ سريان أي تعديل يُعتبر موافقة كاملة وغير مشروطة من جانبك على الشروط المعدلة. إذا لم توافق على الشروط المعدلة، فيجب عليك التوقف عن استخدام المنصة ويحق لك طلب حذف حسابك.';
			case 'terms.footer_questions_title': return 'هل لديك أسئلة حول هذه الشروط؟';
			case 'terms.footer_contact_text': return 'اتصل بفريقنا القانوني على ... أو تفضل بزيارة موقعنا';
			case 'terms.table_fee_row1_type': return 'رسوم منصة الطلبات المادية';
			case 'terms.table_fee_row1_amount': return '2 شيكل ثابت لكل طلب';
			case 'terms.table_fee_row1_applied': return 'يتم تضمينها في المبلغ الإجمالي كرسوم توصيل/خدمة';
			case 'terms.table_fee_row2_type': return 'رسوم منصة المنتجات الرقمية';
			case 'terms.table_fee_row2_amount': return 'شيكل واحد لكل قطعة';
			case 'terms.table_fee_row2_applied': return 'يُخصم من المبلغ الإجمالي عند تقديم الطلب';
			case 'terms.table_fee_row3_type': return 'عمولة الدفع للبائع';
			case 'terms.table_fee_row3_amount': return '5% من مبلغ الدفع';
			case 'terms.table_fee_row3_applied': return 'يُخصم عند تنفيذ عملية الدفع';
			case 'terms.table_fee_row4_type': return 'رسوم التحويل المصرفي';
			case 'terms.table_fee_row4_amount': return '8 شواقل ثابتة لكل عملية تحويل';
			case 'terms.table_fee_row4_applied': return 'تم استيعابها من قبل المنصة — لم يتم تحميلها على المورد';
			case 'refund.page_title': return 'سياسة الاسترداد والإرجاع';
			case 'refund.last_updated': return 'تاريخ السريان: 1 مايو 2026 · آخر تحديث: 1 مايو 2026';
			case 'refund.intro': return 'تلتزم "واسلق" بتوفير تجربة تسوق عادلة وشفافة وآمنة. تحدد سياسة الاسترداد والإرجاع هذه الشروط التي يحق للمشترين بموجبها استرداد أموالهم، وإجراءات تسوية النزاعات، والتزامات البائعين فيما يتعلق بالإرجاع، والحقوق والقيود السارية على جميع الأطراف.';
			case 'refund.s1_title': return 'نافذة الفحص';
			case 'refund.s2_title': return 'شروط استحقاق استرداد المبلغ';
			case 'refund.s3_title': return 'الحالات غير المؤهلة';
			case 'refund.s4_title': return 'كيفية فتح نزاع';
			case 'refund.s5_title': return 'عبء الإثبات';
			case 'refund.s6_title': return 'معالجة عمليات استرداد الأموال';
			case 'refund.s7_title': return 'سياسات إرجاع البائعين';
			case 'refund.s8_title': return 'المنتجات الرقمية — أحكام خاصة';
			case 'refund.s9_title': return 'التزامات البائع فيما يتعلق برد الأموال';
			case 'refund.s10_title': return 'الاتصال والدعم';
			case 'refund.buyer_protection_title': return 'حماية المشتري من Waslaq';
			case 'refund.buyer_protection_desc': return 'يتم حماية كل طلب يتم تقديمه على منصة "واسلق" من خلال نظام الضمان الخاص بنا. حيث تحتفظ المنصة بأموالك في حساب آمن، ولا يتم تحويلها إلى البائع إلا بعد انتهاء فترة الفحص الإلزامية — مما يمنحك الوقت الكافي للتأكد من وصول طلبك بشكل صحيح ومطابق للوصف. ولا يُطلب منك أبدًا قبول أي طلب معيب أو غير صحيح أو مزيف.';
			case 'refund.s1_body1': return 'تُعد «فترة المراجعة» فترة تعليق إلزامية تبدأ عند تسليم الطلب أو تأكيد الشحن من البائع. خلال هذه الفترة، تظل الأموال مودعة في حساب الضمان ولا يتم تحويلها إلى البائع. يجب عليك فتح أي نزاع قبل انتهاء هذه الفترة.';
			case 'refund.physical_products_label': return 'المنتجات المادية';
			case 'refund.physical_products_body': return '48 ساعة من لحظة قيام البائع بوضع علامة "تم الشحن" على الطلب أو تأكيد التسليم.';
			case 'refund.digital_products_label': return 'المنتجات الرقمية';
			case 'refund.digital_products_body': return '24 ساعة من وقت تسليم المفتاح الرقمي أو الملف أو بيانات اعتماد الوصول إلى المشتري.';
			case 'refund.s1_important': return 'بمجرد انتهاء فترة المراجعة وتحويل الأموال إلى البائع، تعتبر المعاملة نهائية ومُسوَّاة من الناحية القانونية. ولن يتم قبول أي مطالبات باسترداد الأموال بعد هذه المرحلة تحت أي ظرف من الظروف، باستثناء حالات الاحتيال المؤكدة وفقًا لتقدير المنصة وحدها.';
			case 'refund.s2_intro': return 'تغطي خدمة حماية المشتري من Waslaq الحالات التالية. وفي كل حالة، يجب فتح نزاع قبل انتهاء فترة الفحص، ويجب أن يتضمن أدلة داعمة:';
			case 'refund.s2_item1_title': return 'لم يتم استلام المنتج';
			case 'refund.s2_item1_body': return 'لم يقم البائع بشحن الطلب في غضون فترة زمنية معقولة، ولم يقدم أي تحديث صالح لتتبع الشحنة أو تأكيدًا بالتسليم. ولم يستلم المشتري السلعة، ولا يوجد أي دليل على محاولة التسليم.';
			case 'refund.s2_item2_title': return 'يختلف بشكل كبير عما هو موصوف';
			case 'refund.s2_item2_body': return 'يختلف المنتج المستلم اختلافًا جوهريًا وجوهريًا عما ورد في الإعلان — على سبيل المثال، منتج خاطئ تمامًا، أو لون أو مقاس خاطئ لم يتم الإفصاح عنه، أو مكونات مفقودة كانت جزءًا من المنتج المُعلن عنه، أو حالة (مثل: مستعمل مقابل جديد) تتعارض مع ما ورد في الإعلان.';
			case 'refund.s2_item3_title': return 'وصلت السلعة تالفة';
			case 'refund.s2_item3_body': return 'وصل المنتج في حالة تجعله غير صالح للاستخدام أو مكسورًا أو غير قابل للاستخدام فعليًّا، حيث وقع التلف قبل استلامه من قِبل المشتري. يجب على المشتري تقديم دليل مصور أو مسجل بالفيديو يثبت التلف الذي حدث عند فتح العبوة أو عند الاستخدام الأول.';
			case 'refund.s2_item4_title': return 'منتج مقلد دون الإفصاح عن ذلك';
			case 'refund.s2_item4_body': return 'تم عرض منتج وبيعه على أنه أصلي أو حقيقي أو يحمل علامة تجارية معروفة، لكن المنتج الذي تم استلامه مزيف بشكل واضح أو غير أصلي دون الإفصاح عن ذلك مسبقًا في الإعلان. ملاحظة: إذا كان الإعلان قد أشار إلى أن المنتج نسخة مقلدة أو غير أصلي، فلا ينطبق هذا الشرط.';
			case 'refund.s2_item5_title': return 'منتج رقمي غير وظيفي';
			case 'refund.s2_item5_body': return 'المفتاح الرقمي أو رمز التفعيل أو الملف القابل للتنزيل غير صالح أو منتهي الصلاحية أو تم استخدامه بالفعل من قبل مستخدم سابق أو تالف أو غير صالح للاستخدام لأي سبب آخر وقت التسليم. يجب على المشتري تقديم دليل على الخلل (مثل لقطة شاشة لرسالة الخطأ الصادرة عن المنصة أو الناشر).';
			case 'refund.s2_item6_title': return 'تكرار الرسوم';
			case 'refund.s2_item6_body': return 'تم تحصيل المبلغ من المشتري أكثر من مرة عن نفس الطلب بسبب خطأ في معالجة الدفع. ويجب أن تتضمن الأدلة سجلات تأكيد الدفع.';
			case 'refund.s3_intro': return 'لا تشمل خدمة «حماية المشتري من واسلق» الحالات التالية بشكل صريح:';
			case 'refund.s3_item1_title': return 'تغيير الرأي';
			case 'refund.s3_item1_body': return 'تلقى المشتري المنتج الصحيح الذي لم يتعرض لأي تلف والذي تمت وصفه بدقة، ولكنه ببساطة لم يعد يرغب فيه. في هذه الحالة، تُطبق سياسة الإرجاع الخاصة بالبائع حصريًّا. ولا تتدخل Waslaq في عمليات الإرجاع الناجمة عن تغيير الرأي.';
			case 'refund.s3_item2_title': return 'فترة تقديم المطالبات بعد الفحص';
			case 'refund.s3_item2_body': return 'أي نزاع أو طلب استرداد يُقدم بعد انتهاء فترة الفحص وتسديد المبلغ إلى البائع. تُعتبر هذه المطالبات قد تم التنازل عنها قانونًا ولن يتم النظر فيها.';
			case 'refund.s3_item3_title': return 'الأضرار التي يتسبب فيها المشتري';
			case 'refund.s3_item3_body': return 'السلع التي كانت في حالة جيدة عند التسليم، لكنها تعرضت للتلف لاحقًا بسبب سوء الاستخدام أو التعامل غير السليم أو التعديل أو التلف العرضي من جانب المشتري.';
			case 'refund.s3_item4_title': return 'المنتجات المعلن عنها على أنها غير أصلية أو مقلدة';
			case 'refund.s3_item4_body': return 'المنتجات التي تم وصفها بوضوح وصراحة في عنوان الإعلان ووصفه على أنها مزيفة أو نسخة طبق الأصل أو مقلدة أو غير أصلية. وبشراء هذه المنتجات، يكون المشتري قد وافق عن علم على طبيعة المنتج.';
			case 'refund.s3_item5_title': return 'المنتجات الرقمية التي تم استرداد قيمتها';
			case 'refund.s3_item5_body': return 'المفاتيح الرقمية أو الرموز أو القسائم التي تم استرداد قيمتها أو تفعيلها أو استخدامها بالفعل من قِبل المشتري أو أي طرف شاركه المشتري الرمز، بغض النظر عما إذا كان المنتج قد حقق التوقعات بعد ذلك أم لا.';
			case 'refund.s3_item6_title': return 'مشاكل عدم التوافق المعروفة وقت الشراء';
			case 'refund.s3_item6_body': return 'المنتجات التي تعمل بالشكل الموصوف، ولكنها غير متوافقة مع الجهاز أو المنطقة أو الحساب أو المنصة الخاصة بالمشتري، شريطة أن تكون متطلبات التوافق هذه قد تم الإفصاح عنها أو كان من الممكن اكتشافها بشكل معقول في وصف المنتج.';
			case 'refund.s3_item7_title': return 'اختلافات طفيفة في المظهر';
			case 'refund.s3_item7_body': return 'اختلافات طفيفة في اللون، أو اختلافات في التغليف، أو عيوب شكلية بسيطة لا تؤثر بشكل جوهري على وظيفة المنتج أو قابليته للاستخدام، وتقع ضمن حدود التفاوت الطبيعية للمنتج.';
			case 'refund.s4_intro': return 'لطلب استرداد المبلغ أو الإبلاغ عن مشكلة تتعلق بطلبك، اتبع الخطوات التالية:';
			case 'refund.s4_step1': return 'انتقل إلى "الحساب" → "الطلبات" وابحث عن الطلب المطلوب باستخدام رقم الطلب أو التاريخ.';
			case 'refund.s4_step2': return 'انقر على "فتح نزاع" في صفحة تفاصيل الطلب. هذا الخيار متاح فقط خلال فترة الفحص السارية.';
			case 'refund.s4_step3': return 'اختر سبب النزاع الأكثر دقة من بين الفئات المتاحة.';
			case 'refund.s4_step4': return 'يرجى تقديم وصف مكتوب مفصل للمشكلة، بما في ذلك التواريخ ذات الصلة، وما استلمته، وكيف يختلف عما كان مذكورًا.';
			case 'refund.s4_step5': return 'قم بتحميل الأدلة الداعمة: الصور الفوتوغرافية، ومقاطع الفيديو، ولقطات الشاشة، والإيصالات، أو أي وثائق تدعم مطالبتك. فكلما كانت أدلتك أقوى، زادت سرعة حل المشكلة.';
			case 'refund.s4_step6': return 'أرسل النزاع. ستتلقى إشعارًا بالتأكيد. سيتم إخطار البائع ومنحه مهلة للرد.';
			case 'refund.s4_step7': return 'تابع حالة النزاع من حسابك. قد تتصل بك "واسلق" لطلب معلومات إضافية. يرجى الرد بسرعة لتجنب أي تأخير.';
			case 'refund.s4_step8': return 'ستقوم "واسلق" بمراجعة جميع الأدلة وإصدار قرار نهائي ملزم. سيتم إخطارك بالنتيجة عبر البريد الإلكتروني وإشعار داخل التطبيق.';
			case 'refund.s4_tip': return 'نصيحة: للحصول على حل أسرع، قم بفتح شكواك في أقرب وقت ممكن خلال فترة الفحص، وقدم أدلة شاملة في شكل صور أو مقاطع فيديو فور اكتشاف المشكلة.';
			case 'refund.s5_body': return 'يقع عبء الإثبات على عاتق المشتري. ولا تقبل "واسلاق" إصدار حكم لصالح المشتري إلا بعد تقديم أدلة قاطعة. وتشمل الأدلة المقبولة ما يلي:';
			case 'refund.s5_item1': return 'صور فوتوغرافية أو مقاطع فيديو واضحة للسلعة المستلمة تُظهر بوضوح العيب أو التلف أو التباين.';
			case 'refund.s5_item2': return 'مقارنة جنبًا إلى جنب بين الصور والوصف الوارد في الإعلان والمنتج المستلم.';
			case 'refund.s5_item3': return 'لقطات شاشة لرسائل الخطأ الخاصة بالمنتجات الرقمية المعطلة، بما في ذلك ردود المنصة أو الناشر على هذه الأخطاء.';
			case 'refund.s5_item4': return 'صور التغليف التي توضح حالة المنتج عند وصوله (مفيدة في حالات المطالبة بالتعويض عن الأضرار).';
			case 'refund.s5_item5': return 'التواصل الكتابي مع البائع عبر نظام المراسلة الخاص بالمنصة.';
			case 'refund.s5_warning': return 'تحذير بشأن الاحتيال: يُعد تقديم أدلة مزورة أو ملفقة أو مزيفة أو تم التلاعب بها في أي نزاع بمثابة احتيال وانتهاك خطير لشروط استخدام «واسلق». وسيتم إغلاق حسابات المخالفين فوراً وبشكل نهائي، ومصادرة جميع الأرصدة المعلقة، وقد يتم الإبلاغ عنهم إلى السلطات الفلسطينية المختصة لاتخاذ الإجراءات القانونية اللازمة.';
			case 'refund.s6_1_title': return 'عندما يُحسم النزاع لصالح المشتري';
			case 'refund.s6_1_item1': return 'الأموال التي لا تزال مودعة في حساب الضمان: يتم إلغاء عملية دفع الأموال المودعة في حساب الضمان على الفور وإعادتها إلى وسيلة الدفع الأصلية للمشتري. ولا يتعين على البائع اتخاذ أي إجراء.';
			case 'refund.s6_1_item2': return 'الأموال التي تم تحويلها بالفعل إلى المورد: يتم خصم مبلغ الاسترداد مباشرةً من الرصيد المتاح للمورد. وإذا كان رصيد المورد غير كافٍ، فستقوم المنصة باحتجاز الأرباح المستقبلية حتى يتم سداد الدين بالكامل.';
			case 'refund.s6_1_item3': return 'استرداد كامل المبلغ: يتم إعادة المبلغ الكامل للطلب إلى المشتري، بما في ذلك أي رسوم خدمة للمنصة، إن وجدت.';
			case 'refund.s6_1_item4': return 'استرداد جزئي (حل جزئي): في الحالات التي يثبت فيها وجود خطأ جزئي من كلا الطرفين، يجوز لشركة «واسلق» إصدار استرداد جزئي وفقًا لتقديرها الخاص والنهائي.';
			case 'refund.s6_2_title': return 'الجدول الزمني لاسترداد الأموال';
			case 'refund.s6_2_body': return 'تختلف مدة معالجة عمليات استرداد الأموال باختلاف مزود خدمة الدفع الذي تستخدمه:';
			case 'refund.s6_2_item1': return 'بنك فلسطين والبوابات المحلية: من 3 إلى 7 أيام عمل من تاريخ اتخاذ القرار.';
			case 'refund.s6_2_item2': return 'طرق الدفع الأخرى: قد يستغرق الأمر ما يصل إلى 14 يوم عمل، حسب المزود.';
			case 'refund.s6_2_note': return 'لا تتحمل "واسلق" المسؤولية عن أي تأخير ناجم عن المدة التي يستغرقها البنك الذي تتعامل معه أو مزود خدمة الدفع في معالجة المعاملة.';
			case 'refund.s7_body1': return 'بالإضافة إلى الحماية التي توفرها منصة Waslaq، يجوز للبائعين نشر سياساتهم الخاصة بالإرجاع والاستبدال وخدمات ما بعد البيع على صفحة متجرهم العامة. وتسري هذه السياسات الخاصة بالبائعين حصريًّا على الحالات التي لا تشملها "حماية المشتري من Waslaq" — وأكثرها شيوعًا هي حالات الإرجاع بسبب تغيير الرأي في الطلبات التي تم تنفيذها بشكل صحيح.';
			case 'refund.s7_body2': return 'لا تفرض "واسلق" سياسات الإرجاع الخاصة بالبائعين ولا تضمنها. وعلى المشترين الراغبين في إرجاع المنتجات أو استبدالها بموجب سياسة البائع الخاصة بالتنسيق مباشرةً مع البائع عبر نظام المراسلة الخاص بالمنصة.';
			case 'refund.s7_tip': return 'قبل الشراء، نوصي بالاطلاع على سياسة الإرجاع التي ينشرها البائع على صفحة متجره، لا سيما بالنسبة للسلع عالية القيمة أو المنتجات التي تعتمد على التفضيل الشخصي.';
			case 'refund.s8_body': return 'تخضع المنتجات الرقمية، بما في ذلك مفاتيح الألعاب وتراخيص البرامج والقسائم والملفات القابلة للتنزيل ورموز التنشيط، للأحكام الإضافية التالية:';
			case 'refund.s8_item1': return 'التسليم الفوري: يتم تسليم المنتجات الرقمية تلقائيًا فور تأكيد الدفع. ويُعتبر التسليم قد اكتمل عندما يصبح الرمز أو الملف متاحًا في حساب المشتري أو يتم إرساله عبر البريد الإلكتروني.';
			case 'refund.s8_item2': return 'فترة فحص مدتها 24 ساعة: يتاح للمشترين 24 ساعة من تاريخ الاستلام لاختبار المنتج والإبلاغ عن أي مشاكل. بعد انقضاء هذه الفترة، تصبح عملية البيع نهائية.';
			case 'refund.s8_item3': return 'المفاتيح غير الصالحة: إذا كان المفتاح غير صالح أو تم استخدامه بالفعل عند التسليم، يجب على المشتري تقديم لقطة شاشة لرسالة الخطأ الصادرة عن الناشر. يتم رد قيمة المطالبات الصحيحة بالكامل.';
			case 'refund.s8_item4': return 'لا يُسمح باسترداد المبلغ بعد الاستخدام: بمجرد استرداد المفتاح الرقمي أو الرمز أو الترخيص، أو تفعيله، أو استخدامه — حتى لو كان ذلك جزئيًا — يُعتبر قد تم استهلاكه بالكامل، ولن يتم استرداد المبلغ بأي حال من الأحوال، بغض النظر عن مدى الرضا.';
			case 'refund.s8_item5': return 'مشاكل تقييد المنطقة: يتحمل المشتري مسؤولية التحقق من التوافق الإقليمي قبل الشراء. لا يُسمح برد الأموال في حالة المنتجات المقيدة إقليمياً إذا كان التقييد الإقليمي قد تم الإفصاح عنه أو كان من الممكن تحديده بشكل معقول من خلال وصف المنتج.';
			case 'refund.s9_role_title': return 'توضيح دور المنصة';
			case 'refund.s9_role_body1': return 'تعمل "واسلق" حصريًّا كوسيط تقني ومالي — أي كطرف محايد بين المشترين والبائعين. ولا تتحمل المنصة أي مسؤولية عن التسليم المادي أو التغليف أو الشحن أو الخدمات اللوجستية لأي طلب. وتقع جميع التزامات التسليم بالكامل على عاتق البائع. ولا تقوم "واسلق" بتخزين البضائع المادية أو شحنها أو مناولتها أو فحصها في أي مرحلة من المراحل.';
			case 'refund.s9_role_body2': return 'بالإضافة إلى ذلك، بمجرد انتهاء فترة الفحص وإطلاق الأموال، لا تتحمل المنصة أي مسؤولية مالية عن أي طلبات استرداد أو إرجاع لاحقة. وتصبح هذه الطلبات مسألة تخص المشتري والبائع حصريًّا، وتخضع لسياسة الإرجاع التي ينشرها البائع. ولن تتدخل "واسلق" أو تتوسط أو تمول عمليات الإرجاع خارج فترة الفحص السارية تحت أي ظرف من الظروف.';
			case 'refund.s9_vendor_intro': return 'يلتزم البائعون على منصة "واسلق" بالالتزامات التالية المتعلقة برد الأموال وإرجاع المنتجات:';
			case 'refund.s9_vendor_item1': return 'يجب على البائعين التأكد من أن جميع المنتجات المشحونة تتطابق تمامًا مع الوصف والحالة والمواصفات الواردة في الإعلان.';
			case 'refund.s9_vendor_item2': return 'يجب على البائعين الرد على إخطارات النزاع خلال المدة الزمنية التي تحددها المنصة. ويُعتبر عدم الرد اعترافًا ضمنيًا وقد يؤدي إلى رد المبلغ تلقائيًا إلى المشتري.';
			case 'refund.s9_vendor_item3': return 'يجب على البائعين الامتناع عن الاتصال بالمشترين خارج نظام المراسلة الخاص بالمنصة، وذلك بهدف ثنيهم عن رفع النزاعات أو عرض ترتيبات تعويض غير مصرح بها.';
			case 'refund.s9_vendor_item4': return 'في الحالات التي يتم فيها إصدار رد أموال من رصيد البائع، يوافق البائع بشكل نهائي على هذا الخصم كشرط للمشاركة في المنصة.';
			case 'refund.s9_vendor_item5': return 'قد تؤدي النزاعات المتكررة بشأن استرداد الأموال التي يتم الفصل فيها ضد البائع إلى مراجعة الحساب، أو إطالة فترات الاحتجاز في حساب الضمان، أو تعليق الحساب.';
			case 'refund.s10_intro': return 'للاستفسار عن هذه السياسة، أو للحصول على المساعدة في رفع نزاع، أو للحصول على الدعم بشأن طلب معين:';
			case 'refund.s10_item1': return 'استخدم نظام النزاعات مباشرةً من صفحة طلبك: الحساب → الطلبات → [الطلب] → فتح نزاع';
			case 'refund.s10_item2': return 'يرجى الاتصال بفريق الدعم لدينا على العنوان support@waslaq.com';
			case 'refund.s10_item3': return 'أرسل طلب دعم عبر صفحة الاتصال الخاصة بنا';
			case 'refund.s10_note': return 'الدعم متاح باللغتين العربية والإنجليزية. ونسعى للرد على جميع الاستفسارات في غضون يوم إلى يومين عمل.';
			case 'refund.s3_body': return 'لا تشمل خدمة «حماية المشتري من واسلق» الحالات التالية بشكل صريح:';
			case 'refund.s4_body': return 'لطلب استرداد المبلغ أو الإبلاغ عن مشكلة تتعلق بطلبك، اتبع الخطوات التالية:';
			case 'refund.s10_body': return 'للاستفسار عن هذه السياسة، أو للحصول على المساعدة في رفع نزاع، أو للحصول على الدعم بخصوص طلب معين:';
			case 'refund.footer_related_policies': return 'السياسات ذات الصلة';
			case 'refund.cookie_policy_link': return 'سياسة ملفات تعريف الارتباط';
			case 'refund.contact_support_link': return 'اتصل بالدعم الفني';
			case 'vendor_finances.ready_to_withdraw': return 'جاهز للسحب';
			case 'vendor_finances.pending_escrow': return 'قيد الانتظار (حساب الضمان)';
			case 'vendor_finances.awaiting_release': return 'في انتظار إصدار الإذن بالتنفيذ';
			case 'vendor_finances.total_paid_out': return 'إجمالي المبالغ المدفوعة';
			case 'vendor_finances.lifetime_withdrawals': return 'عمليات السحب على مدى العمر';
			case 'vendor_finances.request_withdrawal': return 'طلب السحب';
			case 'vendor_finances.amount_ils': return 'المبلغ (شيكل إسرائيلي)';
			case 'vendor_finances.request_payout': return 'طلب سحب الأموال';
			case 'vendor_finances.payout_note': return 'يتم معالجة عمليات الدفع يدويًّا من قِبل مسؤول المنصة في غضون 2 إلى 5 أيام عمل.';
			case 'vendor_finances.transaction_ledger': return 'دفتر الأستاذ';
			case 'vendor_finances.no_transactions': return 'لا توجد معاملات حتى الآن.';
			case 'vendor_settings.store_logo': return 'شعار المتجر';
			case 'vendor_settings.tap_to_change': return 'انقر لتغيير';
			case 'vendor_settings.store_info': return 'معلومات عامة';
			case 'vendor_settings.store_name': return 'اسم المتجر';
			case 'vendor_settings.store_description': return 'وصف المتجر';
			case 'vendor_settings.contact': return 'الاتصال';
			case 'vendor_settings.phone': return 'الهاتف';
			case 'vendor_settings.delivery': return 'التسليم';
			case 'vendor_settings.store_location': return 'موقع المتجر (المدينة)';
			case 'vendor_settings.location_placeholder': return 'على سبيل المثال: غزة، رام الله';
			case 'vendor_settings.delivery_zone': return 'منطقة التوصيل';
			case 'vendor_settings.select_zone': return 'اختر المنطقة...';
			case 'vendor_settings.zone_note': return 'لن يتم توصيل المنتجات المادية إلا داخل المنطقة التي اخترتها.';
			case 'vendor_settings.payout': return 'المبلغ المدفوع';
			case 'vendor_settings.payout_account': return 'حساب التحويل (IBAN أو PayPal)';
			case 'vendor_settings.payout_placeholder': return 'أدخل رقم IBAN أو عنوان بريدك الإلكتروني على PayPal';
			case 'vendor_settings.payout_hint': return 'سيتم إرسال مدفوعاتك إلى هذا العنوان. تأكد من صحته.';
			case 'vendor_settings.save_settings': return 'حفظ الإعدادات';
			case 'vendor_policies.title': return 'سياسات المتجر';
			case 'vendor_policies.audit_note': return 'يؤدي تحديث سياساتك إلى إنشاء نسخة جديدة دائمة وقابلة للتدقيق القانوني. ويتم الاحتفاظ بالإصدارات السابقة.';
			case 'vendor_policies.shipping_policy': return 'سياسة الشحن';
			case 'vendor_policies.shipping_placeholder': return 'أدخل سياسة الشحن الخاصة بك...';
			case 'vendor_policies.refund_policy': return 'سياسة الإرجاع والاسترداد';
			case 'vendor_policies.refund_placeholder': return 'أدخل سياسة الإرجاع والاسترداد الخاصة بك...';
			case 'vendor_policies.save': return 'حفظ السياسات';
			case 'digital_vault.title': return 'الخزينة الرقمية';
			case 'digital_vault.subtitle': return 'المنتجات الرقمية التي اشتريتها. يُسمح بتنزيل كل منتج مرة واحدة خلال 24 ساعة من الشراء.';
			case 'digital_vault.expired': return 'منتهية الصلاحية';
			case 'digital_vault.digital_product': return 'المنتج الرقمي';
			case 'digital_vault.downloads': return 'التنزيلات';
			case 'digital_vault.order': return 'طلب';
			case 'digital_vault.expired_on': return 'انتهت صلاحيتها في';
			case 'digital_vault.limit_reached': return 'تم الوصول إلى الحد الأقصى';
			case 'vendor_products.title': return 'منتجات متجرك';
			case 'vendor_products.subtitle': return 'قم بإدارة عناصر الكتالوج المادية والرقمية.';
			case 'vendor_products.cancel_creation': return 'إلغاء الإنشاء';
			case 'vendor_products.bulk_edit_stock': return 'التعديل الجماعي للمخزون';
			case 'vendor_products.create_new_product': return 'إنشاء منتج جديد';
			case 'vendor_products.product_details': return 'تفاصيل المنتج';
			case 'vendor_products.product_details_subtitle': return 'معلومات أساسية عن المنتج الذي تبيعه.';
			case 'vendor_products.product_title': return 'اسم المنتج';
			case 'vendor_products.product_title_placeholder': return 'مثل: وعاء خزفي مصنوع يدويًا';
			case 'vendor_products.description': return 'الوصف';
			case 'vendor_products.description_placeholder': return 'أخبر المشترين عن منتجك وميزاته والمواد المصنوع منها أو تعليمات الاستخدام...';
			case 'vendor_products.product_type': return 'نوع المنتج';
			case 'vendor_products.virtual_digital': return 'افتراضي / رقمي';
			case 'vendor_products.physical_item': return 'المنتج المادي';
			case 'vendor_products.virtual_desc': return 'البرامج، ملفات PDF، الوسائط، مفاتيح التفعيل';
			case 'vendor_products.physical_desc': return 'يتطلب الشحن';
			case 'vendor_products.category': return 'الفئة';
			case 'vendor_products.select_parent_category': return 'اختر الفئة الرئيسية';
			case 'vendor_products.select_subcategory': return 'اختر فئة فرعية (اختياري)';
			case 'vendor_products.category_hint': return 'يساعد اختيار فئة فرعية محددة العملاء على العثور على منتجك بسهولة أكبر.';
			case 'vendor_products.product_images': return 'صور المنتج';
			case 'vendor_products.add_images': return 'إضافة صور';
			case 'vendor_products.digital_asset_label': return 'الأصل الرقمي / رابط الاسترداد';
			case 'vendor_products.upload_file_label': return 'الخيار 1: تحميل ملف (بحد أقصى 128 ميغابايت)';
			case 'vendor_products.choose_file': return 'اختر ملفًا لتحميله...';
			case 'vendor_products.or': return 'أو';
			case 'vendor_products.external_link_label': return 'الخيار 2: توفير رابط خارجي';
			case 'vendor_products.external_link_placeholder': return 'https://g2a.com/... أو رابط Google Drive';
			case 'vendor_products.digital_delivery_note': return 'سيتلقى العملاء هذا الملف أو الرابط تلقائيًا عبر بريدهم الإلكتروني فور إتمام عملية الدفع بنجاح.';
			case 'vendor_products.inventory_notice': return 'إشعار بشأن المخزون';
			case 'vendor_products.inventory_note': return 'تتطلب المنتجات المادية تتبعًا. يمنع نظام المخزون الذكي لدينا البيع الزائد ويوقف عملية الدفع في حالة نفاد المنتج أثناء عملية الشراء. سيتم إرسال بريد إلكتروني إليك فورًا عندما يصل مخزون المنتج إلى 0.';
			case 'vendor_products.discard': return 'تجاهل';
			case 'vendor_products.launch_product': return 'إطلاق المنتج';
			case 'vendor_products.no_products': return 'لا توجد منتجات حتى الآن';
			case 'vendor_products.no_products_desc': return 'ابدأ بإدراج أول منتج مادي أو رقمي لديك للوصول إلى العملاء في جميع أنحاء العالم.';
			case 'vendor_products.list_first_item': return 'أدرج العنصر الأول';
			case 'vendor_products.edit_product': return 'تعديل المنتج';
			case 'vendor_products.price_ils': return 'السعر (شواقل إسرائيلية)';
			case 'vendor_products.save_changes': return 'حفظ التغييرات';
			case 'vendor_products.bulk_inventory_title': return 'تحرير المخزون بالجملة';
			case 'vendor_products.bulk_inventory_subtitle': return 'اضغط على رقم لتعديله';
			case 'vendor_products.units': return 'الوحدات';
			case 'vendor_products.default_label': return 'الافتراضي';
			case 'vendor_products.cancel': return 'إلغاء';
			case 'vendor_products.save_all_changes': return 'حفظ جميع التغييرات';
			case 'vendor_products.no_managed_inventory': return 'لم يتم العثور على أي منتجات ذات مخزون مُدار.';
			case 'vendor_products.delete_confirm': return 'هل أنت متأكد من رغبتك في حذف هذا المنتج؟ لا يمكن التراجع عن هذا الإجراء.';
			case 'vendor_products.price_placeholder': return 'على سبيل المثال: 99.99';
			case 'vendor_products.file_size_error': return 'حجم الملف يتجاوز الحد الأقصى البالغ 128 ميغابايت.';
			case 'vendor_products.upload_url_error': return 'فشل الحصول على رابط التحميل';
			case 'vendor_products.upload_failed_error': return 'فشل تحميل الملف إلى R2';
			case 'vendor_products.create_failed_error': return 'فشل إنشاء المنتج';
			case 'vendor_products.unexpected_upload_error': return 'حدث خطأ غير متوقع أثناء التحميل.';
			case 'vendor_products.delete_failed_error': return 'فشل حذف المنتج';
			case 'vendor_products.delete_error': return 'حدث خطأ أثناء حذف المنتج.';
			case 'vendor_products.update_failed_error': return 'فشل تحديث المنتج';
			case 'vendor_products.generic_error': return 'حدث خطأ';
			case 'vendor_products.invalid_qty': return 'غير صالح';
			case 'vendor_products.bulk_update_failed': return 'فشلت بعض عمليات التحديث. يرجى المحاولة مرة أخرى.';
			case 'vendor_products.options_title': return 'خيارات المنتج (اللون، الحجم، المادة)';
			case 'vendor_products.add_option': return 'إضافة + خيار';
			case 'vendor_products.no_options_note': return 'لم يتم تكوين أي خيارات. سيتم إنشاء هذا كنسخة افتراضية واحدة.';
			case 'vendor_products.variant_matrix': return 'مصفوفة المتغيرات';
			case 'vendor_products.track_stock': return 'مخزون القضبان';
			case 'vendor_products.price_column': return 'السعر (شواقل إسرائيلية)';
			case 'vendor_products.sku': return 'رقم المنتج';
			case 'vendor_products.variant_column': return 'صيغة';
			case 'vendor_products.default_config': return 'الإعدادات الافتراضية';
			case 'vendor_products.type_physical': return 'البدني';
			case 'vendor_products.type_digital': return 'رقمي';
			case 'vendor_products.option_name': return 'اسم الخيار';
			case 'vendor_products.comma_separated_values': return 'قيم مفصولة بفواصل';
			case 'vendor_products.option_name_placeholder': return 'على سبيل المثال، اللون';
			case 'vendor_products.values_placeholder': return 'على سبيل المثال: الأحمر، الأزرق، الأخضر';
			case 'vendor_products.stock_qty': return 'كمية المخزون';
			case 'vendor_products.dimensions': return 'الأبعاد (العرض/الطول/الارتفاع)';
			case 'vendor_products.sku_placeholder': return 'SKU-123';
			case 'vendor_products.weight_placeholder': return 'مثل: 0.5';
			case 'vendor_products.height_placeholder': return 'ح';
			case 'vendor_products.inventory_label': return 'المخزون';
			case 'vendor_products.unlimited': return 'بلا حدود';
			case 'vendor_products.out_of_stock': return 'غير متوفر';
			case 'vendor_orders.title': return 'طلباتي';
			case 'vendor_orders.ship_to': return 'الشحن إلى:';
			case 'vendor_orders.status_shipped': return 'تم الشحن';
			case 'vendor_orders.status_pending': return 'قيد الانتظار';
			case 'vendor_orders.status_processing': return 'المعالجة';
			case 'vendor_orders.status_delivered': return 'تم التسليم';
			case 'vendor_orders.status_cancelled': return 'تم إلغاؤه';
			case 'vendor_orders.status_awaiting_pickup': return 'في انتظار الاستلام';
			case 'vendor_orders.no_orders': return 'لا توجد طلبات حتى الآن';
			case 'vendor_orders.no_orders_desc': return 'عندما يشتري العملاء منتجاتك، ستظهر الطلبات هنا.';
			case 'vendor_orders.mark_shipped': return 'وضع علامة "تم الشحن"';
			case 'vendor_orders.shipping_loading': return 'الشحن…';
			case 'vendor_orders.order_number': return 'رقم الطلب';
			case 'vendor_orders.status_completed': return 'تم الانتهاء';
			case 'dispute.back': return 'العودة';
			case 'dispute.case_resolved_vendor': return 'تمت تسوية القضية: تم تحويل الأموال إلى المورد';
			case 'dispute.case_resolved_buyer': return 'تمت تسوية القضية: تم رد المبلغ إلى المشتري';
			case 'dispute.case_resolved_full_refund': return '✅ تم حل القضية: تم إصدار استرداد كامل للمبلغ';
			case 'dispute.dispute_opened': return 'تم فتح النزاع';
			case 'dispute.under_review': return 'قيد المراجعة';
			case 'dispute.image_attachment': return 'صورة مرفقة';
			case 'dispute.admin_badge': return 'المسؤول';
			case 'dispute.loading_chat': return 'جاري تحميل الدردشة...';
			case 'dispute.not_found': return 'لم يتم العثور على النزاع.';
			case 'dispute.no_messages': return 'لا توجد رسائل حتى الآن. أرسل رسالة لبدء المحادثة.';
			case 'dispute.input_placeholder': return 'اشرح مشكلتك للمورد والمسؤول...';
			case 'dispute.attachment_label': return '📎 المرفق';
			case 'dispute.status_open': return 'فتح';
			case 'dispute.status_resolved_refund': return 'تم حل المشكلة (استرداد المبلغ)';
			case 'dispute.status_resolved_release': return 'تم حله (تم إصداره)';
			case 'dispute.status_resolved_split': return 'تم حله (مقسم)';
			case 'dispute.status_under_review': return 'قيد المراجعة';
			case 'stores.title': return 'تصفح المتاجر';
			case 'stores.subtitle': return 'اكتشف البائعين الفلسطينيين المفضلين لديك وتابعهم.';
			case 'stores.no_stores': return 'لا توجد متاجر حتى الآن.';
			case 'stores.retry': return 'إعادة المحاولة';
			case 'stores.no_stores_yet': return 'لا توجد متاجر بعد';
			case 'social.message_button': return 'رسالة';
			case 'social.follow_button': return 'تابع';
			case 'social.visit_store_button': return 'تفضل بزيارة متجري';
			case 'social.share_button': return 'مشاركة';
			case 'social.comments_heading': return 'التعليقات';
			case 'social.comment_placeholder': return 'ما رأيك؟';
			case 'social.comment_button': return 'تعليق';
			case 'social.no_comments': return 'لا توجد تعليقات حتى الآن';
			case 'social.pending_button': return 'قيد الانتظار';
			case 'social.following_button': return 'فيما يلي';
			case 'social.replying_to': return 'رداً على';
			case 'social.protected_posts_title': return 'هذه المنشورات محمية';
			case 'social.protected_posts_desc': return 'لا يمكن إلا للمتابعين المعتمدين مشاهدة المنشورات.';
			case 'social.no_posts': return 'لا توجد مشاركات حتى الآن.';
			case 'social.no_replies': return 'لا توجد ردود حتى الآن.';
			case 'social.no_media': return 'لا توجد وسائط حتى الآن.';
			case 'social.years_ago': return ({required Object n}) => 'قبل ${n} سنة';
			case 'social.months_ago': return ({required Object n}) => 'قبل ${n} شهر';
			case 'social.days_ago': return ({required Object n}) => 'قبل ${n} يوم';
			case 'social.hours_ago': return ({required Object n}) => 'قبل ${n} ساعة';
			case 'social.minutes_ago': return ({required Object n}) => 'قبل ${n} دقيقة';
			case 'social.just_now': return 'قبل قليل';
			case 'social.years_short': return ({required Object n}) => '${n}سنة';
			case 'social.months_short': return ({required Object n}) => '${n}شهر';
			case 'social.days_short': return ({required Object n}) => '${n}ي';
			case 'social.hours_short': return ({required Object n}) => '${n}س';
			case 'social.minutes_short': return ({required Object n}) => '${n}د';
			case 'social.now_short': return 'الآن';
			case 'social.share_post': return ({required Object title, required Object url}) => 'شاهد هذا المنشور على واصلك: ${title}\n${url}';
			case 'store.title': return 'المتجر';
			case 'store.all_categories': return 'الكل';
			case 'store.products_count': return ({required Object count}) => '${count} منتج';
			case 'store.latest_arrivals': return 'أحدث المنتجات';
			case 'store.price_low_high': return 'السعر: من الأقل للأعلى';
			case 'store.price_high_low': return 'السعر: من الأعلى للأقل';
			case 'store.no_products_found': return 'لم يتم العثور على منتجات';
			case 'vendor_profile.products_tab': return 'المنتجات ({count})';
			case 'vendor_profile.qa_tab': return 'الأسئلة والأجوبة ({count})';
			case 'vendor_profile.reviews_tab': return 'التقييمات ({count})';
			case 'vendor_profile.policies_tab': return 'السياسات';
			case 'vendor_profile.store_not_found': return 'المتجر غير موجود';
			case 'vendor_profile.no_products': return 'لا توجد منتجات بعد';
			case 'vendor_profile.no_questions': return 'لا توجد أسئلة بعد';
			case 'vendor_profile.no_reviews': return 'لا توجد تقييمات بعد';
			case 'vendor_profile.no_policies': return 'لم يتم نشر أي سياسات بعد';
			case 'vendor_profile.vendor_answer': return 'إجابة البائع';
			case 'vendor_profile.awaiting_response': return 'في انتظار رد البائع...';
			case 'vendor_profile.verified_badge': return '✓ موثق';
			case 'vendor_profile.shipping_policy': return 'سياسة الشحن';
			case 'vendor_profile.return_refund_policy': return 'سياسة الإرجاع والاسترداد';
			case 'drawer.browse': return 'تصفح';
			case 'drawer.community_section': return 'المجتمع';
			case 'drawer.stores_section': return 'المتاجر';
			case 'drawer.account_section': return 'الحساب';
			case 'drawer.info_section': return 'المعلومات';
			case 'drawer.legal_section': return 'قانوني';
			case 'drawer.sign_in_prompt': return 'قم بتسجيل الدخول للوصول إلى مجتمعاتك ومتاجرك';
			case 'drawer.popular': return 'شائع';
			case 'drawer.news': return 'الأخبار';
			case 'drawer.saved': return 'المحفوظات';
			case 'drawer.create_community': return 'إنشاء مجتمع';
			case 'drawer.no_communities_joined': return 'لم تنضم إلى أي مجتمع بعد';
			case 'drawer.browse_all_stores': return 'تصفح جميع المتاجر';
			case 'drawer.my_store': return 'متجري';
			case 'drawer.not_vendor_yet': return 'لست بائعاً بعد — كن بائعاً الآن ←';
			case 'drawer.about_waslaq': return 'عن واصلك';
			case 'drawer.contact_us': return 'اتصل بنا';
			case 'drawer.feedback': return 'الملاحظات';
			case 'info.about_title': return 'عن واصلك';
			case 'info.contact_title': return 'اتصل بنا';
			case 'info.feedback_title': return 'الملاحظات';
			case 'info.our_mission': return 'مهمتنا';
			case 'info.what_we_offer': return 'ماذا نقدم';
			case 'info.trust_safety': return 'الثقة والأمان';
			case 'info.get_in_touch': return 'تواصل معنا';
			case 'info.send_message': return 'إرسال الرسالة';
			case 'info.help_us_improve': return 'ساعدنا في التحسين';
			case 'info.submit_feedback': return 'إرسال الملاحظات';
			case 'info.message_sent': return 'تم إرسال الرسالة! سنقوم بالرد عليك قريباً.';
			case 'info.thank_you_feedback': return 'شكراً لملاحظاتك!';
			case 'info.write_feedback_required': return 'يرجى كتابة ملاحظاتك';
			case 'info.failed_submit_feedback': return 'فشل الإرسال. يرجى المحاولة مرة أخرى.';
			case 'info.feedback_desc': return 'تساعدنا ملاحظاتك في بناء منصة أفضل.';
			case 'info.category': return 'الفئة';
			case 'info.rating': return 'التقييم';
			case 'info.your_feedback': return 'ملاحظاتك';
			case 'info.feedback_hint': return 'أخبرنا برأيك...';
			case 'info.type_general': return 'عام';
			case 'info.type_bug': return 'خطأ برمجي';
			case 'info.type_feature': return 'ميزة جديدة';
			case 'info.type_design': return 'التصميم';
			case 'info.about_subtitle': return 'سوقك الفلسطيني الأول';
			case 'info.our_mission_body': return 'واصلك هو سوق اجتماعي هجين مبني لفلسطين. نحن نجمع بين أفضل محتوى يقوده المجتمع ومنصة تجارة إلكترونية موثوقة، ونربط البائعين المحليين بالمشترين من خلال نظام ضمان آمن.';
			case 'info.what_we_offer_body': return '• بائعون محليون موثوقون مع حماية الضمان\n• محتوى ونقاشات يقودها المجتمع\n• منتجات رقمية ومادية\n• مدفوعات آمنة عبر Stripe\n• مناطق توصيل في غزة والضفة الغربية';
			case 'info.trust_safety_body': return 'كل معاملة معاملة محمية بنظام الضمان الخاص بنا. يتم الاحتفاظ بالأموال بأمان حتى يؤكد المشتري الاستلام. يتم التحقق من البائعين وتقييمهم من قبل المجتمع.';
			case 'info.version': return ({required Object version}) => 'الإصدار ${version}';
			case 'info.fill_all_fields': return 'يرجى ملء جميع الحقول';
			case 'info.failed_send_message': return 'فشل الإرسال. يرجى المحاولة مرة أخرى.';
			case 'info.contact_desc': return 'لديك سؤال أو بحاجة إلى مساعدة؟ أرسل لنا رسالة.';
			case 'info.name_label': return 'الاسم';
			case 'info.message_label': return 'الرسالة';
			case 'orders.title': return 'طلباتي';
			case 'orders.failed_load': return 'فشل تحميل الطلبات';
			case 'orders.retry': return 'إعادة المحاولة';
			case 'orders.no_orders': return 'لا توجد طلبات حتى الآن';
			case 'orders.today': return 'اليوم';
			case 'orders.yesterday': return 'أمس';
			case 'orders.days_ago': return ({required Object n}) => 'منذ ${n} أيام';
			case 'orders.weeks_ago': return ({required Object n}) => 'منذ ${n} أسبوع';
			case 'orders.months_ago': return ({required Object n}) => 'منذ ${n} أشهر';
			case 'notifications.title': return 'الإشعارات';
			case 'notifications.failed_load': return 'فشل تحميل الإشعارات';
			case 'notifications.retry': return 'إعادة المحاولة';
			case 'notifications.no_notifications': return 'لا توجد إشعارات حتى الآن';
			case 'saved_items.title': return 'العناصر المحفوظة';
			case 'saved_items.failed_load': return 'فشل تحميل العناصر المحفوظة';
			case 'saved_items.retry': return 'إعادة المحاولة';
			case 'saved_items.products_tab': return 'المنتجات';
			case 'saved_items.posts_tab': return 'المنشورات';
			case 'saved_items.no_products': return 'لا توجد منتجات محفوظة بعد';
			case 'saved_items.no_products_sub': return 'اضغط ♡ على أي منتج لحفظه هنا.';
			case 'saved_items.no_posts': return 'لا توجد منشورات محفوظة بعد';
			case 'saved_items.no_posts_sub': return 'احفظ المنشورات من موجز المجتمع.';
			case 'saved_items.could_not_load': return 'تعذّر تحميل المنتجات';
			case 'legal.privacy_policy_title': return 'سياسة الخصوصية';
			case 'legal.terms_title': return 'شروط الخدمة';
			case 'create_post.sheet_title': return 'ماذا تريد أن تنشر؟';
			case 'create_post.general_post': return 'منشور عام';
			case 'create_post.community_post': return 'نشر داخل مجتمع';
			case 'create_post.community_post_in': return ({required Object slug}) => 'نشر في r/${slug}';
			case 'create_post.share_product': return 'مشاركة منتج';
			case 'create_post.share_product_named': return ({required Object title}) => 'مشاركة: ${title}';
			case 'create_post.ask_product': return 'سؤال عن منتج';
			case 'create_post.select_community_title': return 'اختر مجتمعاً';
			case 'create_post.search_communities': return 'ابحث عن مجتمعات...';
			case 'create_post.show_more_communities': return 'عرض المزيد من المجتمعات';
			case 'create_post.no_communities_found': return 'لم يتم العثور على مجتمعات';
			case 'create_post.private_community_locked': return 'خاص - انضم للاختيار';
			case 'create_post.create_community': return 'إنشاء مجتمع';
			case 'create_post.ai_assistant': return 'المساعد الذكي (AI)';
			case 'errors.network': return 'لا يوجد اتصال بالإنترنت — تحقق من الشبكة وحاول مجدداً';
			case 'errors.timeout': return 'الاتصال يستغرق وقتاً طويلاً — حاول مرة أخرى';
			case 'errors.server': return 'حدث خطأ من طرفنا — حاول مجدداً بعد قليل';
			case 'errors.unauthorized': return 'انتهت صلاحية الجلسة — سجّل الدخول من جديد';
			case 'errors.not_found': return 'لم نعثر على ما تبحث عنه';
			case 'errors.rate_limited': return 'محاولات كثيرة — انتظر لحظة وحاول مجدداً';
			case 'errors.validation': return 'بعض المعلومات غير صحيحة — راجعها وحاول مجدداً';
			case 'errors.unknown': return 'حدث خطأ ما — حاول مرة أخرى';
			case 'errors.offline_banner': return 'لا يوجد اتصال بالإنترنت';
			case 'errors.back_online': return 'عاد الاتصال';
			case 'errors.crash_title': return 'عذراً، حدث خلل';
			case 'errors.crash_message': return 'حدث خطأ غير متوقع. ارجع للخلف وحاول مجدداً.';
			case 'connections.title': return 'التواصل';
			case 'connections.followers': return 'المتابِعون';
			case 'connections.following': return 'يتابِع';
			case 'connections.no_followers': return 'لا يوجد متابِعون بعد';
			case 'connections.no_following': return 'لا يتابع أحداً بعد';
			case 'connections.remove_follower': return 'إزالة المتابِع';
			case 'connections.remove': return 'إزالة';
			case 'connections.remove_follower_confirm': return ({required Object name}) => 'إزالة ${name} من متابِعيك؟ لن يتم إخباره بذلك.';
			case 'connections.removed': return 'تمت إزالة المتابِع';
			case 'connections.block': return 'حظر';
			case 'connections.block_confirm': return ({required Object name}) => 'حظر ${name}؟ لن يتمكن من متابعتك أو مراسلتك.';
			case 'connections.blocked': return 'تم حظر المستخدم';
			case 'vendor_import.title': return 'استيراد / تصدير';
			case 'vendor_import.step1_title': return 'تصدير منتجاتك';
			case 'vendor_import.step1_desc': return 'نزّل منتجاتك الحالية كملف Excel، عدّل أو أضف صفوفاً جديدة، ثم أعد رفعه. البائعون الجدد يحصلون على صف نموذجي.';
			case 'vendor_import.step1_btn': return 'تصدير المنتجات (.xlsx)';
			case 'vendor_import.step2_title': return 'استيراد المنتجات';
			case 'vendor_import.step2_desc': return 'ارفع ملف .xlsx أو .csv المعبّأ. الحد الأقصى 100 منتج لكل عملية.';
			case 'vendor_import.tap_to_select': return 'اضغط لاختيار ملف';
			case 'vendor_import.file_too_large': return 'الملف يتجاوز حد 5 ميغابايت.';
			case 'vendor_import.import_completed': return 'اكتمل الاستيراد!';
			case 'vendor_import.import_failed': return ({required Object error}) => 'فشل الاستيراد: ${error}';
			case 'vendor_import.export_failed': return ({required Object error}) => 'فشل التصدير: ${error}';
			case 'vendor_import.export_share_text': return 'تصدير منتجات واصلك';
			case 'vendor_import.start_import': return 'بدء الاستيراد';
			case 'vendor_import.results_title': return 'نتائج الاستيراد';
			case 'vendor_import.products_created': return ({required Object count}) => 'تم إنشاء ${count} منتجات';
			case 'vendor_import.rows_failed': return ({required Object count}) => 'فشل ${count} صفوف';
			case 'vendor_import.import_another': return 'استيراد آخر';
			case 'vendor_import.done': return 'تم';
			default: return null;
		}
	}
}
