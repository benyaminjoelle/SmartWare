// enum StockMovementType {
//   stockIn,    // Supplier purchase, stock arrival
//   stockOut,   // Order fulfillment, client sale
//   transfer,   // Moved to another warehouse
//   adjustment, // Inventory count correction, damaged goods
// }

// class StockMovement {
//   final String id;
//   final String referenceNumber; // Order #, Invoice #, or Transfer ID
//   final DateTime timestamp;
//   final StockMovementType type;
//   final int quantityChange; // Positive (+10) for IN, Negative (-5) for OUT
//   final int balanceAfter;
//   final String performedBy;  // Worker or Owner name
//   final String? notes;

//   StockMovement({
//     required this.id,
//     required this.referenceNumber,
//     required this.timestamp,
//     required this.type,
//     required this.quantityChange,
//     required this.balanceAfter,
//     required this.performedBy,
//     this.notes,
//   });
// }

// class WarehouseStockCardData {
//   final String warehouseId;
//   final String warehouseName;
//   final String productSku;
//   final String productName;
//   final String aisleLocation; // e.g. "Aisle 4, Shelf B-2"
//   final int currentStock;
//   final int minimumThreshold; // Alert if stock goes below
//   final int maximumCapacity;
//   final List<StockMovement> movementHistory;

//   WarehouseStockCardData({
//     required this.warehouseId,
//     required this.warehouseName,
//     required this.productSku,
//     required this.productName,
//     required this.aisleLocation,
//     required this.currentStock,
//     required this.minimumThreshold,
//     required this.maximumCapacity,
//     required this.movementHistory,
//   });
// }