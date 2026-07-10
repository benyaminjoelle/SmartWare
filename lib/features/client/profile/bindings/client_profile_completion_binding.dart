import 'package:get/get.dart';
import 'package:smartware/features/client/profile/controllers/client_profile_completion_controller.dart';

class ClientProfileCompletionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClientProfileCompletionController>(
      () => ClientProfileCompletionController(),
      fenix: true,
    );
  }
}
