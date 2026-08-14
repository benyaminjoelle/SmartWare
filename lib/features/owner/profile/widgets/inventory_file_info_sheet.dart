import 'package:flutter/material.dart';
import 'package:smartware/features/owner/profile/widgets/excel_import_step.dart';
import 'package:smartware/features/owner/profile/widgets/excel_info_items.dart';
class InventoryFileInfoSheet {
  static void show(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * .82,
          ),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                24,
                12,
                24,
                28,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _handle(cs),

                  const SizedBox(height: 24),

                  _header(theme, cs),

                  const SizedBox(height: 20),

                  Text(
                    'Instead of entering every product manually, '
                    'you can give SmartWare your existing inventory '
                    'file and let us do the initial setup for you.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      height: 1.55,
                    ),
                  ),

                  const SizedBox(height: 24),

                  const ExcelInfoItems(
                    icon: Icons.edit_off_outlined,
                    title: 'No manual data entry',
                    description:
                        'You do not have to enter every product, quantity, or stock record one by one.',
                  ),

                  const SizedBox(height: 16),

                  const ExcelInfoItems(
                    icon: Icons.speed_outlined,
                    title: 'Save hours of work',
                    description:
                        'Import hundreds or thousands of products at once instead of adding them individually.',
                  ),

                  const SizedBox(height: 16),

                  const ExcelInfoItems(
                    icon: Icons.inventory_2_outlined,
                    title: 'Start with your current stock',
                    description:
                        'Your existing products can be used to prepare your initial warehouse inventory.',
                  ),

                  const SizedBox(height: 16),

                  const ExcelInfoItems(
                    icon: Icons.visibility_outlined,
                    title: 'Know exactly what you have',
                    description:
                        'SmartWare can use the imported information to show your products and current stock.',
                  ),

                  const SizedBox(height: 24),

                  _importProcess(theme, cs),

                  const SizedBox(height: 24),

                  Text(
                    'Supported formats: .xlsx, .xls, .csv',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget _handle(ColorScheme cs) {
    return Center(
      child: Container(
        width: 42,
        height: 4,
        decoration: BoxDecoration(
          color: cs.onSurfaceVariant.withValues(alpha: .25),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  static Widget _header(
    ThemeData theme,
    ColorScheme cs,
  ) {
    return Row(
      children: [
       
        Expanded(
          child: Text(
            'Why do we need your inventory file?',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  static Widget _importProcess(
    ThemeData theme,
    ColorScheme cs,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.primary.withValues(alpha: .12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What happens after you upload it?',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 14),

          const ExcelImportStep(
            number: '1',
            text: 'Upload your existing inventory file.',
          ),

          const ExcelImportStep(
            number: '2',
            text: 'SmartWare reads the product information.',
          ),

          const ExcelImportStep(
            number: '3',
            text: 'Your initial inventory is prepared.',
          ),

          const ExcelImportStep(
            number: '4',
            text: 'Review your products and stock.',
          ),
        ],
      ),
    );
  }
}