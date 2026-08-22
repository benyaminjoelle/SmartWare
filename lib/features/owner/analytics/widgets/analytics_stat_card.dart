import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/owner/analytics/controllers/owner_analytic_controller.dart';
import 'package:smartware/features/owner/analytics/widgets/low_stock_card.dart';

class AnalyticsSummaryGrid extends StatelessWidget {
  final OwnerAnalyticsController controller;

  const AnalyticsSummaryGrid({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 360;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: isSmall ? 125 : 115,
          ),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return AnalyticsStatCard(
                  title: 'products'.tr,
                  value: controller.totalProducts.value.toString(),
                  icon: Icons.inventory_2_outlined,
                  onTap: () {
                    Get.toNamed('ownerProducts');
                  },
                );

              case 1:
                return AnalyticsStatCard(
                  title: 'low_stock'.tr,
                  value: controller.lowStockCount.value.toString(),
                  icon: Icons.warning_amber_rounded,
                  iconColor: colors.error,
                  onTap: () {
                    Get.to(
                      () => LowStockCard(
                        controller: controller,
                      ),
                    );
                  },
                );

              default:
                return AnalyticsStatCard(
                  title: 'pending_orders'.tr,
                  value: controller.pendingOrders.value.toString(),
                  icon: Icons.shopping_cart_outlined,
                  onTap: () {
                    // TODO: Open pending orders
                  },
                );
            }
          },
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// ANALYTICS STAT CARD
// -----------------------------------------------------------------------------

class AnalyticsStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const AnalyticsStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    size: 22,
                    color: iconColor ?? colors.primary,
                  ),

                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: colors.onSurfaceVariant,
                  ),
                ],
              ),

              const Spacer(),

              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 3),

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
      ),
    );
  }
}
