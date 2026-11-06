import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/admin_bottom_navigation.dart';
import '../../../core/widgets/mobile_background.dart';

class ManageSubcategoryScreen extends StatefulWidget {
  const ManageSubcategoryScreen({
    super.key,
    required this.subcategory,
    this.category,
  });

  final String subcategory;

  /// Optional for backward compatibility with existing Technology screens.
  /// If omitted, the category is inferred from the subcategory name.
  final String? category;

  @override
  State<ManageSubcategoryScreen> createState() =>
      _ManageSubcategoryScreenState();
}

class _ManageSubcategoryScreenState extends State<ManageSubcategoryScreen> {
  static const Color _purple = AppColors.textPurple;
  static const Color _dark = Color(0xFF511B4D);
  static const Color _green = Color(0xFF239B4B);
  static const Color _orange = Color(0xFFFF812D);
  static const Color _palePurple = Color(0xFFE9EAFB);
  static const Color _yellow = Color(0xFFF5E7BF);
  static const Color _sheetBackground = Color(0xFFFDFBFD);
  static const Color _sheetFieldFill = Color(0xFFEFEDF6);
  static const Color _sheetHint = Color(0xFF92939A);
  static const Color _sheetBorder = Color(0xFF511B4D);
  static const Color _sheetDisabledFill = Color(0xFFDFE0E8);

  String get _category {
    final explicitCategory = widget.category?.trim();
    if (explicitCategory != null && explicitCategory.isNotEmpty) {
      return explicitCategory;
    }

    final subcategory = widget.subcategory.trim().toLowerCase();
    const educationSubcategories = {
      'course',
      'courses',
      'kursus',
      'certification',
      'certifications',
      'sertifikasi',
      'internship',
      'internships',
      'tempat magang',
    };
    if (educationSubcategories.contains(subcategory)) {
      return 'Education';
    }

    return 'Technology';
  }

  String get _normalizedSubcategory => widget.subcategory.trim().toLowerCase();

  late final List<_Criterion> _criteria = _initialCriteria();
  late final List<_OptionItem> _options = _initialOptions();
  late final List<_Suggestion> _suggestedCriteria = _initialSuggestions();

  List<_Criterion> _initialCriteria() {
    if (_category.toLowerCase() == 'education') {
      switch (_normalizedSubcategory) {
        case 'course':
        case 'courses':
        case 'kursus':
          return [
            _Criterion(
              name: 'Price',
              type: 'Cost',
              unit: 'Rp',
              icon: Icons.payments_outlined,
            ),
            _Criterion(
              name: 'Rating',
              type: 'Benefit',
              unit: 'scale 1-5',
              icon: Icons.star_rounded,
            ),
            _Criterion(
              name: 'Duration',
              type: 'Cost',
              unit: 'hours',
              icon: Icons.schedule_rounded,
            ),
          ];
        case 'certification':
        case 'certifications':
        case 'sertifikasi':
          return [
            _Criterion(
              name: 'Exam Fee',
              type: 'Cost',
              unit: 'Rp',
              icon: Icons.payments_outlined,
            ),
            _Criterion(
              name: 'Industry Recognition',
              type: 'Benefit',
              unit: 'scale 1-5',
              icon: Icons.workspace_premium_rounded,
            ),
            _Criterion(
              name: 'Validity',
              type: 'Benefit',
              unit: 'years',
              icon: Icons.event_available_rounded,
            ),
            _Criterion(
              name: 'Preparation Time',
              type: 'Cost',
              unit: 'hours',
              icon: Icons.schedule_rounded,
            ),
          ];
        case 'internship':
        case 'internships':
        case 'tempat magang':
          return [
            _Criterion(
              name: 'Monthly Allowance',
              type: 'Benefit',
              unit: 'Rp/month',
              icon: Icons.payments_outlined,
            ),
            _Criterion(
              name: 'Field Relevance',
              type: 'Benefit',
              unit: 'scale 1-5',
              icon: Icons.school_outlined,
            ),
            _Criterion(
              name: 'Company Rating',
              type: 'Benefit',
              unit: 'scale 1-5',
              icon: Icons.star_rounded,
            ),
            _Criterion(
              name: 'Distance',
              type: 'Cost',
              unit: 'km',
              icon: Icons.directions_walk_rounded,
            ),
          ];
      }
    }

    if (_category.toLowerCase() == 'fashion') {
      switch (_normalizedSubcategory) {
        case 'shoes':
        case 'sepatu':
          return [
            _Criterion(
              name: 'Price',
              type: 'Cost',
              unit: 'Rp',
              icon: Icons.payments_outlined,
            ),
            _Criterion(
              name: 'Rating',
              type: 'Benefit',
              unit: 'scale 1-5',
              icon: Icons.star_rounded,
            ),
            _Criterion(
              name: 'Comfort',
              type: 'Benefit',
              unit: 'scale 1-5',
              icon: Icons.weekend_outlined,
            ),
            _Criterion(
              name: 'Weight',
              type: 'Cost',
              unit: 'grams',
              icon: Icons.scale_outlined,
            ),
          ];
        case 'bags':
        case 'bag':
        case 'tas':
          return [
            _Criterion(
              name: 'Price',
              type: 'Cost',
              unit: 'Rp',
              icon: Icons.payments_outlined,
            ),
            _Criterion(
              name: 'Rating',
              type: 'Benefit',
              unit: 'scale 1-5',
              icon: Icons.star_rounded,
            ),
            _Criterion(
              name: 'Capacity',
              type: 'Benefit',
              unit: 'liters',
              icon: Icons.inventory_2_outlined,
            ),
            _Criterion(
              name: 'Weight',
              type: 'Cost',
              unit: 'grams',
              icon: Icons.scale_outlined,
            ),
          ];
        case 'tops':
        case 'top':
        case 'atasan':
        case 'atasan baju':
          return [
            _Criterion(
              name: 'Price',
              type: 'Cost',
              unit: 'Rp',
              icon: Icons.payments_outlined,
            ),
            _Criterion(
              name: 'Rating',
              type: 'Benefit',
              unit: 'scale 1-5',
              icon: Icons.star_rounded,
            ),
            _Criterion(
              name: 'Fabric Quality',
              type: 'Benefit',
              unit: 'scale 1-5',
              icon: Icons.checkroom_rounded,
            ),
          ];
        case 'bottoms':
        case 'bottom':
        case 'bawahan':
          return [
            _Criterion(
              name: 'Price',
              type: 'Cost',
              unit: 'Rp',
              icon: Icons.payments_outlined,
            ),
            _Criterion(
              name: 'Rating',
              type: 'Benefit',
              unit: 'scale 1-5',
              icon: Icons.star_rounded,
            ),
            _Criterion(
              name: 'Comfort',
              type: 'Benefit',
              unit: 'scale 1-5',
              icon: Icons.weekend_outlined,
            ),
            _Criterion(
              name: 'Fabric Quality',
              type: 'Benefit',
              unit: 'scale 1-5',
              icon: Icons.checkroom_rounded,
            ),
          ];
        case 'watches':
        case 'watch':
        case 'jam tangan':
          return [
            _Criterion(
              name: 'Price',
              type: 'Cost',
              unit: 'Rp',
              icon: Icons.payments_outlined,
            ),
            _Criterion(
              name: 'Rating',
              type: 'Benefit',
              unit: 'scale 1-5',
              icon: Icons.star_rounded,
            ),
            _Criterion(
              name: 'Water Resistance',
              type: 'Benefit',
              unit: 'meters',
              icon: Icons.water_drop_outlined,
            ),
            _Criterion(
              name: 'Warranty',
              type: 'Benefit',
              unit: 'years',
              icon: Icons.verified_outlined,
            ),
          ];
      }
    }

    switch (_normalizedSubcategory) {
      case 'laptop':
        return [
          _Criterion(
            name: 'Price',
            type: 'Cost',
            unit: 'Rp',
            icon: Icons.payments_outlined,
          ),
          _Criterion(
            name: 'RAM',
            type: 'Benefit',
            unit: 'GB',
            icon: Icons.memory_rounded,
          ),
          _Criterion(
            name: 'Storage',
            type: 'Benefit',
            unit: 'GB',
            icon: Icons.storage_rounded,
          ),
          _Criterion(
            name: 'Weight',
            type: 'Cost',
            unit: 'kg',
            icon: Icons.scale_outlined,
          ),
        ];
      case 'smartphone':
        return [
          _Criterion(
            name: 'Price',
            type: 'Cost',
            unit: 'Rp',
            icon: Icons.payments_outlined,
          ),
          _Criterion(
            name: 'RAM',
            type: 'Benefit',
            unit: 'GB',
            icon: Icons.memory_rounded,
          ),
          _Criterion(
            name: 'Storage',
            type: 'Benefit',
            unit: 'GB',
            icon: Icons.storage_rounded,
          ),
          _Criterion(
            name: 'Battery Capacity',
            type: 'Benefit',
            unit: 'mAh',
            icon: Icons.battery_full_rounded,
          ),
          _Criterion(
            name: 'Main Camera',
            type: 'Benefit',
            unit: 'MP',
            icon: Icons.camera_alt_outlined,
          ),
        ];
      case 'tablet':
        return [
          _Criterion(
            name: 'Price',
            type: 'Cost',
            unit: 'Rp',
            icon: Icons.payments_outlined,
          ),
          _Criterion(
            name: 'RAM',
            type: 'Benefit',
            unit: 'GB',
            icon: Icons.memory_rounded,
          ),
          _Criterion(
            name: 'Storage',
            type: 'Benefit',
            unit: 'GB',
            icon: Icons.storage_rounded,
          ),
          _Criterion(
            name: 'Battery Capacity',
            type: 'Benefit',
            unit: 'mAh',
            icon: Icons.battery_full_rounded,
          ),
          _Criterion(
            name: 'Screen Size',
            type: 'Benefit',
            unit: 'inches',
            icon: Icons.tablet_android_outlined,
          ),
        ];
      case 'pc':
        return [
          _Criterion(
            name: 'Price',
            type: 'Cost',
            unit: 'Rp',
            icon: Icons.payments_outlined,
          ),
          _Criterion(
            name: 'RAM',
            type: 'Benefit',
            unit: 'GB',
            icon: Icons.memory_rounded,
          ),
          _Criterion(
            name: 'Storage',
            type: 'Benefit',
            unit: 'GB',
            icon: Icons.storage_rounded,
          ),
          _Criterion(
            name: 'CPU Score',
            type: 'Benefit',
            unit: 'benchmark points',
            icon: Icons.speed_rounded,
          ),
        ];
      case 'monitor':
        return [
          _Criterion(
            name: 'Price',
            type: 'Cost',
            unit: 'Rp',
            icon: Icons.payments_outlined,
          ),
          _Criterion(
            name: 'Screen Size',
            type: 'Benefit',
            unit: 'inches',
            icon: Icons.monitor_outlined,
          ),
          _Criterion(
            name: 'Refresh Rate',
            type: 'Benefit',
            unit: 'Hz',
            icon: Icons.speed_rounded,
          ),
          _Criterion(
            name: 'Response Time',
            type: 'Cost',
            unit: 'ms',
            icon: Icons.timer_outlined,
          ),
          _Criterion(
            name: 'Resolution',
            type: 'Benefit',
            unit: 'MP',
            icon: Icons.high_quality_outlined,
          ),
        ];
      default:
        return [
          _Criterion(
            name: 'Price',
            type: 'Cost',
            unit: 'Rp',
            icon: Icons.payments_outlined,
          ),
          _Criterion(
            name: 'RAM',
            type: 'Benefit',
            unit: 'GB',
            icon: Icons.memory_rounded,
          ),
          _Criterion(
            name: 'Storage',
            type: 'Benefit',
            unit: 'GB',
            icon: Icons.storage_rounded,
          ),
          _Criterion(
            name: 'Weight',
            type: 'Cost',
            unit: 'kg',
            icon: Icons.scale_outlined,
          ),
        ];
    }
  }

