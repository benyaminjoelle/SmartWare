import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/owner/analytics/controllers/owner_analytic_controller.dart';

import 'package:smartware/features/owner/analytics/models/warehouse_repo.dart';

class LowStockCard extends StatelessWidget {
  final OwnerAnalyticsController controller;

  const LowStockCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
    

      body: SafeArea(
        child: Obx(() {
          final products = controller.stockOutRiskProducts;

          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // ============================================================
              // HEADER
              // ============================================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                  child: Row(
                    children: [
                      Material(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          onTap: () => Get.back(),
                          borderRadius: BorderRadius.circular(14),
                          child: SizedBox(
                            width: 44,
                            height: 44,
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 18,
                              color: colors.onSurface,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Low stock',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: colors.onSurface,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.3,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              'Products that need attention',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: colors.error.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${products.length}',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colors.error,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ============================================================
              // DESCRIPTION / WARNING
              // ============================================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.error.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(color: colors.error.withOpacity(0.14)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: colors.error.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.warning_amber_rounded,
                            color: colors.error,
                            size: 22,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Stock needs attention',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colors.onSurface,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                'These products currently have 10 units or less in this warehouse.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colors.onSurfaceVariant,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ============================================================
              // PRODUCTS
              // ============================================================
              if (products.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _NoLowStockProducts(),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final product = products[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _LowStockProduct(product: product),
                      );
                    }, childCount: products.length),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

// ============================================================================
// LOW STOCK PRODUCT
// ============================================================================

class _LowStockProduct extends StatelessWidget {
  final StockOutRiskProduct product;

  const _LowStockProduct({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final currentStock = product.warehouseQuantity;

    const minimumStock = 10;

    final percentage = (currentStock / minimumStock).clamp(0.0, 1.0);

    final dangerLevel = 1.0 - percentage;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ------------------------------------------------------------
          // PRODUCT ICON
          // ------------------------------------------------------------
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colors.error.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 24,
              color: colors.error,
            ),
          ),

          const SizedBox(width: 13),

          // ------------------------------------------------------------
          // PRODUCT INFO
          // ------------------------------------------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.displayName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '${product.warehouseQuantity} ${product.unit} left',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                if (product.sku.isNotEmpty) ...[
                  const SizedBox(height: 3),

                  Text(
                    'SKU: ${product.sku}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 14),

          // ------------------------------------------------------------
          // STOCK INDICATOR
          // ------------------------------------------------------------
          _StockIndicator(currentStock: currentStock, dangerLevel: dangerLevel),
        ],
      ),
    );
  }
}

// ============================================================================
// STOCK INDICATOR
// ============================================================================

class _StockIndicator extends StatelessWidget {
  final int currentStock;
  final double dangerLevel;

  const _StockIndicator({
    required this.currentStock,
    required this.dangerLevel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final indicatorHeight = 20 + (dangerLevel * 28);

    return SizedBox(
      width: 42,
      height: 58,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Background bar
          Container(
            width: 5,
            height: 48,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Error level
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
              '$currentStock',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colors.error,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EMPTY STATE
// ============================================================================

class _NoLowStockProducts extends StatelessWidget {
  const _NoLowStockProducts();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                size: 34,
                color: colors.primary,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              'All stock levels look good',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'No products need attention right now.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
