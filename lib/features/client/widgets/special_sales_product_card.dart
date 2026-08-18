import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/product/models/product_model.dart';
import 'package:smartware/features/warehouse/models/warehouse_product_model.dart';

class SpecialSaleProductCard extends StatelessWidget {
  final Product product;
  final WarehouseProductModel warehouseProduct;

  const SpecialSaleProductCard({
    super.key,
    required this.product,
    required this.warehouseProduct,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final discount =
        warehouseProduct.discountPercentage;

    final originalPrice =
        warehouseProduct.unitPrice;

    final discountedPrice =
        discount != null
            ? originalPrice * (1 - discount / 100)
            : originalPrice;

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
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            // =========================
            // IMAGE + DISCOUNT
            // =========================

            Expanded(
              child: Stack(
                children: [

                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Container(
                      width: double.infinity,
                      color:
                          colors.surfaceContainerLow,
                      child:
                          product.imageUrl != null &&
                                  product.imageUrl!.isNotEmpty
                              ? Image.network(
                                  product.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (
                                    context,
                                    error,
                                    stackTrace,
                                  ) {
                                    return Icon(
                                      Icons
                                          .inventory_2_outlined,
                                      size: 40,
                                      color: colors
                                          .onSurface
                                          .withOpacity(0.4),
                                    );
                                  },
                                )
                              : Icon(
                                  Icons
                                      .inventory_2_outlined,
                                  size: 40,
                                  color: colors
                                      .onSurface
                                      .withOpacity(0.4),
                                ),
                    ),
                  ),

                  // DISCOUNT BADGE
                  if (discount != null && discount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(6),
                          color: colors.error,
                        ),
                        child: Text(
                          '${discount.toStringAsFixed(0)}% OFF',
                          style: TextStyle(
                            color: colors.onError,
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // =========================
            // INFO
            // =========================

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
                          overflow:
                              TextOverflow.ellipsis,
                          style: theme
                              .textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 4),

                        if (discount != null &&
                            discount > 0)
                          Row(
                            children: [

                              Text(
                                '\$${originalPrice.toStringAsFixed(2)}',
                                style: theme
                                    .textTheme.bodySmall
                                    ?.copyWith(
                                  decoration:
                                      TextDecoration
                                          .lineThrough,
                                  color: colors
                                      .onSurface
                                      .withOpacity(
                                          0.5),
                                ),
                              ),

                              const SizedBox(width: 5),

                              Text(
                                '\$${discountedPrice.toStringAsFixed(2)}',
                                style: theme
                                    .textTheme.titleSmall
                                    ?.copyWith(
                                  color:
                                      colors.primary,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        else
                          Text(
                            '\$${originalPrice.toStringAsFixed(2)}',
                            style: theme
                                .textTheme.titleSmall
                                ?.copyWith(
                              color: colors.primary,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Container(
                    padding:
                        const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius:
                          BorderRadius.circular(8),
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