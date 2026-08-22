import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoWarehouseState extends StatelessWidget {
  const NoWarehouseState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            Icons.warehouse_outlined,
            size: 34,
            color: colors.onSurfaceVariant.withOpacity(0.55),
          ),

          const SizedBox(height: 10),

          Text(
            'No warehouse can fulfill this quantity'.tr,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Try reducing the quantity and check again.'.tr,
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
