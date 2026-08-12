import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/cart/controllers/checkout_controller.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckoutController());
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Summary"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Purchased Items List Summary ---
            Text("Items Summary", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.cartController.cartItems.length,
              separatorBuilder: (_, __) => const Divider(height: 12),
              itemBuilder: (context, index) {
                final item = controller.cartController.cartItems.values.toList()[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${item.quantity}x  ${item.product.name}"),
                    Text(
                      "\$${(item.product.discountedPrice * item.quantity).toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),
            const Divider(thickness: 1.5),
            const SizedBox(height: 12),

            // --- 2. Final Invoice Financial Breakdown ---
            Text("Payment Details", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),

            // Original Price Subtotal
            _buildPriceRow(
              "Original Subtotal",
              "\$${controller.cartController.rawSubtotal.toStringAsFixed(2)}",
              colors,
            ),

            // Discount Savings Highlight (If applicable)
            if (controller.cartController.totalSavings > 0) ...[
              const SizedBox(height: 6),
              _buildPriceRow(
                "Discount Savings",
                "-\$${controller.cartController.totalSavings.toStringAsFixed(2)}",
                colors,
                isDiscount: true,
              ),
            ],

            const SizedBox(height: 6),
            _buildPriceRow(
              "Shipping Fee",
              "\$${controller.shippingFee.toStringAsFixed(2)}",
              colors,
            ),

            const SizedBox(height: 6),
            _buildPriceRow(
              "Estimated Tax (8%)",
              "\$${controller.estimatedTax.toStringAsFixed(2)}",
              colors,
            ),

            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),

            // Grand Payable Total Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Grand Total",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Obx(() => Text(
                      "\$${controller.grandTotal.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    )),
              ],
            ),

            const SizedBox(height: 32),

            // --- 3. Confirm & Pay Action Button ---
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.placeOrder(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Confirm & Place Order",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Clean Invoice Rows
  Widget _buildPriceRow(
    String label,
    String amount,
    ColorScheme colors, {
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDiscount ? colors.tertiary : colors.onSurface.withOpacity(0.7),
            fontWeight: isDiscount ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: isDiscount ? colors.tertiary : colors.onSurface,
            fontWeight: isDiscount ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}