import 'package:get/get.dart';
import 'package:smartware/features/client/cart/controllers/client_cart_controller.dart';
import 'package:smartware/features/product/models/product_model.dart';
import 'package:smartware/features/warehouse/controllers/warehouse_controller.dart';
import 'package:smartware/features/warehouse/models/warehouse_product_model.dart';
import 'package:smartware/widgets/app_snackbar.dart';

class ProductDetailsController extends GetxController {
  final Product product;

  ProductDetailsController({
    required this.product,
  });

  final WarehouseController warehouseController =
      Get.find<WarehouseController>();

  final CartController cartController =
      Get.find<CartController>();

  final quantity = 1.obs;

  final availableWarehouses =
      <WarehouseProductModel>[].obs;

  final Rxn<WarehouseProductModel> selectedWarehouse =
      Rxn<WarehouseProductModel>();

  final isCheckingAvailability = false.obs;
  final hasCheckedAvailability = false.obs;
  final isAddingToCart = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> checkWarehouseAvailability() async {
    try {
      isCheckingAvailability.value = true;

      await Future.delayed(
        const Duration(milliseconds: 300),
      );

      availableWarehouses.assignAll(
        warehouseController.getWarehousesForProduct(
          product.id,
        ).where(
          (warehouse) =>
              warehouse.quantity >= quantity.value,
        ),
      );

      hasCheckedAvailability.value = true;

      final selected = selectedWarehouse.value;

      if (selected != null &&
          selected.quantity < quantity.value) {
        selectedWarehouse.value = null;
      }
    } finally {
      isCheckingAvailability.value = false;
    }
  }
  double get selectedPrice {
    return selectedWarehouse.value?.discountedPrice ?? 0.0;
  }

  double get totalPrice {
    return selectedPrice * quantity.value;
  }

  void increaseQuantity() {
    quantity.value++;
    _resetWarehouseSelection();
  }

  void decreaseQuantity() {
    if (quantity.value <= 1) return;

    quantity.value--;
    _resetWarehouseSelection();
  }

  void setQuantity(int value) {
    if (value < 1) return;

    quantity.value = value;
    _resetWarehouseSelection();
  }

  void selectWarehouse(
    WarehouseProductModel warehouse,
  ) {
    if (warehouse.quantity < quantity.value) {
      return;
    }

    selectedWarehouse.value = warehouse;
  }

  Future<void> addToCart() async {
    final warehouse = selectedWarehouse.value;

    if (warehouse == null) {
      AppSnackbar.show(
        title: 'Warehouse Required',
        message: 'Please choose a warehouse first.',
        position: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (warehouse.quantity < quantity.value) {
      AppSnackbar.show(
        title: 'Not Enough Stock',
        message:
            'This warehouse does not have enough stock.',
        position: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      isAddingToCart.value = true;

      cartController.addToCart(
        product,
        quantity.value,
        warehouse.warehouseName,
        warehouse.warehouseId,
        warehouse.unitPrice,
        warehouse.discountPercentage,
      );

      AppSnackbar.show(
        title: 'Added to Cart',
        message:
            '${product.name} from ${warehouse.warehouseName} added to your cart.',
        position: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isAddingToCart.value = false;
    }
  }

 
  void _resetWarehouseSelection() {
    hasCheckedAvailability.value = false;
    selectedWarehouse.value = null;
    availableWarehouses.clear();
  }
}