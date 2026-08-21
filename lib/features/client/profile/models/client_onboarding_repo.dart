import 'package:dio/dio.dart';
import 'package:smartware/core/constants/const_ip.dart';
import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/network/api_service.dart';
import 'package:smartware/core/utils/pref_helper.dart';
import 'package:smartware/features/client/profile/models/change_phone_number_model.dart';
import 'package:smartware/features/client/profile/models/client_documents_model.dart';
import 'package:smartware/features/client/profile/models/client_prefrences_model.dart';
import 'package:smartware/features/client/profile/models/client_profile_image_model.dart';
import 'package:smartware/features/client/profile/models/update_business_name_model.dart';

class ClientOnboardingRepo {
  final ApiService _api = ApiService();
  final baseUrl = 'http://${ConstIp().ip}:8000';
  Future<ClientPreferencesModel> savePreferences({
    required String facilityName,
    required String role,
    required String businessType,
    required List<String> categories,
    int? facilityId,
  }) async {
    try {
      print('');
      print('════════ SAVE PREFERENCES START ════════');
      // ================ REQUEST DATA =================

      final requestData = {
        'facility_name': facilityName,
        'role': role,
        'business_type': businessType,
        'categories': categories,
        if (facilityId != null) 'facility_id': facilityId,
      };

      print('📤 Request Data:');
      print(requestData);

      // ================= API REQUEST ===================

      final response = await _api.post(
        '$baseUrl/api/onboarding/savePreferences',
        requestData,
      );

      // =================== RAW RESPONSE ==================
      print('');
      print('📥 Raw Response:');
      print(response);

      // ============ RESPONSE VALIDATION ==============

      if (response is ApiError) {
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        throw ApiError(message: 'Invalid response from server');
      }

      // PARSE RESPONSE
      final result = ClientPreferencesModel.fromJson(response);

      // DEBUG RESPONSE
      print('');
      print('════════ PREFERENCES RESPONSE ════════');

      print('💬 Message: ${result.message}');

      print('🏢 Facility ID: ${result.facility.id}');
      // facility_name is returned at the TOP LEVEL
      print('🏢 Facility Name: ${result.facilityName}');
      print(
        '🏪 Facility Type: '
        '${result.facility.facilityType}',
      );
      print(
        '🏪 Business Type: '
        '${result.facility.businessType}',
      );
      print(
        '📊 Facility Status: '
        '${result.facility.facilityStatus}',
      );
      print(
        '📦 Categories: '
        '${result.facility.categories.map((e) => e.name).toList()}',
      );

      print('════════════════════════════════════');
      print('');
      print('════════ SAVE PREFERENCES SUCCESS ════════');

      return result;
    } on DioException catch (e) {
      print('');
      print('════════ SAVE PREFERENCES DIO ERROR ════════');
      print('❌ Status Code: ${e.response?.statusCode}');
      print('❌ Response Data: ${e.response?.data}');
      print('════════════════════════════════════════════');
      throw ApiError(
        message: e.response?.data?['message'] ?? 'Failed to save preferences',
      );
    } catch (e, stackTrace) {
      print('');
      print('════════ SAVE PREFERENCES ERROR ════════');
      print('❌ Error: $e');
      print('❌ Type: ${e.runtimeType}');
      print('❌ StackTrace:');
      print(stackTrace);
      print('════════════════════════════════════════');

      if (e is ApiError) {
        rethrow;
      }
      throw ApiError(message: 'Failed to save preferences');
    }
  }
  Future<OnboardingDocumentsResponse> uploadOnboardingDocuments({
  required int facilityId,
  required String identityDocumentPath,
  required String facilityDocumentPath,
}) async {
  try {
    print('');
    print('════════ UPLOAD DOCUMENTS START ════════');

    print('🏢 Facility ID: $facilityId');
    print('🪪 Identity Document: $identityDocumentPath');
    print('📄 Facility Document: $facilityDocumentPath');

    final formData = FormData.fromMap({
      'facility_id': facilityId,

      'identity_document': await MultipartFile.fromFile(
        identityDocumentPath,
      ),

      'facility_document': await MultipartFile.fromFile(
        facilityDocumentPath,
      ),
    });

    print('');
    print('📤 Sending onboarding documents...');

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
        OnboardingDocumentsResponse.fromJson(response);

    print('');
    print('════════ DOCUMENTS RESPONSE ════════');

    print('💬 Message: ${result.message}');

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

    print('════════════════════════════════════');
    print('');
    print('════════ UPLOAD DOCUMENTS SUCCESS ════════');

    return result;
  } on DioException catch (e) {
    print('');
    print(
      '════════ UPLOAD DOCUMENTS DIO ERROR ════════',
    );

    print('❌ Status Code: ${e.response?.statusCode}');
    print('❌ Response Data: ${e.response?.data}');

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
      message: 'Failed to upload onboarding documents',
    );
  }
  
}
//Add Client location
Future<void> submitLocation({
  required int facilityId,
  required double latitude,
  required double longitude,
  required String address,
}) async {
  try {
    print('');
    print('════════ SUBMIT LOCATION START ════════');

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
    print('📥 Location Response:');
    print(response);

    if (response is ApiError) {
      throw response;
    }

    print('════════ SUBMIT LOCATION SUCCESS ════════');
  } on DioException catch (e) {
    print('');
    print('════════ SUBMIT LOCATION DIO ERROR ════════');
    print('❌ Status Code: ${e.response?.statusCode}');
    print('❌ Response Data: ${e.response?.data}');
    print('════════════════════════════════════════');

    throw ApiError(
      message:
          e.response?.data?['message'] ??
          'Failed to save location',
    );
  } catch (e) {
    print('');
    print('❌ Submit location error: $e');

    if (e is ApiError) {
      rethrow;
    }

    throw ApiError(
      message: 'Failed to save location',
    );
  }
}
// ============================================================
// ADD / UPDATE PERSONAL IMAGE
// ============================================================

