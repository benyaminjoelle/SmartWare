import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/core/constants/app_colors.dart';
import 'package:smartware/features/auth/models/auth_repo.dart';
import 'package:smartware/widgets/app_dialog.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class WorkerSignupController extends GetxController {
  final AuthRepo _authRepo = AuthRepo();

  // ==============TextField Controllers=====================
  final workerKey = GlobalKey<FormState>();
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

  // =========================================================
  // PASSWORD VISIBILITY
  // =========================================================
  void togglePasswordVisibility() =>
      isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  // =========================================================
  // VERIFICATION DATA & STATE
  // =========================================================
  final otpController = TextEditingController();
  final registeredEmail = ''.obs;
  final isResendEnabled = true.obs;
  final secondsRemaining = 60.obs;
  Timer? _timer;

  bool validateWorker() => workerKey.currentState?.validate() ?? false;

  // =========================================================
  // REGISTER
  // =========================================================
  Future<void> continueToVerify() async {
    if (!validateWorker()) {
      AppSnackbar.show(
        title: "Invalid Data".tr,
        message: "Please check your inputs".tr,
        icon: Icons.warning_amber_rounded,
        iconColor: theme.colorScheme.error,
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
        'national_id': natinalIdController.text.trim(),
        'password': passwordController.text,
        'role': 'worker',
      };

      print("════════ REGISTER WORKER ════════");
      print(userData);

      final user = await _authRepo.clientRegister(userData);

      // Save email state locally before moving to verification
      registeredEmail.value = user.email;

      AppSnackbar.show(
        title: "Success".tr,
        message: "Account created successfully".tr,
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
      );

      // Start the resend timer baseline countdown right away
      startResendTimer();

      Get.toNamed(
        '/userverification',
        arguments: {
          'email': user.email,
          'password': passwordController.text, // Passed plain string value
          'isResendabled': isResendEnabled,
          'secondsRemaining': secondsRemaining,
          'controller': this,
          'onVerify': () => verifyEmail(),
          'onResend': () => resendCode(),
        },
      );
    } catch (e) {
      print("❌ Registration Error: $e");
      AppSnackbar.show(
        title: "Error".tr,
        message: e.toString(),
        icon: Icons.error_outline,
        iconColor: AppColors.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================================================
  // VERIFICATION
  // ==========================================================
  Future<void> verifyEmail() async {
    try {
      isLoading.value = true;
      print("🔍 Verifying email status for: ${registeredEmail.value}");
      // Dynamic verification mapping goes here
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

      startResendTimer();
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

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    natinalIdController.dispose();
    otpController.dispose();
    _timer?.cancel();
    super.onClose();
  }
}
