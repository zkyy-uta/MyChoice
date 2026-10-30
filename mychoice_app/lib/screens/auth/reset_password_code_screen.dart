import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:mychoice_app/core/theme/app_colors.dart';
import 'package:mychoice_app/core/theme/app_spacing.dart';
import 'package:mychoice_app/core/theme/app_typography.dart';
import 'package:mychoice_app/core/widgets/mobile_background.dart';
import 'package:mychoice_app/features/auth/presentation/providers/auth_provider.dart';

class ResetPasswordCodeScreen extends StatefulWidget {
  const ResetPasswordCodeScreen({super.key, required this.email});

  final String email;

  @override
  State<ResetPasswordCodeScreen> createState() =>
      _ResetPasswordCodeScreenState();
}

class _ResetPasswordCodeScreenState extends State<ResetPasswordCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  bool _isVerifying = false;
  bool _isResending = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isVerifying = true;
      _error = null;
    });

    final auth = context.read<AuthProvider>();
    await auth.verifyPasswordResetCode(widget.email, _codeController.text);
    if (!mounted) return;

    if (auth.error == null) {
      Navigator.of(context).pushReplacementNamed('/reset-password');
      return;
    }

    setState(() {
      _isVerifying = false;
      _error = auth.error;
    });
  }

  Future<void> _resendCode() async {
    setState(() {
      _isResending = true;
      _error = null;
    });

    final auth = context.read<AuthProvider>();
    await auth.requestPasswordReset(widget.email);
    if (!mounted) return;

    setState(() {
      _isResending = false;
      _error = auth.error;
    });
    if (auth.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode reset baru sudah dikirim.')),
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
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.arrow_back),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Masukkan Kode Reset',
                        style: AppTypography.screenTitle,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Kode 8 digit dikirim ke ${widget.email}. Masukkan '
                        'kode tersebut untuk melanjutkan.',
                        style: AppTypography.body,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      TextFormField(
                        key: const Key('reset-code'),
                        controller: _codeController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(8),
                        ],
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          hintText: 'Kode verifikasi',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length != 8) {
                            return 'Masukkan kode 8 digit dari email';
                          }
                          return null;
                        },
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
                          onPressed: _isVerifying || _isResending
                              ? null
                              : _verifyCode,
                          child: _isVerifying
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              : Text(
                                  'Verifikasi kode',
                                  style: AppTypography.buttonLarge,
                                ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextButton(
                        onPressed: _isVerifying || _isResending
                            ? null
                            : _resendCode,
                        child: _isResending
                            ? const Text('Mengirim ulang kode...')
                            : const Text('Kirim ulang kode'),
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
