class SlowMovingProductModel {
  final int id;
  final String sku;
  final String nameEn;
  final String? nameAr;
  final String unit;
  final String productImage;
  final String? descriptionEn;
  final String? descriptionAr;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int totalSold;

  SlowMovingProductModel({
    required this.id,
    required this.sku,
    required this.nameEn,
    this.nameAr,
    required this.unit,
    required this.productImage,
    this.descriptionEn,
    this.descriptionAr,
    this.createdAt,
    this.updatedAt,
    required this.totalSold,
  });

  factory SlowMovingProductModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SlowMovingProductModel(
      id: json['id'] ?? 0,
      sku: json['sku'] ?? '',
      nameEn: json['name_en'] ?? '',
      nameAr: json['name_ar'],
      unit: json['unit'] ?? '',
      productImage: json['product_image']?.toString() ?? '',
      descriptionEn: json['description_en'],
      descriptionAr: json['description_ar'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(
              json['created_at'].toString(),
            )
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(
              json['updated_at'].toString(),
            )
          : null,

      // Backend currently returns null.
      totalSold: json['total_sold'] ?? 0,
    );
  }
}