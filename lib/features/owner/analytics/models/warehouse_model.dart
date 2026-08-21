class WarehouseModel {
  final int id;
  final int addressId;
  final int userId;

  final String nameEn;
  final String? nameAr;

  final String type;
  final String status;
  final String businessType;

  final DateTime createdAt;
  final DateTime updatedAt;

  final int productCount;
  final int stockOutRiskCount;

  final String location;

  WarehouseModel({
    required this.id,
    required this.addressId,
    required this.userId,
    required this.nameEn,
    this.nameAr,
    required this.type,
    required this.status,
    required this.businessType,
    required this.createdAt,
    required this.updatedAt,
    required this.productCount,
    required this.stockOutRiskCount,
    required this.location,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    final address = json['address'];

    return WarehouseModel(
      id: json['id'] ?? 0,
      addressId: json['address_id'] ?? 0,
      userId: json['user_id'] ?? 0,

      nameEn: json['facility_name_en'] ?? '',
      nameAr: json['facility_name_ar'],

      type: json['facility_type'] ?? '',
      status: json['facility_status'] ?? '',
      businessType: json['business_type'] ?? '',

      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),

      productCount: json['product_count'] ?? 0,
      stockOutRiskCount: json['stock_out_risk_count'] ?? 0,

      location: address is Map<String, dynamic>
          ? address['address'] ?? ''
          : '',
    );
  }
}