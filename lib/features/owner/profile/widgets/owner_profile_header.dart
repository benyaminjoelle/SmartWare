import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/owner/profile/controllers/owner_profile_controller.dart';
import 'package:smartware/widgets/app_image_picker.dart';

class OwnerProfileHeader extends StatelessWidget {
  const OwnerProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final controller = Get.find<OwnerProfileController>();

    return Column(
      children: [
        AppImagePicker(
          image: controller.profileImage,
          onRemove: controller.removeProfileImage,
          onPick: controller.pickProfileImage,
          size: 120,
        ),

        const SizedBox(height: 18),

        Obx(
          () => Text(
            controller.businessName.value,
            textAlign: TextAlign.center,

            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
              letterSpacing: -.5,
            ),
          ),
        ),

        const SizedBox(height: 6),
      ],
    );
  }
}
