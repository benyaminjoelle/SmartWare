import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/auth/controllers/user_verification_controller.dart';
import 'package:smartware/widgets/back_button.dart';
import 'package:smartware/widgets/primary_button.dart';

class UserVerification extends GetView<UserVerificationController> {
  const UserVerification({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: media.size.width * 0.06,
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // Back button
              Align(
                alignment: Alignment.centerLeft,
                child: const CustomBackButton(),
              ),

              const Spacer(),

              // Illustration
              Image.asset(
                'assets/photos/forgot_pass.png',
                height: media.size.height * 0.25,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 28),

              // Title
              Text(
                "Verify your Email".tr,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 14),

              // Description
              Text(
                "We've sent a verification link to".tr,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color
                      ?.withValues(alpha: 0.65),
                ),
              ),

              const SizedBox(height: 6),

              // Email
              Text(
                controller.email.value,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Please check your spam folder if you can't find it.".tr,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color
                      ?.withValues(alpha: 0.5),
                ),
              ),

              const Spacer(),

              // Verify button
              Obx(
                () => PrimaryButton(
                  text: "I have verified".tr,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.verifyEmail,
                ),
              ),

              const SizedBox(height: 12),

              // Resend
              Obx(
                () => controller.isResendEnabled.value
                    ? TextButton(
                        onPressed: controller.resendCode,
                        child: Text(
                          "Resend email".tr,
                          style: TextStyle(
                            color: cs.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Text(
                        'resend_email_in'.trParams({
                          'seconds': controller.secondsRemaining.value
                              .toString(),
                        }),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color
                              ?.withValues(alpha: 0.55),
                        ),
                      ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}