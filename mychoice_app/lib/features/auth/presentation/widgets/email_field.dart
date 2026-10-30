import 'package:flutter/material.dart';
import '../../../../core/validators/validation_rules.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';

class EmailField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final String? initialValue;

  const EmailField({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.initialValue,
  });

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  late TextEditingController _controller;
  String? _error;
  bool _isValid = false;

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
    final email = _controller.text;
    final error = validateEmail(email.isEmpty ? null : email);

    setState(() {
      _error = error;
      _isValid = error == null && email.isNotEmpty;
    });

    widget.onChanged?.call(email);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: widget.hint ?? 'Enter your email',
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
            suffixIcon: _controller.text.isEmpty
                ? null
                : _error != null
                ? const Icon(Icons.error, color: Colors.red)
                : const Icon(Icons.check_circle, color: Colors.green),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
          ),
        ),
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
