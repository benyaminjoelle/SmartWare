enum UserRole { warehouseAdmin, worker, client }

class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String businessName;
  final String phoneNumber;
  final String email;
  final String? token;
  final String? nationalId;
  final String? password;

  final UserRole role;
  UserModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    this.nationalId,
    required this.role,
    required this.phoneNumber,
    required this.id,
    required this.businessName,
    this.token,
    this.password,
  });
  factory UserModel.fromJson(Map<String, dynamic> json, {String? token}) {
    print('USER JSON 👉 $json');

    return UserModel(
      email: json['email'] ?? '',
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      role: _parseRole(json['role']),
      businessName: json['business_name'] ?? '',
      nationalId: json['national_id'] ?? '',
      password: json['password']??'',
      token: token,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'role': role.name,
      'business_name': businessName,
      'token': token,
      'password':password
    };
  }

  static UserRole _parseRole(String? role) {
    switch (role) {
      case 'warehouse_admin':
        return UserRole.warehouseAdmin;

      case 'worker':
        return UserRole.worker;

      case 'client':
        return UserRole.client;

      default:
        return UserRole.client;
    }
  }
}
