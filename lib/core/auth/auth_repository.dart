import '../api/medusa_client.dart';
import '../storage/secure_storage.dart';
import '../config/app_config.dart';
import '../crashlytics/crash_reporter.dart';

class AuthRepository {
  AuthRepository._();

  // Single auth call — mirrors POST /store/custom/auth-sync
  // Returns full response: { customer, token, username }
  // firstName/lastName are optional — only passed on first sign-up so the
  // backend creates the Medusa customer with the real name instead of "User".
  static Future<Map<String, dynamic>> authSync(
    String firebaseToken, {
    String? firstName,
    String? lastName,
  }) async {
    final response = await MedusaClient.instance.post(
      '/store/custom/auth-sync',
      data: {
        'token': firebaseToken,
        'signup_source': AppConfig.signupSource,
        if (firstName != null && firstName.isNotEmpty) 'first_name': firstName,
        if (lastName != null && lastName.isNotEmpty) 'last_name': lastName,
      },
    );
    final token = response.data['token'] as String;
    await SecureStorage.saveMedusaJwt(token);
    return response.data as Map<String, dynamic>;
  }

  // Fire-and-forget — never awaited in login flow
  static void syncAuthMetadata() async {
    try {
      final token = await SecureStorage.getMedusaJwt();
      if (token == null) return;
      await MedusaClient.instance.post(
        '/store/custom/auth-sync',
        data: {'signup_source': AppConfig.signupSource},
      );
    } catch (e) {
      CrashReporter.reportError(
        e, null,
        reason: 'auth-sync fire-and-forget failed silently',
      );
    }
  }

  // Get current customer profile
  static Future<Map<String, dynamic>> getCustomer() async {
    final response = await MedusaClient.instance.get('/store/customers/me');
    return response.data['customer'] as Map<String, dynamic>;
  }
}
