import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/core/constants/app_colors.dart';

import 'package:smartware/features/onboarding/widgets/feature_carousel.dart';
import 'package:smartware/features/onboarding/widgets/onboarding_text.dart';
import 'package:smartware/localization/local_controller.dart';

import 'package:smartware/widgets/primary_button.dart';
import 'package:smartware/widgets/secondary_button.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final localeController = Get.put(LocaleController());

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),

                        // LANGUAGE BUTTON
                        Align(
                          alignment: Alignment.centerRight,
                          child: Obx(() {
                            final isEnglish =
                                localeController
                                    .currentLocale
                                    .value
                                    .languageCode ==
                                'en';

                            return TextButton.icon(
                              onPressed: localeController.toggleLanguage,
                              icon: const Icon(
                                Icons.language_rounded,
                                size: 18,
                              ),
                              label: Text(
                                isEnglish ? 'العربية' : 'English',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: theme.colorScheme.primary,
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 18),

                        // TOP SECTION
                        const OnboardingText(),

                        const SizedBox(height: 20),

                        // MIDDLE (RESPONSIVE FLEX ZONE)
                        Expanded(child: Center(child: FeatureCarousel())),

                        const SizedBox(height: 20),

                        // BOTTOM SECTION
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PrimaryButton(
                              onPressed: () => Get.toNamed('/login'),
                              text: 'Login'.tr,
                            ),

                            const SizedBox(height: 12),

                            SecondaryButton(
                              onPressed: () => Get.toNamed('/signupOnboarding'),
                              text: 'Create Account'.tr,
                            ),

                            const SizedBox(height: 18),

                            Text(
                              "By continuing, you agree to our Terms of Service and Privacy Policy."
                                  .tr,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.grey,
                                height: 1.4,
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
