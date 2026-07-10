import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/features/client/orders/controllers/client_orders_controller.dart';
import 'package:smartware/features/client/profile/widgets/glass_container.dart';

class ClientOrdersView extends StatelessWidget {
  ClientOrdersView({super.key});

  final OrdersController controller = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("My Orders"), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Obx(
                () => GlassContainer(
                  padding: const EdgeInsets.all(6),
                  borderRadius: BorderRadius.circular(30),
                  child: Row(
                    children: [
                      _tab("Recent", OrderTab.recent, controller, cs),
                      _tab("Previous", OrderTab.previous, controller, cs),
                      _tab("Cancelled", OrderTab.cancelled, controller, cs),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Obx(() {
                  final orders = controller.currentOrders;

                  if (orders.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 70,
                            color: cs.outline,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "No orders found",
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: orders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (_, index) {
                      final order = orders[index];

                      return GlassContainer(
                        padding: const EdgeInsets.all(18),
                        borderRadius: BorderRadius.circular(22),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: cs.primary.withOpacity(.12),
                              ),
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                color: cs.primary,
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order["id"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(order["date"]),

                                  const SizedBox(height: 5),

                                  Text(
                                    "${order["items"]} items • ${order["price"]}",
                                  ),
                                ],
                              ),
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _statusColor(
                                      order["status"],
                                      cs,
                                    ).withOpacity(.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    order["status"],
                                    style: TextStyle(
                                      color: _statusColor(order["status"], cs),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tab(
    String text,
    OrderTab tab,
    OrdersController controller,
    ColorScheme cs,
  ) {
    final selected = controller.selectedTab.value == tab;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(tab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: selected ? cs.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: selected ? Colors.white : cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status, ColorScheme cs) {
    switch (status.toLowerCase()) {
      case "processing":
        return Colors.orange;

      case "pending":
        return Colors.blue;

      case "delivered":
        return Colors.green;

      case "cancelled":
        return Colors.red;

      default:
        return cs.primary;
    }
  }
}
