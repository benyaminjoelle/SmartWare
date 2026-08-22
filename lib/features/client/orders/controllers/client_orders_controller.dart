import 'package:get/get.dart';
import 'package:smartware/core/network/api_service.dart';

enum OrderTab {
  pending,
  accepted,
  previous,
}

class OrdersController extends GetxController {
  final ApiService apiService = ApiService();

  final selectedTab = OrderTab.pending.obs;

  final pendingOrders = <Map<String, dynamic>>[].obs;
  final acceptedOrders = <Map<String, dynamic>>[].obs;
  final previousOrders = <Map<String, dynamic>>[].obs;

  final isLoading = false.obs;
  final isCancelling = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPendingOrders();
  }

  void changeTab(OrderTab tab) {
    selectedTab.value = tab;

    switch (tab) {
      case OrderTab.pending:
        loadPendingOrders();
        break;
      case OrderTab.accepted:
        loadAcceptedOrders();
        break;
      case OrderTab.previous:
        loadPreviousOrders();
        break;
    }
  }

  Future<void> loadPendingOrders() async {
    await _loadOrders('/orders/pending', pendingOrders);
  }

  Future<void> loadAcceptedOrders() async {
    await _loadOrders('/orders/approved', acceptedOrders);
  }

  Future<void> loadPreviousOrders() async {
    await _loadOrders('/orders/delivered', previousOrders);
  }

  Future<void> _loadOrders(
    String endpoint,
    RxList<Map<String, dynamic>> target,
  ) async {
    try {
      isLoading.value = true;

      final response = await apiService.get(endpoint);

      if (response is Map && response['success'] == true) {
        final data = response['data'];

        if (data is List) {
          target.assignAll(
            data.map(
              (e) => Map<String, dynamic>.from(e),
            ),
          );
        }
      }
    } catch (e) {
      print('Failed to load orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> cancelOrder(int orderId) async {
    try {
      isCancelling.value = true;

      final response = await apiService.post(
        '/orders/$orderId/cancel',
        {},
      );

      if (response is Map && response['success'] == true) {
        pendingOrders.removeWhere(
          (order) => order['id'] == orderId,
        );

        return true;
      }

      Get.snackbar(
        'Error',
        response is Map
            ? response['message']?.toString() ?? 'Failed to cancel order'
            : 'Failed to cancel order',
      );

      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to cancel order',
      );
      return false;
    } finally {
      isCancelling.value = false;
    }
  }
  Future<void> refreshOrders() async {
  switch (selectedTab.value) {
    case OrderTab.pending:
      await loadPendingOrders();
      break;

    case OrderTab.accepted:
      await loadAcceptedOrders();
      break;

    case OrderTab.previous:
      await loadPreviousOrders();
      break;
  }
}

  List<Map<String, dynamic>> get currentOrders {
    switch (selectedTab.value) {
      case OrderTab.pending:
        return pendingOrders;
      case OrderTab.accepted:
        return acceptedOrders;
      case OrderTab.previous:
        return previousOrders;
    }
  }
}