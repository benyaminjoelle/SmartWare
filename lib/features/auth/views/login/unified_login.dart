import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storex/core/utils/validators.dart';
import 'package:storex/features/auth/widgets/login_onboarding_header.dart';
import 'package:storex/widgets/custom_textfield.dart';
import 'package:storex/widgets/primary_button.dart';

class UnifiedLogin extends StatelessWidget {
  const UnifiedLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final media = MediaQuery.of(context);

    final String backgroundImage = isDarkMode 
        ? 'assets/photos/login_dark.png' 
        : 'assets/photos/login_light.png';

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            // 1. Background Image Layer
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.surface.withValues(alpha: 0.2),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),

            // 2. Content Layer
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 5),
                              const LoginOnboardingHeader(),
                              SizedBox(height: media.size.height * 0.08),
                              CustomTextField(
                                label: 'Email Address/Phone number'.tr,
                                hint: 'Enter Email or Phone number'.tr,
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) => Validators.emailValidation(value),
                              ),
                              SizedBox(height: media.size.height * 0.03),
                              CustomTextField(
                                label: 'Password'.tr,
                                suffix: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Forgot Password?'.tr,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                hint: 'Enter your password'.tr,
                                prefixIcon: Icons.lock_outline,
                                isPassword: true,
                                textInputAction: TextInputAction.done,
                                validator: (value) => Validators.passwordValidation(value),
                              ),
                              SizedBox(height: media.size.height * 0.1),
                              PrimaryButton(
                                text: "Login".tr,
                                onPressed: () {
                                  // Handle login logic
                                },
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

            // 3. Premium Back Button
            Positioned(
              top: media.padding.top + 10,
              left: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: theme.colorScheme.onSurface,
                        size: 20,
                      ),
                      onPressed: () => Get.back(), // Using GetX for navigation
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