// lib/core/storage/secure_storage.dart
// Wrapper around Flutter Secure Storage.
// ONLY tokens and auth flags live here. Never cache data here.

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';

class SecureStorage {
  SecureStorage._();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // Medusa JWT
  static Future<void> saveMedusaJwt(String token) =>
      _storage.write(key: AppConfig.keyMedusaJwt, value: token);

  static Future<String?> getMedusaJwt() =>
      _storage.read(key: AppConfig.keyMedusaJwt);

  static Future<void> deleteMedusaJwt() =>
      _storage.delete(key: AppConfig.keyMedusaJwt);

  // Firebase token
  static Future<void> saveFirebaseToken(String token) =>
      _storage.write(key: AppConfig.keyFirebaseToken, value: token);

  static Future<String?> getFirebaseToken() =>
      _storage.read(key: AppConfig.keyFirebaseToken);

  static Future<void> deleteFirebaseToken() =>
      _storage.delete(key: AppConfig.keyFirebaseToken);

  // Sign-out flag — mirrors web localStorage waslaq_signed_out pattern
  static Future<void> setSignedOut() =>
      _storage.write(key: AppConfig.keySignedOut, value: '1');

  static Future<bool> isSignedOut() async {
    final value = await _storage.read(key: AppConfig.keySignedOut);
    return value == '1';
  }

  static Future<void> clearSignedOutFlag() =>
      _storage.delete(key: AppConfig.keySignedOut);

  // Cart ID — persisted between sessions; cleared by clearAll() on sign-out
  static const String _keyCartId = 'waslaq_cart_id';

  static Future<void> saveCartId(String cartId) =>
      _storage.write(key: _keyCartId, value: cartId);

  static Future<String?> getCartId() =>
      _storage.read(key: _keyCartId);

  static Future<void> deleteCartId() =>
      _storage.delete(key: _keyCartId);

  // Clear everything on sign-out (includes cart ID via deleteAll)
  static Future<void> clearAll() => _storage.deleteAll();
}
