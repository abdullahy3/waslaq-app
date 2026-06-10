You are working on the WaslaQ Flutter app at ~/waslaq-app.

Read these files COMPLETELY before writing any code:
cat ~/waslaq-app/lib/features/checkout/data/models/checkout_model.dart
cat ~/waslaq-app/lib/features/checkout/data/checkout_repository.dart
cat ~/waslaq-app/lib/features/checkout/providers/checkout_provider.dart
cat ~/waslaq-app/lib/features/cart/data/models/cart_model.dart
cat ~/waslaq-app/lib/features/cart/providers/cart_provider.dart
cat ~/waslaq-app/lib/core/auth/auth_notifier.dart
cat ~/waslaq-app/lib/core/auth/auth_state.dart
cat ~/waslaq-app/lib/core/api/medusa_client.dart
cat ~/waslaq-app/lib/core/api/social_client.dart
cat ~/waslaq-app/lib/shared/theme/app_colors.dart
cat ~/waslaq-app/lib/router/app_router.dart
cat ~/waslaq-app/lib/features/account/ui/screens/account_screen.dart
cat ~/waslaq-app/lib/features/auth/ui/screens/sign_up_screen.dart
cat ~/waslaq-app/lib/features/messages/ui/screens/messages_screen.dart
cat ~/waslaq-app/lib/features/notifications/ui/screens/notifications_screen.dart

After reading ALL files, make ALL changes below in order.
Do not skip any section.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SECTION 1 — NATIVE CHECKOUT (replace WebView bridge)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

BACKGROUND:
The current checkout opens waslaq.com/checkout in a WebView which
requires a web session cookie — this never works from Flutter.
Replace it with a fully native checkout flow that calls the
Medusa API directly. The WebView is reserved for the future local
payment gateway's external bank OTP page only.

The checkout flow has 5 API calls in this exact order:

1. PATCH /store/carts/:id
   body: { shipping_address: {...}, email: string }
   country_code is always "ps" (Palestine)
2. GET /store/shipping-options?cart_id=:id
   returns { shipping_options: [ { id, name, amount } ] }
3. POST /store/carts/:id/shipping-methods
   body: { option_id: shippingOptionId }
4. POST /store/payment-collections
   body: { cart_id: cartId }
5. POST /store/carts/:id/complete
   returns { type: "order", data: { id, display_id, ... } }
   on success: type === "order"

STEP 1A — Update checkout_model.dart
Add these classes (keep existing Order and OrderItem):

class ShippingAddress {
final String firstName, lastName, address1, city, phone;
final String? province, postalCode, company;
const ShippingAddress({...});
Map<String, dynamic> toJson() => {
'first_name': firstName,
'last_name': lastName,
'address_1': address1,
'city': city,
'phone': phone,
'country_code': 'ps',
if (province != null) 'province': province,
if (postalCode != null) 'postal_code': postalCode,
if (company != null) 'company': company,
};
}

class ShippingOption {
final String id, name;
final double amount;
const ShippingOption({...});
factory ShippingOption.fromJson(Map<String, dynamic> json) => ShippingOption(
id: json['id'] as String,
name: json['name'] as String,
amount: (json['amount'] as num).toDouble(),
);
}

Update CheckoutSession to add:
final ShippingAddress? shippingAddress;
final String? selectedShippingOptionId;

STEP 1B — Update checkout_repository.dart
Replace the entire file with these methods:

static Future<void> setShippingAddress(
String cartId, ShippingAddress address, String email)
→ PATCH /store/carts/:cartId
body: { shipping_address: address.toJson(), email: email }

static Future<List<ShippingOption>> getShippingOptions(String cartId)
→ GET /store/shipping-options?cart_id=cartId
returns parsed list of ShippingOption

static Future<void> selectShippingMethod(
String cartId, String optionId)
→ POST /store/carts/:cartId/shipping-methods
body: { option_id: optionId }

static Future<void> initPaymentSession(String cartId)
→ POST /store/payment-collections
body: { cart_id: cartId }

static Future<Order> placeOrder(String cartId)
→ POST /store/carts/:cartId/complete
parse response.data['type'] — if 'order' return Order.fromJson(response.data['data'])
else throw Exception('Unexpected cart completion type')

Keep existing: getOrder(), extractOrderId(), isSuccessUrl(), isFailureUrl()
REMOVE: buildCheckoutUrl() — no longer needed

