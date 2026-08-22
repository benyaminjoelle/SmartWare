import 'package:flutter/material.dart';

import 'package:smartware/features/owner/products/models/owner_inventory_model.dart';
import 'package:smartware/features/owner/products/widgets/product_image.dart';

class ProductCard extends StatelessWidget {
  final OwnerInventoryModel product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final productInfo = product.product;

    // ============================================================
    // STOCK STATUS
    // ============================================================

    final Color statusColor;
    final String statusText;

    if (product.quantity <= 0) {
      statusColor = colors.error;
      statusText = 'Out of stock';
    } else if (product.quantity < 25) {
      statusColor = Colors.orange;
      statusText = 'Low stock';
    } else {
      statusColor = colors.primary;
      statusText = 'In stock';
    }

    // ============================================================
    // PRODUCT NAME
    // ============================================================

    final String productName =
        productInfo.nameEn.trim().isNotEmpty
            ? productInfo.nameEn
            : productInfo.nameAr;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 16,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // ============================================================
              // IMAGE
              // ============================================================

              ProductImage(
                imageUrl: productInfo.productImage,
              ),

              const SizedBox(width: 14),

              // ============================================================
              // PRODUCT INFO
              // ============================================================

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      productInfo.sku,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Unit: ${productInfo.unit}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),

                        const SizedBox(width: 7),

                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: colors.onSurfaceVariant,
                            shape: BoxShape.circle,
                          ),
                        ),

                        const SizedBox(width: 7),

                        Flexible(
                          child: Text(
                            statusText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // ============================================================
              // STOCK / PRICE
              // ============================================================

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    product.quantity.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: statusColor,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    productInfo.unit,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontSize: 10,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    product.unitPrice.toStringAsFixed(2),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 8),

              // ============================================================
              // ARROW
              // ============================================================

              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}