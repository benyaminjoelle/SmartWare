import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/utils/pref_helper.dart';
import 'package:smartware/features/auth/models/auth_repo.dart';
import 'package:smartware/features/auth/models/user_model.dart';
import 'package:smartware/features/auth/views/login/verify_code.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class ForgotPassController extends GetxController {
  final AuthRepo _authRepo = AuthRepo();

  //------------TextField Controllers-----------------
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  // final editEmailController = TextEditingController();

  final passwordKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  
  //------------States & Variables-----------------
  var isLoading = false.obs; 
  var email = "user@example.com".obs; 
  var otp = "";
  var password = '';

  ThemeData get theme => Get.theme;

  //-------Timer-----------
  Timer? timer;
  var secondsRemaining = 60.obs;
  var isResendEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();

    print("════════ VERIFY SCREEN ARGS ════════");
    print(Get.arguments);

    final args = Get.arguments;

    if (args != null) {
      email.value = args['email'] ?? '';
      password = args['password'] ?? '';
    }

    print("EMAIL = $email");
    print("PASSWORD = $password");

    startResendTimer();
  }

  void startResendTimer() {
    isResendEnabled.value = false;
    secondsRemaining.value = 60; 
    
    // cancel any timers if already running
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

  ///=================CHANGE EMAIL FUNCTION=================
  ///wont use anymore
  // Future<void> changeEmail(String newEmail) async {
  //   try {
  //     isLoading.value = true;

  //     final userId = await PrefHelper.getUserId();

  //     if (userId == null) {
  //       throw Exception("User ID not found in local storage");
  //     }

  //     await _authRepo.changeEmail(userId: userId, email: newEmail);

  //     email.value = newEmail;

  //     await PrefHelper.saveUserEmail(newEmail);

  //     AppSnackbar.show(
  //       position: SnackPosition.TOP,
  //       title: "Email Updated".tr,
  //       message: "Your email has been changed successfully.".tr,
  //       icon: Icons.check_circle_outline,
  //       iconColor: Colors.green,
  //     );
  //   } catch (e) {
  //     AppSnackbar.show(
  //       position: SnackPosition.TOP,
  //       title: "Error".tr,
  //       message: e.toString(),
  //       icon: Icons.error_outline,
  //       iconColor: theme.colorScheme.error,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  ///=================RESEND CODE FUNCTION=================
  Future<void> resendCode() async {
    if (!isResendEnabled.value) return;

    try {
      isLoading.value = true;

      await _authRepo.forgotPassword(email: email.value);

      startResendTimer();

      AppSnackbar.show(
        position: SnackPosition.TOP,
        title: "Email Sent".tr,
        message: "A new verification code has been sent.".tr,
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
      );
    } catch (e) {
      AppSnackbar.show(
        position: SnackPosition.TOP,
        title: "Error".tr,
        message: e.toString(),
        icon: Icons.error_outline,
        iconColor: theme.colorScheme.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  //============ Step 1: Send Password Recovery Link ===========
  Future<void> sendCode() async {
    try {
      isLoading.value = true;
      email.value = emailController.text.trim();

      await _authRepo.forgotPassword(email: email.value);      
      Get.toNamed('/verifyCode');
    } catch (e) {
      AppSnackbar.show(
        position: SnackPosition.TOP,
        title: "Error".tr, 
        message: e.toString(), 
        icon: Icons.error_outline,
        iconColor: theme.colorScheme.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  //========== Step 2: Verify Email ==============
  Future<void> verifyCode() async {
    try {
      isLoading.value = true;

      final String otp = codeController.text.trim();
      final String email = emailController.text.trim();

      if (otp.isEmpty || otp.length < 6) {
        throw ApiError(message: 'Please check the code sent to your email.'.tr); 
      }

      final responseMap = await _authRepo.verifyOtp(
        email: email,
        otp: otp,
      );
      // final user = UserModel.fromJson(responseMap);
      

      await PrefHelper.saveUserEmail(email);

      // print("✅ TOKEN = ${user.token}");

      Get.toNamed('/resetPassword');
    } catch (e) {
      AppSnackbar.show(
        position: SnackPosition.TOP,
        title: "Verification Failed".tr,
        message: e.toString(),
        icon: Icons.error_outline,
        iconColor: theme.colorScheme.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  //=========== Step 3: Reset Password API ===============
  Future<void> passwordReset() async {
    try {
      isLoading.value = true;

      final String newPassword = newPasswordController.text;
      final String email = emailController.text;
      final String otp = codeController.text.trim();

      await _authRepo.passwordReset(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );

      AppSnackbar.show(
        position: SnackPosition.TOP,
        title: "Success".tr,
        message: "Password changed successfully!".tr,
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
      );
      
      Get.offAllNamed('/login');
    } catch (e) {
      AppSnackbar.show(
        position: SnackPosition.TOP,
        title: "Error".tr, 
        message: e.toString(),
        icon: Icons.error_outline,
        iconColor: theme.colorScheme.error,
      );
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
    // editEmailController.dispose();
    timer?.cancel();
    super.onClose();
  }
}