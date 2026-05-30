// lib/core/api/social_client.dart
// Dio client #2 — Social / Prisma API
// Handles: posts, communities, profiles, votes, follows, social token

import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../storage/secure_storage.dart';
import '../error/app_exception.dart';
import '../crashlytics/crash_reporter.dart';

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
