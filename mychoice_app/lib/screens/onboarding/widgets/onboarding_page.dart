import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../onboarding_screen.dart';

/// Onboarding Page Widget
/// Individual page in the onboarding carousel
/// Features: Full-size illustration that doesn't crop
class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.screenHorizontal,
        right: AppSpacing.screenHorizontal,
        top: AppSpacing.lg,
        bottom: 0, // No bottom padding - let image extend to bottom card
      ),
      child: Column(
        children: [
          // Illustration - FULL SIZE, NO CROP!
          Expanded(
            child: Center(
              child: Image.asset(
                data.illustration,
                width: double.infinity,
                fit: BoxFit
                    .contain, // Preserve aspect ratio, fill available space
                alignment: Alignment.bottomCenter, // Align to bottom
                errorBuilder: (context, error, stackTrace) {
                  // Fallback emoji if image not found
                  return Container(
                    constraints: const BoxConstraints(
                      maxWidth: 350,
                      maxHeight: 500,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text('🖼️', style: const TextStyle(fontSize: 120)),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
