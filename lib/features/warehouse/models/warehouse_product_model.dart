class WarehouseProductModel {
  //product
  final int productId;
  final int quantity;
  final double unitPrice;
  final int companyId;
  final double? discountPercentage;
  //warehouse
  final String name;
  final String capacity;
  final int warehouseId;
  final String warehouseName;
  final int sectionId;
  final String address;


  WarehouseProductModel({
    required this.sectionId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.warehouseId,
    required this.warehouseName,
    required this.companyId,
    required this.name,
    required this.capacity,
    required this.address,
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
 
  factory WarehouseProductModel.fromJson(Map<String, dynamic> json) {
    return WarehouseProductModel(
      sectionId: json['section_id'] as int,
      productId: json['product_id'] as int,
      quantity: json['quantity'] as int,
      unitPrice: (json['unit_price'] as num).toDouble(),
      discountPercentage: (json['discount_percentage'] as num?)?.toDouble(),
      warehouseId: json['warehouse_id'] as int,
      warehouseName: json['warehouse_name'] as String,
      companyId: json['company_id'] as int,
      name: json['name'] as String,
      capacity: json['capacity'] as String,
      address: json['address'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'section_id': sectionId,
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'warehouse_id': warehouseId,
      'warehouse_name':warehouseName,
      'company_id': companyId,
      'name': name,
      'capacity': capacity,
      'discount_percentage': discountPercentage,
      'address': address,
    };
  }
}