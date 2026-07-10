import 'package:get/get.dart';
import 'package:storex/features/client/home/controllers/client_home_controller.dart';
import 'package:storex/features/client/profile/controllers/client_profile_controller.dart';
import 'package:storex/features/client/profile/controllers/client_settings_controller.dart';
import 'package:storex/features/client/root/controller/root_controller.dart';
import 'package:storex/localization/local_controller.dart';


class ClientRootBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut<ClientSettingsController>(
      () => ClientSettingsController(),
    );
    Get.lazyPut<LocaleController>(
      () => LocaleController(),
    );
    Get.lazyPut<RootController>(
      () => RootController(),
    );
     Get.lazyPut<ClientProfileController>(
      () => ClientProfileController(),
    );
     Get.lazyPut<ClientSettingsController>(
      () => ClientSettingsController(),
    );
    Get.lazyPut<ClientHomeController>(
      () => ClientHomeController(),
    );
  }
}