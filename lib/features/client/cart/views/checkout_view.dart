import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/cart/controllers/checkout_controller.dart';
import 'package:smartware/features/client/cart/models/cart_item_model.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CheckoutController>();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        centerTitle: true,
      ),

      body: Obx(() {
        final invoices = controller.warehouseInvoices;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "Your Invoices",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 16),

              // ==================================================
              // ONE INVOICE PER WAREHOUSE
              // ==================================================

              ...invoices.entries.map((entry) {
                final items = entry.value;

                return _buildWarehouseInvoice(
                  context,
                  controller,
                  items,
                  colors,
                );
              }),

              const SizedBox(height: 20),

              // ==================================================
              // GRAND TOTAL
              // ==================================================

              const Divider(thickness: 1.5),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total to Pay",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    "\$${controller.grandTotal.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ==================================================
              // PLACE ORDER
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Confirm & Place Order",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ============================================================
  // WAREHOUSE INVOICE
  // ============================================================

  Widget _buildWarehouseInvoice(
    BuildContext context,
    CheckoutController controller,
    List<CartItem> items,
    ColorScheme colors,
  ) {
    final warehouseName = items.first.warehouseName;

    final subtotal =
        controller.warehouseSubtotal(items);

    final savings =
        controller.warehouseSavings(items);

    final finalTotal =
        controller.warehouseFinalTotal(items);

    final tax =
        controller.warehouseTax(items);

    final total =
        controller.warehouseGrandTotal(items);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outline.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Warehouse name
          Row(
            children: [
              Icon(
                Icons.warehouse_outlined,
                color: colors.primary,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  warehouseName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Products
          ...items.map(
            (item) {
              return Padding(
                padding:
                    const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [

                    Expanded(
                      child: Text(
                        "${item.quantity} × ${item.product.name}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    Text(
                      "\$${item.discountedTotal.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const Divider(),

          const SizedBox(height: 8),

          _buildPriceRow(
            "Subtotal",
            subtotal,
            colors,
          ),

          if (savings > 0) ...[
            const SizedBox(height: 6),

            _buildPriceRow(
              "Discount Savings",
              -savings,
              colors,
              isDiscount: true,
            ),
          ],

          const SizedBox(height: 6),

          _buildPriceRow(
            "Shipping",
            controller.shippingFee,
            colors,
          ),

          const SizedBox(height: 6),

          _buildPriceRow(
            "Tax (8%)",
            tax,
            colors,
          ),

          const SizedBox(height: 10),

          const Divider(),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Invoice Total",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              Text(
                "\$${total.toStringAsFixed(2)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount,
    ColorScheme colors, {
    bool isDiscount = false,
  }) {
    final prefix = amount < 0 ? "-\$" : "\$";
    final value = amount.abs();

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDiscount
                ? colors.tertiary
                : colors.onSurface.withOpacity(0.7),
            fontWeight: isDiscount
                ? FontWeight.w600
                : FontWeight.normal,
          ),
        ),

        Text(
          "$prefix${value.toStringAsFixed(2)}",
          style: TextStyle(
            color: isDiscount
                ? colors.tertiary
                : colors.onSurface,
            fontWeight: isDiscount
                ? FontWeight.bold
                : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}