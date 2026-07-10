import 'package:get/get.dart';

enum OrderTab {
  recent,
  previous,
  cancelled,
}

class OrdersController extends GetxController {
  final selectedTab = OrderTab.recent.obs;

  void changeTab(OrderTab tab) {
    selectedTab.value = tab;
  }

  // Temporary dummy data
  final recentOrders = [
    {
      "id": "#ORD-1201",
      "date": "15 Jun 2026",
      "items": 4,
      "price": "\$84.50",
      "status": "Processing",
    },
    {
      "id": "#ORD-1198",
      "date": "13 Jun 2026",
      "items": 2,
      "price": "\$42.00",
      "status": "Pending",
    },
  ];

  final previousOrders = [
    {
      "id": "#ORD-1155",
      "date": "28 May 2026",
      "items": 6,
      "price": "\$170.00",
      "status": "Delivered",
    },
    {
      "id": "#ORD-1130",
      "date": "20 May 2026",
      "items": 1,
      "price": "\$12.50",
      "status": "Delivered",
    },
  ];

  final cancelledOrders = [
    {
      "id": "#ORD-1110",
      "date": "14 May 2026",
      "items": 3,
      "price": "\$50.00",
      "status": "Cancelled",
    },
  ];

  List<Map<String, dynamic>> get currentOrders {
    switch (selectedTab.value) {
      case OrderTab.recent:
        return recentOrders;
      case OrderTab.previous:
        return previousOrders;
      case OrderTab.cancelled:
        return cancelledOrders;
    }
  }
}