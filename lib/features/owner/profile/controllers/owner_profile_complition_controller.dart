import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/core/constants/client_products.dart';
import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/utils/pref_helper.dart';

import 'package:smartware/features/owner/profile/models/owner_documents_model.dart';
import 'package:smartware/features/owner/profile/models/owner_import_excel_model.dart';
import 'package:smartware/features/owner/profile/models/owner_onboarding_repo.dart';
import 'package:smartware/features/owner/profile/models/owner_prefrences_model.dart';

import 'package:smartware/features/client/profile/widgets/product_type_model.dart';

import 'package:smartware/widgets/app_dialog.dart';

class OwnerProfileComplitionController extends GetxController {
  // ============================================================
  // REPOSITORY
  // ============================================================

  final OwnerOnboardingRepo _onboardingRepo =
      OwnerOnboardingRepo();

  // ============================================================
  // OWNER BUSINESS TYPE
  // ============================================================

  /// OWNER IS ALWAYS A WAREHOUSE.
  /// THERE IS NO BUSINESS TYPE SELECTION FOR OWNER.
  static const String ownerBusinessType = 'warehouse';

  // ============================================================
  // STEP MANAGEMENT
  // ============================================================

  final currentStep = 0.obs;

  final int totalSteps = 4;

  /*
   * STEP 0 = Warehouse Preferences
   * STEP 1 = Inventory
   * STEP 2 = Documents
   * STEP 3 = Location
   *
   * Completion:
   *
   * Step 0 = 0%
   * Step 1 = 25%
   * Step 2 = 50%
   * Step 3 = 75%
   * Done   = 100%
   */

  final profileCompletion = 0.obs;

  static const int maxCompletion = 100;

  double get completionPercent {
    return profileCompletion.value / maxCompletion;
  }

  bool get isProfileComplete {
    return profileCompletion.value >= maxCompletion;
  }

  String get completionText {
    switch (profileCompletion.value) {
      case 100:
        return 'Profile Complete';

      case 75:
        return 'Almost Done';

      case 50:
      case 25:
        return 'Keep Going';

      default:
        return 'Complete Your Profile';
    }
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

    restoreOnboardingProgress();
  }

  void _onBusinessNameChanged() {
    businessName.value =
        businessNameController.text.trim();
  }

  // ============================================================
  // RESTORE ONBOARDING
  // ============================================================

