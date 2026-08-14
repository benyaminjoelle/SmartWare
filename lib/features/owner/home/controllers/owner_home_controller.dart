import 'package:get/get.dart';

class OwnerHomeController extends GetxController {
  final isLoading = false.obs;

  final ownerName = 'Warehouse Owner'.obs;

  final warehouseCount = 0.obs;
  final productCount = 0.obs;
  final pendingOrders = 0.obs;
  final lowStockCount = 0.obs;

  final warehouses = <OwnerWarehouseHomeModel>[].obs;
  final lowStockProducts = <OwnerLowStockHomeModel>[].obs;
  final recentOrders = <OwnerRecentOrderModel>[].obs;

  String get greeting {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good morning';
    }

    if (hour < 18) {
      return 'Good afternoon';
    }

    return 'Good evening';
  }

  @override
  void onInit() {
    super.onInit();
    loadHome();
  }

  Future<void> loadHome() async {
    try {
      isLoading.value = true;

      // TODO:
      // Call backend here.
      //
      // Get:
      // - owner name
      // - warehouse count
      // - product count
      // - pending orders
      // - low stock count
      // - warehouses
      // - low stock products
      // - recent orders

    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshHome() async {
    await loadHome();
  }

  void addProduct() {
    // TODO: navigate to add product
  }

  void addWorker() {
    // TODO: navigate to add worker
  }

  void openProducts() {
    // TODO: navigate to products
  }

  void openOrders() {
    // TODO: navigate to orders
  }

  void openWarehouses() {
    // TODO: navigate to warehouses
  }

  void openProfile() {
    // TODO: navigate to profile
  }

  void openWarehouse(
    OwnerWarehouseHomeModel warehouse,
  ) {
    // TODO: open warehouse details
  }

  void openProduct(
    OwnerLowStockHomeModel product,
  ) {
    // TODO: open product details
  }
}

// =============================================================================
// HOME MODELS
// =============================================================================

class OwnerWarehouseHomeModel {
  final String name;
  final String location;
  final String? imageUrl;
  final double capacity;

  OwnerWarehouseHomeModel({
    required this.name,
    required this.location,
    this.imageUrl,
    required this.capacity,
  });
}

class OwnerLowStockHomeModel {
  final String name;
  final int currentStock;
  final int minimumStock;
  final String? imageUrl;

  OwnerLowStockHomeModel({
    required this.name,
    required this.currentStock,
    required this.minimumStock,
    this.imageUrl,
  });
}

class OwnerRecentOrderModel {
  final String orderNumber;
  final String clientName;
  final String status;

  OwnerRecentOrderModel({
    required this.orderNumber,
    required this.clientName,
    required this.status,
  });
}