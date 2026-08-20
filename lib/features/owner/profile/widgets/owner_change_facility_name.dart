import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/owner/profile/controllers/owner_edit_profile_controller.dart';
import 'package:smartware/widgets/custom_textfield.dart';
import 'package:smartware/widgets/primary_button.dart';

class OwnerChangeFacilityName extends StatelessWidget {
  OwnerChangeFacilityName({super.key});

  final controller =
      Get.find<OwnerEditProfileController>();

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
                'Facility Name:'.tr,
                style:
                    theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Update the name displayed for this warehouse.'.tr,
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
                label: 'New Facility Name'.tr,
                hint: 'Enter the new Facility name'.tr,
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