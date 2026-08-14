import 'package:get/get.dart';

class OwnerProduct {
  final int id;
  final String name;
  final String sku;
  final String category;
  final String? imageUrl;
  final int currentStock;
  final int minimumStock;
  final String unit;

  OwnerProduct({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    this.imageUrl,
    required this.currentStock,
    required this.minimumStock,
    required this.unit,
  });

  bool get isOutOfStock => currentStock <= 0;

  bool get isLowStock =>
      currentStock > 0 && currentStock <= minimumStock;

  bool get isHealthy =>
      currentStock > minimumStock;
}

class OwnerProductsController extends GetxController {
  final RxList<OwnerProduct> products = <OwnerProduct>[].obs;

  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;

  final RxBool isLoading = false.obs;

  List<OwnerProduct> get filteredProducts {
    final query = searchQuery.value.trim().toLowerCase();

    return products.where((product) {
      final matchesSearch =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.sku.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);

      final matchesCategory =
          selectedCategory.value == 'All' ||
          product.category == selectedCategory.value;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<String> get categories {
    final values = products
        .map((product) => product.category)
        .where((category) => category.trim().isNotEmpty)
        .toSet()
        .toList();

    values.sort();

    return ['All', ...values];
  }

  int get totalProducts => products.length;

  int get lowStockCount =>
      products.where((product) => product.isLowStock).length;

  int get outOfStockCount =>
      products.where((product) => product.isOutOfStock).length;

  void searchProducts(String value) {
    searchQuery.value = value;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;

      // TODO:
      // Call your repository/API here.
      //
      // Example:
      // final result = await repository.getWarehouseProducts();

      await Future.delayed(const Duration(milliseconds: 500));

      // Temporary mock data.
      products.assignAll([
        OwnerProduct(
          id: 1,
          name: 'Coca Cola 330ml',
          sku: 'BEV-001',
          category: 'Beverages',
          currentStock: 120,
          minimumStock: 30,
          unit: 'pcs',
        ),
        OwnerProduct(
          id: 2,
          name: 'Pepsi 330ml',
          sku: 'BEV-002',
          category: 'Beverages',
          currentStock: 18,
          minimumStock: 25,
          unit: 'pcs',
        ),
        OwnerProduct(
          id: 3,
          name: 'Basmati Rice 5kg',
          sku: 'FOOD-001',
          category: 'Food',
          currentStock: 75,
          minimumStock: 20,
          unit: 'bags',
        ),
        OwnerProduct(
          id: 4,
          name: 'Mineral Water 1.5L',
          sku: 'BEV-003',
          category: 'Beverages',
          currentStock: 0,
          minimumStock: 30,
          unit: 'bottles',
        ),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  void addProduct() {
    // TODO:
    // Navigate to AddProductView
  }

  void openProduct(OwnerProduct product) {
    // TODO:
    // Navigate to ProductDetailsView / EditProductView
  }

  Future<void> refreshProducts() async {
    await fetchProducts();
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }
}