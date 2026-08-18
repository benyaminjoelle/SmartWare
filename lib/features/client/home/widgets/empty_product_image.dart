import 'package:flutter/material.dart';

class EmptyProductImage extends StatelessWidget {
  const EmptyProductImage();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      color: colors.surfaceContainerHighest.withOpacity(0.45),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 52,
          color: colors.onSurfaceVariant.withOpacity(0.45),
        ),
      ),
    );
  }
}