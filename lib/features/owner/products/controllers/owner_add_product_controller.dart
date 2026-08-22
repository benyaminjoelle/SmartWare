import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/utils/pref_helper.dart';
import 'package:smartware/features/owner/products/models/products_repo.dart';

class AddProductController extends GetxController {
  // ============================================================
  // REPOSITORY
  // ============================================================

  final ProductsRepo _repo = ProductsRepo();

  // ============================================================
  // FORM
  // ============================================================

  final formKey = GlobalKey<FormState>();

  final skuController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final unitPriceController = TextEditingController();

  // ============================================================
  // IMAGE
  // ============================================================

  final ImagePicker _imagePicker = ImagePicker();

  final Rxn<File> selectedImage = Rxn<File>();

  // ============================================================
  // UNIT
  // ============================================================

  final RxString selectedUnit = ''.obs;

  final List<String> units = [
    'box',
    'carton',
    'bottle',
    'can',
    'jar',
    'pack',
    'piece',
    'pallet',
  ];

  // ============================================================
  // CATEGORIES
  // ============================================================

  /// Categories allowed for THIS owner.
  ///
  /// These names come from PrefHelper.
  /// Nothing is hardcoded here.
  final RxList<String> availableCategories = <String>[].obs;

  /// Categories selected by the user.
  ///
  /// These are category names because this keeps the existing
  /// category selector compatible.
  final RxList<String> selectedCategories = <String>[].obs;

  /// Actual category objects returned from the backend and
  /// persisted in PrefHelper.
  ///
  /// Example:
  ///
  /// [
  ///   {
  ///     "id": 1,
  ///     "name": "Canned Foods"
  ///   },
  ///   {
  ///     "id": 4,
  ///     "name": "Frozen Foods"
  ///   }
  /// ]
  final RxList<Map<String, dynamic>> _ownerCategories =
      <Map<String, dynamic>>[].obs;

  // ============================================================
  // LOADING
  // ============================================================

  final RxBool isLoading = false.obs;

  // ============================================================
  // DOUBLE SUBMISSION PROTECTION
  // ============================================================

  bool _submitted = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    print('════════ ADD PRODUCT CONTROLLER INIT ════════');

