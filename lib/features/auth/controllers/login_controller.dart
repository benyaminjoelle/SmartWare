import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/auth/models/auth_repo.dart';
import 'package:smartware/features/auth/models/user_model.dart';
import 'package:smartware/features/auth/widgets/role_data.dart';

class LoginController extends GetxController {
  final AuthRepo _authRepo = AuthRepo();
  final loginFormKey = GlobalKey<FormState>();
  // Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  final email = "".obs;
  String phoneNumber = "";
  final password = "";

  // UI state
  final isPasswordHidden = true.obs;

  Future<void> login() async {
    final user = await _authRepo.login(
      loginIdentifier: email.value,
      password: password,
    );
    // This triggers all validators in the form
    if (loginFormKey.currentState!.validate()) {
      // If the form is valid, proceed with login logic
      switch (user.role) {
        case UserRole.client:
          Get.offAllNamed('/clientRoot');
          break;
        case UserRole.worker:
          Get.offAllNamed('/workerRoot');
          break;
        case UserRole.warehouseAdmin:
          Get.offAllNamed('/ownerRoot');
          break;
        default:
          print("Invalid user type!");
      }
    } else {
      print("Form is invalid!");
    }
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  @override
  void onClose() {
    // emailController.dispose();
    // passwordController.dispose();
    super.onClose();
  }
}
