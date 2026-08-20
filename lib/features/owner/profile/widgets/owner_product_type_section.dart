import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/client/profile/widgets/product_type_model.dart';
import 'package:smartware/features/owner/profile/controllers/owner_profile_complition_controller.dart';

class OwnerProductTypeSection extends StatelessWidget {
  const OwnerProductTypeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.find<OwnerProfileComplitionController>();

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Obx(() {
      // ==========================================================
      // OWNER PRODUCTS ARE INDEPENDENT OF BUSINESS TYPE
      // ==========================================================

      final products = controller.allProducts;

      final isExpanded =
          controller.isProductsExpanded.value;

      final selectedProducts =
          controller.selectedProducts.toList();

      // ==========================================================
      // DISPLAY PRODUCTS
      // ==========================================================

      final displayedProducts =
          (isExpanded || products.length <= 4)
              ? products
              : products.take(4).toList();

      // ==========================================================
      // HEADER
      // ==========================================================

      final header = Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Product Types',
            style:
                theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w300,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Select the product categories that describe your business.',
            style:
                theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant
                  .withValues(alpha: .7),
              height: 1.5,
            ),
          ),
        ],
      );

      // ==========================================================
      // PRODUCT LIST
      // ==========================================================

      final list = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (products.isEmpty)
            const _NoProductsState()
          else
            GridView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemCount:
                  displayedProducts.length,
              itemBuilder: (_, index) {
                final item =
                    displayedProducts[index];

                final selected =
                    selectedProducts.contains(
                  item.id,
                );

                return _ProductTile(
                  item: item,
                  selected: selected,
                  onTap: () {
                    controller.toggleProduct(
                      item.id,
                    );
                  },
                );
              },
            ),

          // ======================================================
          // SHOW MORE
          // ======================================================

          if (products.length > 4)
            Padding(
              padding:
                  const EdgeInsets.only(top: 16),
              child: Center(
                child: TextButton.icon(
                  onPressed: () {
                    controller
                        .isProductsExpanded
                        .toggle();
                  },
                  icon: Icon(
                    isExpanded
                        ? Icons
                            .keyboard_arrow_up_rounded
                        : Icons
                            .keyboard_arrow_down_rounded,
                    color: cs.primary,
                  ),
                  label: Text(
                    isExpanded
                        ? 'Show Less'
                        : 'Show More (${products.length - 4} more)',
                    style: TextStyle(
                      color: cs.primary,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      );

      // ==========================================================
      // RESPONSIVE LAYOUT
      // ==========================================================

      return LayoutBuilder(
        builder:
            (context, constraints) {
          final isLargeScreen =
              constraints.maxWidth >= 800;

          if (isLargeScreen) {
            return Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
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
            crossAxisAlignment:
                CrossAxisAlignment.start,
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

// ================================================================
// NO PRODUCTS
// ================================================================

class _NoProductsState
    extends StatelessWidget {
  const _NoProductsState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color:
              cs.outline.withValues(alpha: .15),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.category_outlined,
            size: 42,
            color: cs.outline,
          ),
          const SizedBox(height: 12),
          Text(
            'No product categories available',
            style:
                theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'No product categories are currently available.',
            style:
                theme.textTheme.bodyMedium
                    ?.copyWith(
              color: cs.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ================================================================
// PRODUCT TILE
// ================================================================

class _ProductTile
    extends StatelessWidget {
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
        borderRadius:
            BorderRadius.circular(12),
        hoverColor:
            cs.primary.withValues(alpha: .02),
        splashColor: Colors.transparent,
        highlightColor:
            Colors.transparent,
        child: AnimatedContainer(
          duration:
              const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: selected
                ? cs.primary
                    .withValues(alpha: .06)
                : Colors.transparent,
            borderRadius:
                BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? cs.primary
                      .withValues(alpha: .35)
                  : cs.outline
                      .withValues(alpha: .15),
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ==================================================
              // CHECK
              // ==================================================

              Positioned(
                top: 12,
                right: 12,
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 220,
                  ),
                  width: 22,
                  height: 22,
                  decoration:
                      BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? cs.primary
                          : cs.outline
                              .withValues(
                              alpha: .5,
                            ),
                      width: 2,
                    ),
                    color: selected
                        ? cs.primary
                        : Colors.transparent,
                  ),
                  child: AnimatedSwitcher(
                    duration:
                        const Duration(
                      milliseconds: 180,
                    ),
                    child: selected
                        ? Icon(
                            Icons.check,
                            key:
                                const ValueKey(
                              true,
                            ),
                            size: 13,
                            color:
                                cs.onPrimary,
                          )
                        : const SizedBox(
                            key:
                                ValueKey(false),
                          ),
                  ),
                ),
              ),

              // ==================================================
              // CONTENT
              // ==================================================

              Padding(
                padding:
                    const EdgeInsets.all(16),
                child: Align(
                  alignment:
                      Alignment.center,
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration:
                            const Duration(
                          milliseconds: 220,
                        ),
                        width: 44,
                        height: 44,
                        decoration:
                            BoxDecoration(
                          color: selected
                              ? cs.primary
                                  .withValues(
                                  alpha: .10,
                                )
                              : cs
                                  .surfaceContainerHighest,
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),
                        child: Icon(
                          item.icon,
                          size: 20,
                          color: selected
                              ? cs.primary
                              : cs
                                  .onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        item.title,
                        textAlign:
                            TextAlign.center,
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                        style: theme
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                          fontWeight:
                              FontWeight.w400,
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