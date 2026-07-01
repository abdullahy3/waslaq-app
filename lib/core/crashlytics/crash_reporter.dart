// lib/core/crashlytics/crash_reporter.dart

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

class CrashReporter {
  CrashReporter._();

  static Future<void> initialize() async {
    // Disable Crashlytics in debug mode
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(!kDebugMode);

    // Catch all uncaught Flutter framework errors
    FlutterError.onError = (details) {
      debugPrint('🚨 FLUTTER ERROR: ${details.exception}\n${details.stack}');
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      _bridgeToPostHog(details.exception.toString());
    };

    // Catch uncaught async errors outside Flutter framework
    PlatformDispatcher.instance.onError = (error, stack) {
      debugPrint('🚨 UNCAUGHT ASYNC ERROR: $error\n$stack');
      // Routine connectivity drops (Stream Chat websocket, sockets, timeouts
      // on flaky 3G) are expected churn — record as non-fatal so Crashlytics
      // fatal stats stay meaningful.
      final s = error.toString();
      final isNetworkNoise = s.contains('SocketException') ||
          s.contains('WebSocketChannelException') ||
          s.contains('TimeoutException') ||
          s.contains('HandshakeException');
      FirebaseCrashlytics.instance
          .recordError(error, stack, fatal: !isNetworkNoise);
      if (!isNetworkNoise) _bridgeToPostHog(s);
      return false; // Return false so it is also logged to standard output
    };
  }

  // Mirror crashes into PostHog — Crashlytics stays the source of truth for
  // the crash itself, this only lets error-rate alerts and rage-click signals
  // in PostHog line up with app crashes. Mobile has no Sentry, so this is the
  // only crash↔replay bridge on the app side.
  static void _bridgeToPostHog(String message) {
    if (kDebugMode) return;
    Posthog().capture(
      eventName: r'$exception_bridge',
      properties: {'message': message, 'source': 'crashlytics'},
    );
  }

  // Report non-fatal errors (network failures, API errors, etc.)
  static void reportError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
  }) {
    if (kDebugMode) {
      // In debug mode just print — do not send to Crashlytics
      debugPrint('🔴 Error: $exception\nReason: $reason\n$stack');
      return;
    }
    FirebaseCrashlytics.instance.recordError(
      exception,
      stack,
      reason: reason,
      fatal: fatal,
    );
  }

  // Attach user ID after login so crashes are tied to a customer
  static Future<void> setUserId(String customerId) async {
    await FirebaseCrashlytics.instance.setUserIdentifier(customerId);
  }

  // Clear user ID on sign-out
  static Future<void> clearUserId() async {
    await FirebaseCrashlytics.instance.setUserIdentifier('');
  }

  // Add key-value context to crash reports
  static Future<void> log(String message) async {
    await FirebaseCrashlytics.instance.log(message);
  }
}
