import 'package:get/get.dart';
import 'package:storex/features/client/profile/controllers/client_security_controller.dart';

class ClientSecurityBinding extends Bindings{
   @override
  void dependencies() {
   Get.lazyPut<ClientSecurityController>(
      () => ClientSecurityController(),
    );
  }
}