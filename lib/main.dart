import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'core/auth/firebase_service.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/preferences_provider.dart';
import 'core/providers/currency_provider.dart';
import 'i18n/strings.g.dart';
import 'core/config/app_config.dart';
import 'core/crashlytics/crash_reporter.dart';
import 'features/messages/providers/stream_chat_provider.dart';
import 'core/notifications/notification_bus.dart';
import 'core/navigation/app_links.dart';
import 'router/app_router.dart';
import 'shared/theme/app_colors.dart';
import 'shared/theme/app_theme.dart';
import 'shared/widgets/biometric_guard.dart';
import 'shared/widgets/offline_banner.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

// ─── Notification channel ────────────────────────────────────────────────────
const AndroidNotificationChannel _channel = AndroidNotificationChannel(
  'waslaq_messages_custom',
  'WaslaQ Messages',
  description: 'Notifications for new messages',
  importance: Importance.high,
  playSound: true,
  sound: RawResourceAndroidNotificationSound('waslaq'),
);

final FlutterLocalNotificationsPlugin _localNotifications =
    FlutterLocalNotificationsPlugin();

// Shows a local notification from a RemoteMessage (used for both foreground
// and background/data-only messages).
// Title priority: notification.title → data['title'] (waslaq social/commerce)
//                → data['sender_name'] (getstream chat) → default
// Body priority:  notification.body  → data['body']  (waslaq social/commerce)
//                → data['message_text'] (getstream chat) → default
Future<void> _showLocalNotification(RemoteMessage message) async {
  final data = message.data;

  // Extract title
  String title;
  if (message.notification?.title != null) {
    title = message.notification!.title!;
  } else if ((data['title'] as String?)?.isNotEmpty == true) {
    title = data['title'] as String;            // waslaq social/commerce FCM
  } else if ((data['sender_name'] as String?)?.isNotEmpty == true) {
    title = data['sender_name'] as String;      // getstream chat
  } else {
    title = 'واصلك';
  }

  // Extract body
  String body;
  if (message.notification?.body != null) {
    body = message.notification!.body!;
  } else if ((data['body'] as String?)?.isNotEmpty == true) {
    body = data['body'] as String;              // waslaq social/commerce FCM
  } else if ((data['message_text'] as String?)?.isNotEmpty == true) {
    body = data['message_text'] as String;      // getstream chat
  } else {
    body = 'You have a new notification on WaslaQ';
  }

  // Pass the link as payload so flutter_local_notifications can route on tap
  final payload = (data['link'] as String?)?.isNotEmpty == true ? data['link'] as String : null;
  await _localNotifications.show(
    message.hashCode,
    title,
    body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        _channel.id,
        _channel.name,
        channelDescription: _channel.description,
        importance: _channel.importance,
        priority: Priority.high,
        icon: '@mipmap/launcher_icon',
        color: const Color(0xFF000000),
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('waslaq'),
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'waslaq.wav',
      ),
    ),
    payload: payload,
  );
}

// ─── Background FCM handler (top-level, runs in separate isolate) ─────────────
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Must reinitialize flutter_local_notifications in background isolate.
  await _localNotifications.initialize(
    InitializationSettings(
      android: const AndroidInitializationSettings('@mipmap/launcher_icon'),
      iOS: const DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    ),
  );
  final androidPlugin = _localNotifications
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  await androidPlugin?.createNotificationChannel(_channel);
  await _showLocalNotification(message);
}

// Background notification tap handler — must be top-level + vm:entry-point.
// Fired when app is in background isolate context. Store link for main app to pick up.
@pragma('vm:entry-point')
void _onBgNotificationTapped(NotificationResponse response) {
  // Can't access _globalRouter here (different isolate).
  // The main app's onDidReceiveNotificationResponse handles this instead.
}

// ─── FCM initialization ───────────────────────────────────────────────────────
Future<void> _initFCM() async {
  try {
    // Initialize local notifications plugin
    await _localNotifications.initialize(
      InitializationSettings(
        android: const AndroidInitializationSettings('@mipmap/launcher_icon'),
        iOS: const DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final link = response.payload ?? '';
        if (link.isNotEmpty && link != '/') {
          if (_globalRouter != null) {
            Future.delayed(const Duration(milliseconds: 400), () => _navigateToLink(link));
          } else {
            _pendingNavLink = link; // cold start — WaslaqApp.build() will consume
          }
        }
      },
      onDidReceiveBackgroundNotificationResponse: _onBgNotificationTapped,
    );
    // Create the notification channel
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_channel);

    final messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // Foreground: show notification manually (Android ignores setForegroundNotificationPresentationOptions)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('[FCM] Foreground: ${message.notification?.title ?? message.data['type']}');
      _showLocalNotification(message);
      fcmMessageBus.notify(message);
      // Refresh bell badge instantly on foreground FCM
      notifyRefreshListeners();
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
    final initial = await messaging.getInitialMessage().timeout(
      const Duration(seconds: 3),
      onTimeout: () => null,
    );
    if (initial != null) _handleNotificationTap(initial);
  } catch (e, stack) {
    debugPrint('[FCM] Error in _initFCM: $e');
    CrashReporter.reportError(e, stack, reason: '_initFCM error');
  }
}

