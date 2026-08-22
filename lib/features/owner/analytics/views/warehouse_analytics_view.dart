import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/owner/analytics/controllers/owner_analytic_controller.dart';
import 'package:smartware/features/owner/analytics/models/top_moving_products.dart';
import 'package:smartware/features/owner/analytics/models/warehouse_model.dart';
import 'package:smartware/features/owner/analytics/models/warehouse_repo.dart';
import 'package:smartware/features/owner/analytics/widgets/analytics_chart_card.dart';
import 'package:smartware/features/owner/analytics/widgets/analytics_section_title.dart';
import 'package:smartware/features/owner/analytics/widgets/analytics_stat_card.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WarehouseAnalyticsView extends StatelessWidget {
  final WarehouseModel warehouse;
  final OwnerAnalyticsController controller;

  const WarehouseAnalyticsView({
    super.key,
    required this.warehouse,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoadingAnalytics.value) {
            return Center(
              child: CircularProgressIndicator(
                color: colors.primary,
              ),
            );
          }

          final topMovingProducts = controller.topMovingProducts;
          final slowMovingProducts = controller.slowMovingProducts;
          final stockOutRiskProducts = controller.stockOutRiskProducts;

          return RefreshIndicator(
            color: colors.primary,
            backgroundColor: colors.surface,
            onRefresh: () {
              return controller.loadWarehouseAnalytics(warehouse.id);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                20,
                14,
                20,
                40,
              ),
              children: [
                _buildHeader(
                  context,
                  theme,
                  colors,
                ),

                const SizedBox(height: 28),

                const AnalyticsSectionTitle(
                  title: 'Overview',
                  subtitle: 'Current warehouse performance',
                ),

                const SizedBox(height: 12),

                AnalyticsSummaryGrid(
                  controller: controller,
                ),

                const SizedBox(height: 30),

                // ============================================================
                // TOP MOVING PRODUCTS
                // ============================================================

                const AnalyticsSectionTitle(
                  title: 'Top moving products',
                  subtitle:
                      'Products with the highest outgoing movement',
                ),

                const SizedBox(height: 12),

                Column(
                  children: [
                    AnalyticsChartCard(
                      height: 350,
                      padding: const EdgeInsets.fromLTRB(
                        8,
                        18,
                        12,
                        8,
                      ),
                      child: _TopMovingProductsChart(
                        products: topMovingProducts,
                      ),
                    ),

                    const SizedBox(height: 10),

                    _ViewProductsButton(
                      title: 'View top moving products',
                      count: topMovingProducts.length,
                      icon: Icons.trending_up_rounded,
                      color: colors.primary,
                      onTap: () {
                        _showTopMovingProducts(
                          context,
                          topMovingProducts,
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // ============================================================
                // SLOW MOVING PRODUCTS
                // ============================================================

                const AnalyticsSectionTitle(
                  title: 'Slow moving products',
                  subtitle:
                      'Products with little or no outgoing movement',
                ),

                const SizedBox(height: 12),

                Column(
                  children: [
                    AnalyticsChartCard(
                      height: 350,
                      padding: const EdgeInsets.fromLTRB(
                        8,
                        18,
                        12,
                        8,
                      ),
                      child: _SlowMovingChart(
                        products: slowMovingProducts,
                      ),
                    ),

                    const SizedBox(height: 10),

                    _ViewProductsButton(
                      title: 'View slow moving products',
                      count: slowMovingProducts.length,
                      icon: Icons.trending_down_rounded,
                      color: colors.primary,
                      onTap: () {
                        _showSlowMovingProducts(
                          context,
                          slowMovingProducts,
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // ============================================================
                // OUT OF STOCK RISK
                // ============================================================

                _OutOfStockRiskHeader(
                  count: stockOutRiskProducts.length,
                ),

                const SizedBox(height: 12),

                Column(
                  children: [
                    AnalyticsChartCard(
                      height: 350,
                      padding: const EdgeInsets.fromLTRB(
                        8,
                        18,
                        12,
                        8,
                      ),
                      child: _StockOutRiskChart(
                        products: stockOutRiskProducts,
                      ),
                    ),

                    const SizedBox(height: 10),

                    _ViewProductsButton(
                      title: 'View out of stock risk products',
                      count: stockOutRiskProducts.length,
                      icon: Icons.warning_amber_rounded,
                      color: colors.error,
                      onTap: () {
                        _showStockRiskProducts(
                          context,
                          stockOutRiskProducts,
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ==========================================================================
  // HEADER
  // ==========================================================================

  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
    ColorScheme colors,
  ) {
    return Row(
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
                warehouse.nameEn,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'Warehouse analytics',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        Material(
          color: colors.surface,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: () {
              controller.loadWarehouseAnalytics(
                warehouse.id,
              );
            },
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 44,
              height: 44,
              child: Icon(
                Icons.refresh_rounded,
                color: colors.onSurface,
                size: 21,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// OUT OF STOCK RISK HEADER
// ============================================================================

class _OutOfStockRiskHeader extends StatelessWidget {
  final int count;

  const _OutOfStockRiskHeader({
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final hasRisk = count > 0;

    return Row(
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Out of stock risk',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),

                  if (hasRisk)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: colors.error.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$count',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colors.error,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 4),

              Text(
                hasRisk
                    ? 'Products with 10 units or less'
                    : 'No products are currently at risk',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// TOP MOVING PRODUCTS CHART
// ============================================================================

class _TopMovingProductsChart extends StatelessWidget {
  final List<TopMovingProductModel> products;

  const _TopMovingProductsChart({
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    /*
     * IMPORTANT:
     *
     * We DO NOT return _ChartEmptyState when products is empty.
     *
     * The chart itself must still be rendered.
     *
     * When the API returns [],
     * we create a few zero-value placeholder points.
     */
    final bool hasData = products.isNotEmpty;

    final chartProducts = hasData
        ? products.take(10).toList()
        : <TopMovingProductModel>[];

    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(
        8,
        15,
        12,
        10,
      ),

      title: ChartTitle(
        text: hasData
            ? ''
            : 'No outgoing movement data',
        textStyle: theme.textTheme.bodySmall?.copyWith(
          color: colors.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),

      tooltipBehavior: TooltipBehavior(
        enable: hasData,
        header: 'Top moving product',
        color: colors.surface,
        textStyle: theme.textTheme.bodySmall?.copyWith(
          color: colors.onSurface,
        ),
      ),

      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(
          width: 0,
        ),
        labelStyle: theme.textTheme.bodySmall?.copyWith(
          color: colors.onSurfaceVariant,
        ),
        labelRotation: -45,
        axisLine: AxisLine(
          color: colors.outlineVariant,
        ),
      ),

      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: hasData ? null : 5,
        interval: hasData ? null : 1,
        majorGridLines: MajorGridLines(
          width: 0.5,
          color: colors.outlineVariant.withOpacity(0.45),
        ),
        labelStyle: theme.textTheme.bodySmall?.copyWith(
          color: colors.onSurfaceVariant,
        ),
        title: AxisTitle(
          text: 'Units sold',
          textStyle: theme.textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
        axisLine: AxisLine(
          color: colors.outlineVariant,
        ),
      ),

      series: <CartesianSeries>[
        if (hasData)
          ColumnSeries<TopMovingProductModel, String>(
            dataSource: chartProducts,

            xValueMapper: (product, _) {
              final sku = product.sku;

              return sku.length > 8
                  ? sku.substring(0, 8)
                  : sku;
            },

            yValueMapper: (product, _) {
              return product.totalSold.toDouble();
            },

            name: 'Sold',

            color: colors.primary,

            width: 0.65,

            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),

            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelAlignment:
                  ChartDataLabelAlignment.top,
              textStyle:
                  theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        else
          ColumnSeries<_EmptyChartPoint, String>(
            dataSource: const [
              _EmptyChartPoint('No data', 0),
            ],

            xValueMapper: (point, _) {
              return point.label;
            },

            yValueMapper: (point, _) {
              return point.value;
            },

            name: 'Sold',

            color: colors.primary.withOpacity(0.18),

            width: 0.65,

            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),

            dataLabelSettings: const DataLabelSettings(
              isVisible: false,
            ),
          ),
      ],
    );
  }
}

// ============================================================================
// SLOW MOVING CHART
// ============================================================================

class _SlowMovingChart extends StatelessWidget {
  final List products;

  const _SlowMovingChart({
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final bool hasData = products.isNotEmpty;

    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(
        5,
        5,
        5,
        5,
      ),

      title: ChartTitle(
        text: hasData
            ? ''
            : 'No slow movement data',
        textStyle: theme.textTheme.bodySmall?.copyWith(
          color: colors.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),

      tooltipBehavior: TooltipBehavior(
        enable: hasData,
        color: colors.surface,
        textStyle: theme.textTheme.bodySmall?.copyWith(
          color: colors.onSurface,
        ),
      ),

      primaryXAxis: CategoryAxis(
        labelRotation: -45,
        majorGridLines: const MajorGridLines(
          width: 0,
        ),
        labelStyle: theme.textTheme.bodySmall?.copyWith(
          color: colors.onSurfaceVariant,
        ),
        axisLine: AxisLine(
          color: colors.outlineVariant,
        ),
      ),

      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: hasData ? null : 5,
        interval: hasData ? null : 1,
        majorGridLines: MajorGridLines(
          width: 0.5,
          color: colors.outlineVariant.withOpacity(0.45),
        ),
        labelStyle: theme.textTheme.bodySmall?.copyWith(
          color: colors.onSurfaceVariant,
        ),
        axisLine: AxisLine(
          color: colors.outlineVariant,
        ),
      ),

      series: <CartesianSeries>[
        if (hasData)
          LineSeries<dynamic, String>(
            dataSource: products,

            xValueMapper: (product, _) {
              final sku =
                  product.sku?.toString() ?? '';

              return sku.length > 7
                  ? sku.substring(0, 7)
                  : sku;
            },

            yValueMapper: (product, _) {
              final value = product.totalSold;

              if (value == null) {
                return 0;
              }

              if (value is num) {
                return value.toDouble();
              }

              return double.tryParse(
                    value.toString(),
                  ) ??
                  0;
            },

            name: 'Units sold',

            color: colors.primary,

            width: 3,

            markerSettings: MarkerSettings(
              isVisible: true,
              height: 9,
              width: 9,
              color: colors.primary,
              borderColor: colors.surface,
              borderWidth: 2,
            ),

            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelAlignment:
                  ChartDataLabelAlignment.top,
              textStyle:
                  theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        else
          LineSeries<_EmptyChartPoint, String>(
            dataSource: const [
              _EmptyChartPoint('No data', 0),
              _EmptyChartPoint('', 0),
            ],

            xValueMapper: (point, _) {
              return point.label;
            },

            yValueMapper: (point, _) {
              return point.value;
            },

            name: 'Units sold',

            color: colors.primary.withOpacity(0.25),

            width: 3,

            markerSettings: MarkerSettings(
              isVisible: true,
              height: 9,
              width: 9,
              color: colors.primary.withOpacity(0.25),
              borderColor: colors.surface,
              borderWidth: 2,
            ),

            dataLabelSettings:
                const DataLabelSettings(
              isVisible: false,
            ),
          ),
      ],
    );
  }
}

// ============================================================================
// OUT OF STOCK RISK CHART
// ============================================================================

class _StockOutRiskChart extends StatelessWidget {
  final List<StockOutRiskProduct> products;

  const _StockOutRiskChart({
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final bool hasData = products.isNotEmpty;

    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(
        5,
        5,
        5,
        5,
      ),

      title: ChartTitle(
        text: hasData
            ? ''
            : 'No products at risk',
        textStyle: theme.textTheme.bodySmall?.copyWith(
          color: colors.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),

      tooltipBehavior: TooltipBehavior(
        enable: hasData,
        color: colors.surface,
        textStyle: theme.textTheme.bodySmall?.copyWith(
          color: colors.onSurface,
        ),
      ),

      primaryXAxis: CategoryAxis(
        labelRotation: -45,
        majorGridLines: const MajorGridLines(
          width: 0,
        ),
        labelStyle: theme.textTheme.bodySmall?.copyWith(
          color: colors.onSurfaceVariant,
        ),
        axisLine: AxisLine(
          color: colors.outlineVariant,
        ),
      ),

      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: 10,
        interval: 2,
        majorGridLines: MajorGridLines(
          width: 0.5,
          color: colors.primary.withOpacity(0.18),
        ),
        labelStyle: theme.textTheme.bodySmall?.copyWith(
          color: colors.onSurfaceVariant,
        ),
        axisLine: AxisLine(
          color: colors.outlineVariant,
        ),
      ),

      series: <CartesianSeries>[
        if (hasData)
          ColumnSeries<StockOutRiskProduct, String>(
            dataSource: products,

            xValueMapper: (product, _) {
              final sku = product.sku;

              return sku.length > 7
                  ? sku.substring(0, 7)
                  : sku;
            },

            yValueMapper: (product, _) {
              return product.warehouseQuantity
                  .toDouble();
            },

            name: 'Stock',

            color: colors.primary,

            width: 0.65,

            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(6),
            ),

            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              textStyle:
                  theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
          )
        else
          ColumnSeries<_EmptyChartPoint, String>(
            dataSource: const [
              _EmptyChartPoint('No risk', 0),
            ],

            xValueMapper: (point, _) {
              return point.label;
            },

            yValueMapper: (point, _) {
              return point.value;
            },

            name: 'Stock',

            color: colors.primary.withOpacity(0.18),

            width: 0.65,

            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(6),
            ),

            dataLabelSettings:
                const DataLabelSettings(
              isVisible: false,
            ),
          ),
      ],
    );
  }
}

// ============================================================================
// EMPTY CHART POINT
// ============================================================================

class _EmptyChartPoint {
  final String label;
  final double value;

  const _EmptyChartPoint(
    this.label,
    this.value,
  );
}

// ============================================================================
// VIEW PRODUCTS BUTTON
// ============================================================================

class _ViewProductsButton extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ViewProductsButton({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: color,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              const SizedBox(width: 8),

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

// ============================================================================
// GENERIC PRODUCTS SHEET
// ============================================================================

void _showProductsSheet(
  BuildContext context, {
  required String title,
  required String subtitle,
  required List<_ProductSheetItem> products,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      final theme = Theme.of(context);
      final colors = theme.colorScheme;

      return Container(
        height: MediaQuery.of(context).size.height * 0.78,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),

            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: colors.onSurfaceVariant
                    .withOpacity(0.25),
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                14,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme
                              .textTheme.titleLarge
                              ?.copyWith(
                            color: colors.onSurface,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          subtitle,
                          style: theme
                              .textTheme.bodySmall
                              ?.copyWith(
                            color:
                                colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary
                          .withOpacity(0.10),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${products.length}',
                      style: theme
                          .textTheme.labelLarge
                          ?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Divider(
              height: 1,
              color: colors.outlineVariant
                  .withOpacity(0.4),
            ),

            Expanded(
              child: products.isEmpty
                  ? _ChartEmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: 'No products',
                      subtitle:
                          'There are no products to display.',
                      color: colors.primary,
                    )
                  : ListView.separated(
                      padding:
                          const EdgeInsets.fromLTRB(
                        16,
                        12,
                        16,
                        30,
                      ),
                      itemCount: products.length,
                      separatorBuilder: (_, __) {
                        return const SizedBox(
                          height: 8,
                        );
                      },
                      itemBuilder: (_, index) {
                        return _ProductSheetTile(
                          product: products[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    },
  );
}

// ============================================================================
// PRODUCT SHEET MODEL
// ============================================================================

class _ProductSheetItem {
  final String name;
  final String sku;
  final dynamic value;
  final String valueLabel;
  final String unit;

  _ProductSheetItem({
    required this.name,
    required this.sku,
    required this.value,
    required this.valueLabel,
    required this.unit,
  });
}

// ============================================================================
// PRODUCT SHEET TILE
// ============================================================================

class _ProductSheetTile extends StatelessWidget {
  final _ProductSheetItem product;

  const _ProductSheetTile({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest
            .withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: colors.primary,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

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
                    color: colors.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'SKU: ${product.sku}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),

                if (product.unit.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    product.unit,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(
                      color:
                          colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                '${product.value}',
                style: theme.textTheme.titleMedium
                    ?.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w900,
                ),
              ),

              Text(
                product.valueLabel,
                style: theme.textTheme.bodySmall
                    ?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// CHART EMPTY STATE
// ============================================================================

class _ChartEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _ChartEmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
              color: color.withOpacity(0.75),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium
                ?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 5),

          Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 25,
            ),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall
                  ?.copyWith(
                color:
                    colors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TOP MOVING BOTTOM SHEET
// ============================================================================

void _showTopMovingProducts(
  BuildContext context,
  List<TopMovingProductModel> products,
) {
  _showProductsSheet(
    context,
    title: 'Top moving products',
    subtitle:
        'Products with the highest outgoing movement',
    products: products
        .map(
          (product) => _ProductSheetItem(
            name: product.nameEn,
            sku: product.sku,
            value: product.totalSold,
            valueLabel: 'sold',
            unit: product.unit,
          ),
        )
        .toList(),
  );
}

// ============================================================================
// SLOW MOVING BOTTOM SHEET
// ============================================================================

void _showSlowMovingProducts(
  BuildContext context,
  List products,
) {
  _showProductsSheet(
    context,
    title: 'Slow moving products',
    subtitle:
        'Products with little or no outgoing movement',
    products: products
        .map(
          (product) => _ProductSheetItem(
            name: product.nameEn?.toString() ??
                product.nameAr?.toString() ??
                'Unnamed product',
            sku: product.sku?.toString() ?? '',
            value: product.totalSold ?? 0,
            valueLabel: 'sold',
            unit: product.unit?.toString() ?? '',
          ),
        )
        .toList(),
  );
}

// ============================================================================
// STOCK RISK BOTTOM SHEET
// ============================================================================

void _showStockRiskProducts(
  BuildContext context,
  List<StockOutRiskProduct> products,
) {
  _showProductsSheet(
    context,
    title: 'Out of stock risk products',
    subtitle:
        'Products with 10 units or less',
    products: products
        .map(
          (product) => _ProductSheetItem(
            name: product.displayName,
            sku: product.sku,
            value: product.warehouseQuantity,
            valueLabel: 'in stock',
            unit: product.unit,
          ),
        )
        .toList(),
  );
}