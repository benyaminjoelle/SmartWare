import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:smartware/features/client/home/controllers/product_details_controller.dart';

class productDetailsBinding extends Bindings {
   @override
   void dependencies() {
     Get.lazyPut<ProductDetailsController>(() => ProductDetailsController());
   }
 }