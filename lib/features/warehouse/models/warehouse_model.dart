class Warehouse {
  final int id;
  final String name;
  final String address;
  final String city;
  final String phone;
  final String managerName;
  final int totalCapacityUnits;
  final int currentOccupiedUnits;
  final double latitude;
  final double longitude;

  Warehouse({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.phone,
    required this.managerName,
    required this.totalCapacityUnits,
    required this.currentOccupiedUnits,
    required this.latitude,
    required this.longitude,
  });

  // Helper getter to calculate capacity percentage
 double get occupancyPercentage {
  if (totalCapacityUnits <= 0) {
    return 0;
  }
  return (currentOccupiedUnits / totalCapacityUnits) * 100;
}

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      id: json['id'] as int,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      phone: json['phone'] ?? '',
      managerName: json['manager_name'] ?? '',
      totalCapacityUnits: json['total_capacity'] ?? 0,
      currentOccupiedUnits: json['current_occupied'] ?? 0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'phone': phone,
      'manager_name': managerName,
      'total_capacity': totalCapacityUnits,
      'current_occupied': currentOccupiedUnits,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}