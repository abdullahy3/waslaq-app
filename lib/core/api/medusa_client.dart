// lib/core/api/medusa_client.dart
// Dio client #1 — Medusa commerce API
// Handles: products, cart, orders, vendors, checkout

import 'package:dio/dio.dart';
import 'retry_interceptor.dart';
import '../config/app_config.dart';
import '../storage/secure_storage.dart';
import '../error/app_exception.dart';
import '../crashlytics/crash_reporter.dart';
import '../auth/firebase_service.dart';
import '../auth/auth_repository.dart';

class MedusaClient {
  MedusaClient._();
  static Dio? _dio;

  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBase,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'x-publishable-api-key': AppConfig.publishableKey,
          'x-signup-source': AppConfig.signupSource,
        },
      ),
    );

    // Parse JSON off the main isolate for large payloads — keeps scrolling
    // smooth on mid-range devices while big feed/product responses decode.
    dio.transformer = BackgroundTransformer();
    dio.interceptors.add(_AuthInterceptor(dio));
    // Retries flaky-network GETs (2x with backoff) — poor-3G resilience.
    dio.interceptors.add(RetryInterceptor(dio));
    return dio;
  }
}

class _AuthInterceptor extends QueuedInterceptorsWrapper {
  final Dio dio;
  _AuthInterceptor(this.dio);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStorage.getMedusaJwt();
    if (token != null && !options.headers.containsKey('Authorization')) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final endpoint = err.requestOptions.path;

    // Report all errors to Crashlytics as non-fatal
    CrashReporter.reportError(
      err,
      err.stackTrace,
      reason: 'Medusa API error $statusCode on $endpoint',
    );

    // Handle 401 — WaslaQ tokens are custom JWTs from auth-sync, NOT Medusa
    // built-in tokens. They cannot be refreshed via /auth/token/refresh.
    // Correct fix: get a fresh Firebase token and re-call auth-sync.
    // Firebase silently refreshes its own token if expired.
    if (statusCode == 401) {
      // Don't retry the auth-sync endpoint itself — infinite loop risk
      final isAuthSyncCall = endpoint.contains('/store/custom/auth-sync');
      if (!isAuthSyncCall) {
        try {
          final freshFirebaseToken = await FirebaseService.getIdToken(forceRefresh: true);
          if (freshFirebaseToken != null) {
            await AuthRepository.authSync(freshFirebaseToken);
            // New Medusa JWT is now in SecureStorage — retry original request
            final newToken = await SecureStorage.getMedusaJwt();
            if (newToken != null) {
              err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
              final retryResponse = await dio.fetch(err.requestOptions);
              handler.resolve(retryResponse);
              return;
            }
          }
        } catch (refreshError) {
          CrashReporter.reportError(
            refreshError, null,
            reason: 'Token re-auth via auth-sync failed',
          );
          // Refresh failed — force sign-out flag so the app shows login
          await SecureStorage.setSignedOut();
          await SecureStorage.clearAll();
        }
      }
    }

    // Map to AppException
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.unknown) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: AppException.network(endpoint),
        ),
      );
      return;
    }

    handler.next(err);
  }
}
