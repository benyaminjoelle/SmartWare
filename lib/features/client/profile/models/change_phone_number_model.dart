class ChangePhoneNumberModel {
  final String message;
  final String phoneNumber;

  ChangePhoneNumberModel({
    required this.message,
    required this.phoneNumber,
  });

  factory ChangePhoneNumberModel.fromJson(Map<String, dynamic> json) {
    return ChangePhoneNumberModel(
      message: json['message'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'phone_number': phoneNumber,
    };
  }
}