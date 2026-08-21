import 'dart:io';

import 'package:dio/dio.dart';

import 'package:smartware/core/constants/const_ip.dart';
import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/network/api_service.dart';

import 'package:smartware/features/owner/products/models/owner_inventory_model.dart';
import 'package:smartware/features/owner/products/models/owner_product_create_model.dart';

class ProductsRepo {
  final ApiService _api = ApiService();

  final baseUrl = 'http://${ConstIp().ip}:8000';

  // ============================================================
  // GET WAREHOUSE INVENTORY
  // ============================================================

  Future<List<OwnerInventoryModel>> getWarehouseInventory({
    required int facilityId,
  }) async {
    try {
      print('');
      print('════════ GET WAREHOUSE INVENTORY START ════════');
      print('🏢 Facility ID: $facilityId');

      final response = await _api.get(
        '$baseUrl/api/warehouse/$facilityId/inventory',
      );

      print('');
      print('📥 Raw Response:');
      print(response);

      if (response is ApiError) {
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        throw ApiError(message: 'Invalid response from server');
      }

      final data = response['data'];

      if (data is! Map<String, dynamic>) {
        throw ApiError(message: 'Invalid inventory data');
      }

      final items = data['data'];

      if (items is! List) {
        throw ApiError(message: 'Invalid inventory list');
      }

      final result = items
          .map(
            (item) => OwnerInventoryModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();

      print('');
      print('════════ WAREHOUSE INVENTORY RESPONSE ════════');
      print('📦 Total Inventory Items: ${result.length}');

      for (final inventory in result) {
        print(
          '📦 ${inventory.product.nameEn ?? inventory.product.nameAr ?? ''} '
          '| Product ID: ${inventory.product.id} '
          '| SKU: ${inventory.product.sku} '
          '| Quantity: ${inventory.quantity} '
          '| Section ID: ${inventory.sectionId} '
          '| Unit: ${inventory.product.unit}',
        );
      }

      print('════════════════════════════════════════');

      return result;
    } on DioException catch (e) {
      print('');
      print('════════ INVENTORY DIO ERROR ════════');
      print('❌ Status Code: ${e.response?.statusCode}');
      print('❌ Response Data: ${e.response?.data}');
      print('════════════════════════════════════');

      final data = e.response?.data;

      String message = 'Failed to load inventory';

      if (data is Map<String, dynamic>) {
        if (data['error'] != null) {
          message = data['error'].toString();
        } else if (data['message'] != null) {
          message = data['message'].toString();
        }
      }

      throw ApiError(message: message);
    }
  }

  // ============================================================
  // CREATE PRODUCT + INVENTORY
  // ============================================================

 Future<CreateProductResponse> createProduct({
  required String sku,
  required String nameEn,
  required String unit,
  required List<int> categories,
  required String descriptionEn,
  required int sectionId,
  required int quantity,
  required double unitPrice,
  File? productImage,
}) async {
  try {
    print('');
    print('════════ CREATE PRODUCT START ════════');

    print('📦 SKU: $sku');
    print('📝 Name: $nameEn');
    print('📏 Unit: $unit');
    print('💰 Unit Price: $unitPrice');
    print('🏷 Categories: $categories');
    print('📄 Description: $descriptionEn');
    print('🏢 Section ID: $sectionId');
    print('📦 Quantity: $quantity');
    print('🖼 Image: ${productImage?.path}');

    final formData = FormData();

    formData.fields.add(
      MapEntry('sku', sku.trim()),
    );

    formData.fields.add(
      MapEntry('name_en', nameEn.trim()),
    );

    formData.fields.add(
      MapEntry('unit', unit.trim()),
    );

    formData.fields.add(
      MapEntry('unit_price', unitPrice.toString()),
    );

    formData.fields.add(
      MapEntry('description_en', descriptionEn.trim()),
    );

    formData.fields.add(
      MapEntry('section_id', sectionId.toString()),
    );

    formData.fields.add(
      MapEntry('quantity', quantity.toString()),
    );

    for (final categoryId in categories) {
      formData.fields.add(
        MapEntry(
          'categories[]',
          categoryId.toString(),
        ),
      );
    }

    if (productImage != null) {
      formData.files.add(
        MapEntry(
          'product_image',
          await MultipartFile.fromFile(
            productImage.path,
            filename: productImage.path
                .split(Platform.pathSeparator)
                .last,
          ),
        ),
      );
    }

    print('');
    print('📤 FORM DATA:');

    for (final field in formData.fields) {
      print('   ${field.key}: ${field.value}');
    }

    if (formData.files.isNotEmpty) {
      print(
        '   product_image: '
        '${formData.files.first.value.filename}',
      );
    }

    final response = await _api.post(
      '$baseUrl/api/products',
      formData,
    );

    print('');
    print('📥 CREATE PRODUCT RESPONSE:');
    print(response);

    if (response is ApiError) {
      throw response;
    }

    if (response is! Map<String, dynamic>) {
      throw ApiError(
        message: 'Invalid response from server',
      );
    }

    final result = CreateProductResponse.fromJson(response);

    print('');
    print('════════ PRODUCT CREATED ════════');
    print('💬 Message: ${result.message}');
    print('🆔 Product ID: ${result.data.id}');
    print('📦 SKU: ${result.data.sku}');
    print('📝 Name: ${result.data.name}');
    print('════════════════════════════════');

    return result;
  } on DioException catch (e) {
    print('');
    print('════════ CREATE PRODUCT DIO ERROR ════════');
    print('❌ Status Code: ${e.response?.statusCode}');
    print('❌ Response Data: ${e.response?.data}');
    print('════════════════════════════════════════');

    final data = e.response?.data;

    String message = 'Failed to create product';

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
    print('════════ CREATE PRODUCT ERROR ════════');
    print('❌ Error: $e');
    print('❌ Type: ${e.runtimeType}');
    print('❌ StackTrace: $stackTrace');
    print('════════════════════════════════════');

    if (e is ApiError) {
      rethrow;
    }

    throw ApiError(
      message: 'Failed to create product',
    );
  }
}
}