import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storex/core/routes/app_routes.dart';
import 'package:storex/features/auth/controllers/signup_onboarding_controller.dart';

import 'package:storex/features/auth/widgets/role_data.dart';
import 'package:storex/widgets/primary_button.dart';
import '../../widgets/role_card.dart';
import '../../widgets/signup_onboarding_header.dart';

class SignupOnboarding extends StatelessWidget {
  SignupOnboarding({super.key});

  final controller = Get.put(SignupOnboardingController());

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final roles = getRoles(colors);

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,

          /// 🧠 TAP ANYWHERE OUTSIDE → CLEAR SELECTION
          onTap: () {
            controller.clearSelection();
          },

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const SignupOnboardingHeader(),
                const SizedBox(height: 20),

                /// 🎯 GRID (NOT EXPANDED ANYMORE)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isTablet = constraints.maxWidth > 600;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: roles.length,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isTablet ? 2 : 1,
                        childAspectRatio: 3.6,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        final role = roles[index];

                        return Obx(() {
                          return RoleCard(
                            title: role.title,
                            description: role.description,
                            icon: role.icon,
                            color: role.color,
                            isSelected:
                                controller.selectedType.value ==
                                    role.type,
                            onTap: () {
                              controller.selectRole(role.type);
                            },
                          );
                        });
                      },
                    );
                  },
                ),

                const SizedBox(height: 20),

                /// 📦 BUTTON (NOW UNDER GRID PROPERLY)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: PrimaryButton(
                    onPressed: controller.continueSignup,
                    text: "Continue",
                  ),
                ),

                const SizedBox(height: 10),

                /// 🧾 LOGIN TEXT
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?".tr),
                  TextButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.login);
                    },
                    child: Text('Login'.tr),
                  ),
                ],
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}