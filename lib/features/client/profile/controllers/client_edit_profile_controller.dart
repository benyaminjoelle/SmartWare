import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/profile/widgets/change_business_name.dart';
import 'package:smartware/features/client/profile/widgets/change_email.dart';
import 'package:smartware/features/client/profile/widgets/change_password.dart';
import 'package:smartware/features/client/profile/widgets/change_phone.dart';
import 'package:smartware/features/client/profile/widgets/change_preferences.dart';
import 'package:smartware/features/client/profile/widgets/verify_new_email.dart';

class ClientEditProfileController extends GetxController {
  final RxString businessName = ''.obs;
  final RxString selectedBusinessName = ''.obs;
  final RxString email = ''.obs;
  final RxString pendingEmail = ''.obs;
  final RxString phone = ''.obs;

  final RxBool isLoading = false.obs;

  final personalInfoFormKey = GlobalKey<FormState>();
  final contactSecurityFormKey = GlobalKey<FormState>();

  late final TextEditingController businessNameController;

  Timer? timer;

  final RxInt secondsRemaining = 60.obs;

  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  final passwordController = TextEditingController();
  final TextEditingController verificationCodeController =
      TextEditingController();

  final RxBool isResendEnabled = false.obs;
  final RxBool obscurePassword = true.obs;
  final List<String> businesses = [
    'Bella Restaurant',
    'Fresh Market',
    'Tech Store',
  ];
  @override
  void onInit() {
    super.onInit();

    businessNameController = TextEditingController(text: businessName.value);

    emailController = TextEditingController(text: email.value);

    phoneController = TextEditingController(text: phone.value);
  }

  void startResendTimer() {
    isResendEnabled.value = false;
    secondsRemaining.value = 60;

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

  void goToEmail() {
    Get.to(() => ChangeEmail());
    startResendTimer();
  }

  void goToPhone() {
    Get.to(() => ChangePhone());
  }

  void goToPassword() {
    Get.to(() => ChangePassword());
  }

  void goToPreferences() {
    Get.to(() => const ChangePreferences());
  }

  void goToBusiness() {
    Get.to(() => ChangeBusinessName());
  }

  void goToEmailVerification() {
    Get.to(() => const VerifyNewEmail());
  }

  Future<void> savePersonalInfo() async {
    if (personalInfoFormKey.currentState?.validate() != true) return;

    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 600));

      businessName.value = businessNameController.text.trim();

      Get.back();
      Get.snackbar('Success'.tr, 'Personal info updated'.tr);
    } catch (e) {
      Get.snackbar('Error'.tr, 'Something went wrong. Please try again'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveContactSecurity() async {
    if (contactSecurityFormKey.currentState?.validate() != true) return;

    isLoading.value = true;
    try {
      // TODO: persist via your repository/API. Only send passwordController.text
      // if it's non-empty (treat empty as "no change").
      await Future.delayed(const Duration(milliseconds: 600));

      email.value = emailController.text.trim();
      phone.value = phoneController.text.trim();
      passwordController.clear();

      Get.back();
      Get.snackbar('Success'.tr, 'Contact & security updated'.tr);
    } catch (e) {
      Get.snackbar('Error'.tr, 'Something went wrong. Please try again'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> savePreferences() async {
    isLoading.value = true;
    try {
      // TODO: persist via your repository/API.
      await Future.delayed(const Duration(milliseconds: 600));

      Get.back();
      Get.snackbar('Success'.tr, 'Preferences updated'.tr);
    } catch (e) {
      Get.snackbar('Error'.tr, 'Something went wrong. Please try again'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void verifyNewEmail() {
  final code = verificationCodeController.text.trim();

  if (code.isEmpty || code.length != 6) {
    Get.snackbar(
      'Invalid Code'.tr,
      'Please enter the 6-digit verification code'.tr,
    );
    return;
  }

  // TODO:
  // Verify the code with the backend later.

  email.value = pendingEmail.value;

  pendingEmail.value = '';

  verificationCodeController.clear();

  timer?.cancel();

  Get.back();
  Get.back();

  Get.snackbar(
    'Email Updated'.tr,
    'Your email address was updated successfully'.tr,
  );
}
  void resendEmailCode() {
  if (!isResendEnabled.value) {
    return;
  }

  // TODO:
  // Send a new verification code through the backend.

  startResendTimer();

  Get.snackbar(
    'Code Sent'.tr,
    'A new verification code has been sent'.tr,
  );
}
  @override
  void onClose() {
    businessNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    verificationCodeController.dispose();
    timer?.cancel();
    super.onClose();
  }
}
