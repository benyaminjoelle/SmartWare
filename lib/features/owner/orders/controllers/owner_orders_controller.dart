import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/core/network/api_service.dart';

enum OrderTab {
  pending,
  incoming,
  outgoing,
}

enum OrderStatus {
  pending,
  accepted,
  denied,
  preparing,
  ready,
  dispatched,
  delivered,
}

enum BatchStatus {
  planned,
  ready,
  dispatched,
  delivered,
}

class OwnerOrdersController extends GetxController {
  final isLoading = false.obs;
  final ApiService apiService = ApiService();
  final selectedTab = OrderTab.pending.obs;

  // ===========================================================================
  // DATA
  // ===========================================================================

  final pendingOrders = <ClientOrderModel>[].obs;

  final incomingOrders = <WarehouseIncomingOrderModel>[].obs;

  final outgoingOrders = <OutgoingOrderModel>[].obs;

  final outgoingBatches = <OutgoingBatchModel>[].obs;

  // ===========================================================================
  // COUNTS
  // ===========================================================================

  int get pendingCount => pendingOrders.length;

  int get incomingCount => incomingOrders.length;

  int get outgoingCount => outgoingOrders.length;

  int get pendingBatchCount {
    return outgoingBatches
        .where((batch) => batch.status != BatchStatus.delivered)
        .length;
  }

  // ===========================================================================
  // LIFECYCLE
  // ===========================================================================

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  // ===========================================================================
  // TAB
  // ===========================================================================

  void changeTab(OrderTab tab) {
    selectedTab.value = tab;
  }

  // ===========================================================================
  // LOAD ORDERS
  // ===========================================================================

Future<void> loadOrders() async {
  try {
    isLoading.value = true;

    final response = await apiService.get('/orders/pending');

    if (response is Map && response['success'] == true) {
      final data = response['data'];

      if (data is List) {
        pendingOrders.assignAll(
          data.map((e) => _clientOrderFromJson(e)),
        );
      }
    }
  } catch (e) {
    print('Failed to load pending orders: $e');
  } finally {
    isLoading.value = false;
  }
}

ClientOrderModel _clientOrderFromJson(Map<String, dynamic> json) {
  final products = json['products'] is List
      ? json['products'] as List
      : [];

  return ClientOrderModel(
    id: json['id'].toString(),
    orderNumber: '#ORD-${json['id']}',
    clientName: json['user']?['name']?.toString() ?? 'Client',
    clientLocation: '',
    clientImageUrl: null,
    createdAt: DateTime.tryParse(
          json['created_at']?.toString() ?? '',
        ) ??
        DateTime.now(),
    items: products.map((item) {
      final product = item['product'];

      return OrderItemModel(
        productName: product?['name_en']?.toString() ?? 'Product',
        quantity: item['quantity'] ?? 0,
        unit: product?['unit']?.toString() ?? '',
        imageUrl: null,
      );
    }).toList(),
  );
}
  Future<void> refreshOrders() async {
    await loadOrders();
  }

  // ===========================================================================
  // DUMMY DATA
  // ===========================================================================

