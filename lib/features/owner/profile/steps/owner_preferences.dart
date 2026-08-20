import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/core/utils/validators.dart';
import 'package:smartware/features/owner/profile/controllers/owner_profile_complition_controller.dart';
import 'package:smartware/features/owner/profile/widgets/owner_product_type_section.dart';
import 'package:smartware/widgets/custom_textfield.dart';
import 'package:smartware/widgets/primary_button.dart';

class OwnerPreferences extends StatelessWidget {
  const OwnerPreferences({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.find<OwnerProfileComplitionController>();

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics:
                const BouncingScrollPhysics(),
            padding:
                const EdgeInsets.only(
              bottom: 24,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),

                // ============================================================
                // WAREHOUSE NAME
                // ============================================================

                CustomTextField(
                  controller:
                      controller.businessNameController,
                  label:
                      "Warehouse Name:".tr,
                  hint:
                      "Enter your warehouse name".tr,
                  textInputAction:
                      TextInputAction.next,
                  validator:
                      Validators.nameValidation,
                ),

                const SizedBox(
                  height: 28,
                ),

                // ============================================================
                // CATEGORIES
                // ============================================================

                OwnerProductTypeSection(),
              ],
            ),
          ),
        ),

        const SizedBox(
          height: 16,
        ),

        // ================================================================
        // CONTINUE BUTTON
        // ================================================================

        Obx(
          () {
            debugPrint(
              'Owner Warehouse: '
              '${controller.businessName.value}',
            );

            debugPrint(
              'Owner Business Type: warehouse',
            );

            debugPrint(
              'Owner Categories: '
              '${controller.selectedProducts}',
            );

            debugPrint(
              'Can next: '
              '${controller.canGoNext}',
            );

            return PrimaryButton(
              text: "Continue",
              isDisabled:
                  !controller.canGoNext,
              onPressed:
                  controller.nextStep,
            );
          },
        ),
      ],
    );
  }
}