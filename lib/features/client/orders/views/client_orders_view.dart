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
        title: const Text(
          'My Orders',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refreshOrders,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                20,
                8,
                20,
                30,
              ),
              children: [
                // =============================================================
                // HEADER
                // =============================================================

                Text(
                  'Track your orders',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'View your order status and details',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 22),

                // =============================================================
                // TABS
                // =============================================================

                _OrdersTabs(
                  controller: controller,
                ),

                const SizedBox(height: 22),

                // =============================================================
                // CURRENT TAB
                // =============================================================

                Obx(() {
                  final orders = controller.currentOrders;

                  if (orders.isEmpty) {
                    return _OrdersEmptyState(
                      tab: controller.selectedTab.value,
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionIntro(
                        tab: controller.selectedTab.value,
                        count: orders.length,
                      ),

                      const SizedBox(height: 12),

                      ...orders.map(
                        (order) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: 12,
                            ),
                            child: _ClientOrderCard(
                              order: order,
                              controller: controller,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }),
              ],
            ),
          );
        }),
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
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withOpacity(0.55),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          _OrderTabButton(
            label: 'Pending',
            tab: OrderTab.pending,
            controller: controller,
          ),
          _OrderTabButton(
            label: 'Accepted',
            tab: OrderTab.accepted,
            controller: controller,
          ),
          _OrderTabButton(
            label: 'Previous',
            tab: OrderTab.previous,
            controller: controller,
          ),
        ],
      ),
    );
  }
}

class _OrderTabButton extends StatelessWidget {
  final String label;
  final OrderTab tab;
  final OrdersController controller;

  const _OrderTabButton({
    required this.label,
    required this.tab,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final isSelected = controller.selectedTab.value == tab;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(tab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 5,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.surface
                : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.035),
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
              style: TextStyle(
                color: isSelected
                    ? colors.onSurface
                    : colors.onSurfaceVariant,
                fontSize: 12,
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
// SECTION INTRO
// =============================================================================

class _SectionIntro extends StatelessWidget {
  final OrderTab tab;
  final int count;

  const _SectionIntro({
    required this.tab,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    String title;
    String subtitle;

    switch (tab) {
      case OrderTab.pending:
        title = 'Pending orders';
        subtitle = 'Orders waiting for warehouse approval.';

        break;

      case OrderTab.accepted:
        title = 'Active orders';
        subtitle = 'Orders currently being processed.';

        break;

      case OrderTab.previous:
        title = 'Previous orders';
        subtitle = 'Your completed and past orders.';

        break;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        Text(
          '$count ${count == 1 ? 'order' : 'orders'}',
          style: theme.textTheme.labelSmall?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
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

    final products = order["products"] is List
        ? order["products"] as List
        : [];

    final quantity = products.fold<int>(
      0,
      (sum, item) {
        return sum + ((item["quantity"] ?? 0) as int);
      },
    );

    final status =
        order["status"]?.toString() ?? "pending";

    final orderId =
        order["id"]?.toString() ?? "";

    final orderDate =
        order["order_date"]?.toString() ?? "";

    final expectedPrice =
        order["expected_price"]?.toString() ?? "0";

    final warehouseId =
        order["src_facility_id"]?.toString() ?? "-";

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        onTap: () {
          Get.bottomSheet(
            ClientOrderDetailsSheet(
              order: order,
              controller: controller,
            ),
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
          );
        },
        borderRadius: BorderRadius.circular(19),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              // ---------------------------------------------------------------
              // TOP
              // ---------------------------------------------------------------

              Row(
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

                        const SizedBox(height: 4),

                        Row(
                          children: [
                            Icon(
                              Icons.warehouse_outlined,
                              size: 14,
                              color: colors.onSurfaceVariant,
                            ),

                            const SizedBox(width: 4),

                            Expanded(
                              child: Text(
                                'Warehouse #$warehouseId',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    theme.textTheme.bodySmall?.copyWith(
                                  color:
                                      colors.onSurfaceVariant,
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

              // ---------------------------------------------------------------
              // BOTTOM INFO
              // ---------------------------------------------------------------

              Row(
                children: [
                  _OrderInfo(
                    icon: Icons.inventory_2_outlined,
                    text: '$quantity items',
                  ),

                  const SizedBox(width: 14),

                  _OrderInfo(
                    icon: Icons.attach_money_rounded,
                    text: expectedPrice,
                  ),

                  const Spacer(),

                  Text(
                    orderDate,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        theme.textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
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

    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(
        Icons.shopping_bag_outlined,
        size: 21,
        color: colors.primary,
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
    final colors = Theme.of(context).colorScheme;

    final statusColor =
        _statusColor(status, colors);

    String text;

    switch (status.toLowerCase()) {
      case 'pending':
        text = 'Waiting';
        break;

      case 'approved':
        text = 'Accepted';
        break;

      case 'delivered':
        text = 'Delivered';
        break;

      case 'rejected':
        text = 'Rejected';
        break;

      case 'cancelled':
        text = 'Cancelled';
        break;

      default:
        text = status.capitalizeFirst ?? status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.11),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(
          color: statusColor,
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
    final colors = Theme.of(context).colorScheme;

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
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(
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

    String title;
    String subtitle;

    switch (tab) {
      case OrderTab.pending:
        title = 'No pending orders';
        subtitle =
            'New orders will appear here while waiting for approval.';
        break;

      case OrderTab.accepted:
        title = 'No active orders';
        subtitle =
            'Accepted orders will appear here while they are being processed.';
        break;

      case OrderTab.previous:
        title = 'No previous orders';
        subtitle =
            'Your completed orders will appear here.';
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 38,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(19),
      ),
      child: Column(
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 40,
            color: colors.onSurfaceVariant.withOpacity(0.45),
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            subtitle,
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

// =============================================================================
// STATUS COLOR
// =============================================================================

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