import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../config/app_config.dart';
import '../crashlytics/crash_reporter.dart';

class FirebaseService {
  FirebaseService._();

  static final _auth = FirebaseAuth.instance;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();
  static User? get currentUser => _auth.currentUser;

  /// No-op — kept so main.dart call doesn't need to change.
  static Future<void> initializeGoogleSignIn() async {}

  static Future<String?> getIdToken({bool forceRefresh = false}) async {
    try {
      return await _auth.currentUser?.getIdToken(forceRefresh);
    } catch (e, stack) {
      CrashReporter.reportError(e, stack, reason: 'getIdToken failed');
      return null;
    }
  }

  static Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  static Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  // google_sign_in v7.x: use constructor with serverClientId (not the singleton).
  // serverClientId is required so authentication.idToken is non-null on Android.
  static final _googleSignIn = GoogleSignIn(
    serverClientId: AppConfig.googleWebClientId,
    scopes: ['email', 'profile'],
  );

  /// Sign in with Google. Returns null if the user cancelled.
  /// Requires SHA-1 in Firebase Console + valid google-services.json.
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Show Google account picker
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) return null; // user cancelled

      // Get auth tokens — idToken requires serverClientId to be set
      final GoogleSignInAuthentication auth = await account.authentication;

      // idToken null = SHA-1 missing from Firebase or serverClientId wrong
      if (auth.idToken == null) {
        throw FirebaseAuthException(
          code: 'google-idtoken-null',
          message:
              'Google idToken is null. Check SHA-1 in Firebase Console '
              'and re-download google-services.json.',
        );
      }

      // google_sign_in v6: idToken + accessToken both available
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
        accessToken: auth.accessToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'canceled' || e.code == 'user-cancelled') return null;
      CrashReporter.reportError(e, null,
          reason: 'Google sign-in FirebaseAuthException: ${e.code}');
      rethrow;
    } catch (e, stack) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('cancel') ||
          msg.contains('sign_in_cancelled') ||
          msg.contains('dismissed')) {
        return null;
      }
      CrashReporter.reportError(e, stack, reason: 'Google sign-in unexpected error');
      rethrow;
    }
  }

  static Future<void> signOut() async {
    try { await _googleSignIn.signOut(); } catch (_) {}
    await _auth.signOut();
  }

  static Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
