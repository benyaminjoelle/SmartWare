import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/features/auth/models/user_model.dart';
import 'package:smartware/features/client/profile/models/client_onboarding_repo.dart';
import 'package:smartware/features/client/profile/models/client_prefrences_model.dart';
import 'package:smartware/features/product/controllers/product_controller.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class ClientHomeController extends GetxController {
  late UserModel user;

  final _repo = ClientOnboardingRepo();
  final productController = Get.find<ProductController>();

  final currentPreferences = <FacilityCategoryModel>[].obs;
  final selectedCategories = <String>[].obs;
  final isLoadingPreferences = false.obs;

  String get userName => user.firstName;

  @override
  void onInit() {
    super.onInit();
    loadUser();
    getPreferences();
  }

  void loadUser() {
    final data = GetStorage().read('user_data') ?? {};
    user = UserModel.fromJson(Map<String, dynamic>.from(data));
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
        title: 'Error',
        message: e is ApiError
            ? e.message
            : 'Failed to load your preferences.',
      );
    } finally {
      isLoadingPreferences.value = false;
    }
  }
}