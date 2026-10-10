import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/animated_gradient_background.dart';
import 'widgets/onboarding_page.dart';

/// Onboarding Screen
/// Shows 4 slides explaining MyChoice features
/// Users can skip or navigate through slides
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = const [
    OnboardingData(
      title: 'Welcome to MyChoice',
      subtitle: 'Clarity Before You Decide.',
      description:
          'MyChoice membantu kamu membandingkan berbagai pilihan berdasarkan kebutuhan, prioritas, dan kondisi kamu.',
      illustration:
          'assets/illustrations/onboarding_welcome.png', // Placeholder - Replace with actual illustration
    ),
    OnboardingData(
      title: '🔍 Understand Your Needs',
      subtitle: 'Know What Matters Most',
      description:
          'Bingung menentukan apa yang paling penting? MyChoice membantu memahami kebutuhan kamu dan menyarankan kriteria yang relevan.',
      illustration:
          'assets/illustrations/onboarding_understand.png', // Placeholder
    ),
    OnboardingData(
      title: '⚖️ Compare Your Options',
      subtitle: 'Compare Without the Confusion',
      description:
          'Bandingkan beberapa pilihan berdasarkan kriteria yang benar-benar penting buat kamu.',
      illustration:
          'assets/illustrations/onboarding_compare.png', // Placeholder
    ),
    OnboardingData(
      title: '✨ Understand the Result',
      subtitle: 'You Decide. MyChoice Helps.',
      description:
          'MyChoice memberikan hasil berdasarkan data dan prioritasmu, menjelaskan alasannya, dan membantu melihat kemungkinan hasil jika prioritasmu berubah.',
      illustration: 'assets/illustrations/onboarding_result.png', // Placeholder
    ),
  ];

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToAuth();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() {
    _navigateToAuth();
  }

  void _navigateToAuth() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: SoftGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button
              if (!isLastPage)
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _skip,
                    child: Text(
                      'Skip',
                      style: AppTypography.buttonMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(height: 48),

              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return OnboardingPage(data: _pages[index]);
                  },
                ),
              ),

              // Bottom Section
              Container(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Page Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                          ),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppColors.indicatorActive
                                : AppColors.indicatorInactive,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Title
                    Text(
                      _pages[_currentPage].title,
                      style: AppTypography.screenTitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Subtitle
                    Text(
                      _pages[_currentPage].subtitle,
                      style: AppTypography.sectionInnerTitle.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Description
                    Text(
                      _pages[_currentPage].description,
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Navigation Buttons
                    Row(
                      children: [
                        // Back Button
                        if (_currentPage > 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _previousPage,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: AppColors.primary88,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                'Back',
                                style: AppTypography.buttonLarge.copyWith(
                                  color: AppColors.primary88,
                                ),
                              ),
                            ),
                          ),
                        if (_currentPage > 0)
                          const SizedBox(width: AppSpacing.md),

                        // Next/Get Started Button
                        Expanded(
                          flex: _currentPage == 0 ? 1 : 1,
                          child: ElevatedButton(
                            onPressed: _nextPage,
                            child: Text(
                              isLastPage ? "Let's Get Started" : 'Next',
                              style: AppTypography.buttonLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Onboarding Data Model
class OnboardingData {
  final String title;
  final String subtitle;
  final String description;
  final String illustration;

  const OnboardingData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.illustration,
  });
}
