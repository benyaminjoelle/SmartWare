import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import 'package:smartware/core/constants/business_product_mapping.dart';
import 'package:smartware/core/constants/client_business_types.dart';
import 'package:smartware/core/constants/client_products.dart';
import 'package:smartware/core/network/api_error.dart';

import 'package:smartware/features/client/profile/models/client_onboarding_repo.dart';
import 'package:smartware/features/client/profile/models/client_prefrences_model.dart';
import 'package:smartware/features/client/profile/widgets/product_type_model.dart';

import 'package:smartware/widgets/app_dialog.dart';

class ClientProfileCompletionController extends GetxController {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  final businessNameController = TextEditingController();

  // ============================================================
  // REPOSITORY
  // ============================================================

  final ClientOnboardingRepo _onboardingRepo =
      ClientOnboardingRepo();

  // ============================================================
  // STEPS
  // ============================================================

  final currentStep = 0.obs;

  final int totalSteps = 3;

  final List<int> stepProgress = [
    33,
    66,
    100,
  ];

  // ============================================================
  // PROFILE COMPLETION
  // ============================================================

  final profileCompletion = 33.obs;

  static const int maxCompletion = 100;

  double get completionPercent =>
      profileCompletion.value / maxCompletion;

  bool get isProfileComplete =>
      profileCompletion.value >= maxCompletion;

  String get completionText {
    final value = profileCompletion.value;

    if (value >= 100) {
      return "Profile Complete";
    }

    if (value >= 80) {
      return "Almost Done";
    }

    if (value >= 50) {
      return "Keep Going";
    }

    return "Complete Your Profile";
  }

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    businessNameController.addListener(
      _onBusinessNameChanged,
    );
  }

  void _onBusinessNameChanged() {
    businessName.value =
        businessNameController.text.trim();
  }

  // ============================================================
  // STEP NAVIGATION
  // ============================================================

  Future<void> nextStep() async {
    if (!canGoNext) {
      return;
    }

    // STEP 1
    // Save preferences before moving to step 2.
    if (currentStep.value == 0) {
      final success = await savePreferences();

      if (!success) {
        return;
      }
    }

    if (currentStep.value < totalSteps - 1) {
      currentStep.value++;

      _syncProgress();
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;

      _syncProgress();
    }
  }

  bool get isFirstStep =>
      currentStep.value == 0;

  bool get isLastStep =>
      currentStep.value == totalSteps - 1;

  // ============================================================
  // STEP → PROGRESS SYNC
  // ============================================================

  void _syncProgress() {
    profileCompletion.value =
        stepProgress[currentStep.value];
  }

  // ============================================================
  // STEP 1: PREFERENCES DATA
  // ============================================================

  final businessName = ''.obs;

  final selectedBusinessType = ''.obs;

  final isProductsExpanded = false.obs;

  final preferredLanguage = 'English'.obs;

  final preferredCurrency = 'USD'.obs;

  final selectedProducts = <String>[].obs;

  // ============================================================
  // API STATE
  // ============================================================

  final isSavingPreferences = false.obs;

  final savedPreferences =
      Rxn<ClientPreferencesModel>();

  // ============================================================
  // BUSINESS TYPES / PRODUCTS
  // ============================================================

  final businessTypes = BusinessTypes.all;

  final List<ProductTypeModel> allProducts =
      ProductTypes.all;

  final Map<String, List<String>> businessProductMap =
      BusinessProductMapping.map;

  // ============================================================
  // PRODUCT SELECTION
  // ============================================================

  void toggleProduct(String id) {
    if (selectedProducts.contains(id)) {
      selectedProducts.remove(id);
    } else {
      selectedProducts.add(id);
    }

    selectedProducts.refresh();

    print(
      '📦 Selected Products: '
      '$selectedProducts',
    );
  }

  // ============================================================
  // BUSINESS TYPE SELECTION
  // ============================================================

  void selectBusinessType(String id) {
    if (selectedBusinessType.value == id) {
      return;
    }

    selectedBusinessType.value = id;

    selectedProducts.clear();

    isProductsExpanded.value = false;
  }

  void clearBusinessType() {
    selectedBusinessType.value = '';

    selectedProducts.clear();

    isProductsExpanded.value = false;
  }

  // ============================================================
  // AVAILABLE PRODUCTS
  // ============================================================

  List<ProductTypeModel> get availableProducts {
    final allowedIds =
        businessProductMap[
              selectedBusinessType.value
            ] ??
            [];

    return allProducts
        .where(
          (product) =>
              allowedIds.contains(product.id),
        )
        .toList();
  }

  // ============================================================
  // SAVE STEP 1: PREFERENCES
  // ============================================================

  Future<bool> savePreferences() async {
    try {
      isSavingPreferences.value = true;

      print('');
      print(
        '════════ SAVE PREFERENCES START ════════',
      );

      // ========================================================
      // BUSINESS NAME
      // ========================================================

      final facilityName =
          businessNameController.text.trim();

      print(
        '🏢 Facility Name: "$facilityName"',
      );

      print(
        '🏢 Facility Name Empty: '
        '${facilityName.isEmpty}',
      );

      // ========================================================
      // VALIDATE BUSINESS NAME
      // ========================================================

      if (facilityName.isEmpty) {
        Get.snackbar(
          'Missing Information',
          'Please enter your business name.',
        );

        return false;
      }

      // ========================================================
      // VALIDATE BUSINESS TYPE
      // ========================================================

      if (selectedBusinessType.value.isEmpty) {
        Get.snackbar(
          'Missing Information',
          'Please select your business type.',
        );

        return false;
      }

      // ========================================================
      // VALIDATE PRODUCTS
      // ========================================================

      if (selectedProducts.isEmpty) {
        Get.snackbar(
          'Missing Information',
          'Please select at least one product category.',
        );

        return false;
      }

      // ========================================================
      // DEBUG REQUEST
      // ========================================================

      print('');
      print('📤 Sending preferences to backend...');
      print(
        '🏢 Facility Name: $facilityName',
      );
      print(
        '🎭 Role: client',
      );
      print(
        '🏪 Business Type: '
        '${selectedBusinessType.value}',
      );
      print(
        '📦 Categories: '
        '${selectedProducts.toList()}',
      );

      // ========================================================
      // API CALL
      // ========================================================

      final result =
          await _onboardingRepo.savePreferences(
        facilityName: facilityName,
        role: 'client',
        businessType:
            selectedBusinessType.value,
        categories:
            selectedProducts.toList(),
      );

      // ========================================================
      // SAVE RESPONSE LOCALLY
      // ========================================================

      savedPreferences.value = result;

      print('');
      print(
        '════════ PREFERENCES RESPONSE ════════',
      );

      print(
        '💬 Message: ${result.message}',
      );

      print(
        '🏢 Facility ID: '
        '${result.facility.id}',
      );

      print(
        '🏢 Facility Name: '
        '${result.facility.facilityName}',
      );

      print(
        '🏪 Business Type: '
        '${result.facility.businessType}',
      );

      print(
        '📊 Facility Status: '
        '${result.facility.facilityStatus}',
      );

      print(
        '📦 Categories: '
        '${result.facility.categories.map(
              (e) => e.name,
            ).toList()}',
      );

      print(
        '════════ SAVE PREFERENCES SUCCESS ════════',
      );

      return true;
    } catch (e, stackTrace) {
      print('');
      print(
        '════════ SAVE PREFERENCES ERROR ════════',
      );

      print('❌ Error: $e');

      print(
        '❌ Type: ${e.runtimeType}',
      );

      print('❌ StackTrace:');
      print(stackTrace);

      print(
        '════════════════════════════════════════',
      );

      if (e is ApiError) {
        Get.snackbar(
          'Error',
          e.message,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to save preferences.',
        );
      }

      return false;
    } finally {
      isSavingPreferences.value = false;
    }
  }

  // ============================================================
  // STEP 2: LOCATION DATA
  // ============================================================

  final address = ''.obs;

  final city = ''.obs;

  final country = ''.obs;

  // ============================================================
  // STEP 3: DOCUMENTATION DATA
  // ============================================================

  final ownerIdUploaded = false.obs;

  final ownershipProofUploaded = false.obs;

  // ============================================================
  // DOCUMENT PICKER
  // ============================================================

  Future<void> pickDocument(String type) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'jpg',
        'jpeg',
        'png',
      ],
    );

    if (result != null &&
        result.files.single.path != null) {
      final filePath =
          result.files.single.path!;

      if (type == 'owner_id') {
        ownerIdUploaded.value = true;
      } else if (type == 'ownership_proof') {
        ownershipProofUploaded.value = true;
      }

      print(
        '📄 Selected file: $filePath',
      );

      print(
        '📍 Current step: '
        '${currentStep.value}',
      );

      print(
        '🪪 Owner ID: '
        '${ownerIdUploaded.value}',
      );

      print(
        '🏢 Ownership Proof: '
        '${ownershipProofUploaded.value}',
      );

      print(
        '➡️ Can next: $canGoNext',
      );
    }
  }

  // ============================================================
  // DOCUMENTATION ACTIONS
  // ============================================================

  void markOwnerIdUploaded() {
    ownerIdUploaded.value = true;
  }

  void markOwnershipProofUploaded() {
    ownershipProofUploaded.value = true;
  }

  void removeOwnerId() {
    ownerIdUploaded.value = false;
  }

  void removeOwnershipProof() {
    ownershipProofUploaded.value = false;
  }

  // ============================================================
  // VALIDATION
  // ============================================================
