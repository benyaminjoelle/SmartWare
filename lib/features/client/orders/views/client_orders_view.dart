import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/core/routes/app_routes.dart';
import 'package:smartware/features/client/orders/controllers/client_orders_controller.dart';
import 'package:smartware/features/client/orders/widgets/client_order_details_sheet.dart';
import 'package:smartware/features/client/profile/widgets/glass_container.dart';

class ClientOrdersView extends StatelessWidget {
  ClientOrdersView({super.key});

  final OrdersController controller = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: const Text("My Orders"),
        centerTitle: true,
      ),
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
                      _tab("Pending", OrderTab.pending, controller, cs),
                      _tab("Accepted", OrderTab.accepted, controller, cs),
                      _tab("Previous", OrderTab.previous, controller, cs),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

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

                  return RefreshIndicator(
                    onRefresh: () async{
                      await controller.refreshOrders();
                    },
                    child: ListView.separated(
                      itemCount: orders.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      // itemCount: orders.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 14),
                      itemBuilder: (_, index) {
                        final order = orders[index];
                    
                        final products = order["products"] is List
                            ? order["products"] as List
                            : [];
                    
                        final quantity = products.fold<int>(
                          0,
                          (sum, item) =>
                              sum + ((item["quantity"] ?? 0) as int),
                        );
                    
                        final status =
                            order["status"]?.toString() ?? "pending";
                    
                        return GestureDetector(
                         onTap: () {
                          Get.bottomSheet(
                            ClientOrderDetailsSheet(
                              order: order,
                              controller: controller,
                            ),
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                          );
                        },
                          child: GlassContainer(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "#ORD-${order["id"]}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        order["order_date"]?.toString() ?? "",
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "$quantity items • "
                                        "\$${order["expected_price"]}",
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Warehouse #${order["src_facility_id"]}",
                                        style: TextStyle(
                                          color: cs.outline,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _statusColor(
                                          status,
                                          cs,
                                        ).withOpacity(.15),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        status == "pending"
                                            ? "Waiting Approval"
                                            : status.capitalizeFirst!,
                                        style: TextStyle(
                                          color:
                                              _statusColor(status, cs),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
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
                          ),
                        );
                      },
                    ),
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
      case "pending":
        return Colors.blue;
      case "approved":
        return cs.tertiary;
      case "delivered":
        return cs.tertiary;
      case "rejected":
      case "cancelled":
        return cs.error;
      default:
        return cs.primary;
    }
  }
}