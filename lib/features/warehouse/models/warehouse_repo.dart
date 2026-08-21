import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/network/api_service.dart';
import 'package:smartware/features/warehouse/models/warehouse_product_model.dart';

class WarehouseRepo {
  final ApiService _apiService = ApiService();

  Future<List<WarehouseProductModel>> getWarehousesForProduct(
    int productId,
  ) async {
    try {
      final response = await _apiService.get(
        '/inventories/products/$productId/warehouses',
      );

      if (response is ApiError) {
        throw response;
      }

      final inventories = response['inventories'];

      if (inventories is! List) {
        throw ApiError(
          message: 'Invalid inventory response.',
        );
      }

      final List<WarehouseProductModel> result = [];

      for (final item in inventories) {
        final inventory =
            Map<String, dynamic>.from(item);

        final section =
            Map<String, dynamic>.from(
          inventory['section'],
        );

        final warehouse =
            Map<String, dynamic>.from(
          section['warehouse'],
        );

        final discounts = inventory['discounts'];

        double? discountPercentage;

        if (discounts is List && discounts.isNotEmpty) {
          final activeDiscount = discounts.firstWhere(
            (discount) =>
                discount['is_active'] == true,
            orElse: () => null,
          );

          if (activeDiscount != null) {
            discountPercentage =
                double.tryParse(
              activeDiscount['percentage'].toString(),
            );
          }
        }

        result.add(
          WarehouseProductModel(
            inventoryId: inventory['id'] as int,
            productId: inventory['product_id'] as int,
            quantity: inventory['quantity'] as int,
            unitPrice: double.parse(
              inventory['unit_price'].toString(),
            ),
            discountPercentage: discountPercentage,

            sectionId: section['id'] as int,
            sectionName:
                section['name'].toString(),
            capacity:
                section['capacity'].toString(),

            warehouseId:
                warehouse['id'] as int,
            warehouseName:
                warehouse['facility_name_en']
                    ?.toString() ??
                'Unknown Warehouse',
            addressId:
                warehouse['address_id'] as int?,
          ),
        );
      }

      return result;
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }

      throw ApiError(
        message:
            'Failed to load warehouses for product.',
      );
    }
  }
}