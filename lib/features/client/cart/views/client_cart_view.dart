import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/core/constants/app_colors.dart';
import 'package:smartware/features/client/cart/controllers/client_cart_controller.dart';
import 'package:smartware/features/product/models/cart_item_model.dart';
import 'package:smartware/features/product/widgets/build_cart_card.dart';

class ClientCartView extends StatelessWidget {
  const ClientCartView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/photos/empty_cart.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    // color:,
                  ),
                ),
                // const SizedBox(height: 20),
                Text(
                  'Your cart is empty.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.8),
                                fontSize: 20,
                      ),
                ),
              ],
            ),
          );
        }

        final cartItemsList = controller.cartItems.values.toList();

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: cartItemsList.length,
                itemBuilder: (context, index) {
                  final CartItem item = cartItemsList[index];
                  return CartCard(
                    cartItem: item,
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}