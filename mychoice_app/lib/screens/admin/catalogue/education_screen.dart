import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/admin_bottom_navigation.dart';
import '../../../core/widgets/mobile_background.dart';
import '../../../features/admin_catalog/domain/repositories/admin_catalog_repository.dart';
import 'manage_subcategory_screen.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  static const Color _darkPurple = AppColors.textPurple;
  static const Color _plum = Color(0xFF54204F);
  static const Color _cardBackground = Color(0xFFDCE0F6);

  // Get the full Education subcategory list from the database.
  List<String> _subcategories = [];
  Map<String, bool?> _incompleteBySubcategory = {};
  Map<String, List<String>> _criteriaTagsBySubcategory = {};
  bool _loadingCompleteness = true;
  String? _loadError;
  int? _totalCriteria;
  int? _totalOptions;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadCompleteness();
    });
  }

  // Fetch the full list from Production, then load each subcategory's
  // criteria, options, and completeness through the existing repository.
  // All queries here are read-only.
  Future<void> _loadCompleteness() async {
    if (!mounted) return;
    setState(() {
      _loadingCompleteness = true;
      _loadError = null;
    });

    try {
      final repository = Provider.of<AdminCatalogRepository?>(
        context,
        listen: false,
      );
      if (repository == null) {
        throw StateError('Admin catalog repository is unavailable.');
      }

      final client = Supabase.instance.client;
      final categoryRow = await client
          .from('categories')
          .select('id_kategori')
          .eq('nama_kategori', 'Education')
          .maybeSingle();

      if (categoryRow == null) {
        throw StateError('Education category was not found in the database.');
      }

      final subcategoryRows = await client
          .from('subcategories')
          .select('id_sub_kategori, nama_sub_kategori')
          .eq('id_kategori', categoryRow['id_kategori'])
          .order('id_sub_kategori', ascending: true);

      final names = <String>[
        for (final row in subcategoryRows)
          if ((row['nama_sub_kategori'] as String?)?.trim().isNotEmpty ?? false)
            (row['nama_sub_kategori'] as String).trim(),
      ];

      final results = await Future.wait<({
        String name,
        bool? incomplete,
        int? criteria,
        int? options,
        List<String> tags,
      })>(
        names.map((subcategory) async {
          try {
            final catalog = await repository.loadSubcategory(
              category: 'Education',
              subcategory: subcategory,
            );
            final incomplete = catalog.options.any((option) {
              return catalog.criteria.any((criterion) {
                final key = criterion.attributeKey ??
                    _attributeKey(criterion.name);
                final value = key == 'harga'
                    ? option.price ??
                        option.attributes[key] ??
                        option.attributes['price']
                    : option.attributes[key] ??
                        option.attributes[criterion.name];
                final text = value?.toString().trim() ?? '';
                // As on the detail page, N/A is allowed; empty is incomplete.
                return text.isEmpty;
              });
            });
            return (
              name: subcategory,
              incomplete: incomplete,
              criteria: catalog.criteria.length,
              options: catalog.options.length,
              tags: catalog.criteria.map((criterion) => _criterionTagLabel(criterion.name)).toList(),
            );
          } catch (error) {
            debugPrint('Could not load Education catalog for $subcategory: $error');
            return (
              name: subcategory,
              incomplete: null,
              criteria: null,
              options: null,
              tags: <String>[],
            );
          }
        }),
      );

      final allLoaded = results.every(
        (item) => item.criteria != null && item.options != null,
      );
      final criteriaTotal = allLoaded
          ? results.fold<int>(0, (total, item) => total + item.criteria!)
          : null;
      final optionsTotal = allLoaded
          ? results.fold<int>(0, (total, item) => total + item.options!)
          : null;

      if (!mounted) return;
      setState(() {
        _subcategories = names;
        _incompleteBySubcategory = {
          for (final item in results) item.name: item.incomplete,
        };
        _criteriaTagsBySubcategory = {
          for (final item in results) item.name: item.tags,
        };
        _totalCriteria = criteriaTotal;
        _totalOptions = optionsTotal;
        _loadingCompleteness = false;
      });
    } catch (error) {
      debugPrint('Could not load Education subcategories: $error');
      if (!mounted) return;
      setState(() {
        _subcategories = [];
        _incompleteBySubcategory = {};
        _criteriaTagsBySubcategory = {};
        _totalCriteria = null;
        _totalOptions = null;
        _loadError = 'Could not load Education subcategories. Please retry.';
        _loadingCompleteness = false;
      });
    }
  }

  // Preserve the existing icons; use a generic icon for new DB subcategories.
  IconData _iconForSubcategory(String name) {
    switch (name.toLowerCase().trim()) {
      case 'course':
        return Icons.menu_book_rounded;
      case 'certification':
        return Icons.workspace_premium_rounded;
      case 'bootcamp':
        return Icons.work_outline_rounded;
      case 'university':
        return Icons.school_rounded;
      case 'training program':
        return Icons.business_rounded;
      default:
        return Icons.school_outlined;
    }
  }

  // Matches the fallback attribute key logic in ManageSubcategoryScreen.
  // Translate only criterion chips shown on Education cards.
  // Names/attribute keys stored in Supabase remain unchanged for all logic.
  String _criterionTagLabel(String name) {
    const translations = <String, String>{
      'harga': 'Price',
      'harga barang': 'Price',
      'biaya': 'Price',
      'biaya ujian': 'Exam Fee',
      'penyimpanan': 'Storage',
      'kapasitas penyimpanan': 'Storage',
      'memori penyimpanan': 'Storage',
      'memori': 'Memory',
      'daya tahan baterai': 'Battery Life',
      'daya tahan baterai (jam)': 'Battery Life',
      'umur baterai': 'Battery Life',
      'kapasitas baterai': 'Battery Capacity',
      'berat': 'Weight',
      'bobot': 'Weight',
      'ukuran layar': 'Screen Size',
      'resolusi layar': 'Screen Resolution',
      'kamera utama': 'Main Camera',
      'kualitas kamera': 'Camera Quality',
      'waktu respons': 'Response Time',
      'kecepatan refresh': 'Refresh Rate',
      'kecepatan penyegaran': 'Refresh Rate',
      'masa garansi': 'Warranty',
      'garansi': 'Warranty',
      'jarak': 'Distance',
      'durasi': 'Duration',
      'lama penggunaan': 'Duration',
      'masa berlaku': 'Validity',
      'waktu persiapan': 'Preparation Time',
      'biaya pendidikan': 'Tuition Fee',
      'uang saku bulanan': 'Monthly Allowance',
      'relevansi bidang': 'Field Relevance',
      'rating perusahaan': 'Company Rating',
      'peringkat perusahaan': 'Company Rating',
      'kepuasan mahasiswa': 'Student Satisfaction',
      'keamanan kampus': 'Campus Safety',
      'tingkat penempatan kerja': 'Job Placement Rate',
      'penempatan kerja': 'Job Placement',
      'kapasitas': 'Capacity',
      'kenyamanan': 'Comfort',
      'ketahanan': 'Durability',
      'daya tahan': 'Durability',
      'bahan': 'Material',
      'material': 'Material',
      'kualitas bahan': 'Material Quality',
      'gaya': 'Style',
      'model': 'Style',
      'kualitas kurikulum': 'Curriculum Quality',
      'pengakuan industri': 'Industry Recognition',
      'pengalaman instruktur': 'Instructor Experience',
      'tingkat kelulusan': 'Completion Rate',
      'skor cpu': 'CPU Score',
      'skor gpu': 'GPU Score',
      'sertifikat': 'Certificate',
      'bahasa': 'Language',
      'ukuran': 'Size',
      'ukuran pakaian': 'Clothing Size',
      'ukuran sepatu': 'Shoe Size',
      'potongan': 'Cut',
      'petunjuk perawatan': 'Care Instructions',
      'instruksi perawatan': 'Care Instructions',
      'jenis bahan': 'Material Type',
      'warna': 'Color',
      'asal produk': 'Product Origin',
      'bahan pengisi': 'Filling Material',
      'biaya kuliah': 'Tuition Fee',
      'clock speed': 'Clock Speed',
      'durasi belajar': 'Study Duration',
      'fitur': 'Features',
      'format': 'Format',
      'gpu': 'GPU',
      'isa tersedia': 'ISA Available',
      'jalur belajar': 'Learning Paths',
      'jenis': 'Type',
      'jenis institusi': 'Institution Type',
      'jenis panel': 'Panel Type',
      'jenis sepatu': 'Shoe Type',
      'jumlah core': 'Core Count',
      'ketahanan air': 'Water Resistance',
      'kinerja': 'Performance',
      'konsumsi daya': 'Power Consumption',
      'layar': 'Display',
      'level': 'Level',
      'lokasi': 'Location',
      'peringkat': 'Ranking',
      'program unggulan': 'Featured Programs',
      'prosesor': 'Processor',
      'ram': 'RAM',
      'refresh rate': 'Refresh Rate',
      'resolusi': 'Resolution',
      'socket': 'Socket',
      'tdp': 'TDP',
      'vram': 'VRAM',
    };
    final key = name.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    return translations[key] ?? name.trim();
  }

  String _attributeKey(String name) {
    if (name.trim().toLowerCase() == 'price') return 'harga';
    return name
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
  }

  bool? _statusFor(String subcategory) => _loadingCompleteness
      ? null
      : _incompleteBySubcategory[subcategory];

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
                          _statCard(
                            _loadingCompleteness
                                ? '...'
                                : (_loadError != null
                                    ? '—'
                                    : _subcategories.length.toString()),
                            'Subcategories',
                          ),
                          const SizedBox(width: 8),
                          _statCard(
                            _loadingCompleteness
                                ? '...'
                                : (_totalCriteria?.toString() ?? '—'),
                            'Criteria',
                          ),
                          const SizedBox(width: 8),
                          _statCard(
                            _loadingCompleteness
                                ? '...'
                                : (_totalOptions?.toString() ?? '—'),
                            'Options',
                          ),
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

                      if (_loadingCompleteness && _subcategories.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 28),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      if (_loadError != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_loadError!),
                              const SizedBox(height: 8),
                              OutlinedButton(
                                onPressed: _loadCompleteness,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      if (!_loadingCompleteness &&
                          _loadError == null &&
                          _subcategories.isEmpty)
                        const Text('No subcategories found.'),
                      for (final subcategory in _subcategories)
                        _subcategoryCard(
                          context: context,
                          name: subcategory,
                          icon: _iconForSubcategory(subcategory),
                          incomplete: _statusFor(subcategory),
                          criteriaTags:
                              _criteriaTagsBySubcategory[subcategory] ??
                                  const <String>[],
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
                  'Education',
                  style: AppTypography.sectionInnerTitle.copyWith(
                    color: AppColors.primaryDark,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "Manage what's available in Education",
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

  // Stat card: plum -> lavender vertical gradient.
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

  // Subcategory card: lavender card, sparkles, single-row tags (+N),
  // content-sized status chip and OPEN button.
  Widget _subcategoryCard({
    required BuildContext context,
    required String name,
    required IconData icon,
    required bool? incomplete,
    required List<String> criteriaTags,
  }) {
    final allTags = criteriaTags;

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
                        color: incomplete == null
                            ? const Color(0xFFEDECF6)
                            : incomplete
                                ? const Color(0xFFF5E0BC)
                                : const Color(0xFFB8F0B0),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        incomplete == null
                            ? (_loadingCompleteness
                                ? 'Checking status...'
                                : 'Status unavailable')
                            : incomplete
                                ? 'Options Incomplete'
                                : 'All Options Complete',
                        style: TextStyle(
                          color: incomplete == null
                              ? _plum
                              : incomplete
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
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (context) => ManageSubcategoryScreen(
                                category: 'Education',
                                subcategory: name,
                              ),
                            ),
                          );
                          if (mounted) await _loadCompleteness();
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
