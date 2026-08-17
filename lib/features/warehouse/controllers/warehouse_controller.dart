import 'package:get/get.dart';
import 'package:smartware/features/warehouse/models/warehouse_product_model.dart';

class WarehouseController extends GetxController {
  final warehouseProducts = <WarehouseProductModel>[].obs;
  final isLoading = false.obs;

    @override
    void onInit(){
      super.onInit();
      loadAllWarehouseProducts();
    }

  void loadAllWarehouseProducts() {
    isLoading.value = true;

   
    // Later this will come from the backend.
    warehouseProducts.assignAll([
      //product 1
      WarehouseProductModel(
        sectionId: 1,
        productId: 1,
        quantity: 25,
        unitPrice: 95.0,
        warehouseId: 1,
        companyId: 1,
        name: 'Premium Basmati Rice',
        capacity: '25 kg',
        warehouseName: 'Central Distribution Hub',
        address: 'Industrial Zone, Block 4, Bldg 12',
        discountPercentage: 10.0,
      ),
      WarehouseProductModel(
        sectionId: 2,
        productId: 1,
        quantity: 12,
        unitPrice: 100.0,
        warehouseId: 2,
        companyId: 1,
        name: 'Premium Basmati Rice',
        capacity: '25 kg',
        warehouseName: 'Northern Port Depot',
        address: 'Free Zone Area, Dock 3',
        discountPercentage: null,
      ),
      WarehouseProductModel(
        sectionId: 3,
        productId: 1,
        quantity: 8,
        unitPrice: 92.0,
        warehouseId: 3,
        companyId: 2,
        name: 'Premium Basmati Rice',
        capacity: '25 kg',
        warehouseName: 'Southern Commercial Warehouse',
        address: 'Main Highway Exit 7',
        discountPercentage: 5.0,
      ),
      WarehouseProductModel(
        sectionId: 4,
        productId: 1,
        quantity: 30,
        unitPrice: 105.0,
        warehouseId: 4,
        companyId: 2,
        name: 'Premium Basmati Rice',
        capacity: '25 kg',
        warehouseName: 'Central Coast Storage',
        address: 'Industrial City, Plot 88',
        discountPercentage: null,
      ),
      // PRODUCT 2
      WarehouseProductModel(
        sectionId: 5,
        productId: 2,
        quantity: 40,
        unitPrice: 75.0,
        warehouseId: 1,
        companyId: 1,
        name: 'Premium Olive Oil',
        capacity: '1 L',
        warehouseName: 'Central Distribution Hub',
        address: 'Industrial Zone, Block 4, Bldg 12',
        discountPercentage: null,
      ),

      WarehouseProductModel(
        sectionId: 6,
        productId: 2,
        quantity: 18,
        unitPrice: 82.0,
        warehouseId: 2,
        companyId: 1,
        name: 'Premium Olive Oil',
        capacity: '1 L',
        warehouseName: 'Northern Port Depot',
        address: 'Free Zone Area, Dock 3',
        discountPercentage: 8.0,
      ),

      // PRODUCT 3
      WarehouseProductModel(
        sectionId: 7,
        productId: 3,
        quantity: 15,
        unitPrice: 45.0,
        warehouseId: 3,
        companyId: 2,
        name: 'Liquid Dish Soap',
        capacity: '750 ml',
        warehouseName: 'Southern Commercial Warehouse',
        address: 'Main Highway Exit 7',
        discountPercentage: 5.0,
      ),

      WarehouseProductModel(
        sectionId: 8,
        productId: 3,
        quantity: 35,
        unitPrice: 49.0,
        warehouseId: 4,
        companyId: 2,
        name: 'Liquid Dish Soap',
        capacity: '750 ml',
        warehouseName: 'Central Coast Storage',
        address: 'Industrial City, Plot 88',
        discountPercentage: null,
      ),

      // PRODUCT 4
      WarehouseProductModel(
        sectionId: 9,
        productId: 4,
        quantity: 20,
        unitPrice: 120.0,
        warehouseId: 1,
        companyId: 1,
        name: 'Laundry Detergent',
        capacity: '5 kg',
        warehouseName: 'Central Distribution Hub',
        address: 'Industrial Zone, Block 4, Bldg 12',
        discountPercentage: 12.0,
      ),

      WarehouseProductModel(
        sectionId: 10,
        productId: 4,
        quantity: 10,
        unitPrice: 128.0,
        warehouseId: 3,
        companyId: 2,
        name: 'Laundry Detergent',
        capacity: '5 kg',
        warehouseName: 'Southern Commercial Warehouse',
        address: 'Main Highway Exit 7',
        discountPercentage: null,
      ),
    ]);

    isLoading.value = false;
  }

  // Gets inventory belonging to one product.
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