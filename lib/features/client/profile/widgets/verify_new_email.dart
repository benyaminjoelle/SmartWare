import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/client/profile/controllers/client_edit_profile_controller.dart';
import 'package:smartware/features/auth/widgets/custom_pin_theme.dart';
import 'package:smartware/widgets/back_button.dart';
import 'package:smartware/widgets/primary_button.dart';

class VerifyNewEmail extends StatelessWidget {
  const VerifyNewEmail({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    final controller = Get.find<ClientEditProfileController>();

    const backgroundImage = 'assets/photos/forgot_pass.png';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: media.size.width * 0.05,
                      vertical: media.size.height * 0.02,
                    ),
                    child: Column(
                      children: [
                        const CustomBackButton(),

                        Center(
                          child: ClipRRect(
                            child: Image.asset(
                              backgroundImage,
                              height: media.size.height * 0.3,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        Text(
                          'Verify Your New Email'.tr,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(
                          height: media.size.height * 0.015,
                        ),

                        Obx(
                          () => Text(
                            'verification_code_sent'.trParams({
                              'email': controller.pendingEmail.value,
                            }),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.8),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: media.size.height * 0.02,
                        ),

                        CustomPinTheme(
                          length: 6,
                          controller:
                              controller.verificationCodeController,
                        ),

                        SizedBox(
                          height: media.size.height * 0.02,
                        ),

                        Text(
                          "Please check your spam folder if you can't find it."
                              .tr,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color
                                ?.withOpacity(0.5),
                          ),
                        ),

                        SizedBox(
                          height: media.size.height * 0.09,
                        ),

                        PrimaryButton(
                          text: 'Confirm Code'.tr,
                          onPressed: controller.verifyNewEmail,
                        ),
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(
      'Didnt receive the email? '.tr,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.textTheme.bodyMedium?.color
            ?.withOpacity(0.7),
      ),
    ),

    Obx(
      () {
        if (controller.isResendEnabled.value) {
          return TextButton(
            onPressed: controller.resendEmailCode,
            child: Text(
              'Resend email'.tr,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: media.size.height * 0.01,
          ),
          child: Text(
            'resend_email_in'.trParams({
              'seconds': controller.secondsRemaining.value
                  .toString(),
            }),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color
                  ?.withOpacity(0.7),
            ),
          ),
        );
      },
    ),
  ],
),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}