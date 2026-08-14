import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/owner/profile/controllers/owner_profile_complition_controller.dart';
import 'package:smartware/features/owner/profile/widgets/inventory_excel_upload_card.dart';
import 'package:smartware/features/owner/profile/widgets/inventory_file_info_sheet.dart';

class InventoryExcelUploadSection extends StatelessWidget {
  const InventoryExcelUploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerProfileComplitionController>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Import Your Products',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          'Upload a file containing the products currently stored in your warehouse.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurfaceVariant,
            height: 1.4,
          ),
        ),

        const SizedBox(height: 14),

        Obx(
          () => InventoryExcelUploadCard(
            fileName: controller.inventoryFileName.value,
            onUpload: controller.pickInventoryFile,
            onRemove: controller.removeInventoryFile,
          ),
        ),

        const SizedBox(height: 8),

        Align(
          alignment: Alignment.center,
          child: TextButton.icon(
            onPressed: () {
              InventoryFileInfoSheet.show(context);
            },
            icon: const Icon(
              Icons.help_outline_rounded,
              size: 18,
            ),
            label: const Text('About this inventory file'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
      ],
    );
  }
}