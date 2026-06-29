import 'package:auto_route/auto_route.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../router/app_router.dart';

/// Global router ref, set from main.dart so admin-managed banners/popups can
/// deep-link into the app the same way notification taps do.
AppRouter? appLinkRouter;

bool isExternalLink(String raw) {
  final l = raw.trim();
  if (l.startsWith('http://') || l.startsWith('https://')) return true;
  if (l.startsWith('/')) return false;
  // bare domain like example.com/x or www.shop.com
  return RegExp(r'^[\w-]+(\.[\w-]+)+').hasMatch(l);
}

String _normalizeExternal(String raw) {
  final l = raw.trim();
  if (l.startsWith('http://') || l.startsWith('https://')) return l;
  return 'https://$l';
}

Future<void> _launchExternal(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return;
  // User chose in-app: Custom Tabs / SafariViewController, fall back to system browser.
  try {
    final ok = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    if (ok) return;
  } catch (_) {}
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {}
}

/// Maps a WaslaQ internal path (storefront-style) to an in-app route.
PageRouteInfo? _routeForPath(String path) {
  var m = RegExp(r'^/r/([^/]+)/comments/([^/]+)$').firstMatch(path);
  if (m != null) return PostDetailRoute(community: m.group(1)!, postId: m.group(2)!);

  m = RegExp(r'^/r/([^/]+)/?$').firstMatch(path);
  if (m != null) return CommunityRoute(communitySlug: m.group(1)!);

  m = RegExp(r'^/u/([^/]+)$').firstMatch(path);
  if (m != null) return UserProfileRoute(userId: m.group(1)!);

  // /product/{handle} or /products/{handle} — ProductRoute(id:) resolves handle or id.
  m = RegExp(r'^/products?/([^/]+)$').firstMatch(path);
  if (m != null) return ProductRoute(id: m.group(1)!);

  // /vendors/{slug} or /store/{slug}
  m = RegExp(r'^/(?:vendors|store)/([^/]+)$').firstMatch(path);
  if (m != null) return VendorProfileRoute(slug: m.group(1)!);

  if (path == '/categories' || path.startsWith('/categories/')) return CategoriesRoute();
  if (path == '/cart') return const CartRoute();
  if (path == '/orders' || path.startsWith('/account/orders')) return const OrdersRoute();
  if (path == '/account') return const AccountRoute();
  if (path == '/store' || path == '/shop') return StoreRoute();
  if (path == '/community' || path == '/feed') return const FeedRoute();
  return null;
}

/// Opens an admin-managed link: external URLs in an in-app browser, internal
/// paths via the app router, unknown internal paths fall back to the web page.
Future<void> openWaslaqLink(String raw) async {
  final link = raw.trim();
  if (link.isEmpty || link == '/') return;

  if (isExternalLink(link)) {
    await _launchExternal(_normalizeExternal(link));
    return;
  }

  final path = link.split('?').first.split('#').first;
  final router = appLinkRouter;
  if (router != null) {
    try {
      final route = _routeForPath(path);
      if (route != null) {
        router.navigate(route);
        return;
      }
    } catch (_) {/* fall through to web fallback */}
  }
  // Unknown internal path → open the web version so the link still works.
  await _launchExternal('https://waslaq.ps$path');
}
