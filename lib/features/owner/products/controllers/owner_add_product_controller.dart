// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// import 'package:smartware/core/network/api_error.dart';
// import 'package:smartware/core/utils/pref_helper.dart';
// import 'package:smartware/features/owner/products/models/products_repo.dart';

// class AddProductController extends GetxController {
//   final ProductsRepo _repo = ProductsRepo();

//   // ============================================================
//   // FORM
//   // ============================================================

//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   final TextEditingController skuController =
//       TextEditingController();

//   final TextEditingController nameController =
//       TextEditingController();

//   final TextEditingController descriptionController =
//       TextEditingController();

//   // ============================================================
//   // IMAGE
//   // ============================================================

//   final ImagePicker _imagePicker = ImagePicker();

//   final Rxn<File> selectedImage = Rxn<File>();

//   // ============================================================
//   // UNIT
//   // ============================================================

//   final RxString selectedUnit = ''.obs;

//   final List<String> units = [
//     'box',
//       'carton',
//     'bottle',
//      'can',
//    'jar',
//      'pack',
//     'piece',
//     'pallet',
//   ];

//   // ============================================================
//   // CATEGORIES
//   // ============================================================

//   /// These are the category names/keys saved in owner preferences.
//   final RxList<String> availableCategories =
//       <String>[].obs;

//   /// Selected category names/keys.
//   final RxList<String> selectedCategories =
//       <String>[].obs;

//   /// Database category IDs.
//   ///
//   /// These IDs come from the backend response you showed:
//   /// canned_foods = 1
//   /// fresh_foods = 2
//   /// refrigerated_foods = 3
//   /// frozen_foods = 4
//   /// baby_care = 27
//   final Map<String, int> categoryIds = {
//     'canned_foods': 1,
//     'fresh_foods': 2,
//     'refrigerated_foods': 3,
//     'frozen_foods': 4,
//     'baby_care': 27,
//   };

//   // ============================================================
//   // LOADING
//   // ============================================================

//   final RxBool isLoading = false.obs;

//   // ============================================================
//   // INIT
//   // ============================================================

//   @override
//   void onInit() {
//     super.onInit();

//     _loadAllowedCategories();
//   }

//   // ============================================================
//   // LOAD OWNER CATEGORIES
//   // ============================================================

//   Future<void> _loadAllowedCategories() async {
//     try {
//       final categories =
//           await PrefHelper.getOwnerSelectedProducts();

//       if (categories == null || categories.isEmpty) {
//         print('⚠️ No owner product categories found');
//         return;
//       }

//       availableCategories.assignAll(categories);

//       print('');
//       print('════════ OWNER PRODUCT CATEGORIES ════════');
//       print(
//         '🏷 Categories: ${availableCategories.toList()}',
//       );
//       print(
//         '════════════════════════════════════════',
//       );
//     } catch (e) {
//       print(
//         '❌ Failed to load owner categories: $e',
//       );
//     }
//   }

//   // ============================================================
//   // CATEGORY SELECTION
//   // ============================================================

//   bool isCategorySelected(String category) {
//     return selectedCategories.contains(category);
//   }

//   void toggleCategory(String category) {
//     if (selectedCategories.contains(category)) {
//       selectedCategories.remove(category);
//     } else {
//       selectedCategories.add(category);
//     }

//     print(
//       '🏷 Selected categories: '
//       '${selectedCategories.toList()}',
//     );
//   }

//   // ============================================================
//   // CATEGORY IDs
//   // ============================================================

//   List<int> get selectedCategoryIds {
//     return selectedCategories
//         .map((category) => categoryIds[category])
//         .whereType<int>()
//         .toList();
//   }

//   // ============================================================
//   // CATEGORY TITLE
//   // ============================================================

//   String categoryTitle(String category) {
//     switch (category) {
//       case 'canned_foods':
//         return 'Canned Foods';

//       case 'fresh_foods':
//         return 'Fresh Foods';

//       case 'refrigerated_foods':
//         return 'Refrigerated Foods';

//       case 'frozen_foods':
//         return 'Frozen Foods';

//       case 'baby_care':
//         return 'Baby Care';

//       case 'medical_equipment':
//         return 'Medical Equipment';

//       case 'vitamins_supplements':
//         return 'Vitamins & Supplements';

//       default:
//         return category
//             .replaceAll('_', ' ')
//             .split(' ')
//             .map(
//               (word) => word.isEmpty
//                   ? word
//                   : '${word[0].toUpperCase()}'
//                       '${word.substring(1)}',
//             )
//             .join(' ');
//     }
//   }

//   // ============================================================
//   // CATEGORY ICON
//   // ============================================================

//   IconData categoryIcon(String category) {
//     switch (category) {
//       case 'canned_foods':
//         return Icons.inventory_2_outlined;

//       case 'fresh_foods':
//         return Icons.eco_outlined;

//       case 'refrigerated_foods':
//         return Icons.kitchen_outlined;

//       case 'frozen_foods':
//         return Icons.ac_unit;

//       case 'baby_care':
//         return Icons.child_care_outlined;

//       case 'medical_equipment':
//         return Icons.medical_services_outlined;

//       case 'vitamins_supplements':
//         return Icons.medication_outlined;

