import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/client/profile/controllers/client_edit_profile_controller.dart';
import 'package:smartware/widgets/custom_textfield.dart';
import 'package:smartware/widgets/primary_button.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  final controller = Get.find<ClientEditProfileController>();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final obscureOldPassword = true.obs;
  final obscureNewPassword = true.obs;
  final obscureConfirmPassword = true.obs;

  void updatePassword() {
    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (oldPassword.isEmpty) {
      AppSnackbar.show(
        title: 'Required'.tr,
        message: 'Please enter your current password'.tr,
        icon: Icons.warning_amber_rounded,
      );
      return;
    }

    if (newPassword.isEmpty) {
      AppSnackbar.show(
        title: 'Required'.tr,
        message: 'Please enter your new password'.tr,
        icon: Icons.warning_amber_rounded,
      );
      return;
    }

    if (newPassword.length < 8) {
      AppSnackbar.show(
        title: 'Weak Password'.tr,
        message: 'Your new password must be at least 8 characters'.tr,
        icon: Icons.lock_outline,
      );
      return;
    }

    if (confirmPassword.isEmpty) {
      AppSnackbar.show(
        title: 'Required'.tr,
        message: 'Please confirm your new password'.tr,
        icon: Icons.warning_amber_rounded,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      AppSnackbar.show(
        title: 'Passwords Do Not Match'.tr,
        message: 'Please make sure both new passwords match'.tr,
        icon: Icons.error_outline,
      );
      return;
    }

    // TODO:
    // Call your backend here.
    //
    // Example:
    // await controller.changePassword(
    //   oldPassword: oldPassword,
    //   newPassword: newPassword,
    // );

    Get.back();

    AppSnackbar.show(
      title: 'Password Updated'.tr,
      message: 'Your password has been changed successfully'.tr,
      icon: Icons.check_circle_outline,
    );
  }

  void resetPassword() {
    Get.snackbar(
      'Reset Password'.tr,
      'Password reset flow will be opened here.'.tr,
    );

    // TODO:
    // Navigate to your forgot-password flow.
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

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
                'Update your password'.tr,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Enter your current password and choose a new secure password.'
                    .tr,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.65),
                ),
              ),

              const SizedBox(height: 28),

              /// Current Password
              Obx(
                () => CustomTextField(
                  controller: oldPasswordController,
                  label: 'Current Password:'.tr,
                  hint: 'Enter your current password'.tr,
                  
                  suffixIcon: IconButton(
                    onPressed: () {
                      obscureOldPassword.toggle();
                    },
                    icon: Icon(
                      obscureOldPassword.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              /// New Password
              Obx(
                () => CustomTextField(
                  controller: newPasswordController,
                  label: 'New Password:'.tr,
                  hint: 'Enter your new password'.tr,
                 
                  suffixIcon: IconButton(
                    onPressed: () {
                      obscureNewPassword.toggle();
                    },
                    icon: Icon(
                      obscureNewPassword.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              /// Confirm Password
              Obx(
                () => CustomTextField(
                  controller: confirmPasswordController,
                  label: 'Confirm New Password:'.tr,
                  hint: 'Confirm your new password'.tr,
                 
                  
                  suffixIcon: IconButton(
                    onPressed: () {
                      obscureConfirmPassword.toggle();
                    },
                    icon: Icon(
                      obscureConfirmPassword.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Forgot Password
              Center(
                child: TextButton(
                  onPressed: resetPassword,
                  child: Text(
                    'Forgot your current password?'.tr,
                    style: TextStyle(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// Update Button
              PrimaryButton(
                text: 'Update Password'.tr,
                onPressed: updatePassword,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}