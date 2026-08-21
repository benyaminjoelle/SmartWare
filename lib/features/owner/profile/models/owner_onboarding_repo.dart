import 'dart:io';

import 'package:dio/dio.dart';

import 'package:smartware/core/constants/const_ip.dart';
import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/network/api_service.dart';

import 'package:smartware/features/owner/profile/models/owner_documents_model.dart';
import 'package:smartware/features/owner/profile/models/change_phone_number_model.dart';
import 'package:smartware/features/owner/profile/models/update_business_name_model.dart';
import 'package:smartware/features/owner/profile/models/owner_prefrences_model.dart';
import 'package:smartware/features/owner/profile/models/owner_profile_image_model.dart';
import 'package:smartware/features/owner/profile/models/owner_import_excel_model.dart';

class OwnerOnboardingRepo {
  final ApiService _api = ApiService();

  final baseUrl = 'http://${ConstIp().ip}:8000';

  // ============================================================
  // SAVE OWNER PREFERENCES
  // ============================================================
Future<OwnerPrefrencesModel> savePreferences({
  required String facilityName,
  required String role,
  required List<String> categories,
}) async {
  try {
    print('');
    print('════════ SAVE OWNER PREFERENCES START ════════');

    final requestData = {
      'facility_name': facilityName,
      'role': role,
      'categories': categories,
    };

    print('📤 Request Data:');
    print(requestData);

    final response = await _api.post(
      '$baseUrl/api/onboarding/savePreferences',
      requestData,
    );

    print('');
    print('📥 Raw Response:');
    print(response);

    if (response is ApiError) {
      throw response;
    }

    if (response is! Map<String, dynamic>) {
      throw ApiError(
        message: 'Invalid response from server',
      );
    }

    final result = OwnerPrefrencesModel.fromJson(response);

    print('');
    print('════════ OWNER PREFERENCES RESPONSE ════════');
    print('💬 Message: ${result.message}');
    print('🏢 Facility ID: ${result.facility.id}');
    print('🏢 Facility Name: ${result.facilityName}');
    print('🏪 Business Type: ${result.facility.businessType}');
    print(
      '📦 Categories: ${result.facility.categories.map((e) => e.name).toList()}',
    );
    print('════════════════════════════════════════');

    return result;
  } on DioException catch (e) {
    print('');
    print('════════ SAVE OWNER PREFERENCES DIO ERROR ════════');
    print('❌ Status Code: ${e.response?.statusCode}');
    print('❌ Response Data: ${e.response?.data}');
    print('════════════════════════════════════════════════');

    final data = e.response?.data;

    String message = 'Failed to save owner preferences';

    if (data is Map<String, dynamic>) {
      if (data['error'] != null) {
        message = data['error'].toString();
      } else if (data['message'] != null) {
        message = data['message'].toString();
      }
    }

    throw ApiError(message: message);
  } catch (e, stackTrace) {
    print('');
    print('════════ SAVE OWNER PREFERENCES ERROR ════════');
    print('❌ Error: $e');
    print('❌ Type: ${e.runtimeType}');
    print('❌ StackTrace:');
    print(stackTrace);
    print('════════════════════════════════════════');

    if (e is ApiError) {
      rethrow;
    }

    throw ApiError(
      message: 'Failed to save owner preferences',
    );
  }
}
  // ============================================================
  // UPLOAD ONBOARDING DOCUMENTS
  // ============================================================

