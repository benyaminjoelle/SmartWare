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
  // CATEGORIES
  // ============================================================

  final RxList<String> availableCategories = <String>[].obs;

  final RxList<String> selectedCategories = <String>[].obs;

  final Map<String, int> categoryIds = {
    'canned_foods': 1,
    'fresh_foods': 2,
    'refrigerated_foods': 3,
    'frozen_foods': 4,
    'baby_care': 27,
    'medical_equipment': 28,
    'vitamins_supplements': 29,
  };

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

    print('════════ EDIT PRODUCT CONTROLLER INIT ════════');
    print('🆔 Product ID: ${inventory.product.id}');

    _initializeProduct();
    _loadAllowedCategories();
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

    selectedUnit.value = product.unit;

    existingImage.value = product.productImage;

    print('📦 SKU: ${skuController.text}');
    print('📝 Name: ${nameController.text}');
    print('📏 Unit: ${selectedUnit.value}');
    print('📦 Quantity: ${quantityController.text}');
    print('💰 Unit Price: ${unitPriceController.text}');
    print('🖼 Existing Image: ${existingImage.value}');
  }

  // ============================================================
  // LOAD OWNER CATEGORIES
  // ============================================================

  Future<void> _loadAllowedCategories() async {
    try {
      final categories =
          await PrefHelper.getOwnerSelectedProducts();

      if (categories == null || categories.isEmpty) {
        print('⚠️ No owner categories found');
        return;
      }

      availableCategories.assignAll(categories);

      print(
        '🏷 Owner categories: '
        '${availableCategories.toList()}',
      );

      // IMPORTANT:
      // Existing product categories should only be selected
      // if they belong to the owner's allowed categories.
      //
      // If your inventory API currently doesn't return category
      // names/IDs, we cannot magically reconstruct them here.
      //
      // We will populate these from the product category data
      // once that is returned by your backend.
    } catch (e) {
      print('❌ Failed to load owner categories: $e');
    }
  }

  // ============================================================
  // CATEGORY HELPERS
  // ============================================================

  bool isCategorySelected(String category) {
    return selectedCategories.contains(category);
  }

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }

    print(
      '🏷 Selected categories: '
      '${selectedCategories.toList()}',
    );
  }

  List<int> get selectedCategoryIds {
    final ids = selectedCategories
        .map((category) => categoryIds[category])
        .whereType<int>()
        .toList();

    print('🆔 Category IDs: $ids');

    return ids;
  }

  String categoryTitle(String category) {
    switch (category) {
      case 'canned_foods':
        return 'Canned Foods';

      case 'fresh_foods':
        return 'Fresh Foods';

      case 'refrigerated_foods':
        return 'Refrigerated Foods';

      case 'frozen_foods':
        return 'Frozen Foods';

      case 'baby_care':
        return 'Baby Care';

      case 'medical_equipment':
        return 'Medical Equipment';

      case 'vitamins_supplements':
        return 'Vitamins & Supplements';

      default:
        return category
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (word) => word.isEmpty
                  ? word
                  : '${word[0].toUpperCase()}'
                    '${word.substring(1)}',
            )
            .join(' ');
    }
  }

  IconData categoryIcon(String category) {
    switch (category) {
      case 'canned_foods':
        return Icons.inventory_2_outlined;

      case 'fresh_foods':
        return Icons.eco_outlined;

      case 'refrigerated_foods':
        return Icons.kitchen_outlined;

      case 'frozen_foods':
        return Icons.ac_unit;

      case 'baby_care':
        return Icons.child_care_outlined;

      case 'medical_equipment':
        return Icons.medical_services_outlined;

      case 'vitamins_supplements':
        return Icons.medication_outlined;

      default:
        return Icons.category_outlined;
    }
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

      print('🖼️ New image selected: ${image.path}');
    } catch (e) {
      print('❌ Image error: $e');

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

    if (selectedCategories.isEmpty) {
      Get.snackbar(
        'Missing Categories',
        'Please select at least one category',
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

      final result = await _repo.updateProduct(
        productId: inventory.product.id,
        sku: skuController.text.trim(),
        nameEn: nameController.text.trim(),
        unit: selectedUnit.value.trim(),
        quantity: quantity,
        unitPrice: unitPrice,
        categories: selectedCategoryIds,
        descriptionEn:
            descriptionController.text.trim(),
        productImage: selectedImage.value,
      );

      print('✅ PRODUCT UPDATED');

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

      print('❌ UPDATE ERROR: $e');

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