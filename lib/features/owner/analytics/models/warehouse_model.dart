class WarehouseModel {
  final String name;
  final String type;
  final String status;
  final int ownerId;
  final int addressId;

  WarehouseModel({
    required this.name,
    required this.type,
    required this.status,
    required this.ownerId,
    required this.addressId,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      name: json['facility_name'] ?? '',
      type: json['facility_type'] ?? '',
      status: json['facility_status'] ?? '',
      ownerId: json['owner_id'] ?? 0,
      addressId: json['address_id'] ?? 0,
    );
  }
}