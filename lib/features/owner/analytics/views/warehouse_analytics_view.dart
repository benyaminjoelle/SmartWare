import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/owner/analytics/controllers/owner_analytic_controller.dart';
import 'package:smartware/features/owner/analytics/models/warehouse_model.dart';
import 'package:smartware/features/owner/analytics/widgets/analytics_chart_card.dart';
import 'package:smartware/features/owner/analytics/widgets/analytics_charts.dart';
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
            onRefresh: controller.refreshAnalytics,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
              children: [
                // ----------------------------------------------------------------
                // HEADER
                // ----------------------------------------------------------------

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
                      child: Text(
                        warehouse.nameEn,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Material(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: controller.refreshAnalytics,
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

                const SizedBox(height: 20),

                // ----------------------------------------------------------------
                // SUMMARY
                // ----------------------------------------------------------------

                AnalyticsSummaryGrid(
                  controller: controller,
                ),

                const SizedBox(height: 20),

                // ----------------------------------------------------------------
                // INVENTORY TREND
                // ----------------------------------------------------------------

                AnalyticsSectionTitle(
                  title: 'Inventory trend',
                  subtitle: 'Stock level over the last 7 days',
                ),

                const SizedBox(height: 12),

                AnalyticsChartCard(
                  child: InventoryTrendChart(
                    controller: controller,
                  ),
                ),

                const SizedBox(height: 20),

                // ----------------------------------------------------------------
                // STOCK MOVEMENT
                // ----------------------------------------------------------------

                AnalyticsSectionTitle(
                  title: 'Stock movement',
                  subtitle: 'Incoming vs outgoing inventory',
                ),

                const SizedBox(height: 12),

                AnalyticsChartCard(
                  child: StockMovementChart(
                    controller: controller,
                  ),
                ),

                const SizedBox(height: 20),

                // ----------------------------------------------------------------
                // INVENTORY BY CATEGORY
                // ----------------------------------------------------------------

                AnalyticsSectionTitle(
                  title: 'Inventory by category',
                  subtitle: 'Current stock distribution',
                ),

                const SizedBox(height: 12),

                AnalyticsChartCard(
                  child: CategoryChart(
                    controller: controller,
                  ),
                ),

                const SizedBox(height: 20),

                // ----------------------------------------------------------------
                // TOP MOVING PRODUCTS
                // ----------------------------------------------------------------

                AnalyticsSectionTitle(
                  title: 'Top moving products',
                  subtitle:
                      'Products with the highest outgoing quantity',
                ),

                const SizedBox(height: 12),

                AnalyticsChartCard(
                  child: TopProductsChart(
                    controller: controller,
                  ),
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