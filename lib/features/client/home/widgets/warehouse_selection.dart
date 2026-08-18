import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:smartware/features/client/home/controllers/product_details_controller.dart';
import 'package:smartware/features/client/home/widgets/product_details_section_title.dart';
import 'package:smartware/features/client/home/widgets/warehouse_card.dart';

class WarehouseSelection extends StatelessWidget {
  final ProductDetailsController controller;

  const WarehouseSelection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Choose a warehouse',
          subtitle: 'Prices may vary depending on the warehouse',
        ),

        const SizedBox(height: 12),

        Obx(
          () {
            return Column(
              children: controller.availableWarehouses
                  .map(
                    (warehouse) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: WarehouseCard(
                        warehouse: warehouse,
                        isSelected:
                            controller.selectedWarehouse.value?.warehouseId ==
                                warehouse.warehouseId,
                        onTap: () {
                          controller.selectWarehouse(warehouse);
                        },
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}