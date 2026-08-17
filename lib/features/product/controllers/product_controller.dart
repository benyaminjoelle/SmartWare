import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/product/models/product_model.dart';
import 'package:smartware/features/warehouse/controllers/warehouse_controller.dart';
import 'package:smartware/core/constants/business_product_mapping.dart';
class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });
}

class ProductController extends GetxController {
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> displayedProducts = <Product>[].obs;

  final WarehouseController warehouseController =
      Get.find<WarehouseController>();

  final RxSet<String> selectedUnit = <String>{}.obs;
  final RxSet<String> selectedSubCategoryId = <String>{}.obs;
  final RxString searchQuery = ''.obs;

  double minPossiblePrice = 0.0;
  double maxPossiblePrice = 100.0;
  late Rx<RangeValues> priceRange;

 
  @override
  void onInit() {
    super.onInit();

    loadProducts();

    debounce(
      searchQuery,
      (_) => applyFilters(),
      time: const Duration(milliseconds: 300),
    );
  }

  void loadProducts() {
    // Later this will come from ProductRepo/API.

    products.assignAll([
      // mock products
    ]);

    calculatePriceBounds();
    displayedProducts.assignAll(products);
  }

  void calculatePriceBounds() {
    final warehouseProducts =
        warehouseController.warehouseProducts;

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

  void applyFilters() {
    final query = searchQuery.value.trim().toLowerCase();

    final filtered = products.where((product) {
      final matchesSearch =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.sku.toLowerCase().contains(query);

      final matchesUnit =
          selectedUnit.isEmpty ||
          selectedUnit.contains(
            product.unit,
          );
      final matchesCategory =
    selectedSubCategoryId.isEmpty ||
    product.categories.any(
      (category) => selectedSubCategoryId.contains(category),
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

      return matchesSearch &&
          matchesUnit &&
          matchesCategory &&
          matchesPrice;
    }).toList();

    displayedProducts.assignAll(filtered);
  }

  void toggleUnit(String type) {
    if (selectedUnit.contains(type)) {
      selectedUnit.remove(type);
    } else {
      selectedUnit.add(type);
    }

    applyFilters();
  }

  void toggleCategory(String category) {
  if (selectedSubCategoryId.contains(category)) {
    selectedSubCategoryId.remove(category);
  } else {
    selectedSubCategoryId.add(category);
  }

  applyFilters();
}
 void resetFilters() {
    selectedUnit.clear();
    selectedSubCategoryId.clear();

    priceRange.value = RangeValues(
      minPossiblePrice,
      maxPossiblePrice,
    );

    searchQuery.value = '';

    applyFilters();
  }
}