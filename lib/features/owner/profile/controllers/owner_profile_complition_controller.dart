import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/core/constants/client_products.dart';
import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/routes/app_routes.dart';
import 'package:smartware/core/utils/pref_helper.dart';

import 'package:smartware/features/client/profile/widgets/product_type_model.dart';

import 'package:smartware/features/owner/profile/models/owner_documents_model.dart';
import 'package:smartware/features/owner/profile/models/owner_import_excel_model.dart';
import 'package:smartware/features/owner/profile/models/owner_onboarding_repo.dart';
import 'package:smartware/features/owner/profile/models/owner_prefrences_model.dart';

import 'package:smartware/widgets/app_dialog.dart';

class OwnerProfileComplitionController extends GetxController {
  // ============================================================
  // REPOSITORY
  // ============================================================

  final OwnerOnboardingRepo _onboardingRepo =
      OwnerOnboardingRepo();

  // ============================================================
  // OWNER BUSINESS TYPE / ROLE
  // ============================================================

  /// Owners are always warehouse owners.
  static const String ownerBusinessType = 'warehouse';

  /// Backend role expected for the owner.
  static const String ownerRole = 'warehouse_admin';

  // ============================================================
  // STEP MANAGEMENT
  // ============================================================

  final currentStep = 0.obs;

  /// Steps:
  ///
  /// 0 = Warehouse Preferences
  /// 1 = Inventory
  /// 2 = Documents
  /// 3 = Location
  ///
  /// Completion:
  ///
  /// Step 0 = 0%
  /// Step 1 = 25%
  /// Step 2 = 50%
  /// Step 3 = 75%
  /// Done   = 100%

  final int totalSteps = 4;

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
  // OWNER PROFILE DATA
  // ============================================================

  final businessNameController =
      TextEditingController();

  final businessName = ''.obs;

  // ============================================================
  // OWNER PREFERENCES
  // ============================================================

  final isProductsExpanded = false.obs;

  final preferredLanguage = 'English'.obs;

  final preferredCurrency = 'USD'.obs;

  /// Selected owner product categories.
  ///
  /// Example:
  /// ['electronics', 'clothing', 'food']
  final RxList<String> selectedProducts =
      <String>[].obs;

  // ============================================================
  // PRODUCTS
  // ============================================================

  final List<ProductTypeModel> allProducts =
      ProductTypes.all;

  // ============================================================
  // API PREFERENCES STATE
  // ============================================================

  final isSavingPreferences = false.obs;

  final savedPreferences =
      Rxn<OwnerPrefrencesModel>();

  // ============================================================
  // INVENTORY
  // ============================================================

  final inventoryFile = Rxn<File>();

  final inventoryFileName = ''.obs;

  final selectedSectionId = 1.obs;

  final isImportingInventory = false.obs;

  final importedInventory =
      Rxn<OwnerImportExcelModel>();

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

  // ============================================================
  // LOCATION
  // ============================================================

  final address = ''.obs;

  final city = ''.obs;

  final country = ''.obs;

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
  // RESTORE OWNER ONBOARDING
  // ============================================================

