// lib/core/error/app_exception.dart

class AppException implements Exception {
  final String message;
  final int? statusCode;
  final String? endpoint;

  const AppException({
    required this.message,
    this.statusCode,
    this.endpoint,
  });

  @override
  String toString() =>
      'AppException($statusCode): $message [endpoint: $endpoint]';

  // Named constructors for common cases
  factory AppException.network(String endpoint) => AppException(
        message: 'Network error — check your connection',
        endpoint: endpoint,
      );

  factory AppException.unauthorized() => const AppException(
        message: 'Session expired — please sign in again',
        statusCode: 401,
      );

  factory AppException.notFound(String endpoint) => AppException(
        message: 'Resource not found',
        statusCode: 404,
        endpoint: endpoint,
      );

  factory AppException.server(int code, String endpoint) => AppException(
        message: 'Server error — please try again',
        statusCode: code,
        endpoint: endpoint,
      );
}
