import 'package:get/get.dart';
import 'package:smartware/features/client/profile/controllers/client_profile_controller.dart';
import 'package:smartware/features/client/profile/controllers/client_settings_controller.dart';
import 'package:smartware/features/client/root/controller/root_controller.dart';
import 'package:smartware/localization/local_controller.dart';

class ClientRootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClientSettingsController>(() => ClientSettingsController());
    Get.lazyPut<LocaleController>(() => LocaleController());
    Get.lazyPut<RootController>(() => RootController());
    Get.lazyPut<ClientProfileController>(() => ClientProfileController());
    Get.lazyPut<ClientSettingsController>(() => ClientSettingsController());
  }
}