void _navigateToLink(String link) {
  if (_globalRouter == null || link.isEmpty || link == '/') return;
  // Parse /r/{community}/comments/{postId}
  final postMatch = RegExp(r'^/r/([^/]+)/comments/([^/]+)$').firstMatch(link);
  if (postMatch != null) {
    _globalRouter!.navigate(PostDetailRoute(
      community: postMatch.group(1)!,
      postId: postMatch.group(2)!,
    ));
    return;
  }
  // Parse /u/{userId}
  final userMatch = RegExp(r'^/u/([^/]+)$').firstMatch(link);
  if (userMatch != null) {
    _globalRouter!.navigate(UserProfileRoute(userId: userMatch.group(1)!));
    return;
  }
  // Parse /account/orders
  if (link.startsWith('/account/orders')) {
    _globalRouter!.navigate(const OrdersRoute());
    return;
  }
  // Parse /account/vendor
  if (link.startsWith('/account/vendor')) {
    _globalRouter!.navigate(const VendorDashboardRoute());
    return;
  }
  // Parse /account
  if (link.startsWith('/account')) {
    _globalRouter!.navigate(const AccountRoute());
    return;
  }
  // Parse /vendors/{slug}
  final vendorMatch = RegExp(r'^/vendors/([^/]+)$').firstMatch(link);
  if (vendorMatch != null) {
    _globalRouter!.navigate(VendorProfileRoute(slug: vendorMatch.group(1)!));
    return;
  }
}

void _handleNotificationTap(RemoteMessage message) {
  notifyRefreshListeners();
  final link = (message.data['link'] as String?) ?? '';
  if (link.isNotEmpty && link != '/') {
    Future.delayed(const Duration(milliseconds: 400), () => _navigateToLink(link));
  }
}

final fcmMessageBus = _FCMBus();

class _FCMBus {
  final _listeners = <void Function(RemoteMessage)>[];
  void notify(RemoteMessage m) { for (final l in _listeners) {
    l(m);
  } }
  void listen(void Function(RemoteMessage) l) => _listeners.add(l);
}

// Global router reference — set in WaslaqApp.build(), used by _handleNotificationTap
AppRouter? _globalRouter;
// Holds a deep-link from a notification tap that arrived before the router was ready
String? _pendingNavLink;

