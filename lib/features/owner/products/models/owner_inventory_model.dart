class OwnerInventoryModel {
  final int id;
  final int sectionId;
  final int productId;
  final int quantity;
  final double unitPrice;
  final OwnerProductModel product;

  OwnerInventoryModel({
    required this.id,
    required this.sectionId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.product,
  });

  factory OwnerInventoryModel.fromJson(Map<String, dynamic> json) {
    return OwnerInventoryModel(
      id: json['id'] ?? 0,
      sectionId: json['section_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      quantity: json['quantity'] ?? 0,
      unitPrice: double.tryParse(
            json['unit_price']?.toString() ?? '0',
          ) ??
          0,
      product: OwnerProductModel.fromJson(
        json['product'] ?? {},
      ),
    );
  }
}

class OwnerProductModel {
  final int id;
  final String sku;
  final String nameEn;
  final String nameAr;
  final String unit;
  final String? productImage;
  final String? descriptionEn;
  final String? descriptionAr;

  OwnerProductModel({
    required this.id,
    required this.sku,
    required this.nameEn,
    required this.nameAr,
    required this.unit,
    this.productImage,
    this.descriptionEn,
    this.descriptionAr,
  });

  factory OwnerProductModel.fromJson(Map<String, dynamic> json) {
    return OwnerProductModel(
      id: json['id'] ?? 0,
      sku: json['sku'] ?? '',
      nameEn: json['name_en'] ?? '',
      nameAr: json['name_ar'] ?? '',
      unit: json['unit'] ?? '',
      productImage: json['product_image']?.toString(),
      descriptionEn: json['description_en']?.toString(),
      descriptionAr: json['description_ar']?.toString(),
    );
  }
}