class ClientProfileImageModel {
  final String message;
  final String path;

  ClientProfileImageModel({
    required this.message,
    required this.path,
  });

  factory ClientProfileImageModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClientProfileImageModel(
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