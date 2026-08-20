class OwnerImportExcelModel {
  final String message;
  final int importFileId;

  OwnerImportExcelModel({
    required this.message,
    required this.importFileId,
  });

  factory OwnerImportExcelModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OwnerImportExcelModel(
      message: json['message'] as String,
      importFileId: json['import_file_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'import_file_id': importFileId,
    };
  }
}