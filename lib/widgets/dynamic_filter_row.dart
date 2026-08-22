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
      final categories = controller.filterCategories;
      final selectedCategories = controller.selectedCategories;

      return SizedBox(
        height: 46,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          itemCount: categories.length + 2,
          itemBuilder: (context, index) {
            // ============================================================
            // ALL BUTTON
            // ============================================================

            if (index == 0) {
              final isAllSelected = selectedCategories.isEmpty;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _QuickFilterChip(
                  label: "All".tr,
                  selected: isAllSelected,
                  icon: Icons.grid_view_rounded,
                  colors: colors,
                  theme: theme,
                  onTap: () {
                    controller.resetFilters();
                  },
                ),
              );
            }

            // ============================================================
            // EDIT FILTERS BUTTON
            // ============================================================

            if (index == categories.length + 1) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _EditFilterChip(
                  colors: colors,
                  theme: theme,
                  onTap: () {
                    Get.bottomSheet(
                      const FilteringMenu(),
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                    );
                  },
                ),
              );
            }

            // ============================================================
            // CATEGORY
            // ============================================================

            final category = categories[index - 1];

            final isSelected = selectedCategories.contains(category);

            final label = category
                .replaceAll('_', ' ')
                .capitalizeFirst!;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _QuickFilterChip(
                label: label,
                selected: isSelected,
                icon: Icons.check_rounded,
                colors: colors,
                theme: theme,
                onTap: () {
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

// ============================================================================
// QUICK FILTER CHIP
// ============================================================================

class _QuickFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final IconData icon;
  final ColorScheme colors;
  final ThemeData theme;
  final VoidCallback onTap;

  const _QuickFilterChip({
    required this.label,
    required this.selected,
    required this.icon,
    required this.colors,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: selected
                ? colors.primary
                : colors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? colors.primary
                  : colors.onSurface.withOpacity(0.08),
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: colors.primary.withOpacity(0.18),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                Icon(
                  icon,
                  size: 15,
                  color: colors.onPrimary,
                ),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: selected
                      ? colors.onPrimary
                      : colors.onSurface.withOpacity(0.75),
                  fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// EDIT FILTER CHIP
// ============================================================================

class _EditFilterChip extends StatelessWidget {
  final ColorScheme colors;
  final ThemeData theme;
  final VoidCallback onTap;

  const _EditFilterChip({
    required this.colors,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: colors.primary.withOpacity(0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colors.primary.withOpacity(0.25),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tune_rounded,
                size: 16,
                color: colors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                "Filters".tr,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}