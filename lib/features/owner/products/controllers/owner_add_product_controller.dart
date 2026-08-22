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
  // OWNER CATEGORIES
  // ============================================================

  final RxList<String> availableCategories =
      <String>[].obs;

  final RxList<String> selectedCategories =
      <String>[].obs;

  final RxList<Map<String, dynamic>> ownerCategories =
      <Map<String, dynamic>>[].obs;

  // ============================================================
  // LOADING
  // ============================================================

  final RxBool isLoading = false.obs;

  final RxBool isLoadingCategories = false.obs;

  bool _submitted = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    loadOwnerCategories();
  }

  // ============================================================
  // LOAD OWNER CATEGORIES
  // ============================================================

  Future<void> loadOwnerCategories() async {
    if (isLoadingCategories.value) {
      return;
    }

    try {
      isLoadingCategories.value = true;

      debugPrint(
        '════════ LOAD OWNER PRODUCT CATEGORIES ════════',
      );

      final storedCategories =
          await PrefHelper.getOwnerProductCategories();

      debugPrint(
        '📦 Stored categories: $storedCategories',
      );

      if (storedCategories.isEmpty) {
        ownerCategories.clear();
        availableCategories.clear();

        debugPrint(
          '❌ No owner categories found.',
        );

        return;
      }

      // ----------------------------------------------------------
      // NORMALIZE
      // ----------------------------------------------------------

      final validCategories =
          <Map<String, dynamic>>[];

      final usedIds = <int>{};
      final usedNames = <String>{};

      for (final category in storedCategories) {
        final rawId = category['id'];
        final rawName = category['name'];

        final id = rawId is int
            ? rawId
            : int.tryParse(
                rawId?.toString() ?? '',
              );

        final name =
            rawName?.toString().trim() ?? '';

        if (id == null || id <= 0) {
          debugPrint(
            '⚠️ Invalid category ID: $category',
          );
          continue;
        }

        if (name.isEmpty) {
          debugPrint(
            '⚠️ Empty category name: $category',
          );
          continue;
        }

        if (usedIds.contains(id)) {
          continue;
        }

        if (usedNames.contains(name.toLowerCase())) {
          continue;
        }

        usedIds.add(id);
        usedNames.add(name.toLowerCase());

        validCategories.add({
          'id': id,
          'name': name,
        });
      }

      // ----------------------------------------------------------
      // STORE IN CONTROLLER
      // ----------------------------------------------------------

      ownerCategories.assignAll(
        validCategories,
      );

      availableCategories.assignAll(
        validCategories
            .map(
              (category) =>
                  category['name'].toString(),
            )
            .toList(),
      );

      debugPrint(
        '✅ Owner categories loaded.',
      );

      for (final category in ownerCategories) {
        debugPrint(
          '   ID: ${category['id']} | '
          'NAME: ${category['name']}',
        );
      }

      debugPrint(
        '════════════════════════════════════════',
      );
    } catch (e, stackTrace) {
      debugPrint(
        '❌ Failed to load owner categories: $e',
      );

      debugPrint('$stackTrace');

      ownerCategories.clear();
      availableCategories.clear();
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // ============================================================
  // CATEGORY SELECTION
  // ============================================================

  bool isCategorySelected(
    String categoryName,
  ) {
    return selectedCategories.contains(
      categoryName,
    );
  }

  void toggleCategory(
    String categoryName,
  ) {
    final cleanName =
        categoryName.trim();

    if (cleanName.isEmpty) {
      return;
    }

    final category =
        ownerCategories.firstWhereOrNull(
      (item) {
        final name =
            item['name']?.toString().trim() ?? '';

        return name == cleanName;
      },
    );

    if (category == null) {
      debugPrint(
        '❌ Category not found: $cleanName',
      );

      debugPrint(
        'Available: ${ownerCategories.toList()}',
      );

      return;
    }

    if (selectedCategories.contains(cleanName)) {
      selectedCategories.remove(cleanName);

      debugPrint(
        '➖ Removed: $cleanName',
      );
    } else {
      selectedCategories.add(cleanName);

      debugPrint(
        '➕ Selected: $cleanName',
      );

      debugPrint(
        '🆔 Real category ID: ${category['id']}',
      );
    }

    debugPrint(
      '📦 Selected: ${selectedCategories.toList()}',
    );

    debugPrint(
      '🆔 IDs: $selectedCategoryIds',
    );
  }

  // ============================================================
  // SELECTED CATEGORY IDS
  // ============================================================

  List<int> get selectedCategoryIds {
    final ids = <int>[];

    for (final selectedName
        in selectedCategories) {
      final category =
          ownerCategories.firstWhereOrNull(
        (item) {
          final name =
              item['name']?.toString().trim() ?? '';

          return name == selectedName;
        },
      );

      if (category == null) {
        debugPrint(
          '⚠️ Cannot resolve category: '
          '$selectedName',
        );

        continue;
      }

      final rawId = category['id'];

      final id = rawId is int
          ? rawId
          : int.tryParse(
              rawId?.toString() ?? '',
            );

      if (id != null && id > 0) {
        ids.add(id);
      }
    }

    return ids.toSet().toList();
  }

  // ============================================================
  // GET CATEGORY ID
  // ============================================================

  int? getCategoryId(
    String categoryName,
  ) {
    final category =
        ownerCategories.firstWhereOrNull(
      (item) =>
          item['name']?.toString().trim() ==
          categoryName.trim(),
    );

    if (category == null) {
      return null;
    }

    final rawId = category['id'];

    if (rawId is int) {
      return rawId;
    }

    return int.tryParse(
      rawId?.toString() ?? '',
    );
  }

  // ============================================================
  // CATEGORY TITLE
  // ============================================================

  String categoryTitle(
    String category,
  ) {
    final clean =
        category.trim();

    return clean.isEmpty
        ? 'Category'.tr
        : clean;
  }

  // ============================================================
  // CATEGORY ICON
  // ============================================================

  IconData categoryIcon(
    String category,
  ) {
    final normalized =
        category.trim().toLowerCase();

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
      final image =
          await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1600,
        maxHeight: 1600,
      );

      if (image == null) {
        return;
      }

      selectedImage.value =
          File(image.path);
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to select image'.tr,
        snackPosition:
            SnackPosition.BOTTOM,
      );
    }
  }

  void removeImage() {
    selectedImage.value = null;
  }

  // ============================================================
  // UNIT
  // ============================================================

  void selectUnit(
    String? unit,
  ) {
    if (unit == null ||
        unit.trim().isEmpty) {
      return;
    }

    selectedUnit.value =
        unit.trim();
  }

  // ============================================================
  // VALIDATORS
  // ============================================================

  String? validateSku(
    String? value,
  ) {
    final sku =
        value?.trim() ?? '';

    if (sku.isEmpty) {
      return 'SKU is required'.tr;
    }

    if (!RegExp(
      r'^[A-Za-z0-9_-]+$',
    ).hasMatch(sku)) {
      return 'Use only letters, numbers, _ or -'.tr;
    }

    if (sku.length > 100) {
      return 'SKU must not exceed 100 characters'.tr;
    }

    return null;
  }

  String? validateName(
    String? value,
  ) {
    final name =
        value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Product name is required'.tr;
    }

    if (name.length > 255) {
      return 'Product name is too long'.tr;
    }

    return null;
  }

  String? validateDescription(
    String? value,
  ) {
    final description =
        value?.trim() ?? '';

    if (description.isEmpty) {
      return 'Description is required'.tr;
    }

    return null;
  }

  String? validateQuantity(
    String? value,
  ) {
    final quantity =
        int.tryParse(
      value?.trim() ?? '',
    );

    if (quantity == null) {
      return 'Enter a valid quantity'.tr;
    }

    if (quantity < 0) {
      return 'Quantity cannot be negative'.tr;
    }

    return null;
  }

  String? validateUnitPrice(
    String? value,
  ) {
    final price =
        double.tryParse(
      value?.trim() ?? '',
    );

    if (price == null) {
      return 'Enter a valid unit price'.tr;
    }

    if (price < 0) {
      return 'Unit price cannot be negative'.tr;
    }

    return null;
  }

  // ============================================================
  // CREATE PRODUCT
  // ============================================================

  Future<void> createProduct() async {
    if (_submitted ||
        isLoading.value) {
      return;
    }

    FocusManager
        .instance
        .primaryFocus
        ?.unfocus();

    final form =
        formKey.currentState;

    if (form == null ||
        !form.validate()) {
      return;
    }

    // ----------------------------------------------------------
    // UNIT
    // ----------------------------------------------------------

    if (selectedUnit.value
        .trim()
        .isEmpty) {
      Get.snackbar(
        'Missing Unit'.tr,
        'Please select a unit.'.tr,
        snackPosition:
            SnackPosition.BOTTOM,
      );

      return;
    }

    // ----------------------------------------------------------
    // CATEGORIES
    // ----------------------------------------------------------

    if (ownerCategories.isEmpty) {
      await loadOwnerCategories();
    }

    if (ownerCategories.isEmpty) {
      Get.snackbar(
        'Categories Unavailable'.tr,
        'No product categories are available for this warehouse.'
            .tr,
        snackPosition:
            SnackPosition.BOTTOM,
      );

      return;
    }

    if (selectedCategories.isEmpty) {
      Get.snackbar(
        'Missing Categories'.tr,
        'Please select at least one category.'.tr,
        snackPosition:
            SnackPosition.BOTTOM,
      );

      return;
    }

    // ----------------------------------------------------------
    // REAL CATEGORY IDS
    // ----------------------------------------------------------

    final categoryIds =
        selectedCategoryIds;

    debugPrint(
      '════════ CREATE PRODUCT CATEGORIES ════════',
    );

    debugPrint(
      '🏷 Names: ${selectedCategories.toList()}',
    );

    debugPrint(
      '🆔 REAL IDs: $categoryIds',
    );

    debugPrint(
      '════════════════════════════════════════',
    );

    if (categoryIds.isEmpty) {
      Get.snackbar(
        'Invalid Categories'.tr,
        'The selected categories could not be resolved.'.tr,
        snackPosition:
            SnackPosition.BOTTOM,
      );

      return;
    }

    // ----------------------------------------------------------
    // QUANTITY
    // ----------------------------------------------------------

    final quantity =
        int.tryParse(
      quantityController.text.trim(),
    );

    if (quantity == null) {
      Get.snackbar(
        'Invalid Quantity'.tr,
        'Please enter a valid quantity.'.tr,
        snackPosition:
            SnackPosition.BOTTOM,
      );

      return;
    }

    // ----------------------------------------------------------
    // PRICE
    // ----------------------------------------------------------

    final unitPrice =
        double.tryParse(
      unitPriceController.text.trim(),
    );

    if (unitPrice == null) {
      Get.snackbar(
        'Invalid Unit Price'.tr,
        'Please enter a valid unit price.'.tr,
        snackPosition:
            SnackPosition.BOTTOM,
      );

      return;
    }

    // ----------------------------------------------------------
    // CREATE
    // ----------------------------------------------------------

    try {
      _submitted = true;
      isLoading.value = true;

      debugPrint(
        '════════ CREATE PRODUCT START ════════',
      );

      final result =
          await _repo.createProduct(
        sku:
            skuController.text.trim(),
        nameEn:
            nameController.text.trim(),
        unit:
            selectedUnit.value.trim(),
        unitPrice:
            unitPrice,
        categories:
            categoryIds,
        descriptionEn:
            descriptionController
                .text
                .trim(),
        quantity:
            quantity,
        productImage:
            selectedImage.value,
      );

      debugPrint(
        '════════ PRODUCT CREATED ════════',
      );

      debugPrint(
        '🆔 Product ID: ${result.data.id}',
      );

      debugPrint(
        '📦 SKU: ${result.data.sku}',
      );

      debugPrint(
        '📝 Name: ${result.data.name}',
      );

      debugPrint(
        '🏷 Category IDs sent: $categoryIds',
      );

      debugPrint(
        '══════════════════════════════════',
      );

      Get.back<bool>(
        result: true,
      );
    } on ApiError catch (e) {
      _submitted = false;

      Get.snackbar(
        'Error'.tr,
        e.message,
        snackPosition:
            SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      _submitted = false;

      debugPrint(
        '❌ Create product error: $e',
      );

      debugPrint(
        '$stackTrace',
      );

      Get.snackbar(
        'Error'.tr,
        'Failed to create product.'.tr,
        snackPosition:
            SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
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