  List<_OptionItem> _initialOptions() {
    if (_category.toLowerCase() == 'education') {
      // Real course, certification, and company names are used as alternatives.
      // Numeric values are illustrative prototype data, not verified live quotes.
      switch (_normalizedSubcategory) {
        case 'course':
        case 'courses':
        case 'kursus':
          return [
            _OptionItem(
              name: 'Google Data Analytics Professional Certificate',
              values: {'Price': '500000', 'Rating': '4.7', 'Duration': '180'},
            ),
            _OptionItem(
              name: 'The Complete Python Bootcamp (Udemy)',
              values: {'Price': '899000', 'Rating': '4.6', 'Duration': '22'},
            ),
            _OptionItem(
              name: 'Belajar Dasar Pemrograman Web (Dicoding)',
              values: {'Price': '500000', 'Rating': '4.8', 'Duration': '60'},
            ),
            _OptionItem(
              name: 'Meta Social Media Marketing (Coursera)',
              values: {'Price': '750000', 'Rating': '4.7', 'Duration': '120'},
            ),
            _OptionItem(
              name: 'IBM Data Science Professional Certificate',
              values: {'Price': '650000', 'Rating': '4.6', 'Duration': '160'},
            ),
          ];
        case 'certification':
        case 'certifications':
        case 'sertifikasi':
          return [
            _OptionItem(
              name: 'AWS Certified Cloud Practitioner',
              values: {
                'Exam Fee': '1500000',
                'Industry Recognition': '4.5',
                'Validity': '3',
                'Preparation Time': '40',
              },
            ),
            _OptionItem(
              name: 'CompTIA A+',
              values: {
                'Exam Fee': '3500000',
                'Industry Recognition': '4.5',
                'Validity': '3',
                'Preparation Time': '120',
              },
            ),
            _OptionItem(
              name: 'Cisco Certified Network Associate (CCNA)',
              values: {
                'Exam Fee': '5500000',
                'Industry Recognition': '4.8',
                'Validity': '3',
                'Preparation Time': '120',
              },
            ),
            _OptionItem(
              name: 'Project Management Professional (PMP)',
              values: {
                'Exam Fee': '8000000',
                'Industry Recognition': '5',
                'Validity': '3',
                'Preparation Time': '150',
              },
            ),
            _OptionItem(
              name: 'Google Cloud Professional Cloud Architect',
              values: {
                'Exam Fee': '3000000',
                'Industry Recognition': '4.7',
                'Validity': '2',
                'Preparation Time': '100',
              },
            ),
          ];
        case 'internship':
        case 'internships':
        case 'tempat magang':
          return [
            _OptionItem(
              name: 'Telkom Indonesia Internship',
              values: {
                'Monthly Allowance': '2500000',
                'Field Relevance': '4.5',
                'Company Rating': '4.3',
                'Distance': '8',
              },
            ),
            _OptionItem(
              name: 'Bank Central Asia (BCA) Internship',
              values: {
                'Monthly Allowance': '3000000',
                'Field Relevance': '4.4',
                'Company Rating': '4.5',
                'Distance': '12',
              },
            ),
            _OptionItem(
              name: 'GoTo Group Internship',
              values: {
                'Monthly Allowance': '3500000',
                'Field Relevance': '4.7',
                'Company Rating': '4.2',
                'Distance': '10',
              },
            ),
            _OptionItem(
              name: 'Traveloka Internship',
              values: {
                'Monthly Allowance': '3000000',
                'Field Relevance': '4.6',
                'Company Rating': '4.1',
                'Distance': '15',
              },
            ),
            _OptionItem(
              name: 'Deloitte Indonesia Internship',
              values: {
                'Monthly Allowance': '2800000',
                'Field Relevance': '4.5',
                'Company Rating': '4.4',
                'Distance': '7',
              },
            ),
          ];
      }
    }

    if (_category.toLowerCase() == 'fashion') {
      // Real product/model names are used. Numeric values are illustrative
      // prototype data and should be verified for the exact product variant.
      switch (_normalizedSubcategory) {
        case 'shoes':
        case 'sepatu':
          return [
            _OptionItem(
              name: "Nike Air Force 1 '07",
              values: {
                'Price': '1599000',
                'Rating': '4.7',
                'Comfort': '4.5',
                'Weight': '400',
              },
            ),
            _OptionItem(
              name: 'Adidas Runfalcon 3.0',
              values: {
                'Price': '899000',
                'Rating': '4.5',
                'Comfort': '4.4',
                'Weight': '280',
              },
            ),
            _OptionItem(
              name: 'Converse Chuck Taylor All Star',
              values: {
                'Price': '999000',
                'Rating': '4.6',
                'Comfort': '4.0',
                'Weight': '350',
              },
            ),
          ];
        case 'bags':
        case 'bag':
        case 'tas':
          return [
            _OptionItem(
              name: 'JanSport SuperBreak',
              values: {
                'Price': '799000',
                'Rating': '4.6',
                'Capacity': '26',
                'Weight': '300',
              },
            ),
            _OptionItem(
              name: 'Herschel Classic Backpack',
              values: {
                'Price': '1099000',
                'Rating': '4.5',
                'Capacity': '26',
                'Weight': '500',
              },
            ),
            _OptionItem(
              name: 'Fjällräven Kånken Classic',
              values: {
                'Price': '1699000',
                'Rating': '4.7',
                'Capacity': '16',
                'Weight': '300',
              },
            ),
          ];
        case 'tops':
        case 'top':
        case 'atasan':
        case 'atasan baju':
          return [
            _OptionItem(
              name: 'Uniqlo AIRism Cotton Oversized T-Shirt',
              values: {
                'Price': '199000',
                'Rating': '4.7',
                'Fabric Quality': '4.6',
              },
            ),
            _OptionItem(
              name: 'H&M Regular Fit Cotton T-Shirt',
              values: {
                'Price': '149900',
                'Rating': '4.3',
                'Fabric Quality': '4.1',
              },
            ),
            _OptionItem(
              name: 'Zara Basic Cotton T-Shirt',
              values: {
                'Price': '299900',
                'Rating': '4.4',
                'Fabric Quality': '4.3',
              },
            ),
          ];
        case 'bottoms':
        case 'bottom':
        case 'bawahan':
          return [
            _OptionItem(
              name: "Levi's 501 Original Jeans",
              values: {
                'Price': '1499000',
                'Rating': '4.7',
                'Comfort': '4.4',
                'Fabric Quality': '4.7',
              },
            ),
            _OptionItem(
              name: 'Uniqlo Wide Fit Jeans',
              values: {
                'Price': '599000',
                'Rating': '4.5',
                'Comfort': '4.5',
                'Fabric Quality': '4.4',
              },
            ),
            _OptionItem(
              name: 'H&M Straight Regular Jeans',
              values: {
                'Price': '499900',
                'Rating': '4.2',
                'Comfort': '4.1',
                'Fabric Quality': '4.0',
              },
            ),
          ];
        case 'watches':
        case 'watch':
        case 'jam tangan':
          return [
            _OptionItem(
              name: 'Casio G-Shock DW-5600UE',
              values: {
                'Price': '1399000',
                'Rating': '4.8',
                'Water Resistance': '200',
                'Warranty': '1',
              },
            ),
            _OptionItem(
              name: 'Casio AE-1200WH',
              values: {
                'Price': '499000',
                'Rating': '4.6',
                'Water Resistance': '100',
                'Warranty': '1',
              },
            ),
            _OptionItem(
              name: 'Seiko 5 Sports SRPD55',
              values: {
                'Price': '4200000',
                'Rating': '4.7',
                'Water Resistance': '100',
                'Warranty': '1',
              },
            ),
          ];
      }
    }

    // Product names are real examples; specifications/prices are illustrative
    // prototype values and must be verified for the exact local variant.
    switch (_normalizedSubcategory) {
      case 'laptop':
        return [
          _OptionItem(
            name: 'Lenovo IdeaPad Slim 5',
            values: {
              'Price': '12999000',
              'RAM': '16',
              'Storage': '512',
              'Weight': '1.46',
            },
          ),
          _OptionItem(
            name: 'ASUS Vivobook 14',
            values: {
              'Price': '8999000',
              'RAM': '16',
              'Storage': '512',
              'Weight': '1.40',
            },
          ),
          _OptionItem(
            name: 'Acer Aspire 5',
            values: {
              'Price': '7999000',
              'RAM': '8',
              'Storage': '512',
              'Weight': '',
            },
          ),
        ];
      case 'smartphone':
        return [
          _OptionItem(
            name: 'iPhone 17',
            values: {
              'Price': '17999000',
              'RAM': '8',
              'Storage': '256',
              'Battery Capacity': '3692',
              'Main Camera': '48',
            },
          ),
          _OptionItem(
            name: 'Samsung Galaxy S25',
            values: {
              'Price': '13999000',
              'RAM': '12',
              'Storage': '256',
              'Battery Capacity': '4000',
              'Main Camera': '50',
            },
          ),
          _OptionItem(
            name: 'Xiaomi Redmi Note 14 Pro 5G',
            values: {
              'Price': '4499000',
              'RAM': '8',
              'Storage': '256',
              'Battery Capacity': '5110',
              'Main Camera': '200',
            },
          ),
        ];
      case 'tablet':
        return [
          _OptionItem(
            name: 'Samsung Galaxy Tab S10+',
            values: {
              'Price': '16999000',
              'RAM': '12',
              'Storage': '256',
              'Battery Capacity': '10090',
              'Screen Size': '12.4',
            },
          ),
          _OptionItem(
            name: 'Apple iPad Air 11-inch',
            values: {
              'Price': '9999000',
              'RAM': '8',
              'Storage': '128',
              'Battery Capacity': '7606',
              'Screen Size': '11',
            },
          ),
          _OptionItem(
            name: 'Xiaomi Redmi Pad Pro',
            values: {
              'Price': '4499000',
              'RAM': '8',
              'Storage': '256',
              'Battery Capacity': '10000',
              'Screen Size': '12.1',
            },
          ),
        ];
      case 'pc':
        return [
          _OptionItem(
            name: 'HP Pavilion Desktop TP01',
            values: {
              'Price': '11999000',
              'RAM': '16',
              'Storage': '1000',
              'CPU Score': '27000',
            },
          ),
          _OptionItem(
            name: 'Lenovo IdeaCentre 5',
            values: {
              'Price': '13999000',
              'RAM': '16',
              'Storage': '1000',
              'CPU Score': '30000',
            },
          ),
          _OptionItem(
            name: 'Dell Inspiron Desktop',
            values: {
              'Price': '10999000',
              'RAM': '8',
              'Storage': '512',
              'CPU Score': '22000',
            },
          ),
        ];
      case 'monitor':
        return [
          _OptionItem(
            name: 'LG UltraGear 27GP850-B',
            values: {
              'Price': '5999000',
              'Screen Size': '27',
              'Refresh Rate': '165',
              'Response Time': '1',
              'Resolution': '3.7',
            },
          ),
          _OptionItem(
            name: 'Samsung Odyssey G5 27-inch',
            values: {
              'Price': '4299000',
              'Screen Size': '27',
              'Refresh Rate': '165',
              'Response Time': '1',
              'Resolution': '3.7',
            },
          ),
          _OptionItem(
            name: 'ASUS TUF Gaming VG249Q1A',
            values: {
              'Price': '2499000',
              'Screen Size': '23.8',
              'Refresh Rate': '165',
              'Response Time': '1',
              'Resolution': '2.1',
            },
          ),
        ];
      default:
        return [
          _OptionItem(name: 'Option A', values: {}),
          _OptionItem(name: 'Option B', values: {}),
          _OptionItem(name: 'Option C', values: {}),
        ];
    }
  }

