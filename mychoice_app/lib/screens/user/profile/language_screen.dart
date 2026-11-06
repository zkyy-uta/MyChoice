import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/mobile_background.dart';
import '../../../core/widgets/page_app_bar.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return MobileBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const PageAppBar(title: 'Language'),
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
          children: [
            Text(
              'Select your language',
              style: AppTypography.sectionInnerTitle,
            ),
            const SizedBox(height: AppSpacing.md),
            RadioGroup<String>(
              groupValue: _selectedLanguage,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedLanguage = value);
                }
              },
              child: Column(
                children: [
                  for (final language in const ['English', 'Bahasa Indonesia'])
                    Card(
                      color: Colors.white,
                      child: RadioListTile<String>(
                        value: language,
                        title: Text(
                          language,
                          style: AppTypography.smallSemibold,
                        ),
                        activeColor: AppColors.primaryDark,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
