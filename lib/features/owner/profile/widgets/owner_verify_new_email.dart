import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/owner/profile/controllers/owner_edit_profile_controller.dart';
import 'package:smartware/widgets/back_button.dart';
import 'package:smartware/widgets/primary_button.dart';

class OwnerVerifyNewEmail extends StatelessWidget {
  const OwnerVerifyNewEmail({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.find<OwnerEditProfileController>();

    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: media.size.width * 0.06,
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // ==================================================
              // BACK BUTTON
              // ==================================================

              const Align(
                alignment: Alignment.centerLeft,
                child: CustomBackButton(),
              ),

              // ==================================================
              // SCROLLABLE CONTENT
              // ==================================================

              Expanded(
                child: SingleChildScrollView(
                  physics:
                      const BouncingScrollPhysics(),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height:
                              media.size.height *
                                  0.05,
                        ),

                        // ==================================================
                        // ILLUSTRATION
                        // ==================================================

                        Image.asset(
                          'assets/photos/forgot_pass.png',
                          height:
                              media.size.height *
                                  0.22,
                          fit: BoxFit.contain,
                        ),

                        const SizedBox(
                          height: 24,
                        ),

                        // ==================================================
                        // TITLE
                        // ==================================================

                        Text(
                          "Verify your Email".tr,
                          textAlign:
                              TextAlign.center,
                          style: theme
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),

                        const SizedBox(
                          height: 14,
                        ),

                        // ==================================================
                        // DESCRIPTION
                        // ==================================================

                        Text(
                          "We've sent a verification link to"
                              .tr,
                          textAlign:
                              TextAlign.center,
                          style: theme
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            color: theme
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withValues(
                              alpha: 0.65,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 6,
                        ),

                        // ==================================================
                        // EMAIL
                        // ==================================================

                        Obx(
                          () => Text(
                            controller
                                .pendingEmail
                                .value,
                            textAlign:
                                TextAlign.center,
                            style: theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: cs.primary,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        // ==================================================
                        // SPAM MESSAGE
                        // ==================================================

                        Text(
                          "Please check your spam folder if you can't find it."
                              .tr,
                          textAlign:
                              TextAlign.center,
                          style: theme
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color: theme
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 28,
                        ),

                        // ==================================================
                        // VERIFY BUTTON
                        // ==================================================

                        Obx(
                          () => PrimaryButton(
                            text:
                                "I have verified".tr,
                            isLoading: controller
                                .isLoading
                                .value,
                            onPressed:
                                controller
                                    .verifyNewEmail,
                          ),
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        // ==================================================
                        // RESEND
                        // ==================================================

                        Obx(
                          () => controller
                                  .isResendEnabled
                                  .value
                              ? TextButton(
                                  onPressed:
                                      controller
                                          .resendEmailCode,
                                  child: Text(
                                    "Resend email"
                                        .tr,
                                    style:
                                        TextStyle(
                                      color:
                                          cs.primary,
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                  ),
                                )
                              : Text(
                                  'resend_email_in'
                                      .trParams({
                                    'seconds':
                                        controller
                                            .secondsRemaining
                                            .value
                                            .toString(),
                                  }),
                                  style: theme
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                    color: theme
                                        .textTheme
                                        .bodySmall
                                        ?.color
                                        ?.withValues(
                                      alpha: 0.55,
                                    ),
                                  ),
                                ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                      ],
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