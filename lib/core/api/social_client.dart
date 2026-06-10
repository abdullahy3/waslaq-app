// lib/core/api/social_client.dart
// Dio client #2 — Social / Prisma API
// Handles: posts, communities, profiles, votes, follows, social token

import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../storage/secure_storage.dart';
import '../error/app_exception.dart';
import '../crashlytics/crash_reporter.dart';
import '../auth/firebase_service.dart';
import '../auth/auth_repository.dart';

class SocialClient {
  SocialClient._();
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
          // Required by Medusa for all /store/* routes
          'x-publishable-api-key': AppConfig.publishableKey,
        },
      ),
    );

    dio.interceptors.add(_SocialAuthInterceptor(dio));
    return dio;
  }
}

class _SocialAuthInterceptor extends QueuedInterceptorsWrapper {
  final Dio dio;
  _SocialAuthInterceptor(this.dio);

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

    CrashReporter.reportError(
      err,
      err.stackTrace,
      reason: 'Social API error $statusCode on $endpoint',
    );

    // Handle 401 token expiration and refresh automatically
    if (statusCode == 401) {
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
            reason: 'Token re-auth via auth-sync failed on SocialClient',
          );
          // Refresh failed — force sign-out flag so the app shows login
          await SecureStorage.setSignedOut();
          await SecureStorage.clearAll();
        }
      }
    }

    // Map timeouts and connection/handshake errors to AppException.network
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
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
