import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/owner/home/controllers/owner_home_controller.dart';

class OwnerHomeView extends StatelessWidget {
  const OwnerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final backgroundColor =
        Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Obx(
          () {
            final controller = Get.find<OwnerHomeController>();

            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: colors.primary,
                  strokeWidth: 2.5,
                ),
              );
            }

            return RefreshIndicator(
              color: colors.primary,
              onRefresh: controller.refreshHome,
              child: ListView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  18,
                  20,
                  35,
                ),
                children: [
                  _Header(
                    controller: controller,
                    colors: colors,
                  ),

                  const SizedBox(height: 24),

                  _MainHero(
                    controller: controller,
                    colors: colors,
                  ),

                  const SizedBox(height: 28),

                  _SectionTitle(
                    title: 'Quick access',
                    colors: colors,
                  ),

                  const SizedBox(height: 13),

                  _QuickAccess(
                    controller: controller,
                    colors: colors,
                  ),

                  const SizedBox(height: 30),

                  _SectionHeader(
                    title: 'Your space',
                    action: 'View all',
                    colors: colors,
                    onTap: controller.openWarehouses,
                  ),

                  const SizedBox(height: 13),

                  if (controller.warehouses.isEmpty)
                    _EmptyState(
                      icon: Icons.warehouse_outlined,
                      title: 'Your warehouse space is empty',
                      subtitle:
                          'Create your first warehouse to get started.',
                      colors: colors,
                    )
                  else
                    ...controller.warehouses.take(2).map(
                      (warehouse) => Padding(
                        padding:
                            const EdgeInsets.only(bottom: 12),
                        child: _WarehouseCard(
                          warehouse: warehouse,
                          colors: colors,
                          onTap: () {
                            controller.openWarehouse(warehouse);
                          },
                        ),
                      ),
                    ),

                  const SizedBox(height: 18),

                  _SectionHeader(
                    title: 'Needs attention',
                    action: 'See products',
                    colors: colors,
                    onTap: controller.openProducts,
                  ),

                  const SizedBox(height: 13),

                  if (controller.lowStockProducts.isEmpty)
                    _SuccessBanner(
                      colors: colors,
                    )
                  else
                    ...controller.lowStockProducts.take(2).map(
                      (product) => Padding(
                        padding:
                            const EdgeInsets.only(bottom: 10),
                        child: _AttentionCard(
                          product: product,
                          colors: colors,
                          onTap: () {
                            controller.openProduct(product);
                          },
                        ),
                      ),
                    ),

                  const SizedBox(height: 18),

                  _SectionHeader(
                    title: 'Latest activity',
                    action: 'All orders',
                    colors: colors,
                    onTap: controller.openOrders,
                  ),

                  const SizedBox(height: 13),

                  if (controller.recentOrders.isEmpty)
                    _EmptyState(
                      icon: Icons.bolt_rounded,
                      title: 'Nothing happening yet',
                      subtitle:
                          'Your latest warehouse activity will appear here.',
                      colors: colors,
                    )
                  else
                    _ActivityCard(
                      orders:
                          controller.recentOrders.take(4).toList(),
                      colors: colors,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// =============================================================================
// HEADER
// =============================================================================

class _Header extends StatelessWidget {
  final OwnerHomeController controller;
  final ColorScheme colors;

  const _Header({
    required this.controller,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.greeting.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: colors.onSurface.withOpacity(.55),
                  letterSpacing: 1.3,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                controller.ownerName.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  color: colors.onSurface,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
        ),

        GestureDetector(
          onTap: controller.openProfile,
          child: Container(
            width: 49,
            height: 49,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.primary,
                  colors.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withOpacity(.22),
                  blurRadius: 15,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: colors.onPrimary,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// MAIN HERO
// =============================================================================

class _MainHero extends StatelessWidget {
  final OwnerHomeController controller;
  final ColorScheme colors;

  const _MainHero({
    required this.controller,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 245,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary,
            colors.secondary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(.18),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            right: -60,
            top: -70,
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.onPrimary.withOpacity(.08),
              ),
            ),
          ),

          Positioned(
            right: 45,
            bottom: -90,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.onPrimary.withOpacity(.06),
              ),
            ),
          ),

          Positioned(
            right: 20,
            top: 20,
            child: Icon(
              Icons.grid_4x4_rounded,
              size: 90,
              color: colors.onPrimary.withOpacity(.035),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(23),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: colors.tertiary,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      'SMARTWARE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        color: colors.onPrimary.withOpacity(.72),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Text(
                  'Everything under\ncontrol.',
                  style: TextStyle(
                    fontSize: 25,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                    color: colors.onPrimary,
                    letterSpacing: -.9,
                  ),
                ),

                const Spacer(),

                Row(
                  children: [
                    _HeroMetric(
                      value:
                          controller.warehouseCount.value.toString(),
                      label: 'WAREHOUSES',
                      colors: colors,
                    ),

                    _HeroDivider(
                      colors: colors,
                    ),

                    _HeroMetric(
                      value:
                          controller.productCount.value.toString(),
                      label: 'PRODUCTS',
                      colors: colors,
                    ),

                    _HeroDivider(
                      colors: colors,
                    ),

                    _HeroMetric(
                      value:
                          controller.pendingOrders.value.toString(),
                      label: 'PENDING',
                      colors: colors,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(10),
                          color:
                              colors.onPrimary.withOpacity(.10),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: controller
                              .overallCapacity
                              .value
                              .clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(10),
                              color: colors.tertiary,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Text(
                      'LIVE',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        color: colors.tertiary,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  final String value;
  final String label;
  final ColorScheme colors;

  const _HeroMetric({
    required this.value,
    required this.label,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: colors.onPrimary,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            label,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              letterSpacing: .7,
              color: colors.onPrimary.withOpacity(.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroDivider extends StatelessWidget {
  final ColorScheme colors;

  const _HeroDivider({
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: colors.onPrimary.withOpacity(.10),
    );
  }
}

// =============================================================================
// QUICK ACCESS
// =============================================================================

class _QuickAccess extends StatelessWidget {
  final OwnerHomeController controller;
  final ColorScheme colors;

  const _QuickAccess({
    required this.controller,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickButton(
            icon: Icons.inventory_2_rounded,
            title: 'Add product',
            subtitle: 'Inventory',
            color: colors.primary,
            colors: colors,
            onTap: controller.addProduct,
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: _QuickButton(
            icon: Icons.person_add_alt_1_rounded,
            title: 'Add worker',
            subtitle: 'Team',
            color: colors.secondary,
            colors: colors,
            onTap: controller.addWorker,
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: _QuickButton(
            icon: Icons.receipt_long_rounded,
            title: 'Orders',
            subtitle: 'Requests',
            color: colors.tertiary,
            colors: colors,
            onTap: controller.openOrders,
          ),
        ),
      ],
    );
  }
}

class _QuickButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final ColorScheme colors;
  final VoidCallback onTap;

  const _QuickButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(21),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            border: Border.all(
              color: colors.outline.withOpacity(.25),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 37,
                height: 37,
                decoration: BoxDecoration(
                  color: color.withOpacity(.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 19,
                  color: color,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: colors.onSurface,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: colors.onSurface.withOpacity(.55),
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
// SECTION
// =============================================================================

class _SectionTitle extends StatelessWidget {
  final String title;
  final ColorScheme colors;

  const _SectionTitle({
    required this.title,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w900,
        color: colors.onSurface,
        letterSpacing: -.4,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String action;
  final ColorScheme colors;
  final VoidCallback onTap;

  const _SectionHeader({
    required this.title,
    required this.action,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: colors.onSurface,
              letterSpacing: -.4,
            ),
          ),
        ),

        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Text(
                action,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: colors.primary,
                ),
              ),

              const SizedBox(width: 5),

              Icon(
                Icons.arrow_forward_rounded,
                size: 15,
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
// WAREHOUSE
// =============================================================================

class _WarehouseCard extends StatelessWidget {
  final OwnerWarehouseHomeModel warehouse;
  final ColorScheme colors;
  final VoidCallback onTap;

  const _WarehouseCard({
    required this.warehouse,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final capacity =
        warehouse.capacity.clamp(0.0, 1.0);

    final capacityColor =
        capacity >= .9
            ? colors.error
            : capacity >= .7
                ? colors.secondary
                : colors.tertiary;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colors.outline.withOpacity(.25),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _WarehouseImage(
                    imageUrl: warehouse.imageUrl,
                    colors: colors,
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          warehouse.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: colors.onSurface,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 12,
                              color:
                                  colors.onSurface.withOpacity(.55),
                            ),

                            const SizedBox(width: 3),

                            Expanded(
                              child: Text(
                                warehouse.location,
                                maxLines: 1,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: colors.onSurface
                                      .withOpacity(.55),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colors.primary.withOpacity(.08),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(
                      Icons.arrow_outward_rounded,
                      size: 16,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 17),

              Row(
                children: [
                  Text(
                    'SPACE UTILIZATION',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .8,
                      color:
                          colors.onSurface.withOpacity(.50),
                    ),
                  ),

                  const Spacer(),

                  Text(
                    '${(capacity * 100).round()}%',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: capacityColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Container(
                      height: 7,
                      color: colors.onSurface.withOpacity(.07),
                    ),

                    FractionallySizedBox(
                      widthFactor: capacity,
                      child: Container(
                        height: 7,
                        color: capacityColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WarehouseImage extends StatelessWidget {
  final String? imageUrl;
  final ColorScheme colors;

  const _WarehouseImage({
    required this.imageUrl,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage =
        imageUrl != null &&
        imageUrl!.trim().isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(17),
      child: SizedBox(
        width: 58,
        height: 58,
        child: hasImage
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return _placeholder();
                },
              )
            : _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      decoration: BoxDecoration(
        color: colors.primary.withOpacity(.08),
      ),
      child: Icon(
        Icons.warehouse_rounded,
        color: colors.primary,
        size: 26,
      ),
    );
  }
}

// =============================================================================
// LOW STOCK
// =============================================================================

class _AttentionCard extends StatelessWidget {
  final OwnerLowStockHomeModel product;
  final ColorScheme colors;
  final VoidCallback onTap;

  const _AttentionCard({
    required this.product,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: colors.error.withOpacity(.20),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: colors.error.withOpacity(.08),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: colors.error,
                  size: 21,
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
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: colors.onSurface,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Minimum ${product.minimumStock} units',
                      style: TextStyle(
                        fontSize: 10,
                        color:
                            colors.onSurface.withOpacity(.55),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    product.currentStock.toString(),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: colors.error,
                    ),
                  ),

                  Text(
                    'remaining',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color:
                          colors.onSurface.withOpacity(.50),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.chevron_right_rounded,
                size: 21,
                color: colors.onSurface.withOpacity(.25),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// SUCCESS
// =============================================================================

class _SuccessBanner extends StatelessWidget {
  final ColorScheme colors;

  const _SuccessBanner({
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: colors.tertiary.withOpacity(.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: colors.tertiary.withOpacity(.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: colors.tertiary,
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
                  'Inventory looks healthy',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: colors.onSurface,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'No products require immediate attention.',
                  style: TextStyle(
                    fontSize: 10,
                    color:
                        colors.onSurface.withOpacity(.55),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.verified_rounded,
            color: colors.tertiary,
            size: 20,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// ACTIVITY
// =============================================================================

class _ActivityCard extends StatelessWidget {
  final List<OwnerRecentOrderModel> orders;
  final ColorScheme colors;

  const _ActivityCard({
    required this.orders,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: colors.outline.withOpacity(.25),
        ),
      ),
      child: Column(
        children: [
          for (int i = 0; i < orders.length; i++)
            _ActivityRow(
              order: orders[i],
              isLast: i == orders.length - 1,
              colors: colors,
            ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final OwnerRecentOrderModel order;
  final bool isLast;
  final ColorScheme colors;

  const _ActivityRow({
    required this.order,
    required this.isLast,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        15,
        14,
        15,
        14,
      ),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: colors.outline.withOpacity(.15),
                ),
              ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.bolt_rounded,
              size: 19,
              color: colors.primary,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  order.orderNumber,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: colors.onSurface,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  order.clientName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    color:
                        colors.onSurface.withOpacity(.55),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              order.status,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w900,
                color: colors.primary,
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

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final ColorScheme colors;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 25,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: colors.outline.withOpacity(.25),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: colors.primary,
              size: 22,
            ),
          ),

          const SizedBox(height: 11),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: colors.onSurface,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              height: 1.4,
              color: colors.onSurface.withOpacity(.55),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}