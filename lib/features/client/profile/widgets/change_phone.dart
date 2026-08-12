import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/client/profile/controllers/client_edit_profile_controller.dart';
import 'package:smartware/widgets/custom_textfield.dart';
import 'package:smartware/widgets/primary_button.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class ChangePhone extends StatelessWidget {
  ChangePhone({super.key});

  final controller = Get.find<ClientEditProfileController>();

  final phoneController = TextEditingController();

  void updatePhone() {
    final newPhone = phoneController.text.trim();

    if (newPhone.isEmpty) {
      AppSnackbar.show(
        title: 'Required'.tr,
        message: 'Please enter your phone number'.tr,
        icon: Icons.warning_amber_rounded,
      );
      return;
    }

    if (newPhone == controller.phone.value) {
      AppSnackbar.show(
        title: 'No Changes'.tr,
        message: 'Please enter a different phone number'.tr,
        icon: Icons.info_outline,
      );
      return;
    }

    controller.phone.value = newPhone;

    Get.back();

    AppSnackbar.show(
      title: 'Phone Number Updated'.tr,
      message: 'Your phone number was updated successfully'.tr,
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
                'Phone Number'.tr,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Update the phone number associated with your account.'.tr,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.65),
                ),
              ),

              const SizedBox(height: 28),

              CustomTextField(
                controller: phoneController,
                label: 'New Phone Number'.tr,
                hint: 'Enter your new phone number'.tr,
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(
                  Icons.phone_outlined,
                ),
                textInputAction: TextInputAction.done,
              ),

              const SizedBox(height: 28),

              PrimaryButton(
                text: 'Update Phone Number'.tr,
                onPressed: updatePhone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}