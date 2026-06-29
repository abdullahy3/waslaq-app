// lib/core/error/error_localizer.dart
// Single source of truth: any thrown object → friendly localized message.
// UI must NEVER show raw e.toString() — always pass errors through here.

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../i18n/strings.g.dart';
import 'app_exception.dart';

String localizeError(Object? error) {
  // Dio wraps our AppException inside DioException.error — unwrap first
  final e = (error is DioException && error.error != null) ? error.error : error;

  if (e is AppException) {
    final code = e.statusCode;
    if (code == null) return t.errors.network;
    return _fromStatus(code);
  }

  if (e is DioException) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return t.errors.timeout;
      case DioExceptionType.connectionError:
        return t.errors.network;
      case DioExceptionType.badResponse:
        return _fromStatus(e.response?.statusCode);
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return t.errors.unknown;
    }
  }

  if (e is SocketException) return t.errors.network;
  if (e is TimeoutException) return t.errors.timeout;

  return t.errors.unknown;
}

String _fromStatus(int? code) {
  if (code == null) return t.errors.unknown;
  if (code == 401 || code == 403) return t.errors.unauthorized;
  if (code == 404) return t.errors.not_found;
  if (code == 429) return t.errors.rate_limited;
  if (code == 422 || code == 400) return t.errors.validation;
  if (code >= 500) return t.errors.server;
  return t.errors.unknown;
}
