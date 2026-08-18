import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/client/profile/controllers/client_profile_completion_controller.dart';
import 'package:smartware/features/client/profile/widgets/product_type_model.dart';

class ProductTypeSection extends StatelessWidget {
  const ProductTypeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientProfileCompletionController>();

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Obx(() {
      final hasBusiness =
          controller.selectedBusinessType.value.isNotEmpty;

      final products = controller.availableProducts;

      if (!hasBusiness) {
        return const _EmptyProductState();
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth >= 800;

          final header = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Product Types",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w300,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Select the product categories that describes your business.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant.withValues(alpha: .7),
                  height: 1.5,
                ),
              ),
            ],
          );

          final list = Obx(() {
            final selectedProducts =
                controller.selectedProducts.toList();

            final displayedProducts =
                (controller.isProductsExpanded.value ||
                        products.length <= 4)
                    ? products
                    : products.take(4).toList();

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: displayedProducts.length,
                  itemBuilder: (_, index) {
                    final item = displayedProducts[index];

                    // IMPORTANT:
                    // Every selected product remains selected.
                    final selected =
                        selectedProducts.contains(item.id);

                    return _ProductTile(
                      item: item,
                      selected: selected,
                      onTap: () {
                        controller.toggleCategory(item.id);
                      },
                    );
                  },
                ),

                if (products.length > 4)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Center(
                      child: TextButton.icon(
                        onPressed: () {
                          controller.isProductsExpanded.toggle();
                        },
                        icon: Icon(
                          controller.isProductsExpanded.value
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: cs.primary,
                        ),
                        label: Text(
                          controller.isProductsExpanded.value
                              ? "Show Less"
                              : "Show More (${products.length - 4} more)",
                          style: TextStyle(
                            color: cs.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          });

          if (isLargeScreen) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: header,
                ),
                const SizedBox(width: 64),
                Expanded(
                  flex: 5,
                  child: list,
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header,
              const SizedBox(height: 32),
              list,
            ],
          );
        },
      );
    });
  }
}

class _EmptyProductState extends StatelessWidget {
  const _EmptyProductState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48,
            color: cs.outline,
          ),
          const SizedBox(height: 16),
          Text(
            "Choose a business type first",
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            "Available product categories will appear automatically based on your selected business.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final ProductTypeModel item;
  final bool selected;
  final VoidCallback onTap;

  const _ProductTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        hoverColor: cs.primary.withValues(alpha: 0.02),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: selected
                ? cs.primary.withValues(alpha: .06)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? cs.primary.withValues(alpha: .35)
                  : cs.outline.withValues(alpha: .15),
            ),
          ),
          child: Stack(
            children: [
              // =========================
              // SELECTION INDICATOR
              // =========================

              Positioned(
                top: 12,
                right: 12,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected
                        ? cs.primary
                        : Colors.transparent,
                    border: Border.all(
                      color: selected
                          ? cs.primary
                          : cs.outline.withValues(alpha: .5),
                      width: 2,
                    ),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: selected
                        ? Icon(
                            Icons.check,
                            key: const ValueKey('selected'),
                            size: 13,
                            color: cs.onPrimary,
                          )
                        : const SizedBox(
                            key: ValueKey('unselected'),
                          ),
                  ),
                ),
              ),

              // =========================
              // CONTENT
              // =========================

              Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration:
                            const Duration(milliseconds: 220),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: selected
                              ? cs.primary.withValues(alpha: .10)
                              : cs.surfaceContainerHighest,
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: Icon(
                          item.icon,
                          size: 20,
                          color: selected
                              ? cs.primary
                              : cs.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}