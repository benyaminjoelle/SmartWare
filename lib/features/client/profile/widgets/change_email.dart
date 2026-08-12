import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/client/profile/controllers/client_edit_profile_controller.dart';
import 'package:smartware/widgets/custom_textfield.dart';
import 'package:smartware/widgets/primary_button.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class ChangeEmail extends StatelessWidget {
  ChangeEmail({super.key});

  final controller = Get.find<ClientEditProfileController>();

  final emailController = TextEditingController();

  void sendCode() {
    final newEmail = emailController.text.trim();

    if (newEmail.isEmpty || !GetUtils.isEmail(newEmail)) {
      AppSnackbar.show(
        title: 'Invalid Email'.tr,
        message: 'Please enter a valid email address'.tr,
        icon: Icons.warning_amber_rounded,
      );
      return;
    }

    if (newEmail == controller.email.value) {
      AppSnackbar.show(
        title: 'No Changes'.tr,
        message: 'Please enter a different email address'.tr,
        icon: Icons.info_outline,
      );
      return;
    }

    // Keep the new email temporarily.
    // The actual email will only change after verification.
    controller.pendingEmail.value = newEmail;

    controller.goToEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

  

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackButton(),

              Text(
                'Change Email Address'.tr,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Enter your new email address. We will send a verification code to it.'
                    .tr,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.65),
                ),
              ),

              const SizedBox(height: 28),

              CustomTextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                label: 'New Email Address'.tr,
                hint: 'Enter your new email'.tr,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                ),
                textInputAction: TextInputAction.done,
              ),

              const SizedBox(height: 28),

              PrimaryButton(
                text: 'Send Verification Code'.tr,
                onPressed: sendCode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}