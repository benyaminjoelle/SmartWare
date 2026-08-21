import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/cart/controllers/client_cart_controller.dart';
import 'package:smartware/features/client/cart/models/cart_item_model.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    super.key,
    required this.cartItem,
  });

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // =====================================================
          // PRODUCT IMAGE
          // =====================================================
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.network(
              cartItem.product.imageUrl ?? '',
              width: 100,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  width: 100,
                  height: 120,
                  child: Icon(
                    Icons.inventory_2_outlined,
                    size: 40,
                  ),
                );
              },
            ),
          ),

          // =====================================================
          // EVERYTHING ON THE RIGHT
          // =====================================================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ================= PRODUCT NAME =================
                  Text(
                    cartItem.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // ================= WAREHOUSE =================
                  Row(
                    children: [
                      Icon(
                        Icons.warehouse_outlined,
                        size: 16,
                        color: colors.primary,
                      ),
                      const SizedBox(width: 5),

                      Expanded(
                        child: Text(
                          cartItem.warehouseName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // ================= QUANTITY + TOTAL =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total: \$${cartItem.discountedTotal.toStringAsFixed(2)}',
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colors.tertiary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

            // ================= QUANTITY CONTROLS =================
                 Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Minus
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        controller.removeSingleItem(
                          cartItem.product.sku,
                          cartItem.warehouseId,
                        );
                      },
                    ),

                    // Quantity
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        '${cartItem.quantity}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Plus
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        controller.addToCart(
                          cartItem.product,
                          1,
                          cartItem.warehouseName,
                          cartItem.warehouseId,
                          cartItem.unitPrice,
                          cartItem.discountPercentage,
                            );
                          },
                        ),
                      ],
                    )
                                ],
                              ),
                        ]
                        ),
                      ),
                      )
                      ],
                      ),
                      
                    );
                  }
}