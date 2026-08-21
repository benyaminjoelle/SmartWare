import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/owner/analytics/controllers/owner_analytic_controller.dart';
import 'package:smartware/features/owner/analytics/widgets/warehouse_analytics_card.dart';
import 'package:smartware/widgets/primary_button.dart';

class OwnerAnalyticsView extends StatelessWidget {
  OwnerAnalyticsView({super.key});

  final OwnerAnalyticsController controller =
      Get.put(OwnerAnalyticsController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SafeArea(
      child: Obx(() {
        if (controller.isLoadingWarehouses.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.warehouses.isEmpty) {
          return const _EmptyWarehousesState();
        }

        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: controller.loadWarehouses,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;

                  final contentWidth =
                      width > 1100 ? 1000.0 : width;

                  return ListView(
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: width < 600 ? 16 : 24,
                      right: width < 600 ? 16 : 24,
                      top: 20,
                      bottom: 100,
                    ),
                    children: [
                      Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: contentWidth,
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Warehouses',
                                style: theme
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight:
                                          FontWeight.w800,
                                    ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                'Select a warehouse to view its performance.',
                                style: theme
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: colors
                                          .onSurfaceVariant,
                                    ),
                              ),

                              const SizedBox(height: 24),

                              _WarehouseGrid(
                                controller: controller,
                                width: width,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Floating Add New Facility Button
            Positioned(
              right: 24,
              bottom: 20,
              child: SizedBox(
                width: 190,
                child: PrimaryButton(
                  text: 'Add New Facility',
                  onPressed: () {
                    // TODO:
                    // Navigate to Add Facility screen
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// ============================================================
// WAREHOUSE GRID
// ============================================================

class _WarehouseGrid extends StatelessWidget {
  final OwnerAnalyticsController controller;
  final double width;

  const _WarehouseGrid({
    required this.controller,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = width >= 1100
        ? 3
        : width >= 700
            ? 2
            : 1;

    return GridView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio:
            width < 700 ? 1.55 : 1.15,
      ),
      itemCount: controller.warehouses.length,
      itemBuilder: (context, index) {
        final warehouse =
            controller.warehouses[index];

        return WarehouseAnalyticsCard(
          warehouse: warehouse,
          onTap: () {
            controller.selectWarehouse(warehouse);
          },
        );
      },
    );
  }
}

// ============================================================
// EMPTY STATE
// ============================================================

class _EmptyWarehousesState
    extends StatelessWidget {
  const _EmptyWarehousesState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warehouse_outlined,
              size: 64,
              color: colors.onSurfaceVariant,
            ),

            const SizedBox(height: 16),

            Text(
              'No warehouses yet',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Create a warehouse to start viewing analytics.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: 200,
              child: PrimaryButton(
                text: 'Add New Facility',
                onPressed: () {
                  // TODO:
                  // Navigate to Add Facility screen
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}