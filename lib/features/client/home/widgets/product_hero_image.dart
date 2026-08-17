import 'package:flutter/material.dart';
import 'package:smartware/features/client/home/widgets/empty_product_image.dart';

class ProductHeroImage extends StatelessWidget {
  final String? imageUrl;

  const ProductHeroImage({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final hasImage =
        imageUrl != null && imageUrl!.trim().isNotEmpty;

    return SizedBox(
      height: 340,
      width: double.infinity,
      child: hasImage
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return const EmptyProductImage();
              },
            )
          : const EmptyProductImage(),
    );
  }
}
