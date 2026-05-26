import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storex/core/routes/app_routes.dart';
import 'package:storex/core/utils/validators.dart';
import 'package:storex/features/auth/controllers/owner_signup_controller.dart';
import 'package:storex/features/auth/widgets/signup_header.dart';
import 'package:storex/widgets/back_button.dart';
import 'package:storex/widgets/custom_textfield.dart';
import 'package:storex/widgets/primary_button.dart';

class OwnerSignupView extends StatelessWidget {
  const OwnerSignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final controller = Get.find<OwnerSignupController>();
    final media = MediaQuery.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              /// =========================
              /// FIXED BACK BUTTON ROW
              /// =========================
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 10,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomBackButton(
                    onPressed: controller.handleBack,
                  ),
                ),
              ),

              /// =========================
              /// SCROLLABLE CONTENT
              /// =========================
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: media.size.width * 0.05,
                        vertical: media.size.height * 0.02,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 20,
                            sigmaY: 20,
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: media.size.width * 0.05,
                              vertical: media.size.height * 0.07,
                            ),
                            decoration: BoxDecoration(
                              color: theme.surface.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: theme.onSurface.withValues(alpha: 0.15),
                              ),
                            ),

                            child: Form(
                              key: controller.clientSignupKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 5),
                                  const SignupHeader(),
                                  SizedBox(height: media.size.height * 0.08),

                                  /// FIRST NAME
                                  CustomTextField(
                                    controller: controller.firstNameController,
                                    label: "First Name".tr,
                                    hint: "Enter first name".tr,
                                    textInputAction: TextInputAction.next,
                                    validator: Validators.nameValidation,
                                  ),

                                  SizedBox(height: media.size.height * 0.03),

                                  /// LAST NAME
                                  CustomTextField(
                                    controller: controller.lastNameController,
                                    label: "Last Name".tr,
                                    hint: "Enter last name".tr,
                                    textInputAction: TextInputAction.next,
                                    validator: Validators.nameValidation,
                                  ),

                                
                                  SizedBox(height: media.size.height * 0.03),

                                  /// EMAIL
                                  CustomTextField(
                                    controller: controller.emailController,
                                    label: "Business Email".tr,
                                    hint: "Enter your business email".tr,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    validator: Validators.emailValidation,
                                  ),

                                  SizedBox(height: media.size.height * 0.03),

                                  /// PHONE
                                  CustomTextField(
                                    controller: controller.phoneController,
                                    label: "Business Phone".tr,
                                    hint: "+963",
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.next,
                                    validator: Validators.phoneValidation,
                                  ),

                                  SizedBox(height: media.size.height * 0.03),

                                  /// PASSWORD
                                  Obx(
                                    () => CustomTextField(
                                      controller: controller.passwordController,
                                      label: 'Password:'.tr,
                                      hint: 'Enter your password'.tr,
                                      isPassword: true,
                                      isObscure: controller.isPasswordHidden.value,
                                      onToggleVisibility:
                                          controller.togglePasswordVisibility,
                                      textInputAction: TextInputAction.done,
                                      validator: (value) =>
                                          Validators.passwordValidation(value),
                                    ),
                                  ),

                                  SizedBox(height: media.size.height * 0.03),

                                  /// CONFIRM PASSWORD
                                  Obx(
                                    () => CustomTextField(
                                      controller:
                                          controller.confirmPasswordController,
                                      label: 'Confirm Password:'.tr,
                                      hint: 'Enter your password'.tr,
                                      isPassword: true,
                                      isObscure:
                                          controller.isConfirmPasswordHidden.value,
                                      onToggleVisibility:
                                          controller.toggleConfirmPasswordVisibility,
                                      textInputAction: TextInputAction.done,
                                      validator: (value) {
                                        if (value !=
                                            controller.passwordController.text) {
                                          return "Passwords do not match".tr;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),

                                  SizedBox(height: media.size.height * 0.04),

                                  /// BUTTON
                                  PrimaryButton(
                                    text: "Continue".tr,
                                    onPressed: () {
                                      controller.validateClient();
                                      Get.toNamed('/verifyCode');
                                    },
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Already have an account?".tr),
                                      TextButton(
                                        onPressed: () {
                                          Get.toNamed(AppRoutes.login);
                                        },
                                        child: Text('Login'.tr),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}