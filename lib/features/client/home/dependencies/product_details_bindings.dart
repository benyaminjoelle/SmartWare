import 'package:get/get.dart';
import 'package:smartware/features/client/home/controllers/product_details_controller.dart';
import 'package:smartware/features/product/models/product_model.dart';
import 'package:smartware/features/warehouse/controllers/warehouse_controller.dart';

class ProductDetailsBindings extends Bindings {
  @override
  void dependencies() {
    final product = Get.arguments as Product;

    Get.lazyPut<ProductDetailsController>(
      () => ProductDetailsController(product: product),
    );
      Get.lazyPut<WarehouseController>(
      () => WarehouseController(),
    );
  }
}