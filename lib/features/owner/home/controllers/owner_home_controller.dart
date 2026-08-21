import 'package:get/get.dart';
import 'package:smartware/core/routes/app_routes.dart';
import 'package:smartware/core/utils/pref_helper.dart';

class OwnerHomeController extends GetxController {
  // ===========================================================================
  // STATE
  // ===========================================================================
  final userName = 'User name'.obs;
  final isLoading = false.obs;

  // ===========================================================================
  // MAIN OVERVIEW
  // ===========================================================================

  final warehouseCount = 0.obs;
  final productCount = 0.obs;
  final pendingOrders = 0.obs;
  final lowStockCount = 0.obs;

  // Additional useful dashboard information
  final workerCount = 0.obs;
  final totalInventoryUnits = 0.obs;
  final todayOrders = 0.obs;
  final ordersNeedingAttention = 0.obs;

  // ===========================================================================
  // OPERATION STATUS
  // ===========================================================================

  final systemOperational = true.obs;

  /// 0.0 -> 1.0
  /// Represents the overall warehouse capacity.
  final overallCapacity = 0.0.obs;

  // ===========================================================================
  // HOME LISTS
  // ===========================================================================

  final warehouses = <OwnerWarehouseHomeModel>[].obs;

  final lowStockProducts = <OwnerLowStockHomeModel>[].obs;

  final recentOrders = <OwnerRecentOrderModel>[].obs;

  // ===========================================================================
  // GREETING
  // ===========================================================================

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

  // ===========================================================================
  // COMPUTED VALUES
  // ===========================================================================

  /// Number of warehouses that are almost full.
  int get warehousesNearCapacity {
    return warehouses.where((warehouse) => warehouse.capacity >= 0.85).length;
  }

  /// Number of products that are critically low.
  int get criticalStockCount {
    return lowStockProducts
        .where((product) => product.currentStock <= product.minimumStock * 0.5)
        .length;
  }

  /// The warehouse using the most space.
  OwnerWarehouseHomeModel? get busiestWarehouse {
    if (warehouses.isEmpty) {
      return null;
    }

    return warehouses.reduce(
      (current, next) => current.capacity > next.capacity ? current : next,
    );
  }

  /// Percentage of overall warehouse capacity.
  int get overallCapacityPercentage {
    return (overallCapacity.value * 100).round();
  }

  /// Whether there is something that needs owner's attention.
  bool get hasAlerts {
    return lowStockCount.value > 0 ||
        pendingOrders.value > 0 ||
        warehousesNearCapacity > 0;
  }

  // ===========================================================================
  // LIFECYCLE
  // ===========================================================================

  @override
  void onInit() {
    super.onInit();
    loadUserName();
    loadHome();
  }

  Future<void> loadUserName() async {
    final name = await PrefHelper.getUserName();

    if (name != null && name.isNotEmpty) {
      userName.value = name;
    }
  }
  // ===========================================================================
  // LOAD HOME
  // ===========================================================================

  Future<void> loadHome() async {
    try {
      isLoading.value = true;

      // ========================================================================
      // TODO: BACKEND
      // ========================================================================
      //
      // Replace the demo section below with your API call.
      //
      // Backend should eventually return:
      //
      // owner
      // warehouses
      // products
      // workers
      // orders
      // inventory statistics
      // low stock products
      // recent orders
      //
      // ========================================================================

      await Future.delayed(const Duration(milliseconds: 700));

      _loadDemoData();
    } catch (e) {
      // TODO:
      // Handle API error here.
      //
      // Example:
      // Get.snackbar(
      //   'Error',
      //   'Unable to load dashboard data',
      // );
    } finally {
      isLoading.value = false;
    }
  }

  // ===========================================================================
  // DEMO DATA
  // ===========================================================================

