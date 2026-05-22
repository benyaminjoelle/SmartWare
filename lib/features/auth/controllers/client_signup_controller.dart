import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:storex/core/constants/app_colors.dart';

import 'package:storex/widgets/app_dialog.dart';
import 'package:storex/widgets/app_snackbar.dart';

class ClientSignupController extends GetxController {
  /// =========================================================
  /// STEP MANAGEMENT
  /// =========================================================

  final currentStep = 0.obs;
 final RxnString selectedBusinessType = RxnString();
  /// keep scalable for future steps
  final int totalSteps = 5;

  late final PageController pageController;

  double get progress =>
      (currentStep.value + 1) / totalSteps;

  /// =========================================================
  /// FORM KEYS
  /// =========================================================

  final basicInfoFormKey = GlobalKey<FormState>();

  final companyInfoFormKey = GlobalKey<FormState>();

  final documentsFormKey = GlobalKey<FormState>();

  final businessInfoFormKey = GlobalKey<FormState>();

  final verificationFormKey = GlobalKey<FormState>();

  /// =========================================================
  /// BASIC INFO CONTROLLERS
  /// =========================================================

  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final usernameController = TextEditingController();

  /// =========================================================
  /// ACCOUNT INFO CONTROLLERS
  /// =========================================================

  final emailController = TextEditingController();

  final phoneController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController =
      TextEditingController();

  /// =========================================================
  /// DOCUMENTS CONTROLLERS
  /// =========================================================

  final nationalIdController =
      TextEditingController();

  final addressController = TextEditingController();

  /// =========================================================
  /// BUSINESS INFO CONTROLLERS
  /// =========================================================

  final businessNameController =
      TextEditingController();

  final businessDescriptionController =
      TextEditingController();

  /// =========================================================
  /// VERIFICATION CONTROLLERS
  /// =========================================================

  final otpController = TextEditingController();

  /// =========================================================
  /// IMAGE PICKERS
  /// =========================================================

  final ImagePicker _picker = ImagePicker();

  final Rx<File?> personalPhoto = Rx<File?>(null);

  final Rx<File?> idPhoto = Rx<File?>(null);

  final Rx<File?> ownershipDocument =
      Rx<File?>(null);

  /// =========================================================
  /// BUTTON STATES
  /// =========================================================

  final isLoading = false.obs;

  /// =========================================================
  /// LIFECYCLE
  /// =========================================================

  @override
  void onInit() {
    pageController = PageController();

    super.onInit();
  }

  @override
  void onClose() {
    /// BASIC INFO
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();

    /// ACCOUNT INFO
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    /// DOCUMENTS
    nationalIdController.dispose();
    addressController.dispose();

    /// BUSINESS INFO
    businessNameController.dispose();
    businessDescriptionController.dispose();

    /// VERIFICATION
    otpController.dispose();

    pageController.dispose();

    super.onClose();
  }

  /// =========================================================
  /// STEP VALIDATIONS
  /// =========================================================

  bool validateBasicInfo() {
    return basicInfoFormKey.currentState?.validate() ??
        false;
  }

  bool validateAccountInfo() {
    return companyInfoFormKey.currentState
            ?.validate() ??
        false;
  }

  bool validateDocuments() {
    return documentsFormKey.currentState?.validate() ??
        false;
  }

  bool validateBusinessInfo() {
    return businessInfoFormKey.currentState
            ?.validate() ??
        false;
  }

  bool validateVerification() {
    return verificationFormKey.currentState
            ?.validate() ??
        false;
  }

  /// =========================================================
  /// NEXT STEP FLOW
  /// =========================================================

  void nextStep() {
    bool isValid = false;

    switch (currentStep.value) {
      case 0:
        isValid = validateBasicInfo();
        break;

      case 1:
        isValid = validateAccountInfo();
        break;

      case 2:
        isValid = validateDocuments();
        break;

      case 3:
        isValid = validateBusinessInfo();
        break;

      case 4:
        isValid = validateVerification();
        break;
    }

    if (!isValid) {
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

  /// =========================================================
  /// PREVIOUS STEP
  /// =========================================================

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

  /// =========================================================
  /// SMART BACK BUTTON
  /// =========================================================

  Future<void> handleBack() async {
    if (currentStep.value == 0) {
      final result =
          await AppDialogs.showConfirmDialog(
        title: "Exit signup?",
        message:
            "Your progress will be lost if you leave now.",
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

  /// =========================================================
  /// IMAGE PICKERS
  /// =========================================================

  Future<void> pickPersonalPhoto() async {
    await _pickImage(target: personalPhoto);
  }

  Future<void> pickIdPhoto() async {
    await _pickImage(target: idPhoto);
  }

  Future<void> pickOwnershipDocument() async {
    await _pickImage(
      target: ownershipDocument,
    );
  }

  Future<void> _pickImage({
    required Rx<File?> target,
  }) async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1400,
      );

      if (picked != null) {
        target.value = File(picked.path);
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

}