import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/core/utils/validators.dart';
import 'package:smartware/features/client/profile/controllers/client_profile_completion_controller.dart';
import 'package:smartware/features/client/profile/widgets/business_type_section.dart';
import 'package:smartware/features/client/profile/widgets/product_type_section.dart';
import 'package:smartware/widgets/custom_textfield.dart';

import 'package:smartware/widgets/primary_button.dart';

class ClientPreferences extends StatelessWidget {
  const ClientPreferences({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientProfileCompletionController>();
   
 
      return Column(
      
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  CustomTextField(
                    controller:
                        controller.businessNameController,
                    label: "Business Name:".tr,
                    hint: "Enter your Business name".tr,
                    textInputAction: TextInputAction.next,
                    validator: Validators.nameValidation,
                  ),
                    SizedBox(height: 20),
                  // --- SECTION 1: BUSINESS TYPE ---
                 BusinessTypeSection(),
                  const SizedBox(height: 36),

                  // --- SECTION 2: WAREHOUSE CATEGORIES ---
                 ProductTypeSection()
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // --- FOOTER ACTION ---
   Obx(
  () {
    print(
      "Business: ${controller.selectedBusinessType.value}"
    );
    print(
      "Products: ${controller.selectedProducts}"
    );
    print(
      "Can next: ${controller.canGoNext}"
    );

    return PrimaryButton(
      text: "Continue",
      isDisabled: !controller.canGoNext,
      onPressed: controller.nextStep,
    );
  },
),
        ],
      );
  
  }
}

