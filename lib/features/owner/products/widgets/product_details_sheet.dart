import 'package:flutter/material.dart';

import 'package:smartware/features/owner/products/models/owner_inventory_model.dart';

class ProductDetailsSheet extends StatelessWidget {
  final OwnerInventoryModel inventory;

  const ProductDetailsSheet({
    super.key,
    required this.inventory,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final product = inventory.product;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============================================================
              // HANDLE
              // ============================================================

              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.onSurfaceVariant.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ============================================================
              // HEADER
              // ============================================================

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      _displayName(product),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // ============================================================
              // SKU
              // ============================================================

              if (product.sku.trim().isNotEmpty)
                Text(
                  product.sku,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),

              const SizedBox(height: 24),

              // ============================================================
              // STOCK CARD
              // ============================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: colors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.inventory_2_outlined,
                        color: colors.primary,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Stock',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            '${inventory.quantity} ${product.unit}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ============================================================
              // PRODUCT INFORMATION
              // ============================================================

              Text(
                'Product Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              _InfoRow(
                label: 'Product ID',
                value: product.id.toString(),
              ),

              _InfoRow(
                label: 'SKU',
                value: product.sku,
              ),

              _InfoRow(
                label: 'Unit',
                value: product.unit,
              ),

              _InfoRow(
                label: 'Inventory ID',
                value: inventory.id.toString(),
              ),

              _InfoRow(
                label: 'Section ID',
                value: inventory.sectionId.toString(),
              ),

              const SizedBox(height: 20),

              // ============================================================
              // PRICING
              // ============================================================

              Text(
                'Pricing',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              _InfoRow(
                label: 'Unit Price',
                value: inventory.unitPrice.toStringAsFixed(2),
              ),

              const SizedBox(height: 20),

              // ============================================================
              // DESCRIPTION
              // ============================================================

              if (_hasDescription(product)) ...[
                Text(
                  'Description',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  _description(product),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DISPLAY NAME
  // ============================================================

  String _displayName(OwnerProductModel product) {
    if (product.nameEn.trim().isNotEmpty) {
      return product.nameEn;
    }

    if (product.nameAr.trim().isNotEmpty) {
      return product.nameAr;
    }

    return 'Unnamed Product';
  }

  // ============================================================
  // DESCRIPTION CHECK
  // ============================================================

  bool _hasDescription(OwnerProductModel product) {
    return (product.descriptionEn ?? '').trim().isNotEmpty ||
        (product.descriptionAr ?? '').trim().isNotEmpty;
  }

  // ============================================================
  // DESCRIPTION
  // ============================================================

  String _description(OwnerProductModel product) {
    final english = (product.descriptionEn ?? '').trim();

    if (english.isNotEmpty) {
      return english;
    }

    return (product.descriptionAr ?? '').trim();
  }
}

// ============================================================================
// INFO ROW
// ============================================================================

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}