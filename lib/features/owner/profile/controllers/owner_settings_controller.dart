import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/utils/pref_helper.dart';
import 'package:smartware/features/auth/models/auth_repo.dart';


class OwnerSettingsController extends GetxController {
  final isDarkMode = false.obs;
  final isNotificationsEnabled = true.obs;

  final isLoading = false.obs;

  final AuthRepo _authRepo = AuthRepo();

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  // ============================================================
  // THEME
  // ============================================================

  Future<void> _loadTheme() async {
    final saved = await PrefHelper.getTheme();

    if (saved == "dark") {
      isDarkMode.value = true;
      Get.changeThemeMode(ThemeMode.dark);
    } else if (saved == "light") {
      isDarkMode.value = false;
      Get.changeThemeMode(ThemeMode.light);
    } else {
      isDarkMode.value = Get.isDarkMode;
    }
  }

  Future<void> changeTheme(ThemeMode mode) async {
    final isDark = mode == ThemeMode.dark;

    isDarkMode.value = isDark;

    Get.changeThemeMode(mode);

    await PrefHelper.saveTheme(
      isDark ? "dark" : "light",
    );
  }

  // ============================================================
  // DELETE ACCOUNT
  // ============================================================

  Future<void> deleteAccount() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      print('════════ OWNER DELETE ACCOUNT ════════');
      print('📤 Sending delete account request...');

      await _authRepo.deleteAccount();

      print('✅ Account deleted successfully');

      // Clear local data after successful deletion.
      await PrefHelper.clearUser();

      // Go back to login screen.
      Get.offAllNamed('/login');

    } catch (e) {
      print('❌ DELETE ACCOUNT ERROR: $e');

      Get.snackbar(
        'Error'.tr,
        e is ApiError
            ? e.message
            : 'Failed to delete account'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}