import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/core/utils/pref_helper.dart';
import 'package:smartware/features/product/models/product_model.dart';
import 'package:smartware/features/product/models/product_repo.dart';

class ProductController extends GetxController {
  final ProductRepo productRepo = ProductRepo();

  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> displayedProducts = <Product>[].obs;
  final RxBool isLoading = false.obs;

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

      print('📦 Real products loaded: ${products.length}');

      calculatePriceBounds();
      applyFilters();
    } catch (e) {
      print('❌ Failed to load products: $e');

      products.clear();
      displayedProducts.clear();
    }
  }

  void calculatePriceBounds() {
    final prices = products
        .expand((product) => product.inventories)
        .map((inventory) => inventory.unitPrice)
        .toList();

    if (prices.isEmpty) {
      minPossiblePrice = 0.0;
      maxPossiblePrice = 100.0;
    } else {
      minPossiblePrice = prices.reduce(
        (a, b) => a < b ? a : b,
      );

      maxPossiblePrice = prices.reduce(
        (a, b) => a > b ? a : b,
      );
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

  List<String> get filterCategories {
    if (businessCategories.isEmpty) {
      return availableCategories;
    }

    return businessCategories;
  }

  RxList<Product> get specialSaleItems {
    return products.where((product) {
      final matchesBusinessCategory =
          businessCategories.isEmpty ||
          product.categories.any(
            (category) =>
                businessCategories.contains(category),
          );

      final hasSpecialSale = product.inventories.any(
        (inventory) =>
            inventory.quantity > 0 &&
            inventory.hasDiscount,
      );

      return matchesBusinessCategory && hasSpecialSale;
    }).toList().obs;
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
  Future<void> refreshProducts() async {
  try {
    isLoading.value = true;

    await loadProducts();

    // Re-apply the currently selected filters/search
    applyFilters();
  } finally {
    isLoading.value = false;
  }
}

  void applyFilters() {
    final query = searchQuery.value.trim().toLowerCase();
    //  print('════════ FILTER DEBUG ════════');
    // print('🏪 Business preferences: $businessCategories');
    // print('📦 Total products: ${products.length}');

  // for (final product in products) {
  //   final matchesBusinessCategory =
  //       businessCategories.isEmpty ||
  //       product.categories.any(
  //         (category) => businessCategories.contains(category),
  //       );

  //   print(
  //     '📦 ${product.id} | '
  //     '${product.nameEn} | '
  //     'categories: ${product.categories} | '
  //     'MATCH: $matchesBusinessCategory',
  //   );
  // }

  // print('══════════════════════════════');

    final filtered = products.where((product) {
      final matchesBusinessCategory =
          businessCategories.isEmpty ||
          product.categories.any(
            (category) =>
                businessCategories.contains(category),
          );

      final matchesSearch =
          query.isEmpty ||
          product.nameEn.toLowerCase().contains(query) ||
          product.nameAr.toLowerCase().contains(query) ||
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

      final matchesPrice =  product.inventories.any(
        (inventory) =>
            inventory.unitPrice >=
                priceRange.value.start &&
            inventory.unitPrice <=
                priceRange.value.end,
      );

      final hasStock = product.inventories.any(
        (inventory) => inventory.quantity > 0,
      );

      return matchesBusinessCategory &&
          matchesSearch &&
          matchesUnit &&
          matchesSelectedCategory &&
          matchesPrice &&
          hasStock;
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