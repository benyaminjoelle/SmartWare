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

      final warehouses = response['warehouses'];

      if (warehouses is! List) {
        throw ApiError(
          message: 'Invalid warehouse response.',
        );
      }

      return warehouses
          .map(
            (json) => WarehouseProductModel.fromJson(
              Map<String, dynamic>.from(json),
            ),
          )
          .toList();
    } catch (e) {
      if (e is ApiError) {
        rethrow;
      }

      throw ApiError(
        message: 'Failed to load warehouses for product.',
      );
    }
  }
}