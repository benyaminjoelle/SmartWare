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
    final data = controller.inventoryTrend;

    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(
          width: 0,
        ),
      ),

      primaryYAxis: const NumericAxis(
        majorGridLines: MajorGridLines(
          width: 0.5,
        ),
      ),

      tooltipBehavior: TooltipBehavior(
        enable: true,
      ),

      series: <CartesianSeries>[
        LineSeries<InventoryTrend, String>(
          dataSource: data,
          xValueMapper: (item, _) => item.day,
          yValueMapper: (item, _) => item.quantity,
          name: 'Inventory',
          width: 3,
          markerSettings: const MarkerSettings(
            isVisible: true,
          ),
        ),
      ],
    );
  }
}

class StockMovementChart extends StatelessWidget {
  final OwnerAnalyticsController controller;

  const StockMovementChart({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final data = controller.stockMovement;

    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(
          width: 0,
        ),
      ),

      primaryYAxis: const NumericAxis(
        majorGridLines: MajorGridLines(
          width: 0.5,
        ),
      ),

      tooltipBehavior: TooltipBehavior(
        enable: true,
      ),

      legend: const Legend(
        isVisible: true,
        position: LegendPosition.bottom,
      ),

      series: <CartesianSeries>[
        ColumnSeries<StockMovement, String>(
          dataSource: data,
          xValueMapper: (item, _) => item.day,
          yValueMapper: (item, _) => item.incoming,
          name: 'Incoming',
        ),

        ColumnSeries<StockMovement, String>(
          dataSource: data,
          xValueMapper: (item, _) => item.day,
          yValueMapper: (item, _) => item.outgoing,
          name: 'Outgoing',
        ),
      ],
    );
  }
}

class CategoryChart extends StatelessWidget {
  final OwnerAnalyticsController controller;

  const CategoryChart({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final data = controller.categoryInventory;

    return SfCircularChart(
      legend: const Legend(
        isVisible: true,
        position: LegendPosition.bottom,
      ),

      tooltipBehavior: TooltipBehavior(
        enable: true,
      ),

      series: <CircularSeries>[
        DoughnutSeries<CategoryInventory, String>(
          dataSource: data,
          xValueMapper: (item, _) => item.category,
          yValueMapper: (item, _) => item.quantity,
          dataLabelMapper: (item, _) =>
              '${item.category}\n${item.quantity}',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ),
          innerRadius: '65%',
        ),
      ],
    );
  }
}

class TopProductsChart extends StatelessWidget {
  final OwnerAnalyticsController controller;

  const TopProductsChart({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final data = controller.topProducts;

    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(
          width: 0,
        ),
      ),

      primaryYAxis: const NumericAxis(
        majorGridLines: MajorGridLines(
          width: 0.5,
        ),
      ),

      tooltipBehavior: TooltipBehavior(
        enable: true,
      ),

      series: <CartesianSeries>[
        BarSeries<TopProduct, String>(
          dataSource: data,
          xValueMapper: (item, _) => item.name,
          yValueMapper: (item, _) => item.quantity,
          name: 'Outgoing',
        ),
      ],
    );
  }
}