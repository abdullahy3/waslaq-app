// lib/core/crashlytics/crash_reporter.dart

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

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
      return false; // Return false so it is also logged to standard output
    };
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
