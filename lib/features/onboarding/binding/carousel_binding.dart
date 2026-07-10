import 'package:get/get.dart';
import 'package:smartware/features/onboarding/controller/onboarding_carousel_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingCarouselController>(
      () => OnboardingCarouselController(),
    );
  }
}
