import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/core/network/api_error.dart';
import 'package:smartware/features/auth/models/auth_repo.dart';
import 'package:smartware/features/client/profile/models/client_onboarding_repo.dart';

import 'package:smartware/features/client/profile/widgets/change_business_name.dart';
import 'package:smartware/features/client/profile/widgets/change_email.dart';
import 'package:smartware/features/client/profile/widgets/change_password.dart';
import 'package:smartware/features/client/profile/widgets/change_phone.dart';
import 'package:smartware/features/client/profile/widgets/change_preferences.dart';
import 'package:smartware/features/client/profile/widgets/verify_new_email.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class ClientEditProfileController extends GetxController {
  // ============================================================
  // REPOSITORIES
  // ============================================================

  final AuthRepo _authRepo = AuthRepo();
  final ClientOnboardingRepo _clientOnboardingRepo =
      ClientOnboardingRepo();

  // ============================================================
  // PROFILE DATA
  // ============================================================

  final RxString businessName = ''.obs;
  final RxString selectedBusinessName = ''.obs;
  final RxString email = ''.obs;
  final RxString pendingEmail = ''.obs;
  final RxString phone = ''.obs;

  // ============================================================
  // LOADING
  // ============================================================

  final RxBool isLoading = false.obs;

  // ============================================================
  // FORM KEYS
  // ============================================================

  final changeEmailFormKey = GlobalKey<FormState>();
  final personalInfoFormKey = GlobalKey<FormState>();
  final contactSecurityFormKey = GlobalKey<FormState>();

  // ============================================================
  // TEXT CONTROLLERS
  // ============================================================

  late final TextEditingController businessNameController;
  late final TextEditingController emailController;
  late final TextEditingController newEmailController;
  late final TextEditingController phoneController;

  final passwordController = TextEditingController();
  final verificationCodeController = TextEditingController();

  // ============================================================
  // EMAIL VERIFICATION
  // ============================================================

  Timer? timer;

  final RxInt secondsRemaining = 60.obs;
  final RxBool isResendEnabled = false.obs;

  // ============================================================
  // PASSWORD
  // ============================================================

  final RxBool obscurePassword = true.obs;

  // ============================================================
  // TEST BUSINESSES
  // ============================================================

  final List<String> businesses = [
    'Bella Restaurant',
    'Fresh Market',
    'Tech Store',
  ];

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    businessNameController = TextEditingController(
      text: businessName.value,
    );

    emailController = TextEditingController(
      text: email.value,
    );

    newEmailController = TextEditingController();

    phoneController = TextEditingController(
      text: phone.value,
    );
  }

  // ============================================================
  // EMAIL RESEND TIMER
  // ============================================================

  void startResendTimer() {
    isResendEnabled.value = false;
    secondsRemaining.value = 60;

    timer?.cancel();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (secondsRemaining.value > 0) {
          secondsRemaining.value--;
        } else {
          isResendEnabled.value = true;
          timer.cancel();
        }
      },
    );
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  void goToEmail() {
    newEmailController.clear();

    Get.to(
      () => ChangeEmail(),
    );
  }

  void goToPhone() {
    Get.to(
      () => ChangePhone(),
    );
  }

  void goToPassword() {
    Get.to(
      () => ChangePassword(),
    );
  }

  void goToPreferences() {
    Get.to(
      () => const ChangePreferences(),
    );
  }

  void goToBusiness() {
    Get.to(
      () => ChangeBusinessName(),
    );
  }

  void goToEmailVerification() {
    Get.to(
      () => const VerifyNewEmail(),
    );

    startResendTimer();
  }

  // ============================================================
  // FRIENDLY ERROR MESSAGE
  // ============================================================

  String _getFriendlyErrorMessage(dynamic error) {
    String msg = '';

    if (error is ApiError) {
      msg = error.message;
    } else {
      msg = error.toString().replaceAll(
        'Exception: ',
        '',
      );
    }

    if (msg.contains('email_already_exists') ||
        msg.contains('taken')) {
      return 'This email address is already registered to another account.'
          .tr;
    }

    if (msg.contains('phone_already_exists') ||
        msg.contains('phone_number_taken')) {
      return 'This phone number is already registered to another account.'
          .tr;
    }

    return msg.tr;
  }

  // ============================================================
  // CHANGE PHONE NUMBER
  // ============================================================

  Future<void> changePhoneNumber() async {
    final newPhone = phoneController.text.trim();

    // ============================================================
    // REQUIRED VALIDATION
    // ============================================================

    if (newPhone.isEmpty) {
      AppSnackbar.show(
        title: 'Required'.tr,
        message: 'Please enter your phone number'.tr,
        icon: Icons.warning_amber_rounded,
      );

      return;
    }

    // ============================================================
    // PHONE FORMAT VALIDATION
    // 09XXXXXXXX = 10 DIGITS
    // ============================================================

    final phoneRegex = RegExp(
      r'^09\d{8}$',
    );

    if (!phoneRegex.hasMatch(newPhone)) {
      AppSnackbar.show(
        title: 'Invalid Phone Number'.tr,
        message:
            'Please enter a valid phone number starting with 09 and containing 10 digits'
                .tr,
        icon: Icons.warning_amber_rounded,
      );

      return;
    }

    // ============================================================
    // SAME NUMBER VALIDATION
    // ============================================================

    if (newPhone == phone.value) {
      AppSnackbar.show(
        title: 'No Changes'.tr,
        message: 'Please enter a different phone number'.tr,
        icon: Icons.info_outline,
      );

      return;
    }

    // ============================================================
    // API REQUEST
    // ============================================================

    isLoading.value = true;

    try {
      print('');
      print('════════ CONTROLLER CHANGE PHONE ════════');
      print('📱 New Phone: $newPhone');

      final result =
          await _clientOnboardingRepo.changePhoneNumber(
        phoneNumber: newPhone,
      );

      // ============================================================
      // UPDATE LOCAL DATA
      // ============================================================

      phone.value = result.phoneNumber;

      phoneController.text = result.phoneNumber;

      print('✅ Phone Updated: ${result.phoneNumber}');
      print('════════════════════════════════════════');

      // ============================================================
      // CLOSE CHANGE PHONE SCREEN
      // ============================================================

      Get.back();

      // ============================================================
      // SUCCESS MESSAGE
      // ============================================================

      AppSnackbar.show(
        title: 'Phone Number Updated'.tr,
        message: result.message.tr,
        icon: Icons.check_circle_outline,
      );
    } catch (e) {
      print('');
      print('════════ CONTROLLER PHONE ERROR ════════');
      print('❌ Error: $e');
      print('════════════════════════════════════════');

      AppSnackbar.show(
        title: 'Phone Number Update Failed'.tr,
        message: _getFriendlyErrorMessage(e),
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // SEND EMAIL CHANGE REQUEST
  // ============================================================

  Future<void> sendEmailChangeRequest() async {
    if (changeEmailFormKey.currentState?.validate() != true) {
      return;
    }

    final targetEmail = newEmailController.text.trim();

    // ============================================================
    // SAME EMAIL VALIDATION
    // ============================================================

    if (targetEmail == email.value) {
      AppSnackbar.show(
        title: 'No Changes'.tr,
        message:
            'Please enter a different email address'.tr,
        icon: Icons.info_outline,
      );

      return;
    }

    // ============================================================
    // API REQUEST
    // ============================================================

    isLoading.value = true;

    try {
      await _authRepo.requestClientEmailChange(
        email: targetEmail,
      );

      pendingEmail.value = targetEmail;

      goToEmailVerification();

      AppSnackbar.show(
        title: 'Verification Link Sent'.tr,
        message:
            'We sent a verification link to your new email address.'
                .tr,
        icon: Icons.mark_email_read_outlined,
      );
    } catch (e) {
      AppSnackbar.show(
        title: 'Email Request Failed'.tr,
        message: _getFriendlyErrorMessage(e),
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // VERIFY NEW EMAIL
  // ============================================================

  Future<void> verifyNewEmail() async {
    isLoading.value = true;

    try {
      email.value = pendingEmail.value;

      emailController.text = pendingEmail.value;

      pendingEmail.value = '';

      timer?.cancel();

      Get.back();
      Get.back();

      AppSnackbar.show(
        title: 'Email Updated'.tr,
        message:
            'Your email address was updated successfully'.tr,
        icon: Icons.check_circle_outline,
      );
    } catch (e) {
      AppSnackbar.show(
        title: 'Error'.tr,
        message: _getFriendlyErrorMessage(e),
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // RESEND EMAIL VERIFICATION
  // ============================================================

  Future<void> resendEmailCode() async {
    if (!isResendEnabled.value) {
      return;
    }

    isLoading.value = true;

    try {
      await _authRepo.requestClientEmailChange(
        email: pendingEmail.value,
      );

      startResendTimer();

      AppSnackbar.show(
        title: 'Email Sent'.tr,
        message:
            'A new verification link has been sent to your email'
                .tr,
        icon: Icons.email_outlined,
      );
    } catch (e) {
      AppSnackbar.show(
        title: 'Resend Failed'.tr,
        message: _getFriendlyErrorMessage(e),
        icon: Icons.error_outline,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // SAVE PERSONAL INFO
  // ============================================================

  Future<void> savePersonalInfo() async {
    if (personalInfoFormKey.currentState?.validate() != true) {
      return;
    }

    isLoading.value = true;

    try {
      await Future.delayed(
        const Duration(milliseconds: 600),
      );

      businessName.value =
          businessNameController.text.trim();

      Get.back();

      Get.snackbar(
        'Success'.tr,
        'Personal info updated'.tr,
      );
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Something went wrong. Please try again'.tr,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // SAVE CONTACT & SECURITY
  // ============================================================

  Future<void> saveContactSecurity() async {
    if (contactSecurityFormKey.currentState?.validate() !=
        true) {
      return;
    }

    isLoading.value = true;

    try {
      await Future.delayed(
        const Duration(milliseconds: 600),
      );

      email.value = emailController.text.trim();

      phone.value = phoneController.text.trim();

      passwordController.clear();

      Get.back();

      Get.snackbar(
        'Success'.tr,
        'Contact & security updated'.tr,
      );
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Something went wrong. Please try again'.tr,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // SAVE PREFERENCES
  // ============================================================

  Future<void> savePreferences() async {
    isLoading.value = true;

    try {
      await Future.delayed(
        const Duration(milliseconds: 600),
      );

      Get.back();

      Get.snackbar(
        'Success'.tr,
        'Preferences updated'.tr,
      );
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Something went wrong. Please try again'.tr,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // PASSWORD VISIBILITY
  // ============================================================

  void togglePasswordVisibility() {
    obscurePassword.value =
        !obscurePassword.value;
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    businessNameController.dispose();
    emailController.dispose();
    newEmailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    verificationCodeController.dispose();

    timer?.cancel();

    super.onClose();
  }
}