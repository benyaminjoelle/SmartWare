import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/utils/pref_helper.dart';
import 'package:smartware/features/owner/products/models/owner_inventory_model.dart';
import 'package:smartware/features/owner/products/models/products_repo.dart';

class EditProductController extends GetxController {
  final ProductsRepo _repo = ProductsRepo();

  final OwnerInventoryModel inventory;

  EditProductController({
    required this.inventory,
  });

  final formKey = GlobalKey<FormState>();

  // ============================================================
  // TEXT CONTROLLERS
  // ============================================================

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

  // Existing image from backend
  final RxnString existingImage = RxnString();

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
  //
  // Categories come from the SAME source of truth as
  // AddProductController: PrefHelper.getOwnerProductCategories(),
  // which stores the REAL {id, name} objects returned by the
  // backend after onboarding / preferences update.
  //
  // ⚠️ KNOWN LIMITATION:
  // The inventory/product API currently does NOT return which
  // categories this specific product already belongs to
  // (OwnerProductModel has no `categories` field). So this screen
  // cannot preselect the product's current categories — the user
  // must re-select them from scratch, and whatever they pick
  // fully replaces the product's categories on save. Ask backend
  // to add `categories` to the product JSON to fix this properly.
  //
  // ============================================================

  /// Category names shown by the UI.
  final RxList<String> availableCategories = <String>[].obs;

  /// Category names currently selected for this product.
  final RxList<String> selectedCategories = <String>[].obs;

  /// REAL owner categories: [{'id': 1, 'name': 'Canned Foods'}, ...]
  final RxList<Map<String, dynamic>> ownerCategories =
      <Map<String, dynamic>>[].obs;

  final RxBool isLoadingCategories = false.obs;

  // ============================================================
  // STATE
  // ============================================================

  final RxBool isLoading = false.obs;

  bool _submitted = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    debugPrint('════════ EDIT PRODUCT CONTROLLER INIT ════════');
    debugPrint('🆔 Product ID: ${inventory.product.id}');

