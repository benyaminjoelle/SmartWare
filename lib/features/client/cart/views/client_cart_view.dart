import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smartware/features/client/cart/controllers/client_cart_controller.dart';

class ClientCartView extends StatelessWidget {
  const ClientCartView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: controller.cartItems.isEmpty
          ?  Column(
              children: [
                 
                 Text('Your cart is empty.'),
                 ]
            )
          : ListView.builder(
              itemCount: controller.cartItems.length,
              itemBuilder: (context, index) {
                final item = controller.cartItems[index];
                return ListTile(
                  title: Text(item.toString()),
                );
              },
            ),
    );
  }
}