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
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            controller.clearSelection();
            FocusScope.of(context).unfocus();
          },

          child: LayoutBuilder(
            builder: (context, constraints) {
              final isTablet = constraints.maxWidth > 600;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      const SignupOnboardingHeader(),

                      const SizedBox(height: 20),

                      /// GRID
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),

                        itemCount: roles.length,

                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isTablet ? 2 : 1,
                          childAspectRatio: isTablet ? 3.2 : 3.4,
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
                      ),

                      const SizedBox(height: 30),

                      /// BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: PrimaryButton(
                          onPressed: controller.continueSignup,
                          text: "Continue".tr,
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// LOGIN ROW
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Already have an account?".tr),
                            TextButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.login);
                              },
                              child: Text("Login".tr),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}