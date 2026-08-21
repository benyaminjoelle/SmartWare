import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartware/features/client/widgets/special_sales_product_card.dart';
import 'package:smartware/features/product/models/product_model.dart';

class SpecialSalesRow extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllPressed;
  final RxList<Product> items;

  const SpecialSalesRow({
    super.key,
    required this.title,
    this.onSeeAllPressed,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context).size;

    return Obx(() {
      if (items.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: media.width * 0.05,
              vertical: 4,
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style:
                      theme.textTheme.titleMedium?.copyWith(
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
          SizedBox(
            height: 240,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              padding: EdgeInsets.only(
                left: media.width * 0.05,
                right: media.width * 0.03,
              ),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final product = items[index];

                return SpecialSaleProductCard(
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