  Future<OnboardingDocumentsResponse>
      uploadOnboardingDocuments({
    required int facilityId,
    required String identityDocumentPath,
    required String facilityDocumentPath,
  }) async {
    try {
      print('');
      print('════════ UPLOAD DOCUMENTS START ════════');

      print('🏢 Facility ID: $facilityId');
      print(
        '🪪 Identity Document: '
        '$identityDocumentPath',
      );
      print(
        '📄 Facility Document: '
        '$facilityDocumentPath',
      );

      final formData = FormData.fromMap({
        'facility_id': facilityId,

        'identity_document':
            await MultipartFile.fromFile(
          identityDocumentPath,
        ),

        'facility_document':
            await MultipartFile.fromFile(
          facilityDocumentPath,
        ),
      });

      final response = await _api.post(
        '$baseUrl/api/onboarding/uploadOnboardingDocuments',
        formData,
      );

      print('');
      print('📥 Raw Documents Response:');
      print(response);

      if (response is ApiError) {
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        throw ApiError(
          message: 'Invalid response from server',
        );
      }

      final result =
          OnboardingDocumentsResponse.fromJson(
        response,
      );

      print('');
      print('════════ DOCUMENTS RESPONSE ════════');

      print(
        '💬 Message: ${result.message}',
      );

      print('');
      print('🪪 IDENTITY DOCUMENT');

      print(
        '🆔 ID: '
        '${result.documents.identityDocument.id}',
      );

      print(
        '👤 User ID: '
        '${result.documents.identityDocument.userId}',
      );

      print(
        '🏢 Facility ID: '
        '${result.documents.identityDocument.facilityId}',
      );

      print(
        '📄 File: '
        '${result.documents.identityDocument.documentFile}',
      );

      print(
        '📊 Status: '
        '${result.documents.identityDocument.status}',
      );

      print('');
      print('📄 FACILITY DOCUMENT');

      print(
        '🆔 ID: '
        '${result.documents.facilityDocument.id}',
      );

      print(
        '👤 User ID: '
        '${result.documents.facilityDocument.userId}',
      );

      print(
        '🏢 Facility ID: '
        '${result.documents.facilityDocument.facilityId}',
      );

      print(
        '📄 File: '
        '${result.documents.facilityDocument.documentFile}',
      );

      print(
        '📊 Status: '
        '${result.documents.facilityDocument.status}',
      );

      print(
        '════════════════════════════════════',
      );

      return result;
    } on DioException catch (e) {
      print('');
      print(
        '════════ UPLOAD DOCUMENTS DIO ERROR ════════',
      );

      print(
        '❌ Status Code: '
        '${e.response?.statusCode}',
      );

      print(
        '❌ Response Data: '
        '${e.response?.data}',
      );

      print(
        '════════════════════════════════════════════',
      );

      throw ApiError(
        message:
            e.response?.data?['message'] ??
            'Failed to upload onboarding documents',
      );
    } catch (e, stackTrace) {
      print('');
      print(
        '════════ UPLOAD DOCUMENTS ERROR ════════',
      );

      print('❌ Error: $e');
      print('❌ Type: ${e.runtimeType}');
      print('❌ StackTrace:');
      print(stackTrace);

      print(
        '════════════════════════════════════════',
      );

      if (e is ApiError) {
        rethrow;
      }

      throw ApiError(
        message:
            'Failed to upload onboarding documents',
      );
    }
  }

  // ============================================================
  // ADD / UPDATE PERSONAL IMAGE
  // ============================================================

  Future<OwnerProfileImageModel>
      addOrUpdatePersonalImage({
    required String imagePath,
  }) async {
    try {
      print('📸 Uploading personal image...');

      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imagePath,
        ),
      });

      final response = await _api.post(
        '$baseUrl/api/addOrUpdatePersonalImage',
        formData,
      );

      if (response is ApiError) {
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        throw ApiError(
          message: 'Invalid response from server',
        );
      }

      final result =
          OwnerProfileImageModel.fromJson(
        response,
      );

      print(
        '✅ Personal image uploaded: '
        '${result.path}',
      );

      return result;
    } on DioException catch (e) {
      print(
        '❌ Personal image upload failed: '
        '${e.response?.data}',
      );

      throw ApiError(
        message:
            e.response?.data?['message'] ??
            'Failed to upload personal image',
      );
    } catch (e) {
      print(
        '❌ Personal image upload error: $e',
      );

      if (e is ApiError) {
        rethrow;
      }

      throw ApiError(
        message: 'Failed to upload personal image',
      );
    }
  }

  // ============================================================
  // REMOVE PERSONAL IMAGE
  // ============================================================

  Future<OwnerProfileImageModel>
      removePersonalImage() async {
    try {
      print('🗑️ Removing personal image...');

      final response = await _api.delete(
        '$baseUrl/api/removePersonalImage',
      );

      if (response is ApiError) {
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        throw ApiError(
          message: 'Invalid response from server',
        );
      }

      final result =
          OwnerProfileImageModel.fromJson(
        response,
      );

      print(
        '✅ Personal image removed: '
        '${result.message}',
      );

      return result;
    } on DioException catch (e) {
      print(
        '❌ Personal image removal failed: '
        '${e.response?.data}',
      );

      throw ApiError(
        message:
            e.response?.data?['message'] ??
            'Failed to remove personal image',
      );
    } catch (e) {
      print(
        '❌ Personal image removal error: $e',
      );

      if (e is ApiError) {
        rethrow;
      }

      throw ApiError(
        message: 'Failed to remove personal image',
      );
    }
  }

  // ============================================================
  // CHANGE PHONE NUMBER
  // ============================================================

  Future<ChangePhoneNumberModel>
      changePhoneNumber({
    required String phoneNumber,
  }) async {
    try {
      print('');
      print(
        '════════ CHANGE PHONE NUMBER START ════════',
      );

      final requestData = {
        'phone_number': phoneNumber,
      };

      print('📤 Request Data: $requestData');

      final response = await _api.post(
        '$baseUrl/api/changePhoneNumber',
        requestData,
      );

      print('📥 Raw Response:');
      print(response);

      if (response is ApiError) {
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        throw ApiError(
          message: 'Invalid response from server',
        );
      }

      final result =
          ChangePhoneNumberModel.fromJson(
        response,
      );

      print(
        '💬 Message: ${result.message}',
      );

      print(
        '📱 Phone Number: '
        '${result.phoneNumber}',
      );

      return result;
    } on DioException catch (e) {
      throw ApiError(
        message:
            e.response?.data?['message'] ??
            'Failed to change phone number',
      );
    } catch (e, stackTrace) {
      print('❌ Error: $e');
      print(stackTrace);

      if (e is ApiError) {
        rethrow;
      }

      throw ApiError(
        message: 'Failed to change phone number',
      );
    }
  }
  // ============================================================
