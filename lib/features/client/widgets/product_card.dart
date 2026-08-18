import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/product/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Container(
                  width: double.infinity,
                  color: colors.surfaceContainerLow,
                  child: product.imageUrl != null &&
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
                              Icons.inventory_2_outlined,
                              size: 40,
                              color: colors.onSurface.withOpacity(0.4),
                            );
                          },
                        )
                      : Icon(
                          Icons.inventory_2_outlined,
                          size: 40,
                          color: colors.onSurface.withOpacity(0.4),
                        ),
                ),
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
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          product.unit,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(
                            color: colors.onSurface
                                .withOpacity(0.55),
                          ),
                        ),
                        const SizedBox(height: 4),

                          Text(
                          product.companyName,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(
                            color: colors.onSurface
                                .withOpacity(0.55),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // ADD BUTTON
                  InkWell(
                    onTap: () {
                      Get.toNamed(
                        '/productDetails',
                        arguments: product,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
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