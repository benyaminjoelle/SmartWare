import 'package:flutter/material.dart';
import 'package:smartware/core/constants/const_ip.dart';

class ProductImage extends StatelessWidget {
  final String? imageUrl;

  const ProductImage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final fullImageUrl = imageUrl == null || imageUrl!.isEmpty
        ? null
        : 'http://${ConstIp().ip}:8000/storage/$imageUrl';

    print('🖼️ IMAGE URL: $fullImageUrl');

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 62,
        height: 62,
        child: fullImageUrl != null
            ? Image.network(
                fullImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print('❌ IMAGE ERROR: $error');
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