  List<_Suggestion> _initialSuggestions() {
    if (_category.toLowerCase() == 'education') {
      switch (_normalizedSubcategory) {
        case 'course':
        case 'courses':
        case 'kursus':
          return [
            _Suggestion(
              name: 'Instructor Experience',
              users: 8,
              unit: 'years',
              category: 'Popular',
            ),
            _Suggestion(
              name: 'Completion Rate',
              users: 5,
              unit: '%',
              category: 'Popular',
            ),
            _Suggestion(
              name: 'Certificate Included',
              users: 3,
              unit: 'yes/no',
              category: 'New',
            ),
          ];
        case 'certification':
        case 'certifications':
        case 'sertifikasi':
          return [
            _Suggestion(
              name: 'Exam Retake Availability',
              users: 6,
              unit: 'yes/no',
              category: 'Popular',
            ),
            _Suggestion(
              name: 'Study Materials',
              users: 4,
              unit: 'items',
              category: 'Popular',
            ),
            _Suggestion(
              name: 'Pass Rate',
              users: 7,
              unit: '%',
              category: 'New',
            ),
          ];
        case 'internship':
        case 'internships':
        case 'tempat magang':
          return [
            _Suggestion(
              name: 'Mentorship Quality',
              users: 8,
              unit: 'scale 1-5',
              category: 'Popular',
            ),
            _Suggestion(
              name: 'Work Mode',
              users: 5,
              unit: 'onsite/hybrid/remote',
              category: 'Popular',
            ),
            _Suggestion(
              name: 'Hiring Opportunity',
              users: 6,
              unit: '%',
              category: 'New',
            ),
          ];
      }
    }

    if (_category.toLowerCase() == 'fashion') {
      switch (_normalizedSubcategory) {
        case 'shoes':
        case 'sepatu':
          return [
            _Suggestion(
              name: 'Durability',
              users: 8,
              unit: 'scale 1-5',
              category: 'Popular',
            ),
            _Suggestion(
              name: 'Grip',
              users: 6,
              unit: 'scale 1-5',
              category: 'Popular',
            ),
            _Suggestion(
              name: 'Material',
              users: 5,
              unit: 'material type',
              category: 'New',
            ),
          ];
        case 'bags':
        case 'bag':
        case 'tas':
          return [
            _Suggestion(
              name: 'Water Resistance',
              users: 8,
              unit: 'scale 1-5',
              category: 'Popular',
            ),
            _Suggestion(
              name: 'Number of Compartments',
              users: 6,
              unit: 'count',
              category: 'Popular',
            ),
            _Suggestion(
              name: 'Laptop Compartment',
              users: 5,
              unit: 'yes/no',
              category: 'New',
            ),
          ];
        case 'tops':
        case 'top':
        case 'atasan':
        case 'atasan baju':
          return [
            _Suggestion(
              name: 'Fit',
              users: 8,
              unit: 'regular/slim/oversized',
              category: 'Popular',
            ),
            _Suggestion(
              name: 'Breathability',
              users: 6,
              unit: 'scale 1-5',
              category: 'Popular',
            ),
            _Suggestion(
              name: 'Color Options',
              users: 5,
              unit: 'count',
              category: 'New',
            ),
          ];
        case 'bottoms':
        case 'bottom':
        case 'bawahan':
          return [
            _Suggestion(
              name: 'Stretchability',
              users: 8,
              unit: 'scale 1-5',
              category: 'Popular',
            ),
            _Suggestion(
              name: 'Fit',
              users: 6,
              unit: 'fit type',
              category: 'Popular',
            ),
            _Suggestion(
              name: 'Pocket Count',
              users: 5,
              unit: 'count',
              category: 'New',
            ),
          ];
        case 'watches':
        case 'watch':
        case 'jam tangan':
          return [
            _Suggestion(
              name: 'Movement Type',
              users: 8,
              unit: 'quartz/automatic',
              category: 'Popular',
            ),
            _Suggestion(
              name: 'Battery Life',
              users: 6,
              unit: 'years',
              category: 'Popular',
            ),
            _Suggestion(
              name: 'Display Type',
              users: 5,
              unit: 'analog/digital',
              category: 'New',
            ),
          ];
      }
    }

    switch (_normalizedSubcategory) {
      case 'laptop':
        return [
          _Suggestion(
            name: 'Battery Life',
            users: 8,
            unit: 'hours',
            category: 'Popular',
          ),
          _Suggestion(
            name: 'Screen Size',
            users: 7,
            unit: 'inches',
            category: 'Popular',
          ),
          _Suggestion(
            name: 'Warranty',
            users: 6,
            unit: 'months',
            category: 'Popular',
          ),
          _Suggestion(
            name: 'Display Resolution',
            users: 5,
            unit: 'pixels',
            category: 'New',
          ),
        ];
      case 'smartphone':
        return [
          _Suggestion(
            name: 'Display Size',
            users: 8,
            unit: 'inches',
            category: 'Popular',
          ),
          _Suggestion(
            name: 'Refresh Rate',
            users: 7,
            unit: 'Hz',
            category: 'Popular',
          ),
          _Suggestion(
            name: 'Water Resistance',
            users: 6,
            unit: 'IP rating',
            category: 'Popular',
          ),
          _Suggestion(
            name: 'Wireless Charging',
            users: 5,
            unit: 'yes/no',
            category: 'New',
          ),
        ];
      case 'tablet':
        return [
          _Suggestion(
            name: 'Stylus Support',
            users: 8,
            unit: 'yes/no',
            category: 'Popular',
          ),
          _Suggestion(
            name: 'Screen Resolution',
            users: 7,
            unit: 'pixels',
            category: 'Popular',
          ),
          _Suggestion(
            name: 'Cellular Connectivity',
            users: 5,
            unit: 'yes/no',
            category: 'New',
          ),
        ];
      case 'pc':
        return [
          _Suggestion(
            name: 'GPU Score',
            users: 8,
            unit: 'benchmark points',
            category: 'Popular',
          ),
          _Suggestion(
            name: 'Power Supply',
            users: 6,
            unit: 'watts',
            category: 'Popular',
          ),
          _Suggestion(
            name: 'Upgradeability',
            users: 5,
            unit: 'scale 1-5',
            category: 'New',
          ),
        ];
      case 'monitor':
        return [
          _Suggestion(
            name: 'Panel Type',
            users: 8,
            unit: 'IPS/VA/OLED',
            category: 'Popular',
          ),
          _Suggestion(
            name: 'Adaptive Sync',
            users: 6,
            unit: 'yes/no',
            category: 'Popular',
          ),
          _Suggestion(
            name: 'HDR Support',
            users: 5,
            unit: 'yes/no',
            category: 'New',
          ),
        ];
      default:
        return [
          _Suggestion(
            name: 'Warranty',
            users: 5,
            unit: 'months',
            category: 'Popular',
          ),
          _Suggestion(
            name: 'Rating',
            users: 4,
            unit: 'scale 1-5',
            category: 'New',
          ),
        ];
    }
  }

