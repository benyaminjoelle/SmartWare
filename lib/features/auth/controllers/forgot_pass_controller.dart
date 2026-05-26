import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storex/features/auth/views/login/verify_Code.dart';
import 'package:storex/features/onboarding/widgets/top_snackbar.dart';


class ForgotPassController extends GetxController{
  //------------TextField Controllers-----------------
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final passwordKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();

  ThemeData get theme => Get.theme;

  //-------Timer-----------
  Timer? timer;
  var secondsRemaining = 60.obs;
  var isResendEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    startResendTimer();
  }

  void startResendTimer(){
    isResendEnabled.value = false;
    secondsRemaining.value += 10; //reset for 60 after testing
    //cancel any timers if already running
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        isResendEnabled.value = true;
        timer.cancel();
      }
    });
  }
  Future<void> resendCode() async {
    if(!isResendEnabled.value) return;

    try {
      // 1. Trigger your backend resend API request here
      // await _authService.resendCode(emailController.text);
      startResendTimer();
      TopSnackbar.show(
        title: "Code Resent",
        message: "A new verification code has been sent to your email.",
        icon: Icons.check_circle_outline,
        iconColor: theme.colorScheme.tertiary,
      );
    } catch (e) {
      TopSnackbar.show(
        title: "Error",
        message: "Failed to resend code. Please try again.",
        icon: Icons.error_outline,
        iconColor: theme.colorScheme.error,
      );
    }
  }

  //------------states -----------------
  var isLoading = false.obs;
  
  // --- Step 1: Send Email API ---
  Future<void> sendVerificationEmail() async {
    try {
      isLoading.value = true;
      // Your API logic here using emailController.text
      
      // On success, move to the OTP Screen
      Get.toNamed('/verifyCode');
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // --- Step 2: Verify OTP API ---
  Future<void> verifyCode() async {
    try {
      isLoading.value = true;
      // Your API logic here using codeController.text
      
      // On success, move to Reset Password Screen
      Get.toNamed('/resetPassword');
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // --- Step 3: Reset Password API ---
  Future<void> updatePassword() async {
    try {
      isLoading.value = true;
      // Your API logic here using newPasswordController.text
      
      // Flow finished! Clear data and go back to Login Screen
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    codeController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    timer?.cancel();
    super.onClose();
  }
}