import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/home/controllers/product_details_controller.dart';


class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailsController>();

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Obx(
          () {
            final product = controller.product.value;

            return Stack(
              children: [
                ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // =========================================================
                    // PRODUCT IMAGE
                    // =========================================================

                    _ProductHeroImage(
                      imageUrl: product.imageUrl,
                    ),

                    // =========================================================
                    // PRODUCT INFORMATION
                    // =========================================================

                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        22,
                        20,
                        130,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          // CATEGORY
                          Text(
                            product.category.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // NAME
                          Text(
                            product.name,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                            ),
                          ),

                          const SizedBox(height: 14),

                          // DESCRIPTION
                          Text(
                            product.description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                              height: 1.6,
                            ),
                          ),

                          const SizedBox(height: 28),

                          // ===================================================
                          // QUANTITY
                          // ===================================================

                          _SectionTitle(
                            title: 'Quantity',
                            subtitle: 'Choose how much you need',
                          ),

                          const SizedBox(height: 12),

                          _QuantitySelector(
                            controller: controller,
                          ),

                          const SizedBox(height: 28),

                          // ===================================================
                          // WAREHOUSE BUTTON
                          // ===================================================

                          _WarehouseAvailabilityButton(
                            controller: controller,
                          ),

                          const SizedBox(height: 20),

                          // ===================================================
                          // WAREHOUSES
                          // ===================================================

                          Obx(
                            () {
                              if (!controller.hasCheckedAvailability.value) {
                                return const SizedBox.shrink();
                              }

                              if (controller.availableWarehouses.isEmpty) {
                                return const _NoWarehouseState();
                              }

                              return _WarehouseSelection(
                                controller: controller,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // =============================================================
                // BACK BUTTON
                // =============================================================

                Positioned(
                  top: 14,
                  left: 16,
                  child: _FloatingButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Get.back(),
                  ),
                ),

                // =============================================================
                // CART BUTTON
                // =============================================================

                Positioned(
                  top: 14,
                  right: 16,
                  child: _FloatingButton(
                    icon: Icons.shopping_bag_outlined,
                    onTap: () {
                      // TODO:
                      // Navigate to cart.
                    },
                  ),
                ),

                // =============================================================
                // BOTTOM ADD TO CART
                // =============================================================

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _BottomCartBar(
                    controller: controller,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// =============================================================================
// HERO IMAGE
// =============================================================================

class _ProductHeroImage extends StatelessWidget {
  final String? imageUrl;

  const _ProductHeroImage({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final hasImage =
        imageUrl != null && imageUrl!.trim().isNotEmpty;

    return SizedBox(
      height: 340,
      width: double.infinity,
      child: hasImage
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return const _EmptyProductImage();
              },
            )
          : const _EmptyProductImage(),
    );
  }
}

// =============================================================================
// EMPTY IMAGE
// =============================================================================

class _EmptyProductImage extends StatelessWidget {
  const _EmptyProductImage();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      color: colors.surfaceContainerHighest.withOpacity(0.45),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 52,
          color: colors.onSurfaceVariant.withOpacity(0.45),
        ),
      ),
    );
  }
}

// =============================================================================
// FLOATING BUTTON
// =============================================================================

class _FloatingButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _FloatingButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface.withOpacity(0.94),
      shape: const CircleBorder(),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.12),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            size: 21,
            color: colors.onSurface,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// SECTION TITLE
// =============================================================================

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// QUANTITY SELECTOR
// =============================================================================

class _QuantitySelector extends StatelessWidget {
  final ProductDetailsController controller;

