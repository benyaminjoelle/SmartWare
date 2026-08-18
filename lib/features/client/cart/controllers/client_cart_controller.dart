import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartware/features/client/cart/models/cart_item_model.dart';
import 'package:smartware/features/product/models/product_model.dart';

class CartController extends GetxController {
 
  final RxMap<String, CartItem> cartItems = <String, CartItem>{}.obs;
  static const String _cartKey = 'saved_cart_items';
  static const String _ordersKey = 'saved_orders';

  @override
  void onInit() {
    super.onInit();

    _loadCartFromStorage();
    cartItems.listen((_) => _saveCartToStorage());
  }

  double get rawSubtotal {
  return cartItems.values.fold(
    0.0,
    (sum, item) => sum + item.total,
  );
}

 double get totalSavings {
  return cartItems.values.fold(
    0.0,
    (sum, item) => sum + item.savings,
  );
}

 double get finalTotal {
  return cartItems.values.fold(
    0.0,
    (sum, item) => sum + item.discountedTotal,
  );
}

  int get itemCount => cartItems.length;

  Map<int, List<CartItem>> get itemsByWarehouse {
    final Map<int, List<CartItem>> grouped = {};

    for (final item in cartItems.values) {
      grouped.putIfAbsent(item.warehouseId, () => []);
      grouped[item.warehouseId]!.add(item);
    }

    return grouped;
  }

 void addToCart(
  Product product,
  int value,
  String warehouseName,
  int warehouseId,
  double unitPrice,
  double? discountPercentage,
) {
  if (value <= 0) return;

  final key = '${product.sku}|$warehouseId';

  if (cartItems.containsKey(key)) {
    final existing = cartItems[key]!;

    cartItems[key] = CartItem(
      product: existing.product,
      warehouseId: existing.warehouseId,
      warehouseName: existing.warehouseName,
      unitPrice: existing.unitPrice,
      discountPercentage: existing.discountPercentage,
      quantity: existing.quantity + value,
    );
  } else {
    cartItems[key] = CartItem(
      product: product,
      warehouseId: warehouseId,
      warehouseName: warehouseName,
      unitPrice: unitPrice,
      discountPercentage: discountPercentage,
      quantity: value,
    );
  }

  cartItems.refresh();
}
   void removeSingleItem(
    String sku,
    int warehouseId,
  ) {
    final key = '$sku|$warehouseId';

    if (!cartItems.containsKey(key)) return;

    final existing = cartItems[key]!;

    if (existing.quantity > 1) {
      cartItems[key] = CartItem(
        product: existing.product,
        warehouseId: existing.warehouseId,
        warehouseName: existing.warehouseName,
        unitPrice: existing.unitPrice,
        discountPercentage: existing.discountPercentage,
        quantity: existing.quantity - 1,
      );
    } else {
      cartItems.remove(key);
    }

    cartItems.refresh();
  }


  
  void removeItem(
    String sku,
    int warehouseId,
  ) {
    final key = '$sku|$warehouseId';

    cartItems.remove(key);
    cartItems.refresh();

    _saveCartToStorage();
  }

  void clearCart() {
    cartItems.clear();
  }

  Future<void> _saveCartToStorage() async {
    final prefs = await SharedPreferences.getInstance();

    final Map<String, dynamic> rawMap = cartItems.map(
      (key, value) => MapEntry(
        key,
        value.toJson(),
      ),
    );

    final String encodedString = jsonEncode(rawMap);

    await prefs.setString(_cartKey, encodedString);
  }

  Future<void> _loadCartFromStorage() async {
    final prefs = await SharedPreferences.getInstance();

    final String? encodedString = prefs.getString(_cartKey);

    if (encodedString != null && encodedString.isNotEmpty) {
      try {
        final Map<String, dynamic> decodedMap =
            Map<String, dynamic>.from(jsonDecode(encodedString));

        final Map<String, CartItem> loadedCart = decodedMap.map(
          (key, value) {
            final item = CartItem.fromJson(
              Map<String, dynamic>.from(value),
            );

            // Rebuild the correct key using SKU + warehouse.
            return MapEntry(
              '${item.product.sku}|${item.warehouseId}',
              item,
            );
          },
        );

        cartItems.assignAll(loadedCart);
      } catch (e) {
        print("Failed to load cart from storage: $e");
      }
    }
  }

  Future<void> saveOrderHistory(
    Map<String, dynamic> orderData,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final String? existingOrdersJson =
        prefs.getString(_ordersKey);

    List<dynamic> ordersList = [];

   if (existingOrdersJson != null &&
    existingOrdersJson.isNotEmpty) {
    ordersList = jsonDecode(existingOrdersJson);
  }

    ordersList.add(orderData);

    await prefs.setString(
      _ordersKey,
      jsonEncode(ordersList),
    );
  }
}