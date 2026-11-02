import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/admin_bottom_navigation.dart';
import 'technology_screen.dart';
import 'education_screen.dart';
import 'fashion_screen.dart';

class CatalogueScreen extends StatelessWidget {
  const CatalogueScreen({super.key});

  static const Color _darkPurple = AppColors.textPurple;
  static const Color _categoryCardBackground = Color(0xFFDCE0F6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: AppTypography.sectionInnerTitle.copyWith(
                        color: _darkPurple,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildCategoryCard(
                      context: context,
                      title: 'Technology',
                      icon: Icons.laptop_mac_rounded,
                      criteria: 23,
                      subcategories: 5,
                      // CHANGED: outlined variant for the big outline illustration
                      illustration: Icons.laptop_mac_outlined,
                      illustrationSize: 90,
                      illustrationTop: 70,
                      illustrationRight: 28,
                      subcategoryIcons: const [
                        Icons.laptop_mac_rounded,
                        Icons.smartphone_rounded,
                        Icons.tablet_mac_rounded,
                        Icons.desktop_windows_rounded,
                        Icons.monitor_rounded,
                      ],
                    ),

                    _buildCategoryCard(
                      context: context,
                      title: 'Education',
                      icon: Icons.school_outlined,
                      criteria: 11,
                      subcategories: 3,
                      illustration: Icons.school_outlined,
                      illustrationSize: 94,
                      illustrationTop: 68,
                      illustrationRight: 24,
                      subcategoryIcons: const [
                        Icons.menu_book_rounded,
                        Icons.workspace_premium_rounded,
                        Icons.work_outline_rounded,
                      ],
                    ),

                    _buildCategoryCard(
                      context: context,
                      title: 'Fashion',
                      icon: Icons.checkroom_outlined,
                      criteria: 19,
                      subcategories: 5,
                      // CHANGED: outlined variant for the big outline illustration
                      illustration: Icons.checkroom_outlined,
                      illustrationSize: 90,
                      illustrationTop: 70,
                      illustrationRight: 21,
                      subcategoryIcons: const [
                        Icons.directions_walk_rounded,
                        Icons.shopping_bag_outlined,
                        Icons.checkroom_rounded,
                        Icons.style_outlined,
                        Icons.watch_outlined,
                      ],
                      customSubcategoryIcons: const [
                        'shoes',
                        null,
                        null,
                        'bottoms',
                        null,
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNavigation(selectedIndex: 2),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Catalogue',
            textAlign: TextAlign.left,
            style: AppTypography.sectionInnerTitle.copyWith(
              color: AppColors.primaryDark,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Keep categories and options up to date',
            textAlign: TextAlign.left,
            style: AppTypography.extraSmallSemibold.copyWith(
              color: AppColors.textTertiary,
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required int criteria,
    required int subcategories,
    required IconData illustration,
    required List<IconData> subcategoryIcons,
    List<String?> customSubcategoryIcons = const [],
    // Tuning per illustration so all of them have the same visual height
    // (~60px) and sit below the sparkles.
    double illustrationSize = 90,
    double illustrationTop = 82,
    double illustrationRight = 28,
  }) {
    return Container(
      height: 158,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: _categoryCardBackground,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(25),
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          // Disable hover/focus overlay so every card keeps the same color.
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          onTap: () {
            if (title == 'Technology') {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const TechnologyScreen(),
                ),
              );
            } else if (title == 'Education') {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const EducationScreen(),
                ),
              );
            } else if (title == 'Fashion') {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const FashionScreen(),
                ),
              );
            }
          },
          child: Stack(
            children: [
              // CHANGED: big outline illustration (bottom-right, behind arrow button)
              Positioned(
                right: illustrationRight,
                top: illustrationTop,
                child: IgnorePointer(
                  child: _buildOutlineIllustration(
                    illustration,
                    size: illustrationSize,
                  ),
                ),
              ),

              // CHANGED: two outlined sparkles (small + big)
              Positioned(
                right: 62,
                top: 52,
                child: IgnorePointer(child: _buildSparkle(9)),
              ),
              Positioned(
                right: 44,
                top: 56,
                child: IgnorePointer(child: _buildSparkle(14)),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 39,
                          height: 39,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            color: _darkPurple,
                            size: 22,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.88),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.layers_outlined,
                                size: 14,
                                color: _darkPurple,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '$subcategories Subcategories',
                                style: AppTypography.extraSmallSemibold.copyWith(
                                  color: _darkPurple,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$criteria Criteria',
                      style: AppTypography.extraSmallSemibold.copyWith(
                        color: _darkPurple.withValues(alpha: 0.55),
                        fontSize: 9,
                      ),
                    ),
                    Text(
                      title,
                      style: AppTypography.sectionInnerTitle.copyWith(
                        color: const Color(0xFF54204F),
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        // CHANGED: overlapping subcategory circles (+N included)
                        _buildSubcategoryStack(
                          icons: subcategoryIcons,
                          total: subcategories,
                          customIcons: customSubcategoryIcons,
                        ),
                        const Spacer(),
                        Container(
                          width: 43,
                          height: 43,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.82),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF6B285F),
                              width: 1.8,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Color(0xFF6B285F),
                            size: 24,
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

  // Overlapping circles: [icon][icon][icon][+N], like the Figma design.
  Widget _buildSubcategoryStack({
    required List<IconData> icons,
    required int total,
    required List<String?> customIcons,
  }) {
    const double size = 38;
    const double overlap = 7;
    const double step = size - overlap;
    const colors = [
      Color(0xFFDDBBFA),
      Color(0xFFFFD9B9),
      Color(0xFFF5BFD9),
    ];

    final visible = icons.length < 3 ? icons.length : 3;
    final hasMore = total > 3;
    final count = visible + (hasMore ? 1 : 0);

    final children = <Widget>[
      for (var i = 0; i < visible; i++)
        Positioned(
          left: i * step,
          child: _categoryIcon(
            icons[i],
            colors[i],
            customType: i < customIcons.length ? customIcons[i] : null,
            size: size,
          ),
        ),
      if (hasMore)
        Positioned(
          left: visible * step,
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '+${total - 3}',
              style: AppTypography.extraSmallSemibold.copyWith(
                color: const Color(0xFF54204F),
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
    ];

    return SizedBox(
      width: step * (count - 1) + size,
      height: size,
      child: Stack(clipBehavior: Clip.none, children: children),
    );
  }

  // Big thin white outline illustration (draws the icon glyph with a stroke).
  Widget _buildOutlineIllustration(IconData icon, {double size = 108}) {
    return Text(
      String.fromCharCode(icon.codePoint),
      textScaler: TextScaler.noScaling,
      style: TextStyle(
        inherit: false,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        fontSize: size,
        height: 1,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round
          ..color = Colors.white.withValues(alpha: 0.9),
      ),
    );
  }

  Widget _buildSparkle(double size) {
    return CustomPaint(
      size: Size(size, size),
      painter: const _SparklePainter(color: Colors.white),
    );
  }

  Widget _categoryIcon(
    IconData icon,
    Color color, {
    String? customType,
    double size = 50,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: customType == 'shoes'
          ? CustomPaint(
              size: Size(size * 0.6, size * 0.6),
              painter: _CatalogueShoeIconPainter(color: _darkPurple),
            )
          : customType == 'bottoms'
              ? CustomPaint(
                  size: Size(size * 0.6, size * 0.6),
                  painter: _CataloguePantsIconPainter(color: _darkPurple),
                )
              : Icon(
                  icon,
                  color: _darkPurple,
                  size: size * 0.5,
                ),
    );
  }
}

// Outlined 4-point sparkle star (decoration at the top-right of the card).
class _SparklePainter extends CustomPainter {
  final Color color;

  const _SparklePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.95)
      ..style = PaintingStyle.fill;

    // Thin same-color stroke to slightly round the star tips.
    final tipPaint = Paint()
      ..color = color.withValues(alpha: 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final path = Path()
      ..moveTo(w * 0.5, 0)
      ..quadraticBezierTo(w * 0.6, h * 0.4, w, h * 0.5)
      ..quadraticBezierTo(w * 0.6, h * 0.6, w * 0.5, h)
      ..quadraticBezierTo(w * 0.4, h * 0.6, 0, h * 0.5)
      ..quadraticBezierTo(w * 0.4, h * 0.4, w * 0.5, 0)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, tipPaint);
  }

  @override
  bool shouldRepaint(covariant _SparklePainter oldDelegate) =>
      oldDelegate.color != color;
}

// Small custom shoe icon matching the Fashion subcategory icon.
class _CatalogueShoeIconPainter extends CustomPainter {
  final Color color;

  const _CatalogueShoeIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final shoe = Path()
      ..moveTo(size.width * 0.08, size.height * 0.68)
      ..lineTo(size.width * 0.28, size.height * 0.62)
      ..lineTo(size.width * 0.43, size.height * 0.32)
      ..quadraticBezierTo(
        size.width * 0.49,
        size.height * 0.25,
        size.width * 0.56,
        size.height * 0.35,
      )
      ..lineTo(size.width * 0.63, size.height * 0.55)
      ..lineTo(size.width * 0.83, size.height * 0.65)
      ..quadraticBezierTo(
        size.width * 0.96,
        size.height * 0.70,
        size.width * 0.93,
        size.height * 0.82,
      )
      ..lineTo(size.width * 0.12, size.height * 0.82)
      ..quadraticBezierTo(
        size.width * 0.03,
        size.height * 0.81,
        size.width * 0.08,
        size.height * 0.68,
      );

    canvas.drawPath(shoe, paint);
    canvas.drawLine(
      Offset(size.width * 0.39, size.height * 0.46),
      Offset(size.width * 0.55, size.height * 0.51),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.35, size.height * 0.54),
      Offset(size.width * 0.57, size.height * 0.60),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.13, size.height * 0.75),
      Offset(size.width * 0.89, size.height * 0.75),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CatalogueShoeIconPainter oldDelegate) =>
      oldDelegate.color != color;
}

// Small custom pants icon matching the Fashion subcategory icon.
class _CataloguePantsIconPainter extends CustomPainter {
  final Color color;

  const _CataloguePantsIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final pants = Path()
      ..moveTo(size.width * 0.22, size.height * 0.12)
      ..lineTo(size.width * 0.78, size.height * 0.12)
      ..lineTo(size.width * 0.84, size.height * 0.88)
      ..lineTo(size.width * 0.57, size.height * 0.88)
      ..lineTo(size.width * 0.50, size.height * 0.48)
      ..lineTo(size.width * 0.43, size.height * 0.88)
      ..lineTo(size.width * 0.16, size.height * 0.88)
      ..close();

    canvas.drawPath(pants, paint);
    canvas.drawLine(
      Offset(size.width * 0.23, size.height * 0.27),
      Offset(size.width * 0.77, size.height * 0.27),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.50, size.height * 0.28),
      Offset(size.width * 0.50, size.height * 0.47),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CataloguePantsIconPainter oldDelegate) =>
      oldDelegate.color != color;
}