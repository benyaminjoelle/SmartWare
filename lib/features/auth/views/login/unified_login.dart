import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storex/core/constants/app_colors.dart';
import 'package:storex/core/utils/validators.dart';
import 'package:storex/features/auth/widgets/login_onboarding_header.dart';
import 'package:storex/widgets/custom_textfield.dart';
import 'package:storex/widgets/primary_button.dart';

class UnifiedLogin extends StatelessWidget {
  const UnifiedLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppColors();
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // Choose the image path based on the theme
    final String backgroundImage = isDarkMode 
        ? 'assets/photos/login_dark.png'  // Your dark theme image
        : 'assets/photos/login_light.png'; // Your light theme image

    final media = MediaQuery.of(context);
    final textScale = media.textScaler.clamp(
      minScaleFactor: 0.8,
      maxScaleFactor: 1.3,
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap outside
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
                  fit: BoxFit.cover, // Ensures the photo covers the entire screen
                  // Optional: Add a slight overlay if the image makes text hard to read
                  colorFilter: ColorFilter.mode(
                    theme.colorScheme.surface.withValues(alpha: 0.1),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
      
            // 2. Content Layer
          // ... (Your background layer stays the same)
      
      // 2. Content Layer
      SafeArea(
        child: Center( // Center the card on the screen
      child: SingleChildScrollView( // 1. Allows scrolling when keyboard appears
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.8), // Increased opacity for readability
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 2. Important: Tells Column to only take needed space
            children: [
              const SizedBox(height: 5),
              const LoginOnboardingHeader(),
              SizedBox(height: media.size.height * 0.08), // Fixed spacing instead of Spacer
              
              CustomTextField(
                label: 'Email Address'.tr,
                hint: 'name@example.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => Validators.emailValidation(value),
              ),
      
               SizedBox(height: media.size.height * 0.03),
      
              CustomTextField(
                label: 'Password'.tr,
                suffix: TextButton(onPressed: () {}, child: 
                                Text('Forgot Password?'.tr, style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w500,
                                ),)),
                hint: 'Enter your password'.tr, 
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                textInputAction: TextInputAction.done,
                validator: (value) => Validators.passwordValidation(value),
              ),
              
              
              SizedBox(height: media.size.height * 0.1), 
              
              //ma 3m 23ref 8yer lon al text bkl lm7lat
              PrimaryButton(text: "Login".tr, onPressed: () {
                // Handle login logic
              }),
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