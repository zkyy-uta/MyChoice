import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/mobile_background.dart';

/// Splash Screen
/// First screen shown when app launches
/// Features MyChoice logo with animated gradient background
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigateToOnboarding();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  Future<void> _navigateToOnboarding() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.initialized;
      if (!mounted) return;
      final route = authProvider.isAuthenticated
          ? (authProvider.user!.isAdmin ? '/admin' : '/dashboard')
          : '/onboarding';
      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final logoSize = math
                .min(
                  200.0,
                  math.min(constraints.maxWidth, constraints.maxHeight * 0.3),
                )
                .toDouble();
            return Center(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo_mark.png',
                      width: logoSize,
                      height: logoSize,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: logoSize,
                          height: logoSize,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Icon(
                            Icons.help_outline_rounded,
                            size: logoSize * 0.5,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: logoSize * 0.16),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [AppColors.primary88, AppColors.primaryLight],
                      ).createShader(bounds),
                      child: Text(
                        'MyChoice',
                        style: AppTypography.screenTitle.copyWith(
                          color: Colors.white,
                          fontSize: logoSize * 0.2,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Clarity Before You Decide',
                      style: AppTypography.body.copyWith(
                        color: AppColors.primary88.withValues(alpha: 0.8),
                        fontSize: logoSize * 0.08,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
