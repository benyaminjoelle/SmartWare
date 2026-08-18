import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/core/utils/pref_helper.dart';
import 'package:smartware/features/product/models/product_model.dart';
import 'package:smartware/features/warehouse/controllers/warehouse_controller.dart';
import 'package:smartware/features/warehouse/models/warehouse_product_model.dart';

class ProductController extends GetxController {
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> displayedProducts = <Product>[].obs;
  final WarehouseController warehouseController = Get.find<WarehouseController>();

  final RxSet<String> selectedUnit = <String>{}.obs;
  final RxSet<String> selectedCategories = <String>{}.obs;
  final RxString searchQuery = ''.obs;
  final RxString businessType = ''.obs;

  final RxList<String> businessCategories = <String>[].obs;

  double minPossiblePrice = 0.0;
  double maxPossiblePrice = 100.0;

  late Rx<RangeValues> priceRange;

  @override
  void onInit() {
    super.onInit();

    loadClientPreferences();
    loadProducts();

    debounce(
      searchQuery,
      (_) => applyFilters(),
      time: const Duration(milliseconds: 300),
    );
  }

  Future <void> loadClientPreferences() async {
    final savedBusinessType =
        await PrefHelper.getBusinessType();

    final savedCategories =
        await PrefHelper.getBusinessCategories();

    businessType.value =
        savedBusinessType ?? '';

    businessCategories.assignAll(
      savedCategories,
    );

    print('🏪 Client business type: ${businessType.value}');
    print('📦 Client categories: $businessCategories');

    // If products have already been loaded,
    // apply the preferences immediately.
    if (products.isNotEmpty) {
      applyFilters();
    }
  }

