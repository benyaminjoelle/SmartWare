import 'package:get/get.dart';
import 'package:smartware/features/client/profile/controllers/client_edit_profile_controller.dart';

class ClientEditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClientEditProfileController>(
      () => ClientEditProfileController(),
    );
  }
}
