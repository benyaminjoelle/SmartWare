import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storex/core/constants/app_colors.dart';
import 'package:storex/widgets/app_dialog.dart';
import 'package:storex/widgets/app_snackbar.dart';


class ClientSignupController extends GetxController {
  /// FORM
  final GlobalKey<FormState> basicInfoFormKey = GlobalKey<FormState>();

  /// TEXT CONTROLLERS
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();

  /// STEP
  final currentStep = 0.obs;
  final int totalSteps = 5;

  late final PageController pageController;

  /// IMAGE
  final Rx<File?> personalPhoto = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    pageController = PageController();
    super.onInit();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    pageController.dispose();
    super.onClose();
  }

  /// VALIDATE FORM (single source of truth)
  bool validateBasicInfo() {
    final formValid =
        basicInfoFormKey.currentState?.validate() ?? false;

    if (!formValid) return false;

    // optional extra rule: photo required (if you want backend-ready strict mode)
    // if (personalPhoto.value == null) return false;

    return true;
  }

  /// NEXT STEP (SAFE + BACKEND READY)
  void nextStep() {
    if (!validateBasicInfo()) {
      AppSnackbar.show(
        title: "Invalid Data",
        message: "Please check your inputs",
        icon: Icons.warning_amber_rounded,
        iconColor: AppColors.error,
      );
      return;
    }

    if (currentStep.value < totalSteps - 1) {
      currentStep.value++;

      pageController.animateToPage(
        currentStep.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;

      pageController.animateToPage(
        currentStep.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
  Future<void> handleBack() async {
  if (currentStep.value == 0) {
   final result = await AppDialogs.showConfirmDialog(
  title: "Exit signup?",
  message: "Your progress will be lost if you leave now.",
  confirmText: "Exit",
  confirmColor: Colors.red,
);

if (result == true) {
  Get.back();
}
    return;
  }

  previousStep();
}

  /// IMAGE PICKER
  Future<void> pickPersonalPhoto() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
      );

      if (picked != null) {
        personalPhoto.value = File(picked.path);
      }
    } catch (e) {
      AppSnackbar.show(
        title: "Error",
        message: "Failed to pick image",
        icon: Icons.warning_amber_rounded,
        iconColor: AppColors.error,
      );
    }
  }

  double get progress =>
      (currentStep.value + 1) / totalSteps;
      
}