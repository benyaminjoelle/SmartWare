import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:storex/features/auth/controllers/worker_signup_controller.dart';

class WorkerSignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorkerSignupController>(
      () => WorkerSignupController(),
    );
  }
}