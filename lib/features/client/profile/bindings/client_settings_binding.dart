import 'package:get/get.dart';
import 'package:storex/features/client/profile/controllers/client_settings_controller.dart';

class ClientSettingsBinding extends Bindings{
  @override
  void dependencies() {
   Get.lazyPut<ClientSettingsController>(
      () => ClientSettingsController(),
    );
  }
}