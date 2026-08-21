import 'package:get/get.dart';
import 'package:smartware/core/network/api_service.dart';
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
//     if (!isProfileCompleted.value) {
//   Get.snackbar(
//     "Complete Your Profile",
//     "Please complete your profile setup before placing an order.",
//   );
//   return;
// }
   if (cartController.cartItems.isEmpty) {
    Get.snackbar(
      "Error",
      "Your cart is empty!",
    );
    return;
  }

  try {
    isLoading.value = true;

    final items = cartController.cartItems.values.map((item) {
      return {
        "product_id": item.product.id,
        "warehouse_id": item.warehouseId,
        "quantity": item.quantity,
      };
    }).toList();

    final body = {
      "items": items,
    };

    print("========== CREATE ORDER ==========");
    print(body);
    print("==================================");

    final response = await ApiService().post(
      '/orders',
      body,
    );

    print("========== ORDER RESPONSE ==========");
    print(response);
    print("====================================");

    if (response is Map && response['success'] == true) {
      cartController.clearCart();

      Get.offAllNamed('/order-success');
    } else {
      Get.snackbar(
        "Order Failed",
        response is Map
            ? response['message'] ?? 'Failed to create order.'
            : 'Failed to create order.',
      );
    }
  } catch (e) {
    print("❌ CREATE ORDER ERROR: $e");

    Get.snackbar(
      "Order Failed",
      e.toString(),
    );
  } finally {
    isLoading.value = false;
  }
}
}