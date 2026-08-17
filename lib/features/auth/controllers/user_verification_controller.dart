import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/core/utils/pref_helper.dart';
import 'package:smartware/features/auth/models/auth_repo.dart';
import 'package:smartware/features/auth/models/user_model.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class UserVerificationController extends GetxController {
  // ============================================================
  // REPOSITORY
  // ============================================================

  final AuthRepo _authRepo = AuthRepo();

  // ============================================================
  // USER DATA
  // ============================================================

  final email = ''.obs;

  String password = '';

  // ============================================================
  // STATE
  // ============================================================

  final isLoading = false.obs;

  // ============================================================
  // RESEND TIMER
  // ============================================================

  Timer? _timer;

  final secondsRemaining = 60.obs;

  final isResendEnabled = true.obs;

  ThemeData get theme => Get.theme;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    print('');
    print('════════ VERIFY SCREEN ARGS ════════');
    print('📦 Arguments = ${Get.arguments}');

    final args = Get.arguments;

    if (args != null && args is Map) {
      email.value = args['email']?.toString() ?? '';

      password = args['password']?.toString() ?? '';
    }

    print('📧 EMAIL    = ${email.value}');
    print('🔐 PASSWORD = ${password.isNotEmpty ? "********" : "EMPTY"}');

    print('═══════════════════════════════════');

    startResendTimer();
  }

  // ============================================================
  // RESEND TIMER
  // ============================================================

  void startResendTimer() {
    isResendEnabled.value = false;

    secondsRemaining.value = 60;

    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (secondsRemaining.value > 0) {
          secondsRemaining.value--;
        } else {
          isResendEnabled.value = true;
          _timer?.cancel();
        }
      },
    );
  }

  // ============================================================
  // CHANGE EMAIL
  // ============================================================

  Future<void> changeEmail(String newEmail) async {
    try {
      isLoading.value = true;

      final userId = await PrefHelper.getUserId();

      if (userId == null) {
        throw Exception(
          'User ID not found in local storage.',
        );
      }

      await _authRepo.changeEmail(
        userId: userId,
        email: newEmail,
      );

      email.value = newEmail;

      await PrefHelper.saveUserEmail(newEmail);

      AppSnackbar.show(
        title: "Email Updated".tr,
        message:
            "Your email has been changed successfully.".tr,
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
      );
    } catch (e) {
      print('❌ CHANGE EMAIL ERROR: $e');

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

  // ============================================================
  // RESEND VERIFICATION EMAIL
  // ============================================================

  Future<void> resendCode() async {
    if (!isResendEnabled.value) {
      return;
    }

    try {
      isLoading.value = true;

      print('📩 Resending verification email...');
      print('📧 Email = ${email.value}');

      await _authRepo.resendVerificationEmail(
        email: email.value,
      );

      startResendTimer();

      AppSnackbar.show(
        title: "Email Sent".tr,
        message:
            "A new verification email has been sent.".tr,
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
      );
    } catch (e) {
      print('❌ RESEND ERROR: $e');

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

  // ============================================================
  // VERIFY EMAIL
  // ============================================================

  Future<void> verifyEmail() async {
    try {
      isLoading.value = true;

      print('');
      print('════════ VERIFIED LOGIN START ════════');
      print('📧 Email = ${email.value}');

      // ========================================================
      // CALL BACKEND
      // ========================================================

      final UserModel user =
          await _authRepo.verifiedLogin(
        email: email.value,
        password: password,
      );

      // ========================================================
      // PRINT USER
      // ========================================================

      print('');
      print('════════ VERIFIED USER RECEIVED ════════');
      print('🆔 ID       = ${user.id}');
      print('👤 NAME     = ${user.firstName} ${user.lastName}');
      print('📧 EMAIL    = ${user.email}');
      print('📱 PHONE    = ${user.phoneNumber}');
      print('🎭 ROLE     = ${user.role}');
      print('🔑 TOKEN    = ${user.token}');

      // ========================================================
      // MAKE SURE TOKEN EXISTS
      // ========================================================

      if (user.token == null || user.token!.isEmpty) {
        throw Exception(
          'Email verification succeeded but no authentication token was returned.',
        );
      }

      // ========================================================
      // SAVE TOKEN
      // ========================================================

      await PrefHelper.saveToken(user.token!);

      // ========================================================
      // READ TOKEN AGAIN
      // ========================================================

      final savedToken =
          await PrefHelper.getToken();

      print('');
      print('════════ VERIFICATION TOKEN TEST ════════');
      print('🔑 API TOKEN   = ${user.token}');
      print('💾 SAVED TOKEN = $savedToken');
      print('✅ MATCH       = ${user.token == savedToken}');
      print('════════════════════════════════════════');

      if (savedToken == null || savedToken.isEmpty) {
        throw Exception(
          'Token was returned but could not be saved locally.',
        );
      }
await PrefHelper.saveUserRole(user.role.name);
      // ========================================================
      // SAVE USER DATA
      // ========================================================

      await PrefHelper.saveUserId(user.id);

      await PrefHelper.saveUserName(
        '${user.firstName} ${user.lastName}',
      );

      await PrefHelper.saveUserEmail(user.email);

      await PrefHelper.saveUserPhone(user.phoneNumber);

      



      // ========================================================
      // DEBUG EVERYTHING
      // ========================================================

      await PrefHelper.debugUserData();

      // ========================================================
      // SUCCESS
      // ========================================================

      AppSnackbar.show(
        title: "Success".tr,
        message:
            "Email verified successfully".tr,
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
      );

      print('════════ VERIFICATION SUCCESS ════════');

      // ========================================================
      // NAVIGATION
      // ========================================================

      switch (user.role) {
        case UserRole.warehouseAdmin:
          Get.offAllNamed('/ownerRoot');
          break;

        case UserRole.worker:
          Get.offAllNamed('/workerRoot');
          break;

        case UserRole.client:
          Get.offAllNamed('/clientRoot');
          break;
      }
    } catch (e) {
      print('');
      print('════════ VERIFICATION ERROR ════════');
      print('❌ Error = $e');
      print('❌ Type  = ${e.runtimeType}');
      print('════════════════════════════════════');

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

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    _timer?.cancel();

    super.onClose();
  }
}