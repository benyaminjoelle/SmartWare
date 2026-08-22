import 'package:get/get.dart';
import 'package:smartware/core/network/api_service.dart';
import 'package:smartware/features/owner/orders/models/owner_order_model.dart';

enum OrderTab {
  pending,
  incoming,
  outgoing,
}

enum OrderStatus {
  pending,
  accepted,
  denied,
  preparing,
  ready,
  dispatched,
  delivered,
}

enum BatchStatus {
  planned,
  ready,
  dispatched,
  delivered,
}

class OwnerOrdersController extends GetxController {
  final ApiService apiService = ApiService();

  final isLoading = false.obs;
  final selectedTab = OrderTab.pending.obs;

  final pendingOrders = <OwnerOrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPendingOrders();
  }

  void changeTab(OrderTab tab) {
    selectedTab.value = tab;
  }

  Future<void> loadPendingOrders() async {
    try {
      isLoading.value = true;

      final response = await apiService.get('/orders/pending');

      if (response is Map && response['success'] == true) {
        final data = response['data'];

        if (data is List) {
          pendingOrders.assignAll(
            data.map(
              (order) => OwnerOrderModel.fromJson(
                Map<String, dynamic>.from(order),
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('Failed to load pending orders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshOrders() async {
    await loadPendingOrders();
  }
}