import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';

/// Dialog displayed when unauthenticated user tries to access protected features
class AuthenticationGateDialog extends StatelessWidget {
  final String? message;
  final String? title;
  final VoidCallback? onSignIn;
  final VoidCallback? onSignUp;
  final VoidCallback? onCancel;

  const AuthenticationGateDialog({
    super.key,
    this.message,
    this.title,
    this.onSignIn,
    this.onSignUp,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLarge),
      ),
      title: Text(
        title ?? 'Sign In Required',
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: Text(
        message ?? 'Sign in to create decisions and save your progress',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
      ),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onCancel?.call();
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        // Sign In Button
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.primary88),
          onPressed: () {
            Navigator.pop(context);
            onSignIn?.call();
          },
          child: const Text('Sign In'),
        ),
        // Sign Up Button
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.success80),
          onPressed: () {
            Navigator.pop(context);
            onSignUp?.call();
          },
          child: const Text('Create Account'),
        ),
      ],
    );
  }

  /// Show the dialog
  static Future<T?> show<T>(
    BuildContext context, {
    String? message,
    String? title,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AuthenticationGateDialog(
        message: message,
        title: title,
        onSignIn: () {
          Navigator.of(context).pushNamed('/login');
        },
        onSignUp: () {
          Navigator.of(context).pushNamed('/register');
        },
      ),
    );
  }
}


