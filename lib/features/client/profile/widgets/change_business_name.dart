import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/client/profile/controllers/client_edit_profile_controller.dart';
import 'package:smartware/widgets/custom_textfield.dart';
import 'package:smartware/widgets/primary_button.dart';

class ChangeBusinessName extends StatelessWidget {
  ChangeBusinessName({super.key});

  final controller =
      Get.find<ClientEditProfileController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackButton(),

              Text(
                'Business Name'.tr,
                style:
                    theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Update the name displayed for this business.'.tr,
                style:
                    theme.textTheme.bodyMedium?.copyWith(
                  color: theme
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.65),
                ),
              ),

              const SizedBox(height: 28),

              CustomTextField(
                label: 'New Business Name'.tr,
                hint: 'Enter the new business name'.tr,
                textInputAction: TextInputAction.done,
                onChanged: (value) {
                  controller.businessName.value = value;
                },
              ),

              const SizedBox(height: 28),

              Obx(
                () => PrimaryButton(
                  text: controller.isLoading.value
                      ? 'Updating...'.tr
                      : 'Update'.tr,
                  isDisabled:
                      controller.isLoading.value,
                  onPressed:
                      controller.isLoading.value
                          ? null
                          : controller.updateBusinessName,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}