// ─── Entry point ──────────────────────────────────────────────────────────────

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // App-wide high refresh rate: pick the panel's highest mode (120/90Hz) at the
  // current resolution. No-op on 60Hz-only devices → they stay 60Hz. Android only;
  // iOS ProMotion is handled by CADisableMinimumFrameDurationOnPhone in Info.plist.
  if (!kIsWeb && Platform.isAndroid) {
    try {
      await FlutterDisplayMode.setHighRefreshRate();
    } catch (_) {
      // Non-fatal: device doesn't expose mode switching → stays at default.
    }
  }

  await Firebase.initializeApp();

  // Initialize Stripe — non-blocking: applySettings uses a platform channel
  // and can hang on release builds if native side is slow to init.
  try {
    Stripe.publishableKey = AppConfig.stripePublishableKey;
    await Stripe.instance.applySettings().timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        debugPrint('[Stripe] applySettings timed out — continuing startup');
      },
    );
  } catch (e) {
    debugPrint('[Stripe] init error (non-fatal): $e');
  }

  await CrashReporter.initialize();

  // Friendly fallback instead of grey/red crash screen in release builds.
  // Crashlytics still receives the real error via FlutterError.onError.
  final defaultErrorBuilder = ErrorWidget.builder;
  ErrorWidget.builder = (details) {
    if (kDebugMode) return defaultErrorBuilder(details);
    return Material(
      color: const Color(0xFFF8F8F8),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.sentiment_dissatisfied_rounded,
                  size: 48, color: Color(0xFF9E9E9E)),
              const SizedBox(height: 16),
              Text(
                t.errors.crash_title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF424242)),
              ),
              const SizedBox(height: 8),
              Text(
                t.errors.crash_message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Color(0xFF757575)),
              ),
            ],
          ),
        ),
      ),
    );
  };
  await FirebaseService.initializeGoogleSignIn();

  // Initialize FCM in the background without blocking app startup
  _initFCM().catchError((e, stack) {
    debugPrint('[FCM] Failed to initialize in background: $e');
    CrashReporter.reportError(e, stack, reason: 'FCM background init failed');
  });

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Synchronously preload secure storage settings before runApp to prevent startup lock bypass
  AppPreferences initialPrefs = const AppPreferences();
  try {
    const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: false,
        resetOnError: true,
      ),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
    final raw = await storage.read(key: 'waslaq_preferences');
    if (raw != null) {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      initialPrefs = AppPreferences(
        textScale: (map['textScale'] as num?)?.toDouble() ?? 1.0,
        arabicFont: map['arabicFont'] as String? ?? 'default',
        boldText: map['boldText'] as bool? ?? false,
        reduceAnimations: map['reduceAnimations'] as bool? ?? false,
        hapticFeedback: map['hapticFeedback'] as bool? ?? true,
        biometricLock: map['biometricLock'] as bool? ?? false,
        purchaseConfirmation: map['purchaseConfirmation'] as bool? ?? false,
        contentLanguage: map['contentLanguage'] as String? ?? 'both',
        muteKeywords: (map['muteKeywords'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        postDefaultVisibility: map['postDefaultVisibility'] as String? ?? 'public',
        autoRefreshMinutes: map['autoRefreshMinutes'] as int? ?? 5,
      );
    }
  } catch (e) {
    debugPrint('[main] Error pre-loading preferences: $e');
  }

  CrashReporter.log('WaslaQ started — ${AppConfig.signupSource}');
  LocaleSettings.setLocaleRaw(
    WidgetsBinding.instance.platformDispatcher.locale.languageCode == 'en' ? 'en' : 'ar',
  );

  runApp(
    TranslationProvider(
      child: ProviderScope(
        overrides: [
          preferencesProvider.overrideWith((ref) => PreferencesNotifier(initialPrefs)),
        ],
        child: const WaslaqApp(),
      ),
    ),
  );
}

// ─── Stream theme ─────────────────────────────────────────────────────────────

