import 'package:get/get.dart';

class WarehouseModel {
  final int id;
  final String name;
  final String location;
  final int totalProducts;
  final int totalStock;
  final int lowStockProducts;
  final int pendingOrders;
  final double capacityPercentage;
  final String? imageUrl;

  WarehouseModel({
    required this.id,
    required this.name,
    required this.location,
    required this.totalProducts,
    required this.totalStock,
    required this.lowStockProducts,
    required this.pendingOrders,
    required this.capacityPercentage,
    this.imageUrl
  });
}

class InventoryTrend {
  final String day;
  final int quantity;

  InventoryTrend({
    required this.day,
    required this.quantity,
  });
}

class StockMovement {
  final String day;
  final int incoming;
  final int outgoing;

  StockMovement({
    required this.day,
    required this.incoming,
    required this.outgoing,
  });
}

class CategoryInventory {
  final String category;
  final int quantity;

  CategoryInventory({
    required this.category,
    required this.quantity,
  });
}

class TopProduct {
  final String name;
  final int quantity;

  TopProduct({
    required this.name,
    required this.quantity,
  });
}

class LowStockProduct {
  final String name;
  final int currentStock;
  final int minimumStock;

  LowStockProduct({
    required this.name,
    required this.currentStock,
    required this.minimumStock,
  });
}

class OwnerAnalyticsController extends GetxController {
  // ------------------------------------------------------------
  // WAREHOUSES
  // ------------------------------------------------------------

  final isLoadingWarehouses = false.obs;

  final warehouses = <WarehouseModel>[].obs;

  // ------------------------------------------------------------
  // SELECTED WAREHOUSE
  // ------------------------------------------------------------

  final selectedWarehouse = Rxn<WarehouseModel>();

  final isLoadingAnalytics = false.obs;

  // ------------------------------------------------------------
  // ANALYTICS DATA
  // ------------------------------------------------------------

  final inventoryTrend = <InventoryTrend>[].obs;

  final stockMovement = <StockMovement>[].obs;

  final categoryInventory = <CategoryInventory>[].obs;

  final topProducts = <TopProduct>[].obs;

  final lowStockProducts = <LowStockProduct>[].obs;

  // ------------------------------------------------------------
  // SUMMARY
  // ------------------------------------------------------------

  final totalProducts = 0.obs;
  final totalStock = 0.obs;
  final lowStockCount = 0.obs;
  final pendingOrders = 0.obs;

  @override
  void onInit() {
    super.onInit();

    loadWarehouses();
  }

  // ------------------------------------------------------------
  // LOAD WAREHOUSES
  // ------------------------------------------------------------

  Future<void> loadWarehouses() async {
    try {
      isLoadingWarehouses.value = true;

      // TODO:
      // Replace this section with your Laravel API call.

      await Future.delayed(const Duration(milliseconds: 700));

      warehouses.assignAll([
        WarehouseModel(
          id: 1,
          name: 'Main Warehouse',
          location: 'Damascus',
          totalProducts: 1248,
          totalStock: 18420,
          lowStockProducts: 17,
          pendingOrders: 24,
          capacityPercentage: 0.72,
        ),
        WarehouseModel(
          id: 2,
          name: 'North Warehouse',
          location: 'Aleppo',
          totalProducts: 856,
          totalStock: 12680,
          lowStockProducts: 9,
          pendingOrders: 13,
          capacityPercentage: 0.54,
        ),
        WarehouseModel(
          id: 3,
          name: 'Distribution Center',
          location: 'Homs',
          totalProducts: 642,
          totalStock: 9340,
          lowStockProducts: 5,
          pendingOrders: 8,
          capacityPercentage: 0.38,
        ),
      ]);
    } finally {
      isLoadingWarehouses.value = false;
    }
  }

  // ------------------------------------------------------------
  // OPEN WAREHOUSE ANALYTICS
  // ------------------------------------------------------------

  Future<void> selectWarehouse(WarehouseModel warehouse) async {
    selectedWarehouse.value = warehouse;

    await loadWarehouseAnalytics(warehouse.id);
  }

