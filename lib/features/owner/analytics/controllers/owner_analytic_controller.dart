import 'package:get/get.dart';
import 'package:smartware/features/owner/analytics/models/slow_moving_products.dart';
import 'package:smartware/features/owner/analytics/models/top_moving_products.dart';
import 'package:smartware/features/owner/analytics/models/warehouse_model.dart';
import 'package:smartware/features/owner/analytics/models/warehouse_repo.dart';

class OwnerAnalyticsController extends GetxController {
  // ============================================================
  // REPOSITORY
  // ============================================================

  final OwnerAnalyticsRepo _repo =
      OwnerAnalyticsRepo();

  // ============================================================
  // WAREHOUSES
  // ============================================================

  final isLoadingWarehouses = false.obs;

  final warehouses =
      <WarehouseModel>[].obs;

  final selectedWarehouse =
      Rxn<WarehouseModel>();

  final isLoadingAnalytics = false.obs;

  // ============================================================
  // ANALYTICS DATA
  // ============================================================

  /// Products that have little or no movement.
  final slowMovingProducts =
      <SlowMovingProductModel>[].obs;

  /// Products whose warehouse quantity is <= 10.
  final stockOutRiskProducts =
      <StockOutRiskProduct>[].obs;

  /// Products with the highest number of sold units.
  final topMovingProducts =
      <TopMovingProductModel>[].obs;

  

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

      print('');
      print(
        '════════ GET OWNER ANALYTICS WAREHOUSES ════════',
      );

      final result =
          await _repo.getWarehouses();

      warehouses.assignAll(result);

      print(
        '🏢 Warehouses loaded: '
        '${warehouses.length}',
      );

      if (warehouses.isNotEmpty) {
        await selectWarehouse(
          warehouses.first,
        );
      } else {
        selectedWarehouse.value = null;
        _clearAnalytics();
      }
    } catch (e) {
      print(
        '❌ Failed to load owner warehouses: $e',
      );

      warehouses.clear();
      selectedWarehouse.value = null;
      _clearAnalytics();
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
    print(
      '════════ SELECT WAREHOUSE ════════',
    );
    print(
      '🏢 Warehouse: ${warehouse.nameEn}',
    );
    print(
      '🆔 Facility ID: ${warehouse.id}',
    );
    print(
      '════════════════════════════════',
    );

    selectedWarehouse.value = warehouse;

    await loadWarehouseAnalytics(
      warehouse.id,
    );
  }

  // ============================================================
  // LOAD ALL WAREHOUSE ANALYTICS
  // ============================================================

  Future<void> loadWarehouseAnalytics(
    int warehouseId,
  ) async {
    try {
      isLoadingAnalytics.value = true;

      print('');
      print(
        '════════ LOAD WAREHOUSE ANALYTICS ════════',
      );
      print(
        '🏢 Facility ID: $warehouseId',
      );

      // --------------------------------------------------------
      // FIND SELECTED WAREHOUSE
      // --------------------------------------------------------

      final warehouse =
          warehouses.firstWhere(
        (item) => item.id == warehouseId,
      );

      // --------------------------------------------------------
      // SUMMARY
      // --------------------------------------------------------

      totalProducts.value =
          warehouse.productCount;

      lowStockCount.value =
          warehouse.stockOutRiskCount;

      // These endpoints are not connected yet.
      totalStock.value = 0;
      pendingOrders.value = 0;

      // --------------------------------------------------------
      // SLOW MOVING PRODUCTS
      // --------------------------------------------------------

      print('');
      print(
        '════════ GET SLOW MOVING PRODUCTS ════════',
      );
      print(
        '🏢 Facility ID: $warehouseId',
      );

      final slowMoving =
          await _repo.getSlowMovingProducts(
        facilityId: warehouseId,
      );

      slowMovingProducts.assignAll(
        slowMoving,
      );

      print(
        '📦 Slow moving products: '
        '${slowMovingProducts.length}',
      );

      // --------------------------------------------------------
      // STOCK OUT RISK
      // --------------------------------------------------------

      print('');
      print(
        '════════ GET STOCK OUT RISK ════════',
      );
      print(
        '🏢 Facility ID: $warehouseId',
      );

      final stockRisk =
          await _repo.getStockOutRisk(
        facilityId: warehouseId,
      );

      stockOutRiskProducts.assignAll(
        stockRisk,
      );

      print(
        '⚠️ Stock out risk products: '
        '${stockOutRiskProducts.length}',
      );

      // --------------------------------------------------------
      // TOP MOVING PRODUCTS
      // --------------------------------------------------------

      print('');
      print(
        '════════ GET TOP MOVING PRODUCTS ════════',
      );
      print(
        '🏢 Facility ID: $warehouseId',
      );

      final topMoving =
          await _repo.getTopMovingProducts(
        facilityId: warehouseId,
      );

      topMovingProducts.assignAll(
        topMoving,
      );

      print(
        '🚀 Top moving products: '
        '${topMovingProducts.length}',
      );

      
      // --------------------------------------------------------
      // FINAL LOG
      // --------------------------------------------------------

      print('');
      print(
        '════════ ANALYTICS SUMMARY ════════',
      );

      print(
        '📦 Total products: $totalProducts',
      );

      print(
        '📦 Slow moving: '
        '${slowMovingProducts.length}',
      );

      print(
        '⚠️ Stock out risk: '
        '${stockOutRiskProducts.length}',
      );

      print(
        '🚀 Top moving: '
        '${topMovingProducts.length}',
      );

    
      print(
        '════════ ANALYTICS LOADED ════════',
      );
    } catch (e, stackTrace) {
      print('');
      print(
        '════════ ANALYTICS ERROR ════════',
      );

      print('❌ Error: $e');
      print(
        '❌ Type: ${e.runtimeType}',
      );
      print(
        '❌ StackTrace: $stackTrace',
      );

      print(
        '════════════════════════════════',
      );

      // Clear analytics only when
      // the overall analytics load fails.
      slowMovingProducts.clear();
      stockOutRiskProducts.clear();
      topMovingProducts.clear();
    
    } finally {
      isLoadingAnalytics.value = false;
    }
  }

  // ============================================================
  // CLEAR ANALYTICS
  // ============================================================

  void _clearAnalytics() {
    slowMovingProducts.clear();
    stockOutRiskProducts.clear();
    topMovingProducts.clear();
   
    totalProducts.value = 0;
    totalStock.value = 0;
    lowStockCount.value = 0;
    pendingOrders.value = 0;
  }

  // ============================================================
  // REFRESH ANALYTICS
  // ============================================================

  Future<void> refreshAnalytics() async {
    print('');
    print(
      '════════ REFRESH ANALYTICS ════════',
    );

    if (selectedWarehouse.value != null) {
      await loadWarehouseAnalytics(
        selectedWarehouse.value!.id,
      );
    } else {
      await loadWarehouses();
    }
  }
}