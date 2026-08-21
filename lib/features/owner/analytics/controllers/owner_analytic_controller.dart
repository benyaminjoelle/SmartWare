import 'package:get/get.dart';

import 'package:smartware/features/owner/analytics/models/slow_moving_products.dart';
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
  // ============================================================
  // REPOSITORY
  // ============================================================

  final OwnerAnalyticsRepo _repo = OwnerAnalyticsRepo();

  // ============================================================
  // WAREHOUSES
  // ============================================================

  final isLoadingWarehouses = false.obs;

  final warehouses = <WarehouseModel>[].obs;

  // ============================================================
  // SELECTED WAREHOUSE
  // ============================================================

  final selectedWarehouse = Rxn<WarehouseModel>();

  final isLoadingAnalytics = false.obs;

  // ============================================================
  // ANALYTICS DATA
  // ============================================================

  final inventoryTrend = <InventoryTrend>[].obs;

  final stockMovement = <StockMovement>[].obs;

  final categoryInventory = <CategoryInventory>[].obs;

  final topProducts = <TopProduct>[].obs;

  final lowStockProducts = <LowStockProduct>[].obs;

  final slowMovingProducts =
      <SlowMovingProductModel>[].obs;

  // ============================================================
  // SUMMARY
  // ============================================================

  final totalProducts = 0.obs;

  final totalStock = 0.obs;

  final lowStockCount = 0.obs;

  final pendingOrders = 0.obs;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    loadWarehouses();
  }

  // ============================================================
  // LOAD OWNER WAREHOUSES
  // ============================================================

  Future<void> loadWarehouses() async {
    try {
      isLoadingWarehouses.value = true;

      final result = await _repo.getWarehouses();

      warehouses.assignAll(result);

      if (warehouses.isNotEmpty) {
        await selectWarehouse(warehouses.first);
      } else {
        selectedWarehouse.value = null;
        _clearAnalytics();
      }
    } catch (e) {
      print('❌ Failed to load owner warehouses: $e');
    } finally {
      isLoadingWarehouses.value = false;
    }
  }

  // ============================================================
  // SELECT WAREHOUSE
  // ============================================================

  Future<void> selectWarehouse(
    WarehouseModel warehouse,
  ) async {
    print('');
    print('════════ SELECT WAREHOUSE ════════');
    print('🏢 Warehouse: ${warehouse.nameEn}');
    print('🆔 Facility ID: ${warehouse.id}');
    print('════════════════════════════════');

    selectedWarehouse.value = warehouse;

    await loadWarehouseAnalytics(
      warehouse.id,
    );
  }

  // ============================================================
  // LOAD WAREHOUSE ANALYTICS
  // ============================================================

  Future<void> loadWarehouseAnalytics(
    int warehouseId,
  ) async {
    try {
      isLoadingAnalytics.value = true;

      print('');
      print('════════ LOAD WAREHOUSE ANALYTICS ════════');
      print('🏢 Facility ID: $warehouseId');

      final warehouse = warehouses.firstWhere(
        (warehouse) => warehouse.id == warehouseId,
      );

      // --------------------------------------------------------
      // SUMMARY FROM OWNED FACILITIES
      // --------------------------------------------------------

      totalProducts.value = warehouse.productCount;

      lowStockCount.value =
          warehouse.stockOutRiskCount;

      // --------------------------------------------------------
      // NOT PROVIDED YET
      // --------------------------------------------------------

      totalStock.value = 0;

      pendingOrders.value = 0;

      // --------------------------------------------------------
      // SLOW MOVING PRODUCTS
      // --------------------------------------------------------

      final slowMoving =
          await _repo.getSlowMovingProducts(
        facilityId: warehouseId,
      );

      slowMovingProducts.assignAll(
        slowMoving,
      );

      print(
        '📦 Slow moving products loaded: '
        '${slowMovingProducts.length}',
      );

      // --------------------------------------------------------
      // OTHER ANALYTICS
      // --------------------------------------------------------

      inventoryTrend.clear();

      stockMovement.clear();

      categoryInventory.clear();

      topProducts.clear();

      lowStockProducts.clear();

      print('════════ ANALYTICS LOADED ════════');
    } catch (e) {
      print(
        '❌ Failed to load warehouse analytics: $e',
      );

      slowMovingProducts.clear();
    } finally {
      isLoadingAnalytics.value = false;
    }
  }

  // ============================================================
  // CLEAR ANALYTICS
  // ============================================================

  void _clearAnalytics() {
    inventoryTrend.clear();
    stockMovement.clear();
    categoryInventory.clear();
    topProducts.clear();
    lowStockProducts.clear();
    slowMovingProducts.clear();

    totalProducts.value = 0;
    totalStock.value = 0;
    lowStockCount.value = 0;
    pendingOrders.value = 0;
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refreshAnalytics() async {
    await loadWarehouses();
  }
}