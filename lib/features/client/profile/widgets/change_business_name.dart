import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/client/profile/controllers/client_edit_profile_controller.dart';
import 'package:smartware/widgets/custom_textfield.dart';
import 'package:smartware/widgets/primary_button.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class ChangeBusinessName extends StatelessWidget {
  ChangeBusinessName({super.key});

  final controller = Get.find<ClientEditProfileController>();

  Future<void> updateBusinessName() async {
    final newName = controller.businessName.value.trim();

    if (newName.isEmpty) {
      AppSnackbar.show(
        title: 'Required'.tr,
        message: 'Please enter a business name'.tr,
        icon: Icons.warning_amber_rounded,
      );
      return;
    }

    if (newName == controller.selectedBusinessName.value) {
      AppSnackbar.show(
        title: 'No Changes'.tr,
        message: 'Please enter a different business name'.tr,
        icon: Icons.info_outline,
      );
      return;
    }

    controller.selectedBusinessName.value = newName;

    Get.back();

    AppSnackbar.show(
      title: 'Business Name Updated'.tr,
      message: 'Your business name was updated successfully'.tr,
      icon: Icons.check_circle_outline,
    );
  }

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
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Update the name displayed for this business.'.tr,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.65),
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

              PrimaryButton(
                text: 'Update'.tr,
                onPressed: updateBusinessName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}