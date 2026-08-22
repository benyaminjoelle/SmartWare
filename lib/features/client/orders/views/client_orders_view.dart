```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/client/orders/controllers/client_orders_controller.dart';
import 'package:smartware/features/client/orders/widgets/client_order_details_sheet.dart';
import 'package:smartware/features/client/profile/widgets/glass_container.dart';

class ClientOrdersView extends StatelessWidget {
  ClientOrdersView({super.key});

  final OrdersController controller = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Orders'.tr,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),

            // ===============================================================
            // HEADER
            // ===============================================================

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  Text(
                    'View your order status and details'.tr,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 18),

                  _OrdersTabs(
                    controller: controller,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ===============================================================
            // ORDERS
            // ===============================================================

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final orders = controller.currentOrders;

                if (orders.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: controller.refreshOrders,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 20,
                      ),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: _OrdersEmptyState(
                            tab: controller.selectedTab.value,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshOrders,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      18,
                      2,
                      18,
                      24,
                    ),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: orders.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 14),
                    itemBuilder: (_, index) {
                      final order = orders[index];

                      return _ClientOrderCard(
                        order: order,
                        controller: controller,
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// TABS
// =============================================================================

class _OrdersTabs extends StatelessWidget {
  final OrdersController controller;

  const _OrdersTabs({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final colors = Theme.of(context).colorScheme;
      final selectedTab = controller.selectedTab.value;

      return GlassContainer(
        padding: const EdgeInsets.all(5),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            _OrderTabButton(
              label: 'Pending'.tr,
              tab: OrderTab.pending,
              selectedTab: selectedTab,
              controller: controller,
            ),
            _OrderTabButton(
              label: 'Accepted'.tr,
              tab: OrderTab.accepted,
              selectedTab: selectedTab,
              controller: controller,
            ),
            _OrderTabButton(
              label: 'Previous'.tr,
              tab: OrderTab.previous,
              selectedTab: selectedTab,
              controller: controller,
            ),
          ],
        ),
      );
    });
  }
}

class _OrderTabButton extends StatelessWidget {
  final String label;
  final OrderTab tab;
  final OrderTab selectedTab;
  final OrdersController controller;

  const _OrderTabButton({
    required this.label,
    required this.tab,
    required this.selectedTab,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final isSelected = selectedTab == tab;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.changeTab(tab);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 11,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.surface
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? colors.onSurface
                    : colors.onSurfaceVariant,
                fontWeight: isSelected
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// ORDER CARD
// =============================================================================

class _ClientOrderCard extends StatelessWidget {
  final dynamic order;
  final OrdersController controller;

  const _ClientOrderCard({
    required this.order,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final products = order['products'] is List
        ? order['products'] as List
        : <dynamic>[];

    final quantity = _calculateQuantity(products);

    final status =
        order['status']?.toString().toLowerCase() ?? 'pending';

    final orderId =
        order['id']?.toString() ?? '-';

    final orderDate =
        order['order_date']?.toString() ?? '';

    final expectedPrice =
        order['expected_price']?.toString() ?? '0';

    final warehouseId =
        order['src_facility_id']?.toString() ?? '-';

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          _showOrderDetails(
            context,
            order,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // -------------------------------------------------------------
              // TOP
              // -------------------------------------------------------------

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _OrderIcon(
                    status: status,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#ORD-$orderId',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Row(
                          children: [
                            Icon(
                              Icons.warehouse_outlined,
                              size: 14,
                              color: colors.onSurfaceVariant,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                '${'Warehouse'.tr} #$warehouseId',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    theme.textTheme.bodySmall?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  _StatusBadge(
                    status: status,
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Divider(
                height: 1,
                color: colors.surfaceContainerHighest,
              ),

              const SizedBox(height: 12),

              // -------------------------------------------------------------
              // BOTTOM INFO
              // -------------------------------------------------------------

              Row(
                children: [
                  _OrderInfo(
                    icon: Icons.inventory_2_outlined,
                    text: '$quantity ${'items'.tr}',
                  ),

                  const SizedBox(width: 14),

                  _OrderInfo(
                    icon: Icons.attach_money_rounded,
                    text: expectedPrice,
                  ),

                  const Spacer(),

                  Flexible(
                    child: Text(
                      orderDate,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 13,
                    color: colors.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _calculateQuantity(List products) {
    return products.fold<int>(
      0,
      (sum, item) {
        final value = item['quantity'];

        if (value is int) {
          return sum + value;
        }

        if (value is num) {
          return sum + value.toInt();
        }

        return sum;
      },
    );
  }

  void _showOrderDetails(
    BuildContext context,
    dynamic order,
  ) {
    Get.bottomSheet(
      ClientOrderDetailsSheet(
        order: order,
        controller: controller,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

// =============================================================================
// ORDER ICON
// =============================================================================

class _OrderIcon extends StatelessWidget {
  final String status;

  const _OrderIcon({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final color = _statusColor(
      status,
      colors,
    );

    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(
        Icons.shopping_bag_outlined,
        size: 21,
        color: color,
      ),
    );
  }
}

// =============================================================================
// STATUS BADGE
// =============================================================================

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final color = _statusColor(
      status,
      colors,
    );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.11),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        _translatedStatus(status),
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// =============================================================================
// ORDER INFO
// =============================================================================

class _OrderInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _OrderInfo({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: colors.onSurfaceVariant,
          ),

          const SizedBox(width: 5),

          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// EMPTY STATE
// =============================================================================

class _OrdersEmptyState extends StatelessWidget {
  final OrderTab tab;

  const _OrdersEmptyState({
    required this.tab,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final content = _emptyStateContent(tab);

    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 38,
        ),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 46,
              color: colors.onSurfaceVariant.withOpacity(0.45),
            ),

            const SizedBox(height: 14),

            Text(
              content.title.tr,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              content.subtitle.tr,
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

  _EmptyStateContent _emptyStateContent(OrderTab tab) {
    switch (tab) {
      case OrderTab.pending:
        return const _EmptyStateContent(
          title: 'No pending orders',
          subtitle:
              'New orders will appear here while waiting for approval.',
        );

      case OrderTab.accepted:
        return const _EmptyStateContent(
          title: 'No active orders',
          subtitle:
              'Accepted orders will appear here while they are being processed.',
        );

      case OrderTab.previous:
        return const _EmptyStateContent(
          title: 'No previous orders',
          subtitle:
              'Your completed orders will appear here.',
        );
    }
  }
}

class _EmptyStateContent {
  final String title;
  final String subtitle;

  const _EmptyStateContent({
    required this.title,
    required this.subtitle,
  });
}

// =============================================================================
// STATUS HELPERS
// =============================================================================

String _translatedStatus(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return 'Waiting Approval'.tr;

    case 'approved':
      return 'Approved'.tr;

    case 'delivered':
      return 'Delivered'.tr;

    case 'rejected':
      return 'Rejected'.tr;

    case 'cancelled':
      return 'Cancelled'.tr;

    default:
      return status.tr;
  }
}

Color _statusColor(
  String status,
  ColorScheme colors,
) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Colors.blue;

    case 'approved':
      return colors.tertiary;

    case 'delivered':
      return colors.tertiary;

    case 'rejected':
    case 'cancelled':
      return colors.error;

    default:
      return colors.primary;
  }
}
