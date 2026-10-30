import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mychoice_app/core/theme/app_colors.dart';
import 'package:mychoice_app/core/theme/app_spacing.dart';
import 'package:mychoice_app/core/theme/app_typography.dart';
import 'package:mychoice_app/core/validators/validation_rules.dart';
import 'package:mychoice_app/core/widgets/mobile_background.dart';
import 'package:mychoice_app/features/auth/presentation/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    await auth.login(_emailController.text, _passwordController.text);
    if (!mounted) return;

    if (auth.isAuthenticated) {
      final destination = auth.user!.isAdmin ? '/admin' : '/dashboard';
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(destination, (route) => false);
    } else if (auth.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error!),
          backgroundColor: AppColors.error80,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileBackground(
        child: SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: AppSpacing.xxl),
              padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => Navigator.of(
                            context,
                          ).pushReplacementNamed('/guest-home'),
                          icon: const Icon(Icons.arrow_back),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Sign in to your\nAccount',
                        style: AppTypography.screenTitle,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Masuk dengan email dan password. Akses user atau admin '
                        'ditentukan dari peran akun.',
                        style: AppTypography.body,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      TextFormField(
                        key: const Key('login-email'),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.username],
                        decoration: const InputDecoration(hintText: 'Email'),
                        validator: validateEmail,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        key: const Key('login-password'),
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        autofillHints: const [AutofillHints.password],
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Password wajib diisi'
                            : null,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.of(
                            context,
                          ).pushNamed('/forgot-password'),
                          child: const Text('Lupa password?'),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Consumer<AuthProvider>(
                        builder: (context, auth, _) {
                          final isLoading =
                              auth.state == AuthState.loading ||
                              auth.state == AuthState.initial;
                          return SizedBox(
                            height: 54,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _handleLogin,
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    )
                                  : Text(
                                      'Log In',
                                      style: AppTypography.buttonLarge,
                                    ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                            ),
                            child: Text('Or', style: AppTypography.small),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Consumer<AuthProvider>(
                        builder: (context, auth, _) {
                          final isBusy =
                              auth.state == AuthState.loading ||
                              auth.state == AuthState.initial;
                          return SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              key: const Key('continue-with-google'),
                              onPressed: isBusy
                                  ? null
                                  : () async {
                                      await auth.signInWithGoogle();
                                      if (!context.mounted ||
                                          auth.error == null) {
                                        return;
                                      }
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text(auth.error!)),
                                      );
                                    },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.textPrimary,
                                side: const BorderSide(
                                  color: AppColors.grey200,
                                ),
                                shape: const StadiumBorder(),
                              ),
                              child: auth.state == AuthState.loading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'G',
                                          style: TextStyle(
                                            color: Color(0xFF4285F4),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: AppSpacing.sm),
                                        Text(
                                          'Continue with Google',
                                          style: AppTypography.smallSemibold,
                                        ),
                                      ],
                                    ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Center(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: AppTypography.body,
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context).pushNamed('/register'),
                              child: Text(
                                'Sign Up',
                                style: AppTypography.buttonMedium.copyWith(
                                  color: AppColors.info80,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