  Future<void> restoreOnboardingProgress() async {
    try {
      debugPrint('');

      debugPrint(
        '════════ RESTORE OWNER ONBOARDING ════════',
      );

      // ----------------------------------------------------------
      // LOAD PROGRESS
      // ----------------------------------------------------------

      final completion =
          await PrefHelper.getOwnerProfileCompletion();

      final savedStep =
          await PrefHelper.getOwnerOnboardingStep();

      // ----------------------------------------------------------
      // LOAD COMPLETION FLAGS
      // ----------------------------------------------------------

      final preferencesCompleted =
          await PrefHelper.isOwnerPreferencesCompleted();

      final documentsCompleted =
          await PrefHelper.areOwnerDocumentsCompleted();

      final profileCompleted =
          await PrefHelper.isOwnerProfileCompleted();

      // ----------------------------------------------------------
      // LOAD OWNER DATA
      // ----------------------------------------------------------

      final savedBusinessName =
          await PrefHelper.getOwnerBusinessName();

      final savedProducts =
          await PrefHelper.getOwnerSelectedProducts();

      // ----------------------------------------------------------
      // CLEAN CATEGORIES
      // ----------------------------------------------------------

      final cleanedCategories =
          _cleanCategories(savedProducts);

      // ----------------------------------------------------------
      // RESTORE BUSINESS NAME
      // ----------------------------------------------------------

      businessName.value =
          savedBusinessName.trim();

      businessNameController.text =
          savedBusinessName.trim();

      // ----------------------------------------------------------
      // RESTORE CATEGORIES
      // ----------------------------------------------------------

      selectedProducts.assignAll(
        cleanedCategories,
      );

      // ----------------------------------------------------------
      // MAKE SURE OWNER BUSINESS TYPE EXISTS
      // ----------------------------------------------------------

      await PrefHelper.saveOwnerBusinessType(
        ownerBusinessType,
      );

      // ----------------------------------------------------------
      // RESTORE PROGRESS
      // ----------------------------------------------------------

      if (profileCompleted) {
        profileCompletion.value = 100;
        currentStep.value = totalSteps - 1;
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
        profileCompletion.value = 0;
        currentStep.value = 0;
      }

      // ----------------------------------------------------------
      // SAFETY
      // ----------------------------------------------------------

      if (currentStep.value < 0) {
        currentStep.value = 0;
      }

      if (currentStep.value >= totalSteps) {
        currentStep.value = totalSteps - 1;
      }

      // ----------------------------------------------------------
      // DEBUG
      // ----------------------------------------------------------

      debugPrint(
        '🏢 Warehouse: ${businessName.value}',
      );

      debugPrint(
        '🏪 Business Type: $ownerBusinessType',
      );

      debugPrint(
        '👤 Role: $ownerRole',
      );

      debugPrint(
        '📦 Categories: '
        '${selectedProducts.toList()}',
      );

      debugPrint(
        '📊 Stored completion: $completion%',
      );

      debugPrint(
        '📊 Current completion: '
        '${profileCompletion.value}%',
      );

      debugPrint(
        '📍 Current step: '
        '${currentStep.value + 1}',
      );

      debugPrint(
        '✅ Profile completed: '
        '$profileCompleted',
      );

      debugPrint(
        '══════════════════════════════════════════',
      );
    } catch (e, stackTrace) {
      debugPrint(
        '❌ Failed to restore owner onboarding: $e',
      );

      debugPrint('$stackTrace');

      currentStep.value = 0;
      profileCompletion.value = 0;
      selectedProducts.clear();
    }
  }

  // ============================================================
  // OWNER CATEGORY MANAGEMENT
  // ============================================================

  /// Cleans category values before they are stored.
  ///
  /// Removes:
  /// - leading/trailing spaces
  /// - empty values
  /// - duplicate categories
  List<String> _cleanCategories(
    List<String> categories,
  ) {
    return categories
        .map(
          (category) => category.trim(),
        )
        .where(
          (category) => category.isNotEmpty,
        )
        .toSet()
        .toList();
  }

  // ============================================================
  // SAVE OWNER PROFILE CATEGORIES
  // ============================================================

  Future<void> saveOwnerProfileCategories() async {
    final categories = _cleanCategories(
      selectedProducts.toList(),
    );

    selectedProducts.assignAll(categories);

    // Main selected products storage.
    await PrefHelper.saveOwnerSelectedProducts(
      categories,
    );

    // Business categories storage.
    await PrefHelper.saveOwnerBusinessCategories(
      categories,
    );

    debugPrint('');

    debugPrint(
      '════════ OWNER PROFILE CATEGORIES SAVED ════════',
    );

    debugPrint(
      '📦 Categories: $categories',
    );

    debugPrint(
      '═══════════════════════════════════════════════',
    );
  }

  // ============================================================
  // LOAD OWNER PROFILE CATEGORIES
  // ============================================================

  Future<List<String>>
      loadOwnerProfileCategories() async {
    try {
      final categories =
          await PrefHelper.getOwnerSelectedProducts();

      final cleanedCategories =
          _cleanCategories(categories);

      selectedProducts.assignAll(
        cleanedCategories,
      );

      debugPrint('');

      debugPrint(
        '════════ OWNER PROFILE CATEGORIES LOADED ════════',
      );

      debugPrint(
        '📦 Categories: $cleanedCategories',
      );

      debugPrint(
        '════════════════════════════════════════════════',
      );

      return cleanedCategories;
    } catch (e, stackTrace) {
      debugPrint(
        '❌ Failed to load owner categories: $e',
      );

      debugPrint('$stackTrace');

      selectedProducts.clear();

      return [];
    }
  }