  void _loadDummyData() {
    // -------------------------------------------------------------------------
    // PENDING ORDERS FROM CLIENTS
    // -------------------------------------------------------------------------

    pendingOrders.assignAll([
      ClientOrderModel(
        id: 'ORD-1001',
        orderNumber: '#ORD-1001',
        clientName: 'Al Sham Restaurant',
        clientLocation: 'Mazzeh, Damascus',
        clientImageUrl: null,
        createdAt: DateTime.now().subtract(
          const Duration(minutes: 18),
        ),
        items: [
          OrderItemModel(
            productName: 'Canned Tomatoes',
            quantity: 40,
            unit: 'boxes',
            imageUrl: null,
          ),
          OrderItemModel(
            productName: 'Cooking Oil',
            quantity: 20,
            unit: 'bottles',
            imageUrl: null,
          ),
          OrderItemModel(
            productName: 'Basmati Rice',
            quantity: 15,
            unit: 'bags',
            imageUrl: null,
          ),
        ],
      ),

      ClientOrderModel(
        id: 'ORD-1002',
        orderNumber: '#ORD-1002',
        clientName: 'Fresh Market',
        clientLocation: 'Baramkeh, Damascus',
        clientImageUrl: null,
        createdAt: DateTime.now().subtract(
          const Duration(hours: 1),
        ),
        items: [
          OrderItemModel(
            productName: 'Mineral Water',
            quantity: 60,
            unit: 'packs',
            imageUrl: null,
          ),
          OrderItemModel(
            productName: 'Orange Juice',
            quantity: 25,
            unit: 'boxes',
            imageUrl: null,
          ),
        ],
      ),

      ClientOrderModel(
        id: 'ORD-1003',
        orderNumber: '#ORD-1003',
        clientName: 'Pharma Care',
        clientLocation: 'Kafr Sousa, Damascus',
        clientImageUrl: null,
        createdAt: DateTime.now().subtract(
          const Duration(hours: 2),
        ),
        items: [
          OrderItemModel(
            productName: 'Medical Gloves',
            quantity: 100,
            unit: 'boxes',
            imageUrl: null,
          ),
          OrderItemModel(
            productName: 'Face Masks',
            quantity: 50,
            unit: 'boxes',
            imageUrl: null,
          ),
          OrderItemModel(
            productName: 'Hand Sanitizer',
            quantity: 30,
            unit: 'bottles',
            imageUrl: null,
          ),
          OrderItemModel(
            productName: 'First Aid Kits',
            quantity: 10,
            unit: 'kits',
            imageUrl: null,
          ),
        ],
      ),

      ClientOrderModel(
        id: 'ORD-1004',
        orderNumber: '#ORD-1004',
        clientName: 'Smart Electronics',
        clientLocation: 'Abu Rummaneh, Damascus',
        clientImageUrl: null,
        createdAt: DateTime.now().subtract(
          const Duration(hours: 4),
        ),
        items: [
          OrderItemModel(
            productName: 'USB-C Cable',
            quantity: 35,
            unit: 'pieces',
            imageUrl: null,
          ),
          OrderItemModel(
            productName: 'Wireless Mouse',
            quantity: 15,
            unit: 'pieces',
            imageUrl: null,
          ),
        ],
      ),
    ]);

    // -------------------------------------------------------------------------
    // INCOMING ORDERS FROM OTHER WAREHOUSES
    // -------------------------------------------------------------------------

    incomingOrders.assignAll([
      WarehouseIncomingOrderModel(
        id: 'INC-2001',
        orderNumber: '#INC-2001',
        warehouseName: 'North Damascus Warehouse',
        warehouseLocation: 'Qaboun, Damascus',
        warehouseImageUrl: null,
        expectedDate: DateTime.now().add(
          const Duration(days: 1),
        ),
        status: OrderStatus.accepted,
        items: [
          OrderItemModel(
            productName: 'Cardboard Boxes',
            quantity: 100,
            unit: 'boxes',
            imageUrl: null,
          ),
          OrderItemModel(
            productName: 'Packing Tape',
            quantity: 50,
            unit: 'rolls',
            imageUrl: null,
          ),
        ],
      ),

      WarehouseIncomingOrderModel(
        id: 'INC-2002',
        orderNumber: '#INC-2002',
        warehouseName: 'Aleppo Distribution Center',
        warehouseLocation: 'Aleppo',
        warehouseImageUrl: null,
        expectedDate: DateTime.now().add(
          const Duration(days: 2),
        ),
        status: OrderStatus.preparing,
        items: [
          OrderItemModel(
            productName: 'Plastic Containers',
            quantity: 80,
            unit: 'boxes',
            imageUrl: null,
          ),
          OrderItemModel(
            productName: 'Storage Bins',
            quantity: 30,
            unit: 'pieces',
            imageUrl: null,
          ),
          OrderItemModel(
            productName: 'Labels',
            quantity: 200,
            unit: 'packs',
            imageUrl: null,
          ),
        ],
      ),

      WarehouseIncomingOrderModel(
        id: 'INC-2003',
        orderNumber: '#INC-2003',
        warehouseName: 'Homs Central Warehouse',
        warehouseLocation: 'Homs',
        warehouseImageUrl: null,
        expectedDate: DateTime.now().add(
          const Duration(days: 4),
        ),
        status: OrderStatus.dispatched,
        items: [
          OrderItemModel(
            productName: 'Cleaning Supplies',
            quantity: 45,
            unit: 'boxes',
            imageUrl: null,
          ),
          OrderItemModel(
            productName: 'Paper Towels',
            quantity: 70,
            unit: 'packs',
            imageUrl: null,
          ),
        ],
      ),
    ]);

    // -------------------------------------------------------------------------
    // OUTGOING ORDERS
    // -------------------------------------------------------------------------

    outgoingOrders.assignAll([
      OutgoingOrderModel(
        id: 'OUT-3001',
        orderNumber: '#ORD-1005',
        destination: 'Damascus Grocery',
        destinationLocation: 'Malki, Damascus',
        itemsCount: 3,
        totalQuantity: 75,
        acceptedAt: DateTime.now().subtract(
          const Duration(hours: 5),
        ),
        status: OrderStatus.preparing,
      ),

      OutgoingOrderModel(
        id: 'OUT-3002',
        orderNumber: '#ORD-1006',
        destination: 'Al Noor Restaurant',
        destinationLocation: 'Jaramana, Damascus',
        itemsCount: 5,
        totalQuantity: 120,
        acceptedAt: DateTime.now().subtract(
          const Duration(hours: 7),
        ),
        status: OrderStatus.accepted,
      ),

      OutgoingOrderModel(
        id: 'OUT-3003',
        orderNumber: '#ORD-1007',
        destination: 'City Pharmacy',
        destinationLocation: 'Shaalan, Damascus',
        itemsCount: 4,
        totalQuantity: 90,
        acceptedAt: DateTime.now().subtract(
          const Duration(days: 1),
        ),
        status: OrderStatus.ready,
      ),

      OutgoingOrderModel(
        id: 'OUT-3004',
        orderNumber: '#ORD-1008',
        destination: 'Modern Market',
        destinationLocation: 'Dummar, Damascus',
        itemsCount: 6,
        totalQuantity: 160,
        acceptedAt: DateTime.now().subtract(
          const Duration(days: 1),
        ),
        status: OrderStatus.preparing,
      ),

      OutgoingOrderModel(
        id: 'OUT-3005',
        orderNumber: '#ORD-1009',
        destination: 'Tech House',
        destinationLocation: 'Baramkeh, Damascus',
        itemsCount: 2,
        totalQuantity: 45,
        acceptedAt: DateTime.now().subtract(
          const Duration(days: 2),
        ),
        status: OrderStatus.dispatched,
      ),
    ]);

    // -------------------------------------------------------------------------
    // OUTGOING BATCHES
    // -------------------------------------------------------------------------

    outgoingBatches.assignAll([
      OutgoingBatchModel(
        id: 'BAT-4001',
        batchNumber: 'B-24001',
        orders: [
          outgoingOrders[0],
          outgoingOrders[1],
        ],
        scheduledDate: DateTime.now().add(
          const Duration(days: 1),
        ),
        status: BatchStatus.planned,
      ),

      OutgoingBatchModel(
        id: 'BAT-4002',
        batchNumber: 'B-24002',
        orders: [
          outgoingOrders[2],
          outgoingOrders[3],
        ],
        scheduledDate: DateTime.now().add(
          const Duration(days: 2),
        ),
        status: BatchStatus.ready,
      ),
    ]);
  }

