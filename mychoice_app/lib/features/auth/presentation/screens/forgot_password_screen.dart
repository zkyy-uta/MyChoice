import 'package:flutter/material.dart';
import '../widgets/email_field.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/animated_gradient_background.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController _emailController;
  bool _emailValid = false;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendReset() {
    // Simulate sending reset email
    setState(() {
      _submitted = true;
    });

    // Show snack bar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password reset link sent to your email'),
        duration: Duration(seconds: 3),
      ),
    );

    // Navigate back to login after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // Header
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reset Password',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          'Enter your email address and we\'ll send you a link to reset your password',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSpacing.lg),

                  if (!_submitted)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email Field
                        Text(
                          'Email Address',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        EmailField(
                          controller: _emailController,
                          hint: 'Enter your email',
                          onChanged: (value) {
                            setState(() {
                              _emailValid = value.isNotEmpty;
                            });
                          },
                        ),

                        SizedBox(height: AppSpacing.lg),

                        // Send Reset Link Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _emailValid ? _handleSendReset : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary88,
                              disabledBackgroundColor: Colors.grey[300],
                              padding: EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.cardRadiusLarge,
                                ),
                              ),
                            ),
                            child: Text(
                              'Send Reset Link',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        // Success Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green[600],
                            size: 50,
                          ),
                        ),

                        SizedBox(height: AppSpacing.lg),

                        // Success Message
                        Text(
                          'Check Your Email',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                        ),

                        SizedBox(height: AppSpacing.md),

                        Text(
                          'We\'ve sent a password reset link to ${_emailController.text}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),

                        SizedBox(height: AppSpacing.lg),

                        Text(
                          'Click the link in the email to create a new password.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textTertiary),
                        ),

                        SizedBox(height: AppSpacing.xl),

                        // Back to Login Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login',
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary88,
                              padding: EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.cardRadiusLarge,
                                ),
                              ),
                            ),
                            child: Text(
                              'Back to Login',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


