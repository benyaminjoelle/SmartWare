class OwnerOrderModel {
  final int id;
  final int userId;
  final int warehouseId;
  final double expectedPrice;
  final String status;
  final DateTime? orderDate;
  final List<OwnerOrderItem> products;

  OwnerOrderModel({
    required this.id,
    required this.userId,
    required this.warehouseId,
    required this.expectedPrice,
    required this.status,
    required this.orderDate,
    required this.products,
  });

  factory OwnerOrderModel.fromJson(Map<String, dynamic> json) {
    return OwnerOrderModel(
      id: json['id'],
      userId: json['user_id'],
      warehouseId: json['src_facility_id'],
      expectedPrice: double.tryParse(
            json['expected_price']?.toString() ?? '0',
          ) ??
          0,
      status: json['status']?.toString() ?? 'pending',
      orderDate: DateTime.tryParse(
        json['order_date']?.toString() ?? '',
      ),
      products: (json['products'] as List? ?? [])
          .map(
            (e) => OwnerOrderItem.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),
    );
  }

  int get totalQuantity {
    return products.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
  }
}

class OwnerOrderItem {
  final int productId;
  final String productName;
  final String unit;
  final int quantity;
  final double unitPrice;

  OwnerOrderItem({
    required this.productId,
    required this.productName,
    required this.unit,
    required this.quantity,
    required this.unitPrice,
  });

  factory OwnerOrderItem.fromJson(Map<String, dynamic> json) {
    final product = json['product'] is Map
        ? Map<String, dynamic>.from(json['product'])
        : <String, dynamic>{};

    return OwnerOrderItem(
      productId: json['product_id'],
      productName: product['name_en']?.toString() ?? 'Product',
      unit: product['unit']?.toString() ?? '',
      quantity: json['quantity'] ?? 0,
      unitPrice: double.tryParse(
            json['unit_price']?.toString() ?? '0',
          ) ??
          0,
    );
  }
}