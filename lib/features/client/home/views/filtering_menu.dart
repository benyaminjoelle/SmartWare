import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/product/controllers/product_controller.dart';

class FilteringMenu extends StatelessWidget {
  const FilteringMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return SafeArea(
      child: DraggableScrollableSheet(
        initialChildSize: 0.88,
        minChildSize: 0.45,
        maxChildSize: 0.96,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 30,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: Column(
              children: [
                // ===========================================================
                // HEADER
                // ===========================================================

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 16, 0),
                  child: Column(
                    children: [
                      // Handle
                      Container(
                        width: 42,
                        height: 5,
                        decoration: BoxDecoration(
                          color: color.onSurface.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      const SizedBox(height: 18),

                      Row(
                        children: [
                          // Filter icon
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: color.primary.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.tune_rounded,
                              color: color.primary,
                              size: 22,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Filtering".tr,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Refine your product search".tr,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: color.onSurface.withOpacity(0.55),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          TextButton(
                            onPressed: controller.resetFilters,
                            style: TextButton.styleFrom(
                              foregroundColor: color.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            child: Text(
                              "Reset".tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      Divider(
                        height: 1,
                        thickness: 0.7,
                        color: color.onSurface.withOpacity(0.08),
                      ),
                    ],
                  ),
                ),

                // ===========================================================
                // CONTENT
                // ===========================================================

                Expanded(
                  child: ListView(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                    children: [
                      // =====================================================
                      // BUSINESS CATEGORIES
                      // =====================================================

                      _SectionHeader(
                        title: "Business Categories".tr,
                        icon: Icons.category_outlined,
                        theme: theme,
                        color: color,
                      ),

                      const SizedBox(height: 12),

                      Obx(
                        () => Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: controller.filterCategories.map(
                            (category) {
                              final isSelected =
                                  controller.selectedCategories.contains(
                                category,
                              );

                              return _PremiumFilterChip(
                                label: category
                                    .replaceAll('_', ' ')
                                    .capitalizeFirst!,
                                selected: isSelected,
                                icon: Icons.check_rounded,
                                onTap: () {
                                  controller.toggleCategory(category);
                                },
                                theme: theme,
                                color: color,
                              );
                            },
                          ).toList(),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // =====================================================
                      // UNIT
                      // =====================================================

                      _SectionHeader(
                        title: "Unit".tr,
                        icon: Icons.inventory_2_outlined,
                        theme: theme,
                        color: color,
                      ),

                      const SizedBox(height: 12),

                      Obx(
                        () => Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: controller.availableUnits.map(
                            (unit) {
                              final isSelected =
                                  controller.selectedUnit.contains(unit);

                              return _PremiumFilterChip(
                                label: unit,
                                selected: isSelected,
                                icon: Icons.check_rounded,
                                onTap: () {
                                  controller.toggleUnit(unit);
                                },
                                theme: theme,
                                color: color,
                              );
                            },
                          ).toList(),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // =====================================================
                      // PRICE RANGE
                      // =====================================================

                      _SectionHeader(
                        title: "Price Range".tr,
                        icon: Icons.payments_outlined,
                        theme: theme,
                        color: color,
                      ),

                      const SizedBox(height: 12),

                      Obx(
                        () => Container(
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            16,
                            16,
                            12,
                          ),
                          decoration: BoxDecoration(
                            color: color.onSurface.withOpacity(0.035),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: color.onSurface.withOpacity(0.07),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _PriceBadge(
                                    value:
                                        "\$${controller.priceRange.value.start.toStringAsFixed(1)}",
                                    color: color,
                                    theme: theme,
                                  ),
                                  Text(
                                    "to".tr,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color:
                                          color.onSurface.withOpacity(0.45),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  _PriceBadge(
                                    value:
                                        "\$${controller.priceRange.value.end.toStringAsFixed(1)}",
                                    color: color,
                                    theme: theme,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 4,
                                  activeTrackColor: color.primary,
                                  inactiveTrackColor:
                                      color.onSurface.withOpacity(0.10),
                                  thumbColor: color.primary,
                                  overlayColor:
                                      color.primary.withOpacity(0.10),
                                  rangeThumbShape:
                                      const RoundRangeSliderThumbShape(
                                    enabledThumbRadius: 9,
                                  ),
                                ),
                                child: RangeSlider(
                                  values: controller.priceRange.value,
                                  min: controller.minPossiblePrice,
                                  max: controller.maxPossiblePrice,
                                  divisions: 20,
                                  onChanged: (RangeValues values) {
                                    controller.updatePriceRange(values);
                                  },
                                ),
                              ),

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "\$${controller.minPossiblePrice.toStringAsFixed(0)}",
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: color.onSurface.withOpacity(
                                          0.45,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "\$${controller.maxPossiblePrice.toStringAsFixed(0)}",
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: color.onSurface.withOpacity(
                                          0.45,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ===========================================================
                // BOTTOM APPLY AREA
                // ===========================================================

                Container(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                  decoration: BoxDecoration(
                    color: color.surface,
                    border: Border(
                      top: BorderSide(
                        color: color.onSurface.withOpacity(0.07),
                      ),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.applyFilters();
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: color.primary,
                          foregroundColor: color.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_rounded,
                              size: 21,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Apply Filters".tr,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

// ===========================================================================
// SECTION HEADER
// ===========================================================================

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final ThemeData theme;
  final ColorScheme color;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.theme,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 17,
            color: color.primary,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// PREMIUM FILTER CHIP
// ===========================================================================

class _PremiumFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;
  final ThemeData theme;
  final ColorScheme color;

  const _PremiumFilterChip({
    required this.label,
    required this.selected,
    required this.icon,
    required this.onTap,
    required this.theme,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: selected
                ? color.primary.withOpacity(0.10)
                : color.onSurface.withOpacity(0.035),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: selected
                  ? color.primary.withOpacity(0.45)
                  : color.onSurface.withOpacity(0.08),
              width: selected ? 1.2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                Icon(
                  icon,
                  size: 15,
                  color: color.primary,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected
                      ? color.primary
                      : color.onSurface.withOpacity(0.75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// PRICE BADGE
// ===========================================================================

class _PriceBadge extends StatelessWidget {
  final String value;
  final ColorScheme color;
  final ThemeData theme;

  const _PriceBadge({
    required this.value,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.primary.withOpacity(0.09),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        value,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: color.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}