  // ============================================================
  // UPDATE OWNER PROFILE CATEGORIES
  // ============================================================

  Future<void> updateOwnerProfileCategories(
    List<String> categories,
  ) async {
    final cleanedCategories =
        _cleanCategories(categories);

    selectedProducts.assignAll(
      cleanedCategories,
    );

    await PrefHelper.saveOwnerSelectedProducts(
      cleanedCategories,
    );

    await PrefHelper.saveOwnerBusinessCategories(
      cleanedCategories,
    );

    debugPrint('');

    debugPrint(
      '════════ OWNER PROFILE CATEGORIES UPDATED ════════',
    );

    debugPrint(
      '📦 Categories: $cleanedCategories',
    );

    debugPrint(
      '═════════════════════════════════════════════════',
    );
  }

  // ============================================================
  // GET OWNER PROFILE CATEGORIES
  // ============================================================

  Future<List<String>>
      getOwnerProfileCategories() async {
    final categories =
        await PrefHelper.getOwnerSelectedProducts();

    return _cleanCategories(categories);
  }

  // ============================================================
  // TOGGLE PRODUCT CATEGORY
  // ============================================================

  void toggleProduct(String id) {
    final category = id.trim();

    if (category.isEmpty) {
      return;
    }

    if (selectedProducts.contains(category)) {
      selectedProducts.remove(category);
    } else {
      selectedProducts.add(category);
    }

    debugPrint(
      '📦 Owner selected categories: '
      '${selectedProducts.toList()}',
    );
  }

  // ============================================================
  // TOGGLE CATEGORY
  // ============================================================

  void toggleCategory(String id) {
    toggleProduct(id);
  }

  // ============================================================
  // STEP NAVIGATION
  // ============================================================

  Future<void> nextStep() async {
    if (!canGoNext) {
      return;
    }

    // ==========================================================
    // STEP 1
    // WAREHOUSE PREFERENCES
    // ==========================================================

    if (currentStep.value == 0) {
      final success =
          await savePreferences();

      if (!success) {
        return;
      }

      profileCompletion.value = 25;

      await PrefHelper.saveOwnerProfileCompletion(
        25,
      );

      await PrefHelper.saveOwnerOnboardingStep(
        1,
      );

      currentStep.value = 1;

      return;
    }

    // ==========================================================
    // STEP 2
    // INVENTORY
    // ==========================================================

    if (currentStep.value == 1) {
      final success =
          await importInventory();

      if (!success) {
        return;
      }

      profileCompletion.value = 50;

      await PrefHelper.saveOwnerProfileCompletion(
        50,
      );

      await PrefHelper.saveOwnerOnboardingStep(
        2,
      );

      currentStep.value = 2;

      return;
    }

    // ==========================================================
    // STEP 3
    // DOCUMENTS
    // ==========================================================

    if (currentStep.value == 2) {
      final success =
          await uploadOnboardingDocuments();

      if (!success) {
        return;
      }

      profileCompletion.value = 75;

      await PrefHelper.saveOwnerProfileCompletion(
        75,
      );

      await PrefHelper.saveOwnerOnboardingStep(
        3,
      );

      currentStep.value = 3;

      return;
    }

    // ==========================================================
    // STEP 4
    // LOCATION / COMPLETE PROFILE
    // ==========================================================

    if (currentStep.value == 3) {
      final success =
          await completeFinalStep();

      if (!success) {
        return;
      }

      profileCompletion.value = 100;

      debugPrint('');

      debugPrint(
        '════════ OWNER ONBOARDING FINISHED ════════',
      );

      debugPrint(
        '📊 Completion: '
        '${profileCompletion.value}%',
      );

      debugPrint(
        '🏢 Warehouse: ${businessName.value}',
      );

      debugPrint(
        '📦 Categories: '
        '${selectedProducts.toList()}',
      );

      debugPrint(
        '📍 Address: ${address.value}',
      );

      debugPrint(
        '🏙️ City: ${city.value}',
      );

      debugPrint(
        '🌍 Country: ${country.value}',
      );

      debugPrint(
        '🚀 Navigating to owner profile...',
      );

      debugPrint(
        '══════════════════════════════════════════',
      );

      return;
    }
  }

  // ============================================================
  // FINAL PROFILE STEP
  // ============================================================

