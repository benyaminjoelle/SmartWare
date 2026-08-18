import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:smartware/features/client/widgets/special_sales_product_card.dart';
import 'package:smartware/features/product/controllers/product_controller.dart';
import 'package:smartware/features/warehouse/models/warehouse_product_model.dart';

class SpecialSalesRow extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllPressed;
  final RxList<WarehouseProductModel> items;

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
    final productController = Get.find<ProductController>();

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
                final warehouseProduct = items[index];
                final product = productController.getProductById(
                  warehouseProduct.productId,
                );
                if (product == null) {
                  Center(child: Text("No items available".tr));
                  return const SizedBox.shrink();    
                }
                return SpecialSaleProductCard(
                  warehouseProduct: warehouseProduct,
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