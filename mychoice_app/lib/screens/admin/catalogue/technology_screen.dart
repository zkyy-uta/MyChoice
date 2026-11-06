import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/admin_bottom_navigation.dart';
import '../../../core/widgets/mobile_background.dart';
import 'manage_subcategory_screen.dart';

class TechnologyScreen extends StatelessWidget {
  const TechnologyScreen({super.key});

  static const Color _darkPurple = AppColors.textPurple;
  static const Color _plum = Color(0xFF54204F);
  static const Color _cardBackground = Color(0xFFDCE0F6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: MobileBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _statCard('5', 'Subcategories'),
                          const SizedBox(width: 8),
                          _statCard('23', 'Criteria'),
                          const SizedBox(width: 8),
                          _statCard('45', 'Options'),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'Subcategories',
                        style: AppTypography.sectionInnerTitle.copyWith(
                          color: _darkPurple,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 1. LAPTOP
                      _subcategoryCard(
                        context: context,
                        name: 'Laptop',
                        icon: Icons.laptop_mac_rounded,
                        incomplete: true,
                      ),

                      // 2. SMARTPHONE
                      _subcategoryCard(
                        context: context,
                        name: 'Smartphone',
                        icon: Icons.smartphone_rounded,
                        incomplete: false,
                      ),

                      // 3. TABLET
                      _subcategoryCard(
                        context: context,
                        name: 'Tablet',
                        icon: Icons.tablet_mac_rounded,
                        incomplete: false,
                      ),

                      // 4. PC
                      _subcategoryCard(
                        context: context,
                        name: 'PC',
                        icon: Icons.desktop_windows_rounded,
                        incomplete: false,
                        criteriaTags: const [
                          'Price',
                          'RAM',
                          'Storage',
                          'CPU Score',
                        ],
                      ),

                      // 5. MONITOR
                      _subcategoryCard(
                        context: context,
                        name: 'Monitor',
                        icon: Icons.monitor_rounded,
                        incomplete: false,
                        criteriaTags: const [
                          'Price',
                          'Screen Size',
                          'Refresh Rate',
                          'Response Time',
                          'Resolution',
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AdminBottomNavigation(selectedIndex: 2),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 20, 12),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back to Catalogue',
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: _darkPurple,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Technology',
                  style: AppTypography.sectionInnerTitle.copyWith(
                    color: AppColors.primaryDark,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "Manage what's available in Technology",
                  style: AppTypography.extraSmallSemibold.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // CHANGED: taller card, plum -> lavender vertical gradient, bigger number.
  Widget _statCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.55, 1.0],
            colors: [Color(0xFF7B4378), Color(0xFF9783D6), Color(0xFFB4A8F6)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CHANGED: lavender card, bigger icon circle, sparkles, white tags (+N),
  // content-sized status chip and a bigger OPEN button.
  Widget _subcategoryCard({
    required BuildContext context,
    required String name,
    required IconData icon,
    required bool incomplete,
    List<String>? criteriaTags,
  }) {
    final allTags = criteriaTags ?? const ['Price', 'RAM', 'Storage', 'Weight'];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: _cardBackground,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Sparkles (top right)
          Positioned(
            right: 30,
            top: 36,
            child: IgnorePointer(child: _buildSparkle(24, glow: true)),
          ),
          Positioned(
            right: 20,
            top: 26,
            child: IgnorePointer(child: _buildSparkle(8)),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: _plum, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        name,
                        style: AppTypography.sectionInnerTitle.copyWith(
                          color: _plum,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _buildTagRow(context, allTags),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: incomplete
                            ? const Color(0xFFF5E0BC)
                            : const Color(0xFFB8F0B0),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        incomplete
                            ? '1 Option Incomplete'
                            : 'All Options Complete',
                        style: TextStyle(
                          color: incomplete
                              ? const Color(0xFF6E5520)
                              : const Color(0xFF2E6B33),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 36,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (context) =>
                                  ManageSubcategoryScreen(subcategory: name),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: _plum,
                          elevation: 3,
                          shadowColor: Colors.black.withValues(alpha: 0.35),
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'OPEN',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
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
    );
  }

  static const double _tagSpacing = 6;
  static const double _tagHorizontalPadding = 10;

  TextStyle _tagTextStyle() {
    return AppTypography.extraSmallSemibold.copyWith(
      color: _plum,
      fontSize: 9.5,
      fontWeight: FontWeight.w600,
    );
  }

  // Measures how wide a tag pill will be (text + horizontal padding).
  double _tagWidth(BuildContext context, String text) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: _tagTextStyle()),
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout();
    return painter.width + _tagHorizontalPadding * 2;
  }

  // Shows tags in ONE row only. Tags that do not fit are collapsed into a
  // "+N" pill (N = number of hidden tags), calculated per card.
  Widget _buildTagRow(BuildContext context, List<String> tags) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Small safety margin so rounding never causes an overflow.
        final maxWidth = constraints.maxWidth - 2;
        final widths = [for (final t in tags) _tagWidth(context, t)];

        double widthFor(int visible) {
          var total = 0.0;
          for (var i = 0; i < visible; i++) {
            total += widths[i] + (i > 0 ? _tagSpacing : 0);
          }
          final hidden = tags.length - visible;
          if (hidden > 0) {
            total +=
                (visible > 0 ? _tagSpacing : 0) +
                _tagWidth(context, '+$hidden');
          }
          return total;
        }

        // Largest number of tags that still fits (together with "+N").
        var visible = 0;
        for (var n = tags.length; n >= 0; n--) {
          if (widthFor(n) <= maxWidth) {
            visible = n;
            break;
          }
        }

        final hidden = tags.length - visible;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < visible; i++) ...[
              if (i > 0) const SizedBox(width: _tagSpacing),
              _miniTag(tags[i]),
            ],
            if (hidden > 0) ...[
              if (visible > 0) const SizedBox(width: _tagSpacing),
              _miniTag('+$hidden'),
            ],
          ],
        );
      },
    );
  }

  // White pill with plum text.
  Widget _miniTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _tagHorizontalPadding,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, maxLines: 1, style: _tagTextStyle()),
    );
  }

  Widget _buildSparkle(double size, {bool glow = false}) {
    return CustomPaint(
      size: Size(size, size),
      painter: _SparklePainter(color: Colors.white, glow: glow),
    );
  }
}

// Solid white 4-point sparkle star with slightly rounded tips.
// glow: true adds a soft white glow behind the star.
class _SparklePainter extends CustomPainter {
  final Color color;
  final bool glow;

  const _SparklePainter({required this.color, this.glow = false});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path()
      ..moveTo(w * 0.5, 0)
      ..quadraticBezierTo(w * 0.6, h * 0.4, w, h * 0.5)
      ..quadraticBezierTo(w * 0.6, h * 0.6, w * 0.5, h)
      ..quadraticBezierTo(w * 0.4, h * 0.6, 0, h * 0.5)
      ..quadraticBezierTo(w * 0.4, h * 0.4, w * 0.5, 0)
      ..close();

    if (glow) {
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.6)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
      canvas.drawPath(path, glowPaint);
    }

    final fill = Paint()
      ..color = color.withValues(alpha: 0.97)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fill);

    // Thin same-color stroke to slightly round the tips.
    final tips = Paint()
      ..color = color.withValues(alpha: 0.97)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, tips);
  }

  @override
  bool shouldRepaint(covariant _SparklePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.glow != glow;
}
