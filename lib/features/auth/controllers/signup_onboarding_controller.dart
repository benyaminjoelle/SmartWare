import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/core/constants/app_colors.dart';
import 'package:smartware/core/utils/pref_helper.dart';
import 'package:smartware/features/auth/models/auth_repo.dart';
import 'package:smartware/features/auth/models/user_model.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class SignupOnboardingController extends GetxController {
  final AuthRepo _authRepo = AuthRepo();

  final Rxn<UserRole> selectedType = Rxn<UserRole>();
  final emailController = TextEditingController();
  var password = '';
  var email = "user@example.com".obs;
  final formKey = GlobalKey<FormState>();

  ThemeData get theme => Get.theme;

  void selectRole(UserRole type) {
    selectedType.value = type;
  }

  void clearSelection() {
    selectedType.value = null;
  }

  bool isSelected(UserRole type) {
    return selectedType.value == type;
  }

  void continueSignup() {
    final selected = selectedType.value;
    if (selected == null) {
      AppSnackbar.show(
        title: "Selection Required".tr,
        message: "Please choose an account type".tr,
        icon: Icons.warning_amber_rounded,
        iconColor: AppColors.error,
      );
      return;
    }

    switch (selected) {
      case UserRole.client:
        Get.toNamed('/clientSignup');
        break;

      case UserRole.warehouseAdmin:
        Get.toNamed('/ownerSignup');
        break;

      case UserRole.worker:
        Get.toNamed('/workerSignup');
        break;
    }
  }

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
  }

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

  //------------states -----------------
  var isLoading = false.obs;
}
