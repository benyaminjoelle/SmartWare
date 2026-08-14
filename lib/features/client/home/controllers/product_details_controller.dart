import 'package:get/get.dart';
import 'package:smartware/features/client/cart/controllers/client_cart_controller.dart';
import 'package:smartware/features/product/models/product_model.dart';

class ProductDetailsController extends GetxController {
  late final Rx<Product> product;
  final controller = Get.find<CartController>();
  // Local screen state
  final quantity = 1.obs;
  final selectedImageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Safely retrieve the Product passed from Get.toNamed
    if (Get.arguments is Product) {
      product = (Get.arguments as Product).obs;
    } else {
      // Fallback or handle error if required
    }
  }

  void incrementQuantity() => quantity.value++;
  
  void decrementQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  void addToCart(Product product, int value) {
    Get.find<CartController>().addToCart(product, quantity.value);
  }
}