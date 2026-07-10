import 'package:get/get.dart';
import 'package:smartware/features/auth/controllers/signup_onboarding_controller.dart';

class SignupOnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupOnboardingController>(() => SignupOnboardingController());
  }
}
