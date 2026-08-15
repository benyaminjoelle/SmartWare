import 'package:get/get.dart';
import 'package:smartware/features/warehouse/models/warehouse_product_model.dart';

class WarehouseController extends GetxController {
  final warehouseProducts = <WarehouseProduct>[].obs;
  final isLoading = false.obs;

  void loadWarehousesForProduct(String productSku) {
  
    warehouseProducts.assignAll([
      WarehouseProduct(
        warehouseId: 'wh_001',
        warehouseName: 'Central Distribution Hub',
        address: 'Industrial Zone, Block 4, Bldg 12',
        price: 95.0,
        discountPercentage: 10.0,
        stockQuantity: 25,
      ),
      WarehouseProduct(
        warehouseId: 'wh_002',
        warehouseName: 'Northern Port Depot',
        address: 'Free Zone Area, Dock 3',
        price: 100.0,
        discountPercentage: null,
        stockQuantity: 12,
      ),
      WarehouseProduct(
        warehouseId: 'wh_003',
        warehouseName: 'Southern Commercial Warehouse',
        address: 'Main Highway Exit 7',
        price: 92.0,
        discountPercentage: 5.0,
        stockQuantity: 8,
      ),
      WarehouseProduct(
        warehouseId: 'wh_004',
        warehouseName: 'Central Coast Storage',
        address: 'Industrial City, Plot 88',
        price: 105.0,
        discountPercentage: null,
        stockQuantity: 30,
      ),
    ]);
  }
}