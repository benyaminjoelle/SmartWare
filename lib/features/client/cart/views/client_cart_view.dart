import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/cart/controllers/client_cart_controller.dart';
import 'package:smartware/features/client/root/controller/root_controller.dart';
import 'package:smartware/features/product/models/cart_item_model.dart';
import 'package:smartware/features/product/widgets/build_cart_card.dart';
import 'package:smartware/widgets/primary_button.dart';

class ClientCartView extends StatelessWidget {
  const ClientCartView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
      ),
      body: Obx(() {
        // ================= EMPTY CART VIEW =================
        if (controller.cartItems.isEmpty) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Stylized Illustration Container
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      color: colors.primary.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/photos/empty_cart.png',
                        width: 150,
                        height: 150,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.shopping_bag_outlined,
                          size: 90,
                          color: colors.primary.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: media.size.height * 0.05),

                  // Header Title
                  Text(
                    'Your Cart is Empty',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Descriptive Subtitle
                  Text(
                    'Looks like you haven\'t added any items to your inventory cart yet.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurface.withOpacity(0.7),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Action Button
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.find<RootController>().changePage(0);
                    },
                    icon: const Icon(Icons.search_rounded),
                    label: const Text('Explore Products'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // ================= POPULATED CART VIEW =================
        final cartItemsList = controller.cartItems.values.toList();

        return Column(
          children: [
            // Scrollable Items List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                itemCount: cartItemsList.length,
                itemBuilder: (context, index) {
                  final CartItem item = cartItemsList[index];
                  return Dismissible(
                    key: Key(item.product.sku),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 28),
                          SizedBox(width: 8),
                          Text(
                            "Remove",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      return true;
                    },
                    onDismissed: (direction) {
                      controller.removeItem(item.product.sku);
                    },
                    child: CartCard(
                      cartItem: item,
                    ),
                  );
                },
              ),
            ),

            // Sticky Bottom Checkout Summary Bar
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Subtotal & Discount breakdown (Visible when savings exist)
                    if (controller.totalSavings > 0) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text("Subtotal:", style: TextStyle(color: colors.onSurface.withOpacity(0.75))),
                          Text(
                            "\$${controller.rawSubtotal.toStringAsFixed(2)}",
                            style:  TextStyle(
                              // decoration: TextDecoration.lineThrough,
                              color: colors.onSurface.withOpacity(0.75),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Discount Savings:",
                            style: TextStyle(color: colors.tertiary, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "-\$${controller.totalSavings.toStringAsFixed(2)}",
                            style:  TextStyle(
                              color: colors.tertiary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),
                    ],

                    // Final Total Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Estimated Total:",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "\$${controller.finalTotal.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Proceed Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: PrimaryButton(
                        onPressed: () => Get.toNamed('/checkout'),
                        isLoading: false,
                        text: 'Proceed to Checkout',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}