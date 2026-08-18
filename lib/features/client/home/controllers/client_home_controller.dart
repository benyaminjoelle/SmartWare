import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smartware/features/auth/models/user_model.dart';
import 'package:smartware/features/product/controllers/product_controller.dart';

class ClientHomeController extends GetxController {
  late UserModel user;

  String get userName => user.firstName;
 //hon bdi 2a5od l onboarding preference w 7ton mshan 7mel lproducts
  @override
  void onInit() {
    super.onInit();

    loadUser();
  }

  void loadUser() {
    final box = GetStorage();

    final Map<String, dynamic> responseMap =
        box.read('user_data') ?? {};

    user = UserModel.fromJson(responseMap);
  }
  }