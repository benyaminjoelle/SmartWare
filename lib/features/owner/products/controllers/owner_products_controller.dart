import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/core/utils/pref_helper.dart';

import 'package:smartware/features/owner/products/models/owner_inventory_model.dart';
import 'package:smartware/features/owner/products/models/products_repo.dart';
import 'package:smartware/features/owner/products/views/owner_add_product_view.dart';
import 'package:smartware/features/owner/products/widgets/product_details_sheet.dart';

class OwnerProductsController extends GetxController {
  final ProductsRepo _repo = ProductsRepo();

  // ============================================================
  // STATE
  // ============================================================

  final RxList<OwnerInventoryModel> products =
      <OwnerInventoryModel>[].obs;

  final RxString searchQuery = ''.obs;

  final RxString selectedCategory = 'All'.obs;

  final RxBool isLoading = false.obs;

  final RxInt facilityId = 0.obs;

  // ============================================================
  // FILTERED PRODUCTS
  // ============================================================

  List<OwnerInventoryModel> get filteredProducts {
    final query = searchQuery.value.trim().toLowerCase();

    return products.where((inventory) {
      final product = inventory.product;

      final matchesSearch =
          query.isEmpty ||
          product.nameEn.toLowerCase().contains(query) ||
          product.nameAr.toLowerCase().contains(query) ||
          product.sku.toLowerCase().contains(query);

      // Category is not currently returned
      // by the backend inventory endpoint.
      final matchesCategory =
          selectedCategory.value == 'All';

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // ============================================================
  // CATEGORIES
  // ============================================================

  List<String> get categories {
    return ['All'];
  }

  // ============================================================
  // SUMMARY
  // ============================================================

  int get totalProducts {
    return products.length;
  }

  int get lowStockCount {
    // Backend does not currently return minimum_stock.
    return 0;
  }

  int get outOfStockCount {
    return products
        .where(
          (inventory) => inventory.quantity <= 0,
        )
        .length;
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void searchProducts(String value) {
    searchQuery.value = value;
  }

  // ============================================================
  // CATEGORY
  // ============================================================

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  // ============================================================
  // LOAD FACILITY ID
  // ============================================================

  Future<void> loadFacilityId() async {
    final savedFacilityId =
        await PrefHelper.getOwnerFacilityId();

    if (savedFacilityId == null) {
      print('❌ Owner facility ID not found');

      facilityId.value = 0;
      return;
    }

    facilityId.value = savedFacilityId;

    print(
      '🏢 Owner Facility ID: ${facilityId.value}',
    );
  }

  // ============================================================
  // FETCH PRODUCTS
  // ============================================================

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;

      print('');
      print(
        '════════ FETCH OWNER PRODUCTS ════════',
      );

      // ----------------------------------------------------------
      // LOAD FACILITY ID
      // ----------------------------------------------------------

      await loadFacilityId();

      if (facilityId.value <= 0) {
        print(
          '❌ Invalid owner facility ID',
        );

        Get.snackbar(
          'Error',
          'Owner facility was not found',
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      print(
        '🏢 Facility ID: ${facilityId.value}',
      );

      // ----------------------------------------------------------
      // API REQUEST
      // ----------------------------------------------------------

      final result =
          await _repo.getWarehouseInventory(
        facilityId: facilityId.value,
      );

      // ----------------------------------------------------------
      // UPDATE PRODUCTS
      // ----------------------------------------------------------

      products.assignAll(result);

      print(
        '✅ Products loaded: ${products.length}',
      );

      print(
        '════════════════════════════════════',
      );
    } catch (e, stackTrace) {
      print('');
      print(
        '════════ FETCH PRODUCTS ERROR ════════',
      );

      print(
        '❌ Error: $e',
      );

      print(
        '❌ Type: ${e.runtimeType}',
      );

      print(
        '❌ StackTrace: $stackTrace',
      );

      print(
        '════════════════════════════════════',
      );

      Get.snackbar(
        'Error',
        'Failed to load products',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // ADD PRODUCT
  // ============================================================

  void addProduct() {
  // Get.to(
  //   () => const AddProductView(),
  // )?.then((result) {
  //   if (result == true) {
  //     fetchProducts();
  //   }
  
}

  // ============================================================
  // OPEN PRODUCT DETAILS
  // ============================================================

  void openProduct(
    OwnerInventoryModel inventory,
  ) {
    Get.bottomSheet(
      ProductDetailsSheet(
        inventory: inventory,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
    );
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refreshProducts() async {
    await fetchProducts();
  }

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    fetchProducts();
  }
}