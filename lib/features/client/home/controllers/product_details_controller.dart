import 'package:get/get.dart';

class ProductDetailsController extends GetxController {
  // ===========================================================================
  // PRODUCT
  // ===========================================================================

  final product = ClientProductModel(
    id: 'PROD-001',
    name: 'Premium Basmati Rice',
    description:
        'Premium long-grain basmati rice carefully selected for restaurants, '
        'supermarkets, and businesses. Known for its delicate aroma, fluffy '
        'texture, and consistent quality.',
    imageUrl:
        'https://images.unsplash.com/photo-1586201375761-83865001e31c',
    category: 'Food & Beverages',
    unit: 'bag',
    basePrice: 12.50,
  ).obs;

  // ===========================================================================
  // QUANTITY
  // ===========================================================================

  final quantity = 1.obs;

  // ===========================================================================
  // WAREHOUSES
  // ===========================================================================

  final warehouses = <ProductWarehouseModel>[].obs;

  final availableWarehouses = <ProductWarehouseModel>[].obs;

  final selectedWarehouse = Rxn<ProductWarehouseModel>();

  // ===========================================================================
  // PRICE
  // ===========================================================================

  double get selectedPrice {
    return selectedWarehouse.value?.price ?? product.value.basePrice;
  }

  double get totalPrice {
    return selectedPrice * quantity.value;
  }

  // ===========================================================================
  // STATE
  // ===========================================================================

  final isCheckingAvailability = false.obs;

  final hasCheckedAvailability = false.obs;

  final isAddingToCart = false.obs;

  // ===========================================================================
  // LIFECYCLE
  // ===========================================================================

  @override
  void onInit() {
    super.onInit();

    _loadTestWarehouses();
  }

  // ===========================================================================
  // TEST DATA
  // ===========================================================================

  void _loadTestWarehouses() {
    warehouses.assignAll([
      ProductWarehouseModel(
        id: 'WH-001',
        name: 'Damascus Central Warehouse',
        location: 'Mazzeh, Damascus',
        imageUrl: null,
        availableQuantity: 120,
        price: 12.50,
      ),

      ProductWarehouseModel(
        id: 'WH-002',
        name: 'North Damascus Warehouse',
        location: 'Qaboun, Damascus',
        imageUrl: null,
        availableQuantity: 65,
        price: 11.90,
      ),

      ProductWarehouseModel(
        id: 'WH-003',
        name: 'Aleppo Distribution Center',
        location: 'Aleppo',
        imageUrl: null,
        availableQuantity: 40,
        price: 11.50,
      ),

      ProductWarehouseModel(
        id: 'WH-004',
        name: 'Homs Central Warehouse',
        location: 'Homs',
        imageUrl: null,
        availableQuantity: 18,
        price: 13.20,
      ),

      ProductWarehouseModel(
        id: 'WH-005',
        name: 'Coastal Warehouse',
        location: 'Latakia',
        imageUrl: null,
        availableQuantity: 7,
        price: 14.00,
      ),
    ]);
  }

  // ===========================================================================
  // QUANTITY
  // ===========================================================================

  void increaseQuantity() {
    quantity.value++;
    _resetWarehouseSelection();
  }

  void decreaseQuantity() {
    if (quantity.value <= 1) {
      return;
    }

    quantity.value--;
    _resetWarehouseSelection();
  }

  void setQuantity(int value) {
    if (value < 1) {
      return;
    }

    quantity.value = value;
    _resetWarehouseSelection();
  }

  // ===========================================================================
  // WAREHOUSE AVAILABILITY
  // ===========================================================================

  Future<void> checkWarehouseAvailability() async {
    try {
      isCheckingAvailability.value = true;

      await Future.delayed(
        const Duration(milliseconds: 450),
      );

      availableWarehouses.assignAll(
        warehouses.where(
          (warehouse) =>
              warehouse.availableQuantity >= quantity.value,
        ),
      );

      hasCheckedAvailability.value = true;

      // If the previously selected warehouse cannot fulfill
      // the new quantity, remove the selection.
      if (selectedWarehouse.value != null &&
          selectedWarehouse.value!.availableQuantity <
              quantity.value) {
        selectedWarehouse.value = null;
      }
    } finally {
      isCheckingAvailability.value = false;
    }
  }

  // ===========================================================================
  // SELECT WAREHOUSE
  // ===========================================================================

  void selectWarehouse(ProductWarehouseModel warehouse) {
    if (warehouse.availableQuantity < quantity.value) {
      return;
    }

    selectedWarehouse.value = warehouse;
  }

  // ===========================================================================
  // CART
  // ===========================================================================

  Future<void> addToCart() async {
    if (selectedWarehouse.value == null) {
      return;
    }

    try {
      isAddingToCart.value = true;

      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      // TODO:
      // Send product + quantity + warehouse + price to cart backend.

      Get.snackbar(
        'Added to cart',
        '${product.value.name} added successfully.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isAddingToCart.value = false;
    }
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  void _resetWarehouseSelection() {
    hasCheckedAvailability.value = false;
    selectedWarehouse.value = null;
    availableWarehouses.clear();
  }
}

// =============================================================================
// PRODUCT MODEL
// =============================================================================

class ClientProductModel {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final String category;
  final String unit;
  final double basePrice;

  ClientProductModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.category,
    required this.unit,
    required this.basePrice,
  });
}

// =============================================================================
// PRODUCT WAREHOUSE MODEL
// =============================================================================

class ProductWarehouseModel {
  final String id;
  final String name;
  final String location;
  final String? imageUrl;
  final int availableQuantity;
  final double price;

  ProductWarehouseModel({
    required this.id,
    required this.name,
    required this.location,
    this.imageUrl,
    required this.availableQuantity,
    required this.price,
  });
}