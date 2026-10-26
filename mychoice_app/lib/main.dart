import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations (portrait only)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // api supabase
  await Supabase.initialize(
    url: 'https://mwthzxveegbjpiujolzb.supabase.co',
    publishableKey: 'sb_publishable_O5K1gJ3di3RIf17TJ48rFg_Mfo87PJn',
  );

  runApp(const MyChoiceApp());
}