// CHANGE PASSWORD
// ============================================================

Future<void> changePassword({
  required String currentPassword,
  required String newPassword,
}) async {
  try {
    print('');
    print('════════ CHANGE OWNER PASSWORD START ════════');

    final requestData = {
      'current_password': currentPassword,
      'new_password': newPassword,
    };

    print('📤 Request Data:');
    print({
      'current_password': '********',
      'new_password': '********',
    });

    final response = await _api.post(
      '$baseUrl/api/changePassword',
      requestData,
    );

    print('');
    print('📥 Raw Password Response:');
    print(response);

    if (response is ApiError) {
      throw response;
    }

    if (response is! Map<String, dynamic>) {
      throw ApiError(
        message: 'Invalid response from server',
      );
    }

    final message = response['message']?.toString() ??
        'Password changed successfully';

    print('💬 Message: $message');
    print('✅ OWNER PASSWORD CHANGE SUCCESS');
    print('════════════════════════════════════════');

  } on DioException catch (e) {
    print('');
    print('════════ CHANGE OWNER PASSWORD DIO ERROR ════════');

    print('❌ Status Code: ${e.response?.statusCode}');
    print('❌ Response Data: ${e.response?.data}');

    final data = e.response?.data;

    String message = 'Failed to change password';

    if (data is Map<String, dynamic>) {
      if (data['message'] != null) {
        message = data['message'].toString();
      } else if (data['error'] != null) {
        message = data['error'].toString();
      }
    }

    throw ApiError(message: message);

  } catch (e, stackTrace) {
    print('');
    print('════════ CHANGE OWNER PASSWORD ERROR ════════');

    print('❌ Error: $e');
    print('❌ Type: ${e.runtimeType}');
    print('❌ StackTrace:');
    print(stackTrace);

    if (e is ApiError) {
      rethrow;
    }

    throw ApiError(
      message: 'Failed to change password',
    );
  }
}

  // ============================================================
  // UPDATE BUSINESS NAME
  // ============================================================
  //
  // This is kept because it is a PROFILE feature.
  // It is NOT part of owner onboarding preferences.
  //
  // ============================================================

  Future<UpdateBusinessNameModel>
      updateBusinessName({
    required String businessName,
    required int facilityId,
  }) async {
    try {
      print('');
      print(
        '════════ UPDATE BUSINESS NAME START ════════',
      );

      final data = {
        'business_name': businessName,
        'facility_id': facilityId,
      };

      print('📤 Request Data: $data');

      final response = await _api.post(
        '$baseUrl/api/editBusinessName',
        data,
      );

      print('📥 Raw Response:');
      print(response);

      if (response is ApiError) {
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        throw ApiError(
          message: 'Invalid response from server',
        );
      }

      final result =
          UpdateBusinessNameModel.fromJson(
        response,
      );

      print(
        '💬 Message: ${result.message}',
      );

      print(
        '🏢 Facility ID: '
        '${result.facility.id}',
      );

      print(
        '🏢 Updated Business Name: '
        '${result.facility.facilityNameEn}',
      );

      return result;
    } on DioException catch (e) {
      throw ApiError(
        message:
            e.response?.data?['message'] ??
            'Failed to update business name',
      );
    } catch (e, stackTrace) {
      print('❌ Error: $e');
      print(stackTrace);

      if (e is ApiError) {
        rethrow;
      }

      throw ApiError(
        message: 'Failed to update business name',
      );
    }
  }
  //Locatio
  Future<void> submitLocation({
  required int facilityId,
  required double latitude,
  required double longitude,
  required String address,
}) async {
  try {
    print('');
    print('════════ OWNER SUBMIT LOCATION START ════════');

    final requestData = {
      'facility_id': facilityId,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };

    print('📤 Request Data:');
    print(requestData);

    final response = await _api.post(
      '$baseUrl/api/onboarding/submitLocation',
      requestData,
    );

    print('');
    print('📥 Owner Location Response:');
    print(response);

    if (response is ApiError) {
      throw response;
    }

    print('════════ OWNER LOCATION SUCCESS ════════');
  } on DioException catch (e) {
    print('');
    print('════════ OWNER LOCATION DIO ERROR ════════');
    print('❌ Status Code: ${e.response?.statusCode}');
    print('❌ Response Data: ${e.response?.data}');
    print('════════════════════════════════════════');

    throw ApiError(
      message:
          e.response?.data?['message'] ??
          'Failed to save location',
    );
  } catch (e) {
    print('❌ Submit owner location error: $e');

    if (e is ApiError) {
      rethrow;
    }

    throw ApiError(
      message: 'Failed to save location',
    );
  }
}
  // ============================================================
