import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/home/views/filtering_menu.dart';
import 'package:smartware/features/product/controllers/product_controller.dart';

class DynamicFilterRow extends StatelessWidget {
  const DynamicFilterRow({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Obx(() {
      final selectedCategories =
          controller.selectedCategories.toList();

      if (selectedCategories.isEmpty) {
        return const SizedBox.shrink();
      }

      return SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          itemCount: selectedCategories.length + 1,
          itemBuilder: (context, index) {
            // Edit categories button
            if (index == selectedCategories.length) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ActionChip(
                  avatar: Icon(
                    Icons.tune_outlined,
                    size: 14,
                    color: colors.primary,
                  ),
                  label: const Text("Edit Categories"),
                  backgroundColor: colors.surface,
                  labelStyle: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: colors.primary.withOpacity(0.3),
                    ),
                  ),
                  onPressed: () {
                    Get.bottomSheet(
                      const FilteringMenu(),
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                    );
                  },
                ),
              );
            }

            final category = selectedCategories[index];

            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterChip(
                label: Text(category),
                selected: true,
                selectedColor: colors.primary,
                labelStyle: TextStyle(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
                backgroundColor: colors.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: colors.primary,
                  ),
                ),
                showCheckmark: false,
                onSelected: (_) {
                  controller.toggleCategory(category);
                },
              ),
            );
          },
        ),
      );
    });
  }
}