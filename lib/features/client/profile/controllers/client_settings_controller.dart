import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/core/utils/pref_helper.dart';

class ClientSettingsController extends GetxController {
  final isDarkMode = false.obs;
  final isNotificationsEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final saved = await PrefHelper.getTheme();

    if (saved == "dark") {
      isDarkMode.value = true;
      Get.changeThemeMode(ThemeMode.dark);
    } else if (saved == "light") {
      isDarkMode.value = false;
      Get.changeThemeMode(ThemeMode.light);
    } else {
      isDarkMode.value = Get.isDarkMode; // system default fallback sync
    }
  }

  Future<void> changeTheme(ThemeMode mode) async {
    final isDark = mode == ThemeMode.dark;

    isDarkMode.value = isDark;

    Get.changeThemeMode(mode);

    await PrefHelper.saveTheme(isDark ? "dark" : "light");
  }
}
