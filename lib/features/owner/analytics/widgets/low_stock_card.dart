import 'package:flutter/material.dart';

import 'package:smartware/features/owner/analytics/controllers/owner_analytic_controller.dart';

class LowStockCard extends StatelessWidget {
  final OwnerAnalyticsController controller;

  const LowStockCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Low stock',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Products that need attention',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 18),

          if (controller.lowStockProducts.isEmpty)
            const _NoLowStockProducts()
          else
            ...controller.lowStockProducts.map(
              (product) => _LowStockProduct(
                product: product,
              ),
            ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// LOW STOCK PRODUCT
// -----------------------------------------------------------------------------

class _LowStockProduct extends StatelessWidget {
  final LowStockProduct product;

  const _LowStockProduct({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final currentStock = product.currentStock;
    final minimumStock = product.minimumStock;

    final percentage = minimumStock > 0
        ? (currentStock / minimumStock).clamp(0.0, 1.0)
        : 0.0;

    final dangerLevel = 1.0 - percentage;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const _EmptyProductImage(),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '$currentStock left',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          _StockIndicator(
            currentStock: currentStock,
            dangerLevel: dangerLevel,
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// EMPTY PRODUCT IMAGE
// -----------------------------------------------------------------------------

class _EmptyProductImage extends StatelessWidget {
  const _EmptyProductImage();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        width: 50,
        height: 50,
        color: colors.surfaceContainerHighest.withOpacity(0.45),
        child: Icon(
          Icons.image_outlined,
          size: 23,
          color: colors.onSurfaceVariant.withOpacity(0.5),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// STOCK INDICATOR
// -----------------------------------------------------------------------------

class _StockIndicator extends StatelessWidget {
  final int currentStock;
  final double dangerLevel;

  const _StockIndicator({
    required this.currentStock,
    required this.dangerLevel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final indicatorHeight = 24 + (dangerLevel * 28);

    return SizedBox(
      width: 42,
      height: 58,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: 5,
            height: 48,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 5,
            height: indicatorHeight,
            decoration: BoxDecoration(
              color: colors.error,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          Positioned(
            right: 0,
            top: 0,
            child: Text(
              currentStock.toString(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: colors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// EMPTY STATE
// -----------------------------------------------------------------------------

class _NoLowStockProducts extends StatelessWidget {
  const _NoLowStockProducts();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 32,
              color: colors.primary,
            ),

            const SizedBox(height: 8),

            Text(
              'All stock levels look good',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              'No products need attention right now.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}