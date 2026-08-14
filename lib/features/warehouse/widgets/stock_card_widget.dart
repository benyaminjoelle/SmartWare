import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/warehouse/models/stock_card_model.dart';

class WarehouseStockCardWidget extends StatelessWidget {
  final WarehouseStockCardData stockCard;
  final VoidCallback? onAdjustStockPressed;

  const WarehouseStockCardWidget({
    super.key,
    required this.stockCard,
    this.onAdjustStockPressed,
    required discountNote,
    required String warehouseName,
    required int stockQuantity,
    required num price,
    discountPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isLowStock = stockCard.currentStock <= stockCard.minimumThreshold;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.warehouse_outlined, color: colors.primary, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      stockCard.warehouseName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.grid_view_rounded, size: 14, color: colors.outline),
                      const SizedBox(width: 4),
                      Text(
                        stockCard.aisleLocation,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Current Balance".tr, style: theme.textTheme.bodySmall),
                    const SizedBox(height: 2),
                    Text(
                      "${stockCard.currentStock} units",
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isLowStock ? colors.error : colors.onSurface,
                      ),
                    ),
                  ],
                ),
                if (onAdjustStockPressed != null)
                  ElevatedButton.icon(
                    onPressed: onAdjustStockPressed,
                    icon: const Icon(Icons.edit_note_rounded, size: 18),
                    label: Text("Adjust".tr),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // --- CAPACITY PROGRESS BAR ---
            LinearProgressIndicator(
              value: (stockCard.currentStock / stockCard.maximumCapacity).clamp(0.0, 1.0),
              backgroundColor: colors.surfaceContainerHighest,
              color: isLowStock ? colors.error : colors.primary,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Min: ${stockCard.minimumThreshold}",
                  style: theme.textTheme.bodySmall?.copyWith(color: colors.outline),
                ),
                Text(
                  "Max: ${stockCard.maximumCapacity}",
                  style: theme.textTheme.bodySmall?.copyWith(color: colors.outline),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Text(
              "Recent Movements".tr,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // --- MOVEMENT HISTORY TILES ---
            ...stockCard.movementHistory.take(3).map((movement) {
              final isPositive = movement.quantityChange > 0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: isPositive
                          ? Colors.green.withAlpha(30)
                          : Colors.red.withAlpha(30),
                      child: Icon(
                        isPositive ? Icons.add : Icons.remove,
                        size: 16,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movement.referenceNumber,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${movement.performedBy} • ${_formatDate(movement.timestamp)}",
                            style: theme.textTheme.bodySmall?.copyWith(color: colors.outline),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "${isPositive ? '+' : ''}${movement.quantityChange}",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return "${dt.day}/${dt.month}/${dt.year}";
  }
}