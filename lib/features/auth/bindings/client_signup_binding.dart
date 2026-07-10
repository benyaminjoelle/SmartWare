import 'package:get/get.dart';
import 'package:smartware/features/auth/controllers/client_signup_controller.dart';

class ClientSignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClientSignupController>(() => ClientSignupController());
  }
}
