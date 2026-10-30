import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mychoice_app/screens/user/comparison/mf08_manual_choice_structuring_screen.dart';
import 'package:mychoice_app/screens/user/decision/result_screen.dart';
import 'package:mychoice_app/screens/guest/mf04_public_home_catalog_screen.dart';
import 'package:mychoice_app/screens/onboarding/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('onboarding opens the public MF04 catalog', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    await tester.pumpWidget(
      MaterialApp(
        home: const OnboardingScreen(),
        routes: {'/public-catalog': (_) => const Mf04PublicHomeCatalogScreen()},
      ),
    );

    await tester.tap(find.text('Jelajahi katalog tanpa login'));
    await tester.pumpAndSettle();

    expect(find.text('Pilih kategori'), findsOneWidget);
    expect(find.text('Pilihan tersimpan'), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('Basic MF04 blocks a fourth choice and shows Premium notice', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    await tester.pumpWidget(
      const MaterialApp(home: Mf04PublicHomeCatalogScreen()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Technology'));
    await tester.pumpAndSettle();

    for (var index = 0; index < 3; index++) {
      await tester.tap(find.byType(CheckboxListTile).at(index));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.byType(CheckboxListTile).at(3));
    await tester.pumpAndSettle();

    expect(find.text('Batas pilihan tercapai'), findsOneWidget);
    expect(
      find.text(
        'Paket Basic maksimal 3 opsi. '
        'Upgrade ke Premium untuk memilih hingga 10 opsi.',
      ),
      findsOneWidget,
    );
    expect(find.text('Pilihan dibandingkan (3/3)'), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('result screen opens MF08 with its ranked choices', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const ResultScreen(
          category: 'Education',
          subcategory: 'Course',
          choices: [
            RankedChoice(name: 'Course A', score: 0.9),
            RankedChoice(name: 'Course B', score: 0.75),
          ],
        ),
        routes: {
          '/mf08-comparison': (context) {
            final arguments =
                ModalRoute.of(context)!.settings.arguments
                    as Mf08ComparisonArguments;
            return Mf08ComparisonScreen(
              choices: arguments.choices,
              category: arguments.category,
              subcategory: arguments.subcategory,
            );
          },
        },
      ),
    );

    await tester.tap(find.text('View Comparison'));
    await tester.pumpAndSettle();

    expect(find.text('Comparing 2 options'), findsOneWidget);
    expect(find.textContaining('Course A'), findsWidgets);
    expect(find.textContaining('Course B'), findsWidgets);
    expect(find.text('Course'), findsOneWidget);
  });
}
