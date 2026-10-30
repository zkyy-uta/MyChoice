import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mychoice_app/core/theme/app_colors.dart';
import 'package:mychoice_app/core/theme/app_spacing.dart';
import 'package:mychoice_app/core/theme/app_typography.dart';
import 'package:mychoice_app/core/validators/validation_rules.dart';
import 'package:mychoice_app/core/widgets/mobile_background.dart';
import 'package:mychoice_app/features/auth/presentation/providers/auth_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();
  bool _isSaving = false;
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;
  String? _error;

  bool get _passwordsMatch =>
      _passwordController.text.isNotEmpty &&
      _passwordController.text == _confirmationController.text;

  bool get _canSave =>
      !_isSaving &&
      validatePassword(_passwordController.text) == null &&
      _passwordsMatch;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  Future<void> _savePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
      _error = null;
    });

    final auth = context.read<AuthProvider>();
    await auth.updatePassword(_passwordController.text);
    if (!mounted) return;

    setState(() {
      _isSaving = false;
      _error = auth.error;
    });

    if (auth.error == null) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Password diperbarui'),
          content: const Text('Silakan login kembali dengan password baru.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Ke login'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
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
                      Text(
                        'Buat Password Baru',
                        style: AppTypography.screenTitle,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Gunakan minimal 8 karakter, satu huruf besar, dan satu angka.',
                        style: AppTypography.body,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      TextFormField(
                        key: const Key('new-password'),
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.newPassword],
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Password baru',
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
                        validator: validatePassword,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextFormField(
                        key: const Key('confirm-new-password'),
                        controller: _confirmationController,
                        obscureText: _obscureConfirmation,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.newPassword],
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Konfirmasi password baru',
                          suffixIcon: IconButton(
                            onPressed: () => setState(
                              () =>
                                  _obscureConfirmation = !_obscureConfirmation,
                            ),
                            icon: Icon(
                              _obscureConfirmation
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                        validator: (value) => value != _passwordController.text
                            ? 'Konfirmasi password tidak sama'
                            : null,
                      ),
                      if (_confirmationController.text.isNotEmpty &&
                          !_passwordsMatch) ...[
                        const SizedBox(height: AppSpacing.sm),
                        const Text(
                          'Password belum sama.',
                          style: TextStyle(color: AppColors.error80),
                        ),
                      ],
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
                          key: const Key('save-new-password'),
                          onPressed: _canSave ? _savePassword : null,
                          child: _isSaving
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              : Text(
                                  'Simpan password baru',
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
