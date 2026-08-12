import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartware/features/product/models/cart_item_model.dart';
import 'package:smartware/features/product/models/product_model.dart';

class CartController extends GetxController {
  //  O(1), cz sku is better thank looking for the whole object             
  final RxMap<String, CartItem> cartItems = <String, CartItem>{}.obs;
  static const String _cartKey = 'saved_cart_items';
  static const String _ordersKey = 'saved_orders';

  @override
  void onInit() {
    super.onInit();
    _loadCartFromStorage();
     cartItems.listen((_) => _saveCartToStorage());
  }

  // Getters
  double get rawSubtotal => cartItems.values.fold(
        0.0,
        (sum, item) => sum + (item.product.price * item.quantity),
      );

  // 2. Total amount saved across all discounted items
  double get totalSavings => cartItems.values.fold(
        0.0,
        (sum, item) => sum + (item.product.savingsPerUnit * item.quantity)
      );
  double get finalTotal => rawSubtotal - totalSavings;

  int get itemCount => cartItems.length;
  // int get totalQuantity => cartItems.values.fold(0, (sum, item) => sum + item.quantity);


  // ==================== ACTIONS =====================

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
      cartItems[product.sku] = CartItem(product: product, quantity: 1);
    }

    cartItems.refresh();
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
    cartItems.refresh();
  }

  void removeItem(String sku) {
    cartItems.remove(sku);
    cartItems.refresh();
  }
  Future<void> _saveCartToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Map<String, CartItem> -> JSON String
    final Map<String, dynamic> rawMap = cartItems.map(
      (key, value) => MapEntry(key, value.toJson()),
    );
    final String encodedString = jsonEncode(rawMap);

    await prefs.setString(_cartKey, encodedString);
  }

  Future<void> _loadCartFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedString = prefs.getString(_cartKey);

    if (encodedString != null && encodedString.isNotEmpty) {
      try {
        final Map<String, dynamic> decodedMap = jsonDecode(encodedString);
        final Map<String, CartItem> loadedCart = decodedMap.map(
          (key, value) => MapEntry(key, CartItem.fromJson(value)),
        );
        cartItems.assignAll(loadedCart);
      } catch (e) {
        print("Failed to load cart from storage: $e");
      }
    }
  }
  Future<void> saveOrderHistory(Map<String, dynamic> orderData) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Fetch existing saved orders list
    final String? existingOrdersJson = prefs.getString(_ordersKey);
    List<dynamic> ordersList = [];

    if (existingOrdersJson != null) {
      ordersList = jsonDecode(existingOrdersJson);
    }

    // Append new order
    ordersList.add(orderData);

    // Save updated list
    await prefs.setString(_ordersKey, jsonEncode(ordersList));
  }
  void clearCart() {
    cartItems.clear();
  }
}

  
