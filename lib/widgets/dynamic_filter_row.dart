import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storex/features/client/home/controllers/client_home_controller.dart';

class DynamicFilterRow extends StatelessWidget {
  const DynamicFilterRow({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientHomeController>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Obx(() {
      if (controller.filteredSubCategories.isEmpty) {
        return const SizedBox.shrink();
      }

      // Add 1 to the length to account for our permanent trailing "Edit" action chip
      final int totalItemCount = controller.filteredSubCategories.length + 1;

      return SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: totalItemCount,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            // Check if this position is the very last item in the row loop
            if (index == totalItemCount - 1) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ActionChip(
                  avatar: Icon(Icons.tune_outlined, size: 14, color: colors.primary),
                  label: const Text("Edit Niches"),
                  backgroundColor: colors.surface,
                  labelStyle: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: colors.primary.withOpacity(0.3)),
                  ),
                  onPressed: () {
                    // Navigate cleanly to the Profile configuration screen using GetX
                    Get.toNamed('/profile/manage-sectors');
                  },
                ),
              );
            }

            // Otherwise, render the standard sub-category filter chips as normal
            final subCategory = controller.filteredSubCategories[index];
            return Obx (() {
                final bool isSelected = controller.selectedSubCategoryId.value == subCategory.id;

            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(subCategory.name),
                selected: isSelected,
                selectedColor: colors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? colors.onPrimary : colors.onSurface,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  fontSize: 13,
                ),
                backgroundColor: colors.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? colors.primary : colors.outline.withOpacity(0.15),
                  ),
                ),
                showCheckmark: false,
                onSelected: (bool selected) => controller.selectSubCategory(subCategory.id),
              ),
            );
            });
          },
        ),
      );
    });
  }
}