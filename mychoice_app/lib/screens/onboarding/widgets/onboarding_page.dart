import 'dart:math' as math;

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
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final imageWidth = math
                    .min(constraints.maxWidth, 480.0)
                    .toDouble();
                final imageHeight = math
                    .min(constraints.maxHeight, 420.0)
                    .toDouble();
                return Center(
                  child: Image.asset(
                    data.illustration,
                    width: imageWidth,
                    height: imageHeight,
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: imageWidth,
                        height: imageHeight,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Center(
                          child: Text('🖼️', style: TextStyle(fontSize: 120)),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
