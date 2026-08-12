import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/home/controllers/client_home_controller.dart';

class FilteringMenu extends StatelessWidget {
  const FilteringMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientHomeController>();
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return SafeArea(
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: color.onSurface.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // Title & Clear Action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Filtering".tr,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => controller.resetFilters(),
                      child: Text("Reset".tr),
                    ),
                  ],
                ),
                const Divider(height: 24, thickness: 0.5),

                // Scrollable Body Content
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    children: [
                     
                      Text(
                        "Product Sector".tr,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Obx(() => Wrap(
                            spacing: 8,
                            children: controller.userOnboardingSectors.map((sector) {
                              final isSelected = controller.selectedProductTypes.contains(sector);
                              return FilterChip(
                                label: Text(sector.capitalizeFirst!),
                                selected: isSelected,
                                onSelected: (_) => controller.toggleProductType(sector),
                              );
                            }).toList(),
                          )),

                      const SizedBox(height: 20),

                      // --- 2. CONTAINER TYPES ---
                      Text(
                        "Container Type".tr,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Obx(() => Wrap(
                            spacing: 8,
                            children: controller.availableContainerTypes.map((container) {
                              final isSelected = controller.selectedContainerTypes.contains(container);
                              return FilterChip(
                                label: Text(container),
                                selected: isSelected,
                                onSelected: (_) => controller.toggleContainerType(container),
                              );
                            }).toList(),
                          )),

                      const SizedBox(height: 20),

                      // --- 3. PRICE RANGE SLIDER ---
                      Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Price Range".tr,
                                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "\$${controller.priceRange.value.start.toStringAsFixed(1)} - \$${controller.priceRange.value.end.toStringAsFixed(1)}",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: color.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              RangeSlider(
                                values: controller.priceRange.value,
                                min: controller.minPossiblePrice,
                                max: controller.maxPossiblePrice,
                                divisions: 20,
                                labels: RangeLabels(
                                  "\$${controller.priceRange.value.start.toStringAsFixed(0)}",
                                  "\$${controller.priceRange.value.end.toStringAsFixed(0)}",
                                ),
                                onChanged: (RangeValues values) {
                                  controller.priceRange.value = values;
                                },
                              ),
                            ],
                          )),

                      const SizedBox(height: 30),

                      // --- 4. APPLY BUTTON ---
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color.primary,
                            foregroundColor: color.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            controller.applyFilters();
                            Get.back(); // Dismiss BottomSheet
                          },
                          child: Text(
                            "Apply Filters".tr,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}