class OnboardingDocumentsResponse {
  final String message;
  final OnboardingDocumentsModel documents;

  OnboardingDocumentsResponse({
    required this.message,
    required this.documents,
  });

  factory OnboardingDocumentsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return OnboardingDocumentsResponse(
      message: json['message'] ?? '',
      documents: OnboardingDocumentsModel.fromJson(
        json['documents'] ?? {},
      ),
    );
  }
}

class OnboardingDocumentsModel {
  final OnboardingDocumentModel identityDocument;
  final OnboardingDocumentModel facilityDocument;

  OnboardingDocumentsModel({
    required this.identityDocument,
    required this.facilityDocument,
  });

  factory OnboardingDocumentsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OnboardingDocumentsModel(
      identityDocument: OnboardingDocumentModel.fromJson(
        json['identity_document'] ?? {},
      ),
      facilityDocument: OnboardingDocumentModel.fromJson(
        json['facility_document'] ?? {},
      ),
    );
  }
}

class OnboardingDocumentModel {
  final int userId;
  final int? facilityId;
  final String documentFile;
  final String? documentType;
  final String status;
  final String updatedAt;
  final String createdAt;
  final int id;

  OnboardingDocumentModel({
    required this.userId,
    required this.facilityId,
    required this.documentFile,
    required this.documentType,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory OnboardingDocumentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OnboardingDocumentModel(
      userId: json['user_id'] ?? 0,
      facilityId: json['facility_id'],
      documentFile: json['document_file'] ?? '',
      documentType: json['document_type'],
      status: json['status'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      id: json['id'] ?? 0,
    );
  }
}