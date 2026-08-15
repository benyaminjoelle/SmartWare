import 'package:get/get.dart';
import 'package:smartware/features/warehouse/controllers/warehouse_controller.dart';

class WarehouseDependencie extends Bindings{
    @override
    void dependencies() {
        Get.lazyPut<WarehouseController>(() => WarehouseController());
    }
}