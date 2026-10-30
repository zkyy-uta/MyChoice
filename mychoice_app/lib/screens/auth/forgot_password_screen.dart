import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mychoice_app/core/theme/app_colors.dart';
import 'package:mychoice_app/core/theme/app_spacing.dart';
import 'package:mychoice_app/core/theme/app_typography.dart';
import 'package:mychoice_app/core/validators/validation_rules.dart';
import 'package:mychoice_app/core/widgets/mobile_background.dart';
import 'package:mychoice_app/features/auth/presentation/providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSending = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSending = true;
      _error = null;
    });

    final auth = context.read<AuthProvider>();
    await auth.requestPasswordReset(_emailController.text);
    if (!mounted) return;

    setState(() {
      _error = auth.error;
    });
    if (auth.error == null) {
      Navigator.of(context).pushReplacementNamed(
        '/verify-reset-code',
        arguments: _emailController.text.trim(),
      );
    } else {
      setState(() => _isSending = false);
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
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.arrow_back),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Reset Password', style: AppTypography.screenTitle),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Masukkan email akunmu. Jika terdaftar, kami akan '
                        'mengirim kode verifikasi untuk membuat password baru '
                        'di aplikasi.',
                        style: AppTypography.body,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      TextFormField(
                        key: const Key('reset-email'),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.email],
                        decoration: const InputDecoration(hintText: 'Email'),
                        validator: validateEmail,
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          _error!,
                          style: const TextStyle(color: AppColors.error80),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xxl),
                      SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _isSending ? null : _sendResetCode,
                          child: _isSending
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              : Text(
                                  'Kirim kode reset',
                                  style: AppTypography.buttonLarge,
                                ),
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
