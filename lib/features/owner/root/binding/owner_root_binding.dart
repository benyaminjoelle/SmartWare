import 'package:get/get.dart';
import 'package:smartware/features/owner/analytics/controllers/owner_analytic_controller.dart';
import 'package:smartware/features/owner/home/controllers/owner_home_controller.dart';
import 'package:smartware/features/owner/notifications/controllers/owner_notifications_controller.dart';
import 'package:smartware/features/owner/orders/controllers/owner_orders_controller.dart';
import 'package:smartware/features/owner/products/controllers/owner_products_controller.dart';
import 'package:smartware/features/owner/profile/controllers/owner_profile_controller.dart';
import 'package:smartware/features/owner/profile/controllers/owner_settings_controller.dart';
import 'package:smartware/features/owner/profile/controllers/owner_workers_controller.dart';

import 'package:smartware/features/owner/root/controller/owner_root_controller.dart';
class OwnerRootBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut<OwnerRootController>(() => OwnerRootController());
   Get.lazyPut<OwnerHomeController>(() => OwnerHomeController());
   Get.lazyPut<OwnerOrdersController>(() => OwnerOrdersController());
   Get.lazyPut<OwnerNotificationsController>(() => OwnerNotificationsController());
   Get.lazyPut<OwnerAnalyticsController>(() => OwnerAnalyticsController());
   Get.lazyPut<OwnerProfileController>(() => OwnerProfileController());
   Get.lazyPut<OwnerSettingsController>(() => OwnerSettingsController());
    Get.lazyPut<OwnerWorkersController>(() => OwnerWorkersController());
        Get.lazyPut<OwnerProductsController>(() => OwnerProductsController());

  }
}
