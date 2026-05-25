import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storex/features/auth/controllers/client_signup_controller.dart';
import 'package:storex/widgets/custom_textfield.dart';
import 'package:storex/widgets/primary_button.dart';

class AccountInfoView extends StatelessWidget {
  const AccountInfoView({super.key});

  @override
  Widget build(BuildContext context) {
   final controller = Get.find<ClientSignupController>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isTablet = constraints.maxWidth > 600;

              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 520 : double.infinity,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// HEADER
                        Text(
                          "Account Information".tr,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "Give us main informations about you".tr,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.onSurface.withOpacity(0.6),
                          ),
                        ),

                        const SizedBox(height: 28),

                        /// FIELDS (no container, no gimmicks)
                        CustomTextField(
                          label: "Email".tr,
                          hint: "Enter your email".tr,
                          textInputAction: TextInputAction.next,
                        ),

                        const SizedBox(height: 14),

                        CustomTextField(
                          label: "Phone Number".tr,
                          hint: "Enter phone number".tr,
                          textInputAction: TextInputAction.next,
                        ),

                      

                       
                        const SizedBox(height: 30),

                        /// BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                           
                            
                            onPressed: controller.nextStep,
                            text: "Continue".tr,
                          ),
                        ),
                      ],
                    ),
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