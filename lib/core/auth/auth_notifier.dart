import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'auth_state.dart';
import 'firebase_service.dart';
import 'auth_repository.dart';
import '../storage/secure_storage.dart';
import '../storage/isar_service.dart';
import '../crashlytics/crash_reporter.dart';
import '../api/social_client.dart';
import '../api/medusa_client.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    final sub = FirebaseService.authStateChanges.listen(_onAuthStateChanged);
    ref.onDispose(sub.cancel);
    return const AuthState.initial();
  }

  Future<void> _onAuthStateChanged(User? user) async {
    if (user == null) {
      state = const AuthState.unauthenticated();
      return;
    }
    final isSignedOut = await SecureStorage.isSignedOut();
    if (isSignedOut) {
      await FirebaseService.signOut();
      state = const AuthState.unauthenticated();
      return;
    }
    await _completeLogin(user);
  }

  Future<void> _completeLogin(User user) async {
    try {
      state = const AuthState.loading();

      final firebaseToken =
          await FirebaseService.getIdToken(forceRefresh: true);
      if (firebaseToken == null) throw Exception('Failed to get Firebase token');

      final firstName = _pendingFirstName;
      final lastName = _pendingLastName;
      _pendingFirstName = null;
      _pendingLastName = null;

      final data = await AuthRepository.authSync(
        firebaseToken,
        firstName: firstName,
        lastName: lastName,
      );
      final customer = data['customer'] as Map<String, dynamic>;
      final username = data['username'] as String?;
      final customerId = customer['id'] as String;

      String displayName = '';
      String? avatarUrl;
      try {
        final profileResp = await SocialClient.instance
            .get('/store/social/profiles/$customerId');
        final profile =
            profileResp.data['profile'] as Map<String, dynamic>?;
        displayName = (profile?['displayName'] as String? ?? '').trim();
        // DiceBear: profile stores avatarStyle + avatarSeed, not a raw URL.
        // Use PNG format so CachedNetworkImageProvider can render it.
        final style = profile?['avatarStyle'] as String?;
        final seed = profile?['avatarSeed'] as String?;
        if (style != null) {
          avatarUrl = 'https://api.dicebear.com/9.x/$style/png?seed=${seed ?? customerId}&size=128';
        }
      } catch (_) {}

      if (displayName.isEmpty) {
        final fName = (customer['first_name'] as String? ?? '').trim();
        final lName = (customer['last_name'] as String? ?? '').trim();
        displayName = [fName, lName].where((s) => s.isNotEmpty).join(' ');
      }

      await SecureStorage.clearSignedOutFlag();
      await CrashReporter.setUserId(customerId);
      CrashReporter.log('User authenticated: $customerId');

      state = AuthState.authenticated(
        customerId: customerId,
        email: customer['email'] as String,
        displayName: displayName.isEmpty ? null : displayName,
        avatarUrl: avatarUrl,
        username: username,
      );

      // Register FCM token — fire-and-forget, never blocks login.
      _registerFCMToken();
    } catch (e, stack) {
      CrashReporter.reportError(e, stack, reason: 'Login flow failed');
      try { await FirebaseService.signOut(); } catch (_) {}
      state = AuthState.error('Login failed. Please try again.');
    }
  }

  // ─── FCM token ───────────────────────────────────────────────────────────────

  void _registerFCMToken() async {
    try {
      final messaging = FirebaseMessaging.instance;
      final token = await messaging.getToken();
      if (token != null) await _sendTokenToBackend(token);
      messaging.onTokenRefresh.listen(_sendTokenToBackend);
    } catch (e) {
      CrashReporter.reportError(e, null,
          reason: 'FCM token registration failed');
    }
  }

  Future<void> _sendTokenToBackend(String token) async {
    try {
      await MedusaClient.instance.post(
        '/store/customers/me/fcm-token',
        data: {'token': token, 'action': 'register'},
      );
      debugPrint('[FCM] Token registered');
    } catch (e) {
      debugPrint('[FCM] Token send failed: $e');
    }
  }

  Future<void> _unregisterFCMToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await MedusaClient.instance.post(
          '/store/customers/me/fcm-token',
          data: {'token': token, 'action': 'unregister'},
        );
      }
    } catch (_) {}
  }

  // ─── Auth methods ─────────────────────────────────────────────────────────────

  String? _pendingFirstName;
  String? _pendingLastName;

  Future<void> signInWithEmail(String email, String password) async {
    try {
      state = const AuthState.loading();
      await SecureStorage.clearSignedOutFlag();
      await FirebaseService.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e, stack) {
      CrashReporter.reportError(e, stack, reason: 'Email sign-in failed');
      state = AuthState.error(_friendlyError(e.toString()));
    }
  }

  Future<void> registerWithEmail(
    String email,
    String password, {
    String? firstName,
    String? lastName,
  }) async {
    try {
      state = const AuthState.loading();
      await SecureStorage.clearSignedOutFlag();
      await FirebaseService.createUserWithEmailAndPassword(
          email: email, password: password);
      _pendingFirstName = firstName;
      _pendingLastName = lastName;
    } catch (e, stack) {
      CrashReporter.reportError(e, stack, reason: 'Email registration failed');
      state = AuthState.error(_friendlyError(e.toString()));
    }
  }

  /// Google Sign-In — fires _onAuthStateChanged automatically on success.
  Future<void> signInWithGoogle() async {
    try {
      state = const AuthState.loading();
      // Clear sign-out flag BEFORE Firebase auth fires _onAuthStateChanged,
      // otherwise the listener sees isSignedOut=true and immediately signs out again.
      await SecureStorage.clearSignedOutFlag();
      final credential = await FirebaseService.signInWithGoogle();
      if (credential == null) {
        // User cancelled — go back to unauthenticated without an error.
        state = const AuthState.unauthenticated();
      }
      // On success: Firebase auth state change triggers _onAuthStateChanged → _completeLogin.
    } catch (e, stack) {
      CrashReporter.reportError(e, stack, reason: 'Google sign-in failed');
      state = AuthState.error(_friendlyError(e.toString()));
    }
  }

  String _friendlyError(String raw) {
    if (raw.contains('user-not-found') ||
        raw.contains('wrong-password') ||
        raw.contains('invalid-credential')) {
      return 'Incorrect email or password.';
    }
    if (raw.contains('email-already-in-use')) {
      return 'An account with this email already exists.';
    }
    if (raw.contains('weak-password')) {
      return 'Password must be at least 6 characters.';
    }
    if (raw.contains('network-request-failed')) {
      return 'No internet connection. Please try again.';
    }
    if (raw.contains('sign_in_canceled') || raw.contains('canceled')) {
      return 'Sign-in cancelled.';
    }
    return 'Something went wrong. Please try again.';
  }

  Future<void> signOut() async {
    try {
      await _unregisterFCMToken();
      await SecureStorage.setSignedOut();
      await FirebaseService.signOut();
      await SecureStorage.clearAll();
      await IsarService.clearAll();
      await CrashReporter.clearUserId();
      state = const AuthState.unauthenticated();
    } catch (e, stack) {
      CrashReporter.reportError(e, stack, reason: 'Sign-out failed');
    }
  }

  Future<void> refreshProfile() async {
    await state.maybeWhen(
      authenticated: (customerId, email, displayName, avatarUrl, username) async {
        try {
          final profileResp = await SocialClient.instance
              .get('/store/social/profiles/$customerId');
          final profile =
              profileResp.data['profile'] as Map<String, dynamic>?;
          
          final newDisplayName = (profile?['displayName'] as String? ?? '').trim();
          final style = profile?['avatarStyle'] as String?;
          final seed = profile?['avatarSeed'] as String?;
          String? newAvatarUrl;
          if (style != null) {
            newAvatarUrl = 'https://api.dicebear.com/9.x/$style/png?seed=${seed ?? customerId}&size=128';
          }
          final newUsername = profile?['username'] as String?;

          state = AuthState.authenticated(
            customerId: customerId,
            email: email,
            displayName: newDisplayName.isEmpty ? displayName : newDisplayName,
            avatarUrl: newAvatarUrl ?? avatarUrl,
            username: newUsername ?? username,
          );
        } catch (_) {}
      },
      orElse: () {},
    );
  }
}