// IMPORT INVENTORY EXCEL FILE
// ============================================================

Future<OwnerImportExcelModel> importInventoryExcel({
  required int facilityId,
  required int sectionId,
  required String excelFilePath,
}) async {
  try {
    print('');
    print('════════ IMPORT INVENTORY EXCEL START ════════');
    print('🏢 Facility ID: $facilityId');
    print('📦 Section ID: $sectionId');
    print('📄 Excel File: $excelFilePath');

    final file = File(excelFilePath);

    if (!await file.exists()) {
      throw ApiError(
        message: 'Selected inventory file does not exist.',
      );
    }

    final formData = FormData.fromMap({
      'facility_id': facilityId,
      'section_id': sectionId,

      // IMPORTANT:
      // Backend expects "file", NOT "excel_file"
      'file': await MultipartFile.fromFile(
        excelFilePath,
        filename: file.path.split(Platform.pathSeparator).last,
      ),
    });

    print('');
    print('📤 Sending inventory Excel file...');
    print('📦 Form fields:');
    print('   facility_id: $facilityId');
    print('   section_id: $sectionId');
    print('   file: ${file.path}');

    final response = await _api.post(
      '$baseUrl/api/import-excel',
      formData,
    );

    print('');
    print('📥 Raw Import Response:');
    print(response);

    if (response is ApiError) {
      throw response;
    }

    if (response is! Map<String, dynamic>) {
      throw ApiError(
        message: 'Invalid response from server.',
      );
    }

    final result =
        OwnerImportExcelModel.fromJson(response);

    print('');
    print('════════ INVENTORY IMPORT SUCCESS ════════');
    print('💬 Message: ${result.message}');
    print('📁 Import File ID: ${result.importFileId}');
    print('════════════════════════════════════════');

    return result;
  } on DioException catch (e) {
    print('');
    print('════════ IMPORT INVENTORY DIO ERROR ════════');
    print('❌ Status Code: ${e.response?.statusCode}');
    print('❌ Response Data: ${e.response?.data}');
    print('════════════════════════════════════════');

    final data = e.response?.data;

    String message = 'Failed to import inventory file.';

    if (data is Map<String, dynamic>) {
      if (data['message'] != null) {
        message = data['message'].toString();
      }

      if (data['errors'] != null) {
        print('❌ Validation Errors: ${data['errors']}');
      }
    }

    throw ApiError(
      message: message,
    );
  } catch (e, stackTrace) {
    print('');
    print('════════ IMPORT INVENTORY ERROR ════════');
    print('❌ Error: $e');
    print('❌ Type: ${e.runtimeType}');
    print('❌ StackTrace:');
    print(stackTrace);
    print('════════════════════════════════════════');

    if (e is ApiError) {
      rethrow;
    }

    throw ApiError(
      message: 'Failed to import inventory file.',
    );
  }
}
}