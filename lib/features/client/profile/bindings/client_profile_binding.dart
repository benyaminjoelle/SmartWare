import 'package:get/get.dart';

import '../controllers/client_profile_controller.dart';

class ClientProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClientProfileController>(
      () => ClientProfileController(),
      fenix: true,
    );
    
  }
}