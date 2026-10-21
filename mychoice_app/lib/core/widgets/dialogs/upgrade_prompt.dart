import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

/// Upgrade prompt dialog
class UpgradePromptDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onUpgrade;
  final VoidCallback? onCancel;

  const UpgradePromptDialog({
    super.key,
    required this.title,
    required this.message,
    this.onUpgrade,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: AppTypography.sectionTitle),
      content: Text(message, style: AppTypography.body),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onUpgrade ?? () => Navigator.of(context).pop(),
          child: const Text('Upgrade'),
        ),
      ],
    );
  }
}
