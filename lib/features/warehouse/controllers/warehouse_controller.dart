import 'package:get/get.dart';
import 'package:smartware/features/warehouse/models/warehouse_product_model.dart';
import 'package:smartware/features/warehouse/models/warehouse_repo.dart';

class WarehouseController extends GetxController {
  final warehouseProducts = <WarehouseProductModel>[].obs;
  final WarehouseRepo warehouseRepo = WarehouseRepo();
  final isLoading = false.obs;

  Future<void> loadWarehousesForProduct(int productId) async {
    try {
      isLoading.value = true;

      final result =
          await warehouseRepo.getWarehousesForProduct(productId);

      warehouseProducts.assignAll(result);

      print(
        '🏪 Warehouses for product $productId: '
        '${warehouseProducts.length}',
      );
    } catch (e) {
      print('❌ Failed to load warehouses: $e');
      warehouseProducts.clear();
    } finally {
      isLoading.value = false;
    }
  }

  List<WarehouseProductModel> getWarehousesForProduct(
    int productId,
  ) {
    return warehouseProducts
        .where((item) => item.productId == productId)
        .toList();
  }

  void clearWarehouses() {
    warehouseProducts.clear();
  }
}