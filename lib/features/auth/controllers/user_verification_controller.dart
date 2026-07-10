import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/core/utils/pref_helper.dart';
import 'package:smartware/features/auth/models/auth_repo.dart';
import 'package:smartware/features/auth/models/user_model.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class UserVerificationController extends GetxController {
  ///===============REPOSITORY=================
  final AuthRepo _authRepo = AuthRepo();

  ///===============OBSERVABLES=================
  final email = "".obs;
  String password = "";
  final isLoading = false.obs;

  ///===============TIMER FOR RESEND=================
  Timer? _timer;
  final secondsRemaining = 60.obs;
  final isResendEnabled = true.obs;

  ThemeData get theme => Get.theme;

  @override
  void onInit() {
    super.onInit();

    print("════════ VERIFY SCREEN ARGS ════════");
    print(Get.arguments);

    // Safely collect plain string parameters
    final args = Get.arguments;
    if (args != null && args is Map) {
      email.value = args['email'] ?? '';
      password = args['password'] ?? '';
    }
    print("EMAIL = $email");
    print("PASSWORD = $password");

    startResendTimer();
  }

  void startResendTimer() {
    isResendEnabled.value = false;
    secondsRemaining.value = 60; // Clean baseline reset
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

  Future<void> changeEmail(String newEmail) async {
    try {
      isLoading.value = true;
      final userId = await PrefHelper.getUserId();
      if (userId == null) throw Exception("User ID not found in local storage");

      await _authRepo.changeEmail(userId: userId, email: newEmail);
      email.value = newEmail;
      await PrefHelper.saveUserEmail(newEmail);

      AppSnackbar.show(
        title: "Email Updated".tr,
        message: "Your email has been changed successfully.".tr,
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
      );
    } catch (e) {
      AppSnackbar.show(
        title: "Error".tr,
        message: e.toString(),
        icon: Icons.error_outline,
        iconColor: theme.colorScheme.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendCode() async {
    if (!isResendEnabled.value) return;
    try {
      isLoading.value = true;
      await _authRepo.resendVerificationEmail(email: email.value);
      startResendTimer();
      AppSnackbar.show(
        title: "Email Sent".tr,
        message: "A new verification email has been sent.".tr,
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
      );
    } catch (e) {
      AppSnackbar.show(
        title: "Error",
        message: e.toString(),
        icon: Icons.error_outline,
        iconColor: theme.colorScheme.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyEmail() async {
    try {
      isLoading.value = true;
      final user = await _authRepo.verifiedLogin(
        email: email.value,
        password: password,
      );

      if (user.token != null) await PrefHelper.saveToken(user.token!);
      await PrefHelper.saveUserId(user.id);
      await PrefHelper.saveUserName('${user.firstName} ${user.lastName}');
      await PrefHelper.saveUserEmail(user.email);
      await PrefHelper.saveUserPhone(user.phoneNumber);
      await PrefHelper.saveBusinessName(user.businessName);

      AppSnackbar.show(
        title: "Success".tr,
        message: "Email verified successfully".tr,
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
      );
      print("✅ TOKEN = ${user.token}");

      ///==================NAVIGATION BASED ON ROLE=================
      switch (user.role) {
        case UserRole.warehouseAdmin:
          Get.offAllNamed('/ownerHome');
          throw UnimplementedError();
        case UserRole.worker:
          throw UnimplementedError();
        case UserRole.client:
          Get.offAllNamed('/clientHome');
          throw UnimplementedError();
      }

      ///===========================================================
    } catch (e) {
      AppSnackbar.show(
        title: "Verification Failed".tr,
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
    _timer?.cancel(); // Critical to prevent memory leaks!
    super.onClose();
  }
}
