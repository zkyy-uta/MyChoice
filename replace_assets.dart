#!/usr/bin/env dart

/// Auto-Replace Assets Script
/// Replaces placeholder code with real asset paths
///
/// Usage: dart replace_assets.dart

import 'dart:io';

void main() {
  print('🎨 MyChoice Assets Auto-Replacer\n');

  // Check if assets exist
  print('📋 Checking assets...');
  final assetsExist = checkAssets();

  if (!assetsExist) {
    print('\n⚠️  Some assets are missing!');
    print('Please copy all required files to assets/ folder first.');
    print('See ASSETS_NAMING_GUIDE.md for details.\n');
    return;
  }

  print('✅ All assets found!\n');

  // Replace code
  print('🔄 Replacing placeholders...\n');

  try {
    replaceSplashLogo();
    replaceOnboardingIllustrations();
    replaceDashboardAvatar();

    print('\n✅ All replacements complete!');
    print('\n📱 Next steps:');
    print('1. Run: flutter pub get');
    print('2. Run: flutter run -d chrome --release');
    print('3. Or press R (capital) for Hot Restart\n');
  } catch (e) {
    print('\n❌ Error: $e');
    print('Please replace manually. See REPLACE_ASSETS_GUIDE.md\n');
  }
}

bool checkAssets() {
  final assets = [
    'mychoice_app/assets/images/logo_mychoice.png',
    'mychoice_app/assets/illustrations/onboarding_welcome.png',
    'mychoice_app/assets/illustrations/onboarding_understand.png',
    'mychoice_app/assets/illustrations/onboarding_compare.png',
    'mychoice_app/assets/illustrations/onboarding_result.png',
    'mychoice_app/assets/images/avatar_default.png',
  ];

  var allExist = true;
  for (var asset in assets) {
    final exists = File(asset).existsSync();
    final status = exists ? '✅' : '❌';
    print('  $status $asset');
    if (!exists) allExist = false;
  }

  return allExist;
}

void replaceSplashLogo() {
  print('📝 1. Updating Splash Screen logo...');

  final file = File('mychoice_app/lib/screens/splash/splash_screen.dart');
  if (!file.existsSync()) {
    print('   ⚠️  File not found: ${file.path}');
    return;
  }

  var content = file.readAsStringSync();

  // Replace icon placeholder with Image.asset
  content = content.replaceAll(
    RegExp(
      r'child: const Icon\(\s*Icons\.help_outline_rounded,\s*size: 80,\s*color: AppColors\.primary88,\s*\)',
      multiLine: true,
    ),
    '''child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'assets/images/logo_mychoice.png',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.help_outline_rounded,
                          size: 80,
                          color: AppColors.primary88,
                        );
                      },
                    ),
                  )''',
  );

  file.writeAsStringSync(content);
  print('   ✅ Splash screen updated');
}

void replaceOnboardingIllustrations() {
  print('📝 2. Updating Onboarding illustrations...');

  // Update onboarding_screen.dart (data)
  final screenFile = File(
    'mychoice_app/lib/screens/onboarding/onboarding_screen.dart',
  );
  if (screenFile.existsSync()) {
    var content = screenFile.readAsStringSync();

    content = content
        .replaceAll(
          "illustration: '🐕'",
          "illustration: 'assets/illustrations/onboarding_welcome.png'",
        )
        .replaceAll(
          "illustration: '📋'",
          "illustration: 'assets/illustrations/onboarding_understand.png'",
        )
        .replaceAll(
          "illustration: '⚖️'",
          "illustration: 'assets/illustrations/onboarding_compare.png'",
        )
        .replaceAll(
          "illustration: '📊'",
          "illustration: 'assets/illustrations/onboarding_result.png'",
        );

    screenFile.writeAsStringSync(content);
    print('   ✅ Onboarding data updated');
  }

  // Update onboarding_page.dart (widget)
  final pageFile = File(
    'mychoice_app/lib/screens/onboarding/widgets/onboarding_page.dart',
  );
  if (pageFile.existsSync()) {
    var content = pageFile.readAsStringSync();

    // Replace emoji display with Image.asset
    content = content.replaceAll(
      RegExp(
        r'Container\(\s*width: 200,\s*height: 200,.*?Text\(\s*data\.illustration,\s*style: const TextStyle\(fontSize: 80\),\s*\),\s*\),\s*\)',
        multiLine: true,
        dotAll: true,
      ),
      '''Image.asset(
            data.illustration,
            width: 250,
            height: 250,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Icon(Icons.image_outlined, size: 80, color: Colors.white54),
                ),
              );
            },
          )''',
    );

    pageFile.writeAsStringSync(content);
    print('   ✅ Onboarding widget updated');
  }
}

void replaceDashboardAvatar() {
  print('📝 3. Updating Dashboard avatar...');

  final file = File('mychoice_app/lib/screens/dashboard/dashboard_screen.dart');
  if (!file.existsSync()) {
    print('   ⚠️  File not found: ${file.path}');
    return;
  }

  var content = file.readAsStringSync();

  // Replace NetworkImage with AssetImage
  content = content.replaceAll(
    "backgroundImage: const NetworkImage(\n    'https://i.pravatar.cc/150?img=1',\n  ),",
    "backgroundImage: const AssetImage(\n    'assets/images/avatar_default.png',\n  ),",
  );

  file.writeAsStringSync(content);
  print('   ✅ Dashboard avatar updated');
}
