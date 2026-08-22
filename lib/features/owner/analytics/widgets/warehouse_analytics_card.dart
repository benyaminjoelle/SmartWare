import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/owner/analytics/models/warehouse_model.dart';

class WarehouseAnalyticsCard extends StatelessWidget {
  final WarehouseModel warehouse;
  final VoidCallback onTap;

  const WarehouseAnalyticsCard({
    super.key,
    required this.warehouse,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WarehouseHeader(
                warehouse: warehouse,
              ),

              const SizedBox(height: 18),

              Divider(
                height: 1,
                thickness: 1,
                color: colors.outlineVariant.withOpacity(0.35),
              ),

              const SizedBox(height: 16),

              _WarehouseStats(
                warehouse: warehouse,
              ),

              const SizedBox(height: 16),

              Divider(
                height: 1,
                thickness: 1,
                color: colors.outlineVariant.withOpacity(0.35),
              ),

              const SizedBox(height: 14),

              _WarehouseLocation(
                location: warehouse.location,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// HEADER
// ============================================================================

class _WarehouseHeader extends StatelessWidget {
  final WarehouseModel warehouse;

  const _WarehouseHeader({
    required this.warehouse,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        const _WarehouseImage(),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                warehouse.nameEn,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  Icon(
                    Icons.warehouse_outlined,
                    size: 15,
                    color: colors.onSurfaceVariant,
                  ),

                  const SizedBox(width: 4),

                  Expanded(
                    child: Text(
                      warehouse.type,
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
          size: 15,
          color: colors.onSurfaceVariant,
        ),
      ],
    );
  }
}

// ============================================================================
// IMAGE
// ============================================================================

class _WarehouseImage extends StatelessWidget {
  const _WarehouseImage();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 54,
        height: 54,
        color: colors.surfaceContainerHighest.withOpacity(0.45),
        child: Icon(
          Icons.warehouse_outlined,
          size: 25,
          color: colors.onSurfaceVariant.withOpacity(0.55),
        ),
      ),
    );
  }
}

// ============================================================================
// STATS
// ============================================================================

class _WarehouseStats extends StatelessWidget {
  final WarehouseModel warehouse;

  const _WarehouseStats({
    required this.warehouse,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: MiniStat(
            label: 'products'.tr,
            value: warehouse.productCount.toString(),
            icon: Icons.inventory_2_outlined,
          ),
        ),

        const _StatDivider(),

        Expanded(
          child: MiniStat(
            label: 'low_stock'.tr,
            value: warehouse.stockOutRiskCount.toString(),
            icon: Icons.warning_amber_rounded,
            iconColor: colors.error,
          ),
        ),

        const _StatDivider(),

        Expanded(
          child: MiniStat(
            label: 'status'.tr,
            value: warehouse.status,
            icon: Icons.check_circle_outline_rounded,
            iconColor: colors.primary,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// LOCATION
// ============================================================================

class _WarehouseLocation extends StatelessWidget {
  final String location;

  const _WarehouseLocation({
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 19,
          color: colors.onSurfaceVariant,
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            location.isNotEmpty
                ? location
                : 'location_not_available'.tr,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// MINI STAT
// ============================================================================

class MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;

  const MiniStat({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 19,
          color: iconColor ?? colors.primary,
        ),

        const SizedBox(width: 9),

        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// DIVIDER
// ============================================================================

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 1,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: colors.outlineVariant.withOpacity(0.35),
    );
  }
}
