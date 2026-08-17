import 'package:get/get.dart';

import 'package:smartware/core/routes/app_routes.dart';
import 'package:smartware/core/utils/pref_helper.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();

    print('🚀 SPLASH CONTROLLER READY');

    checkAuth();
  }

  Future<void> checkAuth() async {
    print('');
    print('════════ SPLASH AUTH CHECK ════════');

    await Future.delayed(const Duration(seconds: 2));

    // ============================================================
    // GET TOKEN
    // ============================================================

    final token = await PrefHelper.getToken();

    print('🔑 TOKEN = $token');

    if (token == null || token.isEmpty) {
      print('❌ NO TOKEN');
      print('➡️ GOING TO ONBOARDING');

      Get.offAllNamed(AppRoutes.onboarding);
      return;
    }

    print('✅ TOKEN EXISTS');

    // ============================================================
    // GET ROLE
    // ============================================================

    final role = await PrefHelper.getUserRole();

    print('🎭 STORED ROLE = $role');

    if (role == null || role.isEmpty) {
      print('❌ ROLE IS NULL');
      print('🧹 Clearing invalid session');

      await PrefHelper.clearUser();

      Get.offAllNamed(AppRoutes.onboarding);
      return;
    }

    // ============================================================
    // NAVIGATE
    // ============================================================

    switch (role) {
      case 'client':
        print('➡️ GOING TO CLIENT');
        Get.offAllNamed(AppRoutes.clientRoot);
        break;

      case 'warehouseAdmin':
        print('➡️ GOING TO OWNER');
        Get.offAllNamed(AppRoutes.ownerRoot);
        break;

      case 'worker':
        print('➡️ GOING TO WORKER');
        Get.offAllNamed(AppRoutes.workerSignup);
        break;

      default:
        print('❌ UNKNOWN ROLE: $role');
        print('🧹 Clearing invalid session');

        await PrefHelper.clearUser();

        Get.offAllNamed(AppRoutes.onboarding);
    }

    print('════════ SPLASH AUTH CHECK END ════════');
    print('');
  }
}