import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:smartware/features/owner/analytics/controllers/owner_analytic_controller.dart';
import 'package:smartware/features/owner/analytics/models/warehouse_model.dart';
import 'package:smartware/features/owner/analytics/widgets/analytics_chart_card.dart';
import 'package:smartware/features/owner/analytics/widgets/analytics_section_title.dart';
import 'package:smartware/features/owner/analytics/widgets/analytics_stat_card.dart';

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
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoadingAnalytics.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: () {
              return controller.loadWarehouseAnalytics(
                warehouse.id,
              );
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                30,
              ),
              children: [
                // ============================================================
                // HEADER
                // ============================================================

                Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 19,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            warehouse.nameEn,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style:
                                theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            'Warehouse analytics',
                            style:
                                theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    Material(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () {
                          controller.loadWarehouseAnalytics(
                            warehouse.id,
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: const SizedBox(
                          width: 42,
                          height: 42,
                          child: Icon(
                            Icons.refresh_rounded,
                            size: 21,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // ============================================================
                // OVERVIEW
                // ============================================================

                AnalyticsSectionTitle(
                  title: 'Overview',
                  subtitle: 'Current warehouse status',
                ),

                const SizedBox(height: 12),

                AnalyticsSummaryGrid(
                  controller: controller,
                ),

                const SizedBox(height: 28),

                // ============================================================
                // SLOW MOVING PRODUCTS
                // ============================================================

                AnalyticsSectionTitle(
                  title: 'Slow moving products',
                  subtitle:
                      'Products with little or no outgoing movement',
                ),

                const SizedBox(height: 12),

                Obx(() {
                  final products =
                      controller.slowMovingProducts;

                  if (products.isEmpty) {
                    return const AnalyticsChartCard(
                      height: 280,
                      child: _EmptyAnalyticsState(
                        icon: Icons.inventory_2_outlined,
                        title: 'No slow moving products',
                        subtitle:
                            'There are no slow moving products in this warehouse.',
                      ),
                    );
                  }

                  return AnalyticsChartCard(
                    height: 380,
                    padding: const EdgeInsets.fromLTRB(
                      8,
                      16,
                      12,
                      8,
                    ),
                    child: _SlowMovingProductsChart(
                      products: products,
                    ),
                  );
                }),

                const SizedBox(height: 24),

                // ============================================================
                // PRODUCT DETAILS BUTTON
                // ============================================================

                Obx(() {
                  final products =
                      controller.slowMovingProducts;

                  if (products.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return _ProductDetailsExpansion(
                    products: products,
                  );
                }),

                const SizedBox(height: 28),

                // ============================================================
                // WAREHOUSE INFORMATION
                // ============================================================

                AnalyticsSectionTitle(
                  title: 'Warehouse information',
                  subtitle:
                      'Basic details about this facility',
                ),

                const SizedBox(height: 12),

                _WarehouseInformationCard(
                  warehouse: warehouse,
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ============================================================================
// SLOW MOVING PRODUCTS CHART
// ============================================================================

class _SlowMovingProductsChart extends StatelessWidget {
  final List products;

  const _SlowMovingProductsChart({
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    /*
     * IMPORTANT:
     *
     * The backend currently returns:
     *
     * total_sold: null
     *
     * for these products.
     *
     * That means every value becomes 0.
     *
     * A normal ColumnSeries cannot visually display
     * a column whose height is zero.
     *
     * So we use a tiny visual value for zero-sold
     * products while keeping the tooltip showing
     * the REAL value as 0.
     */

    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(
        10,
        10,
        10,
        5,
      ),

      plotAreaBorderWidth: 0,

      tooltipBehavior: TooltipBehavior(
        enable: true,
        header: 'Product',
        format: 'point.x : point.y sold',
      ),

      primaryXAxis: CategoryAxis(
        labelRotation: -45,
        majorGridLines: const MajorGridLines(
          width: 0,
        ),
        axisLine: AxisLine(
          color: colors.outlineVariant,
        ),
        labelStyle:
            theme.textTheme.bodySmall?.copyWith(
          fontSize: 10,
        ),
      ),

      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: 1,
        interval: 1,
        majorGridLines: MajorGridLines(
          width: 0.5,
          color: colors.outlineVariant.withOpacity(0.4),
        ),
        axisLine: AxisLine(
          color: colors.outlineVariant,
        ),
        labelStyle:
            theme.textTheme.bodySmall?.copyWith(
          fontSize: 10,
        ),
        title: AxisTitle(
          text: 'Products sold',
        ),
      ),

      series: <CartesianSeries>[
        ColumnSeries<dynamic, String>(
          dataSource: products,

          xValueMapper: (product, _) {
            final sku =
                product.sku?.toString() ?? '';

            if (sku.length > 8) {
              return sku.substring(0, 8);
            }

            return sku;
          },

          yValueMapper: (product, _) {
            final value = product.totalSold;

            if (value == null) {
              // Small visual bar for zero.
              return 0.08;
            }

            if (value is num) {
              return value == 0
                  ? 0.08
                  : value.toDouble();
            }

            final parsed =
                double.tryParse(value.toString());

            if (parsed == null || parsed == 0) {
              return 0.08;
            }

            return parsed;
          },

          name: 'Sold',

          width: 0.65,

          spacing: 0.15,

          borderRadius:
              const BorderRadius.vertical(
            top: Radius.circular(6),
          ),

          dataLabelSettings:
              const DataLabelSettings(
            isVisible: true,
            labelAlignment:
                ChartDataLabelAlignment.top,
            textStyle: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// PRODUCT DETAILS EXPANSION
// ============================================================================

class _ProductDetailsExpansion extends StatelessWidget {
  final List products;

  const _ProductDetailsExpansion({
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Theme(
        data: theme.copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 4,
          ),
          childrenPadding: EdgeInsets.zero,

          leading: Icon(
            Icons.list_alt_rounded,
            color: colors.primary,
          ),

          title: Text(
            'View product details',
            style:
                theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),

          subtitle: Text(
            '${products.length} slow moving products',
            style:
                theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),

          children: [
            const Divider(height: 1),

            for (int i = 0; i < products.length; i++) ...[
              _SlowMovingProductTile(
                product: products[i],
              ),

              if (i != products.length - 1)
                Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: colors.outlineVariant
                      .withOpacity(0.35),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SLOW MOVING PRODUCT TILE
// ============================================================================

class _SlowMovingProductTile extends StatelessWidget {
  final dynamic product;

  const _SlowMovingProductTile({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final name =
        product.nameEn?.toString() ?? '';

    final arabicName =
        product.nameAr?.toString() ?? '';

    final sku =
        product.sku?.toString() ?? '';

    final unit =
        product.unit?.toString() ?? '';

    final totalSold =
        product.totalSold;

    final displayName = name.isNotEmpty
        ? name
        : arabicName.isNotEmpty
            ? arabicName
            : 'Unnamed product';

    final soldText =
        totalSold == null
            ? '0'
            : totalSold.toString();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      child: Row(
        children: [
          // ----------------------------------------------------------
          // IMAGE
          // ----------------------------------------------------------

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 52,
              height: 52,
              color: colors
                  .surfaceContainerHighest
                  .withOpacity(0.45),
              child: Icon(
                Icons.inventory_2_outlined,
                color: colors
                    .onSurfaceVariant
                    .withOpacity(0.55),
                size: 24,
              ),
            ),
          ),

          const SizedBox(width: 13),

          // ----------------------------------------------------------
          // INFO
          // ----------------------------------------------------------

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .titleSmall
                      ?.copyWith(
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'SKU: $sku',
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: theme
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                          color: colors
                              .onSurfaceVariant,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Container(
                      width: 4,
                      height: 4,
                      decoration:
                          BoxDecoration(
                        color: colors
                            .onSurfaceVariant,
                        shape:
                            BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      unit,
                      style: theme
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                        color: colors
                            .onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // ----------------------------------------------------------
          // SOLD
          // ----------------------------------------------------------

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                soldText,
                style: theme
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                'sold',
                style: theme
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                  color:
                      colors.onSurfaceVariant,
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
// EMPTY STATE
// ============================================================================

class _EmptyAnalyticsState
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyAnalyticsState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 45,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 42,
              color: colors
                  .onSurfaceVariant
                  .withOpacity(0.45),
            ),

            const SizedBox(height: 14),

            Text(
              title,
              textAlign: TextAlign.center,
              style: theme
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                fontWeight:
                    FontWeight.w800,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                color:
                    colors.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// WAREHOUSE INFORMATION CARD
// ============================================================================

class _WarehouseInformationCard
    extends StatelessWidget {
  final WarehouseModel warehouse;

  const _WarehouseInformationCard({
    required this.warehouse,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.035),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _InfoRow(
            icon:
                Icons.warehouse_outlined,
            label: 'Type',
            value: warehouse.type,
          ),

          const SizedBox(height: 16),

          _InfoRow(
            icon:
                Icons.business_outlined,
            label: 'Business type',
            value:
                warehouse.businessType,
          ),

          const SizedBox(height: 16),

          _InfoRow(
            icon:
                Icons.verified_outlined,
            label: 'Status',
            value:
                warehouse.status,
          ),

          const SizedBox(height: 16),

          _InfoRow(
            icon:
                Icons.location_on_outlined,
            label: 'Location',
            value: warehouse
                    .location.isNotEmpty
                ? warehouse.location
                : 'Location not available',
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// INFO ROW
// ============================================================================

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: colors.primary,
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                  color:
                      colors.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                maxLines: 2,
                overflow:
                    TextOverflow.ellipsis,
                style: theme
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}