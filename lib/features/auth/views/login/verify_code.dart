import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pinput/pinput.dart';
import 'package:storex/core/utils/validators.dart';
import 'package:storex/features/auth/controllers/forgot_pass_controller.dart';
import 'package:storex/features/auth/widgets/custom_pin_theme.dart';
import 'package:storex/widgets/app_snackbar.dart';
import 'package:storex/widgets/back_button.dart';
import 'package:storex/widgets/primary_button.dart';

class verifyCode extends StatelessWidget{
  const verifyCode({super.key});

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
                  padding: EdgeInsets.symmetric(horizontal: media.size.width * 0.05, vertical: media.size.height * 0.02),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    CustomBackButton(),
                    Center(
                      child: ClipRRect(
                        child: Image.asset(backgroundImage,
                        height:media.size.height * 0.3,
                        fit: BoxFit.contain,),
                        
                      ),
                    ),
                    Text(
                      "Verification Code".tr,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                       SizedBox(height: media.size.height * 0.01),
                          Text(
                            "Please enter the 4-digit code sent to your email.".tr,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                            ),
                          ),
                          
                          SizedBox(height: media.size.height * 0.06),
                          
                          // 4. THE DIGIT RECTANGLES (Pinput Widget)
                          Center(
                            child: CustomPinTheme(
                              controller: controller.codeController,
                              validator: (value) {
                                if (value == null || value.length < 4) {
                                  return "Please enter the complete code".tr;
                                }
                                return null;
                              },
                              onCompleted: (pin) {
                                // Optionally, you can trigger verification immediately when the user completes entering the code
                                controller.verifyCode();
                              },
                            ),
                          ),
                          SizedBox(height: media.size.height *0.01,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Didnt receive the code? ".tr,
                              
                               style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7)),
                               ),

                            Obx((){
                               return controller.isResendEnabled.value ?
                               TextButton(
                               onPressed: controller.resendCode, 
                               child: Text("Resend Code".tr,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.primaryColor
                                    ),
                                    ),
                                    )
                                    : Padding(
                                      padding: EdgeInsets.symmetric(vertical: media.size.height * 0.01,),
                                      child: Text("Resend Code in ${controller.secondsRemaining.value}s".tr,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7)),
                                      ),
                                      );
                            }
                             
                            ),
                            ],
                          ),
                        

                          SizedBox(height: media.size.height *0.09,),
                          PrimaryButton(text: "Confirm Code".tr, onPressed: (){
                              // controller.verifyCode();
                              final errorMessage = Validators.validateCode(controller.codeController.text);
                              if (errorMessage != null) {
                               AppSnackbar.show(
                                  position: SnackPosition.TOP,
                                  title: "Invalid Code".tr,
                                  message: errorMessage,
                                  icon: Icons.error_outline,
                                  iconColor: theme.colorScheme.error,
                                );
                              }
                              else {
                                 Get.toNamed('/resetPassword');
                              }
                          })]),
                 
                    
                ),
              
        ),
         
      )
      ),
      ]),
      ),
  );
  }
}