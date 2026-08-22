import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/widgets/product_card.dart';
import 'package:smartware/features/product/models/product_model.dart';

class HorizontalProductRow extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllPressed;
  final RxList<Product> products;

  const HorizontalProductRow({
    super.key,
    required this.title,
    this.onSeeAllPressed,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context).size;

    return Obx(() {
      if (products.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header Row
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: media.width * 0.05,
              vertical: 4,
            ),
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
                    child: Text("See All".tr),
                  ),
              ],
            ),
          ),

          // Horizontal Product List Container
          SizedBox(
            height: 240,
            child: products.isEmpty
                ? Center(
                    child: Text("No items available".tr),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    padding: EdgeInsets.only(
                      left: media.width * 0.05,
                      right: media.width * 0.03,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final product = products[index];

                      return ProductCard(
                        product: product,
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }
}
