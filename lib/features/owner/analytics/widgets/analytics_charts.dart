import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:smartware/features/owner/analytics/controllers/owner_analytic_controller.dart';

class InventoryTrendChart extends StatelessWidget {
  final OwnerAnalyticsController controller;

  const InventoryTrendChart({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final products = controller.slowMovingProducts;

    if (products.isEmpty) {
      return const _ChartEmptyState(
        icon: Icons.show_chart_rounded,
        title: 'No inventory trend data',
        subtitle: 'There is not enough inventory data to display a trend.',
      );
    }

    /*
     * We currently do not have a real daily inventory-history endpoint.
     *
     * Therefore, instead of displaying a completely empty chart,
     * we display the number of slow-moving products as a visual
     * warehouse inventory indicator.
     */
    final data = <_ChartPoint>[
      _ChartPoint('Products', products.length),
    ];

    return SfCartesianChart(
      margin: const EdgeInsets.all(8),

      plotAreaBorderWidth: 0,

      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        axisLine: AxisLine(width: 0),
      ),

      primaryYAxis: const NumericAxis(
        minimum: 0,
        majorGridLines: MajorGridLines(
          width: 0.5,
        ),
        axisLine: AxisLine(width: 0),
      ),

      tooltipBehavior: TooltipBehavior(
        enable: true,
      ),

      series: <CartesianSeries<_ChartPoint, String>>[
        ColumnSeries<_ChartPoint, String>(
          dataSource: data,
          xValueMapper: (item, _) => item.label,
          yValueMapper: (item, _) => item.value,
          name: 'Products',
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(8),
          ),
          width: 0.45,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// STOCK MOVEMENT CHART
// ============================================================================

class StockMovementChart extends StatelessWidget {
  final OwnerAnalyticsController controller;

  const StockMovementChart({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final products = controller.slowMovingProducts;

    if (products.isEmpty) {
      return const _ChartEmptyState(
        icon: Icons.swap_vert_rounded,
        title: 'No stock movement data',
        subtitle: 'There is no stock movement data to display.',
      );
    }

    /*
     * The current backend response gives us total_sold.
     *
     * Incoming stock is NOT supplied by the endpoint, so we do not
     * invent an incoming number.
     *
     * We display outgoing movement for each product.
     */

    final data = products
        .take(8)
        .map(
          (product) => _MovementPoint(
            product.nameEn?.isNotEmpty == true
                ? product.nameEn!
                : 'Product ${product.id}',
            product.totalSold ?? 0,
          ),
        )
        .toList();

    return SfCartesianChart(
      margin: const EdgeInsets.all(8),

      plotAreaBorderWidth: 0,

      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        axisLine: AxisLine(width: 0),
        labelRotation: -35,
      ),

      primaryYAxis: const NumericAxis(
        minimum: 0,
        majorGridLines: MajorGridLines(
          width: 0.5,
        ),
        axisLine: AxisLine(width: 0),
      ),

      tooltipBehavior: TooltipBehavior(
        enable: true,
      ),

      legend: const Legend(
        isVisible: true,
        position: LegendPosition.bottom,
      ),

      series: <CartesianSeries<_MovementPoint, String>>[
        ColumnSeries<_MovementPoint, String>(
          dataSource: data,
          xValueMapper: (item, _) => item.name,
          yValueMapper: (item, _) => item.outgoing,
          name: 'Outgoing',
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(6),
          ),
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// CATEGORY CHART
// ============================================================================

class CategoryChart extends StatelessWidget {
  final OwnerAnalyticsController controller;

  const CategoryChart({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final products = controller.slowMovingProducts;

    if (products.isEmpty) {
      return const _ChartEmptyState(
        icon: Icons.pie_chart_outline_rounded,
        title: 'No category data',
        subtitle: 'There is no category information to display.',
      );
    }

    /*
     * The current slow-moving-products endpoint does not return
     * product categories.
     *
     * Therefore we group the available products by unit.
     *
     * Example:
     *   كغ      -> 5
     *   قطعة    -> 7
     */

    final Map<String, int> grouped = {};

    for (final product in products) {
      final unit = product.unit?.isNotEmpty == true
          ? product.unit!
          : 'Unknown';

      grouped[unit] = (grouped[unit] ?? 0) + 1;
    }

    final data = grouped.entries
        .map(
          (entry) => _CategoryPoint(
            entry.key,
            entry.value,
          ),
        )
        .toList();

    return SfCircularChart(
      margin: const EdgeInsets.all(8),

      legend: const Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        overflowMode: LegendItemOverflowMode.wrap,
      ),

      tooltipBehavior: TooltipBehavior(
        enable: true,
      ),

      series: <CircularSeries<_CategoryPoint, String>>[
        DoughnutSeries<_CategoryPoint, String>(
          dataSource: data,
          xValueMapper: (item, _) => item.category,
          yValueMapper: (item, _) => item.quantity,

          dataLabelMapper: (item, _) =>
              '${item.category}\n${item.quantity}',

          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
          ),

          innerRadius: '62%',

          radius: '85%',
        ),
      ],
    );
  }
}

// ============================================================================
// TOP PRODUCTS CHART
// ============================================================================

class TopProductsChart extends StatelessWidget {
  final OwnerAnalyticsController controller;

  const TopProductsChart({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final products = controller.slowMovingProducts;

    if (products.isEmpty) {
      return const _ChartEmptyState(
        icon: Icons.bar_chart_rounded,
        title: 'No product movement data',
        subtitle: 'There is no product movement data to display.',
      );
    }

    /*
     * Sort products by total_sold.
     *
     * The current endpoint returns total_sold.
     * Products with null total_sold are treated as 0.
     */

    final sorted = [...products];

    sorted.sort(
      (a, b) => (b.totalSold ?? 0).compareTo(
        a.totalSold ?? 0,
      ),
    );

    final topProducts = sorted.take(6).toList();

    final data = topProducts.map(
      (product) {
        final name = product.nameEn?.isNotEmpty == true
            ? product.nameEn!
            : 'Product ${product.id}';

        return _TopProductPoint(
          name,
          product.totalSold ?? 0,
        );
      },
    ).toList();

    return SfCartesianChart(
      margin: const EdgeInsets.all(8),

      plotAreaBorderWidth: 0,

      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        axisLine: AxisLine(width: 0),
        labelRotation: -35,
      ),

      primaryYAxis: const NumericAxis(
        minimum: 0,
        majorGridLines: MajorGridLines(
          width: 0.5,
        ),
        axisLine: AxisLine(width: 0),
      ),

      tooltipBehavior: TooltipBehavior(
        enable: true,
      ),

      series: <CartesianSeries<_TopProductPoint, String>>[
        BarSeries<_TopProductPoint, String>(
          dataSource: data,
          xValueMapper: (item, _) => item.name,
          yValueMapper: (item, _) => item.quantity,
          name: 'Sold',
          borderRadius: const BorderRadius.horizontal(
            right: Radius.circular(6),
          ),
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ),
        ),
      ],
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

  const _ChartEmptyState({
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
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 42,
              color: colors.primary.withOpacity(0.55),
            ),

            const SizedBox(height: 12),

            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
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
// INTERNAL CHART MODELS
// ============================================================================

class _ChartPoint {
  final String label;
  final int value;

  _ChartPoint(
    this.label,
    this.value,
  );
}

class _MovementPoint {
  final String name;
  final int outgoing;

  _MovementPoint(
    this.name,
    this.outgoing,
  );
}

class _CategoryPoint {
  final String category;
  final int quantity;

  _CategoryPoint(
    this.category,
    this.quantity,
  );
}

class _TopProductPoint {
  final String name;
  final int quantity;

  _TopProductPoint(
    this.name,
    this.quantity,
  );
}