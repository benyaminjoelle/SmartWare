import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storex/widgets/app_dialog.dart';
import 'package:storex/widgets/app_snackbar.dart';

class WorkerSignupController extends GetxController {
  //------------TextField Controllers-----------------
  GlobalKey<FormState> workerKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final natinalIdController = TextEditingController();
  
  final isPasswordHidden = true.obs;

  final isConfirmPasswordHidden = true.obs;

  final isLoading = false.obs;

  ThemeData get theme => Get.theme;

   /// =========================================================
  /// PASSWORD VISIBILITY
  /// =========================================================
   void togglePasswordVisibility() {
    isPasswordHidden.value =
        !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value =
        !isConfirmPasswordHidden.value;
  }

   bool validateWorker() {
    return workerKey.currentState
            ?.validate() ??
        false;
  }

   void continueToVerify() {
    if (!validateWorker()) {
      AppSnackbar.show(
        title: "Invalid Data",
        message: "Please check your inputs",
        icon: Icons.warning_amber_rounded,
        iconColor: theme.colorScheme.error,
      );

      return;
    }
   }

  Future<void> handleBack() async {
    final result =
        await AppDialogs.showConfirmDialog(
      title: "Exit signup?",
      message:
          "Your progress will be lost if you leave now.",
      confirmText: "Exit",
      confirmColor: Colors.red,
    );

    if (result == true) {
      Get.back();
    }
  }

  
}
