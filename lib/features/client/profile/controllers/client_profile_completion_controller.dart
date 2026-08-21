import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import 'package:smartware/core/constants/business_product_mapping.dart';
import 'package:smartware/core/constants/client_business_types.dart';
import 'package:smartware/core/constants/client_products.dart';
import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/utils/pref_helper.dart';
import 'package:smartware/features/client/profile/models/client_documents_model.dart';
import 'package:smartware/features/client/profile/models/client_onboarding_repo.dart';
import 'package:smartware/features/client/profile/models/client_prefrences_model.dart';

import 'package:smartware/features/client/profile/widgets/product_type_model.dart';
import 'package:smartware/features/product/controllers/product_controller.dart';

import 'package:smartware/widgets/app_dialog.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class ClientProfileCompletionController extends GetxController {

  // ============== CONTROLLERS ==============

  final businessNameController = TextEditingController();

  // REPOSITORY
  final ClientOnboardingRepo _onboardingRepo = ClientOnboardingRepo();
  final ProductController productController = Get.find<ProductController>();

  // ============ STEPS ==============
  final currentStep = 0.obs;
  final int totalSteps = 3;
  final profileCompletion = 0.obs;
  static const int maxCompletion = 100;
  double get completionPercent => profileCompletion.value / maxCompletion;
  bool get isProfileComplete => profileCompletion.value >= maxCompletion;

  String get completionText {
    switch (profileCompletion.value) {
      case 100:
        return 'Profile Complete';
      case 66:
        return 'Almost Done';
      case 33:
        return 'Keep Going';
      default:
        return 'Complete Your Profile';
    }
  }

  // ================ INIT ================
  @override
  Future<void> onInit() async {
    super.onInit();

    businessNameController.addListener(
      _onBusinessNameChanged,
    );
    initializedProfile();
  }
  Future<void> initializedProfile() async {
  await restoreOnboardingProgress();
}

  // Future<void> initializedProfile() async {
  //    await restoreOnboardingProgress();
  //    final facilityId = await PrefHelper.getClientFacilityId();
  //    if(facilityId != null && facilityId > 0){
  //     await getPreferences();
  //    } else {
  //     debugPrint('no facility yet.');
  //    }
    
  // }

  void _onBusinessNameChanged() {
    businessName.value =
        businessNameController.text.trim();
  }

  // ============================================================
  // RESTORE SAVED ONBOARDING STATE
  // ============================================================

  Future<void> restoreOnboardingProgress() async {
    try {
      final completion =
          await PrefHelper.getClientProfileCompletion();

      final savedStep =
          await PrefHelper.getClientOnboardingStep();

      final preferencesCompleted =
          await PrefHelper.isClientPreferencesCompleted();

      final documentsCompleted =
          await PrefHelper.areClientDocumentsCompleted();

      final profileCompleted =
          await PrefHelper.isClientProfileCompleted();

      final savedBusinessName =
          await PrefHelper.getClientBusinessName();

      final savedBusinessType =
          await PrefHelper.getClientBusinessType();

      final savedProducts =
          await PrefHelper.getClientSelectedProducts();

      // ----------------------------------------------------------
      // RESTORE BASIC DATA
      // ----------------------------------------------------------

      businessName.value = savedBusinessName;
      businessNameController.text = savedBusinessName;
      selectedBusinessType.value = savedBusinessType;
      selectedProducts.assignAll( savedProducts,);

      // ----------------------------------------------------------
      // RESTORE REAL COMPLETION STATE
      // ----------------------------------------------------------

      if (profileCompleted) {
        // Everything completed.
        profileCompletion.value = 100;
        currentStep.value = 2;
      } else if (documentsCompleted) {
        // Documents completed.
        profileCompletion.value = 66;
        currentStep.value = 2;
      } else if (preferencesCompleted) {
        // Preferences completed.
        profileCompletion.value = 33;
        currentStep.value = 1;
      } else {
        // Nothing completed yet.
        profileCompletion.value = completion;
        currentStep.value = savedStep;
      }

      // Safety check.
      if (currentStep.value < 0) {
        currentStep.value = 0;
      }

      if (currentStep.value >= totalSteps) {
        currentStep.value = totalSteps - 1;
      }

      debugPrint(
        'Onboarding restored: '
        '${profileCompletion.value}% | '
        'Step ${currentStep.value + 1}',
      );
    } catch (e) {
      debugPrint(
        'Failed to restore onboarding: $e',
      );

      currentStep.value = 0;
      profileCompletion.value = 0;
    }
  }

  // ============================================================
  // STEP NAVIGATION
  // ============================================================

  Future<void> nextStep() async {
    if (!canGoNext) {
      return;
    }

    // ==========================================================
    // STEP 1 → SAVE PREFERENCES
    // ==========================================================

    if (currentStep.value == 0) {
      final success =
          await savePreferences();
      if (!success) {
        return;
      }

      profileCompletion.value = 33;

      await PrefHelper.saveClientProfileCompletion(
        33,
      );

      await PrefHelper.saveClientOnboardingStep(
        1,
      );

      currentStep.value = 1;

      return;
    }

    // ==========================================================
    // STEP 2 → UPLOAD DOCUMENTS
    // ==========================================================

    if (currentStep.value == 1) {
      final success =
          await uploadOnboardingDocuments();

      if (!success) {
        return;
      }

      profileCompletion.value = 66;

      await PrefHelper.saveClientProfileCompletion(66,);
      await PrefHelper.saveClientOnboardingStep(2,);
      currentStep.value = 2;
      return;
    }

    // ==========================================================
    // STEP 3 → FINALIZE PROFILE
    // ==========================================================

    if (currentStep.value == 2) {
      final success =
          await completeFinalStep();

      if (!success) {
        return;
      }

      // completeFinalStep already saves 100%.
      profileCompletion.value = 100;

      return;
    }
  }

  // ============================================================
  // PREVIOUS STEP
  // ============================================================

  void previousStep() {
  if (currentStep.value <= 0) {
    return;
  }

  currentStep.value--;

  // Display progress based on the step the user is currently viewing.
  switch (currentStep.value) {
    case 0:
      profileCompletion.value = 0;
      break;

    case 1:
      profileCompletion.value = 33;
      break;

    case 2:
      profileCompletion.value = 66;
      break;
  }

  debugPrint(
    'Back to step ${currentStep.value + 1} | '
    'Progress: ${profileCompletion.value}%',
  );
}

  // ============================================================
  // STEP HELPERS
  // ============================================================

  bool get isFirstStep =>
      currentStep.value == 0;

  bool get isLastStep =>
      currentStep.value == totalSteps - 1;

  // ============================================================
  // STEP 1: PREFERENCES DATA
  // ============================================================

  final businessName = ''.obs;
  final selectedBusinessType = ''.obs;
  final isProductsExpanded = false.obs;

  final preferredLanguage =
      'English'.obs;

  final preferredCurrency =
      'USD'.obs;

  final selectedProducts =
      <String>[].obs;

  // ============================================================
  // PREFERENCES API STATE
  // ============================================================
  final isSavingPreferences =
      false.obs;

  final savedPreferences =
      Rxn<ClientPreferencesModel>();

  final isLoadingPreferences =
    false.obs;

  final currentPreferences =
    <FacilityCategoryModel>[].obs;

  // ============================================================
  // BUSINESS TYPES / PRODUCTS
  // ============================================================

  final businessTypes =
      BusinessTypes.all;

  final List<ProductTypeModel> allProducts =
      ProductTypes.all;

  final Map<String, List<String>>
      businessProductMap =
      BusinessProductMapping.map;

  // ============================================================
  // PRODUCT SELECTION
  // ============================================================

  void toggleCategory(String id) {
    if (selectedProducts.contains(id)) {
      selectedProducts.remove(id);
    } else {
      selectedProducts.add(id);
    }

    selectedProducts.refresh();

    print('📦 Selected categories: $selectedProducts',);
  }
 
  // ============= BUSINESS TYPE SELECTION ================ 

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

      final facilityName = businessNameController.text.trim();

      // --------------------------------------------------------
      // VALIDATION
      // --------------------------------------------------------

      if (facilityName.isEmpty) {
        AppSnackbar.show(
          title:'Missing Information',
          message:'Please enter your business name.',
        );

        return false;
      }

      if (selectedBusinessType.value.isEmpty) {
        AppSnackbar.show(
          title:'Missing Information',
          message:'Please select your business type.',
        );

        return false;
      }

      // ========================================================
      // VALIDATE PRODUCTS
      // ========================================================

      if (selectedProducts.isEmpty) {
        AppSnackbar.show(
          title:'Missing Information',
          message: 'Please select at least one product category.',
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

      // API CALL
        final result =
        await _onboardingRepo.savePreferences(
        facilityName: facilityName,
        role: 'client',
        businessType: selectedBusinessType.value,
        categories: selectedProducts.toList(),
        facilityId: await PrefHelper.getClientFacilityId(),
        );

      // --------------------------------------------------------
      // SAVE RESPONSE IN MEMORY
      // --------------------------------------------------------

      savedPreferences.value = result;
      await PrefHelper.saveBusinessType(
      result.facility.businessType,
      );

      await PrefHelper.saveBusinessCategories(
      result.facility.categories
      .map((category) => category.name)
      .toList(),
      );
      businessName.value =
          result.facilityName;

      // --------------------------------------------------------
      // PERSIST IMPORTANT DATA
      // --------------------------------------------------------
      await PrefHelper.saveClientFacilityId(
        result.facility.id,
      );
      await PrefHelper.saveClientBusinessName(
        result.facilityName,
      );
      await PrefHelper.saveClientBusinessType(
        selectedBusinessType.value,
      );

      await PrefHelper.saveClientSelectedProducts(
        selectedProducts.toList(),
      );

      productController.businessType.value =
          result.facility.businessType;

      productController.businessCategories.assignAll(
        result.facility.categories
            .map((category) => category.name)
            .toList(),
      );

      productController.applyFilters();
      await PrefHelper.setClientPreferencesCompleted(
        true,
      );

      await PrefHelper.saveClientProfileCompletion(
        33,
      );

      await PrefHelper.saveClientOnboardingStep(
        1,
      );

      debugPrint(
        'Preferences saved. '
        'Facility: ${result.facility.id}',
      );

      return true;
    } catch (e) {
      debugPrint(
        'Save preferences failed: $e',
      );

      if (e is ApiError) {
        AppSnackbar.show(
          title:'Error',
          message: e.message,
        );
      } else {
        AppSnackbar.show(
        title:'Error',
        message:'Failed to save preferences.',
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

  /// Temporary local path.
  ///
  /// DO NOT persist these paths.
  /// Android can delete the cache files.
  final ownerIdPath =
      RxnString();

  final ownershipProofPath =
      RxnString();

  final ownerIdUploaded =
      false.obs;

  final ownershipProofUploaded =
      false.obs;

  // ============================================================
  // DOCUMENT API STATE
  // ============================================================

  final isUploadingDocuments =
      false.obs;

  final uploadedDocuments =
      Rxn<OnboardingDocumentsResponse>();

  // ============================================================
  // DOCUMENT PICKER
  // ============================================================

  Future<void> pickDocument(
    String type,
  ) async {
    try {
      final result =
          await FilePicker.pickFiles(
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

      if (result == null) {
        return;
      }

      final file =
          result.files.single;

      final filePath =
          file.path;

      if (filePath == null ||
          filePath.isEmpty) {
        AppSnackbar.show(
          title:'Error',
          message:'Could not access the selected file.',
        );

        return;
      }

      // --------------------------------------------------------
      // IDENTITY DOCUMENT
      // --------------------------------------------------------

      if (type == 'owner_id') {
        ownerIdPath.value =
            filePath;

        ownerIdUploaded.value =
            true;
      }

      // --------------------------------------------------------
      // FACILITY DOCUMENT
      // --------------------------------------------------------

      else if (
        type == 'ownership_proof'
      ) {
        ownershipProofPath.value =
            filePath;

        ownershipProofUploaded.value =
            true;
      }
    } catch (e) {
      debugPrint(
        'Document picker failed: $e',
      );

      AppSnackbar.show(
         title:'Error',
         message:'Failed to select the document.',
      );
    }
  }

  // ============================================================
  // UPLOAD STEP 2 DOCUMENTS
  // ============================================================

  Future<bool>
      uploadOnboardingDocuments() async {
    try {
      isUploadingDocuments.value =
          true;

      // --------------------------------------------------------
      // FACILITY ID
      // --------------------------------------------------------

      int? facilityId;

      // First try current memory.
      if (savedPreferences.value != null) {
        facilityId =
            savedPreferences
                .value!
                .facility
                .id;
      }

      // If app was refreshed, get it from PrefHelper.
      facilityId ??=
          await PrefHelper
              .getClientFacilityId();

      if (facilityId == null ||
          facilityId <= 0) {
        AppSnackbar.show(
        title:'Error',
         message:'Facility information was not found.',
        );

        return false;
      }

      // --------------------------------------------------------
      // DOCUMENT PATHS
      // --------------------------------------------------------

      final identityPath =
          ownerIdPath.value;

      final facilityPath =
          ownershipProofPath.value;

      if (identityPath == null ||
          identityPath.trim().isEmpty) {
        AppSnackbar.show(
          title:'Missing Do title',
          message:'Please upload your identity document.',
        );

        return false;
      }

      if (facilityPath == null ||
          facilityPath.trim().isEmpty) {
        AppSnackbar.show(
          title:'Missing Document',
          message:'Please upload the facility document.',
        );

        return false;
      }

      // --------------------------------------------------------
      // API
      // --------------------------------------------------------

      final result =
          await _onboardingRepo
              .uploadOnboardingDocuments(
        facilityId: facilityId,
        identityDocumentPath:
            identityPath,
        facilityDocumentPath:
            facilityPath,
      );

      // --------------------------------------------------------
      // SAVE RESPONSE
      // --------------------------------------------------------

      uploadedDocuments.value =
          result;

      // --------------------------------------------------------
      // PERSIST COMPLETION
      // --------------------------------------------------------

      await PrefHelper.setClientDocumentsCompleted(true,);
      await PrefHelper.saveClientProfileCompletion(66,);
      await PrefHelper.saveClientOnboardingStep(2,);

      debugPrint(
        'Documents uploaded successfully.',
      );

      return true;
    } catch (e) {
      debugPrint(
        'Document upload failed: $e',
      );

      if (e is ApiError) {
        AppSnackbar.show(
         title:'Error',
         message: e.message,
        );
      } else {
        AppSnackbar.show(
         title:'Error',
         message:'Failed to upload onboarding documents.',
        );
      }

      return false;
    } finally {
      isUploadingDocuments.value =
          false;
    }
  }

  // ============================================================
  // FINAL STEP
  // ============================================================

  Future<bool>
      completeFinalStep() async {
    try {
      // --------------------------------------------------------
      // VALIDATION
      // --------------------------------------------------------

      if (address.value.trim().isEmpty) {
        AppSnackbar.show(
          title:'Missing Information',
          message: 'Please enter your address.',
        );

        return false;
      }

      if (city.value.trim().isEmpty) {
        AppSnackbar.show(
          title:'Missing Information',
          message: 'Please enter your city.',
        );

        return false;
      }

      // --------------------------------------------------------
      // IMPORTANT
      //
      // This is the ONLY place where 100% is saved.
      //
      // If later you create a backend endpoint for location,
      // call it here BEFORE saving 100%.
      // --------------------------------------------------------

      await PrefHelper.setClientProfileCompleted(true,);
      await PrefHelper.saveClientProfileCompletion(100,);
      await PrefHelper.saveClientOnboardingStep(2,);
      profileCompletion.value =100;

      debugPrint(
        'Client profile completed: 100%',
      );

      return true;
    } catch (e) {
      debugPrint(
        'Final step failed: $e',
      );

      if (e is ApiError) {
        AppSnackbar.show(
         title:'Error',
         message:e.message,
        );
      } else {
        AppSnackbar.show(
         title:'Error',
         message: 'Failed to complete your profile.',
        );
      }

      return false;
    }
  }

  // ============================================================
  // DOCUMENT ACTIONS
  // ============================================================

  void markOwnerIdUploaded() {
    ownerIdUploaded.value =
        true;
  }

  void markOwnershipProofUploaded() {
    ownershipProofUploaded.value =
        true;
  }

  void removeOwnerId() {
    ownerIdPath.value = null;
    ownerIdUploaded.value =
        false;
  }

  void removeOwnershipProof() {
    ownershipProofPath.value =
        null;
    ownershipProofUploaded.value =
        false;
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  bool get canGoNext {
    switch (currentStep.value) {
      // --------------------------------------------------------
      // STEP 1
      // --------------------------------------------------------

      case 0:
        return businessNameController
                .text
                .trim()
                .isNotEmpty &&
            selectedBusinessType
                .value
                .isNotEmpty &&
            selectedProducts.isNotEmpty;

      // --------------------------------------------------------
      // STEP 2
      // --------------------------------------------------------

      case 1:
        return ownerIdPath.value !=
                null &&
            ownerIdPath.value!
                .isNotEmpty &&
            ownershipProofPath.value !=
                null &&
            ownershipProofPath.value!
                .isNotEmpty;

      // --------------------------------------------------------
      // STEP 3
      // --------------------------------------------------------

      case 2:
        return address.value
                .trim()
                .isNotEmpty &&
            city.value
                .trim()
                .isNotEmpty;

      default:
        return false;
    }
  }
  // ============================================================
// GET CURRENT PREFERENCES
// ============================================================

// Future<bool> getPreferences() async {
//   try {
//     isLoadingPreferences.value = true;

//     print('');
//     print('📥 Getting client preferences...');

//     final result =
//         await _onboardingRepo.getPreferences();

//     // ----------------------------------------------------------
//     // SAVE IN MEMORY
//     // ----------------------------------------------------------

//     currentPreferences.assignAll(
//       result.preferences,
//     );

//     // ----------------------------------------------------------
//     // RESTORE SELECTED PRODUCTS
//     // ----------------------------------------------------------

//     selectedProducts.assignAll(
//       result.preferences
//           .map((preference) => preference.name)
//           .toList(),
//     );

//     print(
//       '📦 Current preferences: '
//       '${currentPreferences.map((e) => e.name).toList()}',
//     );

//     print(
//       '📦 Selected products restored: '
//       '$selectedProducts',
//     );

//     return true;
//   } catch (e) {
//     debugPrint(
//       'Get preferences failed: $e',
//     );

//     if (e is ApiError) {
//       AppSnackbar.show(
//          title:'Error',
//          message:e.message,
//       );
//     } else {
//       AppSnackbar.show(
//          title:'Error',
//          message:'Failed to load your preferences.',
//       );
//     }

//     return false;
//   } finally {
//     isLoadingPreferences.value = false;
//   }
// }

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
      title:
          'Leave Profile Completion?',
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

    ownerIdPath.value =
        null;

    ownershipProofPath.value =
        null;

    ownerIdUploaded.value =
        false;

    ownershipProofUploaded.value =
        false;

    uploadedDocuments.value =
        null;

    isUploadingDocuments.value =
        false;

    // ----------------------------------------------------------
    // CLEAR PERSISTED STATE
    // ----------------------------------------------------------
     PrefHelper.clearClientOnboarding();
    debugPrint('Client onboarding reset.',);
  }
  Future<void> simulateProgress() async {
    await nextStep();
  }

  @override
  void onClose() {
    businessNameController.dispose();

    super.onClose();
  }
}