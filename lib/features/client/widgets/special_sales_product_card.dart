import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/product/models/product_model.dart';

class SpecialSaleProductCard extends StatelessWidget {
  final Product product;

  const SpecialSaleProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final discountedInventories = product.inventories
        .where(
          (inventory) =>
              inventory.quantity > 0 &&
              inventory.hasDiscount,
        )
        .toList();

    if (discountedInventories.isEmpty) {
      return const SizedBox.shrink();
    }

    final inventory = discountedInventories.reduce(
      (a, b) =>
          a.discountedPrice < b.discountedPrice ? a : b,
    );

    final originalPrice = inventory.unitPrice;
    final discount = inventory.activeDiscount!;
    final discountedPrice = inventory.discountedPrice;

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          '/productDetails',
          arguments: product,
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(
          right: 14,
          bottom: 8,
        ),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colors.onSurface.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 155,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Container(
                      width: double.infinity,
                      color: colors.surfaceContainerLow,
                      child: product.imageUrl != null &&
                              product.imageUrl!.isNotEmpty &&
                              product.imageUrl != '0'
                          ? Image.network(
                              product.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (
                                context,
                                error,
                                stackTrace,
                              ) {
                                return Center(
                                  child: Icon(
                                    Icons.inventory_2_outlined,
                                    size: 40,
                                    color: colors.onSurface
                                        .withOpacity(0.4),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Icon(
                                Icons.inventory_2_outlined,
                                size: 40,
                                color: colors.onSurface
                                    .withOpacity(0.4),
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: colors.error,
                      ),
                      child: Text(
                        '${discount.percentage.toStringAsFixed(0)}% ${'OFF'.tr}',
                        style: TextStyle(
                          color: colors.onError,
                          fontWeight: FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                '\$${originalPrice.toStringAsFixed(2)}',
                                maxLines: 1,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: theme
                                    .textTheme.bodySmall
                                    ?.copyWith(
                                  decoration:
                                      TextDecoration.lineThrough,
                                  color: colors.onSurface
                                      .withOpacity(0.5),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '\$${discountedPrice.toStringAsFixed(2)}',
                                maxLines: 1,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: theme
                                    .textTheme.titleSmall
                                    ?.copyWith(
                                  color: colors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