STEP 1C — Update checkout_provider.dart
Replace CheckoutNotifier with a step-based notifier:

enum CheckoutStep { address, shipping, review, processing, done, failed }

Add to CheckoutSession:
final CheckoutStep step;
final List<ShippingOption> shippingOptions;
final String? errorMessage;

CheckoutNotifier methods:
Future<void> startCheckout()
→ reads cart, sets step=address

    Future<void> submitAddress(ShippingAddress address, String email)
      → calls setShippingAddress
      → calls getShippingOptions
      → sets step=shipping, saves options in state

    Future<void> selectShipping(String optionId)
      → calls selectShippingMethod
      → calls initPaymentSession
      → sets step=review

    Future<Order?> placeOrder()
      → sets step=processing
      → calls placeOrder()
      → on success: clears cart, sets step=done, returns order
      → on failure: sets step=failed with errorMessage

STEP 1D — Replace checkout_screen.dart completely

Create a single CheckoutScreen that shows different content
based on CheckoutNotifier state step:

step=address → AddressForm widget (inline)
step=shipping → ShippingList widget (inline)
step=review → OrderReview widget (inline)
step=processing → centered CircularProgressIndicator
step=failed → error message + "Try Again" button
step=done → never shown (provider navigates away before this)

AddressForm widget:
Fields (all required unless marked optional): - First Name - Last Name - Phone - City (TextField — user types city name) - Address Line 1 - Province (optional TextField)
Submit button: "Continue to Shipping" (violet FilledButton)
Pre-fill email from auth state (authNotifierProvider)
On submit: call notifier.submitAddress(address, email)

ShippingList widget:
Title: "Select Shipping Method"
ListView of ShippingOption from state.shippingOptions
Each option: RadioListTile with name and "₪{amount}" price
Submit button: "Continue to Review"
On submit: call notifier.selectShipping(selectedId)

OrderReview widget:
Show cart items (read from cartProvider) with quantities and prices
Show selected shipping option name and price
Show total
Submit button: "Place Order" (violet FilledButton, full width)
On tap: final order = await notifier.placeOrder()
if order != null: context.router.replace(
OrderConfirmationRoute(orderId: order.id))

Design rules (apply to all three widgets):

- Black background, white text, violet accents
- All TextFormField borders: rounded 12px, violet when focused
- Padding: 24px horizontal
- Spacing: 16px between fields

STEP 1E — Update app_router.dart
Remove CheckoutRoute's child routes if any.
Make sure CheckoutRoute path is '/checkout' with no params.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SECTION 2 — SIGN UP SCREEN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Replace lib/features/auth/ui/screens/sign_up_screen.dart completely.

Fields:

- First Name
- Last Name
- Email
- Password (obscure toggle)
- Confirm Password (obscure toggle, validates match)

On submit: call ref.read(authNotifierProvider.notifier).registerWithEmail(email, password)

ref.listen on authNotifierProvider:
authenticated → context.router.replaceAll([HomeRoute()])
error → show SnackBar with message

After successful registration the auth flow runs automatically
(same as sign in — Firebase triggers \_onAuthStateChanged).

Design: identical style to sign_in_screen.dart

- WaslaQ title + subtitle "Create your account"
- Violet FilledButton "Create Account"
- "Already have an account? Sign In" link at bottom
  → context.router.replace(SignInRoute())

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SECTION 3 — ACCOUNT SCREEN FIXES
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Fix lib/features/account/ui/screens/account_screen.dart:

PROBLEM 1 — Display name shows "User" instead of real name.
The AuthState.authenticated has displayName from first_name.
In \_AuthenticatedView, the avatar initial and greeting currently
use displayName ?? email. The issue is first_name is stored as
displayName in auth state.
Fix: show displayName if not null and not empty, else show
the part of email before "@".
final name = (displayName != null && displayName.isNotEmpty)
? displayName
: email.split('@').first;

PROBLEM 2 — Vendor Dashboard button shows for all users.
Not all users are vendors. Add a vendor check:
GET /store/vendors/me → 200 means vendor, 404/401 means not vendor

Add a vendorCheckProvider:
@riverpod
Future<bool> isVendor(Ref ref) async {
try {
await MedusaClient.instance.get('/store/vendors/me');
return true;
} catch (\_) {
return false;
}
}

