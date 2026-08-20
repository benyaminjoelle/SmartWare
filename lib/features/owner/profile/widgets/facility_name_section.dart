import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/owner/profile/controllers/owner_profile_complition_controller.dart';
import 'package:smartware/widgets/custom_textfield.dart';

class FacilityNameSection extends StatelessWidget {
  const FacilityNameSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerProfileComplitionController>();
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Facility Name:',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 6),


CustomTextField(
  // controller: controller.facilityNameController,
   hint: "Enter business name",
  // onChanged: controller.updateFacilityName,

)
  
      ],
    );
  }
}