//       default:
//         return Icons.category_outlined;
//     }
//   }

//   // ============================================================
//   // IMAGE PICKER
//   // ============================================================

//   Future<void> pickImage() async {
//     try {
//       final XFile? image =
//           await _imagePicker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 85,
//         maxWidth: 1600,
//         maxHeight: 1600,
//       );

//       if (image == null) {
//         return;
//       }

//       selectedImage.value = File(image.path);

//       print(
//         '🖼️ Product image selected: ${image.path}',
//       );
//     } catch (e) {
//       print(
//         '❌ Failed to select image: $e',
//       );

//       Get.snackbar(
//         'Error',
//         'Failed to select image',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }

//   void removeImage() {
//     selectedImage.value = null;
//   }

//   // ============================================================
//   // UNIT
//   // ============================================================

//   void selectUnit(String? unit) {
//     if (unit == null) {
//       return;
//     }

//     selectedUnit.value = unit;
//   }

//   // ============================================================
//   // VALIDATION
//   // ============================================================

//   String? validateSku(String? value) {
//     final sku = value?.trim() ?? '';

//     if (sku.isEmpty) {
//       return 'SKU is required';
//     }

//     final validSku =
//         RegExp(r'^[A-Za-z0-9_-]+$');

//     if (!validSku.hasMatch(sku)) {
//       return 'Use only letters, numbers, _ or -';
//     }

//     if (sku.length > 100) {
//       return 'SKU must not exceed 100 characters';
//     }

//     return null;
//   }

//   String? validateName(String? value) {
//     final name = value?.trim() ?? '';

//     if (name.isEmpty) {
//       return 'Product name is required';
//     }

//     if (name.length > 255) {
//       return 'Product name is too long';
//     }

//     return null;
//   }

//   String? validateDescription(String? value) {
//     final description = value?.trim() ?? '';

//     if (description.isEmpty) {
//       return 'Description is required';
//     }

//     return null;
//   }

//   // ============================================================
//   // CREATE PRODUCT
//   // ============================================================

//   Future<void> createProduct() async {
//     FocusManager.instance.primaryFocus?.unfocus();

//     if (!(formKey.currentState?.validate() ?? false)) {
//       return;
//     }

//     if (selectedUnit.value.trim().isEmpty) {
//       Get.snackbar(
//         'Missing Unit',
//         'Please select a unit',
//         snackPosition: SnackPosition.BOTTOM,
//       );

//       return;
//     }

//     if (selectedCategories.isEmpty) {
//       Get.snackbar(
//         'Missing Categories',
//         'Please select at least one category',
//         snackPosition: SnackPosition.BOTTOM,
//       );

//       return;
//     }

//     final categoryIdsToSend = selectedCategoryIds;

//     if (categoryIdsToSend.isEmpty) {
//       Get.snackbar(
//         'Invalid Categories',
//         'Selected categories are not valid',
//         snackPosition: SnackPosition.BOTTOM,
//       );

//       return;
//     }

//     try {
//       isLoading.value = true;

//       print('');
//       print('════════ CREATE PRODUCT CONTROLLER ════════');

//       print(
//         '📦 SKU: "${skuController.text.trim()}"',
//       );

//       print(
//         '📝 Name: "${nameController.text.trim()}"',
//       );

//       print(
//         '📏 Unit: "${selectedUnit.value}"',
//       );

//       print(
//         '🏷 Category Keys: '
//         '${selectedCategories.toList()}',
//       );

//       print(
//         '🆔 Category IDs: '
//         '$categoryIdsToSend',
//       );

//       print(
//         '📄 Description: '
//         '"${descriptionController.text.trim()}"',
//       );

//       print(
//         '🖼 Image: ${selectedImage.value?.path}',
//       );

//       final result = await _repo.createProduct(
//         sku: skuController.text.trim(),
//         nameEn: nameController.text.trim(),
//         unit: selectedUnit.value,
//         categories: categoryIdsToSend,
//         descriptionEn:
//             descriptionController.text.trim(),
//         productImage: selectedImage.value,
//       );

//       print('');
//       print('✅ PRODUCT CREATED SUCCESSFULLY');
//       print('🆔 Product ID: ${result.data.id}');
//       print('📦 SKU: ${result.data.sku}');
//       print('📝 Name: ${result.data.name}');
//       print('════════════════════════════════════');

//       Get.snackbar(
//         'Success',
//         result.message.isNotEmpty
//             ? result.message
//             : 'Product created successfully',
//         snackPosition: SnackPosition.BOTTOM,
//       );

//       Get.back(result: true);
//     } on ApiError catch (e) {
//       print('');
//       print('❌ CREATE PRODUCT API ERROR');
//       print('❌ ${e.message}');

//       Get.snackbar(
//         'Error',
//         e.message,
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } catch (e) {
//       print('');
//       print('❌ CREATE PRODUCT ERROR');
//       print('❌ $e');

//       Get.snackbar(
//         'Error',
//         'Failed to create product',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // ============================================================
//   // DISPOSE
//   // ============================================================

//   @override
//   void onClose() {
//     skuController.dispose();
//     nameController.dispose();
//     descriptionController.dispose();

//     super.onClose();
//   }
// }