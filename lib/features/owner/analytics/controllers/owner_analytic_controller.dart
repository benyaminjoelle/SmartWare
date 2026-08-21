import 'package:get/get.dart';

import 'package:smartware/features/owner/analytics/models/warehouse_model.dart';
import 'package:smartware/features/owner/analytics/models/warehouse_repo.dart';

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
  // REPOSITORY
  // ------------------------------------------------------------

  final OwnerAnalyticsRepo _repo = OwnerAnalyticsRepo();

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

  // ------------------------------------------------------------
  // INIT
  // ------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();

    loadWarehouses();
  }

  // ------------------------------------------------------------
  // LOAD OWNER WAREHOUSES
  // ------------------------------------------------------------

  Future<void> loadWarehouses() async {
    try {
      isLoadingWarehouses.value = true;

      final result = await _repo.getWarehouses();

      warehouses.assignAll(result);

      if (warehouses.isNotEmpty) {
        await selectWarehouse(warehouses.first);
      }
    } catch (e) {
      print('❌ Failed to load owner warehouses: $e');
    } finally {
      isLoadingWarehouses.value = false;
    }
  }

  // ------------------------------------------------------------
  // SELECT WAREHOUSE
  // ------------------------------------------------------------

  Future<void> selectWarehouse(
    WarehouseModel warehouse,
  ) async {
    selectedWarehouse.value = warehouse;

    await loadWarehouseAnalytics(warehouse.id);
  }

  // ------------------------------------------------------------
  // LOAD WAREHOUSE ANALYTICS
  // ------------------------------------------------------------

  Future<void> loadWarehouseAnalytics(
    int warehouseId,
  ) async {
    try {
      isLoadingAnalytics.value = true;

      final warehouse = warehouses.firstWhere(
        (warehouse) => warehouse.id == warehouseId,
      );

      // --------------------------------------------------------
      // REAL DATA FROM /home_page/ownedFacilities
      // --------------------------------------------------------

      totalProducts.value = warehouse.productCount;

      lowStockCount.value = warehouse.stockOutRiskCount;

      // --------------------------------------------------------
      // NOT PROVIDED BY CURRENT ENDPOINT
      // --------------------------------------------------------

      totalStock.value = 0;

      pendingOrders.value = 0;

      // --------------------------------------------------------
      // ANALYTICS ENDPOINTS NOT CONNECTED YET
      // --------------------------------------------------------

      inventoryTrend.clear();

      stockMovement.clear();

      categoryInventory.clear();

      topProducts.clear();

      lowStockProducts.clear();
    } catch (e) {
      print('❌ Failed to load warehouse analytics: $e');
    } finally {
      isLoadingAnalytics.value = false;
    }
  }

  // ------------------------------------------------------------
  // REFRESH
  // ------------------------------------------------------------

  Future<void> refreshAnalytics() async {
    await loadWarehouses();
  }
}