import '../../../product/models/product_model.dart'; 

class CartItem {
  final Product product;
  final int warehouseId;
  final String warehouseName;
  final double unitPrice;
  final double? discountPercentage;
  int quantity;

 CartItem({
    required this.product,
    required this.warehouseId,
    required this.warehouseName,
    required this.unitPrice,
    this.discountPercentage,
    required this.quantity,
  });

   // Original warehouse price
  double get total => unitPrice * quantity;

  // Price after warehouse discount
  double get discountedUnitPrice {
    if (discountPercentage == null ||
        discountPercentage! <= 0) {
      return unitPrice;
    }

    return unitPrice - (unitPrice * discountPercentage! / 100);
  }

  // Final amount for this cart item
  double get discountedTotal => discountedUnitPrice * quantity;
  // Total amount saved
  double get savings => (unitPrice - discountedUnitPrice) * quantity;
  String get cartKey => '${product.sku}|$warehouseId';

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'warehouseId': warehouseId,
      'warehouseName': warehouseName,
      'unitPrice': unitPrice,
      'discountPercentage': discountPercentage,
      'quantity': quantity,
    };
  }

  static Map<String, dynamic> _normalizeProductJson(
  Map<String, dynamic> productJson,
) {
  final categories = productJson['categories'];

  if (categories is List) {
    productJson['categories'] = categories.map((category) {
      if (category is String) {
        return {'name': category};
      }
      return category;
    }).toList();
  }

  return productJson;
}

  //useful for restoring saved cart sessions
  factory CartItem.fromJson(Map<String, dynamic> json) {
  return CartItem(
    product: Product.fromJson(
  _normalizeProductJson(
    Map<String, dynamic>.from(json['product']),
  ),
),
    warehouseId: json['warehouseId'] as int,
    warehouseName: json['warehouseName']?.toString() ?? '',
    unitPrice: (json['unitPrice'] as num).toDouble(),
    discountPercentage:
        (json['discountPercentage'] as num?)?.toDouble(),
    quantity: json['quantity'] as int? ?? 1,
  );
}
}