  // ===========================================================================
  // PENDING ORDERS
  // ===========================================================================

  void openPendingOrder(ClientOrderModel order) {
    // TODO:
    // Open the order details view / bottom sheet.
  }

  Future<void> acceptOrder(ClientOrderModel order) async {
    // TODO:
    // Send accept request to backend.

    pendingOrders.remove(order);

    outgoingOrders.insert(
      0,
      OutgoingOrderModel(
        id: 'OUT-${order.id}',
        orderNumber: order.orderNumber,
        destination: order.clientName,
        destinationLocation: order.clientLocation,
        itemsCount: order.items.length,
        totalQuantity: order.totalQuantity,
        acceptedAt: DateTime.now(),
        status: OrderStatus.accepted,
      ),
    );
  }

  Future<void> denyOrder(ClientOrderModel order) async {
    // TODO:
    // Send deny request to backend.

    pendingOrders.remove(order);
  }

  // ===========================================================================
  // INCOMING
  // ===========================================================================

  void openIncomingOrder(
    WarehouseIncomingOrderModel order,
  ) {
    // TODO:
    // Open incoming order details.
  }

  // ===========================================================================
  // OUTGOING
  // ===========================================================================

  void openOutgoingOrder(
    OutgoingOrderModel order,
  ) {
    // TODO:
    // Open outgoing order details.
  }

