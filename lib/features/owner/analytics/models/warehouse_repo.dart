import 'package:dio/dio.dart';

import 'package:smartware/core/constants/const_ip.dart';
import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/network/api_service.dart';

import 'package:smartware/features/owner/analytics/models/slow_moving_products.dart';
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
              Map<String, dynamic>.from(item),
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

  // ============================================================
  // GET SLOW MOVING PRODUCTS
  // ============================================================

  Future<List<SlowMovingProductModel>> getSlowMovingProducts({
    required int facilityId,
  }) async {
    try {
      print('');
      print('════════ GET SLOW MOVING PRODUCTS ════════');
      print('🏢 Facility ID: $facilityId');

      final response = await _api.get(
        '$baseUrl/api/home_page/slowMovingProduct$facilityId',
      );

      print('');
      print('📥 Raw Slow Moving Products Response:');
      print(response);

      if (response is ApiError) {
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        throw ApiError(
          message: 'Invalid slow moving products response',
        );
      }

      final data = response['data'];

      if (data is! List) {
        throw ApiError(
          message: 'Invalid slow moving products data',
        );
      }

      final result = data
          .map(
            (item) => SlowMovingProductModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();

      print('');
      print('════════ SLOW MOVING PRODUCTS ════════');
      print('📦 Total Products: ${result.length}');

      for (final product in result) {
        print(
          '📦 ${product.nameEn} '
          '| ID: ${product.id} '
          '| SKU: ${product.sku} '
          '| Unit: ${product.unit} '
          '| Total Sold: ${product.totalSold}',
        );
      }

      print('════════════════════════════════════');

      return result;
    } on DioException catch (e) {
      print('');
      print('════════ SLOW MOVING PRODUCTS DIO ERROR ════════');
      print('❌ Status Code: ${e.response?.statusCode}');
      print('❌ Response Data: ${e.response?.data}');
      print('════════════════════════════════════════════');

      final data = e.response?.data;

      String message = 'Failed to load slow moving products';

      if (data is Map<String, dynamic>) {
        if (data['message'] != null) {
          message = data['message'].toString();
        }

        if (data['errors'] is Map) {
          final errors = data['errors'] as Map;

          if (errors.isNotEmpty) {
            final firstError = errors.values.first;

            if (firstError is List &&
                firstError.isNotEmpty) {
              message = firstError.first.toString();
            }
          }
        }
      }

      throw ApiError(message: message);
    } catch (e, stackTrace) {
      print('');
      print('════════ SLOW MOVING PRODUCTS ERROR ════════');
      print('❌ Error: $e');
      print('❌ Type: ${e.runtimeType}');
      print('❌ StackTrace: $stackTrace');
      print('════════════════════════════════════════');

      if (e is ApiError) {
        rethrow;
      }

      throw ApiError(
        message: 'Failed to load slow moving products',
      );
    }
  }
}