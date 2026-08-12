
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/client/profile/controllers/client_edit_profile_controller.dart';
import 'package:smartware/features/client/profile/controllers/client_profile_completion_controller.dart';
import 'package:smartware/features/client/profile/widgets/business_type_section.dart';
import 'package:smartware/features/client/profile/widgets/product_type_section.dart';
import 'package:smartware/widgets/primary_button.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class ChangePreferences extends StatelessWidget {
  const ChangePreferences({super.key});

  Future<void> _savePreferences(
    BuildContext context,
    ClientEditProfileController editController,
    ClientProfileCompletionController preferencesController,
  ) async {
    if (!preferencesController.canGoNext) {
      AppSnackbar.show(
        title: "Incomplete Preferences".tr,
        message:
            "Please select a business type and at least one product category."
                .tr,
        icon: Icons.warning_amber_rounded,
      );
      return;
    }

    editController.isLoading.value = true;

    try {
      // TODO:
      // Send the selected preferences to the backend.
      //
      // Example later:
      //
      // await editController.updateBusinessPreferences(
      //   businessType:
      //       preferencesController.selectedBusinessType.value,
      //   products:
      //       preferencesController.selectedProducts.toList(),
      // );

      await Future.delayed(
        const Duration(milliseconds: 700),
      );

      Get.back();

      AppSnackbar.show(
        title: "Preferences Updated".tr,
        message:
            "Your business preferences have been updated successfully."
                .tr,
        icon: Icons.check_circle_outline,
      );
    } catch (e) {
      AppSnackbar.show(
        title: "Error".tr,
        message:
            "Unable to update your preferences. Please try again.".tr,
        icon: Icons.error_outline,
      );
    } finally {
      editController.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final editController =
        Get.find<ClientEditProfileController>();

    final preferencesController =
        Get.find<ClientProfileCompletionController>();

    return Scaffold(
      
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BackButton(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Business Preferences".tr,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // BUSINESS TYPE
                    const BusinessTypeSection(),

                    const SizedBox(height: 36),

                    // PRODUCT TYPES
                    const ProductTypeSection(),
                  ],
                ),
              ),
            ),

            // SAVE BUTTON
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                8,
                20,
                20,
              ),
              child: Obx(
                () => PrimaryButton(
                  text: editController.isLoading.value
                      ? "Saving...".tr
                      : "Save Preferences".tr,
                  isDisabled:
                      editController.isLoading.value ||
                          !preferencesController.canGoNext,
                  onPressed: editController.isLoading.value
                      ? null
                      : () => _savePreferences(
                            context,
                            editController,
                            preferencesController,
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