In \_AuthenticatedView, watch isVendorProvider:

- if isVendor=true → show "Vendor Dashboard" tile (existing)
- if isVendor=false → show "Become a Vendor" tile
  icon: Icons.store_outlined
  onTap: → context.router.push(SignUpVendorRoute())
  (If SignUpVendorRoute doesn't exist, navigate to
  a simple placeholder or just show a SnackBar
  "Vendor registration coming soon")
- if loading → show placeholder ListTile with shimmer

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SECTION 4 — FIX MESSAGES AND NOTIFICATIONS AUTH
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Messages and Notifications fail to load because the social_client
Dio instance does not inject the Medusa JWT automatically.

Read lib/core/api/social_client.dart.
It likely has a similar interceptor to medusa_client.dart.
If the \_AuthInterceptor is missing or not reading from SecureStorage,
add the same pattern:

@override
Future<void> onRequest(options, handler) async {
final token = await SecureStorage.getMedusaJwt();
if (token != null && !options.headers.containsKey('Authorization')) {
options.headers['Authorization'] = 'Bearer $token';
}
handler.next(options);
}

Also check messages_screen.dart and notifications_screen.dart —
if they show a generic error with no retry button, add:

- Centered error icon + error message text
- "Retry" OutlinedButton that calls ref.invalidate() on the provider

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
AFTER ALL CHANGES:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Run:
cd ~/waslaq-app
export JAVA_HOME=$HOME/jdk-21.0.5+11
  export PATH=$JAVA_HOME/bin:$PATH
  export ANDROID_HOME=$HOME/Android/sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools
dart run build_runner build --delete-conflicting-outputs
flutter analyze lib/ 2>&1 | grep -E "^ error" | head -20
flutter build apk --debug 2>&1 | grep -E "Built|error:" | head -5

Report:

1. build_runner exit code
2. flutter analyze — list every error in hand-written files only
   (ignore _.g.dart, _.freezed.dart warnings)
3. APK build result
4. Every file created or modified with its path
5. Any corrections made and why

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SECTION 5 — PROFILE SETTINGS SCREEN & SOCIAL API TIMEOUTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PROBLEMS RESOLVED:
1. API Latency Timeouts (AppException(null): Unknown error on /store/social/profiles/...)
2. Expiration of social credentials JWT causing silent 401s
3. LateInitializationError crashing the settings page into a blank/black screen on reload or account switch
4. Keyboard/focus layout loop freezing the page when scrolling down on Android
5. Stale display name ("User" fallback) and blank avatar icon on navbar/dashboard
6. Overscroll stretch animation lockups on Samsung One UI devices during list scrolling

IMPLEMENTED CHANGES:
1. lib/core/api/social_client.dart
   - Replicated the automated 401 JWT refresh/retry interceptor logic from MedusaClient. If a token expires, SocialClient now automatically refreshes the Firebase token and retries the request seamlessly.
   - Mapped all timeout exception types (connectionTimeout, sendTimeout, receiveTimeout, etc.) to AppException.network(endpoint) instead of generic "Unknown error" with null status code.

2. lib/features/account/ui/screens/settings/profile_settings_screen.dart
   - Removed 'late' from _avatarStyle and _avatarSeed and assigned safe defaults ('big-smile', 'Felix') to avoid LateInitializationErrors if network loading fails.
   - Wrapped the entire outer build tree inside a diagnostic try-catch block to render an "Initialization Crash Detected" screen with stack trace details instead of failing silently to a blank screen.
   - Migrated the scroll container from SingleChildScrollView + Column to an optimized, native ListView for seamless hardware-accelerated viewport rendering.
   - Added keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag to dismiss the software keyboard on scrolling.
   - Set physics: const ClampingScrollPhysics() on both the main vertical ListView and the horizontal swatches ListView to bypass the Samsung One UI stretch overscroll glow effect which locks GPU rendering.
   - Added `await ref.read(authNotifierProvider.notifier).refreshProfile()` inside _saveProfile so any saved profile changes (real first name, last name, and avatar style) immediately propagate to the global authentication state.

3. lib/features/account/ui/screens/account_screen.dart
   - Integrated a background profile sync trigger inside a post-frame callback in AccountScreen. When you open the Account tab, the app automatically fetches the latest user details in the background and replaces "user" placeholders with your real name and avatar style immediately.
