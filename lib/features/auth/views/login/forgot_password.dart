import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storex/core/routes/app_routes.dart';
import 'package:storex/core/utils/validators.dart';
import 'package:storex/features/auth/controllers/forgot_pass_controller.dart';
import 'package:storex/features/onboarding/widgets/top_snackbar.dart';
import 'package:storex/widgets/back_button.dart';
import 'package:storex/widgets/custom_textfield.dart';
import 'package:storex/widgets/primary_button.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final String backgroundImage = 'assets/photos/forgot_pass.png';
    final controller = Get.find<ForgotPassController>();

    
    return Scaffold(
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
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomBackButton(),
                    Center(
                      child: ClipRRect(
                        child: Image.asset(backgroundImage,
                        height:media.size.height * 0.3,
                        fit: BoxFit.contain,),
                        
                      ),
                    ),
                
                    Center(
                      child: Text(
                        "Forgot Password?".tr,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "Please enter the Email associated with your account.".tr,
                      textAlign: TextAlign.start,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium!.color?.withOpacity(0.7)
                      ),
                    ),
                    Text("We will send you an email with instructions to reset your password.".tr,
                      textAlign: TextAlign.start,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                      ),
                      ),
                        
                      SizedBox(height: media.size.height * 0.03,),
                        
                    CustomTextField(
                      controller: controller.emailController,
                      label:"Email Address:".tr,
                      hint: "Enter your email address".tr,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => Validators.emailValidation(value),),
                      
                    // Spacer(),
                    SizedBox(height: media.size.height * 0.03,),
                    PrimaryButton(text: "Send Email".tr, onPressed: () {
                       if (controller.formKey.currentState!.validate()){
                        //  controller.sendVerificationEmail();
                        Get.toNamed(AppRoutes.verifyCode);
                    }
                    else{
                      TopSnackbar.show(
                        title: "Invalid Email".tr,
                        message: "Please Enter a valid email address.".tr,
                        icon: Icons.error_outline,
                        iconColor: theme.colorScheme.error,
                        );
                    }
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
          ],
          ),
    );
}
}