  void _loadDemoData() {
    // -------------------------------------------------------------------------
    // OWNER
    // -------------------------------------------------------------------------

    // -------------------------------------------------------------------------
    // OVERVIEW
    // -------------------------------------------------------------------------

    warehouseCount.value = 4;

    productCount.value = 248;

    pendingOrders.value = 7;

    lowStockCount.value = 6;

    workerCount.value = 18;

    totalInventoryUnits.value = 12840;

    todayOrders.value = 23;

    ordersNeedingAttention.value = 4;

    // -------------------------------------------------------------------------
    // SYSTEM
    // -------------------------------------------------------------------------

    systemOperational.value = true;

    overallCapacity.value = 0.68;

    // -------------------------------------------------------------------------
    // WAREHOUSES
    // -------------------------------------------------------------------------

    warehouses.assignAll([
      OwnerWarehouseHomeModel(
        name: 'Main Warehouse',
        location: 'Damascus',
        imageUrl: null,
        capacity: 0.68,
        productCount: 124,
        workerCount: 8,
        inventoryUnits: 6840,
        status: WarehouseStatus.operational,
      ),

      OwnerWarehouseHomeModel(
        name: 'North Warehouse',
        location: 'Aleppo',
        imageUrl: null,
        capacity: 0.84,
        productCount: 76,
        workerCount: 5,
        inventoryUnits: 3920,
        status: WarehouseStatus.operational,
      ),

      OwnerWarehouseHomeModel(
        name: 'Cold Storage',
        location: 'Damascus',
        imageUrl: null,
        capacity: 0.47,
        productCount: 31,
        workerCount: 3,
        inventoryUnits: 1450,
        status: WarehouseStatus.operational,
      ),

      OwnerWarehouseHomeModel(
        name: 'West Warehouse',
        location: 'Homs',
        imageUrl: null,
        capacity: 0.91,
        productCount: 17,
        workerCount: 2,
        inventoryUnits: 630,
        status: WarehouseStatus.nearCapacity,
      ),
    ]);

    // -------------------------------------------------------------------------
    // LOW STOCK PRODUCTS
    // -------------------------------------------------------------------------

    lowStockProducts.assignAll([
      OwnerLowStockHomeModel(
        name: 'Coca Cola 330ml',
        currentStock: 12,
        minimumStock: 30,
        imageUrl: null,
        warehouseName: 'Main Warehouse',
      ),

      OwnerLowStockHomeModel(
        name: 'Pepsi 330ml',
        currentStock: 8,
        minimumStock: 25,
        imageUrl: null,
        warehouseName: 'Main Warehouse',
      ),

      OwnerLowStockHomeModel(
        name: 'Bottled Water 500ml',
        currentStock: 14,
        minimumStock: 40,
        imageUrl: null,
        warehouseName: 'North Warehouse',
      ),

      OwnerLowStockHomeModel(
        name: 'Orange Juice 1L',
        currentStock: 6,
        minimumStock: 20,
        imageUrl: null,
        warehouseName: 'Cold Storage',
      ),

      OwnerLowStockHomeModel(
        name: 'Energy Drink',
        currentStock: 9,
        minimumStock: 15,
        imageUrl: null,
        warehouseName: 'West Warehouse',
      ),

      OwnerLowStockHomeModel(
        name: 'Chocolate Bars',
        currentStock: 11,
        minimumStock: 25,
        imageUrl: null,
        warehouseName: 'North Warehouse',
      ),
    ]);

    // -------------------------------------------------------------------------
    // RECENT ORDERS
    // -------------------------------------------------------------------------

    recentOrders.assignAll([
      OwnerRecentOrderModel(
        orderNumber: '#ORD-1048',
        clientName: 'Al Sham Restaurant',
        status: 'Pending',
        totalItems: 24,
        createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
      ),

      OwnerRecentOrderModel(
        orderNumber: '#ORD-1047',
        clientName: 'Fresh Market',
        status: 'Processing',
        totalItems: 42,
        createdAt: DateTime.now().subtract(const Duration(minutes: 38)),
      ),

      OwnerRecentOrderModel(
        orderNumber: '#ORD-1046',
        clientName: 'City Pharmacy',
        status: 'Ready',
        totalItems: 18,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),

      OwnerRecentOrderModel(
        orderNumber: '#ORD-1045',
        clientName: 'Daily Needs Store',
        status: 'Completed',
        totalItems: 31,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),

      OwnerRecentOrderModel(
        orderNumber: '#ORD-1044',
        clientName: 'Al Noor Market',
        status: 'Completed',
        totalItems: 16,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
    ]);
  }

  // ===========================================================================
  // REFRESH
  // ===========================================================================

  Future<void> refreshHome() async {
    await loadHome();
  }

  // ===========================================================================
  // QUICK ACTIONS
  // ===========================================================================

  void addProduct() {
    // TODO:
    // Navigate to add product.
  }

  void addWorker() {
    // TODO:
    // Navigate to add worker.
  }

  // ===========================================================================
  // NAVIGATION
  // ===========================================================================

  void openProducts() {
    // TODO:
    // Navigate to products.
  }

  void openOrders() {
    // TODO:
    // Navigate to orders.
  }

  void openWarehouses() {
    // TODO:
    // Navigate to warehouses.
  }

 
  void openWarehouse(OwnerWarehouseHomeModel warehouse) {
    // TODO:
    // Open warehouse details.
  }

  void openProduct(OwnerLowStockHomeModel product) {
    // TODO:
    // Open product details.
  }

  // ===========================================================================
  // FUTURE API HELPERS
  // ===========================================================================

  /// This will be useful once the backend returns warehouse data.
  void setWarehouseData(List<OwnerWarehouseHomeModel> data) {
    warehouses.assignAll(data);

    warehouseCount.value = data.length;

    if (data.isEmpty) {
      overallCapacity.value = 0;
      return;
    }

    final totalCapacity = data.fold<double>(
      0,
      (sum, warehouse) => sum + warehouse.capacity,
    );

    overallCapacity.value = (totalCapacity / data.length).clamp(0.0, 1.0);
  }

  /// Update stock alerts after loading products.
  void setLowStockData(List<OwnerLowStockHomeModel> data) {
    lowStockProducts.assignAll(data);
    lowStockCount.value = data.length;
  }

  /// Update orders after loading orders.
  void setOrderData(List<OwnerRecentOrderModel> data) {
    recentOrders.assignAll(data);

    pendingOrders.value = data
        .where((order) => order.status.toLowerCase() == 'pending')
        .length;
  }
}

// =============================================================================
// WAREHOUSE MODEL
// =============================================================================

class OwnerWarehouseHomeModel {
  final String name;
  final String location;
  final String? imageUrl;
  final double capacity;

