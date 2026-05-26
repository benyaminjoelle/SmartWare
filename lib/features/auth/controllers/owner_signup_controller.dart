import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storex/core/constants/app_colors.dart';
import 'package:storex/widgets/app_dialog.dart';
import 'package:storex/widgets/app_snackbar.dart';

class OwnerSignupController extends GetxController {
  /// =========================================================
  /// FORM KEY
  /// =========================================================

  final clientSignupKey = GlobalKey<FormState>();

  /// =========================================================
  /// BASIC INFO CONTROLLERS
  /// =========================================================

  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  /// =========================================================
  /// ACCOUNT INFO CONTROLLERS
  /// =========================================================

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController =
      TextEditingController();

  /// =========================================================
  /// BUSINESS INFO CONTROLLERS
  /// =========================================================

 
  /// =========================================================
  /// VERIFICATION CONTROLLERS
  /// =========================================================

  final otpController = TextEditingController();

  /// =========================================================
  /// OBSERVABLES
  /// =========================================================

  final isPasswordHidden = true.obs;

  final isConfirmPasswordHidden = true.obs;

  final isLoading = false.obs;

  /// =========================================================
  /// VALIDATIONS
  /// =========================================================

  bool validateClient() {
    return clientSignupKey.currentState
            ?.validate() ??
        false;
  }

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

  /// =========================================================
  /// SIGNUP FLOW
  /// =========================================================

  void continueToVerify() {
    if (!validateClient()) {
      AppSnackbar.show(
        title: "Invalid Data",
        message: "Please check your inputs",
        icon: Icons.warning_amber_rounded,
        iconColor: AppColors.error,
      );

      return;
    }

    /// continue logic here
  }

  /// =========================================================
  /// BACK BUTTON
  /// =========================================================

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

  /// =========================================================
  /// LIFECYCLE
  /// =========================================================

  @override
  void onClose() {
    /// BASIC INFO
    firstNameController.dispose();
    lastNameController.dispose();

    /// ACCOUNT INFO
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    

    /// VERIFICATION
    otpController.dispose();

    super.onClose();
  }
}