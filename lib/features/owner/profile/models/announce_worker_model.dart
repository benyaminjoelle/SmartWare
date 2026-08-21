class AnnounceWorkerResponse {
  final String message;
  final AnnounceWorkerModel data;

  const AnnounceWorkerResponse({
    required this.message,
    required this.data,
  });

  factory AnnounceWorkerResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return AnnounceWorkerResponse(
      message: json['message']?.toString() ?? '',
      data: AnnounceWorkerModel.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }
}

class AnnounceWorkerModel {
  final String employmentWarehouseId;
  final int managerId;
  final String firstName;
  final String lastName;
  final String nationalId;
  final bool claimed;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int id;

  const AnnounceWorkerModel({
    required this.employmentWarehouseId,
    required this.managerId,
    required this.firstName,
    required this.lastName,
    required this.nationalId,
    required this.claimed,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory AnnounceWorkerModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AnnounceWorkerModel(
      employmentWarehouseId:
          json['employmentWarehouse_id']?.toString() ?? '',

      managerId:
          int.tryParse(
            json['manager_id']?.toString() ?? '',
          ) ??
          0,

      firstName:
          json['first_name']?.toString() ?? '',

      lastName:
          json['last_name']?.toString() ?? '',

      nationalId:
          json['national_id']?.toString() ?? '',

      claimed:
          json['claimed'] == true,

      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(
                  json['updated_at'].toString(),
                )
              : null,

      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(
                  json['created_at'].toString(),
                )
              : null,

      id:
          int.tryParse(
            json['id']?.toString() ?? '',
          ) ??
          0,
    );
  }
}