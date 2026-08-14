import 'package:flutter/material.dart';

class InventoryExcelUploadCard extends StatelessWidget {
  final String fileName;
  final VoidCallback onUpload;
  final VoidCallback onRemove;

  const InventoryExcelUploadCard({
    super.key,
    required this.fileName,
    required this.onUpload,
    required this.onRemove,
  });

  bool get hasFile => fileName.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasFile
              ? cs.primary.withValues(alpha: .35)
              : cs.primary.withValues(alpha: .15),
        ),
      ),
      child: Column(
        children: [
          // ===============================================================
          // FILE HEADER
          // ===============================================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: hasFile
                      ? cs.primary.withValues(alpha: .10)
                      : cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  hasFile
                      ? Icons.table_chart_rounded
                      : Icons.upload_file_outlined,
                  color: hasFile
                      ? cs.primary
                      : cs.onSurfaceVariant,
                  size: 25,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            hasFile
                                ? 'Product list selected'
                                : 'Product inventory',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        if (hasFile)
                          IconButton(
                            onPressed: onRemove,
                            tooltip: 'Remove file',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              Icons.close_rounded,
                              color: cs.error,
                              size: 20,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      hasFile
                          ? fileName
                          : 'Excel or CSV file (.xlsx, .xls, .csv)',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ===============================================================
          // EMPTY STATE
          // ===============================================================
          if (!hasFile)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onUpload,
                icon: const Icon(
                  Icons.upload_file_outlined,
                ),
                label: const Text(
                  'Choose Inventory File',
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  side: BorderSide(
                    color: cs.primary,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )

          // ===============================================================
          // SELECTED FILE STATE
          // ===============================================================
          else
            Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: cs.primary,
                  size: 20,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    'Inventory file ready to import',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                TextButton(
                  onPressed: onUpload,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Replace',
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}