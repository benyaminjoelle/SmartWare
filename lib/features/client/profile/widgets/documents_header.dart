import 'package:flutter/material.dart';

class DocumentsHeader extends StatelessWidget {
  const DocumentsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Documents',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w300,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Upload the required documents to verify your identity and ownership of the business property.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: cs.onSurfaceVariant.withValues(alpha: .7),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}