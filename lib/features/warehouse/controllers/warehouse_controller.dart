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

  // Mock data for testing.
  // Later this will come from the backend.
  warehouseProducts.assignAll([
    // ============================================================
    // PRODUCT 1 - Premium Basmati Rice
    // ============================================================

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

    // ============================================================
    // PRODUCT 2 - Full Cream Milk
    // ============================================================

    WarehouseProductModel(
      sectionId: 4,
      productId: 2,
      quantity: 40,
      unitPrice: 75.0,
      warehouseId: 1,
      companyId: 1,
      name: 'Full Cream Milk',
      capacity: '1 L',
      warehouseName: 'Central Distribution Hub',
      address: 'Industrial Zone, Block 4, Bldg 12',
      discountPercentage: null,
    ),

    WarehouseProductModel(
      sectionId: 5,
      productId: 2,
      quantity: 18,
      unitPrice: 82.0,
      warehouseId: 2,
      companyId: 1,
      name: 'Full Cream Milk',
      capacity: '1 L',
      warehouseName: 'Northern Port Depot',
      address: 'Free Zone Area, Dock 3',
      discountPercentage: 8.0,
    ),

    // ============================================================
    // PRODUCT 3 - Cola Soft Drink
    // ============================================================

    WarehouseProductModel(
      sectionId: 6,
      productId: 3,
      quantity: 60,
      unitPrice: 45.0,
      warehouseId: 3,
      companyId: 2,
      name: 'Cola Soft Drink',
      capacity: '330 ml',
      warehouseName: 'Southern Commercial Warehouse',
      address: 'Main Highway Exit 7',
      discountPercentage: 5.0,
    ),

    WarehouseProductModel(
      sectionId: 7,
      productId: 3,
      quantity: 35,
      unitPrice: 49.0,
      warehouseId: 4,
      companyId: 2,
      name: 'Cola Soft Drink',
      capacity: '330 ml',
      warehouseName: 'Central Coast Storage',
      address: 'Industrial City, Plot 88',
      discountPercentage: null,
    ),

    // ============================================================
    // PRODUCT 4 - Arabica Coffee
    // ============================================================

    WarehouseProductModel(
      sectionId: 8,
      productId: 4,
      quantity: 20,
      unitPrice: 120.0,
      warehouseId: 1,
      companyId: 1,
      name: 'Arabica Coffee',
      capacity: '500 g',
      warehouseName: 'Central Distribution Hub',
      address: 'Industrial Zone, Block 4, Bldg 12',
      discountPercentage: 12.0,
    ),

    WarehouseProductModel(
      sectionId: 9,
      productId: 4,
      quantity: 10,
      unitPrice: 128.0,
      warehouseId: 3,
      companyId: 2,
      name: 'Arabica Coffee',
      capacity: '500 g',
      warehouseName: 'Southern Commercial Warehouse',
      address: 'Main Highway Exit 7',
      discountPercentage: null,
    ),

    // ============================================================
    // PRODUCT 5 - Frozen Chicken Breast
    // ============================================================

    WarehouseProductModel(
      sectionId: 10,
      productId: 5,
      quantity: 15,
      unitPrice: 180.0,
      warehouseId: 2,
      companyId: 1,
      name: 'Frozen Chicken Breast',
      capacity: '10 kg',
      warehouseName: 'Northern Port Depot',
      address: 'Free Zone Area, Dock 3',
      discountPercentage: 10.0,
    ),

    WarehouseProductModel(
      sectionId: 11,
      productId: 5,
      quantity: 22,
      unitPrice: 175.0,
      warehouseId: 4,
      companyId: 2,
      name: 'Frozen Chicken Breast',
      capacity: '10 kg',
      warehouseName: 'Central Coast Storage',
      address: 'Industrial City, Plot 88',
      discountPercentage: null,
    ),

    // ============================================================
    // PRODUCT 6 - Paracetamol 500mg
    // ============================================================

    WarehouseProductModel(
      sectionId: 12,
      productId: 6,
      quantity: 100,
      unitPrice: 25.0,
      warehouseId: 1,
      companyId: 1,
      name: 'Paracetamol 500mg',
      capacity: '20 tablets',
      warehouseName: 'Central Distribution Hub',
      address: 'Industrial Zone, Block 4, Bldg 12',
      discountPercentage: 5.0,
    ),

    WarehouseProductModel(
      sectionId: 13,
      productId: 6,
      quantity: 75,
      unitPrice: 27.0,
      warehouseId: 3,
      companyId: 2,
      name: 'Paracetamol 500mg',
      capacity: '20 tablets',
      warehouseName: 'Southern Commercial Warehouse',
      address: 'Main Highway Exit 7',
      discountPercentage: null,
    ),

    // ============================================================
    // PRODUCT 7 - Vitamin C Tablets
    // ============================================================

    WarehouseProductModel(
      sectionId: 14,
      productId: 7,
      quantity: 80,
      unitPrice: 40.0,
      warehouseId: 2,
      companyId: 1,
      name: 'Vitamin C Tablets',
      capacity: '30 tablets',
      warehouseName: 'Northern Port Depot',
      address: 'Free Zone Area, Dock 3',
      discountPercentage: 10.0,
    ),

    WarehouseProductModel(
      sectionId: 15,
      productId: 7,
      quantity: 50,
      unitPrice: 44.0,
      warehouseId: 4,
      companyId: 2,
      name: 'Vitamin C Tablets',
      capacity: '30 tablets',
      warehouseName: 'Central Coast Storage',
      address: 'Industrial City, Plot 88',
      discountPercentage: null,
    ),

    // ============================================================
    // PRODUCT 8 - First Aid Kit
    // ============================================================

    WarehouseProductModel(
      sectionId: 16,
      productId: 8,
      quantity: 30,
      unitPrice: 65.0,
      warehouseId: 1,
      companyId: 1,
      name: 'First Aid Kit',
      capacity: '1 kit',
      warehouseName: 'Central Distribution Hub',
      address: 'Industrial Zone, Block 4, Bldg 12',
      discountPercentage: null,
    ),

    WarehouseProductModel(
      sectionId: 17,
      productId: 8,
      quantity: 20,
      unitPrice: 70.0,
      warehouseId: 3,
      companyId: 2,
      name: 'First Aid Kit',
      capacity: '1 kit',
      warehouseName: 'Southern Commercial Warehouse',
      address: 'Main Highway Exit 7',
      discountPercentage: 7.0,
    ),

    // ============================================================
    // PRODUCT 9 - Men Cotton Shirt
    // ============================================================

    WarehouseProductModel(
      sectionId: 18,
      productId: 9,
      quantity: 45,
      unitPrice: 55.0,
      warehouseId: 2,
      companyId: 1,
      name: 'Men Cotton Shirt',
      capacity: '1 piece',
      warehouseName: 'Northern Port Depot',
      address: 'Free Zone Area, Dock 3',
      discountPercentage: 10.0,
    ),

    WarehouseProductModel(
      sectionId: 19,
      productId: 9,
      quantity: 25,
      unitPrice: 60.0,
      warehouseId: 4,
      companyId: 2,
      name: 'Men Cotton Shirt',
      capacity: '1 piece',
      warehouseName: 'Central Coast Storage',
      address: 'Industrial City, Plot 88',
      discountPercentage: null,
    ),

    // ============================================================
    // PRODUCT 10 - Running Shoes
    // ============================================================

    WarehouseProductModel(
      sectionId: 20,
      productId: 10,
      quantity: 35,
      unitPrice: 140.0,
      warehouseId: 1,
      companyId: 1,
      name: 'Running Shoes',
      capacity: '1 pair',
      warehouseName: 'Central Distribution Hub',
      address: 'Industrial Zone, Block 4, Bldg 12',
      discountPercentage: 15.0,
    ),

    WarehouseProductModel(
      sectionId: 21,
      productId: 10,
      quantity: 18,
      unitPrice: 150.0,
      warehouseId: 3,
      companyId: 2,
      name: 'Running Shoes',
      capacity: '1 pair',
      warehouseName: 'Southern Commercial Warehouse',
      address: 'Main Highway Exit 7',
      discountPercentage: null,
    ),

    // ============================================================
    // PRODUCT 11 - Leather Handbag
    // ============================================================

    WarehouseProductModel(
      sectionId: 22,
      productId: 11,
      quantity: 20,
      unitPrice: 180.0,
      warehouseId: 2,
      companyId: 1,
      name: 'Leather Handbag',
      capacity: '1 piece',
      warehouseName: 'Northern Port Depot',
      address: 'Free Zone Area, Dock 3',
      discountPercentage: 10.0,
    ),

    WarehouseProductModel(
      sectionId: 23,
      productId: 11,
      quantity: 12,
      unitPrice: 195.0,
      warehouseId: 4,
      companyId: 2,
      name: 'Leather Handbag',
      capacity: '1 piece',
      warehouseName: 'Central Coast Storage',
      address: 'Industrial City, Plot 88',
      discountPercentage: null,
    ),

    // ============================================================
    // PRODUCT 12 - Smartphone Pro
    // ============================================================

    WarehouseProductModel(
      sectionId: 24,
      productId: 12,
      quantity: 15,
      unitPrice: 850.0,
      warehouseId: 1,
      companyId: 1,
      name: 'Smartphone Pro',
      capacity: '1 piece',
      warehouseName: 'Central Distribution Hub',
      address: 'Industrial Zone, Block 4, Bldg 12',
      discountPercentage: 5.0,
    ),

    WarehouseProductModel(
      sectionId: 25,
      productId: 12,
      quantity: 10,
      unitPrice: 875.0,
      warehouseId: 3,
      companyId: 2,
      name: 'Smartphone Pro',
      capacity: '1 piece',
      warehouseName: 'Southern Commercial Warehouse',
      address: 'Main Highway Exit 7',
      discountPercentage: null,
    ),

    // ============================================================
    // PRODUCT 13 - Business Laptop
    // ============================================================

    WarehouseProductModel(
      sectionId: 26,
      productId: 13,
      quantity: 12,
      unitPrice: 1250.0,
      warehouseId: 2,
      companyId: 1,
      name: 'Business Laptop',
      capacity: '1 piece',
      warehouseName: 'Northern Port Depot',
      address: 'Free Zone Area, Dock 3',
      discountPercentage: 8.0,
    ),

    WarehouseProductModel(
      sectionId: 27,
      productId: 13,
      quantity: 7,
      unitPrice: 1300.0,
      warehouseId: 4,
      companyId: 2,
      name: 'Business Laptop',
      capacity: '1 piece',
      warehouseName: 'Central Coast Storage',
      address: 'Industrial City, Plot 88',
      discountPercentage: null,
    ),

    // ============================================================
    // PRODUCT 14 - Wireless Headphones
    // ============================================================

    WarehouseProductModel(
      sectionId: 28,
      productId: 14,
      quantity: 40,
      unitPrice: 95.0,
      warehouseId: 1,
      companyId: 1,
      name: 'Wireless Headphones',
      capacity: '1 piece',
      warehouseName: 'Central Distribution Hub',
      address: 'Industrial Zone, Block 4, Bldg 12',
      discountPercentage: 10.0,
    ),

    WarehouseProductModel(
      sectionId: 29,
      productId: 14,
      quantity: 25,
      unitPrice: 105.0,
      warehouseId: 3,
      companyId: 2,
      name: 'Wireless Headphones',
      capacity: '1 piece',
      warehouseName: 'Southern Commercial Warehouse',
      address: 'Main Highway Exit 7',
      discountPercentage: null,
    ),

    // ============================================================
    // PRODUCT 15 - AA Batteries
    // ============================================================

    WarehouseProductModel(
      sectionId: 30,
      productId: 15,
      quantity: 100,
      unitPrice: 20.0,
      warehouseId: 2,
      companyId: 1,
      name: 'AA Batteries',
      capacity: '4 batteries',
      warehouseName: 'Northern Port Depot',
      address: 'Free Zone Area, Dock 3',
      discountPercentage: 5.0,
    ),

    WarehouseProductModel(
      sectionId: 31,
      productId: 15,
      quantity: 70,
      unitPrice: 22.0,
      warehouseId: 4,
      companyId: 2,
      name: 'AA Batteries',
      capacity: '4 batteries',
      warehouseName: 'Central Coast Storage',
      address: 'Industrial City, Plot 88',
      discountPercentage: null,
    ),

    // ============================================================
    // PRODUCT 16 - Matte Lipstick
    // ============================================================

    WarehouseProductModel(
      sectionId: 32,
      productId: 16,
      quantity: 60,
      unitPrice: 35.0,
      warehouseId: 1,
      companyId: 1,
      name: 'Matte Lipstick',
      capacity: '1 piece',
      warehouseName: 'Central Distribution Hub',
      address: 'Industrial Zone, Block 4, Bldg 12',
      discountPercentage: 10.0,
    ),

    WarehouseProductModel(
      sectionId: 33,
      productId: 16,
      quantity: 30,
      unitPrice: 39.0,
      warehouseId: 3,
      companyId: 2,
      name: 'Matte Lipstick',
      capacity: '1 piece',
      warehouseName: 'Southern Commercial Warehouse',
      address: 'Main Highway Exit 7',
      discountPercentage: null,
    ),

    // ============================================================
    // PRODUCT 17 - Hydrating Face Cream
    // ============================================================

    WarehouseProductModel(
      sectionId: 34,
      productId: 17,
      quantity: 50,
      unitPrice: 48.0,
      warehouseId: 2,
      companyId: 1,
      name: 'Hydrating Face Cream',
      capacity: '100 ml',
      warehouseName: 'Northern Port Depot',
      address: 'Free Zone Area, Dock 3',
      discountPercentage: 5.0,
    ),

    WarehouseProductModel(
      sectionId: 35,
      productId: 17,
      quantity: 35,
      unitPrice: 52.0,
      warehouseId: 4,
      companyId: 2,
      name: 'Hydrating Face Cream',
      capacity: '100 ml',
      warehouseName: 'Central Coast Storage',
      address: 'Industrial City, Plot 88',
      discountPercentage: null,
    ),

    // ============================================================
    // PRODUCT 18 - Floral Perfume
    // ============================================================

    WarehouseProductModel(
      sectionId: 36,
      productId: 18,
      quantity: 25,
      unitPrice: 110.0,
      warehouseId: 1,
      companyId: 1,
      name: 'Floral Perfume',
      capacity: '100 ml',
      warehouseName: 'Central Distribution Hub',
      address: 'Industrial Zone, Block 4, Bldg 12',
      discountPercentage: 12.0,
    ),

    WarehouseProductModel(
      sectionId: 37,
      productId: 18,
      quantity: 15,
      unitPrice: 120.0,
      warehouseId: 3,
      companyId: 2,
      name: 'Floral Perfume',
      capacity: '100 ml',
      warehouseName: 'Southern Commercial Warehouse',
      address: 'Main Highway Exit 7',
      discountPercentage: null,
    ),

    // ============================================================
    // PRODUCT 19 - Office Desk
    // ============================================================

    WarehouseProductModel(
      sectionId: 38,
      productId: 19,
      quantity: 18,
      unitPrice: 250.0,
      warehouseId: 2,
      companyId: 1,
      name: 'Office Desk',
      capacity: '1 piece',
      warehouseName: 'Northern Port Depot',
      address: 'Free Zone Area, Dock 3',
      discountPercentage: 10.0,
    ),

    WarehouseProductModel(
      sectionId: 39,
      productId: 19,
      quantity: 10,
      unitPrice: 275.0,
      warehouseId: 4,
      companyId: 2,
      name: 'Office Desk',
      capacity: '1 piece',
      warehouseName: 'Central Coast Storage',
      address: 'Industrial City, Plot 88',
      discountPercentage: null,
    ),

    // ============================================================
    // PRODUCT 20 - Modern Living Room Sofa
    // ============================================================

    WarehouseProductModel(
      sectionId: 40,
      productId: 20,
      quantity: 8,
      unitPrice: 650.0,
      warehouseId: 1,
      companyId: 1,
      name: 'Modern Living Room Sofa',
      capacity: '1 piece',
      warehouseName: 'Central Distribution Hub',
      address: 'Industrial Zone, Block 4, Bldg 12',
      discountPercentage: 15.0,
    ),

    WarehouseProductModel(
      sectionId: 41,
      productId: 20,
      quantity: 5,
      unitPrice: 700.0,
      warehouseId: 3,
      companyId: 2,
      name: 'Modern Living Room Sofa',
      capacity: '1 piece',
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