class ClientPreferencesModel {
  final String message;
  final String facilityName;
  final FacilityModel facility;

  ClientPreferencesModel({
    required this.message,
    required this.facilityName,
    required this.facility,
  });

  factory ClientPreferencesModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClientPreferencesModel(
      message: json['message'] ?? '',
      facilityName: json['facility_name'] ?? '',
      facility: FacilityModel.fromJson(
        json['facility'] ?? {},
      ),
    );
  }
}

class FacilityModel {
  final int userId;
  final String facilityType;
  final String businessType;
  final String facilityStatus;
  final String updatedAt;
  final String createdAt;
  final int id;
  final List<FacilityCategoryModel> categories;

  FacilityModel({
    required this.userId,
    required this.facilityType,
    required this.businessType,
    required this.facilityStatus,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.categories,
  });

  factory FacilityModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FacilityModel(
      userId: json['user_id'] ?? 0,
      facilityType: json['facility_type'] ?? '',
      businessType: json['business_type'] ?? '',
      facilityStatus: json['facility_status'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      id: json['id'] ?? 0,
      categories: (json['categories'] as List? ?? [])
          .map(
            (category) => FacilityCategoryModel.fromJson(
              category,
            ),
          )
          .toList(),
    );
  }
}

class FacilityCategoryModel {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;
  final CategoryPivotModel pivot;

  FacilityCategoryModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });

  factory FacilityCategoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FacilityCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      pivot: CategoryPivotModel.fromJson(
        json['pivot'] ?? {},
      ),
    );
  }
}

class CategoryPivotModel {
  final int facilityId;
  final int categoryId;

  CategoryPivotModel({
    required this.facilityId,
    required this.categoryId,
  });

  factory CategoryPivotModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CategoryPivotModel(
      facilityId: json['facility_id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
    );
  }
}

class ClientPreferencesResponseModel {
  final List<FacilityCategoryModel> preferences;

  ClientPreferencesResponseModel({
    required this.preferences,
  });

  factory ClientPreferencesResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClientPreferencesResponseModel(
      preferences: (json['preferences'] as List? ?? [])
          .map(
            (preference) => FacilityCategoryModel.fromJson(
              preference,
            ),
          )
          .toList(),
    );
  }
}