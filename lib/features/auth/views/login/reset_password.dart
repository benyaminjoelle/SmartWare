import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:storex/core/utils/validators.dart';
import 'package:storex/features/auth/controllers/forgot_pass_controller.dart';
import 'package:storex/features/onboarding/widgets/top_snackbar.dart';
import 'package:storex/widgets/back_button.dart';
import 'package:storex/widgets/custom_textfield.dart';
import 'package:storex/widgets/primary_button.dart';

class ResetPassword extends StatelessWidget{
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<ForgotPassController>();
    final media = MediaQuery.of(context);
    final backgroundImage = 'assets/photos/pass_reset.png';

     return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
       child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: media.size.width * 0.05, vertical: media.size.height * 0.02),
                  child: Form(
                    key: controller.passwordKey,
                    child: Column(
                      children: [
                        CustomBackButton(),
                        Image.asset(backgroundImage,
                        height: media.size.height * 0.3,
                        fit: BoxFit.contain,),
                        Text(
                          "Reset Password".tr,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                         SizedBox(height: media.size.height * 0.01),
                            Text(
                              "Your account has been recovered successfully.".tr,
                              style: theme.textTheme.bodyMedium,
                            ),
                            SizedBox(height: media.size.height * 0.03),
                    
                          CustomTextField(
                            controller: controller.newPasswordController,
                            label: "New Password".tr,
                            hint: "Enter your new password".tr,
                            validator: (value)=> Validators.passwordValidation(value),
                            ),
                    
                          SizedBox(height: media.size.height * 0.02),
                          CustomTextField(
                            label: "Confirm Password".tr,
                            controller: controller.confirmPasswordController,
                            hint: "Confirm your new password".tr,
                            validator: (value) => Validators.confirmPassword(value,
                            controller.newPasswordController.text),
                            ),
                            SizedBox(height: media.size.height * 0.03),
                           PrimaryButton(text: "Confirm Password".tr, onPressed: (){
                                 if (controller.passwordKey.currentState!.validate()) {
                                   Get.offAllNamed('/login');
                                   TopSnackbar.show(
                                     title: "Success".tr,
                                     message: "Your password has been reset successfully.".tr,
                                     icon: Icons.check_circle_outline,
                                     iconColor: theme.colorScheme.tertiary,
                                   );
          
                                 } else {
                                   // controller.resetPassword();
                                   TopSnackbar.show(
                                     title: "Error".tr,
                                     message: "Please ensure your password meets the requirements and both fields match.".tr,
                                     icon: Icons.error_outline,
                                     iconColor: theme.colorScheme.error,
                                   );
                                 }
                           })
                                ],),
                  ),
            ),
            ),
            ],)
          ),
           ),
        );
  }
}