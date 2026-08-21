import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/owner/home/controllers/owner_home_controller.dart';
import 'package:smartware/features/owner/analytics/models/warehouse_model.dart';

class OwnerHomeView extends StatelessWidget {
  const OwnerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Obx(() {
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
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 35),
              children: [
                // ===========================================================
                // HEADER
                // ===========================================================

                _Header(
                  controller: controller,
                  colors: colors,
                ),

                const SizedBox(height: 18),

                // ===========================================================
                // CURRENT WAREHOUSE
                // ===========================================================

                _WarehouseSwitcherButton(
                  controller: controller,
                  colors: colors,
                ),

                const SizedBox(height: 24),

                // ===========================================================
                // OVERVIEW
                // ===========================================================

                _OverviewCard(
                  controller: controller,
                  colors: colors,
                ),

                const SizedBox(height: 28),

                // ===========================================================
                // QUICK ACCESS
                // ===========================================================

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

                // ===========================================================
                // WAREHOUSES
                // ===========================================================

                _SectionHeader(
                  title: 'Your warehouses',
                  action: 'View all',
                  colors: colors,
                  onTap: controller.openWarehouses,
                ),

                const SizedBox(height: 13),

                if (controller.warehouses.isEmpty)
                  _EmptyWarehouseState(
                    controller: controller,
                    colors: colors,
                  )
                else
                  ...controller.warehouses.take(2).map(
                    (warehouse) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
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

                // ===========================================================
                // INVENTORY STATUS
                // ===========================================================

                _SectionHeader(
                  title: 'Inventory status',
                  action: 'See products',
                  colors: colors,
                  onTap: controller.openProducts,
                ),

                const SizedBox(height: 13),

                _InventoryStatusCard(
                  controller: controller,
                  colors: colors,
                ),

                const SizedBox(height: 18),

                // ===========================================================
                // ADD FACILITY
                // ===========================================================

                _AddFacilityCard(
                  controller: controller,
                  colors: colors,
                ),
              ],
            ),
          );
        }),
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
    return Column(
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
          controller.userName.value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w900,
            color: colors.onSurface,
            letterSpacing: -1,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          'Manage your warehouse operations.',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: colors.onSurface.withOpacity(.50),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// WAREHOUSE SWITCHER
// =============================================================================

class _WarehouseSwitcherButton extends StatelessWidget {
  final OwnerHomeController controller;
  final ColorScheme colors;

  const _WarehouseSwitcherButton({
    required this.controller,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final warehouse = controller.selectedWarehouse.value;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () {
          controller.openWarehouseSwitcher(context);
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colors.outline.withOpacity(.25),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(.09),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.warehouse_rounded,
                  color: colors.primary,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CURRENT WAREHOUSE',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .8,
                        color: colors.onSurface.withOpacity(.45),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      warehouse?.nameEn ?? 'Select warehouse',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: colors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: colors.onSurface.withOpacity(.55),
                size: 23,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// OVERVIEW CARD
// =============================================================================

class _OverviewCard extends StatelessWidget {
  final OwnerHomeController controller;
  final ColorScheme colors;

  const _OverviewCard({
    required this.controller,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
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
          children: [
            // =============================================================
            // BACKGROUND CIRCLES
            // =============================================================

            Positioned(
              right: -55,
              top: -60,
              child: Container(
                width: 155,
                height: 155,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.onPrimary.withOpacity(.07),
                ),
              ),
            ),

            Positioned(
              right: 28,
              top: 78,
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.onPrimary.withOpacity(.07),
                ),
              ),
            ),

            Positioned(
              left: -70,
              bottom: -75,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.onPrimary.withOpacity(.055),
                ),
              ),
            ),

            Positioned(
              right: 70,
              bottom: -22,
              child: Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.onPrimary.withOpacity(.055),
                ),
              ),
            ),

            // =============================================================
            // TRIANGLES
            // =============================================================

            Positioned(
              right: -15,
              top: 30,
              child: Transform.rotate(
                angle: .35,
                child: CustomPaint(
                  size: const Size(80, 80),
                  painter: _TrianglePainter(
                    color: colors.onPrimary.withOpacity(.055),
                  ),
                ),
              ),
            ),

            Positioned(
              left: 85,
              bottom: -15,
              child: Transform.rotate(
                angle: -.45,
                child: CustomPaint(
                  size: const Size(58, 58),
                  painter: _TrianglePainter(
                    color: colors.onPrimary.withOpacity(.05),
                  ),
                ),
              ),
            ),

            Positioned(
              right: 95,
              bottom: 38,
              child: Transform.rotate(
                angle: .55,
                child: CustomPaint(
                  size: const Size(35, 35),
                  painter: _TrianglePainter(
                    color: colors.onPrimary.withOpacity(.045),
                  ),
                ),
              ),
            ),

            // =============================================================
            // DIAGONAL LINES
            // =============================================================

            Positioned(
              right: 40,
              top: 38,
              child: Transform.rotate(
                angle: -.65,
                child: Container(
                  width: 115,
                  height: 1,
                  color: colors.onPrimary.withOpacity(.07),
                ),
              ),
            ),

            Positioned(
              right: -10,
              bottom: 72,
              child: Transform.rotate(
                angle: -.65,
                child: Container(
                  width: 95,
                  height: 1,
                  color: colors.onPrimary.withOpacity(.06),
                ),
              ),
            ),

            // =============================================================
            // CONTENT
            // =============================================================

            Padding(
              padding: const EdgeInsets.all(22),
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
                    'Warehouse\noverview.',
                    style: TextStyle(
                      fontSize: 25,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                      color: colors.onPrimary,
                      letterSpacing: -.9,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [
                      _OverviewMetric(
                        value:
                            controller.warehouseCount.value.toString(),
                        label: 'WAREHOUSES',
                        colors: colors,
                      ),

                      _OverviewDivider(
                        colors: colors,
                      ),

                      _OverviewMetric(
                        value:
                            controller.productCount.value.toString(),
                        label: 'PRODUCTS',
                        colors: colors,
                      ),

                      _OverviewDivider(
                        colors: colors,
                      ),

                      _OverviewMetric(
                        value:
                            controller.lowStockCount.value.toString(),
                        label: 'LOW STOCK',
                        colors: colors,
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Container(
                    height: 1,
                    color: colors.onPrimary.withOpacity(.10),
                  ),

                  const SizedBox(height: 13),

                  Row(
                    children: [
                      Icon(
                        controller.hasAlerts
                            ? Icons.warning_amber_rounded
                            : Icons.check_circle_outline_rounded,
                        size: 16,
                        color: controller.hasAlerts
                            ? colors.tertiary
                            : colors.onPrimary.withOpacity(.70),
                      ),

                      const SizedBox(width: 7),

                      Expanded(
                        child: Text(
                          controller.hasAlerts
                              ? '${controller.lowStockCount.value} item(s) need attention'
                              : 'Inventory is looking healthy',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: colors.onPrimary.withOpacity(.72),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// TRIANGLE PAINTER
// =============================================================================

class _TrianglePainter extends CustomPainter {
  final Color color;

  const _TrianglePainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(
      size.width / 2,
      0,
    );

    path.lineTo(
      size.width,
      size.height,
    );

    path.lineTo(
      0,
      size.height,
    );

    path.close();

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _TrianglePainter oldDelegate,
  ) {
    return oldDelegate.color != color;
  }
}

// =============================================================================
// OVERVIEW METRIC
// =============================================================================

class _OverviewMetric extends StatelessWidget {
  final String value;
  final String label;
  final ColorScheme colors;

  const _OverviewMetric({
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

          const SizedBox(height: 3),

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

// =============================================================================
// OVERVIEW DIVIDER
// =============================================================================

class _OverviewDivider extends StatelessWidget {
  final ColorScheme colors;

  const _OverviewDivider({
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
            color: colors.primary,
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

// =============================================================================
// QUICK BUTTON
// =============================================================================

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
// SECTION TITLE
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

// =============================================================================
// SECTION HEADER
// =============================================================================

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
// WAREHOUSE CARD
// =============================================================================

class _WarehouseCard extends StatelessWidget {
  final WarehouseModel warehouse;
  final ColorScheme colors;
  final VoidCallback onTap;

  const _WarehouseCard({
    required this.warehouse,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(23),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(23),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(23),
            border: Border.all(
              color: colors.outline.withOpacity(.25),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(.08),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  Icons.warehouse_rounded,
                  color: colors.primary,
                  size: 27,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      warehouse.nameEn,
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
                          color: colors.onSurface.withOpacity(.55),
                        ),

                        const SizedBox(width: 3),

                        Expanded(
                          child: Text(
                            warehouse.location.isNotEmpty
                                ? warehouse.location
                                : 'Location unavailable',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: colors.onSurface.withOpacity(.55),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '${warehouse.productCount} products',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: colors.primary,
                      ),
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
        ),
      ),
    );
  }
}

// =============================================================================
// EMPTY WAREHOUSE STATE
// =============================================================================

class _EmptyWarehouseState extends StatelessWidget {
  final OwnerHomeController controller;
  final ColorScheme colors;

  const _EmptyWarehouseState({
    required this.controller,
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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warehouse_outlined,
              color: colors.primary,
              size: 24,
            ),
          ),

          const SizedBox(height: 11),

          Text(
            'No warehouses yet',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: colors.onSurface,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Create your first facility to start managing your warehouse.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              height: 1.4,
              color: colors.onSurface.withOpacity(.55),
            ),
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.addFacility,
              icon: const Icon(
                Icons.add_rounded,
                size: 18,
              ),
              label: const Text(
                'Add Facility',
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// INVENTORY STATUS
// =============================================================================

class _InventoryStatusCard extends StatelessWidget {
  final OwnerHomeController controller;
  final ColorScheme colors;

  const _InventoryStatusCard({
    required this.controller,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final hasAlerts = controller.hasAlerts;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: hasAlerts
              ? colors.error.withOpacity(.20)
              : colors.tertiary.withOpacity(.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: hasAlerts
                  ? colors.error.withOpacity(.08)
                  : colors.tertiary.withOpacity(.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              hasAlerts
                  ? Icons.warning_amber_rounded
                  : Icons.check_rounded,
              color: hasAlerts
                  ? colors.error
                  : colors.tertiary,
              size: 23,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasAlerts
                      ? 'Inventory needs attention'
                      : 'Inventory looks healthy',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: colors.onSurface,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  hasAlerts
                      ? '${controller.lowStockCount.value} product(s) have a stock risk.'
                      : 'No stock-out risks detected.',
                  style: TextStyle(
                    fontSize: 10,
                    color: colors.onSurface.withOpacity(.55),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.chevron_right_rounded,
            color: colors.onSurface.withOpacity(.25),
            size: 21,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// ADD FACILITY
// =============================================================================

class _AddFacilityCard extends StatelessWidget {
  final OwnerHomeController controller;
  final ColorScheme colors;

  const _AddFacilityCard({
    required this.controller,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.primary.withOpacity(.07),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: controller.addFacility,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: colors.primary.withOpacity(.12),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.add_business_rounded,
                  color: colors.primary,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add another facility',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: colors.primary,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      'Expand your warehouse space.',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: colors.onSurface.withOpacity(.55),
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_rounded,
                size: 19,
                color: colors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}