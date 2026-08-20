import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/core/utils/validators.dart';
import 'package:smartware/features/owner/profile/controllers/owner_edit_profile_controller.dart';
import 'package:smartware/widgets/custom_textfield.dart';
import 'package:smartware/widgets/primary_button.dart';

class OwnerChangeEmail extends StatelessWidget {
  OwnerChangeEmail({super.key});

  final controller = Get.find<OwnerEditProfileController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Form(
            key: controller.changeEmailFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BackButton(),

                Text(
                  'Change Email Address'.tr,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Enter your new email address. We will send a verification link to it.'.tr,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.65),
                  ),
                ),

                const SizedBox(height: 28),

                CustomTextField(
                  controller: controller.newEmailController,
                  keyboardType: TextInputType.emailAddress,
                  label: 'New Email Address'.tr,
                  hint: 'Enter your new email'.tr,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                  ),
                  textInputAction: TextInputAction.done,
                  validator: Validators.emailValidation,
                ),

                const SizedBox(height: 28),

                Obx(
                  () => PrimaryButton(
                    text: 'Send Verification Link'.tr,
                    isLoading: controller.isLoading.value,
                    onPressed: controller.sendEmailChangeRequest,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}