Future<ClientProfileImageModel> addOrUpdatePersonalImage({
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
        ClientProfileImageModel.fromJson(response);

    print(
      '✅ Personal image uploaded: ${result.path}',
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

// ======================= REMOVE PERSONAL IMAGE =======================
Future<ClientProfileImageModel> removePersonalImage() async {
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

    final result = ClientProfileImageModel.fromJson(response);

    print(
      '✅ Personal image removed: ${result.message}',
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

// ================== CHANGE PHONE NUMBER =================
Future<ChangePhoneNumberModel> changePhoneNumber({
  required String phoneNumber,
}) async {
  try {
    print('');
    print('════════ CHANGE PHONE NUMBER START ════════');

    print('📱 New Phone Number: $phoneNumber');

    final requestData = {
      'phone_number': phoneNumber,
    };

    print('');
    print('📤 Request Data:');
    print(requestData);

    final response = await _api.post(
      '$baseUrl/api/changePhoneNumber',
      requestData,
    );

    print('');
    print('📥 Raw Phone Number Response:');
    print(response);

    if (response is ApiError) {
      throw response;
    }

    if (response is! Map<String, dynamic>) {
      throw ApiError(
        message: 'Invalid response from server',
      );
    }
    final result = ChangePhoneNumberModel.fromJson(response);
    print('');
    print('════════ CHANGE PHONE NUMBER RESPONSE ════════');

    print('💬 Message: ${result.message}');
    print('📱 Phone Number: ${result.phoneNumber}');

    print('════════════════════════════════════════════');

    print('');
    print('════════ CHANGE PHONE NUMBER SUCCESS ════════');

    return result;
  } on DioException catch (e) {
    print('');
    print(
      '════════ CHANGE PHONE NUMBER DIO ERROR ════════',
    );

    print('❌ Status Code: ${e.response?.statusCode}');
    print('❌ Response Data: ${e.response?.data}');

    print(
      '══════════════════════════════════════════════',
    );

    throw ApiError(
      message:
          e.response?.data?['message'] ??
          'Failed to change phone number',
    );
  } catch (e, stackTrace) {
    print('');
    print(
      '════════ CHANGE PHONE NUMBER ERROR ════════',
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
      message: 'Failed to change phone number',
    );
  }
}

// ============= CHANGE CLIENT EMAIL ================
Future<void> changeEmail({
  required String email,
}) async {
  try {
    print('');
    print('════════ CHANGE EMAIL START ════════');

    final newEmail = email.trim();

    print('📧 New Email: $newEmail');

    final requestData = {
      'email': newEmail,
    };

    print('');
    print('📤 Request Data:');
    print(requestData);

    final response = await _api.post(
      '$baseUrl/api/changeEmail',
      requestData,
    );

    print('');
    print('📥 Raw Change Email Response:');
    print(response);

    if (response is ApiError) {
      throw response;
    }

    print('');
    print('════════ CHANGE EMAIL SUCCESS ════════');
  } on DioException catch (e) {
    print('');
    print('════════ CHANGE EMAIL DIO ERROR ════════');

    print('❌ Status Code: ${e.response?.statusCode}');
    print('❌ Response Data: ${e.response?.data}');

    print('════════════════════════════════════════');

    throw ApiError(
      message:
          e.response?.data?['message'] ??
          'Failed to change email',
    );
  } catch (e, stackTrace) {
    print('');
    print('════════ CHANGE EMAIL ERROR ════════');

    print('❌ Error: $e');
    print('❌ Type: ${e.runtimeType}');
    print('❌ StackTrace:');
    print(stackTrace);

    print('════════════════════════════════════');

    if (e is ApiError) {
      rethrow;
    }

    throw ApiError(
      message: 'Failed to change email',
    );
  }
}
// ============== CHANGE PASSWORD ===============
Future<void> changePassword({
  required String currentPassword,
  required String newPassword,
}) async {
  try {
    final response = await _api.post(
      '$baseUrl/api/password/change',
      {
        'current_password': currentPassword,
        'new_password': newPassword,
      },
    );

    if (response is ApiError) {
      throw response;
    }
  } on DioException catch (e) {
    throw ApiError(
      message:
          e.response?.data?['message'] ??
          'Failed to change password',
    );
  } catch (e) {
    if (e is ApiError) rethrow;

    throw ApiError(
      message: 'Failed to change password',
    );
  }
}

Future<ClientPreferencesResponseModel> getPreferences() async {
  try {
    print('');
    print('════════ GET PREFERENCES START ════════');

    final facilityId =
        await PrefHelper.getClientFacilityId();

    if (facilityId == null || facilityId <= 0) {
      throw ApiError(
        message: 'Facility information was not found.',
      );
    }

    print('🏢 Facility ID: $facilityId');

    final requestData = {
      'facility_id': facilityId,
    };

    print('📤 Request Data:');
    print(requestData);

    final response = await _api.post(
      '$baseUrl/api/onboarding/getPreferences',
      requestData,
    );

    print('');
    print('📥 Raw Preferences Response:');
    print(response);

    if (response is ApiError) {
      throw response;
    }

    if (response is! Map<String, dynamic>) {
      throw ApiError(
        message: 'Invalid response from server',
      );
    }

    final result = ClientPreferencesResponseModel.fromJson(response);

    print('');
    print('════════ PREFERENCES RESPONSE ════════');

    print(
      '📦 Preferences: '
      '${result.preferences.map((e) => e.name).toList()}',
    );

    for (final preference in result.preferences) {
      print(
        '➡️ ID: ${preference.id} | '
        'Name: ${preference.name} | '
        'Facility ID: ${preference.pivot.facilityId} | '
        'Category ID: ${preference.pivot.categoryId}',
      );
    }

    print('════════════════════════════════════');
    print('');
    print('════════ GET PREFERENCES SUCCESS ════════');

    return result;
  } on DioException catch (e) {
    print('');
    print('════════ GET PREFERENCES DIO ERROR ════════');
    print('❌ Status Code: ${e.response?.statusCode}');
    print('❌ Response Data: ${e.response?.data}');
    print('══════════════════════════════════════════');

    throw ApiError(
      message:
          e.response?.data?['message'] ??
          'Failed to get preferences',
    );
  } catch (e, stackTrace) {
    print('');
    print('════════ GET PREFERENCES ERROR ════════');
    print('❌ Error: $e');
    print('❌ Type: ${e.runtimeType}');
    print('❌ StackTrace:');
    print(stackTrace);
    print('══════════════════════════════════════');

    if (e is ApiError) {
      rethrow;
    }

    throw ApiError(
      message: 'Failed to get preferences',
    );
  }
}
// ============================================================
// UPDATE BUSINESS NAME
// ============================================================

Future<UpdateBusinessNameModel> updateBusinessName({
  required String businessName,
  required int facilityId,
}) async {
  try {
    print('');
    print('════════ UPDATE BUSINESS NAME START ════════');

    final data = {
      'business_name': businessName,
      'facility_id': facilityId,
    };

    print('📤 Request Data: $data');

    final response = await _api.post(
      '$baseUrl/api/editBusinessName',
      data,
    );

    print('');
    print('📥 Raw Business Name Response:');
    print(response);

    // ApiService already returns the response body.
    if (response is ApiError) {
      throw response;
    }

    if (response is! Map<String, dynamic>) {
      throw ApiError(
        message: 'Invalid response from server',
      );
    }

    final result = UpdateBusinessNameModel.fromJson(
      response,
    );

    print('');
    print('════════ BUSINESS NAME RESPONSE ════════');

    print('💬 Message: ${result.message}');

    print(
      '🏢 Facility ID: '
      '${result.facility.id}',
    );

    print(
      '🏢 Updated Business Name: '
      '${result.facility.facilityNameEn}',
    );

    print(
      '════════════════════════════════════════',
    );

    print('');
    print(
      '════════ UPDATE BUSINESS NAME SUCCESS ════════',
    );

    return result;
  } on DioException catch (e) {
    print('');
    print(
      '════════ UPDATE BUSINESS NAME DIO ERROR ════════',
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
          'Failed to update business name',
    );
  } catch (e, stackTrace) {
    print('');
    print(
      '════════ UPDATE BUSINESS NAME ERROR ════════',
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
      message: 'Failed to update business name',
    );
  }
}
}
