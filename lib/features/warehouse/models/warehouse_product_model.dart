class WarehouseProduct {
  final String warehouseId;
  final String warehouseName;
  final String address;
  final double price;
  final double? discountPercentage;
  final int stockQuantity;

  WarehouseProduct({
    required this.warehouseId,
    required this.warehouseName,
    required this.address,
    required this.price,
    this.discountPercentage,
    required this.stockQuantity,
  });

  bool get hasDiscount =>
      discountPercentage != null && discountPercentage! > 0;

  double get discountedPrice {
    if (!hasDiscount) return price;

    return price - (price * discountPercentage! / 100);
  }

  factory WarehouseProduct.fromJson(Map<String, dynamic> json) {
    return WarehouseProduct(
      warehouseId: json['warehouse_id'].toString(),
      warehouseName: json['warehouse_name'] ?? '',
      address: json['address'] ?? '',
      price: (json['price'] as num).toDouble(),
      discountPercentage: json['discount_percentage'] != null
          ? (json['discount_percentage'] as num).toDouble()
          : null,
      stockQuantity: json['stock_quantity'] ?? 0,
    );
  }
}