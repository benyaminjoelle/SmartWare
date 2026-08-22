import 'package:get/get.dart';

class RootController extends GetxController {
  final currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is Map && args['index'] != null) {
      currentIndex.value = args['index'];
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
  }
   void openOrders() {
    currentIndex.value = 2;
  }
}