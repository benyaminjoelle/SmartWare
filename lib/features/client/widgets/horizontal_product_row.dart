import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/widgets/product_card.dart';

class HorizontalProductRow extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllPressed;
  final int itemCount; // Switch this to List<ProductModel> products later!

  const HorizontalProductRow({
    super.key,
    required this.title,
    this.onSeeAllPressed,
    this.itemCount = 5, // Default item fallback
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: media.width * 0.05, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              if (onSeeAllPressed != null)
                TextButton(
                  onPressed: onSeeAllPressed,
                  child:  Text("See All".tr),
                ),
            ],
          ),
        ),

        // Horizontal Free-Flowing Product List Container
        SizedBox(
          height: 240, 
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: itemCount, 
            padding: EdgeInsets.only(left: media.width * 0.05, right: media.width * 0.03),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              // Once you have live controllers, pass data down: product: products[index]
              return const ProductCard(); 
            },
          ),
        ),
      ],
    );
  }
}