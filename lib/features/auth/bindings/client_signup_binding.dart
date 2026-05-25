import 'package:get/get.dart';
import 'package:storex/features/auth/controllers/client_signup_controller.dart';

class SignupOnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClientSignupController>(
      () => ClientSignupController(),
    );
  }
}