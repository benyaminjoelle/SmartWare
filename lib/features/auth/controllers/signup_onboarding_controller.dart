import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storex/core/constants/app_colors.dart';
import 'package:storex/features/auth/widgets/role_data.dart';
import 'package:storex/widgets/app_snackbar.dart';

class SignupOnboardingController extends GetxController {
  
  final Rxn<AccountType> selectedType = Rxn<AccountType>();

  void selectRole(AccountType type) {
    selectedType.value = type;
  }
  void clearSelection() {
    selectedType.value = null;
  }

  bool isSelected(AccountType type) {
    return selectedType.value == type;
  }

  void continueSignup() {
    final selected = selectedType.value;
if (selected == null) {
  AppSnackbar.show(
    title: "Selection Required".tr,
    message: "Please choose an account type".tr,
    icon: Icons.warning_amber_rounded,
    iconColor:AppColors.error
  );
  return;
}

    switch (selected) {
      case AccountType.client:
        Get.toNamed('/clientShell');
        break;

      case AccountType.warehouseOwner:
        Get.toNamed('/warehouse-owner-signup');
        break;
    }
  }
}