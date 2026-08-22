class TopMovingProductModel {
  final int id;
  final String sku;
  final String nameEn;
  final String nameAr;
  final String unit;
  final int totalSold;

  TopMovingProductModel({
    required this.id,
    required this.sku,
    required this.nameEn,
    required this.nameAr,
    required this.unit,
    required this.totalSold,
  });

  factory TopMovingProductModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TopMovingProductModel(
      id: json['id'] ?? 0,
      sku: json['sku']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? '',
      nameAr: json['name_ar']?.toString() ?? '',
      unit: json['unit']?.toString() ?? '',
      totalSold: _parseInt(json['total_sold']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;

    if (value is int) return value;

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString()) ?? 0;
  }
}