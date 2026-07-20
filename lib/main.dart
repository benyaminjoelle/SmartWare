import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/core/constants/theme.dart';
import 'package:smartware/core/utils/pref_helper.dart';
import 'package:smartware/localization/app_translation.dart';
import 'package:get_storage/get_storage.dart';

import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final lang = await PrefHelper.getLanguage();
  final savedTheme = await PrefHelper.getTheme();
  // savedTheme: "dark" | "light" | "system" | null

  runApp(MyApp(initialLang: lang, savedTheme: savedTheme));
}

class MyApp extends StatelessWidget {
  final String initialLang;
  final String? savedTheme;

  const MyApp({super.key, required this.initialLang, required this.savedTheme});

  ThemeMode get themeMode {
    switch (savedTheme) {
      case "dark":
        return ThemeMode.dark;
      case "light":
        return ThemeMode.light;
      default:
        return ThemeMode.system; // 🌗 your requirement
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      // THEMES
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // LOCALIZATION
      translations: AppTranslation(),
      locale: Locale(initialLang),
      fallbackLocale: const Locale('en'),

      // ROUTES
      initialRoute: AppRoutes.onboarding,
      getPages: AppPages.pages,
    );
  }
}
