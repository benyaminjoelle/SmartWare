class OwnerPrefrencesModel {
  final String message;
  final String facilityName;
  final OwnerFacility facility;

  OwnerPrefrencesModel({
    required this.message,
    required this.facilityName,
    required this.facility,
  });

  factory OwnerPrefrencesModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final facilityJson = json['facility'];

    return OwnerPrefrencesModel(
      message: json['message']?.toString() ?? '',
      facilityName:
          json['facility_name']?.toString() ?? '',
      facility: facilityJson is Map
          ? OwnerFacility.fromJson(
              Map<String, dynamic>.from(
                facilityJson,
              ),
            )
          : OwnerFacility.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'facility_name': facilityName,
      'facility': facility.toJson(),
    };
  }
}

class OwnerFacility {
  final int id;

  /*
   * Backend always returns:
   *
   * "business_type": "warehouse"
   */
  final String businessType;

  final List<OwnerCategory> categories;

  OwnerFacility({
    required this.id,
    required this.businessType,
    required this.categories,
  });

  factory OwnerFacility.empty() {
    return OwnerFacility(
      id: 0,
      businessType: 'warehouse',
      categories: [],
    );
  }

  factory OwnerFacility.fromJson(
    Map<String, dynamic> json,
  ) {
    final categoriesJson =
        json['categories'];

    return OwnerFacility(
      id: _parseInt(json['id']),

      businessType:
          json['business_type']?.toString().isNotEmpty ==
                  true
              ? json['business_type'].toString()
              : 'warehouse',

      categories: categoriesJson is List
          ? categoriesJson
              .whereType<Map>()
              .map(
                (item) => OwnerCategory.fromJson(
                  Map<String, dynamic>.from(
                    item,
                  ),
                ),
              )
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_type': businessType,
      'categories':
          categories
              .map(
                (e) => e.toJson(),
              )
              .toList(),
    };
  }

  static int _parseInt(
    dynamic value,
  ) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }
}

class OwnerCategory {
  final int id;
  final String name;

  OwnerCategory({
    required this.id,
    required this.name,
  });

  factory OwnerCategory.fromJson(
    Map<String, dynamic> json,
  ) {
    return OwnerCategory(
      id: _parseInt(json['id']),
      name:
          json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  static int _parseInt(
    dynamic value,
  ) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }
}