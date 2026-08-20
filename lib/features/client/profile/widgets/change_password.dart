import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/client/profile/controllers/client_edit_profile_controller.dart';
import 'package:smartware/widgets/custom_textfield.dart';
import 'package:smartware/widgets/primary_button.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  final controller = Get.find<ClientEditProfileController>();

  final confirmPasswordController = TextEditingController();

  final obscureOldPassword = true.obs;
  final obscureNewPassword = true.obs;
  final obscureConfirmPassword = true.obs;

  void updatePassword() {
    final currentPassword =
        controller.currentPasswordController.text.trim();

    final newPassword =
        controller.newPasswordController.text.trim();

    final confirmPassword =
        confirmPasswordController.text.trim();

    // Current password
    if (currentPassword.isEmpty) {
      AppSnackbar.show(
        title: 'Required'.tr,
        message: 'Please enter your current password'.tr,
        icon: Icons.warning_amber_rounded,
      );
      return;
    }

    // New password
    if (newPassword.isEmpty) {
      AppSnackbar.show(
        title: 'Required'.tr,
        message: 'Please enter your new password'.tr,
        icon: Icons.warning_amber_rounded,
      );
      return;
    }

    // Password length
    if (newPassword.length < 8) {
      AppSnackbar.show(
        title: 'Weak Password'.tr,
        message:
            'Your new password must be at least 8 characters'.tr,
        icon: Icons.lock_outline,
      );
      return;
    }

    // Confirm password
    if (confirmPassword.isEmpty) {
      AppSnackbar.show(
        title: 'Required'.tr,
        message: 'Please confirm your new password'.tr,
        icon: Icons.warning_amber_rounded,
      );
      return;
    }

    // Passwords match
    if (newPassword != confirmPassword) {
      AppSnackbar.show(
        title: 'Passwords Do Not Match'.tr,
        message:
            'Please make sure both new passwords match'.tr,
        icon: Icons.error_outline,
      );
      return;
    }

    // Send request to backend
    controller.changePassword();
  }

  void resetPassword() {
    Get.snackbar(
      'Reset Password'.tr,
      'Password reset flow will be opened here.'.tr,
    );
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
                  color: theme.textTheme.bodyMedium?.color
                      ?.withOpacity(0.65),
                ),
              ),

              const SizedBox(height: 28),

              // ============ CURRENT PASSWORD ==============
               
              Obx(
              () => CustomTextField(
                controller: controller.currentPasswordController,
                label: 'Current Password:'.tr,
                hint: 'Enter your current password'.tr,
                isPassword: true,
                isObscure: obscureOldPassword.value,
                onToggleVisibility: obscureOldPassword.toggle,
              ),
            ),

              const SizedBox(height: 18),

              // ============ NEW PASSWORD ===============
             Obx(
              () => CustomTextField(
                controller: controller.newPasswordController,
                label: 'New Password:'.tr,
                hint: 'Enter your new password'.tr,
                isPassword: true,
                isObscure: obscureNewPassword.value,
                onToggleVisibility: obscureNewPassword.toggle,
              ),
            ),
              const SizedBox(height: 18),

              // ============================================================
              // CONFIRM PASSWORD
              // ============================================================

              Obx(
              () => CustomTextField(
                controller: confirmPasswordController,
                label: 'Confirm New Password:'.tr,
                hint: 'Confirm your new password'.tr,
                isPassword: true,
                isObscure: obscureConfirmPassword.value,
                onToggleVisibility: obscureConfirmPassword.toggle,
              ),
            ),

              const SizedBox(height: 20),

              // ============================================================
              // FORGOT PASSWORD
              // ============================================================

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

              // ============================================================
              // UPDATE BUTTON
              // ============================================================

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