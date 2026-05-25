import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:storex/core/utils/validators.dart';
import 'package:storex/features/auth/controllers/client_signup_controller.dart';
import 'package:storex/features/auth/widgets/personal_photo_picker.dart';
import 'package:storex/widgets/custom_textfield.dart';
import 'package:storex/widgets/primary_button.dart';

class ClientBasicInfoView extends StatelessWidget {
  const ClientBasicInfoView({super.key});

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

                    child: Form(
                      key: controller.basicInfoFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// HEADER
                          Text(
                            "Basic Information".tr,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "Tell us about yourself".tr,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurface.withOpacity(0.6),
                            ),
                          ),

                          const SizedBox(height: 10),

                          const PersonalPhotoPicker(),

                          const SizedBox(height: 10),

                          /// FIRST NAME
                          CustomTextField(
                            controller: controller.firstNameController,
                            label: "First Name".tr,
                            hint: "Enter first name".tr,
                            textInputAction: TextInputAction.next,
                            validator: Validators.nameValidation,
                          ),

                          const SizedBox(height: 14),

                          /// LAST NAME
                          CustomTextField(
                            controller: controller.lastNameController,
                            label: "Last Name".tr,
                            hint: "Enter last name".tr,
                            textInputAction: TextInputAction.next,
                            validator: Validators.nameValidation,
                          ),

                          const SizedBox(height: 14),

                          /// USERNAME
                          CustomTextField(
                            controller: controller.usernameController,
                            label: "Username".tr,
                            hint: "Choose username".tr,
                            textInputAction: TextInputAction.done,
                            validator: Validators.usernameValidation,
                          ),

                          const SizedBox(height: 30),

                          /// BUTTON (NO LOGIC HERE)
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}