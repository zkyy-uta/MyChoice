import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class MobileBackground extends StatelessWidget {
  final Widget child;

  const MobileBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: Color(0xFFEEF1F3)),
            Positioned(
              top: -height * 0.2,
              left: -width * 0.2,
              width: width * 1.4,
              height: height * 0.48,
              child: const _AmbientGlow(
                alignment: Alignment(0, 0.7),
                color: Color(0x88A99BFF),
              ),
            ),
            Positioned(
              bottom: -height * 0.2,
              left: -width * 0.2,
              width: width * 1.4,
              height: height * 0.48,
              child: const _AmbientGlow(
                alignment: Alignment(0, -0.7),
                color: Color(0x88A99BFF),
              ),
            ),
            child,
          ],
        );
      },
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  final Alignment alignment;
  final Color color;

  const _AmbientGlow({required this.alignment, required this.color});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ui.ImageFilter.blur(sigmaX: 38, sigmaY: 38),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: alignment,
            radius: 1.3,
            colors: [color, const Color(0x55C6C5F3), const Color(0x00EEF1F3)],
            stops: const [0, 0.48, 1],
          ),
        ),
      ),
    );
  }
}
