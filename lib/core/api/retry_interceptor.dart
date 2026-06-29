// lib/core/api/retry_interceptor.dart
// Retries idempotent GET requests that fail from flaky connectivity
// (timeouts / connection resets) — critical UX on poor 3G networks.
// POST/PUT/DELETE are never retried (not idempotent).

import 'dart:async';

import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final List<Duration> backoff;

  RetryInterceptor(
    this.dio, {
    this.maxRetries = 2,
    this.backoff = const [Duration(milliseconds: 600), Duration(seconds: 2)],
  });

  bool _shouldRetry(DioException err) {
    if (err.requestOptions.method.toUpperCase() != 'GET') return false;
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      default:
        return false;
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final attempt = (err.requestOptions.extra['retry_attempt'] as int?) ?? 0;
    if (!_shouldRetry(err) || attempt >= maxRetries) {
      handler.next(err);
      return;
    }

    await Future.delayed(backoff[attempt.clamp(0, backoff.length - 1)]);

    final options = err.requestOptions;
    options.extra['retry_attempt'] = attempt + 1;
    try {
      final response = await dio.fetch(options);
      handler.resolve(response);
    } on DioException catch (retryErr) {
      handler.next(retryErr);
    }
  }
}
