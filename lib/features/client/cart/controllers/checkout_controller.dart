import 'package:get/get.dart';
import 'package:smartware/features/client/cart/controllers/client_cart_controller.dart';

class CheckoutController extends GetxController {
  final CartController cartController = Get.find<CartController>();

  // Payment & Delivery State
  final RxString selectedPaymentMethod = 'credit_card'.obs;
  final RxBool isLoading = false.obs;

  // Additional Checkout Fees
  final double shippingFee = 5.00;
  final double taxRate = 0.08; // 8% Tax

  
  // 1. Items total after discount
  double get subtotalAfterDiscount => cartController.finalTotal;

  // 2. Tax calculated on the discounted subtotal
  double get estimatedTax => subtotalAfterDiscount * taxRate;

  // 3. Final payable amount across everything
  double get grandTotal => subtotalAfterDiscount + shippingFee + estimatedTax;

  // --- Submit Order Action ---
  Future<void> placeOrder() async {
    if (cartController.cartItems.isEmpty) {
      Get.snackbar("Error", "Your cart is empty!");
      return;
    }

    try {
      isLoading.value = true;

      // 1. Prepare Order Payload
      final orderData = {
        "items": cartController.cartItems.values.map((item) => {
          "productId": item.product.sku,
          "quantity": item.quantity,
          "unitPrice": item.product.price,
          "discountedPrice": item.product.discountedPrice,
        }).toList(),
        "rawSubtotal": cartController.rawSubtotal,
        "totalSavings": cartController.totalSavings,
        "shippingFee": shippingFee,
        "tax": estimatedTax,
        "grandTotal": grandTotal,
        "paymentMethod": selectedPaymentMethod.value,
      };

      // 2. Simulate API Call / Call your Order Repository
      await Future.delayed(const Duration(seconds: 2));

      // 3. Clear Cart & Navigate to Success Screen
      cartController.cartItems.clear();
      isLoading.value = false;

      Get.offAllNamed('/order-success'); // Prevent back navigation to checkout
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Order Failed", e.toString());
    }
  }
}