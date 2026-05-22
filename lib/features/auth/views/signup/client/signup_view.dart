import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storex/core/routes/app_routes.dart';
import 'package:storex/core/utils/validators.dart';
import 'package:storex/features/auth/controllers/login_controller.dart';
import 'package:storex/widgets/back_button.dart';
import 'package:storex/widgets/custom_textfield.dart';
import 'package:storex/widgets/primary_button.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final controller = Get.find<LoginController>();
    final media = MediaQuery.of(context);
    final validate = Validators();



    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
              Container(
                color: theme.scaffoldBackgroundColor,
              ),
          
  SafeArea(
    child: Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: media.size.width * 0.05, 
            vertical: media.size.height * 0.02,),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: media.size.width * 0.05,
                  vertical: media.size.height * 0.07),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                  ),
                ),
                child: Form(
                  key: controller.loginFormKey,
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 5),
                     // const LoginHeader(),
                      SizedBox(height: media.size.height * 0.08),
                      
                      // Email/Phone
                      CustomTextField(
                        controller: controller.emailController,
                        label: 'Email Address / Phone number:'.tr,
                        hint: 'Enter Email or Phone number'.tr,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => Validators.emailOrPhoneValidation(value),
                  
                        // prefixIcon: Icon(
                        //  Icons.mail_outline_rounded,
                        //   color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        //   size: 20,
                        // ),
                      ),
                      
                      SizedBox(height: media.size.height * 0.03),
                      
                      // Password
                      Obx(
                        () => CustomTextField(
                          controller: controller.passwordController,
                          label: 'Password:'.tr,
                          hint: 'Enter your password'.tr,
                          isPassword: true,
                          isObscure: controller.isPasswordHidden.value,
                          onToggleVisibility: controller.togglePasswordVisibility,
                          textInputAction: TextInputAction.done,
                          validator: (value) => Validators.passwordValidation(value),
                          suffix: TextButton(
                            onPressed: () {
                              Get.toNamed(AppRoutes.forgotPassword);
                            },
                            child: Text('Forgot Password?'.tr),
                          ),
                          // prefixIcon: Icon(
                          //   Icons.lock_outline,
                          //   color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          //   size: 20,
                          // ),
                        ),
                      ),
                      
                      SizedBox(height: media.size.height * 0.04),
                      
                      PrimaryButton(
                        text: "Login".tr,
                        onPressed: () {
                          controller.login();
                        },
                      ),

                      // SizedBox(height: media.size.height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?".tr),
                          TextButton(
                            onPressed: () {
                              Get.toNamed(AppRoutes.signupOnboarding);
                            },
                            child: Text('Sign Up'.tr),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  ),

  // 3.Back Button
  CustomBackButton(),
  
],
),
),
);
  }
}