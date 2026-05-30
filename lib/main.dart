import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'core/auth/firebase_service.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'i18n/strings.g.dart';
import 'core/config/app_config.dart';
import 'core/crashlytics/crash_reporter.dart';
import 'features/messages/providers/stream_chat_provider.dart';
import 'router/app_router.dart';
import 'shared/theme/app_colors.dart';
import 'shared/theme/app_theme.dart';

// ─── Notification channel ────────────────────────────────────────────────────
const AndroidNotificationChannel _channel = AndroidNotificationChannel(
  'waslaq_messages',
  'WaslaQ Messages',
  description: 'Notifications for new messages',
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin _localNotifications =
    FlutterLocalNotificationsPlugin();

// Shows a local notification from a RemoteMessage (used for both foreground
// and background/data-only messages from GetStream).
Future<void> _showLocalNotification(RemoteMessage message) async {
  final data = message.data;

  // GetStream sends data-only messages — extract meaningful content.
  // Try notification field first (if GetStream includes it), then data map.
  final String title = message.notification?.title ??
      ((data['sender_name'] as String?)?.isNotEmpty == true
          ? data['sender_name'] as String
          : 'New Message');
  final String body = message.notification?.body ??
      ((data['message_text'] as String?)?.isNotEmpty == true
          ? data['message_text'] as String
          : 'You have a new message on WaslaQ');

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
        icon: '@mipmap/ic_launcher',
        playSound: true,
      ),
    ),
  );
}

// ─── Background FCM handler (top-level, runs in separate isolate) ─────────────
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Must reinitialize flutter_local_notifications in background isolate.
  await _localNotifications.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
  );
  final androidPlugin = _localNotifications
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  await androidPlugin?.createNotificationChannel(_channel);
  await _showLocalNotification(message);
}

// ─── FCM initialization ───────────────────────────────────────────────────────
Future<void> _initFCM() async {
  // Initialize local notifications plugin
  await _localNotifications.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
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
  });

  FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
  final initial = await messaging.getInitialMessage();
  if (initial != null) _handleNotificationTap(initial);
}

void _handleNotificationTap(RemoteMessage message) {
  debugPrint('[FCM] Tap: ${message.data}');
}

final fcmMessageBus = _FCMBus();

class _FCMBus {
  final _listeners = <void Function(RemoteMessage)>[];
  void notify(RemoteMessage m) { for (final l in _listeners) l(m); }
  void listen(void Function(RemoteMessage) l) => _listeners.add(l);
}

// ─── Entry point ──────────────────────────────────────────────────────────────

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CrashReporter.initialize();
  await FirebaseService.initializeGoogleSignIn();
  await _initFCM();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  CrashReporter.log('WaslaQ started — ${AppConfig.signupSource}');
  LocaleSettings.setLocaleRaw(
    WidgetsBinding.instance.platformDispatcher.locale.languageCode == 'en' ? 'en' : 'ar',
  );
  runApp(TranslationProvider(child: const ProviderScope(child: WaslaqApp())));
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router       = ref.watch(appRouterProvider);
    final streamClient = ref.watch(streamChatClientProvider);
    final themeMode    = ref.watch(themeProvider);

    // Resolve the actual brightness for Stream Chat
    final Brightness resolvedBrightness = switch (themeMode) {
      AppThemeMode.light  => Brightness.light,
      AppThemeMode.dark   => Brightness.dark,
      AppThemeMode.system =>
          WidgetsBinding.instance.platformDispatcher.platformBrightness,
    };

    return MaterialApp.router(
      title:                    'WaslaQ',
      debugShowCheckedModeBanner: false,
      theme:      AppTheme.light,
      darkTheme:  AppTheme.dark,
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
      locale: ref.watch(localeProvider),
      builder: (context, child) => StreamChat(
        client: streamClient,
        streamChatThemeData: _buildStreamTheme(resolvedBrightness),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
