import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String? imageUrl;

  const ProductImage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage =
        imageUrl != null && imageUrl!.trim().isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 62,
        height: 62,
        child: hasImage
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return const _EmptyProductImage();
                },
              )
            : const _EmptyProductImage(),
      ),
    );
  }
}

class _EmptyProductImage extends StatelessWidget {
  const _EmptyProductImage();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      color: colors.surfaceContainerHighest.withOpacity(0.45),
      child: Icon(
        Icons.image_outlined,
        size: 27,
        color: colors.onSurfaceVariant.withOpacity(0.5),
      ),
    );
  }
}