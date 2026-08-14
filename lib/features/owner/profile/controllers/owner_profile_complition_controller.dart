import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/core/constants/business_product_mapping.dart';
import 'package:smartware/core/constants/client_business_types.dart';
import 'package:smartware/core/constants/client_products.dart';
import 'package:smartware/features/client/profile/widgets/product_type_model.dart';
import 'package:smartware/widgets/app_dialog.dart';

class OwnerProfileComplitionController extends GetxController {
  // ===========================================================================
  // STEP MANAGEMENT
  // ===========================================================================

  final currentStep = 0.obs;

  /// Total number of profile completion steps.
  final int totalSteps = 4;

  /// Completion percentage for each step.
  final List<int> stepProgress = const [
    25,
    50,
    75,
    100,
  ];

  /// Move to the next step.
  void nextStep() {
    if (currentStep.value < totalSteps - 1) {
      currentStep.value++;
      _syncProgress();
    }
  }

  /// Move to the previous step.
  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      _syncProgress();
    }
  }

  /// Whether the user is currently on the first step.
  bool get isFirstStep => currentStep.value == 0;

  /// Whether the user is currently on the last step.
  bool get isLastStep => currentStep.value == totalSteps - 1;

  // ===========================================================================
  // PROFILE COMPLETION
  // ===========================================================================

  final profileCompletion = 25.obs;

  static const int maxCompletion = 100;

  double get completionPercent =>
      profileCompletion.value / maxCompletion;

  bool get isProfileComplete =>
      profileCompletion.value >= maxCompletion;

  String get completionText {
    final value = profileCompletion.value;

    if (value >= 100) {
      return 'Profile Complete';
    }

    if (value >= 80) {
      return 'Almost Done';
    }

    if (value >= 50) {
      return 'Keep Going';
    }

    return 'Complete Your Profile';
  }

  // ===========================================================================
  // STEP → PROGRESS SYNC
  // ===========================================================================

  void _syncProgress() {
    if (currentStep.value >= 0 &&
        currentStep.value < stepProgress.length) {
      profileCompletion.value =
          stepProgress[currentStep.value];
    }
  }

  // ===========================================================================
  // STEP 1 - BUSINESS PREFERENCES
  // ===========================================================================

  /// Selected business type.
  final selectedBusinessType = ''.obs;

  /// Whether the products section is expanded.
  final isProductsExpanded = false.obs;

  /// Preferred language.
  final preferredLanguage = 'English'.obs;

  /// Preferred currency.
  final preferredCurrency = 'USD'.obs;

  /// Facility / warehouse name.
  final RxString facilityName = ''.obs;

  /// Products selected by the owner.
  final selectedProducts = <String>[].obs;

  /// Available business types.
  final businessTypes = BusinessTypes.all;

  /// All available products.
  final List<ProductTypeModel> allProducts = ProductTypes.all;

  /// Business type → allowed products mapping.
  final Map<String, List<String>> businessProductMap =
      BusinessProductMapping.map;

  /// Toggle a product selection.
  void toggleProduct(String id) {
    if (selectedProducts.contains(id)) {
      selectedProducts.remove(id);
    } else {
      selectedProducts.add(id);
    }
  }

  /// Select a business type.
  void selectBusinessType(String id) {
    if (selectedBusinessType.value == id) {
      return;
    }

    selectedBusinessType.value = id;

    /// Products depend on the selected business type,
    /// so previous selections must be cleared.
    selectedProducts.clear();

    /// Collapse the products section when the business changes.
    isProductsExpanded.value = false;
  }

  /// Clear the selected business type and products.
  void clearBusinessType() {
    selectedBusinessType.value = '';
    selectedProducts.clear();
    isProductsExpanded.value = false;
  }

  /// Products available for the currently selected business type.
  List<ProductTypeModel> get availableProducts {
    final allowedIds =
        businessProductMap[selectedBusinessType.value] ?? [];

    return allProducts
        .where(
          (product) => allowedIds.contains(product.id),
        )
        .toList();
  }

  // ===========================================================================
  // STEP 2 - FACILITY INFORMATION
  // ===========================================================================

  /// Controller for the warehouse / business name.
  final TextEditingController facilityNameController =
      TextEditingController();

  /// Excel file containing the warehouse inventory.
  File? inventoryFile;

  /// Name of the selected inventory file.
  final RxString inventoryFileName = ''.obs;

  /// Update the facility name.
  void updateFacilityName(String value) {
    facilityName.value = value.trim();
  }

  /// Pick the Excel inventory file.
  Future<void> pickInventoryFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'xlsx',
          'xls',
          'csv'
        ],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final pickedFile = result.files.single;

      if (pickedFile.path == null) {
        return;
      }

      inventoryFile = File(pickedFile.path!);
      inventoryFileName.value = pickedFile.name;
    } catch (e) {
      _showErrorSnackbar(
        title: 'File Selection Failed',
        message:
            'Unable to select the Excel file. Please try again.',
      );
    }
  }

  /// Remove the selected inventory file.
  void removeInventoryFile() {
    inventoryFile = null;
    inventoryFileName.value = '';
  }

  // ===========================================================================
  // STEP 3 - DOCUMENTATION
  // ===========================================================================

  /// Whether the owner's ID has been uploaded.
  final ownerIdUploaded = false.obs;

  /// Whether the ownership proof has been uploaded.
  final ownershipProofUploaded = false.obs;

  /// Pick an owner document.
  Future<void> pickDocument(String type) async {
    try {
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
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final pickedFile = result.files.single;

      if (pickedFile.path == null) {
        return;
      }

      switch (type) {
        case 'owner_id':
          ownerIdUploaded.value = true;
          break;

        case 'ownership_proof':
          ownershipProofUploaded.value = true;
          break;
      }
    } catch (e) {
      _showErrorSnackbar(
        title: 'File Selection Failed',
        message:
            'Unable to select the document. Please try again.',
      );
    }
  }

  /// Manually mark the owner's ID as uploaded.
  void markOwnerIdUploaded() {
    ownerIdUploaded.value = true;
  }

  /// Manually mark the ownership proof as uploaded.
  void markOwnershipProofUploaded() {
    ownershipProofUploaded.value = true;
  }

  /// Remove the owner's ID.
  void removeOwnerId() {
    ownerIdUploaded.value = false;
  }

  /// Remove the ownership proof.
  void removeOwnershipProof() {
    ownershipProofUploaded.value = false;
  }

  // ===========================================================================
  // STEP 4 - LOCATION
  // ===========================================================================

  final address = ''.obs;

  final city = ''.obs;

  final country = ''.obs;

  // ===========================================================================
  // VALIDATION
  // ===========================================================================

  bool get canGoNext {
    switch (currentStep.value) {
      // -----------------------------------------------------------------------
      // STEP 1 - BUSINESS PREFERENCES
      // -----------------------------------------------------------------------

      case 0:
        return selectedBusinessType.value.isNotEmpty &&
            selectedProducts.isNotEmpty;

      // -----------------------------------------------------------------------
      // STEP 2 - FACILITY INFORMATION
      // -----------------------------------------------------------------------

      case 1:
         return facilityNameController.text.trim().isNotEmpty &&
            inventoryFile != null;

      // -----------------------------------------------------------------------
      // STEP 3 - DOCUMENTATION
      // -----------------------------------------------------------------------

      case 2:
        return ownerIdUploaded.value &&
            ownershipProofUploaded.value;

      // -----------------------------------------------------------------------
      // STEP 4 - LOCATION
      // -----------------------------------------------------------------------

      case 3:
        return address.value.trim().isNotEmpty &&
            city.value.trim().isNotEmpty;

      default:
        return false;
    }
  }

  // ===========================================================================
  // BACK BUTTON
  // ===========================================================================

  Future<void> handleBack() async {
    /// If the user is on the first step,
    /// leave the profile completion screen.
    if (isFirstStep) {
      Get.back();
      return;
    }

    final leave = await AppDialogs.showConfirmDialog(
      title: 'Leave Profile Completion?',
      message:
          'Your progress will remain saved. Do you want to leave the profile completion process or return to the previous step?',
      confirmText: 'Leave',
      cancelText: 'Previous Step',
    );

    if (leave == true) {
      Get.back();
    } else {
      previousStep();
    }
  }

  // ===========================================================================
  // RESET
  // ===========================================================================

  void reset() {
    // -------------------------------------------------------------------------
    // Step
    // -------------------------------------------------------------------------

    currentStep.value = 0;

    _syncProgress();

    // -------------------------------------------------------------------------
    // Step 1 - Preferences
    // -------------------------------------------------------------------------

    selectedBusinessType.value = '';

    isProductsExpanded.value = false;

    preferredLanguage.value = 'English';

    preferredCurrency.value = 'USD';

    selectedProducts.clear();

    // -------------------------------------------------------------------------
    // Step 2 - Facility
    // -------------------------------------------------------------------------

    facilityName.value = '';

    facilityNameController.clear();

    removeInventoryFile();

    // -------------------------------------------------------------------------
    // Step 3 - Documentation
    // -------------------------------------------------------------------------

    ownerIdUploaded.value = false;

    ownershipProofUploaded.value = false;

    // -------------------------------------------------------------------------
    // Step 4 - Location
    // -------------------------------------------------------------------------

    address.value = '';

    city.value = '';

    country.value = '';
  }

  // ===========================================================================
  // DEMO / TESTING
  // ===========================================================================

  void simulateProgress() {
    nextStep();
  }

  // ===========================================================================
  // PRIVATE HELPERS
  // ===========================================================================

  void _showErrorSnackbar({
    required String title,
    required String message,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ===========================================================================
  // LIFECYCLE
  // ===========================================================================

  @override
  void onClose() {
    facilityNameController.dispose();

    super.onClose();
  }
}