bool get canGoNext {
  switch (currentStep.value) {
    case 0:
      return businessNameController.text.trim().isNotEmpty &&
          selectedBusinessType.value.isNotEmpty &&
          selectedProducts.isNotEmpty;

    case 1:
      return ownerIdUploaded.value &&
          ownershipProofUploaded.value;

    case 2:
      return address.value.isNotEmpty &&
          city.value.isNotEmpty;

    default:
      return true;
  }
}

  // ============================================================
  // BACK HANDLING
  // ============================================================

  Future<void> handleBack() async {
    if (currentStep.value == 0) {
      Get.back();
      return;
    }

    final leave =
        await AppDialogs.showConfirmDialog(
      title: 'Leave Profile Completion?',
      message:
          'Your progress will remain saved. '
          'Do you want to leave the profile completion '
          'process or return to the previous step?',
      confirmText: 'Leave',
      cancelText: 'Previous Step',
    );

    if (leave == true) {
      Get.back();
    } else {
      previousStep();
    }
  }

  // ============================================================
  // RESET
  // ============================================================

  void reset() {
    currentStep.value = 0;

    profileCompletion.value = 33;

    businessNameController.clear();
    businessName.value = '';

    selectedBusinessType.value = '';

    isProductsExpanded.value = false;

    preferredLanguage.value = 'English';

    preferredCurrency.value = 'USD';

    selectedProducts.clear();

    savedPreferences.value = null;

    isSavingPreferences.value = false;

    address.value = '';

    city.value = '';

    country.value = '';

    ownerIdUploaded.value = false;

    ownershipProofUploaded.value = false;

    _syncProgress();
  }

  // ============================================================
  // DEMO
  // ============================================================

  void simulateProgress() {
    nextStep();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    businessNameController.dispose();

    super.onClose();
  }
}