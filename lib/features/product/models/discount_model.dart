class DiscountModel {
  final int id;
  final int inventoryId;
  final int createdBy;
  final double percentage;
  final DateTime startsAt;
  final DateTime endsAt;
  final bool isActive;

  DiscountModel({
    required this.id,
    required this.inventoryId,
    required this.createdBy,
    required this.percentage,
    required this.startsAt,
    required this.endsAt,
    required this.isActive,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['id'] as int,
      inventoryId: json['inventory_id'] as int,
      createdBy: json['created_by'] as int,
      percentage: double.parse(json['percentage'].toString()),
      startsAt: DateTime.parse(json['starts_at']),
      endsAt: DateTime.parse(json['ends_at']),
      isActive: json['is_active'] as bool,
    );
  }
}