StreamChatThemeData _buildStreamTheme(Brightness brightness) {
  final c = brightness == Brightness.dark ? AppColors.dark : AppColors.light;
  return StreamChatThemeData(
    colorTheme: brightness == Brightness.dark
        ? StreamColorTheme.dark(
            accentPrimary: c.primary,
            barsBg:        c.surface,
            appBg:         c.background,
            inputBg:       c.surfaceVariant,
          )
        : StreamColorTheme.light(
            accentPrimary: c.primary,
            barsBg:        c.surface,
            appBg:         c.background,
            inputBg:       c.surfaceVariant,
          ),
    channelPreviewTheme: StreamChannelPreviewThemeData(
      titleStyle: TextStyle(
          color: c.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
      subtitleStyle: TextStyle(color: c.textSecondary, fontSize: 13),
      unreadCounterColor: c.primary,
    ),
    channelHeaderTheme: StreamChannelHeaderThemeData(
      color: c.surface,
      titleStyle: TextStyle(
          color: c.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
      subtitleStyle: TextStyle(color: c.textSecondary, fontSize: 12),
    ),
    messageInputTheme: StreamMessageInputThemeData(
      inputBackgroundColor: c.surfaceVariant,
      sendAnimationDuration: const Duration(milliseconds: 300),
    ),
    ownMessageTheme: StreamMessageThemeData(
      messageBackgroundColor: c.primary,
      messageTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
    ),
    otherMessageTheme: StreamMessageThemeData(
      messageBackgroundColor: c.surface,
      messageTextStyle: TextStyle(color: c.textPrimary, fontSize: 14),
    ),
  );
}

// ─── App root ─────────────────────────────────────────────────────────────────

class WaslaqApp extends ConsumerWidget {
  const WaslaqApp({super.key});

  /// Applies the selected Arabic font to the theme's text theme.
  /// Called for both light and dark variants whenever prefs change.
  /// Returns the base theme unchanged if font is 'default' and boldText is false.
  static ThemeData _applyFont(
    ThemeData base,
    String arabicFont,
    bool boldText,
    Locale locale,
  ) {
    TextTheme tt = base.textTheme;

    // Determine effective font:
    // — User explicitly chose one → use it
    // — Default: Cairo for Arabic locale, Inter for English locale
    final String effectiveFont = arabicFont != 'default'
        ? arabicFont
        : (locale.languageCode == 'ar' ? 'Cairo' : 'Inter');

    tt = switch (effectiveFont) {
      'Cairo'   => GoogleFonts.cairoTextTheme(tt),
      'Tajawal' => GoogleFonts.tajawalTextTheme(tt),
      'Almarai' => GoogleFonts.almaraiTextTheme(tt),
      'Inter'   => GoogleFonts.interTextTheme(tt),
      _         => tt,
    };

    // Apply bold weight across all styles if boldText is enabled
    if (boldText) {
      tt = tt.copyWith(
        displayLarge:  tt.displayLarge?.copyWith(fontWeight: FontWeight.bold),
        displayMedium: tt.displayMedium?.copyWith(fontWeight: FontWeight.bold),
        displaySmall:  tt.displaySmall?.copyWith(fontWeight: FontWeight.bold),
        headlineLarge: tt.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
        headlineMedium:tt.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        headlineSmall: tt.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        titleLarge:    tt.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        titleMedium:   tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        titleSmall:    tt.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        bodyLarge:     tt.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        bodyMedium:    tt.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        bodySmall:     tt.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        labelLarge:    tt.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        labelMedium:   tt.labelMedium?.copyWith(fontWeight: FontWeight.bold),
        labelSmall:    tt.labelSmall?.copyWith(fontWeight: FontWeight.bold),
      );
    }

    return base.copyWith(textTheme: tt);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router       = ref.watch(appRouterProvider);
    _globalRouter = router; // keep global ref for notification tap navigation
    appLinkRouter = router; // keep global ref for banner/popup deep links
    // Consume any pending deep-link from a notification tap during cold start
    if (_pendingNavLink != null) {
      final link = _pendingNavLink!;
      _pendingNavLink = null;
      Future.delayed(const Duration(milliseconds: 600), () => _navigateToLink(link));
    }
    final streamClient = ref.watch(streamChatClientProvider);
    final themeMode    = ref.watch(themeProvider);
    // ── Watch preferences so the root rebuilds when text scale / font / bold change ──
    final prefs        = ref.watch(preferencesProvider);
    // ── Watch currency: instantiates the provider (runs first-launch IP detection)
    //    and rebuilds the whole tree when the user switches ILS/USD in settings ──
    ref.watch(currencyProvider);

    // Resolve the actual brightness for Stream Chat
    final Brightness resolvedBrightness = switch (themeMode) {
      AppThemeMode.light  => Brightness.light,
      AppThemeMode.dark   => Brightness.dark,
      AppThemeMode.system =>
          WidgetsBinding.instance.platformDispatcher.platformBrightness,
    };

    // Build font- and bold-aware themes (recomputed reactively when prefs change)
    final locale     = ref.watch(localeProvider);
    final lightTheme = _applyFont(AppTheme.light, prefs.arabicFont, prefs.boldText, locale);
    final darkTheme  = _applyFont(AppTheme.dark,  prefs.arabicFont, prefs.boldText, locale);

    return MaterialApp.router(
      title:                    'WaslaQ',
      debugShowCheckedModeBanner: false,
      theme:      lightTheme,
      darkTheme:  darkTheme,
      themeMode: switch (themeMode) {
        AppThemeMode.light  => ThemeMode.light,
        AppThemeMode.system => ThemeMode.system,
        AppThemeMode.dark   => ThemeMode.dark,
      },
      routerConfig: router.config(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar'), Locale('en')],
      locale: locale,
      builder: (context, child) {
        // ── Apply textScaler + boldText via MediaQuery + DefaultTextStyle ──
        // textScaler is universal — every Text widget reads it from MediaQuery.
        // For bold, we use two layers:
        //   1. _applyFont() already sets bold on the theme's textTheme (covers
        //      widgets that use theme-derived styles).
        //   2. DefaultTextStyle.merge() here covers Text widgets that inherit
        //      fontWeight from the ambient DefaultTextStyle (i.e. widgets whose
        //      own style does not explicitly specify fontWeight).
        final mq = MediaQuery.of(context);
        Widget tree = StreamChat(
          client: streamClient,
          streamChatThemeData: _buildStreamTheme(resolvedBrightness),
          child: OfflineBanner(
            child: BiometricGuard(child: child ?? const SizedBox.shrink()),
          ),
        );
        if (prefs.boldText) {
          tree = DefaultTextStyle.merge(
            style: const TextStyle(fontWeight: FontWeight.bold),
            child: tree,
          );
        }
        return MediaQuery(
          data: mq.copyWith(
            textScaler: TextScaler.linear(prefs.textScale),
            boldText:   prefs.boldText,
          ),
          child: tree,
        );
      },
    );
  }
}
