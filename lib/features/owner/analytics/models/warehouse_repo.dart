import 'package:dio/dio.dart';

import 'package:smartware/core/constants/const_ip.dart';
import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/network/api_service.dart';

import 'package:smartware/features/owner/analytics/models/warehouse_model.dart';

class OwnerAnalyticsRepo {
  final ApiService _api = ApiService();

  final baseUrl = 'http://${ConstIp().ip}:8000';

  // ============================================================
  // GET OWNER WAREHOUSES
  // ============================================================

  Future<List<WarehouseModel>> getWarehouses() async {
    try {
      print('');
      print(
        '════════ GET OWNER WAREHOUSES START ════════',
      );

      final response = await _api.get(
        '$baseUrl/api/facilities/warehouses',
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

      final data = response['data'];

      if (data is! List) {
        throw ApiError(
          message: 'Invalid warehouses data',
        );
      }

      final result = data
          .map(
            (item) => WarehouseModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList();

      print('');
      print(
        '════════ OWNER WAREHOUSES RESPONSE ════════',
      );

      print(
        '🏢 Total Warehouses: ${result.length}',
      );

      for (final warehouse in result) {
        print(
          '🏢 ${warehouse.name} '
          '| Type: ${warehouse.type} '
          '| Status: ${warehouse.status} '
          '| Owner ID: ${warehouse.ownerId} '
          '| Address ID: ${warehouse.addressId}',
        );
      }

      print(
        '════════════════════════════════════════',
      );

      return result;
    } on DioException catch (e) {
      print('');
      print(
        '════════ OWNER WAREHOUSES DIO ERROR ════════',
      );

      print(
        '❌ Status Code: ${e.response?.statusCode}',
      );

      print(
        '❌ Response Data: ${e.response?.data}',
      );

      print(
        '════════════════════════════════════════',
      );

      final data = e.response?.data;

      String message = 'Failed to load warehouses';

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
        '════════ OWNER WAREHOUSES ERROR ════════',
      );

      print('❌ Error: $e');
      print('❌ Type: ${e.runtimeType}');
      print('❌ StackTrace: $stackTrace');

      print(
        '════════════════════════════════════',
      );

      if (e is ApiError) {
        rethrow;
      }

      throw ApiError(
        message: 'Failed to load warehouses',
      );
    }
  }
}