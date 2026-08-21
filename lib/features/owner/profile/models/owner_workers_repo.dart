import 'package:dio/dio.dart';

import 'package:smartware/core/constants/const_ip.dart';
import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/network/api_service.dart';

import 'package:smartware/features/owner/profile/models/announce_worker_model.dart';

class OwnerWorkersRepo {
  final ApiService _api = ApiService();

  final baseUrl = 'http://${ConstIp().ip}:8000';

  // ============================================================
  // ANNOUNCE WORKER
  // ============================================================

  Future<AnnounceWorkerResponse> announceWorker({
    required String firstName,
    required String lastName,
    required String nationalId,
    required int facilityId,
  }) async {
    try {
      print('');
      print(
        '════════ ANNOUNCE WORKER START ════════',
      );

      final requestData = {
        'first_name': firstName.trim(),
        'last_name': lastName.trim(),
        'national_id': nationalId.trim(),
        'facility_id': facilityId,
      };

      print('📤 Request Data:');
      print(requestData);

      final response = await _api.post(
        '$baseUrl/api/warehouse_manager/announceWorker',
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
          AnnounceWorkerResponse.fromJson(response);

      print('');
      print(
        '════════ ANNOUNCE WORKER RESPONSE ════════',
      );

      print(
        '💬 Message: ${result.message}',
      );

      print(
        '🆔 Worker ID: ${result.data.id}',
      );

      print(
        '👤 Name: '
        '${result.data.firstName} '
        '${result.data.lastName}',
      );

      print(
        '🪪 National ID: '
        '${result.data.nationalId}',
      );

      print(
        '🏢 Employment Warehouse ID: '
        '${result.data.employmentWarehouseId}',
      );

      print(
        '👨‍💼 Manager ID: '
        '${result.data.managerId}',
      );

      print(
        '📌 Claimed: '
        '${result.data.claimed}',
      );

      print(
        '════════════════════════════════════════',
      );

      return result;
    } on DioException catch (e) {
      print('');
      print(
        '════════ ANNOUNCE WORKER DIO ERROR ════════',
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
        '════════════════════════════════════════',
      );

      final data = e.response?.data;

      String message =
          'Failed to announce worker';

      if (data is Map<String, dynamic>) {
        if (data['error'] != null) {
          message = data['error'].toString();
        } else if (data['message'] != null) {
          message = data['message'].toString();
        }
      }

      throw ApiError(
        message: message,
      );
    } catch (e, stackTrace) {
      print('');
      print(
        '════════ ANNOUNCE WORKER ERROR ════════',
      );

      print(
        '❌ Error: $e',
      );

      print(
        '❌ Type: ${e.runtimeType}',
      );

      print('❌ StackTrace:');
      print(stackTrace);

      print(
        '════════════════════════════════════════',
      );

      if (e is ApiError) {
        rethrow;
      }

      throw ApiError(
        message: 'Failed to announce worker',
      );
    }
  }
}