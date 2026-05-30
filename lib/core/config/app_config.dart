// lib/core/config/app_config.dart
// Central configuration — all constants live here, never hardcoded elsewhere

class AppConfig {
  AppConfig._();

  // API
  static const String apiBase = 'https://api.waslaq.com';
  static const String publishableKey =
      'pk_ae810b33651758a40a3f5a2529907c64d3aab6e7901d554ea4c5c8b8541b7186';

  // Region & Sales
  static const String palestineRegionId = 'reg_01KQ6035AK6FMA4R1XJ76RTPGH';
  static const String salesChannelId = 'sc_01KQ55NZ08QD91FMGV9R5B4J0E';

  // Media
  static const String r2BaseUrl =
      'https://pub-ebcd06c597a740369ba289992469fd1b.r2.dev';

  // GetStream
  static const String streamAppId = 'my-feeds';
  static const String streamApiKey = 'jdmvrqw4w4e3';

  // Auth
  static const String signupSource = 'mobile_flutter';
  // Google Sign-In — web client ID (client_type: 3 from google-services.json)
  // Required so GoogleSignIn returns a non-null idToken on Android
  static const String googleWebClientId =
      '450878894389-419iacavp62964ql7n6jehddntfrqp2m.apps.googleusercontent.com';

  // Secure storage keys
  static const String keyMedusaJwt = 'medusa_jwt';
  static const String keyFirebaseToken = 'firebase_id_token';
  static const String keySignedOut = 'waslaq_signed_out';
}
