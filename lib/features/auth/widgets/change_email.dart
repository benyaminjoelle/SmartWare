import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/auth/controllers/forgot_pass_controller.dart';
import 'package:smartware/features/auth/controllers/user_verification_controller.dart';
import 'package:smartware/widgets/custom_textfield.dart';
import 'package:smartware/widgets/primary_button.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class EmailBottomSheet {
  // final controller = Get.find<ForgotPassController>();
  //static method so it can be called easily
  static void show(BuildContext context, dynamic controller, ThemeData theme) {
    final TextEditingController emailController = TextEditingController(
      text: controller.email.value,
    );
    final bool isSignupVerification = controller is UserVerificationController;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                "Change Email Address".tr,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "We will send a new verification code to this email address."
                    .tr,
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                label: "New Email Address".tr,
                hint: "Enter your email".tr,
                // prefixIcon: const Icon(Icons.email_outlined),
              ),

              const SizedBox(height: 25),
              PrimaryButton(
                text: "Update & Resend Code".tr,
                onPressed: () async {
                  String inputEmail = emailController.text.trim();

                  if (inputEmail.isEmpty || !GetUtils.isEmail(inputEmail)) {
                    AppSnackbar.show(
                      title: "Invalid Email".tr,
                      message: "Please enter a valid email address".tr,
                      icon: Icons.warning_amber_rounded,
                    );
                    return;
                  }

                  // controller.changeEmail(inputEmail);
                  Get.back();

                  AppSnackbar.show(
                    title: "Email Updated".tr,
                    message: "A new code has been sent successfully!".tr,
                    icon: Icons.check_circle_outline,
                  );
                  if (isSignupVerification) {
                    // Triggers the signup profile mutation & persistence logic
                    await (controller as UserVerificationController)
                        .changeEmail(inputEmail);
                  } else if (controller is ForgotPassController) {
                    // Triggers the password reset verification email link dispatch logic
                    //NOT DONE YET
                    // controller.updateEmailAndResend(inputEmail);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
