import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/home/controllers/product_details_controller.dart';
import 'package:smartware/features/client/home/widgets/stock_card.dart';
import 'package:smartware/features/warehouse/controllers/warehouse_controller.dart';
import 'package:smartware/features/warehouse/widgets/client_warehouse_product_card.dart';
import 'package:smartware/widgets/app_snackbar.dart';
import 'package:smartware/widgets/primary_button.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final wcontroller = Get.find<WarehouseController>();
    final warehouseProducts = wcontroller.warehouseProducts;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.product.value.name)),
      ),
      body: Obx(() {
        final product = controller.product.value;
        final warehouseProducts = wcontroller.warehouseProducts;
      
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: product.imageUrl.isNotEmpty
                        ? Image.network(product.imageUrl, fit: BoxFit.cover)
                        : Container(
                            color: colors.surfaceContainerHighest,
                            child: Icon(Icons.inventory_2_outlined, size: 64, color: colors.outline),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Product Name & Base Price
              Text(
                product.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "\$${product.price.toStringAsFixed(2)}",
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Quantity Selector
              Row(
                children: [
                  Text("Quantity:", style: theme.textTheme.titleMedium),
                  const Spacer(),
                  IconButton(
                    onPressed: controller.decrementQuantity,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Obx(() => Text(
                        '${controller.quantity.value}',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      )),
                  IconButton(
                    onPressed: controller.incrementQuantity,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),

              const Divider(thickness: 1, height: 32),

              // Available Warehouses Header
              Text(
                "Available Locations & Stock",
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              if (warehouseProducts.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    "No warehouse currently has stock for this item.",
                    style: theme.textTheme.bodyMedium?.copyWith(color: colors.outline),
                  ),
                )
              else
                ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: warehouseProducts.length,
                itemBuilder: (context, index) {
                  final warehouseProduct = warehouseProducts[index];

                  return ClientWarehouseProductCard(
                    warehouseProduct: warehouseProduct,
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PrimaryButton(
            onPressed: () {
              final product = controller.product.value;
              controller.addToCart(product, controller.quantity.value);
              AppSnackbar.show(
                title: 'Added to Cart',
                message: '${controller.quantity.value} x ${product.name} added to your cart.',
                duration: const Duration(seconds: 2),
                position: SnackPosition.TOP,
              );
            },
            text: 'Add to Cart',
          ),
        ),
      ),
    );
  }
}