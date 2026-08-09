import 'package:get/get.dart';
import 'package:smartware/features/product/models/cart_item_model.dart';
import 'package:smartware/features/product/models/product_model.dart';

class CartController extends GetxController {
  // i have put the map instead of the list to make it faster for searching
  var cartItems = <String, CartItem>{}.obs;


  // Total price of all items in cart
  double get totalAmount {
    return cartItems.values.fold(0.0, (sum, item) => sum + item.total);
  }

  int get itemCount => cartItems.length;

  int get totalQuantity {
    return cartItems.values.fold(0, (sum, item) => sum + item.quantity);
  }

  //==================== ACTIONS =====================
  //add product or increment quantity if it exists
  void addToCart(Product product) {
    if (cartItems.containsKey(product.sku)) {
      cartItems.update(
        product.sku,
        (existing) => CartItem(
          product: existing.product,
          quantity: existing.quantity + 1,
        ),
      );
    } else {
      cartItems.putIfAbsent(
        product.sku,
        () => CartItem(product: product, quantity: 1),
      );
    }
  }

  void removeSingleItem(String sku) {
    if (!cartItems.containsKey(sku)) return;

    if (cartItems[sku]!.quantity > 1) {
      cartItems.update(
        sku,
        (existing) => CartItem(
          product: existing.product,
          quantity: existing.quantity - 1,
        ),
      );
    } else {
      cartItems.remove(sku);
    }
  }

  // Remove item line completely regardless of quantity
  void removeItem(String sku) {
    cartItems.remove(sku);
  }

  // Clear all items from cart
  void clearCart() {
    cartItems.clear();
  }
}