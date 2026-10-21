import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/email_field.dart';
import '../widgets/password_field.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/animated_gradient_background.dart';
import '../../../../core/validators/validation_rules.dart';
import '../../domain/repositories/auth_repository.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _nameController;
  DateTime? _dateOfBirth;
  bool _emailValid = false;
  bool _passwordValid = false;
  bool _nameValid = false;
  bool _dateOfBirthValid = false;
  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
        _dateOfBirthValid = validateDateOfBirth(picked) == null;
      });
    }
  }

  void _handleRegister() async {
    final authProvider = context.read<AuthProvider>();

    final data = RegistrationData(
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
      dateOfBirth: _dateOfBirth!,
    );

    await authProvider.register(data);

    if (!mounted) return;

    if (authProvider.isAuthenticated) {
      // Navigate to dashboard
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/dashboard', (route) => false);
    } else if (authProvider.error != null) {
      // Show error dialog
      _showErrorDialog(authProvider.error!);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registration Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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

                  // Header
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Account',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          'Join MyChoice to make better decisions',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // Name Field
                  Text(
                    'Full Name',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your full name',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.inputRadius,
                        ),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _nameValid = validateName(value) == null;
                      });
                    },
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // Email Field
                  Text(
                    'Email Address',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
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

                  // Password Field
                  Text(
                    'Password',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  PasswordField(
                    controller: _passwordController,
                    hint: 'Create a strong password',
                    showStrengthIndicator: true,
                    onChanged: (value) {
                      setState(() {
                        _passwordValid = validatePassword(value) == null;
                      });
                    },
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // Date of Birth
                  Text(
                    'Date of Birth',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  GestureDetector(
                    onTap: _selectDate,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.inputRadius,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _dateOfBirth == null
                                ? 'Select your date of birth'
                                : '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: _dateOfBirth == null
                                      ? AppColors.textTertiary
                                      : AppColors.textPrimary,
                                ),
                          ),
                          const Icon(
                            Icons.calendar_today,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // Terms & Conditions
                  Row(
                    children: [
                      Checkbox(
                        value: _agreedToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreedToTerms = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          'I agree to the Terms and Conditions',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // Register Button
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      final isLoading = authProvider.state == AuthState.loading;
                      final canSubmit =
                          _emailValid &&
                          _passwordValid &&
                          _nameValid &&
                          _dateOfBirth != null &&
                          _agreedToTerms &&
                          !isLoading;

                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: canSubmit ? _handleRegister : null,
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
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Create Account',
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // Sign In Link
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.primary88,
                                  fontWeight: FontWeight.bold,
                                ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pushNamed('/login');
                              },
                          ),
                        ],
                      ),
                    ),
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
