import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storex/features/auth/models/auth_repo.dart';
import 'package:storex/features/auth/models/user_model.dart';
import 'package:storex/widgets/app_snackbar.dart';

class LoginController extends GetxController {
  final AuthRepo _authRepo = AuthRepo();
  final loginFormKey = GlobalKey<FormState>();
  // Text controllers
  final loginIdentifierController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  ThemeData get theme => Get.theme;

  // final email = "".obs;
  // String phoneNumber = "";
  // final password = "";

  // UI state
  final isPasswordHidden = true.obs;

     void _navigateBasedOnRole(UserRole role) {
      switch(role) {
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
      }

  Future<void> login() async {
    // This triggers all validators in the form
    if (loginFormKey.currentState!.validate()) {
      // If the form is valid, proceed with login logic
      try {
        isLoading.value = true;

     // Extract the raw text strings from your text editing controllers
      final String input = loginIdentifierController.text.trim();
      final String passwordText = passwordController.text;
      
      print("🔑 Logging in using identifier: $input");

      // Whether it's an email or phone number, the backend handles it via 'login'
      final UserModel user = await _authRepo.login(
        loginIdentifier: input,
        password: passwordText,
      );
      // Route globally based on the user's role
      _navigateBasedOnRole(user.role);

      } catch (e) {
        AppSnackbar.show(title: "Error".tr,
         message: e.toString().replaceAll('Exception: ', ''),
         position: SnackPosition.TOP,
         icon: Icons.error_outline,
         iconColor: theme.colorScheme.error);
        print(e.toString());
      } finally {
        isLoading.value = false;
      }

   
    } else {
      print("❌ Form validation failed. Please correct the errors and try again.");
      AppSnackbar.show(
        title: "Invalid Input".tr,
        message: "Please correct the errors in the form.".tr,
        position: SnackPosition.TOP,
        icon: Icons.error_outline,
        iconColor: theme.colorScheme.error,
      );
      return;
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
