import 'package:flutter/material.dart';
import 'package:smartware/features/owner/analytics/controllers/owner_analytic_controller.dart';

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
              _WarehouseHeader(warehouse: warehouse),

              const SizedBox(height: 18),

              // Visible divider between warehouse info and statistics.
              Divider(
                height: 1,
                thickness: 1,
                color: colors.outlineVariant.withOpacity(0.35),
              ),

              const SizedBox(height: 16),

              _WarehouseStats(warehouse: warehouse),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// WAREHOUSE HEADER
// -----------------------------------------------------------------------------

class _WarehouseHeader extends StatelessWidget {
  final WarehouseModel warehouse;

  const _WarehouseHeader({required this.warehouse});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _WarehouseImage(imageUrl: warehouse.imageUrl),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                warehouse.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 6),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 15,
                    color: colors.onSurfaceVariant,
                  ),

                  const SizedBox(width: 4),

                  Expanded(
                    child: Text(
                      warehouse.location,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        height: 1.3,
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

// -----------------------------------------------------------------------------
// WAREHOUSE IMAGE
// -----------------------------------------------------------------------------

class _WarehouseImage extends StatelessWidget {
  final String? imageUrl;

  const _WarehouseImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;
 
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 54,
        height: 54,
        child: hasImage
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return const _EmptyWarehouseImage();
                },
              )
            : const _EmptyWarehouseImage(),
      ),
    );
  }
}

class _EmptyWarehouseImage extends StatelessWidget {
  const _EmptyWarehouseImage();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      color: colors.surfaceContainerHighest.withOpacity(0.45),
      child: Icon(
        Icons.image_outlined,
        size: 25,
        color: colors.onSurfaceVariant.withOpacity(0.55),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// WAREHOUSE STATISTICS
// -----------------------------------------------------------------------------

class _WarehouseStats extends StatelessWidget {
  final WarehouseModel warehouse;

  const _WarehouseStats({required this.warehouse});

  @override
  Widget build(BuildContext context) {
     final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 340;

        if (isSmall) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: MiniStat(
                      label: 'Products',
                      value: warehouse.totalProducts.toString(),
                      icon: Icons.inventory_2_outlined,
                    ),
                  ),
                  Expanded(
                    child: MiniStat(
                      label: 'Stock',
                      value: warehouse.totalStock.toString(),
                      icon: Icons.layers_outlined,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              MiniStat(
                label: 'Low stock',
                value: warehouse.lowStockProducts.toString(),
                icon: Icons.warning_amber_rounded,
                iconColor:colors.error ,
                expanded: true,
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: MiniStat(
                label: 'Products',
                value: warehouse.totalProducts.toString(),
                icon: Icons.inventory_2_outlined,
              ),
            ),

            const _StatDivider(),

            Expanded(
              child: MiniStat(
                label: 'Stock',
                value: warehouse.totalStock.toString(),
                icon: Icons.layers_outlined,
              ),
            ),

            const _StatDivider(),

            Expanded(
              child: MiniStat(
                label: 'Low stock',
                value: warehouse.lowStockProducts.toString(),
                icon: Icons.warning_amber_rounded,
              ),
            ),
          ],
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// MINI STAT
// -----------------------------------------------------------------------------

class MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool expanded;
  final Color? iconColor;

  const MiniStat({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    
    this.expanded = false,
    this.iconColor
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      width: expanded ? double.infinity : null,
      child: Row(
        mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Icon(icon, size: 19, color:iconColor?? colors.primary),

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
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// STAT DIVIDER
// -----------------------------------------------------------------------------

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
