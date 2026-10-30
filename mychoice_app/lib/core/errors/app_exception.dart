/// Base exception class for all app exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Validation error for invalid input data
class ValidationError extends AppException {
  ValidationError({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         code: code ?? 'VALIDATION_ERROR',
         originalError: originalError,
         stackTrace: stackTrace,
       );

  @override
  String toString() => 'ValidationError: $message';
}

/// Authentication-related errors
class AuthenticationError extends AppException {
  AuthenticationError({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         code: code ?? 'AUTHENTICATION_ERROR',
         originalError: originalError,
         stackTrace: stackTrace,
       );

  @override
  String toString() => 'AuthenticationError: $message';
}

/// Authorization-related errors (user lacks permission)
class AuthorizationError extends AppException {
  AuthorizationError({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         code: code ?? 'AUTHORIZATION_ERROR',
         originalError: originalError,
         stackTrace: stackTrace,
       );

  @override
  String toString() => 'AuthorizationError: $message';
}

/// Calculation-related errors
class CalculationError extends AppException {
  CalculationError({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         code: code ?? 'CALCULATION_ERROR',
         originalError: originalError,
         stackTrace: stackTrace,
       );

  @override
  String toString() => 'CalculationError: $message';
}

/// Missing required data error
class DataMissingError extends AppException {
  DataMissingError({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         code: code ?? 'DATA_MISSING_ERROR',
         originalError: originalError,
         stackTrace: stackTrace,
       );

  @override
  String toString() => 'DataMissingError: $message';
}

/// Network-related errors
class NetworkError extends AppException {
  NetworkError({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         code: code ?? 'NETWORK_ERROR',
         originalError: originalError,
         stackTrace: stackTrace,
       );

  @override
  String toString() => 'NetworkError: $message';
}

/// Timeout error
class TimeoutError extends AppException {
  TimeoutError({
    required String message,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         code: code ?? 'TIMEOUT_ERROR',
         originalError: originalError,
         stackTrace: stackTrace,
       );

  @override
  String toString() => 'TimeoutError: $message';
}

/// Plan limit exceeded error
class PlanLimitExceededException extends AppException {
  final String? feature;
  final int limit;
  final int attempted;

  PlanLimitExceededException({
    required String message,
    this.feature,
    required this.limit,
    required this.attempted,
    String? code,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(
         message: message,
         code: code ?? 'PLAN_LIMIT_EXCEEDED',
         originalError: originalError,
         stackTrace: stackTrace,
       );

  @override
  String toString() =>
      'PlanLimitExceededException: $message (Limit: $limit, Attempted: $attempted)';
}
