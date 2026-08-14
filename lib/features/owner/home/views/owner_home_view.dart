import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/owner/home/controllers/owner_home_controller.dart';

class OwnerHomeView extends StatelessWidget {
  const OwnerHomeView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final OwnerHomeController controller =
        Get.find<OwnerHomeController>();

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return RefreshIndicator(
              onRefresh: controller.refreshHome,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  18,
                  20,
                  30,
                ),
                children: [
                  // ============================================================
                  // HEADER
                  // ============================================================

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.greeting,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              controller.ownerName.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      _ProfileButton(
                        onTap: controller.openProfile,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ============================================================
                  // OVERVIEW
                  // ============================================================

                  Text(
                    'Overview',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _OverviewGrid(
                    controller: controller,
                  ),

                  const SizedBox(height: 28),

                  // ============================================================
                  // QUICK ACTIONS
                  // ============================================================

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quick actions',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _QuickActions(
                    controller: controller,
                  ),

                  const SizedBox(height: 28),

                  // ============================================================
                  // WAREHOUSES
                  // ============================================================

                  _SectionHeader(
                    title: 'Your warehouses',
                    actionText: 'View all',
                    onTap: controller.openWarehouses,
                  ),

                  const SizedBox(height: 12),

                  if (controller.warehouses.isEmpty)
                    const _EmptyHomeState(
                      icon: Icons.warehouse_outlined,
                      title: 'No warehouses yet',
                      subtitle: 'Add your first warehouse to get started.',
                    )
                  else
                    ...controller.warehouses.take(3).map(
                      (warehouse) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _WarehouseHomeCard(
                            warehouse: warehouse,
                            onTap: () {
                              controller.openWarehouse(warehouse);
                            },
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 16),

                  // ============================================================
                  // LOW STOCK
                  // ============================================================

                  _SectionHeader(
                    title: 'Needs attention',
                    actionText: 'View products',
                    onTap: controller.openProducts,
                  ),

                  const SizedBox(height: 12),

                  if (controller.lowStockProducts.isEmpty)
                    const _EmptyHomeState(
                      icon: Icons.check_circle_outline_rounded,
                      title: 'Everything looks good',
                      subtitle: 'No products are currently low on stock.',
                    )
                  else
                    ...controller.lowStockProducts.take(3).map(
                      (product) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _LowStockHomeCard(
                            product: product,
                            onTap: () {
                              controller.openProduct(product);
                            },
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 18),

                  // ============================================================
                  // RECENT ORDERS
                  // ============================================================

                  _SectionHeader(
                    title: 'Recent orders',
                    actionText: 'View all',
                    onTap: controller.openOrders,
                  ),

                  const SizedBox(height: 12),

                  if (controller.recentOrders.isEmpty)
                    const _EmptyHomeState(
                      icon: Icons.receipt_long_outlined,
                      title: 'No recent orders',
                      subtitle: 'New orders will appear here.',
                    )
                  else
                    ...controller.recentOrders.take(4).map(
                      (order) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _RecentOrderCard(
                            order: order,
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

// =============================================================================
// PROFILE BUTTON
// =============================================================================

class _ProfileButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ProfileButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(
            Icons.person_outline_rounded,
            color: colors.onSurface,
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// OVERVIEW GRID
// =============================================================================

class _OverviewGrid extends StatelessWidget {
  final OwnerHomeController controller;

  const _OverviewGrid({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.7,
      children: [
        _OverviewCard(
          title: 'Warehouses',
          value: controller.warehouseCount.toString(),
          icon: Icons.warehouse_outlined,
        ),

        _OverviewCard(
          title: 'Products',
          value: controller.productCount.toString(),
          icon: Icons.inventory_2_outlined,
        ),

        _OverviewCard(
          title: 'Pending orders',
          value: controller.pendingOrders.toString(),
          icon: Icons.shopping_cart_outlined,
        ),

        _OverviewCard(
          title: 'Low stock',
          value: controller.lowStockCount.toString(),
          icon: Icons.warning_amber_rounded,
        ),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _OverviewCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 21,
            color: colors.primary,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// QUICK ACTIONS
// =============================================================================

class _QuickActions extends StatelessWidget {
  final OwnerHomeController controller;

  const _QuickActions({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.add_box_outlined,
            label: 'Add product',
            onTap: controller.addProduct,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _QuickActionButton(
            icon: Icons.person_add_alt_outlined,
            label: 'Add worker',
            onTap: controller.addWorker,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _QuickActionButton(
            icon: Icons.receipt_long_outlined,
            label: 'Orders',
            onTap: controller.openOrders,
          ),
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 14,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 21,
                color: colors.primary,
              ),

              const SizedBox(height: 7),

              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// SECTION HEADER
// =============================================================================

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onTap;

  const _SectionHeader({
    required this.title,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        TextButton(
          onPressed: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                actionText,
                style: TextStyle(
                  color: colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(width: 3),

              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 11,
                color: colors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// WAREHOUSE CARD
// =============================================================================

class _WarehouseHomeCard extends StatelessWidget {
  final OwnerWarehouseHomeModel warehouse;
  final VoidCallback onTap;

  const _WarehouseHomeCard({
    required this.warehouse,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final capacity = warehouse.capacity.clamp(0.0, 1.0);

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  _SmallImage(
                    imageUrl: warehouse.imageUrl,
                    icon: Icons.warehouse_outlined,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          warehouse.name,
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
                              Icons.location_on_outlined,
                              size: 14,
                              color: colors.onSurfaceVariant,
                            ),

                            const SizedBox(width: 3),

                            Expanded(
                              child: Text(
                                warehouse.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
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

                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: colors.onSurfaceVariant,
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Text(
                    'Capacity',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    '${(capacity * 100).round()}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 7),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: capacity,
                  minHeight: 6,
                  backgroundColor: colors.surfaceContainerHighest,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// LOW STOCK CARD
// =============================================================================

class _LowStockHomeCard extends StatelessWidget {
  final OwnerLowStockHomeModel product;
  final VoidCallback onTap;

  const _LowStockHomeCard({
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              _SmallImage(
                imageUrl: product.imageUrl,
                icon: Icons.inventory_2_outlined,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Minimum ${product.minimumStock}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    product.currentStock.toString(),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.error,
                    ),
                  ),

                  Text(
                    'in stock',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// RECENT ORDER CARD
// =============================================================================

class _RecentOrderCard extends StatelessWidget {
  final OwnerRecentOrderModel order;

  const _RecentOrderCard({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 20,
              color: colors.primary,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.orderNumber,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  order.clientName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Text(
            order.status,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// SMALL IMAGE
// =============================================================================

class _SmallImage extends StatelessWidget {
  final String? imageUrl;
  final IconData icon;

  const _SmallImage({
    required this.imageUrl,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final hasImage =
        imageUrl != null && imageUrl!.trim().isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 48,
        height: 48,
        child: hasImage
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return _EmptyImage(
                    icon: icon,
                  );
                },
              )
            : _EmptyImage(
                icon: icon,
              ),
      ),
    );
  }
}

class _EmptyImage extends StatelessWidget {
  final IconData icon;

  const _EmptyImage({
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      color: colors.surfaceContainerHighest.withOpacity(0.45),
      child: Icon(
        icon,
        size: 22,
        color: colors.onSurfaceVariant.withOpacity(0.5),
      ),
    );
  }
}

// =============================================================================
// EMPTY STATE
// =============================================================================

class _EmptyHomeState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyHomeState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 30,
            color: colors.onSurfaceVariant.withOpacity(0.45),
          ),

          const SizedBox(height: 10),

          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

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