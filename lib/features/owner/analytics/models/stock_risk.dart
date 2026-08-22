class StockOutRiskProductModel {
  final int id;
  final String sku;
  final String? nameEn;
  final String? nameAr;
  final String? unit;
  final String? productImage;
  final String? descriptionEn;
  final String? descriptionAr;
  final num warehouseQuantity;

  StockOutRiskProductModel({
    required this.id,
    required this.sku,
    this.nameEn,
    this.nameAr,
    this.unit,
    this.productImage,
    this.descriptionEn,
    this.descriptionAr,
    required this.warehouseQuantity,
  });

  factory StockOutRiskProductModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StockOutRiskProductModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse('${json['id']}') ?? 0,

      sku: json['sku']?.toString() ?? '',

      nameEn: json['name_en']?.toString(),
      nameAr: json['name_ar']?.toString(),

      unit: json['unit']?.toString(),

      productImage: json['product_image']?.toString(),

      descriptionEn: json['description_en']?.toString(),
      descriptionAr: json['description_ar']?.toString(),

      warehouseQuantity: json['warehouse_quantity'] is num
          ? json['warehouse_quantity']
          : num.tryParse(
                '${json['warehouse_quantity']}',
              ) ??
              0,
    );
  }

  String get displayName {
    if (nameEn != null && nameEn!.trim().isNotEmpty) {
      return nameEn!;
    }

    if (nameAr != null && nameAr!.trim().isNotEmpty) {
      return nameAr!;
    }

    return 'Unnamed product';
  }
}