  // ============================================================
  // SUGGESTED CRITERIA
  // ============================================================

  final Map<String, GlobalKey> _suggestionKeys = {};

  _Suggestion? _activeSuggestion;
  TextEditingController? _popoverUnitController;

  String _popoverSelectedType = 'Benefit';
  String _selectedSuggestionCategory = 'Popular';

  bool _showIncompleteOnly = false;
  bool _showAllOptions = false;

  int get _incompleteCount => _options.where(_isIncomplete).length;

  int get _displayedOptionCount {
    if (_category.toLowerCase() == 'education' ||
        _category.toLowerCase() == 'fashion') {
      return _options.length;
    }

    // Target option counts for each Technology subcategory.
    // The count adjusts automatically when an option is added or deleted.
    final targetCount = switch (_normalizedSubcategory) {
      'laptop' => 15,
      'smartphone' => 10,
      'tablet' => 10,
      'pc' => 5,
      'monitor' => 5,
      _ => 0,
    };

    return targetCount + _options.length - 3;
  }

  int get _selectedSuggestionCount => _suggestedCriteria
      .where((item) => item.category == _selectedSuggestionCategory)
      .length;

  List<_Suggestion> get _visibleSuggestions => _suggestedCriteria
      .where((item) => item.category == _selectedSuggestionCategory)
      .toList();