  void openBatch(
    OutgoingBatchModel batch,
  ) {
    // TODO:
    // Open batch details.
  }

  // ===========================================================================
  // BATCHING
  // ===========================================================================

  void createBatch() {
    final availableOrders = outgoingOrders
        .where(
          (order) =>
              order.status == OrderStatus.accepted ||
              order.status == OrderStatus.preparing,
        )
        .toList();

    if (availableOrders.isEmpty) {
      return;
    }

    final batchNumber =
        'B-${DateTime.now().millisecondsSinceEpoch}';

    final batch = OutgoingBatchModel(
      id: batchNumber,
      batchNumber: batchNumber,
      orders: availableOrders,
      scheduledDate: DateTime.now().add(
        const Duration(days: 1),
      ),
      status: BatchStatus.planned,
    );

    outgoingBatches.add(batch);

    for (final order in availableOrders) {
      order.status = OrderStatus.preparing;
    }

    outgoingOrders.refresh();
  }

  void markBatchReady(
    OutgoingBatchModel batch,
  ) {
    batch.status = BatchStatus.ready;

    for (final order in batch.orders) {
      order.status = OrderStatus.ready;
    }

    outgoingBatches.refresh();
    outgoingOrders.refresh();
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  String get tabTitle {
    switch (selectedTab.value) {
      case OrderTab.pending:
        return 'Pending orders';

      case OrderTab.incoming:
        return 'Incoming orders';

      case OrderTab.outgoing:
        return 'Outgoing orders';
    }
  }
}

// =============================================================================
// CLIENT ORDER
// =============================================================================

class ClientOrderModel {
  final String id;
  final String orderNumber;
  final String clientName;
  final String clientLocation;
  final String? clientImageUrl;
  final DateTime createdAt;
  final List<OrderItemModel> items;

  ClientOrderModel({
    required this.id,
    required this.orderNumber,
    required this.clientName,
    required this.clientLocation,
    this.clientImageUrl,
    required this.createdAt,
    required this.items,
  });

  int get itemsCount => items.length;

  int get totalQuantity {
    return items.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
  }
}

// =============================================================================
// INCOMING ORDER
// =============================================================================

class WarehouseIncomingOrderModel {
  final String id;
  final String orderNumber;
  final String warehouseName;
  final String warehouseLocation;
  final String? warehouseImageUrl;
  final DateTime expectedDate;
  final List<OrderItemModel> items;
  final OrderStatus status;

  WarehouseIncomingOrderModel({
    required this.id,
    required this.orderNumber,
    required this.warehouseName,
    required this.warehouseLocation,
    this.warehouseImageUrl,
    required this.expectedDate,
    required this.items,
    required this.status,
  });

  int get totalQuantity {
    return items.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
  }
}

// =============================================================================
// OUTGOING ORDER
// =============================================================================

class OutgoingOrderModel {
  final String id;
  final String orderNumber;
  final String destination;
  final String destinationLocation;
  final int itemsCount;
  final int totalQuantity;
  final DateTime acceptedAt;

  OrderStatus status;

  OutgoingOrderModel({
    required this.id,
    required this.orderNumber,
    required this.destination,
    required this.destinationLocation,
    required this.itemsCount,
    required this.totalQuantity,
    required this.acceptedAt,
    required this.status,
  });
}

// =============================================================================
// OUTGOING BATCH
// =============================================================================

class OutgoingBatchModel {
  final String id;
  final String batchNumber;
  final List<OutgoingOrderModel> orders;
  final DateTime scheduledDate;

  BatchStatus status;

  OutgoingBatchModel({
    required this.id,
    required this.batchNumber,
    required this.orders,
    required this.scheduledDate,
    required this.status,
  });

  int get orderCount => orders.length;

  int get totalItems {
    return orders.fold(
      0,
      (sum, order) => sum + order.totalQuantity,
    );
  }
}

// =============================================================================
// ORDER ITEM
// =============================================================================

class OrderItemModel {
  final String productName;
  final String? imageUrl;
  final int quantity;
  final String unit;

  OrderItemModel({
    required this.productName,
    this.imageUrl,
    required this.quantity,
    required this.unit,
  });
}