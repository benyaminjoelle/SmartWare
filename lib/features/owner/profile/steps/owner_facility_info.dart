import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/owner/profile/controllers/owner_profile_complition_controller.dart';

import 'package:smartware/features/owner/profile/widgets/inventory_excel_upload_section.dart';
import 'package:smartware/widgets/primary_button.dart';

class OwnerFacilityInfo extends StatelessWidget {
  const OwnerFacilityInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerProfileComplitionController>();
  

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
               
                const SizedBox(height: 28),

                const InventoryExcelUploadSection(),

                const SizedBox(height: 24),

                
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        Obx(
          () => PrimaryButton(
            text: 'Continue',
            isDisabled: !controller.canGoNext,
            onPressed: controller.nextStep,
          ),
        ),
      ],
    );
  }
}