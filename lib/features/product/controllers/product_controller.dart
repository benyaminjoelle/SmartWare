import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/core/utils/pref_helper.dart';
import 'package:smartware/features/product/models/product_model.dart';
import 'package:smartware/features/product/models/product_repo.dart';
import 'package:smartware/features/warehouse/controllers/warehouse_controller.dart';
import 'package:smartware/features/warehouse/models/warehouse_product_model.dart';

class ProductController extends GetxController {
  //========== Repo ============
  final ProductRepo productRepo = ProductRepo();

  final WarehouseController warehouseController = Get.find<WarehouseController>();
  
  final RxList<Product> products = <Product>[].obs;
  
  // ============ filtering ==============
  final RxList<Product> displayedProducts = <Product>[].obs;
  final RxSet<String> selectedUnit = <String>{}.obs;
  final RxSet<String> selectedCategories = <String>{}.obs;
  final RxString searchQuery = ''.obs;
  final RxString businessType = ''.obs;
  final RxBool isProfileCompleted = false.obs;
  final RxList<String> businessCategories = <String>[].obs;

  double minPossiblePrice = 0.0;
  double maxPossiblePrice = 100.0;

  late Rx<RangeValues> priceRange;

  @override
  void onInit() {
    super.onInit();

    loadProfileStatus();
    loadProducts();

    debounce(
      searchQuery,
      (_) => applyFilters(),
      time: const Duration(milliseconds: 300),
    );
  }
  Future<void> loadProfileStatus() async {
  isProfileCompleted.value =
      await PrefHelper.getProfileCompleted();
}


  Future<void> loadProducts() async {
  try {
    final result = await productRepo.getProducts();

    products.assignAll(result);

    calculatePriceBounds();
    applyFilters();

    print('📦 Real products loaded: ${products.length}');
  } catch (e) {
    print('❌ Failed to load products: $e');
  }

    calculatePriceBounds();
    applyFilters();
  }

  void calculatePriceBounds() {
    final warehouseProducts = warehouseController.warehouseProducts;

    if (warehouseProducts.isEmpty) {
      minPossiblePrice = 0.0;
      maxPossiblePrice = 100.0;
    } else {
      minPossiblePrice = warehouseProducts
          .map((item) => item.unitPrice)
          .reduce((a, b) => a < b ? a : b);

      maxPossiblePrice = warehouseProducts
          .map((item) => item.unitPrice)
          .reduce((a, b) => a > b ? a : b);
    }

    priceRange = RangeValues(
      minPossiblePrice,
      maxPossiblePrice,
    ).obs;
  }
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<String> get availableUnits {
    return products
        .map((product) => product.unit)
        .toSet()
        .toList();
  }

 List<String> get availableCategories {
  return products
      .expand((product) => product.categories)
      .toSet()
      .toList();
}
RxList<WarehouseProductModel> get specialSaleItems {
  return warehouseController.warehouseProducts
      .where(
        (item) {
           final product = getProductById(item.productId);

        if (product == null) return false;

        final matchesPreference =
            businessCategories.isEmpty ||
            product.categories.any(
              (category) => businessCategories.contains(category),
            );

        return item.discountPercentage != null &&
            item.discountPercentage! > 0 &&
            item.quantity > 0 &&
            matchesPreference;
        }
            
      )
      .toList().obs;
}
List<String> get filterCategories {
  if (businessCategories.isEmpty) {
    return availableCategories;
  }
  return businessCategories;
}

Product? getProductById(int productId) {
  try {
    return products.firstWhere(
      (product) => product.id == productId,
    );
  } catch (_) {
    return null;
  }
}
 // ========== filtering logic =============
  void applyFilters() {
  //    if (!isProfileCompleted.value) {
  //   displayedProducts.assignAll(products);
  //   return;
  // }
    final query =
        searchQuery.value.trim().toLowerCase();

    final filtered = products.where((product) {

      final matchesBusinessCategory =
          businessCategories.isEmpty ||
          product.categories.any(
            (category) => businessCategories.contains(category),
          );

      final matchesSearch =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.sku.toLowerCase().contains(query);

      final matchesUnit =
          selectedUnit.isEmpty ||
          selectedUnit.contains(product.unit);

      final matchesSelectedCategory =
          selectedCategories.isEmpty ||
          product.categories.any(
            (category) =>
                selectedCategories.contains(category),
          );

      final matchesPrice =
          warehouseController.warehouseProducts.any(
        (warehouseProduct) =>
            warehouseProduct.productId == product.id &&
            warehouseProduct.unitPrice >=
                priceRange.value.start &&
            warehouseProduct.unitPrice <=
                priceRange.value.end,
      );

      return matchesBusinessCategory &&
          matchesSearch &&
          matchesUnit &&
          matchesSelectedCategory &&
          matchesPrice;
    }).toList();

    displayedProducts.assignAll(filtered);

    print(
      '📦 Displayed products: ${displayedProducts.length}',
    );
  }

  void toggleUnit(String unit) {
    if (selectedUnit.contains(unit)) {
      selectedUnit.remove(unit);
    } else {
      selectedUnit.add(unit);
    }

    applyFilters();
  }

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }

    applyFilters();
  }

  void updatePriceRange(RangeValues values) {
    priceRange.value = values;
    applyFilters();
  }

  void resetFilters() {
    selectedUnit.clear();
    selectedCategories.clear();
    priceRange.value = RangeValues(
      minPossiblePrice,
      maxPossiblePrice,
    );
    searchQuery.value = '';
    applyFilters();
  }
}