  // Extra information useful for the home screen
  final int productCount;
  final int workerCount;
  final int inventoryUnits;
  final WarehouseStatus status;

  OwnerWarehouseHomeModel({
    required this.name,
    required this.location,
    this.imageUrl,
    required this.capacity,
    this.productCount = 0,
    this.workerCount = 0,
    this.inventoryUnits = 0,
    this.status = WarehouseStatus.operational,
  });
}

// =============================================================================
// WAREHOUSE STATUS
// =============================================================================

enum WarehouseStatus { operational, nearCapacity, maintenance, inactive }

// =============================================================================
// LOW STOCK MODEL
// =============================================================================

class OwnerLowStockHomeModel {
  final String name;
  final int currentStock;
  final int minimumStock;
  final String? imageUrl;

  // Useful to tell the owner where the problem is.
  final String warehouseName;

  OwnerLowStockHomeModel({
    required this.name,
    required this.currentStock,
    required this.minimumStock,
    this.imageUrl,
    this.warehouseName = '',
  });

  // ---------------------------------------------------------------------------
  // STOCK HELPERS
  // ---------------------------------------------------------------------------

  double get stockPercentage {
    if (minimumStock <= 0) {
      return 0;
    }

    return (currentStock / minimumStock).clamp(0.0, 1.0);
  }

  bool get isCritical {
    return currentStock <= minimumStock * 0.5;
  }

  bool get isOutOfStock {
    return currentStock <= 0;
  }
}

// =============================================================================
// RECENT ORDER MODEL
// =============================================================================

class OwnerRecentOrderModel {
  final String orderNumber;
  final String clientName;
  final String status;

  final int totalItems;
  final DateTime createdAt;

  OwnerRecentOrderModel({
    required this.orderNumber,
    required this.clientName,
    required this.status,
    this.totalItems = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // ---------------------------------------------------------------------------
  // STATUS HELPERS
  // ---------------------------------------------------------------------------

  bool get isPending {
    return status.toLowerCase() == 'pending';
  }

  bool get isProcessing {
    return status.toLowerCase() == 'processing';
  }

  bool get isReady {
    return status.toLowerCase() == 'ready';
  }

  bool get isCompleted {
    return status.toLowerCase() == 'completed';
  }

  // ---------------------------------------------------------------------------
  // TIME
  // ---------------------------------------------------------------------------

  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    }

    return '${difference.inDays}d ago';
  }
}
