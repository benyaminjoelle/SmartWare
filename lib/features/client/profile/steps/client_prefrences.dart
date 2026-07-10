import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/profile/controllers/client_profile_completion_controller.dart';
import 'package:smartware/widgets/primary_button.dart';

class PreferencesStep extends StatelessWidget {
  const PreferencesStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientProfileCompletionController>();

    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final mediaQuery = MediaQuery.of(context);

    // Data Source 1: Business Types (Full Width Rows)
    final businessTypes = const [
      (
        "Restaurant / Food Service",
        Icons.restaurant_rounded,
        "Cafes, diners, fast food, and cloud kitchens",
      ),
      (
        "Supermarket / Grocery",
        Icons.local_grocery_store_rounded,
        "Fresh produce, daily essentials, and hypermarkets",
      ),
      (
        "Shopping Mall / Plaza",
        Icons.bento_rounded,
        "Multi-department venues and large-scale retail hubs",
      ),
    ];

    // Data Source 2: Warehouse Category Preferences (Grid)
    final warehouseCategories = const [
      (
        "Dry Storage",
        Icons.hd_rounded,
      ), // Substitute with appropriate material icons like Icons.inventory_2_rounded if needed
      ("Cold Chain", Icons.ac_unit_rounded),
      ("Hazardous Material", Icons.warning_amber_rounded),
      ("High-Density Racking", Icons.grid_view_rounded),
    ];

    // Responsive structural calculations
    final screenWidth = mediaQuery.size.width;
    final int gridCrossAxisCount = screenWidth > 600 ? 4 : 2;

    final double gridItemHeight = 100.0;
    final double gridItemWidth =
        (screenWidth - (32 + (gridCrossAxisCount - 1) * 12)) /
        gridCrossAxisCount;
    final double gridAspectRatio = gridItemWidth / gridItemHeight;

    return Obx(() {
      // Assuming you added these reactive strings/observables to your ClientProfileCompletionController
      final selectedType = controller.selectedCategories;
      final selectedCategory = controller.selectedCategories;

      final isButtonDisabled = selectedType.isEmpty || selectedCategory.isEmpty;

      return Column(
        key: const ValueKey("business_and_warehouse_preferences"),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// =========================================================
                  /// HEADER SECTION
                  /// =========================================================
                  Text(
                    "Setup your business profile",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Configure your core operations and warehouse alignment",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// =========================================================
                  /// SECTION 1: BUSINESS TYPE (FULL WIDTH LIST)
                  /// =========================================================
                  Row(
                    children: [
                      Text(
                        "1. Business Type",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                      ),
                      const Spacer(),
                      if (selectedType.isNotEmpty)
                        Icon(Icons.check_circle, color: cs.primary, size: 18),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: businessTypes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = businessTypes[index];
                      final title = item.$1;
                      final icon = item.$2;
                      final subtitle = item.$3;

                      final isTypeSelected = selectedType == title;

                      return GestureDetector(
                        // onTap: () => controller.businessType.value = title;
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: isTypeSelected
                                ? cs.primary.withValues(alpha: 0.08)
                                : cs.surfaceContainerLow,
                            border: Border.all(
                              color: isTypeSelected
                                  ? cs.primary
                                  : cs.outline.withValues(alpha: 0.15),
                              width: isTypeSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                icon,
                                size: 28,
                                color: isTypeSelected
                                    ? cs.primary
                                    : cs.onSurface.withValues(alpha: 0.6),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            fontWeight: isTypeSelected
                                                ? FontWeight.bold
                                                : FontWeight.w600,
                                            color: isTypeSelected
                                                ? cs.primary
                                                : cs.onSurface,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      subtitle,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: cs.onSurface.withValues(
                                              alpha: 0.5,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Radio<String>(
                                value: title,

                                activeColor: cs.primary,
                                onChanged: (value) {
                                  // if (value != null) controller.businessType.value = value;
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 28),

                  /// =========================================================
                  /// SECTION 2: WAREHOUSE CATEGORIES (GRID STYLE)
                  /// =========================================================
                  Row(
                    children: [
                      Text(
                        "2. Warehouse Category Preference",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                      ),
                      const Spacer(),
                      if (selectedCategory.isNotEmpty)
                        Icon(Icons.check_circle, color: cs.primary, size: 18),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: warehouseCategories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridCrossAxisCount,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: gridAspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      final category = warehouseCategories[index];
                      final catLabel = category.$1;
                      final catIcon = category.$2;

                      final isCatSelected = selectedCategory == catLabel;

                      return GestureDetector(
                        // onTap: () => controller.warehouseCategory.value = catLabel;
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: isCatSelected
                                ? cs.secondary.withValues(alpha: 0.08)
                                : cs.surfaceContainerLow,
                            border: Border.all(
                              color: isCatSelected
                                  ? cs.secondary
                                  : cs.outline.withValues(alpha: 0.15),
                              width: isCatSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                catIcon,
                                size: 24,
                                color: isCatSelected
                                    ? cs.secondary
                                    : cs.onSurface.withValues(alpha: 0.65),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                catLabel,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: isCatSelected
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                  color: isCatSelected
                                      ? cs.secondary
                                      : cs.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          /// =========================================================
          /// FOOTER ACTION (PRIMARY BUTTON)
          /// =========================================================
          PrimaryButton(
            text: "Continue",
            isDisabled: isButtonDisabled,
            isLoading: false,
            onPressed: controller.nextStep,
          ),
        ],
      );
    });
  }
}