  Future<void> restoreOnboardingProgress() async {
    try {
      final completion =
          await PrefHelper.getOwnerProfileCompletion();

      final savedStep =
          await PrefHelper.getOwnerOnboardingStep();

      final preferencesCompleted =
          await PrefHelper.isOwnerPreferencesCompleted();

      final documentsCompleted =
          await PrefHelper.areOwnerDocumentsCompleted();

      final profileCompleted =
          await PrefHelper.isOwnerProfileCompleted();

      final savedBusinessName =
          await PrefHelper.getOwnerBusinessName();

      final savedProducts =
          await PrefHelper.getOwnerSelectedProducts();

      // ==========================================================
      // RESTORE DATA
      // ==========================================================

      businessName.value = savedBusinessName;

      businessNameController.text =
          savedBusinessName;

      selectedProducts.assignAll(
        savedProducts,
      );

      // ==========================================================
      // RESTORE OWNER BUSINESS TYPE
      // ==========================================================

      // Always warehouse.
      await PrefHelper.saveOwnerBusinessType(
        ownerBusinessType,
      );

      // ==========================================================
      // RESTORE STEP
      // ==========================================================

      if (profileCompleted) {
        profileCompletion.value = 100;
        currentStep.value = 3;
      } else if (documentsCompleted) {
        profileCompletion.value = 75;
        currentStep.value = 3;
      } else if (savedStep >= 2) {
        profileCompletion.value = 50;
        currentStep.value = 2;
      } else if (preferencesCompleted) {
        profileCompletion.value = 25;
        currentStep.value = 1;
      } else {
        profileCompletion.value =
            completion >= 0 ? completion : 0;

        currentStep.value = savedStep;
      }

      // ==========================================================
      // SAFETY
      // ==========================================================

      if (currentStep.value < 0) {
        currentStep.value = 0;
      }

      if (currentStep.value >= totalSteps) {
        currentStep.value = totalSteps - 1;
      }

      debugPrint(
        '════════ OWNER ONBOARDING RESTORED ════════',
      );

      debugPrint(
        '🏢 Warehouse: ${businessName.value}',
      );

      debugPrint(
        '🏪 Business Type: $ownerBusinessType',
      );

      debugPrint(
        '📦 Products: ${selectedProducts.toList()}',
      );

      debugPrint(
        '📊 Progress: ${profileCompletion.value}%',
      );

      debugPrint(
        '📍 Step: ${currentStep.value + 1}',
      );

      debugPrint(
        '══════════════════════════════════════════',
      );
    } catch (e) {
      debugPrint(
        '❌ Failed to restore owner onboarding: $e',
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
    // STEP 1 - WAREHOUSE PREFERENCES
    // ==========================================================

    if (currentStep.value == 0) {
      final success = await savePreferences();

      if (!success) {
        return;
      }

      profileCompletion.value = 25;

      await PrefHelper.saveOwnerProfileCompletion(25);
      await PrefHelper.saveOwnerOnboardingStep(1);

      currentStep.value = 1;

      return;
    }

    // ==========================================================
    // STEP 2 - INVENTORY
    // ==========================================================

    if (currentStep.value == 1) {
      final success = await importInventory();

      if (!success) {
        return;
      }

      profileCompletion.value = 50;

      await PrefHelper.saveOwnerProfileCompletion(50);
      await PrefHelper.saveOwnerOnboardingStep(2);

      currentStep.value = 2;

      return;
    }

    // ==========================================================
    // STEP 3 - DOCUMENTS
    // ==========================================================

    if (currentStep.value == 2) {
      final success =
          await uploadOnboardingDocuments();

      if (!success) {
        return;
      }

      profileCompletion.value = 75;

      await PrefHelper.saveOwnerProfileCompletion(75);
      await PrefHelper.saveOwnerOnboardingStep(3);

      currentStep.value = 3;

      return;
    }

    // ==========================================================
    // STEP 4 - LOCATION
    // ==========================================================

    if (currentStep.value == 3) {
      final success =
          await completeFinalStep();

      if (!success) {
        return;
      }

      profileCompletion.value = 100;

      await PrefHelper.saveOwnerProfileCompletion(100);

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

    switch (currentStep.value) {
      case 0:
        profileCompletion.value = 0;
        break;

      case 1:
        profileCompletion.value = 25;
        break;

      case 2:
        profileCompletion.value = 50;
        break;

      case 3:
        profileCompletion.value = 75;
        break;
    }

    debugPrint(
      'Back to owner step '
      '${currentStep.value + 1} | '
      'Progress: ${profileCompletion.value}%',
    );
  }

  // ============================================================
  // STEP HELPERS
  // ============================================================

  bool get isFirstStep {
    return currentStep.value == 0;
  }

  bool get isLastStep {
    return currentStep.value == totalSteps - 1;
  }

  // ============================================================
  // OWNER PREFERENCES
  // ============================================================

  final businessNameController =
      TextEditingController();

  final businessName = ''.obs;

  final isProductsExpanded = false.obs;

  final preferredLanguage =
      'English'.obs;

  final preferredCurrency =
      'USD'.obs;

  final RxList<String> selectedProducts =
      <String>[].obs;

  // ============================================================
  // PRODUCTS
  // ============================================================

  final List<ProductTypeModel> allProducts =
      ProductTypes.all;

  // ============================================================
  // PRODUCT SELECTION
  // ============================================================

  void toggleProduct(String id) {
    if (selectedProducts.contains(id)) {
      selectedProducts.remove(id);
    } else {
      selectedProducts.add(id);
    }

    debugPrint(
      '📦 Owner selected products: '
      '${selectedProducts.toList()}',
    );
  }

  void toggleCategory(String id) {
    toggleProduct(id);
  }

  // ============================================================
  // API STATE
  // ============================================================

  final isSavingPreferences = false.obs;

  final savedPreferences =
      Rxn<OwnerPrefrencesModel>();

  // ============================================================
  // SAVE OWNER PREFERENCES
  // ============================================================

  Future<bool> savePreferences() async {
    try {
      isSavingPreferences.value = true;

      final facilityName =
          businessNameController.text.trim();

      // ========================================================
      // VALIDATION
      // ========================================================

      if (facilityName.isEmpty) {
        Get.snackbar(
          'Missing Information',
          'Please enter your warehouse name.',
        );

        return false;
      }

      if (selectedProducts.isEmpty) {
        Get.snackbar(
          'Missing Information',
          'Please select at least one product category.',
        );

        return false;
      }

      // ========================================================
      // DEBUG
      // ========================================================

      debugPrint('');

      debugPrint(
        '════════ OWNER PREFERENCES ════════',
      );

      debugPrint(
        '🏢 Warehouse Name: $facilityName',
      );

      debugPrint(
        '🎭 Role: warehouse_admin',
      );

      debugPrint(
        '🏪 Business Type: $ownerBusinessType',
      );

      debugPrint(
        '📦 Products: '
        '${selectedProducts.toList()}',
      );

      // ========================================================
      // API
      // ========================================================

      final result =
          await _onboardingRepo.savePreferences(
        facilityName: facilityName,

        role: 'warehouse_admin',

       

        categories:
            selectedProducts.toList(),
      );

      savedPreferences.value = result;

      businessName.value =
          result.facilityName;

      businessNameController.text =
          result.facilityName;

      // ========================================================
      // SAVE LOCAL DATA
      // ========================================================

      await PrefHelper.saveOwnerBusinessName(
        result.facilityName,
      );

      // ALWAYS WAREHOUSE
      await PrefHelper.saveOwnerBusinessType(
        ownerBusinessType,
      );

      await PrefHelper.saveOwnerBusinessCategories(
        result.facility.categories
            .map(
              (category) => category.name,
            )
            .toList(),
      );

      await PrefHelper.saveOwnerFacilityId(
        result.facility.id,
      );

      await PrefHelper.saveOwnerSelectedProducts(
        selectedProducts.toList(),
      );

      await PrefHelper.setOwnerPreferencesCompleted(
        true,
      );

      await PrefHelper.saveOwnerProfileCompletion(
        25,
      );

      await PrefHelper.saveOwnerOnboardingStep(
        1,
      );

      debugPrint(
        '✅ Owner preferences saved.',
      );

      debugPrint(
        '🏢 Facility ID: '
        '${result.facility.id}',
      );

      debugPrint(
        '🏪 Business Type: $ownerBusinessType',
      );

      return true;
    } catch (e) {
      debugPrint(
        '❌ Owner save preferences failed: $e',
      );

      if (e is ApiError) {
        Get.snackbar(
          'Error',
          e.message,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to save owner preferences.',
        );
      }

      return false;
    } finally {
      isSavingPreferences.value = false;
    }
  }

  // ============================================================
  // INVENTORY
  // ============================================================

  final inventoryFile = Rxn<File>();

  final inventoryFileName = ''.obs;

  final selectedSectionId = 1.obs;

  final isImportingInventory = false.obs;

  final importedInventory =
      Rxn<OwnerImportExcelModel>();

  void selectSection(int sectionId) {
    selectedSectionId.value = sectionId;
  }

  Future<void> pickInventoryFile() async {
    try {
      final result =
          await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'xlsx',
          'xls',
          'csv',
        ],
        allowMultiple: false,
      );

      if (result == null ||
          result.files.isEmpty) {
        return;
      }

      final pickedFile =
          result.files.single;

      final path =
          pickedFile.path;

      if (path == null ||
          path.isEmpty) {
        Get.snackbar(
          'Error',
          'Could not access the selected file.',
        );

        return;
      }

      inventoryFile.value = File(path);

      inventoryFileName.value =
          pickedFile.name;

      debugPrint(
        '📄 Inventory file selected: '
        '${pickedFile.name}',
      );
    } catch (e) {
      debugPrint(
        '❌ Inventory file picker failed: $e',
      );

      _showErrorSnackbar(
        title: 'File Selection Failed',
        message:
            'Unable to select the inventory file. Please try again.',
      );
    }
  }

  void removeInventoryFile() {
    inventoryFile.value = null;
    inventoryFileName.value = '';
    importedInventory.value = null;
  }

  Future<bool> importInventory() async {
    try {
      isImportingInventory.value = true;

      if (inventoryFile.value == null) {
        Get.snackbar(
          'Missing File',
          'Please select an Excel inventory file.',
        );

        return false;
      }

      final sectionId =
          selectedSectionId.value;

      if (sectionId <= 0) {
        Get.snackbar(
          'Missing Section',
          'Please select a warehouse section.',
        );

        return false;
      }

      int? facilityId;

      if (savedPreferences.value != null) {
        facilityId =
            savedPreferences.value!.facility.id;
      }

      facilityId ??=
          await PrefHelper.getOwnerFacilityId();

      if (facilityId == null ||
          facilityId <= 0) {
        Get.snackbar(
          'Error',
          'Facility information was not found.',
        );

        return false;
      }

      final filePath =
          inventoryFile.value!.path;

      if (filePath.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'The selected inventory file is not accessible.',
        );

        return false;
      }

      final result =
          await _onboardingRepo.importInventoryExcel(
        facilityId: facilityId,
        sectionId: sectionId,
        excelFilePath: filePath,
      );

      importedInventory.value = result;

      Get.snackbar(
        'Success',
        result.message,
        snackPosition:
            SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      debugPrint(
        '❌ Inventory import failed: $e',
      );

      if (e is ApiError) {
        Get.snackbar(
          'Import Failed',
          e.message,
          snackPosition:
              SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Import Failed',
          'Failed to import the inventory file.',
          snackPosition:
              SnackPosition.BOTTOM,
        );
      }

      return false;
    } finally {
      isImportingInventory.value = false;
    }
  }

  // ============================================================
  // DOCUMENTS
  // ============================================================

  final ownerIdPath = RxnString();

  final ownershipProofPath = RxnString();

  final ownerIdUploaded = false.obs;

  final ownershipProofUploaded = false.obs;

  final isUploadingDocuments = false.obs;

  final uploadedDocuments =
      Rxn<OnboardingDocumentsResponse>();

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
        allowMultiple: false,
      );

