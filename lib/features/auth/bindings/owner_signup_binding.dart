import 'package:get/get.dart';
import 'package:smartware/features/auth/controllers/owner_signup_controller.dart';

class OwnerSignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OwnerSignupController>(() => OwnerSignupController());
  }
}
