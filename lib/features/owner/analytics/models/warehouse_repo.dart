import 'package:dio/dio.dart';

import 'package:smartware/core/constants/const_ip.dart';
import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/network/api_service.dart';

import 'package:smartware/features/owner/analytics/models/slow_moving_products.dart';
import 'package:smartware/features/owner/analytics/models/top_moving_products.dart';
import 'package:smartware/features/owner/analytics/models/warehouse_model.dart';

class OwnerAnalyticsRepo {
  final ApiService _api = ApiService();

  final baseUrl = 'http://${ConstIp().ip}:8000';

  // ============================================================
  // GET OWNER WAREHOUSES
  // ============================================================

  Future<List<WarehouseModel>> getWarehouses() async {
    try {
      final response = await _api.get('$baseUrl/api/home_page/ownedFacilities');

      if (response is ApiError) {
        throw response;
      }

      if (response is! List) {
        throw ApiError(message: 'Invalid warehouses response');
      }

      return response
          .map(
            (item) => WarehouseModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    } on DioException catch (e) {
      print('❌ Warehouses Dio Error: ${e.response?.data}');

      final data = e.response?.data;

      String message = 'Failed to load warehouses';

      if (data is Map<String, dynamic>) {
        message =
            data['message']?.toString() ?? data['error']?.toString() ?? message;
      }

      throw ApiError(message: message);
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }

      throw ApiError(message: 'Failed to load warehouses');
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

      print('📥 Slow Moving Response:');
      print(response);

      if (response is ApiError) {
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        throw ApiError(message: 'Invalid slow moving products response');
      }

      final data = response['data'];

      if (data is! List) {
        throw ApiError(message: 'Invalid slow moving products data');
      }

      final result = data
          .map(
            (item) => SlowMovingProductModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();

      print('📦 Slow moving products: ${result.length}');

      return result;
    } on DioException catch (e) {
      print(
        '❌ Slow moving Dio error: '
        '${e.response?.statusCode}',
      );

      print(e.response?.data);

      final data = e.response?.data;

      String message = 'Failed to load slow moving products';

      if (data is Map<String, dynamic>) {
        message = data['message']?.toString() ?? message;
      }

      throw ApiError(message: message);
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }

      throw ApiError(message: 'Failed to load slow moving products');
    }
  }

  // ============================================================
  // GET STOCK OUT RISK PRODUCTS
  // ============================================================

  Future<List<StockOutRiskProduct>> getStockOutRisk({
    required int facilityId,
  }) async {
    try {
      print('');
      print('════════ GET STOCK OUT RISK ════════');
      print('🏢 Facility ID: $facilityId');

      final response = await _api.get(
        '$baseUrl/api/home_page/stockOutRisk$facilityId',
      );

      print('');
      print('📥 Stock Out Risk Response:');
      print(response);

      if (response is ApiError) {
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        throw ApiError(message: 'Invalid stock out risk response');
      }

      final data = response['data'];

      if (data is! List) {
        throw ApiError(message: 'Invalid stock out risk data');
      }

      final result = data
          .map(
            (item) =>
                StockOutRiskProduct.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();

      print('⚠️ Stock out risk products: ${result.length}');

      return result;
    } on DioException catch (e) {
      print(
        '❌ Stock out risk Dio error: '
        '${e.response?.statusCode}',
      );

      print(e.response?.data);

      final data = e.response?.data;

      String message = 'Failed to load stock out risk products';

      if (data is Map<String, dynamic>) {
        message = data['message']?.toString() ?? message;
      }

      throw ApiError(message: message);
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }

      throw ApiError(message: 'Failed to load stock out risk products');
    }
  }
  // ============================================================
  // GET TOP MOVING PRODUCTS
  // ============================================================

  Future<List<TopMovingProductModel>> getTopMovingProducts({
    required int facilityId,
  }) async {
    try {
      print('');
      print('════════ GET TOP MOVING PRODUCTS ════════');
      print('🏢 Facility ID: $facilityId');

      final response = await _api.get(
        '$baseUrl/api/home_page/topMovingProduct$facilityId',
      );

      print('');
      print('📥 Raw Top Moving Products Response:');
      print(response);

      if (response is ApiError) {
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        throw ApiError(message: 'Invalid top moving products response');
      }

      final data = response['data'];

      if (data is! List) {
        throw ApiError(message: 'Invalid top moving products data');
      }

      final result = data
          .map(
            (item) =>
                TopMovingProductModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();

      print('');
      print('════════ TOP MOVING PRODUCTS ════════');
      print('📦 Total Products: ${result.length}');

      for (final product in result) {
        print(
          '📦 ${product.nameEn.isNotEmpty ? product.nameEn : product.nameAr} '
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
      print('════════ TOP MOVING PRODUCTS DIO ERROR ════════');
      print('❌ Status Code: ${e.response?.statusCode}');
      print('❌ Response Data: ${e.response?.data}');
      print('════════════════════════════════════════════');

      final data = e.response?.data;

      String message = 'Failed to load top moving products';

      if (data is Map<String, dynamic>) {
        if (data['message'] != null) {
          message = data['message'].toString();
        }

        if (data['errors'] is Map) {
          final errors = data['errors'] as Map;

          if (errors.isNotEmpty) {
            final firstError = errors.values.first;

            if (firstError is List && firstError.isNotEmpty) {
              message = firstError.first.toString();
            }
          }
        }
      }

      throw ApiError(message: message);
    } catch (e, stackTrace) {
      print('');
      print('════════ TOP MOVING PRODUCTS ERROR ════════');
      print('❌ Error: $e');
      print('❌ Type: ${e.runtimeType}');
      print('❌ StackTrace: $stackTrace');
      print('════════════════════════════════════════');

      if (e is ApiError) {
        rethrow;
      }

      throw ApiError(message: 'Failed to load top moving products');
    }
  }

  
}

// ============================================================================
// STOCK OUT RISK MODEL
// ============================================================================

class StockOutRiskProduct {
  final int id;
  final String sku;
  final String? nameEn;
  final String? nameAr;
  final String unit;
  final int warehouseQuantity;

  StockOutRiskProduct({
    required this.id,
    required this.sku,
    required this.nameEn,
    required this.nameAr,
    required this.unit,
    required this.warehouseQuantity,
  });

  factory StockOutRiskProduct.fromJson(Map<String, dynamic> json) {
    return StockOutRiskProduct(
      id: json['id'] ?? 0,
      sku: json['sku']?.toString() ?? '',
      nameEn: json['name_en']?.toString(),
      nameAr: json['name_ar']?.toString(),
      unit: json['unit']?.toString() ?? '',
      warehouseQuantity: _parseInt(json['warehouse_quantity']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString()) ?? 0;
  }

  String get displayName {
    if (nameEn != null && nameEn!.trim().isNotEmpty) {
      return nameEn!;
    }

    if (nameAr != null && nameAr!.trim().isNotEmpty) {
      return nameAr!;
    }

    return 'Unnamed product';
  }
}
