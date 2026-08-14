import 'package:flutter/material.dart';

class EmptyProductsState extends StatelessWidget {
  const EmptyProductsState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 70,
      ),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 46,
            color: colors.onSurfaceVariant.withOpacity(0.45),
          ),

          const SizedBox(height: 14),

          Text(
            'No products found',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Try changing your search or add a new product.',
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