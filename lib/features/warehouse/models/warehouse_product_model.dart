class WarehouseProductModel {
  // Inventory / product
  final int inventoryId;
  final int productId;
  final int quantity;
  final double unitPrice;
  final double? discountPercentage;

  // Section
  final int sectionId;
  final String sectionName;
  final String capacity;

  // Warehouse
  final int warehouseId;
  final String warehouseName;
  final int? addressId;

  WarehouseProductModel({
    required this.inventoryId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.sectionId,
    required this.sectionName,
    required this.capacity,
    required this.warehouseId,
    required this.warehouseName,
    required this.addressId,
    this.discountPercentage,
  });

  bool get hasDiscount =>
      discountPercentage != null && discountPercentage! > 0;

  double get discountedPrice {
    if (!hasDiscount) return unitPrice;

    return unitPrice -
        (unitPrice * discountPercentage! / 100);
  }

  double get savingsPerUnit {
    return hasDiscount
        ? unitPrice - discountedPrice
        : 0.0;
  }
}