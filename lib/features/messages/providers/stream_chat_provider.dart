// lib/features/messages/providers/stream_chat_provider.dart
// Manages StreamChatClient lifecycle — connect on login, disconnect on logout.
//
// CRITICAL: Chat token endpoint is /store/customers/me/stream-token
//           (NOT /store/social/token — that one is for activity feeds)
//           user_id returned is "customer_${customerId}" — with prefix.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../../../core/api/medusa_client.dart';
import '../../../core/auth/auth_notifier.dart';
import '../../../core/config/app_config.dart';

part 'stream_chat_provider.g.dart';

/// Singleton StreamChatClient. Lives as long as the app.
/// keepAlive: true — never auto-disposed between screen navigations.
@Riverpod(keepAlive: true)
StreamChatClient streamChatClient(Ref ref) {
  final client = StreamChatClient(
    AppConfig.streamApiKey,
    logLevel: Level.OFF,
  );
  ref.onDispose(() async {
    if (client.state.currentUser != null) {
      await client.disconnectUser();
    }
    client.dispose();
  });
  return client;
}

/// Manages the connection state.
/// Re-runs whenever auth state changes — connects or disconnects accordingly.
@riverpod
class StreamChatConnection extends _$StreamChatConnection {
  @override
  Future<bool> build() async {
    final client = ref.read(streamChatClientProvider);
    final authState = ref.watch(authNotifierProvider);

    return authState.maybeWhen(
      authenticated: (customerId, email, displayName, avatarUrl, username) async {
        // Already connected as same user — skip
        if (client.state.currentUser?.id == 'customer_$customerId') {
          return true;
        }

        // Disconnect stale connection first
        if (client.state.currentUser != null) {
          await client.disconnectUser();
        }

        // Fetch chat token from backend — chat uses different endpoint than social feed
        final dio = MedusaClient.instance;
        final response = await dio.get('/store/customers/me/stream-token');
        final token = response.data['token'] as String;
        final userId = response.data['user_id'] as String; // "customer_xxx"

        final streamName = displayName?.isNotEmpty == true
            ? displayName!
            : (username?.isNotEmpty == true ? username! : email);

        await client.connectUser(
          User(
            id: userId,
            name: streamName,
            image: avatarUrl,
            extraData: const {},
          ),
          token,
        );

        // Force-update the user profile in Stream so cached stale names are corrected.
        try {
          await client.updateUser(User(
            id: userId,
            name: streamName,
            image: avatarUrl,
          ));
        } catch (_) {}

        // ── Register FCM token with GetStream ─────────────────────────
        // Without this, GetStream cannot deliver push notifications to this device.
        // Must be called AFTER connectUser() succeeds.
        try {
          final fcmToken = await FirebaseMessaging.instance.getToken();
          if (fcmToken != null) {
            await client.addDevice(
              fcmToken,
              PushProvider.firebase,
              pushProviderName: 'waslaq',
            );
          }
          // Re-register if Firebase rotates the token
          FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
            try {
              await client.addDevice(
                newToken,
                PushProvider.firebase,
                pushProviderName: 'waslaq',
              );
            } catch (e) {
              debugPrint('[FCM] Token refresh registration failed: $e');
            }
          });
        } catch (e) {
          // Non-fatal — chat still works without push notifications
          debugPrint('[FCM] GetStream device registration failed: $e');
        }

        return true;
      },
      orElse: () async {
        if (client.state.currentUser != null) {
          await client.disconnectUser();
        }
        return false;
      },
    );
  }
}
