import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/utils/pref_helper.dart';
import 'package:smartware/features/auth/models/user_model.dart';
import 'package:smartware/features/client/profile/models/client_onboarding_repo.dart';
import 'package:smartware/features/client/profile/models/client_prefrences_model.dart';
import 'package:smartware/features/product/controllers/product_controller.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class ClientHomeController extends GetxController {
  UserModel? user;
  final _repo = ClientOnboardingRepo();
  final productController = Get.find<ProductController>();

  final currentPreferences = <FacilityCategoryModel>[].obs;
  final selectedCategories = <String>[].obs;
  final isLoadingPreferences = false.obs;

  String get userName => user?.firstName ?? '';
  @override
  void onInit() {
    super.onInit();
    loadUser();
    getPreferences();
  }

 Future<void> loadUser() async {
  final data = await PrefHelper.getUserData();

  print('👤 USER JSON 👉 $data');

  if (data == null || data.isEmpty) {
    print('❌ No user data found');
    return;
  }

  user = UserModel.fromJson(data);

  print('✅ USER NAME 👉 ${user!.firstName}');
}

  String get greeting {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good morning'.tr;
    }

    if (hour < 18) {
      return 'Good afternoon'.tr;
    }

    return 'Good evening'.tr;
  }

  Future<void> getPreferences() async {
    try {
      isLoadingPreferences.value = true;

      final result = await _repo.getPreferences();

      currentPreferences.assignAll(result.preferences);

      final categories = result.preferences
          .map((preference) => preference.name)
          .toList();

      selectedCategories.assignAll(categories);

      productController.businessCategories.assignAll(categories);
      productController.applyFilters();

      debugPrint('🏪 Home business categories: $categories');
      debugPrint(
        '📦 Displayed products: '
        '${productController.displayedProducts.length}',
      );
    } catch (e) {
      debugPrint('❌ Get preferences failed: $e');

      AppSnackbar.show(
        title: 'Error'.tr,
        message: e is ApiError
            ? e.message
            : 'Your profile is not completed',
      );
    } finally {
      isLoadingPreferences.value = false;
    }
  }
}
