import 'package:flutter/material.dart';

void showAboutStoreX(BuildContext context) {
  final theme = Theme.of(context);
  final cs = theme.colorScheme;

  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    backgroundColor: cs.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      ),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inventory_2_rounded,
              size: 42,
              color: cs.primary,
            ),

            const SizedBox(height: 14),

            Text(
              "StoreX",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "Version 1.0.0",
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              "StoreX helps businesses manage inventory and warehouse operations with a fast, secure and simple experience.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),

            const SizedBox(height: 28),

            FilledButton.icon(
              onPressed: () {
                // open website later
              },
              icon: const Icon(Icons.language_rounded),
              label: const Text("Visit Website"),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}