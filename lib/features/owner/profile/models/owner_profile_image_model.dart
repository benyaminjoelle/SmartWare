class OwnerProfileImageModel {
  final String message;
  final String path;

  OwnerProfileImageModel({
    required this.message,
    required this.path,
  });

  factory OwnerProfileImageModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OwnerProfileImageModel(
      message: json['message']?.toString() ?? '',
      path: json['path']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'path': path,
    };
  }
}