    _initializeProduct();
    _loadOwnerCategoriesThenPreselect();
  }

  // ============================================================
  // INITIALIZE PRODUCT DATA
  // ============================================================

  void _initializeProduct() {
    final product = inventory.product;

    skuController.text = product.sku;
    nameController.text = product.nameEn;

    descriptionController.text =
        product.descriptionEn ?? '';

    quantityController.text =
        inventory.quantity.toString();

    unitPriceController.text =
        inventory.unitPrice.toString();

    existingImage.value = product.productImage;

    // ------------------------------------------------------------
    // ⚠️ GUARD: backend can return a unit string (e.g. "قطعة")
    // that doesn't match any entry in the hardcoded `units` list.
    // Setting selectedUnit to an unknown value crashes the
    // DropdownButtonFormField, since Flutter requires the current
    // value to match exactly one item.
    //
    // If it doesn't match, we leave the dropdown unselected and
    // ask the user to pick again, instead of crashing.
    // ------------------------------------------------------------

    final incomingUnit = product.unit.trim();

    if (units.contains(incomingUnit)) {
      selectedUnit.value = incomingUnit;
    } else {
      debugPrint(
        '⚠️ Unit "$incomingUnit" from backend is not in the known '
        'units list: $units. Leaving unit unselected.',
      );

      selectedUnit.value = '';
    }

    debugPrint('📦 SKU: ${skuController.text}');
    debugPrint('📝 Name: ${nameController.text}');
    debugPrint('📏 Unit (raw from backend): $incomingUnit');
    debugPrint('📏 Unit (applied to dropdown): ${selectedUnit.value}');
    debugPrint('📦 Quantity: ${quantityController.text}');
    debugPrint('💰 Unit Price: ${unitPriceController.text}');
    debugPrint('🖼 Existing Image: ${existingImage.value}');

    // ------------------------------------------------------------
    // ⚠️ TODO — PRESELECT EXISTING PRODUCT CATEGORIES
    // ------------------------------------------------------------
    //
    // `inventory.product` currently exposes no category data, so
    // we cannot preselect this product's existing categories here.
    // Once the backend adds `categories` to the product JSON, this
    // is where we'd match those against `ownerCategories` (loaded
    // below) and call `selectedCategories.assignAll(...)`.
    // ------------------------------------------------------------
  }

  // ============================================================
  // LOAD OWNER CATEGORIES (REAL {id, name} DATA)
  // ============================================================

  Future<void> _loadOwnerCategoriesThenPreselect() async {
    if (isLoadingCategories.value) {
      return;
    }

    try {
      isLoadingCategories.value = true;

      debugPrint(
        '════════ LOAD OWNER PRODUCT CATEGORIES (EDIT) ════════',
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
      // NORMALIZE (same logic as AddProductController)
      // ----------------------------------------------------------

      final validCategories = <Map<String, dynamic>>[];

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

      ownerCategories.assignAll(validCategories);

      availableCategories.assignAll(
        validCategories
            .map(
              (category) => category['name'].toString(),
            )
            .toList(),
      );

      debugPrint('✅ Owner categories loaded.');

      for (final category in ownerCategories) {
        debugPrint(
          '   ID: ${category['id']} | '
          'NAME: ${category['name']}',
        );
      }

      debugPrint(
        '════════════════════════════════════════',
      );

      // TODO: once product-category data is known, preselect here.
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
  // CATEGORY HELPERS
  // ============================================================

  bool isCategorySelected(String categoryName) {
    return selectedCategories.contains(categoryName);
  }

  void toggleCategory(String categoryName) {
    final cleanName = categoryName.trim();

    if (cleanName.isEmpty) {
      return;
    }

    final category = ownerCategories.firstWhereOrNull(
      (item) {
        final name = item['name']?.toString().trim() ?? '';
        return name == cleanName;
      },
    );

    if (category == null) {
      debugPrint('❌ Category not found: $cleanName');
      debugPrint('Available: ${ownerCategories.toList()}');
      return;
    }

    if (selectedCategories.contains(cleanName)) {
      selectedCategories.remove(cleanName);
      debugPrint('➖ Removed: $cleanName');
    } else {
      selectedCategories.add(cleanName);
      debugPrint('➕ Selected: $cleanName');
      debugPrint('🆔 Real category ID: ${category['id']}');
    }

    debugPrint(
      '📦 Selected: ${selectedCategories.toList()}',
    );
    debugPrint('🆔 IDs: $selectedCategoryIds');
  }

  List<int> get selectedCategoryIds {
    final ids = <int>[];

    for (final selectedName in selectedCategories) {
      final category = ownerCategories.firstWhereOrNull(
        (item) {
          final name = item['name']?.toString().trim() ?? '';
          return name == selectedName;
        },
      );

      if (category == null) {
        debugPrint(
          '⚠️ Cannot resolve category: $selectedName',
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

    return ids.toSet().toList();
  }

  int? getCategoryId(String categoryName) {
    final category = ownerCategories.firstWhereOrNull(
      (item) =>
          item['name']?.toString().trim() == categoryName.trim(),
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

  String categoryTitle(String category) {
    final clean = category.trim();
    return clean.isEmpty ? 'Category' : clean;
  }

  IconData categoryIcon(String category) {
    final normalized = category.trim().toLowerCase();

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
  // IMAGE
  // ============================================================

  Future<void> pickImage() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1600,
        maxHeight: 1600,
      );

      if (image == null) {
        return;
      }

      selectedImage.value = File(image.path);

      debugPrint('🖼️ New image selected: ${image.path}');
    } catch (e) {
      debugPrint('❌ Image error: $e');

      Get.snackbar(
        'Error',
        'Failed to select image',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeImage() {
    selectedImage.value = null;
    existingImage.value = null;
  }

  // ============================================================
  // UNIT
  // ============================================================

  void selectUnit(String? unit) {
    if (unit == null) return;

    // ------------------------------------------------------------
    // Defensive guard: only allow values that actually exist in
    // the dropdown's item list, to avoid ever putting the
    // DropdownButtonFormField into an invalid state.
    // ------------------------------------------------------------

    if (!units.contains(unit)) {
      debugPrint('⚠️ Attempted to select unknown unit: $unit');
      return;
    }

    selectedUnit.value = unit;
  }

  // ============================================================
  // VALIDATION
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

  String? validateDescription(String? value) {
    if ((value?.trim() ?? '').isEmpty) {
      return 'Description is required';
    }

    return null;
  }

  String? validateQuantity(String? value) {
    final quantity =
        int.tryParse(value?.trim() ?? '');

    if (quantity == null) {
      return 'Enter a valid quantity';
    }

    if (quantity < 0) {
      return 'Quantity cannot be negative';
    }

    return null;
  }

  String? validateUnitPrice(String? value) {
    final price =
        double.tryParse(value?.trim() ?? '');

    if (price == null) {
      return 'Enter a valid unit price';
    }

    if (price < 0) {
      return 'Unit price cannot be negative';
    }

    return null;
  }

  // ============================================================
  // UPDATE PRODUCT
  // ============================================================

  Future<void> updateProduct() async {
    if (_submitted || isLoading.value) {
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    final form = formKey.currentState;

    if (form == null || !form.validate()) {
      return;
    }

    if (selectedUnit.value.isEmpty) {
      Get.snackbar(
        'Missing Unit',
        'Please select a unit',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (ownerCategories.isEmpty) {
      // Try once more in case categories were loaded after init.
      await _loadOwnerCategoriesThenPreselect();
    }

    if (ownerCategories.isEmpty) {
      Get.snackbar(
        'Categories Unavailable',
        'No product categories are available for this warehouse.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedCategories.isEmpty) {
      Get.snackbar(
        'Missing Categories',
        'Please select at least one category',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final categoryIds = selectedCategoryIds;

    if (categoryIds.isEmpty) {
      Get.snackbar(
        'Invalid Categories',
        'The selected categories could not be resolved.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final quantity =
        int.tryParse(quantityController.text.trim());

    final unitPrice =
        double.tryParse(unitPriceController.text.trim());

    if (quantity == null || unitPrice == null) {
      return;
    }

    try {
      _submitted = true;
      isLoading.value = true;

      debugPrint('════════ UPDATE PRODUCT CATEGORIES ════════');
      debugPrint('🏷 Names: ${selectedCategories.toList()}');
      debugPrint('🆔 REAL IDs: $categoryIds');
      debugPrint('════════════════════════════════════════');

      await _repo.updateProduct(
        productId: inventory.product.id,
        sku: skuController.text.trim(),
        nameEn: nameController.text.trim(),
        unit: selectedUnit.value.trim(),
        quantity: quantity,
        unitPrice: unitPrice,
        categories: categoryIds,
        descriptionEn:
            descriptionController.text.trim(),
        productImage: selectedImage.value,
      );

      debugPrint('✅ PRODUCT UPDATED');

      Get.back<bool>(result: true);
    } on ApiError catch (e) {
      _submitted = false;

      Get.snackbar(
        'Error',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _submitted = false;

      debugPrint('❌ UPDATE ERROR: $e');

      Get.snackbar(
        'Error',
        'Failed to update product',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

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