  const _QuantitySelector({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withOpacity(0.45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _QuantityButton(
            icon: Icons.remove_rounded,
            onTap: controller.decreaseQuantity,
          ),

          Expanded(
            child: Center(
              child: Obx(
                () => Text(
                  '${controller.quantity.value}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ),
          ),

          _QuantityButton(
            icon: Icons.add_rounded,
            onTap: controller.increaseQuantity,
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 54,
          height: 56,
          child: Icon(
            icon,
            color: colors.primary,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// WAREHOUSE AVAILABILITY BUTTON
// =============================================================================

class _WarehouseAvailabilityButton extends StatelessWidget {
  final ProductDetailsController controller;

  const _WarehouseAvailabilityButton({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Obx(
      () {
        final isLoading =
            controller.isCheckingAvailability.value;

        return Material(
          color: colors.primaryContainer,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: isLoading
                ? null
                : controller.checkWarehouseAvailability,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 15,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warehouse_outlined,
                    color: colors.primary,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          isLoading
                              ? 'Checking availability...'
                              : 'Find available warehouses',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'For ${controller.quantity.value} ${controller.product.value.unit}${controller.quantity.value == 1 ? '' : 's'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: colors.primary.withOpacity(0.75),
                              ),
                        ),
                      ],
                    ),
                  ),

                  if (isLoading)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.primary,
                      ),
                    )
                  else
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: colors.primary,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// WAREHOUSE SELECTION
// =============================================================================

class _WarehouseSelection extends StatelessWidget {
  final ProductDetailsController controller;

  const _WarehouseSelection({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: 'Choose a warehouse',
          subtitle:
              'Prices may vary depending on the warehouse',
        ),

        const SizedBox(height: 12),

        Obx(
          () {
            return Column(
              children: controller.availableWarehouses
                  .map(
                    (warehouse) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: _WarehouseCard(
                        warehouse: warehouse,
                        isSelected:
                            controller.selectedWarehouse.value?.id ==
                                warehouse.id,
                        onTap: () {
                          controller.selectWarehouse(
                            warehouse,
                          );
                        },
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

// =============================================================================
// WAREHOUSE CARD
// =============================================================================

class _WarehouseCard extends StatelessWidget {
  final ProductWarehouseModel warehouse;
  final bool isSelected;
  final VoidCallback onTap;

  const _WarehouseCard({
    required this.warehouse,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.primaryContainer.withOpacity(0.55)
                : colors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? colors.primary.withOpacity(0.35)
                  : colors.surfaceContainerHighest,
              width: isSelected ? 1.3 : 1,
            ),
          ),
          child: Row(
            children: [
              _WarehouseImage(
                imageUrl: warehouse.imageUrl,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      warehouse.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            warehouse.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Text(
                      '${warehouse.availableQuantity} ${warehouse.availableQuantity == 1 ? 'available' : 'available'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${warehouse.price.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.primary,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    'per ${'unit'}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 7),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? colors.primary
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? colors.primary
                            : colors.outlineVariant,
                        width: 1.5,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check_rounded,
                            size: 14,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// WAREHOUSE IMAGE
// =============================================================================

class _WarehouseImage extends StatelessWidget {
  final String? imageUrl;

  const _WarehouseImage({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final hasImage =
        imageUrl != null && imageUrl!.trim().isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: SizedBox(
        width: 52,
        height: 52,
        child: hasImage
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return _empty(colors);
                },
              )
            : _empty(colors),
      ),
    );
  }

  Widget _empty(ColorScheme colors) {
    return Container(
      color: colors.surfaceContainerHighest.withOpacity(0.45),
      child: Icon(
        Icons.warehouse_outlined,
        size: 24,
        color: colors.onSurfaceVariant.withOpacity(0.5),
      ),
    );
  }
}

// =============================================================================
// NO WAREHOUSE
// =============================================================================

class _NoWarehouseState extends StatelessWidget {
  const _NoWarehouseState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            Icons.warehouse_outlined,
            size: 34,
            color: colors.onSurfaceVariant.withOpacity(0.55),
          ),

          const SizedBox(height: 10),

          Text(
            'No warehouse can fulfill this quantity',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Try reducing the quantity and check again.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// BOTTOM CART BAR
// =============================================================================

class _BottomCartBar extends StatelessWidget {
  final ProductDetailsController controller;

  const _BottomCartBar({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        14,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Obx(
                () => Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$${controller.totalPrice.toStringAsFixed(2)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              flex: 2,
              child: Obx(
                () {
                  final hasWarehouse =
                      controller.selectedWarehouse.value != null;

                  final isLoading =
                      controller.isAddingToCart.value;

                  return SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed:
                          !hasWarehouse || isLoading
                              ? null
                              : controller.addToCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            colors.surfaceContainerHighest,
                        disabledForegroundColor:
                            colors.onSurfaceVariant,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 21,
                              height: 21,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  hasWarehouse
                                      ? 'Add to cart'
                                      : 'Choose warehouse',
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight:
                                        FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}