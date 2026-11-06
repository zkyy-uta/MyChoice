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
    required super.message,
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(code: code ?? 'VALIDATION_ERROR');

  @override
  String toString() => 'ValidationError: $message';
}

/// Authentication-related errors
class AuthenticationError extends AppException {
  AuthenticationError({
    required super.message,
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(code: code ?? 'AUTHENTICATION_ERROR');

  @override
  String toString() => 'AuthenticationError: $message';
}

/// Authorization-related errors (user lacks permission)
class AuthorizationError extends AppException {
  AuthorizationError({
    required super.message,
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(code: code ?? 'AUTHORIZATION_ERROR');

  @override
  String toString() => 'AuthorizationError: $message';
}

/// Calculation-related errors
class CalculationError extends AppException {
  CalculationError({
    required super.message,
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(code: code ?? 'CALCULATION_ERROR');

  @override
  String toString() => 'CalculationError: $message';
}

/// Missing required data error
class DataMissingError extends AppException {
  DataMissingError({
    required super.message,
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(code: code ?? 'DATA_MISSING_ERROR');

  @override
  String toString() => 'DataMissingError: $message';
}

/// Network-related errors
class NetworkError extends AppException {
  NetworkError({
    required super.message,
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(code: code ?? 'NETWORK_ERROR');

  @override
  String toString() => 'NetworkError: $message';
}

/// Timeout error
class TimeoutError extends AppException {
  TimeoutError({
    required super.message,
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(code: code ?? 'TIMEOUT_ERROR');

  @override
  String toString() => 'TimeoutError: $message';
}

/// Plan limit exceeded error
class PlanLimitExceededException extends AppException {
  final String? feature;
  final int limit;
  final int attempted;

  PlanLimitExceededException({
    required super.message,
    this.feature,
    required this.limit,
    required this.attempted,
    String? code,
    super.originalError,
    super.stackTrace,
  }) : super(code: code ?? 'PLAN_LIMIT_EXCEEDED');

  @override
  String toString() =>
      'PlanLimitExceededException: $message (Limit: $limit, Attempted: $attempted)';
}
