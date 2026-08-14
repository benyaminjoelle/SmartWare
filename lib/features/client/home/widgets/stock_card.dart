import 'package:flutter/material.dart';

class ClientWarehouseStockCard extends StatelessWidget {
  final String warehouseName;
  final String warehouseAddress;
  final int? stockQuantity;
  final double price;
  final double? discountPercentage;
  // final String? discountNote;
  final VoidCallback? onSelectWarehouse;

  const ClientWarehouseStockCard({
    super.key,
    required this.warehouseName,
    required this.warehouseAddress,
    this.stockQuantity,
    required this.price,
    this.discountPercentage,
    // this.discountNote,
    this.onSelectWarehouse,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final hasDiscount = discountPercentage != null && discountPercentage! > 0;
    final discountedPrice = hasDiscount
        ? price * (1 - (discountPercentage! / 100))
        : price;
    final isAvailable = stockQuantity != null && stockQuantity! > 0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.outlineVariant.withAlpha(80)),
      ),
      child: InkWell(
        onTap: isAvailable ? onSelectWarehouse : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- TOP ROW: Warehouse Name & Stock Status ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.storefront_rounded, color: colors.primary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            warehouseName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Availability Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isAvailable
                          ? colors.primaryContainer
                          : colors.errorContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isAvailable ? "$stockQuantity Available" : "Out of Stock",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isAvailable
                            ? colors.onPrimaryContainer
                            : colors.onErrorContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // --- ADDRESS ROW ---
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 16, color: colors.outline),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      warehouseAddress,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.outline,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const Divider(height: 20),

              // --- PRICE & DISCOUNT ROW ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasDiscount) ...[
                        Text(
                          "\$${price.toStringAsFixed(2)}",
                          style: theme.textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: colors.outline,
                          ),
                        ),
                      ],
                      Text(
                        "\$${discountedPrice.toStringAsFixed(2)}",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (hasDiscount)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha(25),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Text(
                        "-${discountPercentage!.toStringAsFixed(0)}% OFF",
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),

              // --- OPTIONAL DISCOUNT NOTE ---
              // if (hasDiscount != null && hasDiscount.isNotEmpty) ...[
              //   const SizedBox(height: 6),
              //   Text(
              //     discountNote!,
              //     style: theme.textTheme.bodySmall?.copyWith(
              //       color: colors.secondary,
              //       fontStyle: FontStyle.italic,
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }
}