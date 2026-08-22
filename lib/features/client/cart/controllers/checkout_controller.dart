import 'package:get/get.dart';
import 'package:smartware/core/network/api_service.dart';
import 'package:smartware/core/routes/app_routes.dart';
import 'package:smartware/core/utils/pref_helper.dart';
import 'package:smartware/features/client/cart/controllers/client_cart_controller.dart';
import 'package:smartware/features/client/cart/models/cart_item_model.dart';
import 'package:smartware/features/client/root/controller/root_controller.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class CheckoutController extends GetxController {
  final ApiService apiService = ApiService();

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
      await PrefHelper.isClientProfileCompleted();

  print('🔍 CLIENT PROFILE COMPLETED: ${isProfileCompleted.value}');
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

    final items = cartController.cartItems.values.map((item) {
      return {
        "product_id": item.product.id,
        "warehouse_id": item.warehouseId,
        "quantity": item.quantity,
      };
    }).toList();

  print('========== CART ITEMS SENT ==========');

for (final item in cartController.cartItems.values) {
  print(
    'Product: ${item.product.id} | '
    'Warehouse: ${item.warehouseId} | '
    'Qty: ${item.quantity}',
  );
}

print('Total cart items: ${cartController.cartItems.length}');
print('====================================');

    final response = await apiService.post(
      '/orders',
      {
        "items": items,
      },
    );
   

    print("========== ORDER RESPONSE ==========");

final responseData = Map<String, dynamic>.from(response);

final orders = responseData['data'];

print("Number of orders: ${orders is List ? orders.length : 'NOT A LIST'}");

if (orders is List) {
  for (final order in orders) {
    print(
      "ORDER ID: ${order['id']} | "
      "WAREHOUSE: ${order['src_facility_id']} | "
      "PRODUCTS: ${order['products']?.length}",
    );

    for (final product in order['products'] ?? []) {
      print(
        "  Product ${product['product_id']} "
        "Qty: ${product['quantity']}",
      );
    }
  }
}

print("====================================");

    if (response is Map && response['success'] == true) {
  await cartController.saveOrderHistory(
    Map<String, dynamic>.from(response),
  );

  cartController.clearCart();

Get.offAllNamed(AppRoutes.clientRoot);

final rootController = Get.find<RootController>();
rootController.openOrders();
  AppSnackbar.show(title: 'Sucess', message: 'Your order was submited sucessfully');
} else {
  Get.snackbar(
    "Order Failed",
    response is Map
        ? response['message']?.toString() ?? "Failed to place order"
        : "Failed to place order",
  );
}
  } catch (e) {
    Get.snackbar(
      "Order Failed",
      e.toString(),
    );
  } finally {
    isLoading.value = false;
  }
}
}