import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/auth/controllers/user_verification_controller.dart';
import 'package:smartware/features/auth/widgets/change_email.dart';
import 'package:smartware/widgets/back_button.dart';
import 'package:smartware/widgets/primary_button.dart';

class UserVerification extends GetView<UserVerificationController> {
  const UserVerification({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    const String backgroundImage = 'assets/photos/forgot_pass.png';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: SafeArea(
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
                        "Verify your Email".tr,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: media.size.height * 0.02),
                      Obx(
                        () => Text(
                          'verification_link_sent'.trParams({
                            'email': controller.email.value,
                          }),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.8),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            EmailBottomSheet.show(context, controller, theme),
                        child: Text(
                          "Wrong email? Change it here".tr,
                          style: TextStyle(color: theme.primaryColor),
                        ),
                      ),
                      Text(
                        "Please check your spam folder if you can't find it."
                            .tr,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(
                            0.5,
                          ),
                        ),
                      ),
                      const Spacer(), // Replaces hardcoded layouts cleanly
                      Obx(
                        () => PrimaryButton(
                          text: "I have verified".tr,
                          isLoading: controller.isLoading.value,
                          onPressed: controller.verifyEmail,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't receive the email? ".tr,
                            style: TextStyle(
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.7),
                            ),
                          ),
                          Obx(() {
                            return controller.isResendEnabled.value
                                ? TextButton(
                                    onPressed: controller.resendCode,
                                    child: Text(
                                      "Resend email".tr,
                                      style: TextStyle(
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: media.size.height * 0.01,
                                    ),
                                    child: Text(
                                      'resend_email_in'.trParams({
                                        'seconds': controller
                                            .secondsRemaining
                                            .value
                                            .toString(),
                                      }),
                                      style: TextStyle(
                                        color: theme.textTheme.bodyMedium?.color
                                            ?.withOpacity(0.7),
                                      ),
                                    ),
                                  );
                          }),
                        ],
                      ),
                    ],
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
