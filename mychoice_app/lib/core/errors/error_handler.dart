import 'package:flutter/material.dart';
import 'app_exception.dart';

/// Error Handler utility for consistent error message handling
class ErrorHandler {
  ErrorHandler._();

  /// Get user-friendly error message from exception
  static String getUserFriendlyMessage(dynamic exception) {
    if (exception is ValidationError) {
      return exception.message;
    } else if (exception is AuthenticationError) {
      return 'Invalid credentials. Please check your email and password.';
    } else if (exception is AuthorizationError) {
      return 'You do not have permission to access this feature.';
    } else if (exception is CalculationError) {
      return 'An error occurred during calculation. Please try again.';
    } else if (exception is DataMissingError) {
      return exception.message;
    } else if (exception is NetworkError) {
      return 'Network error. Please check your internet connection.';
    } else if (exception is TimeoutError) {
      return 'Request timed out. Please try again.';
    } else if (exception is PlanLimitExceededException) {
      return 'You have reached the limit for this feature. Please upgrade your plan.';
    } else if (exception is AppException) {
      return exception.message;
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Handle error and display dialog
  static Future<void> handleError(
    BuildContext context,
    dynamic exception, {
    String? title,
    VoidCallback? onRetry,
  }) async {
    final message = getUserFriendlyMessage(exception);

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(title ?? 'Error'),
          content: Text(message),
          actions: [
            if (onRetry != null)
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  onRetry();
                },
                child: const Text('Retry'),
              ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Log error for debugging
  static void logError(
    dynamic exception, {
    String? tag,
    StackTrace? stackTrace,
  }) {
    final prefix = tag != null ? '[$tag]' : '[Error]';
    print('$prefix $exception');
    if (stackTrace != null) {
      print(stackTrace);
    }
  }
}
