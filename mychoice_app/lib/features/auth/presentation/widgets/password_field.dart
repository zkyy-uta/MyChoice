import 'package:flutter/material.dart';
import '../../../../core/validators/validation_rules.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final bool showStrengthIndicator;

  const PasswordField({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.initialValue,
    this.showStrengthIndicator = true,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  late TextEditingController _controller;
  bool _obscureText = true;
  String? _error;
  bool _isValid = false;
  bool _isFocused = false;
  String _strength = 'weak';

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _controller.addListener(_validate);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _validate() {
    final password = _controller.text;
    final error = validatePassword(password.isEmpty ? null : password);
    final strength = getPasswordStrength(password);

    setState(() {
      _error = error;
      _isValid = error == null && password.isNotEmpty;
      _strength = strength;
    });

    widget.onChanged?.call(password);
  }

  Color _getStrengthColor() {
    switch (_strength) {
      case 'weak':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'strong':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Focus(
          onFocusChange: (hasFocus) {
            setState(() => _isFocused = hasFocus);
          },
          child: TextField(
            controller: _controller,
            obscureText: _obscureText,
            decoration: InputDecoration(
              hintText: widget.hint ?? 'Enter your password',
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                borderSide: BorderSide(
                  color: _error != null ? Colors.red : Colors.grey[300]!,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                borderSide: BorderSide(
                  color: _error != null
                      ? Colors.red
                      : (_isValid ? Colors.green : Colors.grey[300]!),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                borderSide: BorderSide(
                  color: _error != null ? Colors.red : AppColors.primary88,
                  width: 2,
                ),
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() => _obscureText = !_obscureText);
                },
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[600],
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
            ),
          ),
        ),
        // Strength indicator
        if (widget.showStrengthIndicator &&
            _isFocused &&
            _controller.text.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _strength == 'weak'
                          ? 0.33
                          : _strength == 'medium'
                          ? 0.66
                          : 1.0,
                      minHeight: 4,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getStrengthColor(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Strength: $_strength',
                  style: TextStyle(
                    fontSize: 12,
                    color: _getStrengthColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        // Error message
        if (_error != null)
          Padding(
            padding: EdgeInsets.only(top: AppSpacing.sm),
            child: Text(
              _error!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
