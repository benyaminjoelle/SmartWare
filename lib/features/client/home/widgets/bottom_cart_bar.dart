import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/home/controllers/product_details_controller.dart';
import 'package:smartware/features/product/models/product_model.dart';

class BottomCartBar extends StatelessWidget {
  final ProductDetailsController controller;
  final Product product;

  const BottomCartBar({
    super.key,
    required this.controller,
    required this.product,
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
                () {
                  final total = controller.totalPrice;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        '\$${total.toStringAsFixed(2)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              flex: 2,
              child: Obx(
                () {
                  final hasWarehouse =
                      controller.selectedWarehouse.value != null;

                  return SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: !hasWarehouse
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
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
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