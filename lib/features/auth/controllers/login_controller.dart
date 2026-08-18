import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/core/routes/app_routes.dart';
import 'package:smartware/core/utils/pref_helper.dart';
import 'package:smartware/features/auth/models/auth_repo.dart';
import 'package:smartware/features/auth/models/user_model.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class LoginController extends GetxController {
  final AuthRepo _authRepo = AuthRepo();

  final loginFormKey = GlobalKey<FormState>();

  final loginIdentifierController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordHidden = true.obs;

  ThemeData get theme => Get.theme;

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) {
      AppSnackbar.show(
        title: "Invalid Input".tr,
        message: "Please correct the errors in the form.".tr,
        position: SnackPosition.TOP,
        icon: Icons.error_outline,
        iconColor: theme.colorScheme.error,
      );
      return;
    }

    try {
      isLoading.value = true;

      final input = loginIdentifierController.text.trim();
      final password = passwordController.text;

      print('');
      print('════════ LOGIN START ════════');
      print('📧 Login identifier: $input');

      final UserModel user = await _authRepo.login(
        loginIdentifier: input,
        password: password,
      );

      print('');
      print('════════ USER RECEIVED ════════');
      print('🆔 ID       = ${user.id}');
      print('👤 NAME     = ${user.firstName} ${user.lastName}');
      print('📧 EMAIL    = ${user.email}');
      print('📱 PHONE    = ${user.phoneNumber}');
      print('🎭 ROLE     = ${user.role}');
      print('🔑 TOKEN    = ${user.token}');

      // ============================================================
      // SAVE USER DATA
      // ============================================================

      if (user.token == null || user.token!.isEmpty) {
        throw Exception('Login succeeded but no token was returned.');
      }

      await PrefHelper.saveToken(user.token!);
      await PrefHelper.saveUserId(user.id);
      await PrefHelper.saveUserName(
        '${user.firstName} ${user.lastName}',
      );
      await PrefHelper.saveUserEmail(user.email);
      await PrefHelper.saveUserPhone(user.phoneNumber);
      

      // ⭐ THIS WAS MISSING
      await PrefHelper.saveUserRole(
        _roleToStorageString(user.role),
      );

      // ============================================================
      // DEBUG
      // ============================================================

      print('');
      print('════════ SAVED USER DATA ════════');

      await PrefHelper.debugUserData();

      print('════════ LOGIN SUCCESS ════════');
      print('');

      AppSnackbar.show(
        title: "Success".tr,
        message: "Login successful".tr,
        position: SnackPosition.TOP,
        icon: Icons.check_circle_outline,
        iconColor: theme.colorScheme.primary,
      );

      _navigateBasedOnRole(user.role);

    } catch (e) {
      print('');
      print('❌ LOGIN ERROR: $e');

      AppSnackbar.show(
        title: "Error".tr,
        message: e.toString().replaceAll('Exception: ', ''),
        position: SnackPosition.TOP,
        icon: Icons.error_outline,
        iconColor: theme.colorScheme.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // ROLE CONVERSION
  // ============================================================

  String _roleToStorageString(UserRole role) {
    switch (role) {
      case UserRole.client:
        return 'client';

      case UserRole.worker:
        return 'worker';

      case UserRole.warehouseAdmin:
        return 'warehouseAdmin';
    }
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  void _navigateBasedOnRole(UserRole role) {
    switch (role) {
      case UserRole.client:
        Get.offAllNamed(AppRoutes.clientRoot);
        break;

      case UserRole.worker:
        Get.offAllNamed(AppRoutes.workerSignup);
        break;

      case UserRole.warehouseAdmin:
        Get.offAllNamed(AppRoutes.ownerRoot);
        break;
    }
  }

  // ============================================================
  // PASSWORD
  // ============================================================

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    loginIdentifierController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}