import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/network/api_service.dart';
import 'package:smartware/features/product/models/product_model.dart';

class ProductRepo {
  final ApiService _apiService = ApiService();

  Future<List<Product>> getProducts() async {
    try {
      final response = await _apiService.get('/inventories/products');
      if (response is ApiError) {
        throw response;
      }
      final data = response['data'];

      if (data is! List) {
        throw ApiError(
          message: 'Invalid products response.',
        );
      }

      return data
          .map(
            (json) => Product.fromJson(
              Map<String, dynamic>.from(json),
            ),
          )
          .toList();
    } catch (e, stackTrace) {
      print('❌ PRODUCT PARSING ERROR: $e');
      print(stackTrace);

      if (e is ApiError) {
        rethrow;
      }

      throw ApiError(
        message: 'Failed to load products.',
      );
    }
  }
}