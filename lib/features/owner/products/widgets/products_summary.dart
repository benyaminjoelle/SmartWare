import 'package:flutter/material.dart';

import 'package:smartware/features/owner/products/controllers/owner_products_controller.dart';

class ProductsSummary extends StatelessWidget {
  final OwnerProductsController controller;

  const ProductsSummary({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Row(
      children: [
        Expanded(
          child: _SummaryItem(
            value: controller.totalProducts.toString(),
            label: 'Products',
            icon: Icons.inventory_2_outlined,
          ),
        ),

        Expanded(
          child: _SummaryItem(
            value: controller.lowStockCount.toString(),
            label: 'Low stock',
            icon: Icons.warning_amber_rounded,
          ),
        ),

        Expanded(
          child: _SummaryItem(
            value: controller.outOfStockCount.toString(),
            label: 'Out of stock',
            icon: Icons.remove_shopping_cart_outlined,
            iconColor: colors.error,
          ),
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final  Color ?iconColor;
  const _SummaryItem({
    required this.value,
    required this.label,
    required this.icon,
    this.iconColor
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, size: 18, color:iconColor?? colors.primary),

        const SizedBox(width: 7),

        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),

              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