  // ------------------------------------------------------------
  // LOAD ANALYTICS
  // ------------------------------------------------------------

  Future<void> loadWarehouseAnalytics(int warehouseId) async {
    try {
      isLoadingAnalytics.value = true;

      // TODO:
      // Replace this with:
      //
      // final response = await apiService.get(
      //   '/owner/warehouses/$warehouseId/analytics',
      // );
      //
      // Then map the response into the models below.

      await Future.delayed(const Duration(milliseconds: 600));

      _loadMockAnalytics();
    } finally {
      isLoadingAnalytics.value = false;
    }
  }

  // ------------------------------------------------------------
  // MOCK ANALYTICS
  // ------------------------------------------------------------

  void _loadMockAnalytics() {
    totalProducts.value = selectedWarehouse.value?.totalProducts ?? 0;

    totalStock.value = selectedWarehouse.value?.totalStock ?? 0;

    lowStockCount.value =
        selectedWarehouse.value?.lowStockProducts ?? 0;

    pendingOrders.value =
        selectedWarehouse.value?.pendingOrders ?? 0;

    inventoryTrend.assignAll([
      InventoryTrend(day: 'Mon', quantity: 15200),
      InventoryTrend(day: 'Tue', quantity: 15800),
      InventoryTrend(day: 'Wed', quantity: 14900),
      InventoryTrend(day: 'Thu', quantity: 17100),
      InventoryTrend(day: 'Fri', quantity: 16800),
      InventoryTrend(day: 'Sat', quantity: 18100),
      InventoryTrend(day: 'Sun', quantity: 18420),
    ]);

    stockMovement.assignAll([
      StockMovement(
        day: 'Mon',
        incoming: 1200,
        outgoing: 850,
      ),
      StockMovement(
        day: 'Tue',
        incoming: 1500,
        outgoing: 900,
      ),
      StockMovement(
        day: 'Wed',
        incoming: 900,
        outgoing: 1200,
      ),
      StockMovement(
        day: 'Thu',
        incoming: 1800,
        outgoing: 1100,
      ),
      StockMovement(
        day: 'Fri',
        incoming: 1300,
        outgoing: 1500,
      ),
      StockMovement(
        day: 'Sat',
        incoming: 1700,
        outgoing: 900,
      ),
      StockMovement(
        day: 'Sun',
        incoming: 1200,
        outgoing: 880,
      ),
    ]);

    categoryInventory.assignAll([
      CategoryInventory(
        category: 'Food',
        quantity: 6200,
      ),
      CategoryInventory(
        category: 'Beverages',
        quantity: 4800,
      ),
      CategoryInventory(
        category: 'Cosmetics',
        quantity: 3200,
      ),
      CategoryInventory(
        category: 'Medical',
        quantity: 2400,
      ),
      CategoryInventory(
        category: 'Other',
        quantity: 1820,
      ),
    ]);

    topProducts.assignAll([
      TopProduct(
        name: 'Coca Cola',
        quantity: 840,
      ),
      TopProduct(
        name: 'Pepsi',
        quantity: 720,
      ),
      TopProduct(
        name: 'Mineral Water',
        quantity: 610,
      ),
      TopProduct(
        name: 'Orange Juice',
        quantity: 490,
      ),
      TopProduct(
        name: 'Potato Chips',
        quantity: 380,
      ),
    ]);

    lowStockProducts.assignAll([
      LowStockProduct(
        name: 'Coca Cola',
        currentStock: 8,
        minimumStock: 20,
      ),
      LowStockProduct(
        name: 'Pepsi',
        currentStock: 12,
        minimumStock: 25,
      ),
      LowStockProduct(
        name: 'Orange Juice',
        currentStock: 5,
        minimumStock: 15,
      ),
      LowStockProduct(
        name: 'Mineral Water',
        currentStock: 9,
        minimumStock: 30,
      ),
    ]);
  }

  // ------------------------------------------------------------
  // REFRESH
  // ------------------------------------------------------------

  Future<void> refreshAnalytics() async {
    final warehouse = selectedWarehouse.value;

    if (warehouse == null) return;

    await loadWarehouseAnalytics(warehouse.id);
  }
}