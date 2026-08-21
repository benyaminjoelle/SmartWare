import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/utils/pref_helper.dart';
import 'package:smartware/features/owner/products/models/products_repo.dart';

class AddProductController extends GetxController {
  final ProductsRepo _repo = ProductsRepo();

  final formKey = GlobalKey<FormState>();

  final skuController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final sectionIdController = TextEditingController();
  final unitPriceController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  final Rxn<File> selectedImage = Rxn<File>();

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

  final RxBool isLoading = false.obs;

  // Prevent double submission.
  bool _submitted = false;

  @override
  void onInit() {
    super.onInit();

    print('════════ ADD PRODUCT CONTROLLER INIT ════════');

    _loadAllowedCategories();
  }

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
        '🏷 Owner categories: ${availableCategories.toList()}',
      );
    } catch (e) {
      print('❌ Failed to load categories: $e');
    }
  }

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
      '🏷 Selected categories: ${selectedCategories.toList()}',
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
                  : '${word[0].toUpperCase()}${word.substring(1)}',
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

      print('🖼️ Image selected: ${image.path}');
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
  }

  void selectUnit(String? unit) {
    if (unit == null) return;

    selectedUnit.value = unit;

    print('📏 Unit: $unit');
  }

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
    final quantity = int.tryParse(value?.trim() ?? '');

    if (quantity == null) {
      return 'Enter a valid quantity';
    }

    if (quantity < 0) {
      return 'Quantity cannot be negative';
    }

    return null;
  }

  String? validateSectionId(String? value) {
    final sectionId = int.tryParse(value?.trim() ?? '');

    if (sectionId == null) {
      return 'Enter a valid section ID';
    }

    if (sectionId <= 0) {
      return 'Section ID must be greater than 0';
    }

    return null;
  }

  String? validateUnitPrice(String? value) {
    final price = double.tryParse(value?.trim() ?? '');

    if (price == null) {
      return 'Enter a valid unit price';
    }

    if (price < 0) {
      return 'Unit price cannot be negative';
    }

    return null;
  }

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

    FocusManager.instance.primaryFocus?.unfocus();

    final form = formKey.currentState;

    if (form == null) {
      print('❌ Form state is null');
      return;
    }

    if (!form.validate()) {
      print('❌ Form validation failed');
      return;
    }

    if (selectedUnit.value.trim().isEmpty) {
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

    final categoryIdsToSend = selectedCategoryIds;

    if (categoryIdsToSend.isEmpty) {
      Get.snackbar(
        'Invalid Categories',
        'Selected categories are invalid',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final quantity = int.tryParse(
      quantityController.text.trim(),
    );

    final sectionId = int.tryParse(
      sectionIdController.text.trim(),
    );

    final unitPrice = double.tryParse(
      unitPriceController.text.trim(),
    );

    if (quantity == null ||
        sectionId == null ||
        unitPrice == null) {
      return;
    }

    try {
      _submitted = true;
      isLoading.value = true;

      print('');
      print('════════ CREATE PRODUCT START ════════');
      print('📦 SKU: ${skuController.text.trim()}');
      print('📝 Name: ${nameController.text.trim()}');
      print('📏 Unit: ${selectedUnit.value}');
      print('💰 Unit Price: $unitPrice');
      print('🏷 Categories: $categoryIdsToSend');
      print('📄 Description: ${descriptionController.text.trim()}');
      print('🏢 Section ID: $sectionId');
      print('📦 Quantity: $quantity');
      print('════════════════════════════════════');

      final result = await _repo.createProduct(
        sku: skuController.text.trim(),
        nameEn: nameController.text.trim(),
        unit: selectedUnit.value.trim(),
        unitPrice: unitPrice,
        categories: categoryIdsToSend,
        descriptionEn: descriptionController.text.trim(),
        sectionId: sectionId,
        quantity: quantity,
        productImage: selectedImage.value,
      );

      print('');
      print('════════ PRODUCT CREATED ════════');
      print('🆔 Product ID: ${result.data.id}');
      print('📦 SKU: ${result.data.sku}');
      print('📝 Name: ${result.data.name}');
      print('════════════════════════════════');

      // IMPORTANT:
      // Do NOT show a snackbar before Get.back().
      // Return the result directly to the previous screen.

      print('⬅️ POPPING ADD PRODUCT SCREEN WITH TRUE');

      if (Get.isOverlaysOpen) {
        print('⚠️ Overlay is open, closing it first');
        Get.back();
      }

      Get.back<bool>(result: true);

      print('✅ ADD PRODUCT SCREEN POPPED');
    } on ApiError catch (e) {
      _submitted = false;

      print('❌ API ERROR: ${e.message}');

      Get.snackbar(
        'Error',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e, stackTrace) {
      _submitted = false;

      print('❌ CREATE PRODUCT ERROR: $e');
      print('❌ StackTrace: $stackTrace');

      Get.snackbar(
        'Error',
        'Failed to create product',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      print('🏁 createProduct() FINISHED');
    }
  }

  @override
  void onClose() {
    skuController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    sectionIdController.dispose();
    unitPriceController.dispose();

    super.onClose();
  }
}