      if (result == null ||
          result.files.isEmpty) {
        return;
      }

      final pickedFile =
          result.files.single;

      final filePath =
          pickedFile.path;

      if (filePath == null ||
          filePath.isEmpty) {
        Get.snackbar(
          'Error',
          'Could not access the selected file.',
        );

        return;
      }

      switch (type) {
        case 'owner_id':
          ownerIdPath.value = filePath;
          ownerIdUploaded.value = true;
          break;

        case 'ownership_proof':
          ownershipProofPath.value =
              filePath;
          ownershipProofUploaded.value =
              true;
          break;
      }
    } catch (e) {
      debugPrint(
        '❌ Owner document picker failed: $e',
      );

      Get.snackbar(
        'Error',
        'Failed to select the document.',
      );
    }
  }

  Future<bool> uploadOnboardingDocuments() async {
    try {
      isUploadingDocuments.value = true;

      int? facilityId;

      if (savedPreferences.value != null) {
        facilityId =
            savedPreferences.value!.facility.id;
      }

      facilityId ??=
          await PrefHelper.getOwnerFacilityId();

      if (facilityId == null ||
          facilityId <= 0) {
        Get.snackbar(
          'Error',
          'Facility information was not found.',
        );

        return false;
      }

      final identityPath =
          ownerIdPath.value;

      final facilityPath =
          ownershipProofPath.value;

      if (identityPath == null ||
          identityPath.trim().isEmpty) {
        Get.snackbar(
          'Missing Document',
          'Please upload your identity document.',
        );

        return false;
      }

      if (facilityPath == null ||
          facilityPath.trim().isEmpty) {
        Get.snackbar(
          'Missing Document',
          'Please upload the ownership document.',
        );

        return false;
      }

      final result =
          await _onboardingRepo
              .uploadOnboardingDocuments(
        facilityId: facilityId,
        identityDocumentPath:
            identityPath,
        facilityDocumentPath:
            facilityPath,
      );

      uploadedDocuments.value = result;

      await PrefHelper.setOwnerDocumentsCompleted(
        true,
      );

      await PrefHelper.saveOwnerProfileCompletion(
        75,
      );

      await PrefHelper.saveOwnerOnboardingStep(
        3,
      );

      debugPrint(
        '✅ Owner documents uploaded successfully.',
      );

      return true;
    } catch (e) {
      debugPrint(
        '❌ Owner document upload failed: $e',
      );

      if (e is ApiError) {
        Get.snackbar(
          'Error',
          e.message,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to upload owner documents.',
        );
      }

      return false;
    } finally {
      isUploadingDocuments.value = false;
    }
  }

  // ============================================================
  // LOCATION
  // ============================================================

  final address = ''.obs;

  final city = ''.obs;

  final country = ''.obs;

  Future<bool> completeFinalStep() async {
    try {
      if (address.value.trim().isEmpty) {
        Get.snackbar(
          'Missing Information',
          'Please enter your address.',
        );

        return false;
      }

      if (city.value.trim().isEmpty) {
        Get.snackbar(
          'Missing Information',
          'Please enter your city.',
        );

        return false;
      }

      await PrefHelper.setOwnerProfileCompleted(
        true,
      );

      await PrefHelper.saveOwnerProfileCompletion(
        100,
      );

      await PrefHelper.saveOwnerOnboardingStep(
        3,
      );

      profileCompletion.value = 100;

      debugPrint(
        '✅ Owner profile completed: 100%',
      );

      return true;
    } catch (e) {
      debugPrint(
        '❌ Owner final step failed: $e',
      );

      if (e is ApiError) {
        Get.snackbar(
          'Error',
          e.message,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to complete your profile.',
        );
      }

      return false;
    }
  }

  // ============================================================
  // DOCUMENT ACTIONS
  // ============================================================

  void markOwnerIdUploaded() {
    ownerIdUploaded.value = true;
  }

  void markOwnershipProofUploaded() {
    ownershipProofUploaded.value = true;
  }

  void removeOwnerId() {
    ownerIdPath.value = null;
    ownerIdUploaded.value = false;
  }

  void removeOwnershipProof() {
    ownershipProofPath.value = null;
    ownershipProofUploaded.value = false;
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  bool get canGoNext {
    switch (currentStep.value) {
      // ========================================================
      // STEP 1
      // WAREHOUSE NAME + PRODUCTS ONLY
      // ========================================================

      case 0:
        return businessNameController.text
                .trim()
                .isNotEmpty &&
            selectedProducts.isNotEmpty;

      // ========================================================
      // STEP 2
      // INVENTORY
      // ========================================================

      case 1:
        return inventoryFile.value != null;

      // ========================================================
      // STEP 3
      // DOCUMENTS
      // ========================================================

      case 2:
        return ownerIdPath.value != null &&
            ownerIdPath.value!.isNotEmpty &&
            ownershipProofPath.value != null &&
            ownershipProofPath.value!.isNotEmpty;

      // ========================================================
      // STEP 4
      // LOCATION
      // ========================================================

      case 3:
        return address.value.trim().isNotEmpty &&
            city.value.trim().isNotEmpty;

      default:
        return false;
    }
  }

  // ============================================================
  // BACK
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

    profileCompletion.value = 0;

    businessNameController.clear();

    businessName.value = '';

    isProductsExpanded.value = false;

    preferredLanguage.value = 'English';

    preferredCurrency.value = 'USD';

    selectedProducts.clear();

    savedPreferences.value = null;

    isSavingPreferences.value = false;

    removeInventoryFile();

    selectedSectionId.value = 1;

    isImportingInventory.value = false;

    importedInventory.value = null;

    ownerIdPath.value = null;

    ownershipProofPath.value = null;

    ownerIdUploaded.value = false;

    ownershipProofUploaded.value = false;

    uploadedDocuments.value = null;

    isUploadingDocuments.value = false;

    address.value = '';

    city.value = '';

    country.value = '';

    PrefHelper.clearOwnerOnboarding();

    debugPrint(
      'Owner onboarding reset.',
    );
  }

  // ============================================================
  // DEMO
  // ============================================================

  Future<void> simulateProgress() async {
    await nextStep();
  }

  // ============================================================
  // ERROR
  // ============================================================

  void _showErrorSnackbar({
    required String title,
    required String message,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition:
          SnackPosition.BOTTOM,
    );
  }

  // ============================================================
  // CLOSE
  // ============================================================

  @override
  void onClose() {
    businessNameController.dispose();

    super.onClose();
  }
}