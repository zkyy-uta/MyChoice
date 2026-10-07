import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Animated Gradient Background
/// Creates a smooth, animated gradient background similar to UI/UX design
/// Features:
/// - Soft gradient (purple top/bottom, white center)
/// - Subtle shimmer animation
/// - Blur/frosted glass effect
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final bool animate;
  final Duration duration;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    this.animate = true,
    this.duration = const Duration(seconds: 4),
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                0.0,
                0.3 + (_animation.value * 0.1),
                0.7 - (_animation.value * 0.1),
                1.0,
              ],
              colors: [
                Color.lerp(
                  const Color(0xFFB4A7FF),
                  const Color(0xFFE3DDFF),
                  _animation.value * 0.3,
                )!,
                Color.lerp(
                  const Color(0xFFF5F3FF),
                  const Color(0xFFFFFFFF),
                  _animation.value * 0.2,
                )!,
                Color.lerp(
                  const Color(0xFFF5F3FF),
                  const Color(0xFFFFFFFF),
                  _animation.value * 0.2,
                )!,
                Color.lerp(
                  const Color(0xFFB4A7FF),
                  const Color(0xFFE3DDFF),
                  _animation.value * 0.3,
                )!,
              ],
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Static Soft Gradient Background
/// Non-animated version for better performance
class SoftGradientBackground extends StatelessWidget {
  final Widget child;

  const SoftGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.softGradientBackground,
      ),
      child: child,
    );
  }
}

/// Frosted Glass Background Effect
/// Creates blur effect with gradient overlay
class FrostedGradientBackground extends StatelessWidget {
  final Widget child;
  final double blurSigma;

  const FrostedGradientBackground({
    super.key,
    required this.child,
    this.blurSigma = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient Background
        Container(
          decoration: const BoxDecoration(
            gradient: AppColors.softGradientBackground,
          ),
        ),
        // Blur overlay circles (decorative)
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary88.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -150,
          left: -150,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary88.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Content
        child,
      ],
    );
  }
}