  bool _isIncomplete(_OptionItem option) {
    return _criteria.any((criterion) {
      if (option.unavailable.contains(criterion.name)) {
        return false;
      }

      return (option.values[criterion.name] ?? '').trim().isEmpty;
    });
  }

  List<_OptionItem> get _visibleOptions {
    if (_showIncompleteOnly) {
      return _options.where(_isIncomplete).toList();
    }

    return _options;
  }

  List<_OptionItem> get _optionsToDisplay {
    if (_showAllOptions || _visibleOptions.length <= 3) {
      return _visibleOptions;
    }

    return _visibleOptions.take(3).toList();
  }

  @override
  void dispose() {
    _popoverUnitController?.dispose();
    _popoverUnitController = null;
    super.dispose();
  }

  void _disposePopoverControllerAfterFrame() {
    final controller = _popoverUnitController;
    _popoverUnitController = null;

    if (controller != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.dispose();
      });
    }
  }

  void _closeSuggestionPopover() {
    if (_activeSuggestion == null) return;

    setState(() {
      _activeSuggestion = null;
    });

    _disposePopoverControllerAfterFrame();
  }

  void _selectSuggestionCategory(String category) {
    final closesActive =
        _activeSuggestion != null && _activeSuggestion!.category != category;

    setState(() {
      _selectedSuggestionCategory = category;

      if (closesActive) {
        _activeSuggestion = null;
      }
    });

    if (closesActive) {
      _disposePopoverControllerAfterFrame();
    }
  }

  // ============================================================
  // SCREEN
  // ============================================================

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
                      _buildStatistics(),
                      const SizedBox(height: 22),
                      _buildCriteriaSection(),
                      const SizedBox(height: 24),
                      _buildSuggestionsSection(),
                      const SizedBox(height: 24),
                      _buildOptionsSection(),
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
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 12),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: _purple,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.subcategory,
                  style: AppTypography.sectionTitle.copyWith(
                    color: AppColors.primaryDark,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Manage criteria and options in '
                  '${widget.subcategory}',
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

  // ============================================================
  // STATISTICS
  // ============================================================

  Widget _buildStatistics() {
    return Row(
      children: [
        _statCard('${_criteria.length}', 'Criteria', incomplete: false),
        const SizedBox(width: 8),
        _statCard('$_displayedOptionCount', 'Options', incomplete: false),
        const SizedBox(width: 8),
        _statCard('$_incompleteCount', 'Incomplete', incomplete: true),
      ],
    );
  }

  Widget _statCard(String value, String label, {required bool incomplete}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
        decoration: BoxDecoration(
          gradient: incomplete
              ? null
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFA18DE1), Color(0xFF634A9E)],
                ),
          color: incomplete ? _yellow : null,
          borderRadius: BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: incomplete ? _dark : Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                color: incomplete ? _dark : Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CRITERIA
  // ============================================================

  Widget _buildCriteriaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Criteria'),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _criteria.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 14,
            childAspectRatio: 1.04,
          ),
          itemBuilder: (context, index) {
            return _criterionCard(_criteria[index]);
          },
        ),
        const SizedBox(height: 14),
        _primaryButton(
          label: '+ Add Criteria',
          onPressed: _showAddCriterionDialog,
        ),
      ],
    );
  }

  Widget _criterionCard(_Criterion criterion) {
    final isBenefit = criterion.type == 'Benefit';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E8F5),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white, width: 1.3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.13),
            blurRadius: 7,
            offset: const Offset(1, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(criterion.icon, color: _dark, size: 29),
              ),
              const Spacer(),
              Icon(
                isBenefit
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                color: isBenefit ? _green : _orange,
                size: 30,
              ),
            ],
          ),
          const Spacer(),
          Text(
            criterion.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.sectionInnerTitle.copyWith(
              color: _dark,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${criterion.type} · ${criterion.unit}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.smallSemibold.copyWith(
              color: AppColors.textTertiary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SUGGESTED BY USER
  // ============================================================

  Widget _buildSuggestionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.playlist_add_rounded, color: _dark, size: 23),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                'Suggested by User',
                style: AppTypography.sectionInnerTitle.copyWith(
                  color: _dark,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: _dark,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$_selectedSuggestionCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          'Many users added these on their own. '
          'Add the ones that fit.',
          style: AppTypography.extraSmallSemibold.copyWith(
            color: AppColors.textTertiary,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _suggestionCategoryChip(
              label: 'Popular',
              count: _suggestedCriteria
                  .where((item) => item.category == 'Popular')
                  .length,
              selected: _selectedSuggestionCategory == 'Popular',
              onTap: () => _selectSuggestionCategory('Popular'),
            ),
            const SizedBox(width: 8),
            _suggestionCategoryChip(
              label: 'New',
              count: _suggestedCriteria
                  .where((item) => item.category == 'New')
                  .length,
              selected: _selectedSuggestionCategory == 'New',
              onTap: () => _selectSuggestionCategory('New'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ..._visibleSuggestions.map((suggestion) {
          final key = _suggestionKeys.putIfAbsent(
            suggestion.name,
            () => GlobalKey(),
          );

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _suggestionCard(suggestion, key: key),
          );
        }),
        if (_visibleSuggestions.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F7FC),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFB4A5E8)),
            ),
            child: const Text(
              'No suggestions available in this category.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _dark, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _suggestionCategoryChip({
    required String label,
    required int count,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? _dark : const Color(0xFFF4F0F7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _dark, width: selected ? 0 : 0.9),
        ),
        child: Text(
          '$label · $count',
          style: TextStyle(
            color: selected ? Colors.white : _dark,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _suggestionCard(_Suggestion suggestion, {Key? key}) {
    final isSelected = _activeSuggestion?.name == suggestion.name;

    if (isSelected && _popoverUnitController != null) {
      return SizedBox(
        key: key,
        width: double.infinity,
        child: _suggestionPopoverCard(
          suggestion: suggestion,
          unitController: _popoverUnitController!,
          selectedType: _popoverSelectedType,
          onTypeChanged: (value) {
            setState(() {
              _popoverSelectedType = value;
            });
          },
          onCancel: _closeSuggestionPopover,
          onAdd: () => _addSuggestedCriterion(suggestion),
          onCollapse: _closeSuggestionPopover,
        ),
      );
    }

    return SizedBox(
      key: key,
      width: double.infinity,
      child: CustomPaint(
        foregroundPainter: const _DashedRoundedBorderPainter(
          color: Color(0xFF8F7AE4),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: () => _openSuggestionPopover(suggestion),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              constraints: const BoxConstraints(minHeight: 52),
              padding: const EdgeInsets.fromLTRB(12, 7, 12, 7),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F2FA).withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDAD3FF),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.13),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: _dark,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          suggestion.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.smallSemibold.copyWith(
                            color: _dark,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Benefit · ${suggestion.unit}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.extraSmallSemibold.copyWith(
                            color: AppColors.textTertiary,
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // FIX: USER COUNT CENTERED ABOVE THE DROPDOWN
                  SizedBox(
                    width: 48,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 48,
                          child: Text(
                            '${suggestion.users} Users',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: AppTypography.extraSmallSemibold.copyWith(
                              color: AppColors.textTertiary,
                              fontSize: 8,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        SizedBox(
                          width: 48,
                          height: 18,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color(0xFF70417A),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.white,
                              size: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // OPEN / CLOSE SUGGESTION EDITOR
  // ============================================================

  void _openSuggestionPopover(_Suggestion suggestion) {
    if (_activeSuggestion?.name == suggestion.name) {
      _closeSuggestionPopover();
      return;
    }

    final previousController = _popoverUnitController;

    final controller = TextEditingController(text: suggestion.unit);

    setState(() {
      _activeSuggestion = suggestion;
      _popoverUnitController = controller;
      _popoverSelectedType = 'Benefit';
    });

    if (previousController != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        previousController.dispose();
      });
    }
  }

  void _addSuggestedCriterion(_Suggestion suggestion) {
    final unit = _popoverUnitController?.text.trim() ?? '';

    if (unit.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a unit.')));
      return;
    }

    final duplicate = _criteria.any(
      (criterion) =>
          criterion.name.toLowerCase() == suggestion.name.toLowerCase(),
    );

    if (duplicate) {
      _closeSuggestionPopover();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This criterion already exists.')),
      );

      return;
    }

    final newCriterion = _Criterion(
      name: suggestion.name,
      type: _popoverSelectedType,
      unit: unit,
      icon: _iconForCriterion(suggestion.name),
    );

    setState(() {
      _criteria.add(newCriterion);

      _suggestedCriteria.removeWhere((item) => item.name == suggestion.name);

      _activeSuggestion = null;
    });

    _disposePopoverControllerAfterFrame();
  }

  // ============================================================
  // EXPANDED SUGGESTION CARD
  // ============================================================

  Widget _suggestionPopoverCard({
    required _Suggestion suggestion,
    required TextEditingController unitController,
    required String selectedType,
    required ValueChanged<String> onTypeChanged,
    required VoidCallback onCancel,
    required VoidCallback onAdd,
    required VoidCallback onCollapse,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 10, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFAFD),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _dark, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: const Color(0xFFDAD3FF),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: _dark,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  suggestion.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.smallSemibold.copyWith(
                    color: _dark,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              InkWell(
                onTap: onCollapse,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 54,
                  height: 19,
                  decoration: BoxDecoration(
                    color: const Color(0xFF70417A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white,
                    size: 19,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Type',
                style: TextStyle(
                  color: _dark,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              _suggestedBadge(),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _palePurple,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _typeButton(
                    label: 'Benefit',
                    icon: Icons.arrow_upward_rounded,
                    color: _green,
                    selected: selectedType == 'Benefit',
                    onTap: () => onTypeChanged('Benefit'),
                  ),
                ),
                Expanded(
                  child: _typeButton(
                    label: 'Cost',
                    icon: Icons.arrow_downward_rounded,
                    color: _orange,
                    selected: selectedType == 'Cost',
                    onTap: () => onTypeChanged('Cost'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              const Text(
                'Unit',
                style: TextStyle(
                  color: _dark,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              _suggestedBadge(),
            ],
          ),
          const SizedBox(height: 5),
          TextField(
            controller: unitController,
            textInputAction: TextInputAction.done,
            style: const TextStyle(color: _dark, fontSize: 12),
            decoration: InputDecoration(
              hintText: 'e.g. hours, GB, years',
              hintStyle: const TextStyle(color: _sheetHint, fontSize: 12),
              filled: true,
              fillColor: const Color(0xFFF0EFF8),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 9,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _dark, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _dark, width: 1.4),
              ),
            ),
          ),
          const SizedBox(height: 9),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: _yellow,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  color: Color(0xFF9B5700),
                  size: 17,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Criteria cannot be edited after saving. '
                    '$_displayedOptionCount options will need a value for it.',
                    style: const TextStyle(
                      color: Color(0xFF80500C),
                      fontSize: 9,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 29,
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _dark,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      side: const BorderSide(color: _dark, width: 1),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 22),
              Expanded(
                child: SizedBox(
                  height: 29,
                  child: FilledButton(
                    onPressed: onAdd,
                    style: FilledButton.styleFrom(
                      backgroundColor: _dark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'ADD',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _suggestedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFDCD5FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'suggested',
        style: TextStyle(
          color: Color(0xFF7155A8),
          fontSize: 8,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _typeButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 30,
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: label == 'Benefit' ? const Color(0xFF246C32) : _orange,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForCriterion(String name) {
    switch (name.toLowerCase()) {
      case 'battery life':
        return Icons.battery_charging_full_rounded;
      case 'screen size':
      case 'screen sizes':
        return Icons.monitor_outlined;
      case 'warranty':
        return Icons.verified_outlined;
      case 'refresh rate':
        return Icons.speed_rounded;
      case 'display resolution':
        return Icons.high_quality_outlined;
      case 'battery capacity':
        return Icons.battery_full_rounded;
      case 'price':
      case 'exam fee':
      case 'monthly allowance':
        return Icons.payments_outlined;
      case 'rating':
      case 'company rating':
      case 'pass rate':
        return Icons.star_rounded;
      case 'duration':
      case 'preparation time':
        return Icons.schedule_rounded;
      case 'industry recognition':
        return Icons.workspace_premium_rounded;
      case 'validity':
        return Icons.event_available_rounded;
      case 'field relevance':
        return Icons.school_outlined;
      case 'distance':
        return Icons.directions_walk_rounded;
      case 'instructor experience':
        return Icons.person_outline_rounded;
      case 'completion rate':
        return Icons.check_circle_outline_rounded;
      case 'certificate included':
        return Icons.verified_outlined;
      case 'exam retake availability':
        return Icons.replay_rounded;
      case 'study materials':
        return Icons.menu_book_rounded;
      case 'mentorship quality':
        return Icons.support_agent_rounded;
      case 'work mode':
        return Icons.laptop_chromebook_rounded;
      case 'hiring opportunity':
        return Icons.work_outline_rounded;
      case 'comfort':
        return Icons.weekend_outlined;
      case 'fabric quality':
      case 'material':
        return Icons.checkroom_rounded;
      case 'capacity':
        return Icons.inventory_2_outlined;
      case 'water resistance':
        return Icons.water_drop_outlined;
      default:
        return Icons.tune_rounded;
    }
  }

  // ============================================================
  // OPTIONS
  // ============================================================

  Widget _buildOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Options'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _filterChip(
              label: 'All · $_displayedOptionCount',
              selected: !_showIncompleteOnly,
              onTap: () {
                setState(() {
                  _showIncompleteOnly = false;
                  _showAllOptions = false;
                });
              },
            ),
            _filterChip(
              label: 'Incomplete · $_incompleteCount',
              selected: _showIncompleteOnly,
              onTap: () {
                setState(() {
                  _showIncompleteOnly = true;
                  _showAllOptions = false;
                });
              },
              selectedBackground: _yellow,
              selectedTextColor: const Color(0xFF8A6916),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white, width: 1.3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 7,
                offset: const Offset(1, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              for (final option in _optionsToDisplay) _optionRow(option),
              if (_visibleOptions.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Text('No options match this filter.'),
                ),
              if (_visibleOptions.length > 3) ...[
                const Divider(height: 22),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showAllOptions = !_showAllOptions;
                    });
                  },
                  child: Text(
                    _showAllOptions
                        ? 'Show less  ⌃'
                        : 'See all ${_visibleOptions.length} options  ⌄',
                    style: AppTypography.extraSmallSemibold.copyWith(
                      color: _dark,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        _primaryButton(label: '+ Add Option', onPressed: _showAddOptionDialog),
      ],
    );
  }

  Widget _optionRow(_OptionItem option) {
    final incomplete = _isIncomplete(option);

    IconData icon = Icons.laptop_mac_rounded;
    final normalizedSubcategory = _normalizedSubcategory;

    if (_category.toLowerCase() == 'education') {
      if (normalizedSubcategory == 'course' ||
          normalizedSubcategory == 'courses' ||
          normalizedSubcategory == 'kursus') {
        icon = Icons.menu_book_rounded;
      } else if (normalizedSubcategory == 'certification' ||
          normalizedSubcategory == 'certifications' ||
          normalizedSubcategory == 'sertifikasi') {
        icon = Icons.workspace_premium_rounded;
      } else if (normalizedSubcategory == 'internship' ||
          normalizedSubcategory == 'internships' ||
          normalizedSubcategory == 'tempat magang') {
        icon = Icons.work_outline_rounded;
      }
    } else if (normalizedSubcategory == 'smartphone') {
      icon = Icons.smartphone_rounded;
    } else if (normalizedSubcategory == 'tablet') {
      icon = Icons.tablet_mac_rounded;
    } else if (normalizedSubcategory == 'monitor') {
      icon = Icons.monitor_rounded;
    } else if (normalizedSubcategory == 'pc') {
      icon = Icons.desktop_windows_rounded;
    } else if (normalizedSubcategory == 'shoes' ||
        normalizedSubcategory == 'sepatu' ||
        normalizedSubcategory == 'bottoms' ||
        normalizedSubcategory == 'bottom' ||
        normalizedSubcategory == 'bawahan') {
      icon = Icons.checkroom_rounded;
    } else if (normalizedSubcategory == 'bags' ||
        normalizedSubcategory == 'bag' ||
        normalizedSubcategory == 'tas') {
      icon = Icons.shopping_bag_outlined;
    } else if (normalizedSubcategory == 'tops' ||
        normalizedSubcategory == 'top' ||
        normalizedSubcategory == 'atasan' ||
        normalizedSubcategory == 'atasan baju') {
      icon = Icons.checkroom_rounded;
    } else if (normalizedSubcategory == 'watches' ||
        normalizedSubcategory == 'watch' ||
        normalizedSubcategory == 'jam tangan') {
      icon = Icons.watch_outlined;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E3F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: _purple, size: 21),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.smallSemibold.copyWith(
                    color: _dark,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  incomplete ? 'Incomplete values' : 'All values complete',
                  style: AppTypography.extraSmallSemibold.copyWith(
                    fontSize: 9,
                    color: incomplete ? _orange : _green,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit option',
            onPressed: () => _showAddOptionDialog(existing: option),
            icon: const Icon(Icons.edit_outlined, color: _dark, size: 19),
          ),
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    Color? selectedBackground,
    Color? selectedTextColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? (selectedBackground ?? _dark)
              : const Color(0xFFF0EAF8),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: AppTypography.extraSmallSemibold.copyWith(
            color: selected ? (selectedTextColor ?? Colors.white) : _dark,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FIGMA-STYLE BOTTOM SHEET HELPERS
  // ============================================================

  Widget _sheetHeading({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _dark,
            fontSize: 19,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF929097),
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _sheetFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: _dark,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _sheetTextField({
    required TextEditingController controller,
    required String hintText,
    bool enabled = true,
    bool missing = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    final borderColor = missing
        ? _orange
        : (enabled ? _sheetBorder : const Color(0xFFDFE0E8));

    return TextField(
      controller: controller,
      enabled: enabled,
      textCapitalization: textCapitalization,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: const TextStyle(
        color: _dark,
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: enabled ? _sheetHint : const Color(0xFF92939A),
          fontSize: 13,
        ),
        filled: true,
        fillColor: enabled ? _sheetFieldFill : _sheetDisabledFill,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: missing ? 1.3 : 1),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDFE0E8), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: missing ? _orange : _sheetBorder,
            width: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _criterionTypeCard({
    required String type,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final isBenefit = type == 'Benefit';
    final accent = isBenefit ? _green : _orange;
    final subtitle = isBenefit ? 'Higher is better' : 'Lower is better';
    final arrow = isBenefit
        ? Icons.arrow_upward_rounded
        : Icons.arrow_downward_rounded;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.fromLTRB(9, 9, 7, 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF3F0F8) : _sheetFieldFill,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: selected ? _sheetBorder : const Color(0xFFA9A6B0),
            width: selected ? 1.1 : 0.9,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected ? _sheetBorder : const Color(0xFF9B9BA2),
                  size: 19,
                ),
                const SizedBox(width: 5),
                Icon(arrow, color: accent, size: 17),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    type,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isBenefit ? const Color(0xFF246C32) : _orange,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFF77717C),
                fontSize: 9,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetActionButtons({
    required String cancelLabel,
    required String saveLabel,
    required VoidCallback onCancel,
    required VoidCallback onSave,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 120,
          height: 38,
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: _dark,
              side: const BorderSide(color: _dark, width: 1),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              shape: const StadiumBorder(),
            ),
            child: Text(
              cancelLabel,
              maxLines: 1,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 120,
          height: 38,
          child: FilledButton(
            onPressed: onSave,
            style: FilledButton.styleFrom(
              backgroundColor: _dark,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              shape: const StadiumBorder(),
            ),
            child: Text(
              saveLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sheetFrame({
    required BuildContext sheetContext,
    required String title,
    required String subtitle,
    required Widget content,
    required Widget footer,
    required double maxHeightFactor,
  }) {
    final media = MediaQuery.of(sheetContext);

    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: media.size.height * maxHeightFactor,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: _sheetBackground,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 21, 25, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _sheetHeading(title: title, subtitle: subtitle),
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(28, 17, 25, 10),
                    child: content,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    28,
                    7,
                    25,
                    18 + media.padding.bottom,
                  ),
                  child: footer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ADD CRITERIA BOTTOM SHEET
  // ============================================================

  Future<void> _showAddCriterionDialog() async {
    final nameController = TextEditingController();
    final unitController = TextEditingController();
    String selectedType = 'Benefit';

    final result = await showModalBottomSheet<_Criterion>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (sheetContext) {
        return _SheetControllerOwner(
          controllers: [nameController, unitController],
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              return _sheetFrame(
                sheetContext: sheetContext,
                title: 'Add Criteria',
                subtitle: '$_category · ${widget.subcategory}',
                maxHeightFactor: 0.78,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: _yellow,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.lock_outline_rounded,
                            color: Color(0xFF9B5700),
                            size: 20,
                          ),
                          const SizedBox(width: 9),
                          const Expanded(
                            child: Text(
                              'Criteria cannot be edited after saving. '
                              'Please check the name, type and unit first.',
                              style: TextStyle(
                                color: Color(0xFF80500C),
                                fontSize: 10,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 17),
                    _sheetFieldLabel('Criteria Name'),
                    const SizedBox(height: 6),
                    _sheetTextField(
                      controller: nameController,
                      hintText: 'Enter criteria name',
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 14),
                    _sheetFieldLabel('Type'),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Expanded(
                          child: _criterionTypeCard(
                            type: 'Benefit',
                            selected: selectedType == 'Benefit',
                            onTap: () {
                              setSheetState(() {
                                selectedType = 'Benefit';
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _criterionTypeCard(
                            type: 'Cost',
                            selected: selectedType == 'Cost',
                            onTap: () {
                              setSheetState(() {
                                selectedType = 'Cost';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _sheetFieldLabel('Unit'),
                    const SizedBox(height: 6),
                    _sheetTextField(
                      controller: unitController,
                      hintText: 'e.g. hours, GB, years',
                    ),
                  ],
                ),
                footer: _sheetActionButtons(
                  cancelLabel: 'Cancel',
                  saveLabel: 'Save Criteria',
                  onCancel: () {
                    FocusScope.of(sheetContext).unfocus();
                    Navigator.pop(sheetContext);
                  },
                  onSave: () {
                    final name = nameController.text.trim();
                    final unit = unitController.text.trim();

                    if (name.isEmpty || unit.isEmpty) return;

                    FocusScope.of(sheetContext).unfocus();
                    Navigator.pop(
                      sheetContext,
                      _Criterion(
                        name: name,
                        type: selectedType,
                        unit: unit,
                        icon: _iconForCriterion(name),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );

    if (result == null || !mounted) return;

    final duplicate = _criteria.any(
      (item) => item.name.toLowerCase() == result.name.toLowerCase(),
    );

    if (duplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This criterion already exists.')),
      );
      return;
    }

    setState(() {
      _criteria.add(result);
    });
  }

  // ============================================================
  // ADD / EDIT OPTION BOTTOM SHEET
  // ============================================================

  Future<void> _showAddOptionDialog({_OptionItem? existing}) async {
    final nameController = TextEditingController(text: existing?.name ?? '');

    final controllers = <String, TextEditingController>{
      for (final criterion in _criteria)
        criterion.name: TextEditingController(
          text: existing?.values[criterion.name] ?? '',
        ),
    };

    final unavailable = <String>{...?existing?.unavailable};

    final result = await showModalBottomSheet<_OptionItem>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (sheetContext) {
        return _SheetControllerOwner(
          controllers: [nameController, ...controllers.values],
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              final missingCriteria = existing == null
                  ? <String>{}
                  : _criteria
                        .where(
                          (criterion) =>
                              !unavailable.contains(criterion.name) &&
                              (controllers[criterion.name]?.text
                                      .trim()
                                      .isEmpty ??
                                  true),
                        )
                        .map((criterion) => criterion.name)
                        .toSet();

              return _sheetFrame(
                sheetContext: sheetContext,
                title: existing == null ? 'Add Option' : 'Edit Option',
                subtitle: existing == null
                    ? '${widget.subcategory} · $_category'
                    : '${existing.name} · ${widget.subcategory}',
                maxHeightFactor: 0.90,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sheetFieldLabel('Option Name'),
                    const SizedBox(height: 6),
                    _sheetTextField(
                      controller: nameController,
                      hintText: 'e.g ASUS Vivobook 14',
                      textCapitalization: TextCapitalization.words,
                    ),
                    if (existing != null) ...[
                      const SizedBox(height: 7),
                      Text(
                        'The values below follow the criteria of '
                        '${widget.subcategory}. Fill each one, or mark it as '
                        'Not available.',
                        style: const TextStyle(
                          color: Color(0xFF929097),
                          fontSize: 10,
                          height: 1.3,
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    for (final criterion in _criteria) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _sheetFieldLabel(
                              '${criterion.name} (${criterion.unit})',
                            ),
                          ),
                          const SizedBox(width: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 19,
                                height: 22,
                                child: Checkbox(
                                  value: unavailable.contains(criterion.name),
                                  onChanged: (checked) {
                                    setSheetState(() {
                                      if (checked == true) {
                                        unavailable.add(criterion.name);
                                        controllers[criterion.name]!.clear();
                                      } else {
                                        unavailable.remove(criterion.name);
                                      }
                                    });
                                  },
                                  activeColor: _dark,
                                  side: const BorderSide(
                                    color: Color(0xFF92939A),
                                    width: 1.2,
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Not Available',
                                style: TextStyle(
                                  color: Color(0xFF252329),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      _sheetTextField(
                        controller: controllers[criterion.name]!,
                        hintText: unavailable.contains(criterion.name)
                            ? 'Not Available'
                            : 'Enter ${criterion.name}',
                        enabled: !unavailable.contains(criterion.name),
                        missing: missingCriteria.contains(criterion.name),
                        keyboardType: TextInputType.text,
                        onChanged: (_) => setSheetState(() {}),
                      ),
                      if (missingCriteria.contains(criterion.name)) ...[
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              color: _orange,
                              size: 15,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Missing. Fill it in or mark it as Not available.',
                                style: const TextStyle(
                                  color: _orange,
                                  fontSize: 10,
                                  height: 1.25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 12),
                    ],
                    if (existing != null) ...[
                      const SizedBox(height: 1),
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            FocusScope.of(sheetContext).unfocus();
                            Navigator.pop(
                              sheetContext,
                              _OptionItem.delete(existing.name),
                            );
                          },
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 17,
                          ),
                          label: const Text(
                            'Delete Option',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red, width: 1),
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
                footer: _sheetActionButtons(
                  cancelLabel: 'Cancel',
                  saveLabel: 'Save Option',
                  onCancel: () {
                    FocusScope.of(sheetContext).unfocus();
                    Navigator.pop(sheetContext);
                  },
                  onSave: () {
                    final name = nameController.text.trim();

                    if (name.isEmpty) return;

                    FocusScope.of(sheetContext).unfocus();
                    Navigator.pop(
                      sheetContext,
                      _OptionItem(
                        name: name,
                        values: {
                          for (final criterion in _criteria)
                            criterion.name: controllers[criterion.name]!.text
                                .trim(),
                        },
                        unavailable: Set<String>.from(unavailable),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );

    if (result == null || !mounted) return;

    setState(() {
      if (result.isDeleted) {
        _options.removeWhere((option) => option.name == result.name);
      } else {
        final index = existing == null ? -1 : _options.indexOf(existing);

        if (index >= 0) {
          _options[index] = result;
        } else {
          _options.add(result);
        }
      }
    });
  }

  // ============================================================
  // SHARED WIDGETS
  // ============================================================

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.sectionInnerTitle.copyWith(
        color: _purple,
        fontSize: 17,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _primaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 43,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: _dark,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

// ============================================================
// DATA MODELS
// ============================================================

class _SheetControllerOwner extends StatefulWidget {
  const _SheetControllerOwner({required this.controllers, required this.child});

  final List<TextEditingController> controllers;
  final Widget child;

  @override
  State<_SheetControllerOwner> createState() => _SheetControllerOwnerState();
}

class _SheetControllerOwnerState extends State<_SheetControllerOwner> {
  @override
  void dispose() {
    for (final controller in widget.controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _Criterion {
  const _Criterion({
    required this.name,
    required this.type,
    required this.unit,
    required this.icon,
  });

  final String name;
  final String type;
  final String unit;
  final IconData icon;
}

class _Suggestion {
  const _Suggestion({
    required this.name,
    required this.users,
    required this.unit,
    required this.category,
  });

  final String name;
  final int users;
  final String unit;
  final String category;
}

class _OptionItem {
  _OptionItem({
    required this.name,
    required this.values,
    Set<String>? unavailable,
    this.isDeleted = false,
  }) : unavailable = unavailable ?? {};

  factory _OptionItem.delete(String name) {
    return _OptionItem(name: name, values: const {}, isDeleted: true);
  }

  final String name;
  final Map<String, String> values;
  final Set<String> unavailable;
  final bool isDeleted;
}

// ============================================================
// DASHED BORDER FOR SUGGESTION CARDS
// ============================================================

class _DashedRoundedBorderPainter extends CustomPainter {
  const _DashedRoundedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(rect.deflate(1), const Radius.circular(18)),
      );

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;

      while (distance < metric.length) {
        final end = math.min(distance + 7, metric.length).toDouble();

        canvas.drawPath(metric.extractPath(distance, end), paint);

        distance += 12;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedBorderPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