  void loadProducts() {
  products.assignAll([
    // ============================================================
    // RESTAURANT / SUPERMARKET
    // ============================================================

    Product(
      id: 1,
      sku: 'RICE-001',
      name: 'Premium Basmati Rice',
      unit: 'bag',
      companyName: 'Food Supply Co.',
      categories: [
        'fresh_foods',
        'canned_foods',
      ],
    ),

    Product(
      id: 2,
      sku: 'MILK-001',
      name: 'Full Cream Milk',
      unit: 'bottle',
      companyName: 'Dairy Fresh',
      categories: [
        'dairy_products',
        'refrigerated_foods',
      ],
    ),

    Product(
      id: 3,
      sku: 'COLA-001',
      name: 'Cola Soft Drink',
      unit: 'can',
      companyName: 'Beverage Company',
      categories: [
        'beverages',
      ],
    ),

    Product(
      id: 4,
      sku: 'COFFEE-001',
      name: 'Arabica Coffee',
      unit: 'pack',
      companyName: 'Coffee House Supplies',
      categories: [
        'coffee_tea',
        'beverages',
      ],
    ),

    Product(
      id: 5,
      sku: 'CHICKEN-001',
      name: 'Frozen Chicken Breast',
      unit: 'carton',
      companyName: 'Fresh Foods Ltd',
      categories: [
        'meat_poultry',
        'frozen_foods',
      ],
    ),

    // ============================================================
    // PHARMACY
    // ============================================================

    Product(
      id: 6,
      sku: 'PARA-001',
      name: 'Paracetamol 500mg',
      unit: 'box',
      companyName: 'Med Supply',
      categories: [
        'over_the_counter_medicine',
      ],
    ),

    Product(
      id: 7,
      sku: 'VIT-C-001',
      name: 'Vitamin C Tablets',
      unit: 'box',
      companyName: 'Health Plus',
      categories: [
        'vitamins_supplements',
        'health_products',
      ],
    ),

    Product(
      id: 8,
      sku: 'FIRST-001',
      name: 'First Aid Kit',
      unit: 'piece',
      companyName: 'Medical Supplies Co.',
      categories: [
        'first_aid_supplies',
        'medical_equipment',
      ],
    ),

    // ============================================================
    // CLOTHING
    // ============================================================

    Product(
      id: 9,
      sku: 'SHIRT-001',
      name: 'Men Cotton Shirt',
      unit: 'piece',
      companyName: 'Fashion Wholesale',
      categories: [
        'mens_clothing',
        'seasonal_fashion',
      ],
    ),

    Product(
      id: 10,
      sku: 'SHOE-001',
      name: 'Running Shoes',
      unit: 'piece',
      companyName: 'Sports Fashion',
      categories: [
        'shoes',
        'sportswear',
      ],
    ),

    Product(
      id: 11,
      sku: 'BAG-001',
      name: 'Leather Handbag',
      unit: 'piece',
      companyName: 'Fashion Wholesale',
      categories: [
        'bags',
        'accessories',
      ],
    ),

    // ============================================================
    // ELECTRONICS
    // ============================================================

    Product(
      id: 12,
      sku: 'PHONE-001',
      name: 'Smartphone Pro',
      unit: 'piece',
      companyName: 'Tech Distribution',
      categories: [
        'smartphones',
      ],
    ),

    Product(
      id: 13,
      sku: 'LAPTOP-001',
      name: 'Business Laptop',
      unit: 'piece',
      companyName: 'Tech Distribution',
      categories: [
        'laptops',
        'desktop_computers',
      ],
    ),

    Product(
      id: 14,
      sku: 'HEADSET-001',
      name: 'Wireless Headphones',
      unit: 'piece',
      companyName: 'Audio Tech',
      categories: [
        'audio_devices',
      ],
    ),

    Product(
      id: 15,
      sku: 'BATTERY-001',
      name: 'AA Batteries',
      unit: 'pack',
      companyName: 'Power Electronics',
      categories: [
        'batteries',
        'electronic_parts',
      ],
    ),

    // ============================================================
    // MAKEUP
    // ============================================================

    Product(
      id: 16,
      sku: 'LIP-001',
      name: 'Matte Lipstick',
      unit: 'piece',
      companyName: 'Beauty Wholesale',
      categories: [
        'makeup',
        'cosmetics',
      ],
    ),

    Product(
      id: 17,
      sku: 'CREAM-001',
      name: 'Hydrating Face Cream',
      unit: 'jar',
      companyName: 'Beauty Wholesale',
      categories: [
        'skincare',
        'body_care',
      ],
    ),

    Product(
      id: 18,
      sku: 'PERF-001',
      name: 'Floral Perfume',
      unit: 'bottle',
      companyName: 'Beauty Distribution',
      categories: [
        'perfumes',
      ],
    ),

    // ============================================================
    // FURNITURE
    // ============================================================

    Product(
      id: 19,
      sku: 'TABLE-001',
      name: 'Office Desk',
      unit: 'piece',
      companyName: 'Furniture Wholesale',
      categories: [
        'office_furniture',
        'home_furniture',
      ],
    ),

    Product(
      id: 20,
      sku: 'SOFA-001',
      name: 'Modern Living Room Sofa',
      unit: 'piece',
      companyName: 'Furniture Wholesale',
      categories: [
        'living_room_furniture',
        'home_furniture',
      ],
    ),
  ].obs);
    calculatePriceBounds();
    applyFilters();
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

 List<String> get availableCategories {
  return products
      .expand((product) => product.categories)
      .toSet()
      .toList();
}
RxList<WarehouseProductModel> get specialSaleItems {
  return warehouseController.warehouseProducts
      .where(
        (item) =>
            item.discountPercentage != null &&
            item.discountPercentage! > 0 &&
            item.quantity > 0,
      )
      .toList().obs;
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
    final query =
        searchQuery.value.trim().toLowerCase();

    final filtered = products.where((product) {
      final matchesBusinessCategory =
          businessCategories.isEmpty ||
          product.categories.any(
            (category) =>
                businessCategories.contains(category),
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