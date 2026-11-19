import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../onboarding_screen.dart';

/// Onboarding Page Widget
/// Individual page in the onboarding carousel
/// Features: Responsive, consistently-sized illustration across all pages
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
        bottom: 0,
      ),
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.biggest;
                final baseSize = size.shortestSide * 0.78;
                final imageSize = baseSize * data.imageScale;

                // Untuk halaman yang imageAlignment-nya bottomCenter,
                // gambar di-Align ke bawah agar "menempel" ke white card
                final isBottomAligned =
                    data.imageAlignment == Alignment.bottomCenter;

                return Align(
                  alignment: isBottomAligned
                      ? Alignment.bottomCenter
                      : Alignment.center,
                  child: SizedBox(
                    width: imageSize,
                    height: imageSize,
                    child: Image.asset(
                      data.illustration,
                      fit: BoxFit.contain,
                      alignment: data.imageAlignment,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: imageSize * 0.4,
                              color: AppColors.primary88.withValues(alpha: 0.5),
                            ),
                          ),
                        );
                      },
                    ),
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
