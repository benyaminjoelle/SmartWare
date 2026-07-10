import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smartware/features/auth/controllers/forgot_pass_controller.dart';
import 'package:smartware/features/auth/views/login/verify_email.dart';
import 'package:smartware/features/auth/widgets/change_email.dart';
import 'package:smartware/widgets/back_button.dart';
import 'package:smartware/widgets/primary_button.dart';

class verifyEmail extends StatelessWidget {
  const verifyEmail({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final String backgroundImage = 'assets/photos/forgot_pass.png';
    final controller = Get.find<ForgotPassController>();

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
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomBackButton(),
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
                          onPressed: () => EmailBottomSheet.show(
                            context,
                            controller,
                            theme,
                          ), // Open the change email bottom sheet
                          child: Text(
                            "Wrong email? Change it here".tr,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.primaryColor,
                              // decoration: TextDecoration.underline,
                            ),
                          ),
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
                        SizedBox(height: media.size.height * 0.01),

                        SizedBox(height: media.size.height * 0.09),
                        PrimaryButton(
                          text: "I have verified".tr,
                          onPressed: () {
                            controller.verifyEmail();
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didnt receive the email? ".tr,

                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.textTheme.bodyMedium?.color
                                    ?.withOpacity(0.7),
                              ),
                            ),
                            //the
                            Obx(() {
                              return controller.isResendEnabled.value
                                  ? TextButton(
                                      onPressed: controller.resendCode,
                                      child: Text(
                                        "Resend email".tr,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
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
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: theme
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color
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
            ),
          ],
        ),
      ),
    );
  }
}