    _loadAllowedCategories();
  }

  // ============================================================
  // LOAD OWNER CATEGORIES
  // ============================================================

  Future<void> _loadAllowedCategories() async {
    try {
      print('════════ LOAD OWNER CATEGORIES ════════');

      final categories =
          await PrefHelper.getOwnerProductCategories();

      if (categories.isEmpty) {
        print('⚠️ No owner product categories found');

        availableCategories.clear();
        _ownerCategories.clear();

        return;
      }

      // ----------------------------------------------------------
      // STORE ACTUAL CATEGORY DATA
      // ----------------------------------------------------------

      _ownerCategories.assignAll(categories);

      // ----------------------------------------------------------
      // EXPOSE CATEGORY NAMES TO THE UI
      // ----------------------------------------------------------

      availableCategories.assignAll(
        categories
            .map(
              (category) => category['name']?.toString() ?? '',
            )
            .where((name) => name.isNotEmpty)
            .toList(),
      );

      print('🏷 Owner categories loaded:');

      for (final category in _ownerCategories) {
        print(
          '   ID: ${category['id']} | '
          'Name: ${category['name']}',
        );
      }

      print(
        '🏷 Available category names: '
        '${availableCategories.toList()}',
      );

      print('══════════════════════════════════════');
    } catch (e) {
      print('❌ Failed to load owner categories: $e');

      availableCategories.clear();
      _ownerCategories.clear();
    }
  }

  // ============================================================
  // CATEGORY HELPERS
  // ============================================================

  /// Returns true if the category is currently selected.
  bool isCategorySelected(String category) {
    return selectedCategories.contains(category);
  }

  /// Select/unselect a category.
  ///
  /// The category MUST exist in the owner's allowed categories.
  void toggleCategory(String category) {
    // ----------------------------------------------------------
    // SAFETY CHECK
    // ----------------------------------------------------------

    final exists = _ownerCategories.any(
      (item) =>
          item['name']?.toString() == category,
    );

    if (!exists) {
      print(
        '⚠️ Attempted to select category that is not allowed: '
        '$category',
      );

      return;
    }

    // ----------------------------------------------------------
    // TOGGLE
    // ----------------------------------------------------------

    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }

    print(
      '🏷 Selected categories: '
      '${selectedCategories.toList()}',
    );

    print(
      '🆔 Selected category IDs: '
      '${selectedCategoryIds}',
    );
  }

  /// Returns the actual backend IDs for the selected categories.
  ///
  /// These IDs come ONLY from PrefHelper/backend data.
  List<int> get selectedCategoryIds {
    final ids = <int>[];

    for (final selectedCategory in selectedCategories) {
      final category = _ownerCategories.firstWhereOrNull(
        (item) =>
            item['name']?.toString() == selectedCategory,
      );

      if (category == null) {
        print(
          '⚠️ Could not find ID for selected category: '
          '$selectedCategory',
        );

        continue;
      }

      final rawId = category['id'];

      final id = rawId is int
          ? rawId
          : int.tryParse(rawId?.toString() ?? '');

      if (id != null && id > 0) {
        ids.add(id);
      }
    }

    print('🆔 Category IDs: $ids');

    return ids;
  }

  /// Returns the backend ID for a category.
  int? getCategoryId(String categoryName) {
    final category = _ownerCategories.firstWhereOrNull(
      (item) =>
          item['name']?.toString() == categoryName,
    );

    if (category == null) {
      return null;
    }

    final rawId = category['id'];

    if (rawId is int) {
      return rawId;
    }

    return int.tryParse(rawId?.toString() ?? '');
  }

  // ============================================================
  // CATEGORY TITLE
  // ============================================================

  String categoryTitle(String category) {
    if (category.trim().isEmpty) {
      return 'Category';
    }

    return category;
  }

  // ============================================================
  // CATEGORY ICON
  // ============================================================

  IconData categoryIcon(String category) {
    final normalized = category
        .trim()
        .toLowerCase();

    if (normalized.contains('canned')) {
      return Icons.inventory_2_outlined;
    }

    if (normalized.contains('fresh')) {
      return Icons.eco_outlined;
    }

    if (normalized.contains('refrigerated')) {
      return Icons.kitchen_outlined;
    }

    if (normalized.contains('frozen')) {
      return Icons.ac_unit;
    }

    if (normalized.contains('baby')) {
      return Icons.child_care_outlined;
    }

    if (normalized.contains('medical')) {
      return Icons.medical_services_outlined;
    }

    if (normalized.contains('vitamin') ||
        normalized.contains('supplement')) {
      return Icons.medication_outlined;
    }

    return Icons.category_outlined;
  }

  // ============================================================
  // IMAGE PICKER
  // ============================================================

  Future<void> pickImage() async {
    try {
      print('🖼️ Opening image picker...');

      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1600,
        maxHeight: 1600,
      );

      if (image == null) {
        print('⚠️ Image selection cancelled');
        return;
      }

      selectedImage.value = File(image.path);

      print(
        '🖼️ Image selected: ${image.path}',
      );
    } catch (e) {
      print('❌ Image error: $e');

      Get.snackbar(
        'Error',
        'Failed to select image',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ============================================================
  // REMOVE IMAGE
  // ============================================================

  void removeImage() {
    selectedImage.value = null;

    print('🖼️ Product image removed');
  }

  // ============================================================
  // UNIT
  // ============================================================

  void selectUnit(String? unit) {
    if (unit == null || unit.trim().isEmpty) {
      return;
    }

    selectedUnit.value = unit.trim();

    print('📏 Unit: ${selectedUnit.value}');
  }

  // ============================================================
  // VALIDATION - SKU
  // ============================================================

  String? validateSku(String? value) {
    final sku = value?.trim() ?? '';

    if (sku.isEmpty) {
      return 'SKU is required';
    }

    if (!RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(sku)) {
      return 'Use only letters, numbers, _ or -';
    }

    if (sku.length > 100) {
      return 'SKU must not exceed 100 characters';
    }

    return null;
  }

  // ============================================================
  // VALIDATION - NAME
  // ============================================================

  String? validateName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Product name is required';
    }

    if (name.length > 255) {
      return 'Product name is too long';
    }

    return null;
  }

  // ============================================================
  // VALIDATION - DESCRIPTION
  // ============================================================

  String? validateDescription(String? value) {
    final description = value?.trim() ?? '';

    if (description.isEmpty) {
      return 'Description is required';
    }

    return null;
  }

  // ============================================================
  // VALIDATION - QUANTITY
  // ============================================================

  String? validateQuantity(String? value) {
    final quantity = int.tryParse(
      value?.trim() ?? '',
    );

    if (quantity == null) {
      return 'Enter a valid quantity';
    }

    if (quantity < 0) {
      return 'Quantity cannot be negative';
    }

    return null;
  }

  // ============================================================
  // VALIDATION - UNIT PRICE
  // ============================================================

  String? validateUnitPrice(String? value) {
    final price = double.tryParse(
      value?.trim() ?? '',
    );

    if (price == null) {
      return 'Enter a valid unit price';
    }

    if (price < 0) {
      return 'Unit price cannot be negative';
    }

    return null;
  }

  // ============================================================
  // CREATE PRODUCT
  // ============================================================

  Future<void> createProduct() async {
    print('');
    print('🚨 CREATE PRODUCT BUTTON PRESSED');

    // ----------------------------------------------------------
    // PREVENT DOUBLE REQUEST
    // ----------------------------------------------------------

    if (_submitted || isLoading.value) {
      print('⚠️ CREATE ALREADY IN PROGRESS');
      return;
    }

    // ----------------------------------------------------------
    // HIDE KEYBOARD
    // ----------------------------------------------------------

    FocusManager.instance.primaryFocus?.unfocus();

    // ----------------------------------------------------------
    // FORM
    // ----------------------------------------------------------

    final form = formKey.currentState;

    if (form == null) {
      print('❌ Form state is null');
      return;
    }

    if (!form.validate()) {
      print('❌ Form validation failed');
      return;
    }

    // ----------------------------------------------------------
    // UNIT
    // ----------------------------------------------------------

    if (selectedUnit.value.trim().isEmpty) {
      Get.snackbar(
        'Missing Unit',
        'Please select a unit',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    // ----------------------------------------------------------
    // OWNER CATEGORIES
    // ----------------------------------------------------------

    if (_ownerCategories.isEmpty) {
      Get.snackbar(
        'Categories Unavailable',
        'Your allowed product categories could not be loaded.',
        snackPosition: SnackPosition.BOTTOM,
      );

      print(
        '❌ Cannot create product because owner categories '
        'are empty',
      );

      return;
    }

    // ----------------------------------------------------------
    // SELECTED CATEGORIES
    // ----------------------------------------------------------

    if (selectedCategories.isEmpty) {
      Get.snackbar(
        'Missing Categories',
        'Please select at least one category',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    // ----------------------------------------------------------
    // RESOLVE REAL BACKEND CATEGORY IDS
    // ----------------------------------------------------------

    final categoryIdsToSend =
        selectedCategoryIds;

    if (categoryIdsToSend.isEmpty) {
      Get.snackbar(
        'Invalid Categories',
        'The selected categories could not be resolved.',
        snackPosition: SnackPosition.BOTTOM,
      );

      print(
        '❌ Selected categories: '
        '${selectedCategories.toList()}',
      );

      return;
    }

    // ----------------------------------------------------------
    // QUANTITY
    // ----------------------------------------------------------

    final quantity = int.tryParse(
      quantityController.text.trim(),
    );

    if (quantity == null) {
      Get.snackbar(
        'Invalid Quantity',
        'Please enter a valid quantity.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    // ----------------------------------------------------------
    // UNIT PRICE
    // ----------------------------------------------------------

    final unitPrice = double.tryParse(
      unitPriceController.text.trim(),
    );

    if (unitPrice == null) {
      Get.snackbar(
        'Invalid Unit Price',
        'Please enter a valid unit price.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    // ----------------------------------------------------------
    // SUBMIT
    // ----------------------------------------------------------

    try {
      _submitted = true;
      isLoading.value = true;

      print('');
      print('════════ CREATE PRODUCT START ════════');

      print(
        '📦 SKU: ${skuController.text.trim()}',
      );

      print(
        '📝 Name: ${nameController.text.trim()}',
      );

      print(
        '📏 Unit: ${selectedUnit.value}',
      );

      print(
        '💰 Unit Price: $unitPrice',
      );

      print(
        '📦 Quantity: $quantity',
      );

      print(
        '🏷 Selected Categories: '
        '${selectedCategories.toList()}',
      );

      print(
        '🆔 Category IDs: '
        '$categoryIdsToSend',
      );

      print(
        '📄 Description: '
        '${descriptionController.text.trim()}',
      );

      print(
        '🖼️ Image: '
        '${selectedImage.value?.path ?? 'No image'}',
      );

      print('════════════════════════════════════');

      // --------------------------------------------------------
      // API REQUEST
      // --------------------------------------------------------

      final result = await _repo.createProduct(
        sku: skuController.text.trim(),
        nameEn: nameController.text.trim(),
        unit: selectedUnit.value.trim(),
        unitPrice: unitPrice,
        categories: categoryIdsToSend,
        descriptionEn: descriptionController.text.trim(),
        quantity: quantity,
        productImage: selectedImage.value,
      );

      // --------------------------------------------------------
      // SUCCESS
      // --------------------------------------------------------

      print('');
      print('════════ PRODUCT CREATED ════════');

      print(
        '🆔 Product ID: ${result.data.id}',
      );

      print(
        '📦 SKU: ${result.data.sku}',
      );

      print(
        '📝 Name: ${result.data.name}',
      );

      print('════════════════════════════════');

      // --------------------------------------------------------
      // RETURN TO PREVIOUS SCREEN
      // --------------------------------------------------------

      print(
        '⬅️ POPPING ADD PRODUCT SCREEN WITH TRUE',
      );

      if (Get.isOverlaysOpen) {
        print(
          '⚠️ Overlay is open, closing it first',
        );

        Get.back();
      }

      Get.back<bool>(result: true);

      print(
        '✅ ADD PRODUCT SCREEN POPPED',
      );
    } on ApiError catch (e) {
      _submitted = false;

      print(
        '❌ API ERROR: ${e.message}',
      );

      Get.snackbar(
        'Error',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      _submitted = false;

      print(
        '❌ CREATE PRODUCT ERROR: $e',
      );

      print(
        '❌ StackTrace: $stackTrace',
      );

      Get.snackbar(
        'Error',
        'Failed to create product',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;

      print(
        '🏁 createProduct() FINISHED',
      );
    }
  }

  // ============================================================
  // CLOSE
  // ============================================================

  @override
  void onClose() {
    skuController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    unitPriceController.dispose();

    super.onClose();
  }
}