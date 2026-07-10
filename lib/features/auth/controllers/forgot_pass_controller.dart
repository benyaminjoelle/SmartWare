import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/core/utils/pref_helper.dart';
import 'package:smartware/features/auth/models/auth_repo.dart';
import 'package:smartware/features/auth/models/user_model.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class ForgotPassController extends GetxController {
  final AuthRepo _authRepo = AuthRepo();

  //------------TextField Controllers-----------------
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final editEmailController = TextEditingController();

  final passwordKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  
  //------------States & Variables-----------------
  var isLoading = false.obs; 
  var email = "user@example.com".obs; 
  var token = "";
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
    secondsRemaining.value = 60; // Cleaned up testing offset
    
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
  Future<void> changeEmail(String newEmail) async {
    try {
      isLoading.value = true;

      final userId = await PrefHelper.getUserId();

      if (userId == null) {
        throw Exception("User ID not found in local storage");
      }

      await _authRepo.changeEmail(userId: userId, email: newEmail);

      email.value = newEmail;

      await PrefHelper.saveUserEmail(newEmail);

      AppSnackbar.show(
        position: SnackPosition.TOP,
        title: "Email Updated".tr,
        message: "Your email has been changed successfully.".tr,
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

  ///=================RESEND CODE FUNCTION=================
  Future<void> resendCode() async {
    if (!isResendEnabled.value) return;

    try {
      isLoading.value = true;

      await _authRepo.resendVerificationEmail(email: email.value);

      startResendTimer();

      AppSnackbar.show(
        position: SnackPosition.TOP,
        title: "Email Sent".tr,
        message: "A new verification email has been sent.".tr,
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
  Future<void> sendForgotPasswordLink() async {
    try {
      isLoading.value = true;
      email.value = emailController.text.trim();

      await _authRepo.sendPasswordResetEmail(email: email.value);      
      Get.toNamed('/verifyEmail', arguments: {'email': email.value});
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
  Future<void> verifyEmail() async {
    try {
      isLoading.value = true;

      final String verificationToken = codeController.text.trim();

      if (verificationToken.isEmpty){
        throw ApiError(message: 'Please click the verification link sent to your email.'.tr); 
      }

      final responseMap = await _authRepo.verifyResetToken(
        email: email.value,
        token: verificationToken,
      );
      final user = UserModel.fromJson(responseMap, token: verificationToken);
      
      token = verificationToken;

      await PrefHelper.saveUserEmail(email.value);

      if (user.token != null) {
        await PrefHelper.saveToken(user.token!);
      }
      
      await PrefHelper.saveUserId(user.id);
      await PrefHelper.saveUserName('${user.firstName} ${user.lastName}');
      await PrefHelper.saveUserEmail(user.email);
      await PrefHelper.saveUserPhone(user.phoneNumber);
      await PrefHelper.saveBusinessName(user.businessName);

      print("✅ TOKEN = ${user.token}");

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
  Future<void> updatePassword() async {
    try {
      isLoading.value = true;

      final String newPass = newPasswordController.text;
      final String confirmPass = confirmPasswordController.text;
      
      await _authRepo.changePassword(
        newPassword: newPass,
        confirmPassword: confirmPass
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
    editEmailController.dispose();
    timer?.cancel();
    super.onClose();
  }
}