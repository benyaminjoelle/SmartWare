import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/core/constants/app_colors.dart';
import 'package:smartware/features/auth/models/auth_repo.dart';

import 'package:smartware/widgets/app_dialog.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class OwnerSignupController extends GetxController {
  /// =========================================================
  /// REPOSITORY
  /// =========================================================
  final AuthRepo _authRepo = AuthRepo();

  /// =========================================================
  /// FORM KEY
  /// =========================================================
  final ownerSignupKey = GlobalKey<FormState>();

  /// =========================================================
  /// BASIC INFO
  /// =========================================================
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  /// =========================================================
  /// ACCOUNT INFO
  /// =========================================================
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  /// =========================================================
  /// VERIFICATION DATA & STATE (REQUIRED FOR USERVERIFICATION VIEW)
  /// =========================================================
  final otpController = TextEditingController();
  final registeredEmail =
      ''.obs; // Track the successfully registered email as an RxString
  final isResendEnabled = true.obs;
  final secondsRemaining = 60.obs;
  Timer? _timer;

  /// =========================================================
  /// OBSERVABLES
  /// =========================================================
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

  /// =========================================================
  /// PASSWORD VISIBILITY
  /// =========================================================

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  /// =========================================================
  /// VALIDATION
  /// =========================================================

  bool validateOwner() {
    return ownerSignupKey.currentState?.validate() ?? false;
  }

  /// =========================================================
  /// REGISTER
  /// =========================================================
  Future<void> continueToVerify() async {
    if (!validateOwner()) {
      AppSnackbar.show(
        title: "Invalid Data".tr,
        message: "Please check your inputs".tr,
        icon: Icons.warning_amber_rounded,
        iconColor: AppColors.error,
      );
      return;
    }

    try {
      isLoading.value = true;

      final userData = {
        'first_name': firstNameController.text.trim(),
        'last_name': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        'phone_number': phoneController.text.trim(),

        'password': passwordController.text,
        'role': 'warehouse_admin',
      };

      print("════════ REGISTER OWNER ════════");
      print("📤 Sending:");
      print(userData);

      final user = await _authRepo.managerRegister(userData);

      print("✅ Registration Success");
      print("🆔 User ID: ${user.id}");
      print("📧 Email: ${user.email}");
      print("🎭 Role: ${user.role}");

      AppSnackbar.show(
        title: "Success".tr,
        message: "Account created successfully".tr,
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
      );
      print("════════ NAVIGATION DATA ════════");
      print("EMAIL = ${user.email}");
      print("PASSWORD = ${passwordController.text}");

      Get.toNamed(
        '/userverification',
        arguments: {
          'email': user.email,
          'password': passwordController.text,
          'isResendEnabled': isResendEnabled,
          'secondsRemaining': secondsRemaining,
          'controller':
              this, // Passes instance for the dynamic bottom sheet type fallback
          'onVerify': () => verifyEmail(),
          'onResend': () => resendCode(),
        },
      );
    } catch (e) {
      print("❌ Registration Error: ");

      AppSnackbar.show(
        title: "Error".tr,
        message: "Registration Error.".tr,
        icon: Icons.error_outline,
        iconColor: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  ///==========================================================
  ///VERIFICATION
  ///==========================================================
  Future<void> verifyEmail() async {
    try {
      isLoading.value = true;
      print("🔍 Verifying email status for: ${registeredEmail.value}");

      // Call backend API check to verify link status or token
      // bool isVerified = await _authRepo.checkEmailVerification(registeredEmail.value);

      // Temporary check simulation:
      AppSnackbar.show(
        title: "Status Check".tr,
        message: "Checking your verification state...".tr,
      );
    } catch (e) {
      AppSnackbar.show(
        title: "Error".tr,
        message: e.toString(),
        iconColor: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendCode() async {
    if (!isResendEnabled.value) return;

    try {
      print("📩 Requesting code resend to: ${registeredEmail.value}");
      // await _authRepo.resendVerificationEmail(registeredEmail.value);

      AppSnackbar.show(
        title: "Sent".tr,
        message: "A new verification link has been sent.".tr,
        icon: Icons.email_outlined,
        iconColor: AppColors.primary,
      );

      startResendTimer(); // Reset the timer countdown
    } catch (e) {
      AppSnackbar.show(
        title: "Error".tr,
        message: e.toString(),
        iconColor: AppColors.error,
      );
    }
  }

  void startResendTimer() {
    isResendEnabled.value = false;
    secondsRemaining.value = 60;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        isResendEnabled.value = true;
        _timer?.cancel();
      }
    });
  }

  /// =========================================================
  /// BACK BUTTON
  /// =========================================================

  Future<void> handleBack() async {
    final result = await AppDialogs.showConfirmDialog(
      title: "Exit signup?".tr,
      message: "Your progress will be lost if you leave now.".tr,
      confirmText: "Exit",
      confirmColor: Colors.red,
    );

    if (result == true) {
      Get.back();
    }
  }

  /// =========================================================
  /// DISPOSE
  /// =========================================================

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();

    emailController.dispose();
    phoneController.dispose();

    passwordController.dispose();
    confirmPasswordController.dispose();

    otpController.dispose();

    super.onClose();
  }
}
