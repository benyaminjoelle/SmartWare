import 'package:get/get.dart';
import 'package:smartware/core/utils/pref_helper.dart';
import 'package:smartware/features/client/cart/controllers/client_cart_controller.dart';
import 'package:smartware/features/client/cart/models/cart_item_model.dart';

class CheckoutController extends GetxController {
  final CartController cartController = Get.find<CartController>();

  final RxString selectedPaymentMethod = 'credit_card'.obs;
  final RxBool isLoading = false.obs;
  final RxBool isProfileCompleted = false.obs;


  final double shippingFee = 5.00;
  final double taxRate = 0.08;

  @override
  void onInit() {
    super.onInit();
    loadProfileStatus();
}

Future<void> loadProfileStatus() async {
  isProfileCompleted.value =
      await PrefHelper.getProfileCompleted();
}

  // ============================================================
  // WAREHOUSE INVOICES
  // ============================================================

  Map<int, List<CartItem>> get warehouseInvoices {
    return cartController.itemsByWarehouse;
  }

  double warehouseSubtotal(List<CartItem> items) {
    return items.fold(
      0.0,
      (sum, item) => sum + item.total,
    );
  }

  double warehouseSavings(List<CartItem> items) {
    return items.fold(
      0.0,
      (sum, item) => sum + item.savings,
    );
  }

  double warehouseFinalTotal(List<CartItem> items) {
    return items.fold(
      0.0,
      (sum, item) => sum + item.discountedTotal,
    );
  }

  double warehouseTax(List<CartItem> items) {
    return warehouseFinalTotal(items) * taxRate;
  }

  double warehouseGrandTotal(List<CartItem> items) {
    return warehouseFinalTotal(items) +
        shippingFee +
        warehouseTax(items);
  }

  // ============================================================
  // TOTAL OF ALL INVOICES
  // ============================================================

  double get grandTotal {
    return warehouseInvoices.values.fold(
      0.0,
      (sum, items) => sum + warehouseGrandTotal(items),
    );
  }

  // ============================================================
  // PLACE ORDER
  // ============================================================

  Future<void> placeOrder() async {
    if (!isProfileCompleted.value) {
  Get.snackbar(
    "Complete Your Profile",
    "Please complete your profile setup before placing an order.",
  );
  return;
}
    if (cartController.cartItems.isEmpty) {
      Get.snackbar(
        "Error",
        "Your cart is empty!",
      );
      return;
    }

    try {
      isLoading.value = true;

      // One invoice/order per warehouse
      final invoices = warehouseInvoices.entries.map((entry) {
        final warehouseId = entry.key;
        final items = entry.value;

        return {
          "warehouseId": warehouseId,

          "warehouseName": items.first.warehouseName,

          "items": items.map((item) {
            return {
              "productId": item.product.id,
              "sku": item.product.sku,
              "quantity": item.quantity,
              "unitPrice": item.unitPrice,
              "discountPercentage": item.discountPercentage,
              "discountedPrice":
                  item.discountedUnitPrice,
            };
          }).toList(),

          "subtotal": warehouseSubtotal(items),
          "discountSavings": warehouseSavings(items),
          "subtotalAfterDiscount": warehouseFinalTotal(items),
          "shippingFee": shippingFee,
          "tax": warehouseTax(items),
          "grandTotal": warehouseGrandTotal(items),
          "paymentMethod": selectedPaymentMethod.value,
        };
      }).toList();

      // For now, simulate API call
      await Future.delayed(
        const Duration(seconds: 2),
      );

      print("========== ORDERS ==========");
      print(invoices);
      print("============================");

      // Save all warehouse invoices
      await cartController.saveOrderHistory({
        "orders": invoices,
        "createdAt": DateTime.now().toIso8601String(),
      });

      cartController.clearCart();

      isLoading.value = false;

      Get.offAllNamed('/order-success');
    } catch (e) {
      isLoading.value = false;

      Get.snackbar(
        "Order Failed",
        e.toString(),
      );
    }
  }
}