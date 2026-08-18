import 'package:get/get.dart';
import 'package:smartware/features/client/cart/controllers/client_cart_controller.dart';
import 'package:smartware/features/client/home/controllers/ads_carousel_controller.dart';
import 'package:smartware/features/client/home/controllers/client_home_controller.dart';
import 'package:smartware/features/client/profile/controllers/client_profile_controller.dart';
import 'package:smartware/features/client/profile/controllers/client_settings_controller.dart';
import 'package:smartware/features/client/root/controller/root_controller.dart';
import 'package:smartware/features/product/controllers/product_controller.dart';
import 'package:smartware/features/warehouse/controllers/warehouse_controller.dart';
import 'package:smartware/localization/local_controller.dart';

class ClientRootBinding extends Bindings {
  @override
  void dependencies() {
    print('client root binding running');
    Get.lazyPut<ClientSettingsController>(() => ClientSettingsController());
    Get.lazyPut<ClientHomeController>(()=> ClientHomeController());
    Get.put(AdsCarouselController(), permanent: true); // AdsCarouselController is now a singleton
    Get.lazyPut<LocaleController>(() => LocaleController());
    Get.lazyPut<RootController>(() => RootController());
    Get.lazyPut<ClientProfileController>(() => ClientProfileController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<WarehouseController>(() => WarehouseController(),);
    // Get.lazyPut<productDetailsBinding>(() => productDetailsBinding());
    Get.lazyPut<ProductController>(()=>ProductController(),);
  }
}
