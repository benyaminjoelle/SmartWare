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
      print('════════ GET OWNER WAREHOUSES ════════');

      final response = await _api.get(
        '$baseUrl/api/home_page/ownedFacilities',
      );

      print('📥 Raw Response:');
      print(response);

      if (response is ApiError) {
        throw response;
      }

      if (response is! List) {
        throw ApiError(
          message: 'Invalid warehouses response',
        );
      }

      final result = response
          .map(
            (item) => WarehouseModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList();

      print('🏢 Owner Warehouses: ${result.length}');

      for (final warehouse in result) {
        print(
          '🏢 ${warehouse.nameEn} '
          '| ID: ${warehouse.id} '
          '| Type: ${warehouse.type} '
          '| Status: ${warehouse.status}',
        );
      }

      print('════════════════════════════════════');

      return result;
    } on DioException catch (e) {
      print('');
      print('════════ OWNER WAREHOUSES DIO ERROR ════════');
      print('❌ Status Code: ${e.response?.statusCode}');
      print('❌ Response Data: ${e.response?.data}');
      print('════════════════════════════════════════');

      final data = e.response?.data;

      String message = 'Failed to load warehouses';

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
      print('════════ OWNER WAREHOUSES ERROR ════════');
      print('❌ Error: $e');
      print('❌ Type: ${e.runtimeType}');
      print('❌ StackTrace: $stackTrace');
      print('════════════════════════════════════');

      if (e is ApiError) {
        rethrow;
      }

      throw ApiError(
        message: 'Failed to load warehouses',
      );
    }
  }
}