  Future<bool> completeFinalStep() async {
    try {
      final cleanAddress =
          address.value.trim();

      final cleanCity =
          city.value.trim();

      final cleanCountry =
          country.value.trim();

      if (cleanAddress.isEmpty) {
        Get.snackbar(
          'Missing Information',
          'Please enter your address.',
        );

        return false;
      }

      if (cleanCity.isEmpty) {
        Get.snackbar(
          'Missing Information',
          'Please enter your city.',
        );

        return false;
      }

      // ----------------------------------------------------------
      // FACILITY
      // ----------------------------------------------------------

      final facilityId =
          await PrefHelper.getOwnerFacilityId();

      if (facilityId == null || facilityId <= 0) {
        Get.snackbar(
          'Error',
          'Facility information was not found.',
        );

        return false;
      }

      debugPrint('');

      debugPrint(
        '════════ OWNER SUBMIT LOCATION START ════════',
      );

      // ==========================================================
      // SUBMIT LOCATION TO BACKEND
      // ==========================================================
      //
      // Keep your existing repository location API here.
      //
      // Example:
      //
      // await _onboardingRepo.submitLocation(
      //   facilityId: facilityId,
      //   address: cleanAddress,
      //   city: cleanCity,
      //   country: cleanCountry,
      // );
      //
      // ==========================================================

      // ----------------------------------------------------------
      // SAVE PROFILE COMPLETION
      // ----------------------------------------------------------

      await PrefHelper.setOwnerProfileCompleted(
        true,
      );

      await PrefHelper.saveOwnerProfileCompletion(
        100,
      );

      await PrefHelper.saveOwnerOnboardingStep(
        4,
      );

      profileCompletion.value = 100;

      debugPrint('');

      debugPrint(
        '════════ OWNER PROFILE COMPLETED ════════',
      );

      debugPrint(
        '✅ Location saved to Laravel',
      );

      debugPrint(
        '✅ Owner profile completed: 100%',
      );

      debugPrint(
        '✅ Owner onboarding step: 4',
      );

      debugPrint(
        '🚀 Navigating to owner profile...',
      );

      // ----------------------------------------------------------
      // NAVIGATE
      // ----------------------------------------------------------

      await Get.offNamed(
        AppRoutes.onwerProfile,
      );

      debugPrint(
        '✅ Navigation command executed',
      );

      return true;
    } catch (e, stackTrace) {
      debugPrint(
        '❌ Owner final step failed: $e',
      );

      debugPrint('$stackTrace');

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
    return currentStep.value ==
        totalSteps - 1;
  }

  // ============================================================
  // SAVE OWNER PREFERENCES
  // ============================================================

    // ============================================================
  // SAVE OWNER PREFERENCES
  // ============================================================

  Future<bool> savePreferences() async {
    if (isSavingPreferences.value) {
      return false;
    }

    try {
      isSavingPreferences.value = true;

      final facilityName =
          businessNameController.text.trim();

      final categories =
          _cleanCategories(
        selectedProducts.toList(),
      );

      // ----------------------------------------------------------
      // VALIDATION
      // ----------------------------------------------------------

      if (facilityName.isEmpty) {
        Get.snackbar(
          'Missing Information',
          'Please enter your warehouse name.',
        );

        return false;
      }

      if (categories.isEmpty) {
        Get.snackbar(
          'Missing Information',
          'Please select at least one product category.',
        );

        return false;
      }

      // ----------------------------------------------------------
      // UPDATE CONTROLLER
      // ----------------------------------------------------------

      selectedProducts.assignAll(
        categories,
      );

      // ----------------------------------------------------------
      // DEBUG
      // ----------------------------------------------------------

      debugPrint('');

      debugPrint(
        '════════ OWNER PREFERENCES ════════',
      );

      debugPrint(
        '🏢 Warehouse Name: $facilityName',
      );

      debugPrint(
        '🎭 Role: $ownerRole',
      );

      debugPrint(
        '🏪 Business Type: $ownerBusinessType',
      );

      debugPrint(
        '📦 Categories: $categories',
      );

      // ----------------------------------------------------------
      // API
      // ----------------------------------------------------------

      final result =
          await _onboardingRepo.savePreferences(
        facilityName: facilityName,
        role: ownerRole,
        categories: categories,
      );

      savedPreferences.value = result;

      // ----------------------------------------------------------
      // GET SERVER CATEGORIES
      // ----------------------------------------------------------

      final serverCategories =
          _cleanCategories(
        result.facility.categories
            .map(
              (category) => category.name,
            )
            .toList(),
      );

      final finalCategories =
          serverCategories.isNotEmpty
              ? serverCategories
              : categories;

      // ----------------------------------------------------------
      // NEW: BUILD REAL {id, name} CATEGORY OBJECTS
      // ----------------------------------------------------------
      //
      // AddProductController needs the REAL server-side category
      // IDs (not just names) to send `categories[]` when creating
      // a product. We persist those here as {id, name} maps.
      // ----------------------------------------------------------

      final categoryObjects = result.facility.categories
          .map<Map<String, dynamic>>(
            (category) => {
              'id': category.id,
              'name': category.name.trim(),
            },
          )
          .where(
            (category) =>
                (category['id'] as int) > 0 &&
                (category['name'] as String).isNotEmpty,
          )
          .toList();

      // ----------------------------------------------------------
      // UPDATE CONTROLLER WITH SERVER DATA
      // ----------------------------------------------------------

      businessName.value =
          result.facilityName.trim();

      businessNameController.text =
          result.facilityName.trim();

      selectedProducts.assignAll(
        finalCategories,
      );

      // ----------------------------------------------------------
      // SAVE OWNER PROFILE DATA
      // ----------------------------------------------------------

      await PrefHelper.saveOwnerBusinessName(
        result.facilityName.trim(),
      );

      await PrefHelper.saveOwnerBusinessType(
        ownerBusinessType,
      );

      // Save the categories in BOTH owner category keys.
      await PrefHelper.saveOwnerBusinessCategories(
        finalCategories,
      );

      await PrefHelper.saveOwnerSelectedProducts(
        finalCategories,
      );

      // NEW: Save the REAL {id, name} objects so AddProductController
      // can resolve category IDs when creating a product.
      await PrefHelper.saveOwnerProductCategories(
        categoryObjects,
      );

      await PrefHelper.saveOwnerFacilityId(
        result.facility.id,
      );

      await PrefHelper.setOwnerPreferencesCompleted(
        true,
      );

      // ----------------------------------------------------------
      // DEBUG
      // ----------------------------------------------------------

      debugPrint('');

      debugPrint(
        '════════ OWNER PROFILE DATA SAVED ════════',
      );

      debugPrint(
        '🏢 Facility ID: '
        '${result.facility.id}',
      );

      debugPrint(
        '🏢 Warehouse: '
        '${result.facilityName}',
      );

      debugPrint(
        '🏪 Business Type: '
        '$ownerBusinessType',
      );

      debugPrint(
        '📦 Categories: '
        '$finalCategories',
      );

      debugPrint(
        '🆔 Category objects (id+name): '
        '$categoryObjects',
      );

      debugPrint(
        '📊 Profile completion: 25%',
      );

      debugPrint(
        '══════════════════════════════════════════',
      );

      return true;
    } catch (e, stackTrace) {
      debugPrint(
        '❌ Owner save preferences failed: $e',
      );

      debugPrint('$stackTrace');

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

  void selectSection(int sectionId) {
    if (sectionId <= 0) {
      return;
    }

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

      if (path == null || path.isEmpty) {
        Get.snackbar(
          'Error',
          'Could not access the selected file.',
        );

        return;
      }

      inventoryFile.value =
          File(path);

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
    if (isImportingInventory.value) {
      return false;
    }

    try {
      isImportingInventory.value = true;

      // ----------------------------------------------------------
      // FILE
      // ----------------------------------------------------------

      if (inventoryFile.value == null) {
        Get.snackbar(
          'Missing File',
          'Please select an Excel inventory file.',
        );

        return false;
      }

      // ----------------------------------------------------------
      // SECTION
      // ----------------------------------------------------------

      final sectionId =
          selectedSectionId.value;

      if (sectionId <= 0) {
        Get.snackbar(
          'Missing Section',
          'Please select a warehouse section.',
        );

        return false;
      }

      // ----------------------------------------------------------
      // FACILITY
      // ----------------------------------------------------------

      int? facilityId;

      if (savedPreferences.value != null) {
        facilityId =
            savedPreferences
                .value!
                .facility
                .id;
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

      // ----------------------------------------------------------
      // FILE PATH
      // ----------------------------------------------------------

      final filePath =
          inventoryFile.value!.path;

      if (filePath.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'The selected inventory file is not accessible.',
        );

        return false;
      }

      // ----------------------------------------------------------
      // API
      // ----------------------------------------------------------

      final result =
          await _onboardingRepo.importInventoryExcel(
        facilityId: facilityId,
        sectionId: sectionId,
        excelFilePath: filePath,
      );

      importedInventory.value =
          result;

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
      isImportingInventory.value =
          false;
    }
  }

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
          ownerIdPath.value =
              filePath;

          ownerIdUploaded.value =
              true;

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

  // ============================================================
  // UPLOAD DOCUMENTS
  // ============================================================

  Future<bool> uploadOnboardingDocuments() async {
    if (isUploadingDocuments.value) {
      return false;
    }

    try {
      isUploadingDocuments.value =
          true;

      // ----------------------------------------------------------
      // FACILITY
      // ----------------------------------------------------------

      int? facilityId;

      if (savedPreferences.value != null) {
        facilityId =
            savedPreferences
                .value!
                .facility
                .id;
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

      // ----------------------------------------------------------
      // IDENTITY DOCUMENT
      // ----------------------------------------------------------

      final identityPath =
          ownerIdPath.value;

      if (identityPath == null ||
          identityPath.trim().isEmpty) {
        Get.snackbar(
          'Missing Document',
          'Please upload your identity document.',
        );

        return false;
      }

      // ----------------------------------------------------------
      // OWNERSHIP DOCUMENT
      // ----------------------------------------------------------

      final facilityPath =
          ownershipProofPath.value;

      if (facilityPath == null ||
          facilityPath.trim().isEmpty) {
        Get.snackbar(
          'Missing Document',
          'Please upload the ownership document.',
        );

        return false;
      }

      // ----------------------------------------------------------
      // API
      // ----------------------------------------------------------

      final result =
          await _onboardingRepo
              .uploadOnboardingDocuments(
        facilityId: facilityId,
        identityDocumentPath:
            identityPath,
        facilityDocumentPath:
            facilityPath,
      );

      uploadedDocuments.value =
          result;

      // ----------------------------------------------------------
      // SAVE COMPLETION
      // ----------------------------------------------------------

      await PrefHelper.setOwnerDocumentsCompleted(
        true,
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
      isUploadingDocuments.value =
          false;
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
      case 0:
        return businessNameController
                .text
                .trim()
                .isNotEmpty &&
            selectedProducts.isNotEmpty;

      case 1:
        return inventoryFile.value != null;

      case 2:
        return ownerIdPath.value != null &&
            ownerIdPath.value!
                .trim()
                .isNotEmpty &&
            ownershipProofPath.value !=
                null &&
            ownershipProofPath.value!
                .trim()
                .isNotEmpty;

      case 3:
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
  // BACK
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

  // ============================================================
  // RESET
  // ============================================================

  Future<void> reset() async {
    currentStep.value = 0;

    profileCompletion.value = 0;

    // ----------------------------------------------------------
    // PROFILE
    // ----------------------------------------------------------

    businessNameController.clear();

    businessName.value = '';

    // ----------------------------------------------------------
    // PREFERENCES
    // ----------------------------------------------------------

    isProductsExpanded.value =
        false;

    preferredLanguage.value =
        'English';

    preferredCurrency.value =
        'USD';

    selectedProducts.clear();

    savedPreferences.value =
        null;

    isSavingPreferences.value =
        false;

    // ----------------------------------------------------------
    // INVENTORY
    // ----------------------------------------------------------

    removeInventoryFile();

    selectedSectionId.value = 1;

    isImportingInventory.value =
        false;

    importedInventory.value =
        null;

    // ----------------------------------------------------------
    // DOCUMENTS
    // ----------------------------------------------------------

    ownerIdPath.value = null;

    ownershipProofPath.value =
        null;

    ownerIdUploaded.value = false;

    ownershipProofUploaded.value =
        false;

    uploadedDocuments.value =
        null;

    isUploadingDocuments.value =
        false;

    // ----------------------------------------------------------
    // LOCATION
    // ----------------------------------------------------------

    address.value = '';

    city.value = '';

    country.value = '';

    // ----------------------------------------------------------
    // CLEAR PERSISTED OWNER DATA
    // ----------------------------------------------------------

    await PrefHelper.clearOwnerOnboarding();

    debugPrint(
      '🗑️ Owner onboarding reset.',
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
    businessNameController
        .removeListener(
      _onBusinessNameChanged,
    );

    businessNameController.dispose();

    super.onClose();
  }
}