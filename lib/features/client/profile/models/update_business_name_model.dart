class UpdateBusinessNameModel {
  final String message;
  final BusinessNameFacilityModel facility;

  UpdateBusinessNameModel({
    required this.message,
    required this.facility,
  });

  factory UpdateBusinessNameModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UpdateBusinessNameModel(
      message: json['message'] ?? '',
      facility: BusinessNameFacilityModel.fromJson(
        json['facility'] ?? {},
      ),
    );
  }
}

class BusinessNameFacilityModel {
  final int id;
  final int? addressId;
  final int userId;
  final String? facilityNameEn;
  final String? facilityNameAr;
  final String facilityType;
  final String facilityStatus;
  final String businessType;
  final String? createdAt;
  final String? updatedAt;

  BusinessNameFacilityModel({
    required this.id,
    this.addressId,
    required this.userId,
    this.facilityNameEn,
    this.facilityNameAr,
    required this.facilityType,
    required this.facilityStatus,
    required this.businessType,
    this.createdAt,
    this.updatedAt,
  });

  factory BusinessNameFacilityModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BusinessNameFacilityModel(
      id: json['id'] ?? 0,
      addressId: json['address_id'],
      userId: json['user_id'] ?? 0,
      facilityNameEn: json['facility_name_en'],
      facilityNameAr: json['facility_name_ar'],
      facilityType: json['facility_type'] ?? '',
      facilityStatus: json['facility_status'] ?? '',
      businessType: json['business_type'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}