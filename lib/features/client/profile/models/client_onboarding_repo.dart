import 'package:dio/dio.dart';

import 'package:smartware/core/constants/const_ip.dart';
import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/network/api_service.dart';
import 'package:smartware/features/client/profile/models/client_prefrences_model.dart';

class ClientOnboardingRepo {
  final ApiService _api = ApiService();

  final baseUrl = 'http://${ConstIp().ip}:8000';

  Future<ClientPreferencesModel> savePreferences({
    required String facilityName,
    required String role,
    required String businessType,
    required List<String> categories,
  }) async {
    try {
      print('');
      print('════════ SAVE PREFERENCES START ════════');

      final requestData = {
        'facility_name': facilityName,
        'role': role,
        'business_type': businessType,
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

      final result =
          ClientPreferencesModel.fromJson(response);

      print('');
      print('════════ PREFERENCES RESPONSE ════════');
      print('💬 Message: ${result.message}');
      print('🏢 Facility ID: ${result.facility.id}');
      print(
        '🏢 Facility Name: '
        '${result.facility.facilityName}',
      );
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
      print(
        '════════ SAVE PREFERENCES DIO ERROR ════════',
      );
      print('❌ Status Code: ${e.response?.statusCode}');
      print('❌ Response Data: ${e.response?.data}');
      print(
        '════════════════════════════════════════════',
      );

      throw ApiError(
        message:
            e.response?.data?['message'] ??
            'Failed to save preferences',
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

      throw ApiError(
        message: 'Failed to save preferences',
      );
    }
  }
}